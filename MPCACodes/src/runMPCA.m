function [tUs, odrIdx, TXmean, Wgt, newTraining, training_categories, mdl] = runMPCA()

    [training, test, training_categories, test_categories] = loadData();         % tablica 4-wymiarowa 
    training_N = ndims(training)-1;         % wymiary tensora próbkowego dla zbioru treningowego
    test_N = ndims(test)-1;                 % wymiary tensora próbkowego dla zbioru testowego
    training_Is = size(training);           % rozmiar tablicy z danymi treningowymi(4 wymiary: X x Y x KOLOR x ILOŒÆ_PRÓBEK)
    training_numSpl = training_Is(4);       % iloœæ próbek (250) dla danych treningowych
    test_Is = size(test);                   % rozmiar tablicy z danymi testowych(4 wymiary: X x Y x KOLOR x ILOŒÆ_PRÓBEK)
    test_numSpl = test_Is(4);               % iloœæ próbek (25) dla danych testowych
    [tUs, odrIdx, TXmean, Wgt] = MPCA(training,1,100,1); % wykonanie algorytmu MPCA
    trainingCtr = training-repmat(TXmean,[ones(1,training_N), training_numSpl]);   % centrowanie zbioru treningowego
    testCtr = test-repmat(TXmean,[ones(1,test_N), test_numSpl]);        % centrowanie zbioru testowego
    newTraining = ttm(tensor(trainingCtr),tUs,1:training_N);            % rzutowanie MPCA dla zbioru treningowego(50x64x2x250, czyli ZREDUKOWANE_X x ZREDUKOWANE_Y x ZREDUKOWANY_KOLOR x ILOŒÆ_PRÓBEK)
    newTest = ttm(tensor(testCtr),tUs,1:test_N);                        % rzutowanie MPCA dla zbioru testowego (50x64x2x25), czyli ZREDUKOWANE_X x ZREDUKOWANE_Y x ZREDUKOWANY_KOLOR x ILOŒÆ_PRÓBEK)
 
    % Vectorization of the tensorial feature
    newTrainingDim = size(newTraining,1)*size(newTraining,2)*size(newTraining,3);  % ZREDUKOWANE_X * ZREDUKOWANE_Y * ZREDUKOWANY_KOLOR (6400)
    newTestDim = size(newTest,1)*size(newTest,2)*size(newTest,3);  % ZREDUKOWANE_X * ZREDUKOWANE_Y * ZREDUKOWANY_KOLOR (6400)
    newTraining = reshape(newTraining.data,newTrainingDim,training_numSpl)';      % 250 x 6400 dla klasyfikatora? (Note: Transposed)
    newTest = reshape(newTest.data,newTestDim,test_numSpl)';
    %selData = newData(:,odrIdx(1:6400));                     %Select the first "P" sorted features
    Wgt = reshape(Wgt,newTrainingDim,1);                         %Vectorizing weight tensor
    Wgt = Wgt(odrIdx);                                       %Select the weights accordingly
 
    % klasyfikator
   mdl = fitcknn(newTraining, training_categories);
   %Xnew = [min(newData); mean(newData); max(newData)];
   [label, score, cost] = predict(mdl, newTest);
   accTmp = 0 ;
   cat0 = 0;
   cat1 = 0;
   cat2 = 0;
   cat3 = 0;
   cat4 = 0;
   [x_label_size, y_label_size] = size(label);
   for n=1:x_label_size
      if label(n) == test_categories(n)
          accTmp = accTmp + 1;
      end;
      if test_categories(n) == 0 && label(n) == 0
          cat0 = cat0 + 1;
      elseif test_categories(n) == 1 && label(n) == 1
          cat1 = cat1 + 1;
      elseif test_categories(n) == 2 && label(n) == 2
          cat2 = cat2 + 1;
      elseif test_categories(n) == 3 && label(n) == 3
          cat3 = cat3 + 1;
      elseif test_categories(n) == 4 && label(n) == 4
          cat4 = cat4 + 1;
      end;
   end;
   acc = accTmp/x_label_size;
   test_cat_size = 5;
   strcat('Dok³adnoœæ klasyfikacji:  ', num2str(acc * 100), '%') 
   strcat('Przyporz¹dkowanie do 1 kategorii (motyle):  ', num2str(double(cat0/test_cat_size) * 100), '%') 
   strcat('Przyporz¹dkowanie do 2 kategorii (samochody):  ', num2str(double(cat1/test_cat_size) * 100), '%') 
   strcat('Przyporz¹dkowanie do 3 kategorii (delfiny):  ', num2str(double(cat2/test_cat_size) * 100), '%') 
   strcat('Przyporz¹dkowanie do 4 kategorii (twarze):  ', num2str(double(cat3/test_cat_size) * 100), '%') 
   strcat('Przyporz¹dkowanie do 5 kategorii (motory):  ', num2str(double(cat4/test_cat_size) * 100), '%') 
end
 


