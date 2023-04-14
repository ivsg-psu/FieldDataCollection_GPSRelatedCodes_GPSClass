function pathResult = fcn_compareCSConversion(convertMode,pathInput,referenceLLA,GPSObject)
% fcn_compareCSConversion.m 
% This function compares the coordinate system conversion algorithms:
% Algorithm 1: From GPS class
% Algorithm 2: From Standalone conversion code
% Algorithm 3: From MATLAB built-in code

% INPUTS:
% convertMode should be one of the following:
% enu2lla, enu2xyz, lla2enu, lla2xyz,xyz2enu,xyz2lla;
% Format: character. E.g: 'enu2lla'
% As specified by the convertMode, it does the conversion between the
% coordinate systems including: East-North-Up (ENU), Latitude-Longitude-Altitude (LLA), and Earth-Centered-Earth-Fixed (ECEF) systems.

% pathInput:  a path(s) as Nx3 vector defined in the input coordinate
% system

% Outputs:
% pathResult: a struct that contains the following fields:
% Ag1: conversion result from algorithm1
% Ag2: conversion result from algorithm2
% Ag3: conversion result from algorithm3
% Diff_Al12: the difference of the conversion between algorithm 1 and
% 2
% Diff_Al13: the difference of the conversion between algorithm 1 and
% 3

% Created by: Wushuang Bai
% Revision history:
% 2023 02 09: first write of the code.

gpsObj = GPSObject;
coe_lla2meter = 111111;
%% LLA TO XYZ 
if strcmp(convertMode,'lla2xyz')
resultAg1 = zeros(size(pathInput));
for ii = 1:height(pathInput)
temp = pathInput(ii,:);
resultAg1(ii,:) = gpsObj.WGSLLA2XYZ(temp(1),temp(2),temp(3))';
end
resultAg2 = fcn_GPS_lla2xyz(pathInput);
resultAg3 = lla2ecef(pathInput);
end
clear temp; 

%% LLA TO ENU
if strcmp(convertMode,'lla2enu')
resultAg1 = gpsObj.WGSLLA2ENU(pathInput(:,1),pathInput(:,2),pathInput(:,3),referenceLLA(1),referenceLLA(2),referenceLLA(3));
resultAg2 = fcn_GPS_lla2enu(pathInput,referenceLLA);
resultAg3 = lla2enu(pathInput,referenceLLA,'ellipsoid');
end

%% ENU TO XYZ
if strcmp(convertMode,'enu2xyz')
resultAg1 = gpsObj.ENU2WGSXYZ(pathInput,referenceLLA(1),referenceLLA(2),referenceLLA(3))';
resultAg2 = fcn_GPS_enu2xyz(pathInput,referenceLLA);
wgs84 = wgs84Ellipsoid('meter');
resultAg3 = zeros(size(pathInput));
for ii = 1:height(pathInput)
temp = pathInput(ii,:);
[resultAg3(ii,1),resultAg3(ii,2),resultAg3(ii,3)] = enu2ecef(temp(1),temp(2),temp(3),referenceLLA(1),referenceLLA(2),referenceLLA(3),wgs84);
clear temp;
end
end

%% ENU TO LLA
if strcmp(convertMode,'enu2lla')
resultAg1 = gpsObj.ENU2WGSLLA(pathInput,referenceLLA(1),referenceLLA(2),referenceLLA(3));
resultAg2 = fcn_GPS_enu2lla(pathInput,referenceLLA);
resultAg3 = enu2lla(pathInput,referenceLLA,'ellipsoid');
end



%% XYZ to ENU
if strcmp(convertMode,'xyz2enu')
resultAg1 = gpsObj.WGSXYZ2ENU(pathInput,referenceLLA(1),referenceLLA(2),referenceLLA(3))';
resultAg2 = fcn_GPS_xyz2enu(pathInput,referenceLLA);
wgs84 = wgs84Ellipsoid;
for ii = 1:height(pathInput)
temp = pathInput(ii,:);
[resultAg3(ii,1),resultAg3(ii,2),resultAg3(ii,3)] = ecef2enu(temp(1),temp(2),temp(3),referenceLLA(1),referenceLLA(2),referenceLLA(3),wgs84);
clear temp;
end
end

%% XYZ to LLA
if strcmp(convertMode,'xyz2lla')
resultAg1 = zeros(size(pathInput));
for ii = 1:height(pathInput)
temp = pathInput(ii,:);
resultAg1(ii,:) = gpsObj.WGSXYZ2LLA(temp)';
end
clear temp;
resultAg2 = fcn_GPS_xyz2lla(pathInput);
resultAg3 = ecef2lla(pathInput);
end


%% Put everything into an output struct

pathResult.Ag1 = resultAg1;
pathResult.Ag2 = resultAg2;
pathResult.Ag3 = resultAg3;
pathResult.diffAg13 = resultAg1 - resultAg3;
pathResult.diffAg23 = resultAg2 - resultAg3; 
pathResult.diffAg12 = resultAg1 - resultAg2;

%% Generate figures
%%%%%%%%%%%%%%%%% Difference between algorithm 1 and 3%%%%%%%%%%%%%%%%%%
figure();
histogram(pathResult.diffAg13);
ylabel('Frequency');
if strcmp(convertMode,'enu2lla') || strcmp(convertMode,'xyz2lla')
xlabel('Difference between GPS class and MATLAB built-in[deg]');
else
xlabel('Difference between GPS class and MATLAB built-in[m]');   
end
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between GPS class and MATLAB built-in'),'-dpng');

%%%%%%%%%%%%%%%%% Difference between algorithm 2 and 3%%%%%%%%%%%%%%%%%%
figure();
histogram(pathResult.diffAg23);
ylabel('Frequency');
if strcmp(convertMode,'enu2lla') || strcmp(convertMode,'xyz2lla')
xlabel('Difference between Standalone and MATLAB built-in[deg]');
else
    xlabel('Difference between Standalone and MATLAB built-in[m]');
end
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between Standalone and MATLAB built-in'),'-dpng');

%%%%%%%%%%%%%%%%% Difference between algorithm 1 and 2%%%%%%%%%%%%%%%%%%
figure();
histogram(pathResult.diffAg12);
ylabel('Frequency');
if strcmp(convertMode,'enu2lla') || strcmp(convertMode,'xyz2lla')
xlabel('Difference between GPS class and Standalone[deg]');
else
xlabel('Difference between GPS class and Standalone[m]');    
end
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between GPS class and Standalone'),'-dpng');

% Add three more plot: show the conversion error in equivalent meters, when the result is in LLA 
if strcmp(convertMode,'enu2lla') || strcmp(convertMode,'xyz2lla')
figure();
histogram(pathResult.diffAg13 * coe_lla2meter);
xlabel('Difference between GPS class and MATLAB built-in[m]');   
ylabel('Frequency');
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between GPS class and MATLAB built-in-In meters equivalent'),'-dpng');

figure();
histogram(pathResult.diffAg23 * coe_lla2meter);
xlabel('Difference between Standalone and MATLAB built-in[m]');
ylabel('Frequency');
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between Standalone and MATLAB built-in-In meters equivalent'),'-dpng');

figure();
histogram(pathResult.diffAg12 * coe_lla2meter);
xlabel('Difference between GPS class and Standalone[m]');   
ylabel('Frequency');
fcn_setFigureFormat;
print(gcf,strcat(convertMode,'-Difference between GPS class and Standalone-In meters equivalent'),'-dpng');


end







end