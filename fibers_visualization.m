function fibers_visualization(IM, BW_map, Skel_map, time_delay)
 
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

ff = figure();
ff.WindowState = 'maximized';

    for ii = 1:size(IM,3)
        subplot(1,3,1)
        imshow(IM(:,:,ii), [])
        title('Input image', 'FontSize',14, 'Color', [0 0 0])
        
        subplot(1,3,2)
        imshow(BW_map(:,:,ii), [])
        title('Fibers binary map', 'FontSize',14, 'Color', [0 0 0])
    
        subplot(1,3,3)
        imshow(Skel_map(:,:,ii), [])
        title('Skeleton map', 'FontSize',14, 'Color', [0 0 0])
    
        pause(time_delay)
    end