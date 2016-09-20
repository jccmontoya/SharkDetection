function printVectors(I,vectors,offset_x,offset_y)

    close all;
    imagesc(I);axis equal;axis tight
    hold on;
    
    quiver(vectors(:,5)+offset_x,vectors(:,6)+offset_y,vectors(:,8),vectors(:,7),0.5);
end