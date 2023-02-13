clear;
gpsobj = GPS();
reference_latitude = 40.8623031194444;
reference_longitude = -77.8362636138889;
reference_altitude = 333.817;

referenceLLA = [reference_latitude,reference_longitude,reference_altitude];
pathInput = readmatrix('sample_path_ENU_data.csv');
% pathInput = pathInput(1,:);
ag1 = gpsobj.ENU2WGSLLA(pathInput,reference_latitude,reference_longitude,reference_altitude);
ag2 = fcn_GPS_enu2lla(pathInput,referenceLLA);
ag3 = enu2lla(pathInput,referenceLLA,'flat');
% ag1 = gpsobj.ENU2WGSXYZ(pathInput,reference_latitude,reference_longitude,reference_altitude)';
% ag2 = fcn_GPS_enu2xyz(pathInput,[reference_latitude,reference_longitude,reference_altitude]);
% wgs84 = wgs84Ellipsoid;
% [x,y,z] = enu2ecef(pathInput(:,1),pathInput(:,2),pathInput(:,3),reference_latitude,reference_longitude,reference_altitude,wgs84);
