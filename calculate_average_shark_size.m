function average_size = calculate_average_shark_size(tails_x,tails_y,heads_x,heads_y)

sizes = sqrt((tails_x - heads_x).^2+(tails_y - heads_y).^2);

average_size = median(sizes);

end