%% This function evaluate the fibers characterization metrics from the FP method

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

function [T_fibersLength, Tortuosity, Entropy_01, Entropy_10, Var_map] = fiber_metrics(Skel_map, radius, metadata, scale_factor)

    binsize = 11;
for ii = 1:size(Skel_map,3)

    skelIm = Skel_map(:,:,ii);
    skelIm = bwpropfilt(skelIm, 'MajorAxisLength', [6*scale_factor, Inf]);
    [Bskel, Lskel] = bwboundaries(skelIm, 'noholes');
    properties = regionprops(Lskel, {'Perimeter', 'Centroid'});
    for ll = 1:length(properties)
        Centroids(ll,:) = properties(ll).Centroid;
    end

    perimeter = [properties(:).Perimeter].';
    Perimeter = (metadata.xResolution./scale_factor).*perimeter; % in image unities e.g um
    T_fibersLength(ii) = sum(Perimeter);

    for ll = 1:length(Bskel)
        L = floor(length(Bskel{ll})/2);
        dist = sqrt((Bskel{ll}(L,1)-Bskel{ll}(1,1)).^2 + (Bskel{ll}(L,2)-Bskel{ll}(1,2)).^2);
        tor(ll) = perimeter(ll)./dist;
    end
           
    Tortuosity{ii} = tor;

    [entropy1, entropy10, LocalO] = fiber_entropy(skelIm,binsize);
    [VarL] = fibers_variance(LocalO, radius, metadata, scale_factor);
    
    Entropy_01(ii) = entropy1;
    Entropy_10(ii) = entropy10;

    Var_map(:,:,ii) = VarL;
end