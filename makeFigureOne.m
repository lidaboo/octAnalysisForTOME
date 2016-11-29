% #############################################################
% Script to reporduce Figure 1 from Turpin/Mckendrick 2015.
% 
% The goal is to produce a plot of the cumulative retinal
% ganglion cell and receptive field counts as a function of
% eccentricity (mm). 
% 
% Everthing should be in units of mm, mm^2, or cell count
% Conversion between units found at the end of Watson 2014
% and fit from Drasdo 1974.
% 
% MAB 2016
%
% Notes:
% Curcio and Allen 1990 refernce frames is the retinal feild
%       Data loaded from .xml from referes to the retina.
%       No extra steps neded to reference the data.
% Drasdo 2007 refernce frames is the visual feild 
%       Indexing the output of densityRF():
%       ex. RFdensity = densityRf(radDeg,smpPerDeg,'OFF');
%            midPoint = center pixel of output image
%            Temporal retina = right of midPoint
%            Nasal Retina    = left of midPoint
%            Supior Retina   = above midPoint
%            Inferior Retina = below midPoint
% Turpin McKendrick 2015 reference frame is the visual field
%
% Watson 2014 reference frame is the visual field
%
% THIS CODE SETS THE REFERENCE FRAME TO ME THE RETINAL FIELD
%
% #############################################################

%% Load the RGC Density Data from Curcio and Allen 1990:
load('curcio_4meridian.mat') % Load the data 
ecc_mm  = data(:,1); % Assign the eccentrciy (mm) to a var
temp_mm = data(:,2); % Assign the temporal RGC denstiy (cells/mm^2) to a var
sup_mm  = data(:,4); % Assign the superior RGC denstiy (cells/mm^2) to a var
nas_mm  = data(:,6); % Assign the nasal RGC denstiy (cells/mm^2) to a var
inf_mm  = data(:,8); % Assign the inferior RGC denstiy (cells/mm^2) to a var

%% Generate the Recptive Field Density From the Drasdo 2007:
% Set Parameters 
radDeg      = 20; % Radius in Degrees
smpPerDeg   = 2; % Samples per Degree
 
RFdensity = densityRf(radDeg,smpPerDeg,'OFF'); % Generates a 2D Receptive Field Desity plot 

% Get data from Superior Merdian as a first pass check to validate the
% pipeline of Turpin/McKendrick 

midPoint = round(size(RFdensity,1)/2); % find middle of RF density image

sup_RFdensity = RFdensity(1:midPoint,midPoint); % extract the superior meridian from 2D Receptive Field Desity plot 

sup_RFdensity = flipud(sup_RFdensity); % flip column vector so 0deg is at top

xSmpsDeg = (0:1/smpPerDeg:radDeg)'; % the eccentricy of each sample of sup_RFdensity in degrees 

%% Convert to mm and cells/mm^2
alpha= 0.0752+5.846e-5*xSmpsDeg-1.064e-5*xSmpsDeg.^2+4.116e-8*xSmpsDeg.^3;% conversion from mm^2 to deg^2 (mm^2/deg^2)
                                                                          % equation from end of Watson 2014 fit from Drasdo 1974

% sup_RFdensity is in cells/deg^2 so we need 1/alpha (deg^2/mm^2) to give cells/mm^2
alpha = 1./alpha; % to get deg^2/mm^2

sup_RFdensity_mm = sup_RFdensity.*alpha; % gives cells/mm^2

xSmpsMm = 0.268.*xSmpsDeg + 0.0003427.*(xSmpsDeg.^2) - 8.3309e-6.*(xSmpsDeg.^3);% the eccentricy of each sample in MM
                                                                                % equation from end of Watson 2014
%% Fit a spline to the data
[sup_RFdensity_mm_fit] = fit(xSmpsMm,sup_RFdensity_mm,'smoothingspline','Exclude', find(isnan(sup_RFdensity_mm)),'SmoothingParam', 1);
[sup_RGCdensity_mm_fit] = fit(ecc_mm,sup_mm,'smoothingspline','Exclude', find(isnan(sup_mm)),'SmoothingParam', 1);
%% Change X Sample Base to match the positions of the Turpin/McKendrick paper:


%% Calculate sector size to extract cell count from cells/mm^2
%sectorAngle = 6; % Angle of the sector ### turpin code does not use sector angle or pi

annulus_radius = 0.005; % parameter from Turpin code
radii = annulus_radius:annulus_radius:5; % vector of radii to match Turpin code
areaPerSeg= radii.^2 - (radii - annulus_radius).^2; % area calculation to match Turpin code

%% Apply the sectors to the fit Densities 

countRF = sup_RFdensity_mm_fit(radii).*areaPerSeg'; % multiply RFs/mm^2 *mm^2 to get RF count per sector 
countRGC = sup_RGCdensity_mm_fit(radii).*areaPerSeg';  % multiply RGCs/mm^2 *mm^2 to get RGC count per sector 

countRFsum = cumsum(countRF); % Cumulative sum of the recetive fields 
countRGCsum = cumsum(countRGC); % Cumulative sum of the recetive fields 

%% Make plot from Turpin/McKencdrick fig. 1
figure
hold on 
plot(radii,countRFsum,'r')
plot(radii,countRGCsum,'b')
legend('Receptive Fields','Retinal Ganglion Cell')
xlabel('Eccentricity (mm)')
ylabel('Cumulative RGC/RF Count')

%validatePlots(RGCdensity,RFdensity,countRF,countRGC,radDeg,smpPerDeg); ##Needs to be modified to work on this format##
