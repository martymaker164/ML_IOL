%% Current file location directory change 
editor_service = com.mathworks.mlservices.MLEditorServices;
editor_app = editor_service.getEditorApplication;
active_editor = editor_app.getActiveEditor;
storage_location = active_editor.getStorageLocation;
file = char(storage_location.getFile);
path = fileparts(file);
cd(path);  
%% Workspace initialization
clc;
clear all;
close all;
% Source data file load & data preparation
load IOL_Report_ANN.mat
%%  Data normalization
% Selection set
[KMIM_tr, KMIM_tr_ps] = mapminmax(IOLReportANNTrain.KMIM');
[ACDIM_tr, ACDIM_tr_ps] = mapminmax(IOLReportANNTrain.ACDIM');
[ALIM_tr, ALIM_tr_ps] = mapminmax(IOLReportANNTrain.ALIM');
[dSFEqAR_pre_tr, dSFEqAR_pre_tr_ps] = mapminmax(IOLReportANNTrain.dSFEqAR_pre');
[IOLteorGoodRef_tr, IOLteorGoodRef_tr_ps] = mapminmax(IOLReportANNTrain.IOLteorGoodRef');
[Age_tr, Age_tr_ps] = mapminmax(IOLReportANNTrain.Age');
% Verification set
KMIM_ts = mapminmax('apply',IOLReportANNTest.KMIM', KMIM_tr_ps);
ACDIM_ts = mapminmax('apply',IOLReportANNTest.ACDIM', ACDIM_tr_ps);
ALIM_ts = mapminmax('apply',IOLReportANNTest.ALIM', ALIM_tr_ps);
dSFEqAR_pre_ts = mapminmax('apply',IOLReportANNTest.dSFEqAR_pre',dSFEqAR_pre_tr_ps);
Age_ts = mapminmax('apply',IOLReportANNTest.Age', Age_tr_ps);
% Input and target for training
InputVectorTrain = [KMIM_tr; ACDIM_tr; ALIM_tr; Age_tr; dSFEqAR_pre_tr; IOLteorGoodRef_tr];
[TargetVector, ts] = mapminmax(IOLReportANNTrain.IOLteorGood'); %TargetVector norm
% Input, Verification set
InputVectorTestEme = [KMIM_ts; ACDIM_ts; ALIM_ts; Age_ts; dSFEqAR_pre_ts; zeros(height(IOLReportANNTest),1)'];
InputVectorTrain_2 = [KMIM_tr; ACDIM_tr; ALIM_tr; Age_tr; dSFEqAR_pre_tr; IOLteorGoodRef_tr; TargetVector];
%% Model init
[Model, RMSE, MSE] = SVMTrainRegressionModel(InputVectorTrain_2);
ANNSim = Model.predictFcn(InputVectorTestEme);
ANNSim = mapminmax('reverse',ANNSim, ts);
IOLdiffANN = IOLReportANNTest.IOLImplanted - ANNSim;
dSFEqTestAR = IOLReportANNTest.dSFEqAR; 
dSFEqTestANN = ((IOLdiffANN/0.5).* IOLReportANNTest.IOL05teorDiff) + dSFEqTestAR;
IOLsim = ANNSim;
ALL_ANN = dSFEqTestANN;
SMALL_ANN = dSFEqTestANN(IOLReportANNTest.ALIM < 22.01);
LONG_ANN = dSFEqTestANN(IOLReportANNTest.ALIM >= 24);
NORMAL_ANN = dSFEqTestANN((IOLReportANNTest.ALIM >= 22.01) & (IOLReportANNTest.ALIM < 24));
ALL_AR = dSFEqTestAR;
SMALL_AR = dSFEqTestAR(IOLReportANNTest.ALIM < 22.01);
LONG_AR = dSFEqTestAR(IOLReportANNTest.ALIM >= 24);
NORMAL_AR = dSFEqTestAR((IOLReportANNTest.ALIM >= 22.01) & (IOLReportANNTest.ALIM < 24));
ALL_ANN_res = ALL_ANN;
SMALL_ANN_res = SMALL_ANN;
LONG_ANN_res = LONG_ANN;
NORMAL_ANN_res = NORMAL_ANN;
ALL_AR_res = ALL_AR;
SMALL_AR_res = SMALL_AR;
LONG_AR_res = LONG_AR;
NORMAL_AR_res = NORMAL_AR;

%% 
ALL_ANN_resM = (ALL_ANN_res);
SMALL_ANN_resM = (SMALL_ANN_res);
NORMAL_ANN_resM = (NORMAL_ANN_res);
LONG_ANN_resM = (LONG_ANN_res);

ALL_AR_resM = (ALL_AR_res);
SMALL_AR_resM = (SMALL_AR_res);
NORMAL_AR_resM = (NORMAL_AR_res);
LONG_AR_resM = (LONG_AR_res);

%% ALL Eyes ANN and AR
%fprintf(['ALL Eyes \n'])
Mean_ALL_ANN =  mean(ALL_ANN_resM);
MeanAbs_ALL_ANN =  mean(abs(ALL_ANN_resM));
Median_ALL_ANN =  median(abs(ALL_ANN_resM));
std_ALL_ANN =  std(ALL_ANN_resM);
min_ALL_ANN =  min(ALL_ANN_resM);
max_ALL_ANN =  max(ALL_ANN_resM);
In025_ALL_ANN = 100/length(ALL_ANN_resM)*length(ALL_ANN_resM(ALL_ANN_resM>=-0.25 & ALL_ANN_resM<=0.25));
In050_ALL_ANN = 100/length(ALL_ANN_resM)*length(ALL_ANN_resM(ALL_ANN_resM>=-0.5 & ALL_ANN_resM<=0.5));
In075_ALL_ANN = 100/length(ALL_ANN_resM)*length(ALL_ANN_resM(ALL_ANN_resM>=-0.75 & ALL_ANN_resM<=0.75));
In100_ALL_ANN = 100/length(ALL_ANN_resM)*length(ALL_ANN_resM(ALL_ANN_resM>=-1 & ALL_ANN_resM<=1));

Mean_ALL_AR =  mean(ALL_AR_resM);
MeanAbs_ALL_AR =  mean(abs(ALL_AR_resM));
Median_ALL_AR =  median(abs(ALL_AR_resM));
std_ALL_AR =  std(ALL_AR_resM);
min_ALL_AR =  min(ALL_AR_resM);
max_ALL_AR =  max(ALL_AR_resM);
In025_ALL_AR = 100/length(ALL_AR_resM)*length(ALL_AR_resM(ALL_AR_resM>=-0.25 & ALL_AR_resM<=0.25));
In050_ALL_AR = 100/length(ALL_AR_resM)*length(ALL_AR_resM(ALL_AR_resM>=-0.5 & ALL_AR_resM<=0.5));
In075_ALL_AR = 100/length(ALL_AR_resM)*length(ALL_AR_resM(ALL_AR_resM>=-0.75 & ALL_AR_resM<=0.75));
In100_ALL_AR = 100/length(ALL_AR_resM)*length(ALL_AR_resM(ALL_AR_resM>=-1 & ALL_AR_resM<=1));

% Refractive/IOL prediction error is significantly different from zero
Wilcoxon_MAE_AR_p_ALL = signrank(ALL_AR_resM);
Wilcoxon_MAE_ANN_p_ALL = signrank(ALL_ANN_resM);
%[W_AR_H ttest_MAE_AR_p_ALL] = ttest(ALL_AR_resM);
%[W_ANN_H ttest_MAE_ANN_p_ALL] = ttest(ALL_ANN_resM);
ME_p_ALL = strcat({'Real: '},num2str(Wilcoxon_MAE_AR_p_ALL),{'; '},{'Prediction: '},num2str(Wilcoxon_MAE_ANN_p_ALL));

% Difference in absolute prediction errors between IOL calculation formulas
Wilcoxon_MAE_p_ALL = ranksum(ALL_AR_resM, ALL_ANN_resM);

%% In025
ANN_in_025_cnt_ALL = abs(ALL_ANN_resM) <= 0.25;
AR_in_025_cnt_ALL = abs(ALL_AR_resM) <= 0.25;
in_025_ALL = [AR_in_025_cnt_ALL'; ANN_in_025_cnt_ALL']';
in_025_11_ALL = length(in_025_ALL(in_025_ALL(:,1)==1 & in_025_ALL(:,2)==1));
in_025_10_ALL = length(in_025_ALL(in_025_ALL(:,1)==1 & in_025_ALL(:,2)==0));
in_025_01_ALL = length(in_025_ALL(in_025_ALL(:,1)==0 & in_025_ALL(:,2)==1));
in_025_00_ALL = length(in_025_ALL(in_025_ALL(:,1)==0 & in_025_ALL(:,2)==0));
p_in_025_ALL = mcn([in_025_11_ALL in_025_10_ALL; in_025_01_ALL in_025_00_ALL]);

%% In050
ANN_in_050_cnt_ALL = abs(ALL_ANN_resM) <= 0.50;
AR_in_050_cnt_ALL = abs(ALL_AR_resM) <= 0.50;
in_050_ALL = [AR_in_050_cnt_ALL'; ANN_in_050_cnt_ALL']';
in_050_11_ALL = length(in_050_ALL(in_050_ALL(:,1)==1 & in_050_ALL(:,2)==1));
in_050_10_ALL = length(in_050_ALL(in_050_ALL(:,1)==1 & in_050_ALL(:,2)==0));
in_050_01_ALL = length(in_050_ALL(in_050_ALL(:,1)==0 & in_050_ALL(:,2)==1));
in_050_00_ALL = length(in_050_ALL(in_050_ALL(:,1)==0 & in_050_ALL(:,2)==0));
p_in_050_ALL = mcn([in_050_11_ALL in_050_10_ALL; in_050_01_ALL in_050_00_ALL]);

% In075
ANN_in_075_cnt_ALL = abs(ALL_ANN_resM) <= 0.75;
AR_in_075_cnt_ALL = abs(ALL_AR_resM) <= 0.75;
in_075_ALL = [AR_in_075_cnt_ALL'; ANN_in_075_cnt_ALL']';
in_075_11_ALL = length(in_075_ALL(in_075_ALL(:,1)==1 & in_075_ALL(:,2)==1));
in_075_10_ALL = length(in_075_ALL(in_075_ALL(:,1)==1 & in_075_ALL(:,2)==0));
in_075_01_ALL = length(in_075_ALL(in_075_ALL(:,1)==0 & in_075_ALL(:,2)==1));
in_075_00_ALL = length(in_075_ALL(in_075_ALL(:,1)==0 & in_075_ALL(:,2)==0));
p_in_075_ALL = mcn([in_075_11_ALL in_075_10_ALL; in_075_01_ALL in_075_00_ALL]);

% In100
ANN_in_100_cnt_ALL = abs(ALL_ANN_resM) <= 1.00;
AR_in_100_cnt_ALL = abs(ALL_AR_resM) <= 1.00;
in_100_ALL = [AR_in_100_cnt_ALL'; ANN_in_100_cnt_ALL']';
in_100_11_ALL = length(in_100_ALL(in_100_ALL(:,1)==1 & in_100_ALL(:,2)==1));
in_100_10_ALL = length(in_100_ALL(in_100_ALL(:,1)==1 & in_100_ALL(:,2)==0));
in_100_01_ALL = length(in_100_ALL(in_100_ALL(:,1)==0 & in_100_ALL(:,2)==1));
in_100_00_ALL = length(in_100_ALL(in_100_ALL(:,1)==0 & in_100_ALL(:,2)==0));
p_in_100_ALL = mcn([in_100_11_ALL in_100_10_ALL; in_100_01_ALL in_100_00_ALL]);

RowNameWho = {'ME',...
              'MAE',...
              'MedAE'...
              'Std',...
              'Min',...
              'Max',...
              'Eyes within PE (%)',...
              '±0,25',...
              '±0,50',...
              '±0,75',...
              '±1,00',...
           };
AllEyes = table(...
               [Mean_ALL_AR; MeanAbs_ALL_AR; Median_ALL_AR; std_ALL_AR; min_ALL_AR; max_ALL_AR;666 ;In025_ALL_AR; In050_ALL_AR; In075_ALL_AR; In100_ALL_AR],...
               [Mean_ALL_ANN; MeanAbs_ALL_ANN; Median_ALL_ANN; std_ALL_ANN; min_ALL_ANN; max_ALL_ANN;666 ;In025_ALL_ANN; In050_ALL_ANN; In075_ALL_ANN; In100_ALL_ANN],...
               [ME_p_ALL;Wilcoxon_MAE_p_ALL;666;666;666;666;666;p_in_025_ALL;p_in_050_ALL;p_in_075_ALL;p_in_100_ALL],...
               'RowNames',RowNameWho);
AllEyes.Properties.VariableNames = {'Real_results' 'Prediction_result' 'P_value'};               
%writetable(AllEyes,'resources\Table.xlsx','Sheet','ALL','Range','A1','WriteRowNames',true);

%% SMALL Eyes ANN and AR
%fprintf(['SMALL Eyes \n'])
Mean_SMALL_ANN =  mean(SMALL_ANN_resM);
MeanAbs_SMALL_ANN =  mean(abs(SMALL_ANN_resM));
Median_SMALL_ANN =  median(abs(SMALL_ANN_resM));
std_SMALL_ANN =  std(SMALL_ANN_resM);
min_SMALL_ANN =  min(SMALL_ANN_resM);
max_SMALL_ANN =  max(SMALL_ANN_resM);
In025_SMALL_ANN = 100/length(SMALL_ANN_resM)*length(SMALL_ANN_resM(SMALL_ANN_resM>=-0.25 & SMALL_ANN_resM<=0.25));
In050_SMALL_ANN = 100/length(SMALL_ANN_resM)*length(SMALL_ANN_resM(SMALL_ANN_resM>=-0.5 & SMALL_ANN_resM<=0.5));
In075_SMALL_ANN = 100/length(SMALL_ANN_resM)*length(SMALL_ANN_resM(SMALL_ANN_resM>=-0.75 & SMALL_ANN_resM<=0.75));
In100_SMALL_ANN = 100/length(SMALL_ANN_resM)*length(SMALL_ANN_resM(SMALL_ANN_resM>=-1 & SMALL_ANN_resM<=1));

Mean_SMALL_AR =  mean(SMALL_AR_resM);
MeanAbs_SMALL_AR =  mean(abs(SMALL_AR_resM));
Median_SMALL_AR =  median(abs(SMALL_AR_resM));
std_SMALL_AR =  std(SMALL_AR_resM);
min_SMALL_AR =  min(SMALL_AR_resM);
max_SMALL_AR =  max(SMALL_AR_resM);
In025_SMALL_AR = 100/length(SMALL_AR_resM)*length(SMALL_AR_resM(SMALL_AR_resM>=-0.25 & SMALL_AR_resM<=0.25));
In050_SMALL_AR = 100/length(SMALL_AR_resM)*length(SMALL_AR_resM(SMALL_AR_resM>=-0.5 & SMALL_AR_resM<=0.5));
In075_SMALL_AR = 100/length(SMALL_AR_resM)*length(SMALL_AR_resM(SMALL_AR_resM>=-0.75 & SMALL_AR_resM<=0.75));
In100_SMALL_AR = 100/length(SMALL_AR_resM)*length(SMALL_AR_resM(SMALL_AR_resM>=-1 & SMALL_AR_resM<=1));

% Refractive/IOL prediction error is significantly different from zero
Wilcoxon_MAE_AR_p_SMALL = signrank(SMALL_AR_resM);
Wilcoxon_MAE_ANN_p_SMALL = signrank(SMALL_ANN_resM);
%[W_AR_H ttest_MAE_AR_p_SMALL] = ttest(SMALL_AR_resM);
%[W_ANN_H ttest_MAE_ANN_p_SMALL] = ttest(SMALL_ANN_resM);
ME_p_SMALL = strcat({'Real: '},num2str(Wilcoxon_MAE_AR_p_SMALL),{'; '},{'Prediction: '},num2str(Wilcoxon_MAE_ANN_p_SMALL));

% Difference in absolute prediction errors between IOL calculation formulas
Wilcoxon_MAE_p_SMALL = ranksum(SMALL_AR_resM, SMALL_ANN_resM);

% In025
ANN_in_025_cnt_SMALL = abs(SMALL_ANN_resM) <= 0.25;
AR_in_025_cnt_SMALL = abs(SMALL_AR_resM) <= 0.25;
in_025_SMALL = [AR_in_025_cnt_SMALL'; ANN_in_025_cnt_SMALL']';
in_025_11_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==1 & in_025_SMALL(:,2)==1));
in_025_10_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==1 & in_025_SMALL(:,2)==0));
in_025_01_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==0 & in_025_SMALL(:,2)==1));
in_025_00_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==0 & in_025_SMALL(:,2)==0));
p_in_025_SMALL = mcn([in_025_11_SMALL in_025_10_SMALL; in_025_01_SMALL in_025_00_SMALL]);

% In050
ANN_in_050_cnt_SMALL = abs(SMALL_ANN_resM) <= 0.50;
AR_in_050_cnt_SMALL = abs(SMALL_AR_resM) <= 0.50;
in_050_SMALL = [AR_in_050_cnt_SMALL'; ANN_in_050_cnt_SMALL']';
in_050_11_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==1 & in_050_SMALL(:,2)==1));
in_050_10_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==1 & in_050_SMALL(:,2)==0));
in_050_01_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==0 & in_050_SMALL(:,2)==1));
in_050_00_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==0 & in_050_SMALL(:,2)==0));
p_in_050_SMALL = mcn([in_050_11_SMALL in_050_10_SMALL; in_050_01_SMALL in_050_00_SMALL]);

