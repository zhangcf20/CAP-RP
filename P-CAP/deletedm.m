function [] = deletedm(green_folder_base,dist_max)


subdir1 = dir(green_folder_base);

for i = 1:size(subdir1,1)
    
    subdir2 = dir([green_folder_base '/' subdir1(i).name '/' dist_max '.grn.0']);
    
    if size(subdir2,1) > 0
        for j = 0:8
            str = [green_folder_base '/' subdir1(i).name '/' subdir2.name(1:end-1) num2str(j)];
            delete(str);
        end
    end
    
    cf = 23;
end

end

