%% Circular variance map calculation

% Copyright (c) 2025 Oscar Saavedra-Villanueva
% https://github.com/OscarSaavedra-Villanueva/
% If you use our code to analyze your data. Please cite our publication
% DOI: 10.1111/boc.70001
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

function [VarL] = fibers_variance(LocalO, radius, metadata, scale_factor)

    stats_threshold = 50;
    Radius = round( radius.*scale_factor./metadata.xResolution);
    step = round(Radius/2); % 50% overlaping

    ThetaL = zeros( floor((size(LocalO,2)-Radius(1))/step(1))+1, floor((size(LocalO,1)-Radius(1))/step(1))+1 );
    VarL = ThetaL;

    for ll = 1:floor((size(LocalO,1)-Radius(1))/step(1))+1 % y-axis
        for nn = 1:floor((size(LocalO,2)-Radius(1))/step(1))+1 % x-axis
            posxx = [(nn-1)*step(1)+1, (nn-1)*step(1)+Radius(1)+1];
            posyy = [(ll-1)*step(1)+1, (ll-1)*step(1)+Radius(1)+1];
     
            temp_thetaXYl = LocalO(posyy(1):posyy(2), posxx(1):posxx(2));
            temp_thetaXYl = temp_thetaXYl(:);
            temp_thetaXYl(isnan(temp_thetaXYl)) = [];
            if length(temp_thetaXYl) <= stats_threshold
                ThetaL(ll,nn) = NaN;
                VarL(ll,nn) = NaN;
            else
                temp_thetaXYl = deg2rad(temp_thetaXYl);
                thetaXYl = angle(sum(exp(1i*2*temp_thetaXYl)))/2;
                ThetaL(ll,nn) = rad2deg(thetaXYl);   
                VarL(ll,nn) = mean(1-cos(temp_thetaXYl-thetaXYl));
            end
        end
    end