
data = fileread('Hurricanes.txt');
data = cellstr(data);
 data = cellfun(@(newline) strsplit(newline, '\n'), data, 'UniformOutput', false);
data = [data{:}];
% 
data_str = [];
warning off

hurricanes =[];
name = [];
num = 0;
class = [];
land = [];

for ii = 2:length(data)
    ii
    
    aa = data(ii);
    data_str = char(aa);
    
 
    
    if data_str(1:2)== '18' | data_str(1:2)== '19' | data_str(1:2) == '20'
        yr = str2num(data_str(1:4));
        mth = str2num(data_str(5:6));
        day = str2num(data_str(7:8));
        hh = str2num(data_str(11:12));
        mm = str2num(data_str(13:14));
        
        lat = str2num(data_str(24:27));
        lon = str2num(data_str(32:35));
        
        wind = str2num(data_str(39:42));
        minpres = str2num(data_str(45:48));
        
        hurricanes = [hurricanes;num,yr,mth,day,hh,mm,lat,lon,wind,minpres];
        
        class = ([class;num,data_str(20:21)]);
        la = data_str(15:19);
        ff = findstr(la,'L');
        if ~isempty(ff)
            land = ([land;num,lat,lon]);
        else
            land = ([land;NaN,NaN,NaN]);
        end
%         name = ([name;nuNaN]);
    else
        num = num +1;
      
        nn = data_str;
        ff = strfind(nn,',');
        ff = ff(1);
        nn = nn(ff+1:end);
        ffss = strfind(nn,',');
        ffss = ffss(1);
        nn = nn(1:ffss-1);
        ff = strfind(nn,' ');
        nn = nn(ff+1:end);

        name = ([name;num,nn]);
        
        
        
    end
    
end

hurricanes(:,8) = hurricanes(:,8)*-1;
   
ff = find(hurricanes(:,8) ==0 | hurricanes(:,7) == 0);
hurricanes(ff,7:8) = NaN;
save('/Users/Lena/Documents/Data Science/hurricanes','hurricanes','name','class','land')
    
    
%%
close all
clear all
load hurricanes

warning off MATLAB:hg:patch:PatchFaceVertexCDataLengthMustEqualVerticesLength
 
warning off MATLAB:hg:patch:CannotUseFaceVertexCDataOfSize0


figure

lon=[-100 10];
lat=[0 55];

minlon=lon(1);
maxlon=lon(2);
minlat=lat(1);
maxlat=lat(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mercator projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(1)
    orient landscape
    m_proj('mercator','lat',[minlat maxlat],'lon',[minlon maxlon])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lambert conformal conic projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(0)
    m_proj('Lambert Conformal Conic','lon',[minlon maxlon],'lat',[minlat maxlat])%,'clo',-170,'par',[0 80],'rec',('on'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stereographic projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(0)
    m_proj('stereographic','lat',90,'long',-157,'radius',25);
    % m_proj('stereographic','lat',70,'long',-45,'radius',25);
end


m_gshhs_l('patch',[.5,.5,.5],'edgecolor','k')
m_coast('patch',[.5,.5,.5],'edgecolor','k')
% Use this to only draw coastlines
m_coast('line','linewidth',3,'color','black')

m_grid
zoom on
hold on
ylabel('Latitude')
xlabel('Longitude')


max_num = max(hurricanes(:,1))
CC = jet(max_num);
for ii = 1:max_num
    ff = find(hurricanes(:,1) == ii);
    hh = hurricanes(ff,:);
    
    
    m_plot(hh(:,8),hh(:,7),'.-','color',CC(ii,:))
end

warning on

%% Number by year
yr = hurricanes(1,2):hurricanes(end,2);

number =[];
for ii = yr(1):yr(end)
    ff = find(hurricanes(:,2) == ii);
    hh = hurricanes(ff,1);
    
    hh = unique(hh);
    number = ([number ; length(hh)]);
end

figure
plot(yr',number)

ff = find(yr == 1970);
plot(yr(ff:end)',number(ff:end),'.-','markersize',13)

ff = ~isnan(land(:,1));
ff = find(ff==1);
land_year = hurricanes(ff,1:2);
[in,IA,IC] = unique(land_year(:,1));

land_year = land_year(IA,2);

land_number =[];
for ii = yr(1):yr(end)
    ff = find(land_year == ii);
    
    land_number = ([land_number ; length(ff)]);
end

ff = find(yr == 1970);
plot(yr(ff:end)',land_number(ff:end),'.-','markersize',13)
ylabel('Number of landfall')
xlabel('Year')
grid on 
set(gca,'fontsize',12,'fontweight','bold')
title('Number of storms (any category) that made landfall')

%% Points of origin


figure

lon=[-100 15];
lat=[0 50];

minlon=lon(1);
maxlon=lon(2);
minlat=lat(1);
maxlat=lat(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mercator projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(1)
    orient landscape
    m_proj('mercator','lat',[minlat maxlat],'lon',[minlon maxlon])
end


m_gshhs_l('patch',[.5,.5,.5],'edgecolor','k')
m_coast('patch',[.5,.5,.5],'edgecolor','k')
% Use this to only draw coastlines
m_coast('line','linewidth',3,'color','black')

m_grid
zoom on
hold on
ylabel('Latitude')
xlabel('Longitude')


max_num = max(hurricanes(:,1))
CC = jet(max_num);
for ii = 1:max_num
    ff = find(hurricanes(:,1) == ii);
    hh = hurricanes(ff,:);
    
    
    m_plot(hh(1,8),hh(1,7),'.','markersize',14,'color',CC(ii,:))
end

warning on

colorbar
colormap(CC)
set(gca,'clim',[yr(1) yr(end)])

title('Points of origin')



%% Points of landfall


figure

lon=[-100 -50];
lat=[0 50];

minlon=lon(1);
maxlon=lon(2);
minlat=lat(1);
maxlat=lat(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mercator projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(1)
    orient landscape
    m_proj('mercator','lat',[minlat maxlat],'lon',[minlon maxlon])
end


m_gshhs_l('patch',[.5,.5,.5],'edgecolor','k')
m_coast('patch',[.5,.5,.5],'edgecolor','k')
% Use this to only draw coastlines
m_coast('line','linewidth',3,'color','black')

m_grid
zoom on
hold on
ylabel('Latitude')
xlabel('Longitude')


ff = ~isnan(land(:,1));
land = land(ff,:);
m_plot(-land(:,3),land(:,2),'r.','markersize',14)

warning on


title('Points of landfall')
