%% import data
time = ncread("currents.nc", "time");
lat = ncread("currents.nc", "latitude");
lon = ncread("currents.nc", "longitude");
depth = ncread("currents.nc", "depth");
uo = ncread("currents.nc", "uo"); %[lon lat depth]
vo = ncread("currents.nc", "vo"); %[lon lat depth]

%% gridify data
[y, x, z] = meshgrid(lat, lon, depth);
longrid = reshape(x, [], 1);
latgrid = reshape(y, [], 1);
depthgrid = reshape(z, [], 1);
uogrid = reshape(uo, [], 1);
vogrid = reshape(vo, [], 1);

%% plot currents
figure(1)
scatter3(longrid(~isnan(uogrid)), latgrid(~isnan(uogrid)), -depthgrid(~isnan(uogrid)), ".")
figure(2)
quiver3(longrid, latgrid, -depthgrid, uogrid, vogrid, zeros(50*82*50,1), 0);
figure(3)
quiver3(x, y, -z, uo, vo, zeros(82,50,50), 0);

%% setup current data
cdata.latvec = lat;
cdata.lonvec = lon;
cdata.depthvec = depth;
cdata.uogrid = uo; cdata.uogrid(isnan(cdata.uogrid))=0;
cdata.vogrid = vo; cdata.vogrid(isnan(cdata.vogrid))=0;

%% Simulation
% constants
data.mass = 10000; % mass [kg]
data.Cd = 0.5; % coeff of drag
data.A = 100; % area [m^2]
data.p = 1000; % density [kg/m^3]
data.g = 9.81; % [m/s^2]

% initial condition
s0 = [0 0 0 0 0 0];
t = []; y = [];

tic
[t, y] = ode45(@(t,y) (acceleration(y, data, cdata)), [0 3600], s0);
toc

figure(4)
plot3(y(:,1), y(:,2), y(:,3), "-")
grid on