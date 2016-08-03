clear; clc; 
dir_name = 'test'; 
if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET); CEN_LINE_OFFSET = 5; end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION); POLE_PORTION = 1/10; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;
if ~exist('NUM_BIN','var') || isempty(NUM_BIN); NUM_BIN = 100; end;

if ~exist(dir_name, 'dir');
    fprintf(2, 'ERROR: directory not found.\n');
    return;
end;

tic;
%%
mkdir([dir_name,'_analysis']); 
diary([dir_name,'_analysis/log.txt']);

protein_data = spindle_read_folder(dir_name, CEN_LINE_OFFSET, POLE_PORTION);

list_good = {};
list_bad = {};
for i = 1:length(protein_data);
    if ~protein_data{i}.is_bad;
        pr_loc_summary(protein_data{i});
        list_good = [list_good, protein_data{i}.raw_file(end-3:end-1)];
    else
        list_bad = [list_bad, protein_data{i}.raw_file(end-3:end-1)];
    end;
    
    if ~mod(i, 6); close all; end;
end;
close all;
save([dir_name,'_analysis/save.mat']);
%%
pr_loc_display(protein_data, list_good);
print_save_figure(gcf, 'summary', [dir_name,'_analysis']);
[protein_data] = pr_loc_calc_ratio(protein_data, list_good);
[protein_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = pr_loc_plot_ratio(protein_data, list_good, y_lim, NUM_BIN, '', '', '');

%% assignin('base', 'file_name', file_name);
for i = 1:length(list_good);
    idx = pr_loc_find_ID(protein_data, list_good{i});
    protein_data{idx}.ratio_box_100 = protein_data{idx}.ratio_box_100';
    protein_data{idx}.ratio_line_100 = protein_data{idx}.ratio_line_100';
    protein_data{idx}.plot_x = protein_data{idx}.plot_x';
end;

obj_good.list_chosen = list_good;
obj_good.ratio_box_mean = ratio_box_mean;
obj_good.ratio_box_std = ratio_box_std;
obj_good.ratio_line_mean = ratio_line_mean;
obj_good.ratio_line_std = ratio_line_std;
clear('i', 'idx', 'ratio_box_mean', 'ratio_box_std', 'ratio_line_mean', 'ratio_line_std');

save([dir_name,'_analysis/save.mat']);
fprintf('Saved workspace file: %s\n', [dir_name,'_analysis/save.mat']);

log_cleanup([dir_name,'_analysis/log.txt']);
fprintf('Saved screen log file: %s\n', [dir_name,'_analysis/log.txt']);
diary off;
toc;

