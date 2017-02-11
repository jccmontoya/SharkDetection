function [I,new_row,new_col] = getSubImage(Img, curr_row, curr_col,offset)
% This function returns the current image as well as the initial pixel
% positions
% The function nows overlaps the generated image with the previous one in a
% factor of 1/4 regarding the offset. That is, it overlaps with the left
% and upper images.
    [rows, cols,~] = size(Img);
    
    new_col = curr_col + offset;
    new_row = curr_row;
    if(new_col > cols)
        new_col = 1;
        new_row = curr_row + offset;
    end
    if(new_row > rows)
        I = 0;
    else
        crop_col = new_col - offset/4;
        crop_row = new_row - offset/4;
        offset_col = offset + offset/4;
        offset_row = offset + offset/4;

        if(new_col == 1) 
            crop_col = new_col;
            offset_col = offset;
        end
        if(new_row == 1)
            crop_row = new_row;
            offset_row = offset;
        end
        I = imcrop(Img,[crop_col,crop_row,offset_col,offset_row]);
        
        [crop_row, new_row, crop_col, new_col]
    end
end