function pr_loc_display(Cell_data, list_good)

n_cols = 8;
n_rows = ceil(length(list_good)/n_cols);
figure();
set_print_page(gcf,0,[0 0 1200 900]);

for i = 1:length(list_good);
    subplot(n_rows, n_cols, i);
    idx = pr_loc_find_ID(Cell_data, list_good{i});
    im_display = cat(3, imadjust(Cell_data{idx}.crop_box(:,:,1)),...
        imadjust(Cell_data{idx}.crop_box(:,:,2)), imadjust(Cell_data{idx}.crop_box(:,:,3)));
    imshow(im_display);
    title(Cell_data{idx}.raw_file(end-3:end-1),'fontweight','bold','fontsize',16);
end;




