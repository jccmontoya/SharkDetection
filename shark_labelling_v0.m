
%%%%%%% SELECT AREA TO ANALYZE
%
% Set image_path to the name to the image to analyze.
% When the first image appears, select the are that contains sharks. 
% Then, right click on the edge of the rectangle and select Crop Image
%

%%%%%%%%
%
% Now it's time to labell sharks. Several sub-images will appear
% 1) Click the front and rear of each shark. When all sharks in a sub-image
%    are laballed, press enter to go for the next sub-image.


close all
%clear all

image_path = 'DSC_4622.JPG';
save_info_path = 'labelled_sharks3';

shark_img = imread(image_path);
imagesc(shark_img);axis equal; axis tight;
[rows columns channels] = size(shark_img);

disp('Select area with sharks');

[shark_crop,rect] = imcrop(shark_img);

%shark_point = ginput(2);

end_labelling = true;

cell_row = 1;
cell_col = 1;
offset = 200; % Cell size

I = imcrop(shark_crop,[1,1 offset,offset]);
close all
imagesc(I);axis equal;axis tight
hold on;
next_subimage=false;
sharks_labelled = [0,0,0,0,0,0,0,0];



while end_labelling
    
    shark_pose = ginput(2);
    
    %No more sharks in subimage
    [n_points,~] = size(shark_pose);
    if(n_points< 2)
       [I,cell_row,cell_col] = getSubImage(shark_crop,cell_row,cell_col,offset);
       if(I==0)
           break;%End of image reached
       end
       close;
       imagesc(I);axis equal;axis tight 
       hold on;
    else
        shark_tail = shark_pose(1,:);
        shark_tail(1) = shark_tail(1) + cell_col;
        shark_tail(2) = shark_tail(2) + cell_row;
        shark_head = shark_pose(2,:);
        shark_head(1) = shark_head(1) + cell_col;
        shark_head(2) = shark_head(2) + cell_row;
        [x,y,u,v] = getDrawVector(shark_tail,shark_head);
        % For each labelled shark the two points (head and tail), central
        % point and magnitude of the vector are stored.
        sharks_labelled = [sharks_labelled ; [shark_tail, shark_head, x, y,u,v]];
    end
    
end

%Delete first row
sharks_labelled = sharks_labelled(2:end,:);
printVectors(shark_img,sharks_labelled,rect(1),rect(2));

save(save_info_path);
%knnsearch



    