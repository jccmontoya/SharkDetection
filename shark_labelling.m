
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
save_info_path = [image_path, '_labelled.mat'];%'labelled_sharks3';

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
disp('Press b and ENTER to label again the current image');
next_subimage=false;
sharks_labeled = [0,0,0,0,0,0,0,0];
sharks_labeled_temp = [];
old_cell_row = 1;
old_cell_col = 1;

%%% LETS TRY ADDING REWIND CAPABILITIES
%%% PRESS b and ENTER to drop the last image labeling and label it again.

while end_labelling
    
    [sx, sy, buttons] = ginput(2);
    %shark_pose = ginput(2);
    shark_pose = [sx,sy];
    %No more sharks in subimage
    [n_points,~] = size(shark_pose);
    
    if(n_points< 2)
        buttons
        if(n_points>0 && buttons(end)==98) % letters B or b, retry
            if(old_cell_row == 1)
                I = imcrop(shark_crop,[1,1 offset,offset]);
            else               
                [I,cell_row,cell_col] = getSubImage(shark_crop,old_cell_row,old_cell_col,offset);
            end
        else
            old_cell_row = cell_row;
            old_cell_col  = cell_col;
            [I,cell_row,cell_col] = getSubImage(shark_crop,cell_row,cell_col,offset);
            sharks_labeled = [sharks_labeled ; sharks_labeled_temp];
            if(I==0)
                break; % End of image reached
            end
        end
        shark_labeled_temp = [];
        close;
        imagesc(I);axis equal;axis tight
        hold on;
        
    else
        shark_tail = shark_pose(1,:);
        shark_head = shark_pose(2,:);
        [x,y,u,v] = getDrawVector(shark_tail,shark_head);
        x = x + cell_col;
        y = y + cell_row;
        shark_tail(1) = shark_tail(1) + cell_col;
        shark_tail(2) = shark_tail(2) + cell_row;
        shark_head(1) = shark_head(1) + cell_col;
        shark_head(2) = shark_head(2) + cell_row;
        % For each labelled shark the two points (head and tail), central
        % point and magnitude of the vector are stored.
        sharks_labeled_temp = [sharks_labeled_temp ; [shark_tail, shark_head, x, y,u,v]];
    end
    
end

%Delete first row
sharks_labeled = sharks_labeled(2:end,:);
printVectors(shark_img,sharks_labeled,rect(1),rect(2));

save(save_info_path);
%knnsearch



