function angles = find_neighbour_angle(points_u, points_v, neighs_u, neighs_v)
% Returns the angle (in degrees) betweeen two input vectors.
%   Input vectors are described with 4 variables (v1_u,v1_v,v2_u,v2_v)

% Dimensionality of the original space is irrelevant. As long as
% norm(a)*norm(b) > 0, the vectors uniquely define a 2-d space when
% dot(a,b) ~= 0 and a unique 1-d space otherwise.

angles = zeros(length(points_u),1);

for i=1:length(points_u)
costheta = dot([points_u(i),points_v(i)],[neighs_u(i),neighs_v(i)],2) ./ ...
            (norm([points_u(i),points_v(i)]).*norm([neighs_u(i),neighs_v(i)]));
angles(i) =acosd(costheta);
end

end

