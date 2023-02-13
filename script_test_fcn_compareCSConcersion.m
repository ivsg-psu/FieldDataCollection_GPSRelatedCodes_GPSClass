% This script is used to test the function fcn_compareCSConcersion.m;
% For more details, please see fcn_compareCSConcersion.m;
close all; clear;clc; 
reference_latitude = 40.8623031194444;
reference_longitude = -77.8362636138889;
reference_altitude = 333.817;
referenceLLA = [reference_latitude,reference_longitude,reference_altitude];
gpsObj = GPS();
%% Test case 1: LLA to XYZ
convertMode = 'lla2xyz';
pathInput = readmatrix('sample_path_LLA_data.csv');
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);

%% Test case 2: LLA to ENU
convertMode = 'lla2enu';
pathInput = readmatrix('sample_path_LLA_data.csv');
gpsObj = GPS();
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);

%% Test case 3: ENU TO XYZ
convertMode = 'enu2xyz';
pathInput = readmatrix('sample_path_ENU_data.csv');
gpsObj = GPS();
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);

%% Test case 4: ENU to LLA
convertMode = 'enu2lla';
pathInput = readmatrix('sample_path_ENU_data.csv');
gpsObj = GPS();
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);

%% Test case 5: XYZ to ENU
convertMode = 'xyz2enu';
pathInput = readmatrix('sample_path_XYZ_data.csv');
gpsObj = GPS();
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);

%% Test case 6: XYZ to LLA
convertMode = 'xyz2lla';
pathInput = readmatrix('sample_path_XYZ_data.csv');
gpsObj = GPS();
pathResult = fcn_compareCSConcersion(convertMode,pathInput,referenceLLA,gpsObj);


