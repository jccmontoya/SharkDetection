clear all
load('labelled_sharks3');
% 
% % sharks_labelled variable contains 8 fields:
% % shark_tail(x,y)
% % shark_head(x,y)
% % central point(x,y)
% % vector(u,v)
% 
central_points_x = sharks_labelled(:,5);
central_points_y = sharks_labelled(:,6);

%% Calculate average size (in pixels)

tails_x = sharks_labelled(:,1);
tails_y = sharks_labelled(:,2);
heads_x = sharks_labelled(:,3);
heads_y = sharks_labelled(:,4);

average_size = calculate_average_shark_size(tails_x,tails_y,heads_x,heads_y);

%% Calculate nearest neighbour to each shark detection and append to the' sharks_labelled' matrix

plot(central_points_x,central_points_y,'*');axis equal; axis tight;  %axis([0,13,0,13])
[nneighbours_index, distance] = find_nearest_neighbour(central_points_x,central_points_y);

% Appending nearest neighbour index and distance to each item in sharks_labelled
sharks_labelled = [sharks_labelled , nneighbours_index, distance];

%% Calculate the angle between neighbours

shark_u = sharks_labelled(:,7);
shark_v = sharks_labelled(:,8);

neighbours_sorted = sharks_labelled(sharks_labelled(:,9),:);
neighbours_u = neighbours_sorted(:,7);
neighbours_v = neighbours_sorted(:,8);

angles = find_neighbour_angle(shark_u,shark_v,neighbours_u,neighbours_v);

% Appending angle towards nearest neighbour
sharks_labelled = [sharks_labelled , angles];
%% Plot sharks according to distance to nearest neighbour

% If distance to the nearest neighbour is <= 2*average (median) size paint 
% shark in red, otherwise, paing it in blue

close all;
imagesc(shark_img); hold on; axis equal; axis tight;
shark_index = find(sharks_labelled(:,10)<=average_size*2)

shark_center_x = sharks_labelled(shark_index,5);
shark_center_y = sharks_labelled(shark_index,6);
plot(shark_center_x+rect(1),shark_center_y+rect(2),'r*');

shark_index = find(sharks_labelled(:,10)>average_size*2)
shark_center_x = sharks_labelled(shark_index,5);
shark_center_y = sharks_labelled(shark_index,6);
plot(shark_center_x+rect(1),shark_center_y+rect(2),'b*');

%% Plot sharks accorging to alignment to nearest neighbour

% Red vectors for angles below the median and blue for those above

shark_index = find(sharks_labelled(:,11)<=median(angles));
shark_center_x = sharks_labelled(shark_index,5);
shark_center_y = sharks_labelled(shark_index,6);
shark_center_u = sharks_labelled(shark_index,7);
shark_center_v = sharks_labelled(shark_index,8);
quiver(shark_center_x+rect(1),shark_center_y+rect(2),shark_center_v,shark_center_u,'r');

shark_index = find(sharks_labelled(:,11)>median(angles));
shark_center_x = sharks_labelled(shark_index,5);
shark_center_y = sharks_labelled(shark_index,6);
shark_center_u = sharks_labelled(shark_index,7);
shark_center_v = sharks_labelled(shark_index,8);
quiver(shark_center_x+rect(1),shark_center_y+rect(2),shark_center_v,shark_center_u,'b');


