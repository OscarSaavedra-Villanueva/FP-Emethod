function [IM, BW_map, Skel_map] = FP_segmentation(full_path, metadata, scale_factor, reliability_thres,thresh);

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

scale_factor = round(scale_factor);

for ii = 1:metadata.slices
    im = imread(full_path, ii);
    IM(:,:,ii) = im;
    
    im = double(im);
    im = (1/(1.4*max(im(:))))*im;
    im_c = adapthisteq(im,'Distribution','rayleigh','Range', 'full');
    im_c = imgaussfilt(im_c,1.5);
    im_sharp = imsharpen(im_c,'Radius',1,'Amount',2);
    im = imresize(im_sharp,scale_factor);
% Identify ridge-like regions and normalise image
    blksze = 8;
    [normim, mask] = ridgesegment(im, blksze, thresh); 
    SE = strel('disk',2,0);
    mask = imclose(mask, SE);
% Determine ridge orientations
    [orientim, reliability] = ridgeorient(normim, 1, 5, 5);
% Determine ridge frequency values across the image
    blksze2 = 16; 
    [freq, medfreq] = ridgefreq(normim, mask, orientim, blksze2, 5, 5, 100);         
% Actually I find the median frequency value used across the whole fingerprint gives a more satisfactory result...    
    freq = medfreq.*mask;
% Now apply filters to enhance the ridge pattern
    newim = ridgefilter(normim, orientim, freq, 0.5, 0.5, 0);
% Binarise, ridge/valley threshold is 0
    binim = newim > 0;
% Display binary image for where the mask values are one and where the orientation reliability is greater than 0.35
    IM_temp = binim.*mask.*(reliability>reliability_thres);
    bw = imbinarize(IM_temp);
    bw = imerode(bw, SE);
    bw = bwareaopen(bw,5);
    SE1 = strel('disk',1,0);
    bw = imdilate(bw, SE1);

    mask_nan = ones(size(bw));
    mask_bw = zeros(size(bw));
    mask_nan(bw == 0) = NaN;
    mask_bw(bw == 1) = 1;
    mask_bw = logical(mask_bw);
    mask_bw = bwpropfilt(mask_bw, 'Area', [8, Inf]);

    %% Skeleton
    skelIm = bwskel(mask_bw);
    skelIm = untangling(skelIm);
    maskSkel = ones(size(bw));
    maskSkel(skelIm == 0) = NaN;

    BW_map(:,:,ii) = mask_bw; 
    Skel_map(:,:,ii) = skelIm;

end