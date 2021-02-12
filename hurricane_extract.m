
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
    
 