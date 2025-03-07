function CSPraw2ProcessedNoDB(site,user,timezone,imtype)

if nargin < 2
    user = 'Anonymous';
    timezone = 'PST';
    imtype = 'snap';
end


%
%Function that renames the image data from the raw filename and stored in the Raw Image folder. Image data is renamed
%according to Argus file naming convention and then moved to the Processed
%Image folder. This version does not rely on the CoastSnap database and is
%intended for other camera systems (not CoastSnap)
%
%Created by Mitch Harley
%28/2/2020
%Edited by Julia Fiedler for extracting survey123 vs spotteron/other images
%%
%First, load paths
CSPloadPaths
warning('off')

%First find path of DB Excel file and read database
siteDB = CSPreadSiteDB(site); %Read metadata

%Read through images found in Raw file
imagedir = [image_path filesep site filesep 'Raw' filesep];
% imagedir = [image_path filesep site filesep 'Registered' filesep 'PINC' filesep '2023' filesep];
imagedir = [image_path filesep site filesep 'Temp' filesep];

images = dir([imagedir '*.jpg']);
%%
%Loop through images in Raw data directory
for i = 1:length(images)
    filename = images(i).name;
    disp(['Renaming image ' num2str(i) ' of ' num2str(length(images)) ' (' filename ')'])
    exif = [];
%     exif = imfinfo(fullfile(imagedir,filename));
    if isfield(exif,'DateTime')
        time = datenum(exif.DateTime,'yyyy:mm:dd HH:MM:SS');
    else
        if ~contains(filename,'arcgis') && ~contains(filename,'Holden')
            time = datenum(images(i).name(1:12),'yyyymmddHHMM'); %Default name from Spotteron Create Spot Package
            local_time_flag = 1;
        elseif contains(filename,'arcgis')
            time = datenum(filename(1:15),'yyyymmdd_HHMMSS');
            local_time_flag = 0;
            gmt_time = time;
        elseif contains(filename,'Holden')
            time = datenum(filename(1:15),'yyyymmdd_HHMMSS');
            local_time_flag = 1;
%             gmt_time = time;
        end
            %I = imread(fullfile(imagedir,filename));
        %h = figure;
        %image(I)
        %newtime = inputdlg('No image time found in image exif data. Please input a time (format dd/mm/yyyy HH:MM)','Image time',1,{'dd/mm/yyyy HH:MM'});
        %time = datenum(char(newtime),'dd/mm/yyyy HH:MM');
        %close(h)
        %time_ocr = ocr(I(1400:end,1380:end,:));
        %time = strrep(time_ocr.Text,' ',''); time = strrep(time,'O','0');
        %time = [time(1:10) ' ' time(11:18)];
        %time = datenum(time,'dd/mm/yyyy HH:MM');
    end
    
    %Get GMT Time if image is in local time
    if strcmp(timezone,siteDB.timezone.name) && local_time_flag==1
        gmt_time = time-siteDB.timezone.gmt_offset/24;
    elseif strcmp(timezone,siteDB.timezone.alternative.name) && local_time_flag==1
        gmt_time = time-siteDB.timezone.alternative.gmt_offset/24;
    end
    epochtime = matlab2Epoch(gmt_time);
    user = strrep(user,'_',''); user = strrep(user,'.',''); %Get rid of underscore or full stops if any exists
    newname = CSPargusFilename(epochtime,site,-1,lower(imtype),char(user),'jpg');
    year = datestr(gmt_time+siteDB.timezone.gmt_offset/24,'YYYY'); %Have subdirectory of years to not get too confusing
    newdir = fullfile(strrep(imagedir,'Raw','Processed'),year);

    newdir = fullfile(strrep(imagedir,'Registered','Processed'));
    newdir = fullfile(strrep(imagedir,'Temp','Processed'),year);

    movefile([imagedir images(i).name],[newdir filesep newname],'f');
end
disp('All raw files successfully moved to the processed folder')