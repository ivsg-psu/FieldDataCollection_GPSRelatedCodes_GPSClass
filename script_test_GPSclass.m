% script_test_GPSclass.m
% This is a script to exercise the class: GPS.m
% This function was written on 2021_12_12 by S. Brennan, sbrennan@psu.edu

% Revision history:
%     2021_12_12
%     -- first write of the code

% Clear any old paths
path_dirs = regexp(path,'[;]','split');
clear_dir = pwd;
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},clear_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Update the path
path(path,genpath(fullfile(pwd,filesep,'Functions')));

close all;

%% Load test track LLA data
LLA_data = 1.0e+02 *[       
   0.408639848000000  -0.778373327000000   3.338170000000000
   0.408637407000000  -0.778373880000000   3.338170000000000
   0.408635103000000  -0.778373987000000   3.338170000000000
   0.408632458000000  -0.778373515000000   3.338170000000000
   0.408629715000000  -0.778372399000000   3.338170000000000
   0.408627762000000  -0.778370981000000   3.338170000000000
   0.408625936000000  -0.778369189000000   3.338170000000000
   0.408624133000000  -0.778366770000000   3.338170000000000
   0.408622869000000  -0.778364333000000   3.338170000000000
   0.408621837000000  -0.778361424000000   3.338170000000000
   0.408620877000000  -0.778356460000000   3.338170000000000
   0.408620918000000  -0.778352775000000   3.338170000000000
   0.408621584000000  -0.778348565000000   3.338170000000000
   0.408623080000000  -0.778344470000000   3.338170000000000
   0.408643601000000  -0.778309086000000   3.338170000000000
   0.408645474000000  -0.778306965000000   3.338170000000000
   0.408647630000000  -0.778305377000000   3.338170000000000
   0.408650686000000  -0.778304746000000   3.338170000000000
   0.408653463000000  -0.778305793000000   3.338170000000000
   0.408656319000000  -0.778308192000000   3.338170000000000
   0.408658095000000  -0.778311969000000   3.338170000000000
   0.408658577000000  -0.778314367000000   3.338170000000000
   0.408658577000000  -0.778318450000000   3.338170000000000
   0.408649030000000  -0.778361734000000   3.338170000000000
   0.408647703000000  -0.778365108000000   3.338170000000000
   0.408645847000000  -0.778367995000000   3.338170000000000
   0.408643185000000  -0.778371321000000   3.338170000000000];

%% Plot the result
figure(11111);
clf;

% Plot the results onto a map, preferrably satellite view but OSM if not
geoplot(LLA_data(:,1), LLA_data(:,2), '.-','Linewidth',3,'Markersize',40)
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

%% BASIC example 1 - converting LLA to ENU
gps_object = GPS(); % Initiate the class object for GPS

% Use the class to convert LLA to ENU
ENU_data = gps_object.WGSLLA2ENU(LLA_data(:,1), LLA_data(:,2), LLA_data(:,3));

%% Plot the ENU results
figure(22222);
clf;
plot(ENU_data(:,1),ENU_data(:,2),'-','Linewidth',3);

%% Convert back to LLA
LLA_data_convertedBack  =  gps_object.ENU2WGSLLA(ENU_data);

%% Make sure we get what we started with
max_errors = max(LLA_data-LLA_data_convertedBack);

assert(max_errors(1)<1E-12);  % Latitude errror (in degrees)
assert(max_errors(2)<1E-12);  % Longitude errror (in degrees)
assert(max_errors(3)<1E-6);   % Height errror (in meters)




