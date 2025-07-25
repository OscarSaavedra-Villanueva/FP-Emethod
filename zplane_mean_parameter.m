%%  Calculate the mean value of each parameter (tortuosity and variance map) per each z-plane 

% Copyright (c) 2024 Oscar Saavedra-Villanueva
% https://github.com/OscarSaavedra-Villanueva/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

function [Var_mean, Tortuosity_mean] = zplane_mean_parameter(Var_map, Tortuosity)

    for ii = 1:length(Tortuosity)
        temp = Tortuosity{ii};
        temp(temp==Inf) = []; 
        Tortuosity_mean(ii) = mean(temp, "omitnan");
        Var_mean(ii) = mean(reshape(Var_map(:,:,ii),[],1), "omitnan");
    end