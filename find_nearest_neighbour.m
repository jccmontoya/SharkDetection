function [neighbour_index,distance] = find_nearest_neighbour(points_x, points_y)

sqew        = length(points_x);
neighbour_index = zeros(sqew,1);
distance        = zeros(sqew,1);

for i = 1:sqew
    px = points_x(i);
    py = points_y(i);
    matching_points_x = [points_x(1:i-1);points_x(i+1:end)];
    matching_points_y = [points_y(1:i-1);points_y(i+1:end)];
    [~, dist] = knnsearch([px,py],[matching_points_x,matching_points_y],'Distance', 'Euclidean');
    distance(i) = min(dist);
    dist_index =  find(dist == min(dist));
    
   i1 =  find(points_x == matching_points_x(dist_index));
   i2 =  find(points_y == matching_points_y(dist_index));
    neighbour_index(i) = intersect(i1,i2);
   
end
end

