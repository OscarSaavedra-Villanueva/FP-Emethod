%% Fingerprint methods parameters

scale_factor = 2;
FP_thresh = 0.16; % Threshold to define when a region is considered a ridge-like region
reliability_thresh = 0.2; % 
radius = 20; % 

%% Define image stack to open and process it
path = '.\';
% filename = 'C2-m54_A3_2_pos07.tif';
filename = 'm149_2B3.tif';
full_path = ['' path filename ''];

metadata = read_tiff_metadata(full_path);

[IM, BW_map, Skel_map] = FP_segmentation(full_path, metadata, scale_factor, ...
                            reliability_thresh, FP_thresh);

%% Results visualization

fibers_visualization(IM, BW_map, Skel_map, 1) % comment this line to avoid segmentation visualization

%% metric calculations

[T_fibersLength, Tortuosity, Entropy_01, Entropy_10, Var_map] = fiber_metrics(Skel_map, radius, metadata, scale_factor);

%% Save results

pathSave = '.\';
filenameSave = 'm149_2B3_SavedTest';
full_path_Save = ['' pathSave filenameSave ''];

save([full_path_Save '.mat'], 'Skel_map','Var_map', 'T_fibersLength', 'Tortuosity', 'Entropy_01', 'Entropy_10')

%% Mean values per z-plane

[Var_mean, Tortuosity_mean] = zplane_mean_parameter(Var_map, Tortuosity);