% In075
ANN_in_075_cnt_SMALL = abs(SMALL_ANN_resM) <= 0.75;
AR_in_075_cnt_SMALL = abs(SMALL_AR_resM) <= 0.75;
in_075_SMALL = [AR_in_075_cnt_SMALL'; ANN_in_075_cnt_SMALL']';
in_075_11_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==1 & in_075_SMALL(:,2)==1));
in_075_10_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==1 & in_075_SMALL(:,2)==0));
in_075_01_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==0 & in_075_SMALL(:,2)==1));
in_075_00_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==0 & in_075_SMALL(:,2)==0));
p_in_075_SMALL = mcn([in_075_11_SMALL in_075_10_SMALL; in_075_01_SMALL in_075_00_SMALL]);

% In100
ANN_in_100_cnt_SMALL = abs(SMALL_ANN_resM) <= 1.00;
AR_in_100_cnt_SMALL = abs(SMALL_AR_resM) <= 1.00;
in_100_SMALL = [AR_in_100_cnt_SMALL'; ANN_in_100_cnt_SMALL']';
in_100_11_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==1 & in_100_SMALL(:,2)==1));
in_100_10_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==1 & in_100_SMALL(:,2)==0));
in_100_01_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==0 & in_100_SMALL(:,2)==1));
in_100_00_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==0 & in_100_SMALL(:,2)==0));
p_in_100_SMALL = mcn([in_100_11_SMALL in_100_10_SMALL; in_100_01_SMALL in_100_00_SMALL]);

