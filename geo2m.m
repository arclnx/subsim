function [x, y] = geo2m(lat, lon)
% converts [lat, lon] to [x, y] in meters relative to 38E 18E assuming lat
% and lon are square

Re = 6370*1000; % earth radius [km]
y = Re * deg2rad(lat - 38);
x = Re * cosd(38) * deg2rad(lon - 18);

end