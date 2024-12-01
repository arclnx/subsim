function [u, v] = interpCurrent(lat, lon, depth, data)
% interpolates current
    u = interp3(data.latvec, data.lonvec, data.depthvec, data.uogrid, lat, lon, depth, "linear", 0);
    v = interp3(data.latvec, data.lonvec, data.depthvec, data.vogrid, lat, lon, depth, "linear", 0);
end  