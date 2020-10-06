% Game of Life in MATLAB
% Author: Jennefer Maldonado
% Assignment #1
% Date Due: September 18 2020

% set variable Names for alive and dead 
ALIVE = 1;
DEAD = 0;
% original universe board
the_universe = zeros(7,7);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     initialize board    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
the_universe(2,3) = ALIVE;
the_universe(3,4) = ALIVE;
the_universe(4,4) = ALIVE;
the_universe(4,3) = ALIVE;
the_universe(4,2) = ALIVE;
% child board copy of original
the_child = the_universe;
% initialize starting generation
generation = 0;
% loop through as many times as needed (56 as per assignment)
while generation < 57
    % display the board here
    % Reference used for imagesc: 
    % https://www.mathworks.com/help/matlab/ref/imagesc.html
    disp(imagesc(the_universe))
    % used to display for 0.1 seconds
    pause(0.1)
    % only interested in the output here to duplicate
    % for next generation
    [~, the_child] = advance(the_universe, the_child);
    % duplicate for next generation
    the_universe = the_child;
    % increment the generation by 1
    generation = generation+1;
end
    
% Advance the next generation and returns the two boards
% Parameters:
% uni_ori = the original universe that does not change and
% is used to determine neighbors around a cell
% uni_copy = the board that will be changed and is 
% updated as the function executes
% Returns: 
% uni = the original universe
% chld = the next generation that has been produced
function [uni, chld] = advance(uni_ori, uni_copy)
   % find size of board
   [x, y] = size(uni_ori);
   % set values for alive and dead
    ALIVE = 1;
    DEAD = 0;
   % loop through each cell and determine if they 
   % are alive or dead then updates the child board
   % first loop through the rows
   for r = 1:x
       % next loop through the columns
       for c = 1:y
           % get the cell at the row and col specified
           cell = uni_ori(r,c);
           % use the neighbors function to count number of neighbors
           current_neighbors = neighbors(r,c,uni_ori);
           % check if the value at that cell is alive 
           if cell == ALIVE
               % use if statements to determine what rule to follow
               if current_neighbors < 2 
                  uni_copy(r,c) = DEAD;
               elseif current_neighbors == 2 || current_neighbors == 3
                   uni_copy(r,c) = ALIVE;
               elseif current_neighbors > 3 
                   uni_copy(r,c) = DEAD;
               end
           % check if the value at that cell is dead
           elseif cell == DEAD
               % use if statements to determine what rule to follow
               % same as above but rules are for dead cases
               if current_neighbors == 3
                   uni_copy(r,c) = ALIVE;
               else
                  uni_copy(r,c) = DEAD; 
               end %end if
           end %end if
       end % end for
   end % end for
   % return the boards here
   uni = uni_ori;
   chld = uni_copy;
end % end function

% Determines the number of neighbors
% Parameters:
% R = the row index of the cell
% C = the column index of the cell
% board = the board, just for size purposes
% Returns:
% n = number of neighbors
function n = neighbors(R,C,board)
    % set values for alive and dead
    ALIVE = 1;
    DEAD = 0;
    %initialize number of neighbors to 0
    n = 0;
    % get board size to use for bound checking
    [x, y] = size(board);

    % This if statement determines if the cell is a special case
    % If special case assigns specific neighbors
    % If not special case just picks the 4 cells around
    % e.g. corner or boundary cell
    if R == 1 && C == 1 % top right corner
        row_up = R + 1;
        row_dn = x;
        col_rt = C + 1;
        col_lt = y;
    elseif R == 1 && C == y % top left corner
        row_up = R + 1;
        row_dn = x;
        col_rt = 1;
        col_lt = C - 1;
    elseif R == x && C == 1 %bottom right corner
        row_up = 1;
        row_dn = R - 1;
        col_rt = C + 1;
        col_lt = y;
    elseif R == x && C == y % bottom left corner
        row_up = 1;
        row_dn = R-1;
        col_rt = 1;
        col_lt = C - 1;
    % not a corner!
    elseif R == 1 % boundary - first row
        row_up = R + 1;
        row_dn = x;
        col_rt = C + 1;
        col_lt = C - 1;
    elseif C == 1 % boundary - first col
        row_up = R + 1;
        row_dn = R - 1;
        col_rt = C + 1;
        col_lt = y;
    elseif R == x % boundary - last row
        row_up = 1;
        row_dn = R - 1;
        col_rt = C + 1;
        col_lt = C - 1;
    elseif C == y % boundary - last col
        row_up = R + 1;
        row_dn = R - 1;
        col_rt = 1;
        col_lt = C - 1;
    else % not a corner or boundary! (just access cells around)
        row_up = R + 1;
        row_dn = R - 1;
        col_rt = C + 1;
        col_lt = C - 1;
    end % end if
    
    % Eight if statements -- check all 8 boxes around a cell
    % This also takes care of the diagonals
    % Using board_cell to ensure nothing went wrong (e.g. 
    % possible out of bound cell index)
    % for all neighbors in same column
    if board_cell(row_up, C, x, y) && board(row_up, C) == ALIVE
            n = n+1;
    end %end if
    if board_cell(row_dn, C, x, y) && board(row_dn, C) == ALIVE
            n = n+1;
    end %end if
    % for all neighbors in left column
    if board_cell(row_up, col_lt, x, y) && board(row_up, col_lt) == ALIVE
        n = n+1;
    end %end if
    if board_cell(R, col_lt, x, y) && board(R, col_lt) == ALIVE
        n = n+1;
    end %end if
    if board_cell(row_dn, col_lt, x, y) && board(row_dn, col_lt) == ALIVE
        n = n+1;
    end
    % for all neighbors in right column
    if board_cell(row_up, col_rt, x, y) && board(row_up, col_rt) == ALIVE
        n = n+1;
    end %end if
    if board_cell(R, col_rt, x, y) && board(R, col_rt) == ALIVE
        n = n+1;
    end %end if
    if board_cell(row_dn, col_rt, x, y) && board(row_dn, col_rt) == ALIVE
        n = n+1;
    end %end if
end % end function and return n

% Ensures a cell index is on the board (extra boundary checking)
% Parameters:
% row = row index of cell
% col = column index of cel
% x_size = the number of rows in the board
% y_size = the number of columns in the board
% Returns:
% bc = True or False (1 or 0) if the cell is on the board
function bc = board_cell(row, col, x_size, y_size)
    bc = 1; % assume true
    if row > x_size || row <= 0
      bc = 0; %set to false
    end %end if
    if col > y_size || col <= 0
        bc=0; %set to false
    end %end if
end % end function and return bc