RowNameWho = {'ME',...
              'MAE',...
              'MedAE'...
              'Std',...
              'Min',...
              'Max',...
              'Eyes within PE (%)',...
              '±0,25',...
              '±0,50',...
              '±0,75',...
              '±1,00',...
           };
SMALLEyes = table(...
               [Mean_SMALL_AR; MeanAbs_SMALL_AR; Median_SMALL_AR; std_SMALL_AR; min_SMALL_AR; max_SMALL_AR;666 ;In025_SMALL_AR; In050_SMALL_AR; In075_SMALL_AR; In100_SMALL_AR],...
               [Mean_SMALL_ANN; MeanAbs_SMALL_ANN; Median_SMALL_ANN; std_SMALL_ANN; min_SMALL_ANN; max_SMALL_ANN;666 ;In025_SMALL_ANN; In050_SMALL_ANN; In075_SMALL_ANN; In100_SMALL_ANN],...
               [ME_p_SMALL;Wilcoxon_MAE_p_SMALL;666;666;666;666;666;p_in_025_SMALL;p_in_050_SMALL;p_in_075_SMALL;p_in_100_SMALL],...
               'RowNames',RowNameWho);
SMALLEyes.Properties.VariableNames = {'Real_results' 'Prediction_result' 'P_value'};               
%writetable(SMALLEyes,'resources\Table.xlsx','Sheet','SMALL','Range','A1','WriteRowNames',true);

