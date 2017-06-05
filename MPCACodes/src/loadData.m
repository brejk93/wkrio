function [ training4D, test4D, training_categories , test_categories] = loadData()
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
            training4D = cat(4, img1, img2, img3,img4, img5);
        else
            training4D = cat(4, training4D, img1, img2, img3,img4, img5);
        end;
    end;
    for n = 1:250
        id= (mod(n-1, 5));
        if n == 1
            training_categories = [id];
        else
            training_categories = [training_categories id];
        end;
    end;
    for n = 51:55
        path1 = strcat('pictures/butterfly_test','/image_00', num2str(n), '.jpg');
        path2 = strcat('pictures/car_sid_test','/image_00', num2str(n), '.jpg');
        path3 = strcat('pictures/dolphin_test','/image_00', num2str(n), '.jpg');
        path4 = strcat('pictures/faces_test','/image_00', num2str(n), '.jpg');
        path5 = strcat('pictures/motorbikes_test','/image_00', num2str(n), '.jpg');
        img1 = imread(path1);
        img2 = imread(path2);
        img3 = imread(path3);
        img4 = imread(path4);
        img5 = imread(path5);
        if n == 51
            test4D = cat(4, img1, img2, img3,img4, img5);
        else
            test4D = cat(4, test4D, img1, img2, img3,img4, img5);
        end;
    end;
    for n = 1:250
        id= (mod(n-1, 5));
        if n == 1
            test_categories = [id];
        else
            test_categories = [test_categories id];
        end;
    end;
    training4D = double(training4D);
    test4D = double(test4D);
end