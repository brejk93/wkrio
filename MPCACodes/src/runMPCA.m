function [tUs, odrIdx, TXmean, Wgt] = runMPCA()
    data = loadData();         % tablica 4-wymiarowa 
    N = ndims(data)-1;         % wymiary tensora próbkowego
    Is = size(data);           % rozmiar tablicy z danymi (4 wymiary: X x Y x KOLOR x ILOŒÆ_PRÓBEK)
    numSpl = Is(4);            % iloœæ próbek (250)
    [tUs, odrIdx, TXmean, Wgt] = MPCA(data,1,97,1);
    dataCtr = data-repmat(TXmean,[ones(1,N), numSpl]);   % centering
    newData = ttm(tensor(dataCtr),tUs,1:N);              % rzutowanie MPCA (50x64x2x250, czyli ZREDUKOWANE_X x ZREDUKOWANE_Y x ZREDUKOWANY_KOLOR x ILOŒÆ_PRÓBEK)

    % Vectorization of the tensorial feature
    newDataDim = size(newData,1)*size(newData,2)*size(newData,3);  % ZREDUKOWANE_X * ZREDUKOWANE_Y * ZREDUKOWANY_KOLOR (6400)
    newData = reshape(newData.data,newDataDim,numSpl)';      % 250 x 6400 dla klasyfikatora? (Note: Transposed)
    %selData = newData(:,odrIdx(1:6400));                       %Select the first "P" sorted features
    Wgt = reshape(Wgt,newDataDim,1);                         %Vectorizing weight tensor
    Wgt = Wgt(odrIdx);                                       %Select the weights accordingly

    % klasyfikator
end