%% NORMAL Eyes ANN and AR
%fprintf(['NORMAL Eyes \n'])
Mean_NORMAL_ANN =  mean(NORMAL_ANN_resM);
MeanAbs_NORMAL_ANN =  mean(abs(NORMAL_ANN_resM));
Median_NORMAL_ANN =  median(abs(NORMAL_ANN_resM));
std_NORMAL_ANN =  std(NORMAL_ANN_resM);
min_NORMAL_ANN =  min(NORMAL_ANN_resM);
max_NORMAL_ANN =  max(NORMAL_ANN_resM);
In025_NORMAL_ANN = 100/length(NORMAL_ANN_resM)*length(NORMAL_ANN_resM(NORMAL_ANN_resM>=-0.25 & NORMAL_ANN_resM<=0.25));
In050_NORMAL_ANN = 100/length(NORMAL_ANN_resM)*length(NORMAL_ANN_resM(NORMAL_ANN_resM>=-0.5 & NORMAL_ANN_resM<=0.5));
In075_NORMAL_ANN = 100/length(NORMAL_ANN_resM)*length(NORMAL_ANN_resM(NORMAL_ANN_resM>=-0.75 & NORMAL_ANN_resM<=0.75));
In100_NORMAL_ANN = 100/length(NORMAL_ANN_resM)*length(NORMAL_ANN_resM(NORMAL_ANN_resM>=-1 & NORMAL_ANN_resM<=1));

