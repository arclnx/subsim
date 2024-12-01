function [Dstate] = acceleration(state, data, cdata)
%% constants
m = data.mass; % mass [kg]
Cd = data.Cd; % coeff of drag
A = data.A; % area [m^2]
p = data.p; % density [kg/m^3]
g = data.g; % [m/s^2]

%% state variables
% state = [x, y, z, dx, dy, dz] [m, m/s]
% Dstate = [dx, dy, dz, ax, ay, az] [m/s, m/s^2]
x = state(1);
y = state(2);
[lat, lon] = m2geo(x, y);
z = state(3);
dx = state(4);
dy = state(5);
dz = state(6);

%% find ocean velocity
% uo = 1;
% vo = 1;
[uo, vo] = interpCurrent(lat, lon, -z, cdata);
wo = 0;

%% calculations
% uo, vo, wo = x,y,z velocity of ocean
% dx, dy, dz = x,y,z velcoity of sub
ax = sign(uo-dx) * (1/2 * p * (uo-dx)^2 * Cd * A) * 1/m;
ay = sign(vo-dy) * (1/2 * p * (vo-dy)^2 * Cd * A) * 1/m;
az = sign(wo-dz) * (1/2 * p * (wo-dz)^2 * Cd * A) * 1/m - g;

Dstate(1) = dx;
Dstate(2) = dy;
Dstate(3) = dz;
Dstate(4) = ax;
Dstate(5) = ay;
Dstate(6) = az;

% transpose
Dstate = Dstate';
end