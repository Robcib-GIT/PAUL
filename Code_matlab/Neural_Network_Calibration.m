R = Robot;
R.Connect();
R.CalibrateCameras();
MAX_MILLIS = 1200;
N_ITER_MAX = 20000;

pos = zeros(N_ITER_MAX,3);
vol = zeros(N_ITER_MAX,3);

for i = 1:N_ITER_MAX
   
    millis = -50 + 50*randi((MAX + 50) / 50, [1 3]);
    R.WriteSegmentMillis(millis);
    pause(0.1)
    R.Measure();
    pause(0.05)

    vol_raw = R.getVoltages();
    pos_raw = R.CapturePosition();
    pos(i,:) = pos_raw(2,:);
    vol(i,:) = vol_raw';

end

        