Mean_NORMAL_AR =  mean(NORMAL_AR_resM);
MeanAbs_NORMAL_AR =  mean(abs(NORMAL_AR_resM));
Median_NORMAL_AR =  median(abs(NORMAL_AR_resM));
std_NORMAL_AR =  std(NORMAL_AR_resM);
min_NORMAL_AR =  min(NORMAL_AR_resM);
max_NORMAL_AR =  max(NORMAL_AR_resM);
In025_NORMAL_AR = 100/length(NORMAL_AR_resM)*length(NORMAL_AR_resM(NORMAL_AR_resM>=-0.25 & NORMAL_AR_resM<=0.25));
In050_NORMAL_AR = 100/length(NORMAL_AR_resM)*length(NORMAL_AR_resM(NORMAL_AR_resM>=-0.5 & NORMAL_AR_resM<=0.5));
In075_NORMAL_AR = 100/length(NORMAL_AR_resM)*length(NORMAL_AR_resM(NORMAL_AR_resM>=-0.75 & NORMAL_AR_resM<=0.75));
In100_NORMAL_AR = 100/length(NORMAL_AR_resM)*length(NORMAL_AR_resM(NORMAL_AR_resM>=-1 & NORMAL_AR_resM<=1));

% Refractive/IOL prediction error is significantly different from zero
Wilcoxon_MAE_AR_p_NORMAL = signrank(NORMAL_AR_resM);
Wilcoxon_MAE_ANN_p_NORMAL = signrank(NORMAL_ANN_resM);
%[W_AR_H ttest_MAE_AR_p_NORMAL] = ttest(NORMAL_AR_resM);
%[W_ANN_H ttest_MAE_ANN_p_NORMAL] = ttest(NORMAL_ANN_resM);
ME_p_NORMAL = strcat({'Real: '},num2str(Wilcoxon_MAE_AR_p_NORMAL),{'; '},{'Prediction: '},num2str(Wilcoxon_MAE_ANN_p_NORMAL));

