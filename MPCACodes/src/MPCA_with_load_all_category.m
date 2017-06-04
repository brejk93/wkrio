function [faces_tUs, faces_odrIdx, faces_TXmean, faces_Wgt, dolphin_tUs, dolphin_odrIdx, dolphin_TXmean, dolphin_Wgt, butterfly_tUs, butterfly_odrIdx, butterfly_TXmean, butterfly_Wgt, car_sid_tUs, car_sid_odrIdx, car_sid_TXmean, car_sid_Wgt, motorbikes_tUs, motorbikes_odrIdx, motorbikes_TXmean, motorbikes_Wgt] = MPCA_with_load_all_category()
    [faces_tUs, faces_odrIdx, faces_TXmean, faces_Wgt] = MPCA_with_load('faces',1);
    [dolphin_tUs, dolphin_odrIdx, dolphin_TXmean, dolphin_Wgt] = MPCA_with_load('dolphin',2);    
    [butterfly_tUs, butterfly_odrIdx, butterfly_TXmean, butterfly_Wgt] = MPCA_with_load('butterfly',3);    
    [car_sid_tUs, car_sid_odrIdx, car_sid_TXmean, car_sid_Wgt] = MPCA_with_load('car_sid', 4);
    [motorbikes_tUs, motorbikes_odrIdx, motorbikes_TXmean, motorbikes_Wgt] = MPCA_with_load('motorbikes',5);
end

