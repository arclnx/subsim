data = readmatrix("out2.csv");
% t = data(:,1);
% lat = data(:,2);
% lon = data(:,3);
% dep = data(:,4);
% east = data(:,5);
% north = data(:,6);

runs = mat2cell(data,ones(1000,1).*864, 6);

for i = 1:1000
    plot3(runs{i}(:,3), runs{i}(:,2), -runs{i}(:,4)); hold on
end
xlabel("lon"); ylabel("lat"); zlabel("depth"); grid on;