% Difference in absolute prediction errors between IOL calculation formulas
Wilcoxon_MAE_p_NORMAL = ranksum(NORMAL_AR_resM, NORMAL_ANN_resM);

% In025
ANN_in_025_cnt_NORMAL = abs(NORMAL_ANN_resM) <= 0.25;
AR_in_025_cnt_NORMAL = abs(NORMAL_AR_resM) <= 0.25;
in_025_NORMAL = [AR_in_025_cnt_NORMAL'; ANN_in_025_cnt_NORMAL']';
in_025_11_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==1 & in_025_NORMAL(:,2)==1));
in_025_10_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==1 & in_025_NORMAL(:,2)==0));
in_025_01_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==0 & in_025_NORMAL(:,2)==1));
in_025_00_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==0 & in_025_NORMAL(:,2)==0));
p_in_025_NORMAL = mcn([in_025_11_NORMAL in_025_10_NORMAL; in_025_01_NORMAL in_025_00_NORMAL]);

% In050
ANN_in_050_cnt_NORMAL = abs(NORMAL_ANN_resM) <= 0.50;
AR_in_050_cnt_NORMAL = abs(NORMAL_AR_resM) <= 0.50;
in_050_NORMAL = [AR_in_050_cnt_NORMAL'; ANN_in_050_cnt_NORMAL']';
in_050_11_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==1 & in_050_NORMAL(:,2)==1));
in_050_10_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==1 & in_050_NORMAL(:,2)==0));
in_050_01_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==0 & in_050_NORMAL(:,2)==1));
in_050_00_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==0 & in_050_NORMAL(:,2)==0));
p_in_050_NORMAL = mcn([in_050_11_NORMAL in_050_10_NORMAL; in_050_01_NORMAL in_050_00_NORMAL]);

% In075
ANN_in_075_cnt_NORMAL = abs(NORMAL_ANN_resM) <= 0.75;
AR_in_075_cnt_NORMAL = abs(NORMAL_AR_resM) <= 0.75;
in_075_NORMAL = [AR_in_075_cnt_NORMAL'; ANN_in_075_cnt_NORMAL']';
in_075_11_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==1 & in_075_NORMAL(:,2)==1));
in_075_10_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==1 & in_075_NORMAL(:,2)==0));
in_075_01_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==0 & in_075_NORMAL(:,2)==1));
in_075_00_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==0 & in_075_NORMAL(:,2)==0));
p_in_075_NORMAL = mcn([in_075_11_NORMAL in_075_10_NORMAL; in_075_01_NORMAL in_075_00_NORMAL]);

% In100
ANN_in_100_cnt_NORMAL = abs(NORMAL_ANN_resM) <= 1.00;
AR_in_100_cnt_NORMAL = abs(NORMAL_AR_resM) <= 1.00;
in_100_NORMAL = [AR_in_100_cnt_NORMAL'; ANN_in_100_cnt_NORMAL']';
in_100_11_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==1 & in_100_NORMAL(:,2)==1));
in_100_10_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==1 & in_100_NORMAL(:,2)==0));
in_100_01_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==0 & in_100_NORMAL(:,2)==1));
in_100_00_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==0 & in_100_NORMAL(:,2)==0));
p_in_100_NORMAL = mcn([in_100_11_NORMAL in_100_10_NORMAL; in_100_01_NORMAL in_100_00_NORMAL]);

RowNameWho = {'ME',...
              'MAE',...
              'MedAE'...
              'Std',...
              'Min',...
              'Max',...
              'Eyes within PE (%)',...
              '±0,25',...
              '±0,50',...
              '±0,75',...
              '±1,00',...
           };
