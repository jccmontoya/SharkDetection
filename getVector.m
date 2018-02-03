function [x,y,u,v] = getVector(start_point,end_point)
mid_point = (start_point + end_point)/2;
inc = end_point - start_point;
x=mid_point(:,1);
y=mid_point(:,2);
u = inc(:,2);
v = inc(:,1);
end