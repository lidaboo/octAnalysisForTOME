
radDeg = 30;
smpPerDeg = 2;
fname = '/Users/michael/Documents/MATLAB/octAnalysisForTOME/curcio_data.txt';


[line,pol,ecc] = createGrid(radDeg,smpPerDeg);

Df = densityRf(ecc,pol,radDeg,smpPerDeg);

[dRGC] = loadCurcio(fname,radDeg,smpPerDeg);


figure
subplot(2,1,1);
imagesc(Df)
title('RGC receptive feild Density')
axis square
subplot(2,1,2);
imagesc(dRGC)
title('RGC Density')
axis square



[dfCount2,rgcCount2] = calcDisplacment(Df,dRGC,radDeg,smpPerDeg);

[Df2,dRGC2] = rotAndCrop(Df,dRGC,90);

[dfCount3,rgcCount3] = calcDisplacment(Df2,dRGC2,radDeg,smpPerDeg);

[Df3,dRGC3] = rotAndCrop(Df,dRGC,180);

[dfCount4,rgcCount4] = calcDisplacment(Df3,dRGC3,radDeg,smpPerDeg);

[Df4,dRGC4] = rotAndCrop(Df,dRGC,270);

[dfCount5,rgcCount5] = calcDisplacment(Df4,dRGC4,radDeg,smpPerDeg);

%% plot cross scetional sclices in RGC

Xzero = round(size(Df,2)/2);
Yzero = round(size(Df,1)/2);

figure
plot([0 line(line>0)],Df(Yzero,Xzero:end),'r'); %temp
hold on
plot([0 line(line>0)],Df4(Yzero,Xzero:end),'b'); %sup
plot([0 line(line>0)],Df3(Yzero,Xzero:end),'g'); %nasal
plot([0 line(line>0)],Df2(Yzero,Xzero:end),'k'); %inf
xlabel('Eccentricity (deg)')
ylabel('RGCf density') 
legend('Temporal','Superior','Nasal','Inferior')
grid on
%% plot cross scetional sclices in RGC

Xzero = round(size(Df,2)/2);
Yzero = round(size(Df,1)/2);

figure
loglog([0 line(line>0)],dRGC(Yzero,Xzero:end),'r'); %temp
hold on
loglog([0 line(line>0)],dRGC4(Yzero,Xzero:end),'b'); %sup
loglog([0 line(line>0)],dRGC3(Yzero,Xzero:end),'g'); %nasal
loglog([0 line(line>0)],dRGC2(Yzero,Xzero:end),'k'); %inf
xlabel('Eccentricity (deg)')
ylabel('RGC density') 
legend('Temporal','Superior','Nasal','Inferior')
grid on

%% Plot the cumulative RGC 
figure
plot([0 line(line>0)],rgcCount2,'r'); %temp
hold on
plot([0 line(line>0)],rgcCount5,'b'); %sup
plot([0 line(line>0)],rgcCount4,'g'); %nasal
plot([0 line(line>0)],rgcCount3,'k'); %inf
xlabel('Eccentricity (deg)')
ylabel('Cumulative RGC density') 
legend('Temporal','Superior','Nasal','Inferior')
grid on

%% Plot the cumulative Receptive Feild 
figure
plot([0 line(line>0)],dfCount2,'r'); %temp
hold on
plot([0 line(line>0)],dfCount5,'b'); %sup
plot([0 line(line>0)],dfCount4,'g'); %nasal
plot([0 line(line>0)],dfCount3,'k'); %inf
xlabel('Eccentricity (deg)')
ylabel('Cumulative RGCf density') 
legend('Temporal','Superior','Nasal','Inferior')
grid on