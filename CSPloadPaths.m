%This file contains all the necessary path information for your local
%CoastSnap database. It is called in almost all files in the CoastSnap
%Toolbox
%
%Mitch Harley, June 2018

%Load various paths
if ispc
    base_path = '\\reefbreak1.ucsd.edu\group\CoastSnap';
else
    base_path = fileparts(fileparts(pwd));
    base_path = fullfile('/Volumes','group','CoastSnap');
end

% base_path = '\\reefbreak1.ucsd.edu\group\CoastSnap\CoastSnap\Code\';
%base_path = 'D:\Google Drive\CoastSnap';


DB_path = fullfile(base_path,'Database'); %Path where database is located
image_path = fullfile(base_path,'Images'); %Path where all images are stored
shoreline_path = fullfile(base_path,'Shorelines'); %Path where shorelines are stored
tide_path = fullfile(base_path,'Tide Data'); %Path where tide data are stored
transect_dir = fullfile(base_path,'Shorelines','Transect Files'); %Path where transects are stored for shoreline mapping