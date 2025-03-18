%% Statistical entropy (S) calculation

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

function [entropy1, entropy10,Local_orientations] = fiber_entropy(skelIm2,binsize) 

    Local_orientations = skeletonOrientation(skelIm2,[binsize binsize]);
    Local_orientations(skelIm2 == 0) = NaN;
    
     figure(1),
        h1 = histogram(Local_orientations(~isnan(Local_orientations)),'BinWidth',1, 'Normalization','probability');
        val1 = h1.Values;
%         BinEd1 = h1.BinEdges;
    
        h1 = histogram(Local_orientations(~isnan(Local_orientations)),'BinWidth',10, 'Normalization','probability');
        val10 = h1.Values;
%         BinEd1 = h1.BinEdges;
        close(figure(1))
    
        entropy1 = (-1/log(length(val1)))*sum(val1.*log(val1));
        entropy10 = (-1/log(length(val10)))*sum(val10.*log(val10));