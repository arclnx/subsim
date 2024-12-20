%% import data
time = ncread("currents.nc", "time");
NClat = ncread("currents.nc", "latitude");
NClon = ncread("currents.nc", "longitude");
NCdepth = ncread("currents.nc", "depth");
NCuo = ncread("currents.nc", "uo"); %[lon lat depth]
NCvo = ncread("currents.nc", "vo"); %[lon lat depth]

%% gridify data
[y, x, z] = meshgrid(NClat, NClon, NCdepth);
longrid = reshape(x, [], 1);
latgrid = reshape(y, [], 1);
depthgrid = reshape(z, [], 1);
uogrid = reshape(NCuo, [], 1);
vogrid = reshape(NCvo, [], 1);

%% plot currents (ignore)
figure(1)
scatter3(longrid(~isnan(uogrid)), latgrid(~isnan(uogrid)), -depthgrid(~isnan(uogrid)), ".")
figure(2)
quiver3(longrid, latgrid, -depthgrid, uogrid, vogrid, zeros(50*82*50,1), 0);
figure(3)
quiver3(x, y, -z, NCuo, NCvo, zeros(82,50,50), 0);

%% setup current data for interpolation function
cdata.latvec = NClat;
cdata.lonvec = NClon;
cdata.depthvec = NCdepth;
cdata.uogrid = NCuo; cdata.uogrid(isnan(cdata.uogrid))=0;
cdata.vogrid = NCvo; cdata.vogrid(isnan(cdata.vogrid))=0;

%% plot interp currents
[lattest, lontest, depthtest] = meshgrid([36:.1:41],[15:.1:21],[0:500:4000]);
lattest = reshape(lattest, [], 1);
lontest = reshape(lontest, [], 1);
depthtest = reshape(depthtest, [], 1);
[uotest, votest] = interpCurrent(lattest,lontest,depthtest, cdata);
figure(4)
quiver3(lontest, lattest, -depthtest, uotest, votest, zeros(size(uotest)), 0, ShowArrowHead="off")
xlabel("Latitude"); ylabel("Longitude"); zlabel("Depth")

%% Simulation
% constants (change these)
data.mass = 10000; % mass [kg]
data.Cd = 1; % coeff of drag
data.A = 30; % area [m^2]
data.p = 1000; % seawater density [kg/m^3]
data.g = 9.81; % [m/s^2]

% initial position [m] (change this)
[x0, y0] = geo2m(38, 18);
z0 = -100;
% initial velocity [m/s] (change this)
u0 = 0; v0 = 0; w0 = 0;
% initial state
s0 = [x0 y0 z0 u0 v0 w0];

% simulation times
tf = 3600;

% solver options
opts = odeset(RelTol=0.1, AbsTol=1, MinStep=0.1, MaxStep=1);

% run simulation
tic
[t, state] = ode23(@(t,y) (acceleration(y, data, cdata)), [0 3600], s0);
toc

% convert back to geo coordinates
[sim_lat, sim_lon] = m2geo(state(:,1), state(:,2));
sim_z = state(:,3);
figure(5)
grid on
plot3(state(:,1),state(:,2),state(:,3),"-o")
figure(6)
plot3(sim_lon, sim_lat, sim_z, "-o")
grid on