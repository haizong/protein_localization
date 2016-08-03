function protein_data = pr_loc_calc_ratio(protein_data, list_good)

for i = 1:length(list_good);
    idx = pr_loc_find_ID(protein_data, list_good{i});
    % FITC/Texas Red
    protein_data{idx}.ratio_box = protein_data{idx}.data_box(:,2) ./ protein_data{idx}.data_box(:,1); 
    protein_data{idx}.ratio_line = protein_data{idx}.data_line(:,2) ./ protein_data{idx}.data_line(:,1);
    % Rescale the cell length [0, 1]
    protein_data{idx}.plot_x = linspace(0, 1, size(protein_data{idx}.data_line, 1));
end;
