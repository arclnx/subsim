function [lat, lon] = m2geo(x, y)
% converts [x, y] in meters to [lat, lon] relative to 18N 38E assuming lat
% and lon are square

Re = 6370*1000; % earth radius [km]
lat = 38 + rad2deg(y / Re);
lon = 18 + rad2deg(x / (Re*cosd(38)));

end