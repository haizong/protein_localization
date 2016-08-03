function pr_loc_analysis(dir_name, CEN_LINE_OFFSET, POLE_PORTION, y_lim, NUM_BIN)

% This code calculates the ratio of FITC/Texas red by box and line method.
% User first rotate the image to crop the boundary of the cells out. 
% The code will extract information in the box region in each channel,
% followed by calculation of ratios. 
%
% This code is modified from spindle_mat_analysis, which was used in Zong 2015 MBoc. 
% HZ  2016-8-1 Bloomington

%% Check input & set default
if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET); CEN_LINE_OFFSET = 5; end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION); POLE_PORTION = 1/10; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;
if ~exist('NUM_BIN','var') || isempty(NUM_BIN); NUM_BIN = 100; end;

if ~exist(dir_name, 'dir');
    fprintf(2, 'ERROR: directory not found.\n');
    return;
end;

%% Readin RGB intensity. Save info in protein_data 
tic;
mkdir([dir_name,'_analysis']); 
diary([dir_name,'_analysis/log.txt']);

Cell_data = spindle_read_folder(dir_name, CEN_LINE_OFFSET, POLE_PORTION);

list_good = {};
list_bad = {};
for i = 1:length(Cell_data);
    if ~Cell_data{i}.is_bad;
        % call function pr_loc_summary 
        pr_loc_summary(Cell_data{i}); 
        list_good = [list_good, Cell_data{i}.raw_file(end-3:end-1)];
    else
        list_bad = [list_bad, Cell_data{i}.raw_file(end-3:end-1)];
    end;
    save([dir_name,'_analysis/save.mat']);
    if ~mod(i, 6); close all; end;
end;
close all;

%% Display all cropped images
pr_loc_display(Cell_data, list_good);
print_save_figure(gcf, 'summary', [dir_name,'_analysis']);
% Calculate ratio
[Cell_data] = pr_loc_calc_ratio(Cell_data, list_good);  
[Cell_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = ...
    pr_loc_plot_ratio(Cell_data, list_good, y_lim, NUM_BIN, '', '', '');

%% Ratio of FITC/Texas Red by box_average and line_scan method 
% assignin('base', 'file_name', file_name);  Input good cell_ID
for i = 1:length(list_good);
    idx = pr_loc_find_ID(Cell_data, list_good{i});
    Cell_data{idx}.ratio_box_100 = Cell_data{idx}.ratio_box_100';
    Cell_data{idx}.ratio_line_100 = Cell_data{idx}.ratio_line_100';
    Cell_data{idx}.plot_x = Cell_data{idx}.plot_x';
end;

obj_good.list_chosen = list_good;
obj_good.ratio_box_mean = ratio_box_mean;
obj_good.ratio_box_std = ratio_box_std;
obj_good.ratio_line_mean = ratio_line_mean;
obj_good.ratio_line_std = ratio_line_std;

% save
clear('i', 'idx', 'ratio_box_mean', 'ratio_box_std', 'ratio_line_mean', 'ratio_line_std');
save([dir_name,'_analysis/save.mat']);
fprintf('Saved workspace file: %s\n', [dir_name,'_analysis/save.mat']);
log_cleanup([dir_name,'_analysis/log.txt']);
fprintf('Saved screen log file: %s\n', [dir_name,'_analysis/log.txt']);
diary off;
toc;
close all; 