NORMALEyes = table(...
               [Mean_NORMAL_AR; MeanAbs_NORMAL_AR; Median_NORMAL_AR; std_NORMAL_AR; min_NORMAL_AR; max_NORMAL_AR;666 ;In025_NORMAL_AR; In050_NORMAL_AR; In075_NORMAL_AR; In100_NORMAL_AR],...
               [Mean_NORMAL_ANN; MeanAbs_NORMAL_ANN; Median_NORMAL_ANN; std_NORMAL_ANN; min_NORMAL_ANN; max_NORMAL_ANN;666 ;In025_NORMAL_ANN; In050_NORMAL_ANN; In075_NORMAL_ANN; In100_NORMAL_ANN],...
               [ME_p_NORMAL;Wilcoxon_MAE_p_NORMAL;666;666;666;666;666;p_in_025_NORMAL;p_in_050_NORMAL;p_in_075_NORMAL;p_in_100_NORMAL],...
               'RowNames',RowNameWho);
NORMALEyes.Properties.VariableNames = {'Real_results' 'Prediction_result' 'P_value'};               
%writetable(NORMALEyes,'resources\Table.xlsx','Sheet','NORMAL','Range','A1','WriteRowNames',true);

%% LONG Eyes ANN and AR
%fprintf(['LONG Eyes \n'])
Mean_LONG_ANN =  mean(LONG_ANN_resM);
MeanAbs_LONG_ANN =  mean(abs(LONG_ANN_resM));
Median_LONG_ANN =  median(abs(LONG_ANN_resM));
std_LONG_ANN =  std(LONG_ANN_resM);
min_LONG_ANN =  min(LONG_ANN_resM);
max_LONG_ANN =  max(LONG_ANN_resM);
In025_LONG_ANN = 100/length(LONG_ANN_resM)*length(LONG_ANN_resM(LONG_ANN_resM>=-0.25 & LONG_ANN_resM<=0.25));
In050_LONG_ANN = 100/length(LONG_ANN_resM)*length(LONG_ANN_resM(LONG_ANN_resM>=-0.5 & LONG_ANN_resM<=0.5));
In075_LONG_ANN = 100/length(LONG_ANN_resM)*length(LONG_ANN_resM(LONG_ANN_resM>=-0.75 & LONG_ANN_resM<=0.75));
In100_LONG_ANN = 100/length(LONG_ANN_resM)*length(LONG_ANN_resM(LONG_ANN_resM>=-1 & LONG_ANN_resM<=1));

Mean_LONG_AR =  mean(LONG_AR_resM);
MeanAbs_LONG_AR =  mean(abs(LONG_AR_resM));
Median_LONG_AR =  median(abs(LONG_AR_resM));
std_LONG_AR =  std(LONG_AR_resM);
min_LONG_AR =  min(LONG_AR_resM);
max_LONG_AR =  max(LONG_AR_resM);
In025_LONG_AR = 100/length(LONG_AR_resM)*length(LONG_AR_resM(LONG_AR_resM>=-0.25 & LONG_AR_resM<=0.25));
In050_LONG_AR = 100/length(LONG_AR_resM)*length(LONG_AR_resM(LONG_AR_resM>=-0.5 & LONG_AR_resM<=0.5));
In075_LONG_AR = 100/length(LONG_AR_resM)*length(LONG_AR_resM(LONG_AR_resM>=-0.75 & LONG_AR_resM<=0.75));
In100_LONG_AR = 100/length(LONG_AR_resM)*length(LONG_AR_resM(LONG_AR_resM>=-1 & LONG_AR_resM<=1));

% Refractive/IOL prediction error is significantly different from zero
Wilcoxon_MAE_AR_p_LONG = signrank(LONG_AR_resM);
Wilcoxon_MAE_ANN_p_LONG = signrank(LONG_ANN_resM);
%[W_AR_H ttest_MAE_AR_p_LONG] = ttest(LONG_AR_resM);
%[W_ANN_H ttest_MAE_ANN_p_LONG] = ttest(LONG_ANN_resM);
ME_p_LONG = strcat({'Real: '},num2str(Wilcoxon_MAE_AR_p_LONG),{'; '},{'Prediction: '},num2str(Wilcoxon_MAE_ANN_p_LONG));

% Difference in absolute prediction errors between IOL calculation formulas
Wilcoxon_MAE_p_LONG = ranksum(LONG_AR_resM, LONG_ANN_resM);

% In025
ANN_in_025_cnt_LONG = abs(LONG_ANN_resM) <= 0.25;
AR_in_025_cnt_LONG = abs(LONG_AR_resM) <= 0.25;
in_025_LONG = [AR_in_025_cnt_LONG'; ANN_in_025_cnt_LONG']';
in_025_11_LONG = length(in_025_LONG(in_025_LONG(:,1)==1 & in_025_LONG(:,2)==1));
in_025_10_LONG = length(in_025_LONG(in_025_LONG(:,1)==1 & in_025_LONG(:,2)==0));
in_025_01_LONG = length(in_025_LONG(in_025_LONG(:,1)==0 & in_025_LONG(:,2)==1));
in_025_00_LONG = length(in_025_LONG(in_025_LONG(:,1)==0 & in_025_LONG(:,2)==0));
p_in_025_LONG = mcn([in_025_11_LONG in_025_10_LONG; in_025_01_LONG in_025_00_LONG]);

