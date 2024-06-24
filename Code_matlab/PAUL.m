%% Class for PAUL control
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

classdef PAUL < handle

    properties (Access = public)
        serialDevice;                       % Serial port to which Arduino is connected
        realMode = 0;                       % 1 if working with the real PAUL
        deflatingTime = 1500;               % Default deflating time
        deflatingRatio = 2;                 % Relation between deflation and inflation time
        maxAction = 200;
        max_millis = 1000;
        nValves = 9;                        % Number of valves
        nSensors = 3;                       % Number of sensors
        nSegments = 3;                      % Number of segments
        nValvesPerSegment = 0;              % Number of valves per segment
        base = [0 0 0];                     % Position of the centre of the basis (in cameras'coordinates)
        bottom = [0 0 0];                   % Position of the centre of the bottom (in cameras'coordinates)
        origin = zeros(5,3);                % Initial positions and orientation of red, green and blue dots
        millisSentToValves;                 % Milliseconds of air each valve has received
        voltages;                           % Voltages read using the INAs
        positions;                          % Positions read using the cameras
        serialData = '';                    % Data received using the serial port
        matrix_tV;
        max_min;
        volts;
        tol = 20;
        net_pt;
        net_vt;
        net_tpv;                            % For simulation 

        % Geometric parameters
        geom;
        R = [1 0 0;0 0 1;0 -1 0];           % Rotation matrix (from camera to our axes)

        % Cameras
        cam_xz;
        cam_yz;
        img_xz;
        img_yz;
        dx = 0;
        dy = 0;
        dz = 0;
        z_offset = 0;
        calOK;
        OP_mode = 0;
        cam;                            % For auxiliar parameters

        % Position and lengths
        x = zeros(6,1);
        l = zeros(3,1);
    end

    events
        NewMeasure
    end

    methods
        %% Constructor and destructor
        function this = PAUL(nValves)
            % Class constructor
            %
            % PAUL(nValves) creates the object to handle a PAUL with
            % nValves valves.
            %
            % Default values:
            % nValves: 9

            switch nargin
                case 1
                    this.nValves = nValves;
            end
            
            % Adding aux functions to path
            addpath('./')
            addpath('./Src')

            this.millisSentToValves = zeros(1, this.nValves);
            this.voltages = zeros(this.nSensors, 1);
            this.positions = zeros(6, 1);
            this.nValvesPerSegment = floor(this.nValves / this.nSegments);

            % Geometric parameters
            this.geom.trihDistance = 77;                    % Distance (mm) from the centre of the green ball to the centre of the bottom of the PAUL
            this.geom.segmLength = 90;                      % Length of a segment
            this.geom.radius = 45;                          % Radius of the sensors' circle
            this.geom.height = 20;                          % Height of the connectors
            this.geom.phi0 = pi/2;
            this.geom.zoff_modo2 = 7;
            this.geom.xoff_modo2 = 69;

            % Camera representation
            this.MakeAxis();

            % Measure callback
            addlistener(this, 'NewMeasure', @(~,~) this.CallbackMeasurement);
            
        end

        function this = delete(this)
            % Class destructor
            %
            % PAUL.delete() destroys the object and deletes all its
            % properties.

            p = properties(this);

            for i = length(p)
                delete(p{i});
            end
        end

        function vol = getVoltages(this)
            vol = this.voltages(:,end);
        end

        %% Connection to Arduino
        function this = Connect(this, serial, freq)
            % Stablish connexion with the Arduino using the serial port
            % 
            % PAUL.Connect(serial, freq) connects to the serial port specified
            % in serial at frequency freq.
            %
            % Default values:
            % serial: 'COM3'
            % freq: 9600

            switch nargin
                case 2
                    freq = 9600;
                case 1
                    freq = 9600;
                    slist = serialportlist();
                    serial = slist(1);
            end
    
            this.serialDevice = serialport(serial, freq);
            configureTerminator(this.serialDevice,"CR/LF")
            configureCallback(this.serialDevice, "terminator", @(varargin)this.ReadSerialData)

            % Sending info of the PAUL
            writeline(this.serialDevice, "i" + this.realMode);

        end

        function this = Disconnect(this)
            % Erase connexion with the Arduino
            %
            % PAUL.Disconnect() clears the existent connection with the
            % Arduino and returns PAUL.serialDevice value to 0

            delete(this.serialDevice)
            disp("Connection has been removed")

        end

        function Rearme(this)
            writeline(this.serialDevice, 'R');
        end
        
        %% Camera callibration and capture
        function MakeAxis(this)
            % Creates a subplot with two axis, in where to show the images
            % captured by the camera, in case of the default ones have been
            % closed.
            %
            % PAUL.MakeAxis() creates the suplot in where the images of
            % the camera and the captured positions will be shown.
            
            figure;
            title('Images captured by the cameras')
            this.cam.UIAxes_yz = subplot(1,2,1);
            title(this.cam.UIAxes_yz,'CAM_YZ');
            this.cam.UIAxes_xz = subplot(1,2,2);
            title(this.cam.UIAxes_xz,'CAM_XZ');
        end

        function CalibrateCameras(this)
            % Calculates the extrinsic parameters of the cameras and loads
            % the intrinsic ones.
            %
            % PAUL.CallibrateCameras() returns in variable this.cam all
            % the necessary parameters to work with the cameras and two
            % figures displaying its possition relative to the chessboard

            % Select the cameras
            nCams = 0;
            for i = 1:length(webcamlist)
                if strcmp(webcam(i).Name, 'USB Live camera') && ~nCams
                    this.cam_xz = webcam(i);
                    nCams = 1;
                    continue
                end
                if strcmp(webcam(i).Name, 'USB Live camera') && nCams == 1
                    this.cam_yz = webcam(i);
                    break
                end
            end

            % New reference frame
            this.OP_mode = 0;
           
            % Extrinsic parameters
            tempX = load('camera_parameters.mat','cameraParams_yz');
            this.cam.cameraParams_yz = tempX.cameraParams_yz;
            tempX = load('camera_parameters.mat','cameraParams_xz');
            this.cam.cameraParams_xz = tempX.cameraParams_xz;
            [this.cam.rotyz, this.cam.transyz] = findCameraPose(this.cam_yz, this.cam.cameraParams_yz);
            [this.cam.rotxz, this.cam.transxz] = findCameraPose(this.cam_xz, this.cam.cameraParams_xz);
            disp('Snapshots have been taken')
            
            % Figure with cameras' position
            figure;
            this.cam.matyz = cameraMatrix(this.cam.cameraParams_yz, this.cam.rotyz, this.cam.transyz);
            this.cam.matxz = cameraMatrix(this.cam.cameraParams_xz, this.cam.rotxz, this.cam.transxz);   
            this.cam.BLamp.Color = "Green";
            hold off
        end

        function [pos_rel, pos_fixed, nattempts] = CapturePosition(this)
            % Capture pictures with the cameras and returns end tip
            % position.
            % 
            % The posiition of the centre of the bottom and the Euler
            % angles are also stored in the last column of this.positions array
            %
            % pos = PAUL.CapturePosition() Capture pictures with the
            % cameras and returns matrix pos, which contains, by rows
            % the position of the green, red and blue dots, the estimated
            % position of the centre of the bottom and the Euler angles,
            % expressed with respect to the centre of the PAUL base.
            % 
            % [pos2, pos] = PAUL.CapturePosition() also returns the
            % position expressed with respect to the cameras' reference
            % frame.

            if ~this.realMode
                nattempts = 0;
                a = [0 90 0];
                euler = [0 0 0];
                pos = this.net_tpv(this.millisSentToValves(1:this.nSensors)');
                pos_fixed = [pos(1:3)'; a; euler];
                pos_rel = [pos_fixed(1:2,:) - this.base; euler];
                return
            end
            
            nattempts = 0;
            pos = [-1 -1 -1];

            if ~isgraphics(this.cam.UIAxes_xz) || ~isgraphics(this.cam.UIAxes_yz)
                this.MakeAxis();
            end

            while find(pos == [-1 -1 -1])
                
                nattempts = nattempts + 1;

                % Take pictures with both cameras
                this.img_yz = snapshot(this.cam_yz);
                this.img_xz = snapshot(this.cam_xz);
                imshow(this.img_yz,'Parent',this.cam.UIAxes_yz);
                imshow(this.img_xz, 'Parent', this.cam.UIAxes_xz);
                
                % Searching for red, green and blue dots in the images
                yz_r = findPoint(this.img_yz, 'o',"yz");
                yz_g = findPoint(this.img_yz, 'g',"yz");
                yz_b = findPoint(this.img_yz, 'b',"yz");
                xz_r = findPoint(this.img_xz, 'o',"xz");
                xz_g = findPoint(this.img_xz, 'g',"xz");
                xz_b = findPoint(this.img_xz, 'b',"xz");
    
                % Plotting
                hold(this.cam.UIAxes_yz, 'on')
                hold(this.cam.UIAxes_xz, 'on')
                plot(yz_g(1) ,yz_g(2), 'o', 'Parent',this.cam.UIAxes_yz, 'Color','green');
                plot(xz_g(1), xz_g(2), 'o', 'Parent',this.cam.UIAxes_xz, 'Color','green')
                plot(yz_b(1), yz_b(2), 'o', 'Parent',this.cam.UIAxes_yz, 'Color','red');
                plot(xz_b(1), xz_b(2), 'o', 'Parent',this.cam.UIAxes_xz, 'Color','red')
                plot(yz_r(1), yz_r(2), 'o', 'Parent',this.cam.UIAxes_yz, 'Color','red');
                plot(xz_r(1), xz_r(2), 'o', 'Parent',this.cam.UIAxes_xz, 'Color','red')
                plot([yz_b(1) yz_g(1)], [yz_b(2) yz_g(2)], 'g', 'Parent',this.cam.UIAxes_yz);
                plot([yz_b(1) yz_r(1)], [yz_b(2) yz_r(2)], 'g', 'Parent',this.cam.UIAxes_yz);
                plot([yz_g(1) yz_r(1)], [yz_g(2) yz_r(2)], 'g', 'Parent',this.cam.UIAxes_yz);
                plot([xz_b(1) xz_g(1)], [xz_b(2) xz_g(2)], 'g', 'Parent',this.cam.UIAxes_xz);
                plot([xz_b(1) xz_r(1)], [xz_b(2) xz_r(2)], 'g', 'Parent',this.cam.UIAxes_xz);
                plot([xz_g(1) xz_r(1)], [xz_g(2) xz_r(2)], 'g', 'Parent',this.cam.UIAxes_xz);
                 
                this.cam.r = getCoordinates(yz_r,xz_r,this.cam.matyz, this.cam.matxz, this.dx, this.dy, this.dz, this.z_offset);
                this.cam.g = getCoordinates(yz_g,xz_g,this.cam.matyz, this.cam.matxz, this.dx, this.dy, this.dz, this.z_offset);
                this.cam.b = getCoordinates(yz_b,xz_b,this.cam.matyz, this.cam.matxz, this.dx, this.dy, this.dz, this.z_offset);
                
                hold on
    
                [this.cam.rot_m, this.cam.euler_m] = getRotations(this.cam.r, this.cam.g, this.cam.b);
                
                % From rotation matrix to quaternion
                quaternion = rotm2quat(this.cam.rot_m);
                disp(quaternion);
                hold(this.cam.UIAxes_yz, 'on');
                    
                % From rotation matrix to Euler angles
                euler = rotm2eul(this.cam.rot_m);
    
                hold(this.cam.UIAxes_yz, 'on');
                
                rv = [this.cam.r(1) - this.cam.g(1), this.cam.r(2) - this.cam.g(2), this.cam.r(3) - this.cam.g(3)];
                bv = [this.cam.b(1) - this.cam.g(1), this.cam.b(2) - this.cam.g(2), this.cam.b(3) - this.cam.g(3)];
                zv = cross(rv, bv);
                rv = rv / norm(rv);
                bv = bv / norm(bv);
                zv = zv / norm(zv);
    
                quiver3(this.cam.g(1), this.cam.g(2), this.cam.g(3), rv(1), rv(2), rv(3), 'Parent', this.cam.UIAxes_yz, 'Color', 'red');
                quiver3(this.cam.g(1), this.cam.g(2), this.cam.g(3), bv(1) , bv(2), bv(3), 'Parent', this.cam.UIAxes_yz, 'Color', 'blue');
                quiver3(this.cam.g(1), this.cam.g(2), this.cam.g(3), zv(1) , zv(2), zv(3), 'Parent', this.cam.UIAxes_yz, 'Color', 'green');
    
                valuestr = "Green: " + num2str(this.cam.g(1)) + ", " + num2str(this.cam.g(2)) + ", " + num2str(this.cam.g(3)) + newline + "red: " + num2str(this.cam.r(1)) + ", " + num2str(this.cam.r(2)) + ", " + num2str(this.cam.r(3)) + newline + "blue: " + num2str(this.cam.b(1)) + ", " + num2str(this.cam.b(2)) + ", " + num2str(this.cam.b(3)) + newline + "euler: " + num2str(rad2deg(euler(1))) + ", " + num2str(rad2deg(euler(2))) + ", " + num2str(rad2deg(euler(3)))+   newline +    " dy = " + num2str(this.dy) + "" +  " dx = " + num2str(this.dx);
                disp(valuestr);
    
                hold off
                hold off  

%                 pos = [this.cam.g; this.cam.r; this.cam.b];
                pos = this.cam.g;
            
                % Warning
                if nattempts > 10
                    disp("10 attempts of capture have been done and failed")
                    break
                end

            end

            % Coordinate system transformation 
            if (this.OP_mode == 0)
                this.bottom = pos(1,:) + [0 -this.geom.trihDistance 0];
                this.base = this.bottom + [0 -this.geom.segmLength 0];
                this.origin = [pos; this.bottom; euler];
                this.OP_mode = 2;
            elseif (this.OP_mode == 1)
                this.bottom = pos(1,:) + [0 -this.geom.zoff_modo2 -this.geom.xoff_modo2];
                this.base = this.bottom + [0 -this.geom.segmLength 0];
                this.origin = [pos; this.bottom; euler];
                this.OP_mode = 2;
            end

            %a = this.bottom + nanmean(removeOutliers(pos - this.origin(1:3,:)));
            a = this.bottom + (pos - this.origin(1,:));
            pos_fixed = [pos; a; euler];
            pos_rel = [pos_fixed(1:2,:) - this.base; euler];

            % Storing
            this.positions(:,end+1) = [pos_rel(2,:) euler]';

        end

        function Set_OP_mode(this,op)
            this.OP_mode = op;
        end
        
        %% Sending pressure to valves
        function Deflate(this)
            % PAUL.Deflate() deflates all the valves, sending negative
            % pressure during the time specified in this.deflatingTime,
            % which default value is 1000

            deflateMillis = "w,1";
            for i = 1:this.nValves
                deflateMillis = strcat(deflateMillis, ",-", int2str(this.deflatingTime * this.deflatingRatio));
            end
            writeline(this.serialDevice, deflateMillis);

            pause(this.deflatingTime / 500);        % Pause works with seconds. A pause of 2 times the deflating time is done
        end

        function WriteCycle(this, valv, millis)
            % PAUL.WriteCycle(valv, millis) inflates valve valv during the
            % number of milliseconds specified in millis and, after a pause
            % of 100ms, defaltes it

            this.WriteOneValveMillis(valv, millis);
            pause(millis/1000);
            this.WriteOneValveMillis(valv, -millis);

        end

        function WriteOneValveMillis(this, valv, millis)
            % PAUL.WriteOneValveMillis(valv, millis) sends to valve valv
            % air during the time specified in millis.
            %
            % The value of millis can  be possitive (inflating the valve)
            % or negative (deflating the valve). Negativa values are
            % multiplied by PAUL.deflatingRatio
            
            if this.realMode
                if millis > 0
                    writeline(this.serialDevice, "f," + int2str(valv) + "," + int2str(millis));
                else
                    writeline(this.serialDevice, "e," + int2str(valv) + "," + int2str(-millis * this.deflatingRatio));
                end
            end

            this.millisSentToValves(valv+1) = max(0, this.millisSentToValves(valv+1) + millis);
        end

        function WriteSegmentMillis(this, millis)
            for i = 0:2
                this.WriteOneValveMillis(i,millis(i+1));
            end
        end
        
        %% Reading valve state and sensors
        function millis = GetMillisSent(this)
            % millis = GetMillisSent() returns a 1 x PAUL.nValves array 
            % containing the volume of air sent to each valve.
            % 
            % The values stored in millis are the values sent by the user,
            % not the ones which have been really sent (they ARE NOT
            % multplied by PAUL.deflatingRatio).

            millis = this.millisSentToValves;

        end

        function millis = GetMillis(this)
            % millis = GetMillis() returns a 1 x PAUL.nValves array 
            % containing the volume of air sent to each valve.
            % 
            % The values stored in millis are the values read after
            % communicating with the Arduino (they ARE multplied by
            % PAUL.deflatingRatio).

            write(this.serialDevice, 'r', "char");
            millis = str2double(readline(this.serialDevice));
            
        end

        function Measure(this)
            % measurement = PAUL.Measure() returns a PAUL.nSensors x 1 array
            % containing the voltages read by Arduino.
            %
            % The values of data are also stored in the last column of
            % this.voltages array-
            % 
            % Measurement is done by time blocking. If no answer is given
            % after 500ms, process is aborted.
            
            % Sending measure order
            if this.realMode
                writeline(this.serialDevice, "M");
            else
                % Simulating real robot introducing 10% error
                error = 1 + .03*randn(1);
                measurement = this.net_tpv(this.millisSentToValves(1:this.nSensors)' * error);
                this.voltages(:,end+1) = measurement(4:6)';
            end
        end

        function CallbackMeasurement(this)
            % Callback associated to the mesure
            %
            % PAUL.CallbackMeasurement split the measures received 
            measurement = this.serialData;
            disp(measurement);
            measurement = split(measurement);
            measurement = str2double(measurement);
            measurement = measurement(2:1+this.nSensors);
            this.voltages(:,end+1) = measurement;
        end

        function ResetVoltagesPositions(this)
            % Reset the values of PAUL.voltages and PAUL.positions to
            % default (PAUL.voltages will be a nSensors x 1 array and
            % PAUL.positions, a 6 x 1 array)
          
            this.voltages = zeros(this.nSensors, 1);
            this.positions = zeros(6, 1);
        end

        function data = ReadSerialData(this)
            % Callback associated to the serial port specified in
            % PAUL.serialDevice
            % 
            % data = PAUL.ReadSerialData() returns a string containing the data
            % read by the serial port.

            data = readline(this.serialDevice);
            this.serialData = data;
            dataChar = char(data);

            switch dataChar(1)
                case 'M'
                    notify(this, 'NewMeasure');
            end
        end

        %% Sensor calibration
        function CalibrateSensor(this, nSensor)

            this.Measure
            for i = 1:100000000
            end
            this.max_min(3,1) = this.voltages(3,end);

            this.WriteOneValveMillis(nSensor, this.max_millis);
            pause(4)
            this.Measure
            for i = 1:100000000
            end
            this.max_min(nSensor + 1,2) = this.voltages(nSensor + 1,end);
            this.Deflate();

        end

        function Calibrate(this)

            for k = 0:2
                this.CalibrateSensor(k);
            end

        end

        %% Kinematic modelling
        function [l, params] = MCI(this, xP, phi0, a)
            % Calculate the inverse kinematic model of a three-wire PAUL 
            % using the PCC method.
            % 
            % l = PAUL.MCI() returns the lengths of the three wires of a
            % PAUL, knowing the position of its end (x) and the diameter
            % of the circumference they form (a). Orientation may or may
            % not be included in x.
            % 
            % [l, params] = PAUL.MCI() returns, in addition to the lengths
            % of the wires, a structure with the values of lr (average
            % length), phi (orientation) and kappa (curvature)
            % 
            % l = PAUL.MCI(phi0) allows to rotate, counter-clockwise, an
            % angle phi0 the PAUL reference system.
            
            % Initial setup
            switch nargin
                case 1 
                    xP = this.x(1:3);
                    phi0 = pi/2;
                    a = this.geom.phi0;
                
                case 2
                    phi0 = this.geom.phi0;
                    a = this.geom.radius;

                case 3
                    a = this.geom.radius;
                    
            end
               
            % Dependent modelling
            % General case
            if (sum(xP(1:2) - [0 0]))
                phi = atan2(xP(2),xP(1));
                kappa = 2 * norm(xP(1:2)) / norm(xP)^2;
                if xP(3) <= 0
                    theta = acos(1 - kappa * norm(xP(1:2)));
                else
                    theta = 2*pi - acos(1 - kappa * norm(xP(1:2)));
                end
                theta2 = wrapToPi(theta);
                lr = abs(theta2 / kappa);

            % Singular configuration
            else
                phi = 0;    % Every value is possible
                kappa = 0;
                lr = xP(3);            
            end
        
            params.lr = lr;
            params.phi = phi;
            params.kappa = kappa;
        
            % Independent modelling
            phi_i = phi0 + [pi pi/3 -pi/3];
            l = lr * (1 + kappa*a*sin(phi + phi_i));
            this.l = l;
        end
        
        function [T, params] = MCD(this, l, a)              
            % Calcula el modelo cinemático directo de un PAUL de tres cables
            % utilizando el método PCC.
            %
            % T = MCD(l, a) devuelve la matriz de transformación homogénea que permite
            % pasar de la base al extremo del PAUL, conocidas las longtiudes de sus
            % cables (l) y el diámetro de la circunferencia que forman (a).
            % 
            % [T, params] = MCD(l, a) devuelve, además de la matriz de transformación
            % homogénea, una estructura con los valores de lr (longitud media), phi
            % (orientación) y kappa (curvatura).
            
            % Comprobaciones iniciales
            if length(l) ~= 3
                error("Introduce un vector de tres longitudes")
            end

            if nargin == 2
                a = this.geom.radius;
            end
        
            % Modelado dependiente
            % Caso general
            if ~all(l == l(1))
                lr = mean(l);
                phi = atan2(sqrt(3) * (-2*l(1) + l(2) + l(3)), 3 * (l(2) - l(3)));
                kappa = 2 * sqrt(l(1)^2 + l(2)^2 + l(3)^2 - l(1)*l(2) - l(3)*l(2) - l(1)*l(3)) / a / (l(1) + l(2) + l(3));
            % Posición singular
            else
                lr = l(1);
                phi = 0;
                kappa = 0;
            end
        
            params.lr = lr;
            params.phi = phi;
            params.kappa = kappa;
        
            % Modelado independiente
            if ~all(l == l(1))
                Trot = [cos(phi) -sin(phi) 0 0; sin(phi) cos(phi) 0 0; 0 0 1 0; 0 0 0 1];
                Tarc = [cos(kappa*lr) 0 sin(kappa*lr) (1-cos(kappa*lr))/kappa; 0 1 0 0; -sin(kappa*lr) 0 cos(kappa*lr) sin(kappa*lr)/kappa; 0 0 0 1];
                T = Trot*Tarc;
            else
                T = [1 0 0 0; 0 1 0 0; 0 0 1 lr; 0 0 0 1];
            end
        
        end

        function [t, x, res] = GA(this, xd, options)
            % Calculate the IK of a n-module PAUL using genetic algorithms
            %
            % t = PAUL.GA(xd) returns the times needed to reach position xd.
            % This position can be a 1x3 array containing the desired
            % position of final tip of a Nx3 array (with N =
            % PAUL.nSegments) in which all the intermediate positions are
            % specified. If some intermediate position does not have to be
            % specified, at least one of the elements of the row should be
            % a NaN
            %
            % t = PAUL.GA(xd, options) allows to customise algorithm
            % options. Fields of options structure are:
            %   options.lb: lower limits for times generation
            %   options.ub: upper limits for times generation
            %   options t0: point around of it the generation wil be done
            %   options.Display: "diagnose" to show all the information of
            %   the process, "final" for just show final information,
            %   "none" for not showing anything.
            %   options.MaxGenerations: maximum number of generations
            %   options.FitnessLimit: maximum distance (measured in options.pNorm)
            %   between xd and the reached solution to exit the algorithm.
            %   options.PopulationSize: number of individuals
            %   options.pNorm: norm used for the fitness evaluation
            %   options.NParents: number of parents
            %   options.CrossoverFraction: crossover fraction (from 0 to 1)
            %   options.MutationFraction: mutation probability (from 0 to
            %   1)
            % 
            % [t, x, res] = PAUL.GA(xd) also returns the reached position
            % x, and a struct res, containing two elements:
            %   res.error: error (measured in norm 2), between x and xd,
            %   only considering final tip position
            %   res.conv: returns true if algorithm has converged (error
            %   less than options.FitnessLimit) and false otherwise
            %   res.it: number of iterations of the algorithm

            % Default options
            opt.nvars = this.nValves;
            opt.lb = zeros(1, opt.nvars);
            opt.ub = 900 * ones(1, opt.nvars);
            opt.t0 = zeros(1, opt.nvars);
            opt.Display = "none";
            opt.MaxGenerations = 20;
            opt.FitnessLimit = 1;
            opt.PopulationSize = 50;
            opt.pNorm = 2;
            opt.NParents = floor(opt.PopulationSize * 0.2);
            opt.CrossoverFraction = 1;
            opt.MutationFraction = 0.7;
            
            % Manage no options or if not all the options are defined
            switch nargin
                case 2
                    options = opt;
                case 3
                    fields = fieldnames(opt);
                    for f = 1:numel(fields)
                        if ~isfield(options, fields{f})
                            options.(fields{f}) = opt.(fields{f});
                        end
                    end
            end

            % Adjusting xd (if size is different, only the last joints are
            % going to be considered)
            x_aux = nan(this.nSegments, this.nValvesPerSegment);
            sz = size(xd, 1);
            x_aux(end-sz+1:end,:) = xd;
            xd = x_aux;

            % Auxiliary variables
            fitness = zeros(options.PopulationSize, 2);
            fitness(:,1) = 1:options.PopulationSize;

            % Running GA
            if options.Display == "diagnose"
            end
            
            % Generation
            if ~any(options.t0)
                individuals = this.GenerateUniform(options);
            else
                individuals = this.GenerateFromCurrent(options);
            end
            
            % Loop
            if options.Display == "diagnose"
                t1 = datetime('now');
                disp(['Iteration ' 'Time ' 'Best ' 'Average ' ])
            end
            for it = 1:options.MaxGenerations
                % Iteration count (for statistics)
                res.it = it;
            
                % Selection
                if it == 1
                    evStart = 1;
                else
                    evStart = options.NParents+1;
                end
            
                for ind = evStart:options.PopulationSize
                    fitness(ind,2) = this.GADistanceInterm(individuals(ind,:), xd, options.pNorm);
                end
                
                % Best individual
                M = min(fitness(:,2));
            
                if M < options.FitnessLimit
                    break
                end
            
                % For statistics
                a = mean(fitness(:,2));
                
                % Selection
                fitOrd = sortrows(fitness, 2, 'ascend');
                parents = fitOrd(1:options.NParents, 1);
                individuals(1:options.NParents,:) = individuals(parents,:);
            
                % To not evaluate parents again
                fitness(1:options.NParents,2) = fitOrd(1:options.NParents,2);
            
                % Crossover and mutation
                for ind = options.NParents:options.PopulationSize
            
                    % Selecting the parents
                    p1 = randi([1 options.NParents]);
                    p2 = p1;
                    while p2 == p1
                        p2 = randi([1 options.NParents]);
                    end
            
                    % Performing crossover
                    individuals(ind,:) = mean([individuals(p1,:); individuals(p2,:)]);
            
                    % Mutation
                    q = rand();
                    if q < options.MutationFraction 
                        individuals(ind,:) = individuals(ind,:) .* randBtw(0.9, 1.1, 1, options.nvars);
                    end
            
                    % Checking limits
                    individuals(ind,:) = max(individuals(ind,:), options.lb);
                    individuals(ind,:) = min(individuals(ind,:), options.ub);
                end
            
                % Statistics
                if options.Display == "diagnose"
                    t2 = datetime('now');
                    t = seconds(t2-t1);
                    disp([it t M a])
                    t1 = datetime('now');
                end
            end
            
            % Best solution
            best = find(fitness(:,2) == M, 1);
            t = individuals(best,:);
            [~, ~, x, ~] = this.Plot(reshape(t, this.nSegments, this.nValvesPerSegment), false);
            res.error = norm(x(end,:) - xd(end,:));
            if res.error < options.FitnessLimit
                res.conv = true;
            else
                res.conv = false;
            end

            if options.Display == "diagnose" || options.Display == "final"
                disp('Desired position:')
                disp(xd)
                disp('Reached position:')
                disp(x)
                disp('Error:')
                disp(res.error);
            end

        end

        % Genetic Algorithm  Generation function
        function individuals = GenerateUniform(~, options)
            individuals = zeros(options.PopulationSize, options.nvars);
            for ind = 1:size(individuals, 1)
                random_values = rand(1, options.nvars);
                individuals(ind,:) = options.lb + random_values .* (options.ub - options.lb);
            end
        end
        
        function individuals = GenerateFromCurrent(~, options)
            area = max(options.ub - options.lb);
            individuals = zeros(options.PopulationSize, options.nvars);
            ind = options.PopulationSize;
            discarded = 0;
            while ind 
                if discarded >= 2 * options.PopulationSize
                    individuals = GenerateUniform(options);
                    disp('Generation from current point not working. Switching to Uniform Generation')
                    return
                else
                    individuals(ind,:) = options.t0 + 0.3 * area * randn(1,options.nvars);
                    if sum(individuals(ind,:) > options.ub) || sum(individuals(ind,:) < options.lb)
                        discarded = discarded + 1;
                        continue
                    end
                    ind = ind - 1;
                end
            end
            disp(discarded);
        end

        % Genetic Algorithm Fitness function
        function dist = GADistanceInterm(this, times, xd, pNorm)
            alpha = 0.3;
            times = reshape(times, this.nSegments, this.nValvesPerSegment);
            [~, ~, c2, ~] = this.Plot(times, false);
            dif = c2 - xd;
            dif = rmmissing(dif);
            dif(1:end-1,:) = dif(1:end-1,:) * alpha;
            dist = norm(vecnorm(dif', pNorm));
        end

        %% Plotting

        function [c1, c2, o2] = PlotSegment(this, times_obj, pos, or, showFigure)
            % Plot one segment of PAUL and its bases, assuming the PCC model hypothesis
            % with base at pos and orientation or
            %
            % [c1, c2, o2] = PAUL.PlotSegment(a, times) plots a segment for robot r (PAUL type) and
            % bladders infated during times (in milliseconds). It returns the centres
            % of the circles of the base and the bottom and the orientation of the
            % bottom, in Euler angles
            % 
            % [c1, c2, o2] = PAUL.PlotSegment(a, times, pos, or) locates the base at position pos and
            % rotates it an orientation or
            %
            % [c1, c2, o2] = PAUL.PlotSegment(a, times, pos, or, false)
            % does not make any visible plot

            switch nargin
                case 5
                    if ~iscolumn(pos)
                        pos = pos';
                    end
                case 4
                    if ~iscolumn(pos)
                        pos = pos';
                    end
                    showFigure = true;
                case 3
                    showFigure = true;
                    or = [0 0 0];
                    if ~iscolumn(pos)
                        pos = pos';
                    end
                case 2
                    showFigure = true;
                    or = [0 0 0];
                    pos = [0 0 0]';
            end
        
            % Kinematics
            a = this.geom.radius;
            RotM = eul2rotm(or);
            Raux = [0 1 0; -1 0 0; 0 0 1];
        
            pos_obj = this.net_tpv(times_obj');
            [length, ~] = this.MCI(this.R * pos_obj(1:3));
            [T, params] = this.MCD(length, a);
        
            rho = 1 / params.kappa;
            theta = max(params.kappa * params.lr, pi/5000);
            %theta = params.kappa * params.lr;
        
            centre = [rho*cos(params.phi), rho*sin(params.phi), 0]';
            [~,c] = circle(centre, rho, theta, params.phi);
            c = Raux*RotM*c + pos;
                
            % Drawing
            if showFigure
                axis equal
                hold on
                grid on
                plot3(c(1,:), c(2,:), c(3,:), 'k');
            end
            
            % Base and final
            if showFigure
                s = 0:pi/50:2*pi;
                circ = a * [cos(s);sin(s);zeros(size(s))];
                circ = RotM*circ + pos;
                plot3(circ(1,:),circ(2,:),circ(3,:),'k')
            
                circ = c(:,end) - a * RotM * T(1:3,1:3) * [cos(s);sin(s);zeros(size(s))];
                plot3(circ(1,:),circ(2,:),circ(3,:),'k')
            
                hold off
            end
        
            % Centres of the bases
            c1 = c(:,1)';
            c2 = c(:,end)';
            o2 = rotm2eul(RotM*T(1:3,1:3));
        
        end

        function [p, c1, c2, o2] = Plot(this, times_obj, showFigure)
            % p = PAUL.Plot(times_obj, true) plots PAUL orientation and position
            % for each segment when inflating the bladders the milliseconds
            % specified in times_obj and returns the position of the final
            % tip (the centre of the bottom base)
            % Variable times_objs must contain a row per segment and in
            % each column of the row, the inflation team of the
            % corresponding bladder.
            % If the second variable takes the value false, no plot will be
            % displayed, only the calculations will be done.
            %
            % [p, c1, c2] = PAUL.Plot(times_obj, true) also returns the position
            % of each intermediate base (c1 for the bottom of the
            % connectors and c2 for the top)
            %
            % [p, c1, c2, o2] = PAUL.Plot(times_obj, true) also returns the
            % orientation of each intermediate base, in Euler angles.
            
            switch nargin
                case 2
                    showFigure = true;
                case 1
                    error('At least three times must be provided')
            end

            % Setup
            height = this.geom.height;
            pos = [0 0 0];
            o2 = zeros(size(times_obj, 1) + 1, 3);
            c1 = zeros(size(times_obj, 1), 3);
            c2 = zeros(size(c1));
            
            % Drawing each segment
            for seg = 1:size(times_obj, 1)
                [c1(seg,:), c2(seg,:), o2(seg+1,:)] =  this.PlotSegment(times_obj(seg,:), pos, o2(seg,:), showFigure);
                pos = c2(seg,:) + height * (c2(seg,:) - c1(seg,:) )/ norm(c2(seg,:) - c1(seg,:));
            end

            % Returning values
            p = c2(end,:);
        
            % Plot settings
            if showFigure
                xlabel('x (mm)')
                ylabel('y (mm)')
                zlabel('z (mm)')
                grid on
                view(145, 9);

            end
        
        end

        function p = GetCompletePosition(this, times)
            % p = PAUL.GetCompletePosition(times) returns position of the
            % bottom of each segment of the robot (what in PAUL.Plot is
            % called c2) when inflating times
            
            % If times are given in a vector
            if length(times) == this.nValves
                times = reshape(times, this.nValves/3, 3)';
            end
            [~, ~, c2, ~]  = this.Plot(times, false);
            p = reshape(c2', 1, 9);
        end

        %% Neural Network
        function [perform_pt, perform_vt, perform_st] = NN_training(this, pos, volt, tiempo, capas_pt, capas_vt, capas_st)
            % [perform_pt, perform_vt, perform_st] = PAUL.NN_training(pos, volt,
            % tiempo, capas_pt, capas_vt, capas_st) trains and creates the three
            % required neural networks for the control system of PAUL
            %
            % If Paul.realMode == 0, no training is done for the simulation
            % network (perform_st = -1 is returned)

            if nargin == 6
                capas_st = max(capas_pt, capas_vt);
            end
        
            n = fix(0.95*length(pos));
        
            this.net_pt = feedforwardnet(capas_pt);
            this.net_pt = train(this.net_pt,pos(1:n,:)',tiempo(1:n,:)');
        
            out_pt = this.net_pt(pos(n+1:end,:)');
            perform_pt = perform(this.net_pt,tiempo(n+1:end,:)',out_pt);
        
            this.net_vt = feedforwardnet(capas_vt);
            this.net_vt = train(this.net_vt,volt(1:n,:)',tiempo(1:n,:)');
        
            out_vt = this.net_vt(volt(n+1:end,:)');
            perform_vt = perform(this.net_vt,tiempo(n+1:end,:)',out_vt);

            if this.realMode
                perform_st = -1;
            else
                pv = [pos volt];
                this.net_tpv = feedforwardnet(capas_st);
                this.net_tpv = train(this.net_tpv,tiempo(1:n,:)',pv(1:n,:)');
            
                out_st = this.net_tpv(tiempo(n+1:end,:)');
                perform_st = perform(this.net_tpv,pv(n+1:end,:)',out_st);
            end
        end
        
        function NN_creation(this, network_pt, network_vt, network_tpv)
            % PAUL.NN_creation(network_pt, network_vt, network_tpv) creates and
            % storages the already created neural networks
            
            if nargin == 3
                this.net_tpv = [];
            else
                this.net_tpv = network_tpv;
            end
            this.net_pt = network_pt;
            this.net_vt = network_vt;
        end


        %% Control of a single segment
        function [pos_final, error_pos, pos_inter, millis_inter] = Move(this, x, DEBUG)
            % [pos_final, error_pos] = PAUL.Move(x) moves the PAUL to an
            % specified point (x) in the workspace of PAUL.
            %
            % [pos_final, error_pos, pos_inter, millis_inter] = PAUL.Move(x, true) allows
            % keeping a register of all the intermediate positions and
            % inflation times.

            if nargin == 2
                DEBUG = false;
            end
            
            niter = 0;
            t1 = datetime('now');
            action = zeros(1,3);
            itMax = 10;
            pos_inter = zeros(itMax,3);
            millis_inter = zeros(itMax,this.nValves);
            err = [900 900 900]';
            err_prev = err;
            max_accion = 300;
            toler = 40;

            % PID Parameteres
            Kp = 1;
            Kd = 0;
            Ki = 0;

            if length(x) ~= 3
                errordlg("Introduce un punto en el espacio (vector fila de 3 componentes)","Execution Error");
                return
            end

            t_obj = this.net_pt(x');

            while (abs(err(1)) > toler || abs(err(2)) > toler || abs(err(3)) > toler) && niter < itMax
                
                t2 = datetime('now');
                dt = seconds(t2 - t1);
                t1 = t2;
                niter = niter + 1;

                if DEBUG
                    if this.realMode
                        pos_raw = this.CapturePosition;
                        pos_inter(niter,:) = pos_raw(2,:);
                    else
                        pos_final_raw = this.net_tpv(this.millisSentToValves(1:this.nSensors)');
                        pos_inter(niter,:) = pos_final_raw(1:3)';
                    end
                end

                this.Measure();
                if this.realMode
                    pause(0.1)
                end
                vol_current = this.getVoltages();

                t_current = this.net_vt(vol_current);
                err = t_obj - t_current;
                act_p = err;
                act_d = (err - err_prev) / dt;
                act_i = (err + err_prev) * dt / 2;
                act = Kp * act_p + Kd * act_d + Ki * act_i;
                err_prev = err;
                if this.realMode
                    pause(0.1)
                end

                for i = 1:3
                    if err(i) > 0 
                        action(i) = min(act(i), max_accion);
                    else
                        action(i) = max(act(i), -max_accion);
                    end
                end
            
                this.WriteSegmentMillis(action);
                if this.realMode
                    pause(0.5)
                end
                if DEBUG
                    millis_inter(niter,1:length(action)) = action;
                end

            end

            if this.realMode
                pos_final_raw = this.CapturePosition;
                pos_final = pos_final_raw(2,:);
            else
                pos_final_raw = this.net_tpv(this.millisSentToValves(1:this.nSensors)');
                pos_final = pos_final_raw(1:3)';
            end
            error_pos = norm(pos_final - x);

            if DEBUG
                pos_inter(niter+1,:) = pos_final;
            end

        end

        function [pos_final, error_pos, pos_inter] = Move_debug(~, x)
            [pos_final, error_pos, pos_inter] = Move(x, true);
        end

    end
end