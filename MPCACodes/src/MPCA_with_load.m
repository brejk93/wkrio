% funkcja ³aduje obrazy kategoii "faces", dodaje je do macierzy i uruchamia
% algorytm MPCA
function [tUs, odrIdx, TXmean, Wgt] = MPCA_with_load()
    for n = 1:50
        % wyznaczenie œcie¿ki
        if n < 10
            path = strcat('/pictures/faces/image_000', num2str(n), '.jpg');
        else
            path = strcat('/pictures/faces/image_00', num2str(n), '.jpg');
        end;
        % ³adowanie obrazka
        img = imread(path);
        % dodanie do "macierzy"
        if n == 1
            matrix4D = cat(4, img);
        else
            matrix4D = cat(4, matrix4D, img);
        end;
    end;
    [tUs, odrIdx, TXmean, Wgt]  = MPCA(double(matrix4D),1,97,1);
end
