function data = ReadSerialData(serialDevice)
            % data = ReadSerialData() returns a Robot.nSensors x 1 array
            % containing the voltages read by Arduino.
            % 
            % The values of data are also stored in the last column of
            % this.voltages array

            data = readline(serialDevice);
            disp(data)
        end