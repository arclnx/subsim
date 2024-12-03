data = readmatrix("out2.csv");
runs = mat2cell(data,ones(1000,1).*864, 6);
for i = 1:10
  plot3(runs{i}(:,3), runs{i}(:,2), -runs{i}(:,4)); hold on
end
xlabel("lon"); ylabel("lat"); zlabel("depth"); grid on;
runs = mat2cell(data,ones(1000,1).*864, 6);
temp=[];
for i = 1:10
  temp=[temp;runs{i}(:,3)];
end
clf;

lat = data(:,2);
lng = data(:,3);

% get rid of data below 640m
depth = data(:,4);
keep = depth < 640;
depth = depth(keep);
lat = lat(keep);
lng = lng(keep);

nbins=50;
figure(1) % fig 1
h=histogram2(lat,lng,nbins,'FaceColor','flat');
xlabel('Latitude')
ylabel('Longitude')
title('2D Histogram of Predicted Submersible Position')
colorbar

% runs = mat2cell(data,ones(1000,1).*864, 6);
% lat=[];
% long=[];
% for i = 1:10
%   long=[long;runs{i}(:,3)];
%   lat=[lat;runs{i}(:,2)];
% end
nbins=10;
figure(2) % fig
h=histogram2(lat,lng,'Normalization','probability','DisplayStyle','tile');
xlabel('Latitude')
ylabel('Longitude')
title('Heatmap of Predicted Submersible movement')
colorbar
h.Values;
h.BinCounts;