% In050
ANN_in_050_cnt_LONG = abs(LONG_ANN_resM) <= 0.50;
AR_in_050_cnt_LONG = abs(LONG_AR_resM) <= 0.50;
in_050_LONG = [AR_in_050_cnt_LONG'; ANN_in_050_cnt_LONG']';
in_050_11_LONG = length(in_050_LONG(in_050_LONG(:,1)==1 & in_050_LONG(:,2)==1));
in_050_10_LONG = length(in_050_LONG(in_050_LONG(:,1)==1 & in_050_LONG(:,2)==0));
in_050_01_LONG = length(in_050_LONG(in_050_LONG(:,1)==0 & in_050_LONG(:,2)==1));
in_050_00_LONG = length(in_050_LONG(in_050_LONG(:,1)==0 & in_050_LONG(:,2)==0));
p_in_050_LONG = mcn([in_050_11_LONG in_050_10_LONG; in_050_01_LONG in_050_00_LONG]);

% In075
ANN_in_075_cnt_LONG = abs(LONG_ANN_resM) <= 0.75;
AR_in_075_cnt_LONG = abs(LONG_AR_resM) <= 0.75;
in_075_LONG = [AR_in_075_cnt_LONG'; ANN_in_075_cnt_LONG']';
in_075_11_LONG = length(in_075_LONG(in_075_LONG(:,1)==1 & in_075_LONG(:,2)==1));
in_075_10_LONG = length(in_075_LONG(in_075_LONG(:,1)==1 & in_075_LONG(:,2)==0));
in_075_01_LONG = length(in_075_LONG(in_075_LONG(:,1)==0 & in_075_LONG(:,2)==1));
in_075_00_LONG = length(in_075_LONG(in_075_LONG(:,1)==0 & in_075_LONG(:,2)==0));
p_in_075_LONG = mcn([in_075_11_LONG in_075_10_LONG; in_075_01_LONG in_075_00_LONG]);

% In100
ANN_in_100_cnt_LONG = abs(LONG_ANN_resM) <= 1.00;
AR_in_100_cnt_LONG = abs(LONG_AR_resM) <= 1.00;
in_100_LONG = [AR_in_100_cnt_LONG'; ANN_in_100_cnt_LONG']';
in_100_11_LONG = length(in_100_LONG(in_100_LONG(:,1)==1 & in_100_LONG(:,2)==1));
in_100_10_LONG = length(in_100_LONG(in_100_LONG(:,1)==1 & in_100_LONG(:,2)==0));
in_100_01_LONG = length(in_100_LONG(in_100_LONG(:,1)==0 & in_100_LONG(:,2)==1));
in_100_00_LONG = length(in_100_LONG(in_100_LONG(:,1)==0 & in_100_LONG(:,2)==0));
p_in_100_LONG = mcn([in_100_11_LONG in_100_10_LONG; in_100_01_LONG in_100_00_LONG]);

RowNameWho = {'ME',...
              'MAE',...
              'MedAE'...
              'Std',...
              'Min',...
              'Max',...
              'Eyes within PE (%)',...
              '±0,25',...
              '±0,50',...
              '±0,75',...
              '±1,00',...
           };
LONGEyes = table(...
               [Mean_LONG_AR; MeanAbs_LONG_AR; Median_LONG_AR; std_LONG_AR; min_LONG_AR; max_LONG_AR;666 ;In025_LONG_AR; In050_LONG_AR; In075_LONG_AR; In100_LONG_AR],...
               [Mean_LONG_ANN; MeanAbs_LONG_ANN; Median_LONG_ANN; std_LONG_ANN; min_LONG_ANN; max_LONG_ANN;666 ;In025_LONG_ANN; In050_LONG_ANN; In075_LONG_ANN; In100_LONG_ANN],...
               [ME_p_LONG;Wilcoxon_MAE_p_LONG;666;666;666;666;666;p_in_025_LONG;p_in_050_LONG;p_in_075_LONG;p_in_100_LONG],...
               'RowNames',RowNameWho);
LONGEyes.Properties.VariableNames = {'Real_results' 'Prediction_result' 'P_value'};               
%writetable(LONGEyes,'resources\Table.xlsx','Sheet','LONG','Range','A1','WriteRowNames',true);
%%
%save(['WSpace_',datestr(now, 'yymmdd_HHMM_ss'),'.mat']);
