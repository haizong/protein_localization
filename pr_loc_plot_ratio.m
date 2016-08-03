function [protein_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = ...
    pr_loc_plot_ratio(protein_data, list_plot, y_lim, NUM_BIN, str_title, file_name, dir_name)

[protein_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = ...
    pr_loc_average_ratio(protein_data, list_plot, NUM_BIN);

if ~exist('dir_name','var') || isempty(dir_name); dir_name = [protein_data{1}.raw_file(1: strfind(protein_data{1}.raw_file, '/')-1), '_analysis']; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;
if ~exist('str_title','var') || isempty(str_title); str_title = dir_name(1:end-9); end;
if ~exist('file_name','var') || isempty(file_name); file_name = 'ratio'; end;

clrmap = jet(length(list_plot));
figure();
set_print_page(gcf, 0);

subplot(4,1,1); hold on;
for i = 1:length(list_plot);
    idx = pr_loc_find_ID(protein_data, list_plot{i});
    plot(protein_data{idx}.plot_x, protein_data{idx}.ratio_box, 'color', clrmap(i, :));
end;
plot(linspace(0,1,NUM_BIN), ratio_box_mean, 'ko-','markersize',3);
axis([0 1 0 y_lim]);
legend(list_plot,'Location','EastOutside');
xlabel('Trailing edge -> Leading edge');
ylabel('FITC/TexRd Ratio');
title(str_title,'fontsize',16,'fontweight','bold', 'Interpreter','none'); 

subplot(4,1,2); hold on;
for i = 1:length(list_plot);
    idx = pr_loc_find_ID(protein_data, list_plot{i});
    plot(protein_data{idx}.plot_x, protein_data{idx}.ratio_line, 'color', clrmap(i, :));
end;
plot(linspace(0,1,NUM_BIN), ratio_line_mean, 'ko-','markersize',3);
axis([0 1 0 y_lim]);
legend(list_plot,'Location','EastOutside');
xlabel('Trailing edge -> Leading edge');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio    [top] BOX;   [bottom] LINE',...
    'fontsize',14,'fontweight','bold', 'Interpreter','none'); 

subplot(4,1,3); hold on;
plot(linspace(0,1,NUM_BIN), ratio_box_mean, 'bo-','markersize',3);

axis([0 1 0 1.2]);
h = errorbar(linspace(0,1,NUM_BIN), ratio_box_mean, ratio_box_std, 'b');
errorbar_tick(h, 500);

legend('Box','Location','EastOutside');
xlabel('Trailing edge -> Leading edge');
ylabel('FITC/TexRd Ratio');
title(['FITC/TexRd Ratio (BOX, n = ',...
    num2str(length(list_plot)), ')'],'fontsize',14,'fontweight','bold', 'Interpreter','none'); 

subplot(4,1,4); hold on;
plot(linspace(0,1,NUM_BIN), ratio_line_mean, 'ro-','markersize',3);

axis([0 1 0 1.2]);
h = errorbar(linspace(0,1,NUM_BIN), ratio_line_mean, ratio_line_std, 'r');
errorbar_tick(h, 500);

legend('Line','Location','EastOutside');
xlabel('Trailing edge -> Leading edge');
ylabel('FITC/TexRd Ratio');
title(['FITC/TexRd Ratio (LINE, n = ',...
    num2str(length(list_plot)), ')'],'fontsize',14,'fontweight','bold', 'Interpreter','none'); 

print_save_figure(gcf, file_name, dir_name);
