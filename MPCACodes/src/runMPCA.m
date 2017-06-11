function [tUs, odrIdx, TXmean, Wgt, newTraining, training_categories, mdl] = runMPCA()

    [training, test, training_categories, test_categories] = loadData();         % tablica 4-wymiarowa 
    training_N = ndims(training)-1;         % wymiary tensora próbkowego dla zbioru treningowego
    test_N = ndims(test)-1;                 % wymiary tensora próbkowego dla zbioru testowego
    training_Is = size(training);           % rozmiar tablicy z danymi treningowymi(4 wymiary: X x Y x KOLOR x ILOŒÆ_PRÓBEK)
    training_numSpl = training_Is(4);       % iloœæ próbek (250) dla danych treningowych
    test_Is = size(test);                   % rozmiar tablicy z danymi testowych(4 wymiary: X x Y x KOLOR x ILOŒÆ_PRÓBEK)
    test_numSpl = test_Is(4);               % iloœæ próbek (25) dla danych testowych
    [tUs, odrIdx, TXmean, Wgt] = MPCA(training,1,90,1); % wykonanie algorytmu MPCA
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
   
   cat0N = 0; %ilosc elementow, ktore nie naleza do kategorii 0
   cat1N = 0; %ilosc elementow, ktore nie naleza do kategorii 1
   cat2N = 0; %ilosc elementow, ktore nie naleza do kategorii 2
   cat3N = 0; %ilosc elementow, ktore nie naleza do kategorii 3
   cat4N = 0; %ilosc elementow, ktore nie naleza do kategorii 4
   
   cat0P = 0; %ilosc elementow, ktore  naleza do kategorii 1
   cat1P = 0; %ilosc elementow, ktore  naleza do kategorii 2
   cat2P = 0; %ilosc elementow, ktore  naleza do kategorii 3
   cat3P = 0; %ilosc elementow, ktore  naleza do kategorii 4
   cat4P = 0; %ilosc elementow, ktore  naleza do kategorii 5
   
   cat0TN = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako nie nalezace do kategorii 0
   cat1TN = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako nie nalezace do kategorii 1
   cat2TN = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako nie nalezace do kategorii 2
   cat3TN = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako nie nalezace do kategorii 3
   cat4TN = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako nie nalezace do kategorii 4
   
   cat0TP = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako  nalezace do kategorii 0
   cat1TP = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako  nalezace do kategorii 1
   cat2TP= 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako  nalezace do kategorii 2
   cat3TP = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako  nalezace do kategorii 3
   cat4TP = 0; %ilosc elementow, ktore poprawnie sklasyfikowano jako  nalezace do kategorii 4
   
   [x_label_size, y_label_size] = size(label);
   for n=1:x_label_size
     % if label(n) == test_categories(n)
     %      accTmp = accTmp + 1;
     % end;
      if test_categories(n) == 0 
          cat0P = cat0P + 1;
          cat1N = cat1N + 1;
          cat2N = cat2N + 1;
          cat3N = cat3N + 1;
          cat4N = cat4N + 1;
          if label(n) == 0
              cat0TP = cat0TP + 1;
              cat1TN = cat1TN + 1;
              cat2TN = cat2TN + 1;
              cat3TN = cat3TN + 1;
              cat4TN = cat4TN + 1;
          else
              if label(n) ~=  1
              cat1TN = cat1TN + 1;
              end;
              if label(n) ~=   2
              cat2TN = cat2TN + 1;
              end;
              if label(n) ~=  3
              cat3TN = cat3TN + 1;
              end;
              if label(n) ~=   4
              cat4TN = cat4TN + 1;
              end;
          end;
      elseif test_categories(n) == 1 
          cat1P = cat1P + 1;
          cat0N = cat0N + 1;
          cat2N = cat2N + 1;
          cat3N = cat3N + 1;
          cat4N = cat4N + 1;
          if label(n) == 1
              cat1TP = cat1TP + 1;
              cat0TN = cat0TN + 1;
              cat2TN = cat2TN + 1;
              cat3TN = cat3TN + 1;
              cat4TN = cat4TN + 1;
           else
              if label(n) ~=  0
              cat0TN = cat0TN + 1;
              end;
              if label(n) ~=   2
              cat2TN = cat2TN + 1;
              end;
              if label(n) ~=  3
              cat3TN = cat3TN + 1;
              end;
              if label(n) ~=   4
              cat4TN = cat4TN + 1;
              end;
          end;
      elseif test_categories(n) == 2 
          cat2P = cat2P + 1;
          cat1N = cat1N + 1;
          cat0N = cat0N + 1;
          cat3N = cat3N + 1;
          cat4N = cat4N + 1;
          if label(n) == 2
              cat2TP = cat2TP + 1;
              cat1TN = cat1TN + 1;
              cat0TN = cat0TN + 1;
              cat3TN = cat3TN + 1;
              cat4TN = cat4TN + 1;
          else
              if label(n) ~=  1
              cat1TN = cat1TN + 1;
              end;
              if label(n) ~=   0
              cat0TN = cat0TN + 1;
              end;
              if label(n) ~=  3
              cat3TN = cat3TN + 1;
              end;
              if label(n) ~=   4
              cat4TN = cat4TN + 1;
              end;
          end;
      elseif test_categories(n) == 3
          cat3P = cat3P + 1;
          cat1N = cat1N + 1;
          cat2N = cat2N + 1;
          cat0N = cat0N + 1;
          cat4N = cat4N + 1;
          if label(n) == 3
              cat3TP = cat3TP + 1;
              cat1TN = cat1TN + 1;
              cat2TN = cat2TN + 1;
              cat0TN = cat0TN + 1;
              cat4TN = cat4TN + 1;
          else
              if label(n) ~=  1
              cat1TN = cat1TN + 1;
              end;
              if label(n) ~=  2
              cat2TN = cat2TN + 1;
              end;
              if label(n) ~=  0
              cat0TN = cat0TN + 1;
              end;
              if label(n) ~=   4
              cat4TN = cat4TN + 1;
              end;
          end;
      elseif test_categories(n) == 4 
          cat4P = cat4P + 1;
          cat1N = cat1N + 1;
          cat2N = cat2N + 1;
          cat3N = cat3N + 1;
          cat0N = cat0N + 1;
          if label(n) == 4
              cat4TP = cat4TP + 1;
              cat1TN = cat1TN + 1;
              cat2TN = cat2TN + 1;
              cat3TN = cat3TN + 1;
              cat0TN = cat0TN + 1;
         else
              if label(n) ~=  1
              cat1TN = cat1TN + 1;
              end;
              if label(n) ~=  2
              cat2TN = cat2TN + 1;
              end;
              if label(n) ~=  3
              cat3TN = cat3TN + 1;
              end;
              if label(n) ~=   0
              cat0TN = cat0TN + 1;
              end;
          end;
      end;
   end;
   acc = accTmp/x_label_size;
  % strcat('Dokladnosc klasyfikacji:  ', num2str(acc * 100), '%') 
   strcat('Czu³oœæ klasyfikacji:  ', num2str((cat0TP + cat1TP + cat2TP + cat3TP + cat4TP)/(cat0P + cat1P + cat2P + cat3P + cat4P) * 100), '%') 
   strcat('Czu³oœæ dla 1 kategorii (motyle):  ', num2str(double(cat0TP/cat0P) * 100), '%') 
   strcat('Czu³oœæ dla  2 kategorii (samochody):  ', num2str(double(cat1TP/cat1P) * 100), '%') 
   strcat('Czu³oœæ dla  3 kategorii (delfiny):  ', num2str(double(cat2TP/cat2P) * 100), '%') 
   strcat('Czu³oœæ dla  4 kategorii (twarze):  ', num2str(double(cat3TP/cat3P) * 100), '%') 
   strcat('Czu³oœæ dla  5 kategorii (motory):  ', num2str(double(cat4TP/cat4P) * 100), '%') 
   strcat('Specyficznoœæ klasyfikacji:  ', num2str((cat0TN + cat1TN + cat2TN + cat3TN + cat4TN)/(cat0N + cat1N + cat2N + cat3N + cat4N) * 100), '%') 
   strcat('Specyficznoœæ dla 1 kategorii (motyle):  ', num2str(double(cat0TN/cat0N) * 100), '%') 
   strcat('Specyficznoœæ dla  2 kategorii (samochody):  ', num2str(double(cat1TN/cat1N) * 100), '%') 
   strcat('Specyficznoœæ dla  3 kategorii (delfiny):  ', num2str(double(cat2TN/cat2N) * 100), '%') 
   strcat('Specyficznoœæ dla  4 kategorii (twarze):  ', num2str(double(cat3TN/cat3N) * 100), '%') 
   strcat('Specyficznoœæ dla  5 kategorii (motory):  ', num2str(double(cat4TN/cat4N) * 100), '%') 
end
 


