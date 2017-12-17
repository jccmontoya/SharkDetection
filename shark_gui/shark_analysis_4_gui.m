function shark_analysis_4_gui(save_info_path)
%clear all
close all

%save_info_path = 'test.JPG_labelled.mat';

try
    load(save_info_path);
catch
    warningMessage = sprintf('File not found in current folder:\n%s\n', save_info_path);
    uiwait(msgbox(warningMessage,'Error','error'));
    return
end


% 
% % sharks_labeled variable contains 8 fields:
% % shark_tail(x,y)
% % shark_head(x,y)
% % central point(x,y)
% % vector(u,v)
% 
central_points_x = sharks_labeled(:,5);
central_points_y = sharks_labeled(:,6);

%% Calculate average size (in pixels)

tails_x = sharks_labeled(:,1);
tails_y = sharks_labeled(:,2);
heads_x = sharks_labeled(:,3);
heads_y = sharks_labeled(:,4);

average_size = calculate_average_shark_size(tails_x,tails_y,heads_x,heads_y);

%% Calculate nearest neighbour to each shark detection and append to the' sharks_labeled' matrix

plot(central_points_x,central_points_y,'*');axis equal; axis tight;  %axis([0,13,0,13])
[nneighbours_index, distance] = knnsearch(central_points_x,central_points_y);

% Appending nearest neighbour index and distance to each item in sharks_labeled
sharks_labeled = [sharks_labeled , nneighbours_index, distance];

%% Calculate the angle between neighbours

shark_u = sharks_labeled(:,7);
shark_v = sharks_labeled(:,8);

neighbours_sorted = sharks_labeled(sharks_labeled(:,9),:);
neighbours_u = neighbours_sorted(:,7);
neighbours_v = neighbours_sorted(:,8);

angles = find_neighbour_angle(shark_u,shark_v,neighbours_u,neighbours_v);

% Appending angle towards nearest neighbour
sharks_labeled = [sharks_labeled , angles];
%% Plot sharks according to distance to nearest neighbour

% If distance to the nearest neighbour is <= 2*average (median) size paint 
% shark in red, otherwise, paing it in blue

close all;
try
    imshow(shark_img); 
catch
    warningMessage = sprintf('Warning: file does not exist:\n%s\nCheck that the image and the corresponding .mat file are stored in the same folder', shark_img);
    uiwait(msgbox(warningMessage,'Error','error'));
    return
end
hold on; axis equal; axis tight;
shark_index = find(sharks_labeled(:,10)<=average_size*2)

shark_center_x = sharks_labeled(shark_index,5);
shark_center_y = sharks_labeled(shark_index,6);
plot(shark_center_x,shark_center_y,'r*');

shark_index = find(sharks_labeled(:,10)>average_size*2)
shark_center_x = sharks_labeled(shark_index,5);
shark_center_y = sharks_labeled(shark_index,6);
plot(shark_center_x,shark_center_y,'b*');

%% Plot sharks accorging to alignment to nearest neighbour

% Red vectors for angles below the median and blue for those above

shark_index = find(sharks_labeled(:,11)<=median(angles));
shark_center_x = sharks_labeled(shark_index,5);
shark_center_y = sharks_labeled(shark_index,6);
shark_center_u = sharks_labeled(shark_index,7);
shark_center_v = sharks_labeled(shark_index,8);
quiver(shark_center_x,shark_center_y,shark_center_v,shark_center_u,'r');

shark_index = find(sharks_labeled(:,11)>median(angles));
shark_center_x = sharks_labeled(shark_index,5);
shark_center_y = sharks_labeled(shark_index,6);
shark_center_u = sharks_labeled(shark_index,7);
shark_center_v = sharks_labeled(shark_index,8);
quiver(shark_center_x,shark_center_y,shark_center_v,shark_center_u,'b');

%% Save information

xlswrite([save_info_path, '.analyzed.xls'],  sharks_labeled);

print([save_info_path, '.analyzed.png'],'-dpng');

warningMessage = sprintf('Info: Analysis complete. Information stored in:\n%s\n%s\n',[save_info_path, '.analyzed.xls'],[save_info_path, '.analyzed.png']);
uiwait(msgbox(warningMessage,'Analysis successful','help'));


end
