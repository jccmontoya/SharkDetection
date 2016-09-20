function [I,new_row,new_col] = getSubImage(Img, curr_row, curr_col,offset)
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
        I = imcrop(Img,[new_col,new_row,offset,offset]);
    end
end