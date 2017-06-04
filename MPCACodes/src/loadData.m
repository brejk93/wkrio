function [ vector4D ] = loadData()
    for n = 1:50
        % wyznaczenie œcie¿ki
        if n < 10
            path1 = strcat('pictures/butterfly','/image_000', num2str(n), '.jpg');
            path2 = strcat('pictures/car_sid','/image_000', num2str(n), '.jpg');
            path3 = strcat('pictures/dolphin','/image_000', num2str(n), '.jpg');
            path4 = strcat('pictures/faces','/image_000', num2str(n), '.jpg');
            path5 = strcat('pictures/motorbikes','/image_000', num2str(n), '.jpg');
        else
            path1 = strcat('pictures/butterfly','/image_00', num2str(n), '.jpg');
            path2 = strcat('pictures/car_sid','/image_00', num2str(n), '.jpg');
            path3 = strcat('pictures/dolphin','/image_00', num2str(n), '.jpg');
            path4 = strcat('pictures/faces','/image_00', num2str(n), '.jpg');
            path5 = strcat('pictures/motorbikes','/image_00', num2str(n), '.jpg');
        end;
        % ³adowanie obrazka
        img1 = imread(path1);
        img2 = imread(path2);
        img3 = imread(path3);
        img4 = imread(path4);
        img5 = imread(path5);
        % dodanie do "macierzy"
        if n == 1
            matrix4D = cat(4, img1, img2, img3,img4, img5);
        else
            matrix4D = cat(4, matrix4D, img1, img2, img3,img4, img5);
        end;
    end;
    vector4D = double(matrix4D);

end

