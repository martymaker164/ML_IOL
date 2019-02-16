clear all;
close all;
clc;

ANNFilename = 'ANNEM1.mat';
ANNEMCaption = {'ALL_ANN_resM', ...
                'SMALL_ANN_resM', ...
                'NORMAL_ANN_resM', ...
                'LONG_ANN_resM'};
ANNEM = load(ANNFilename,ANNEMCaption{:});

SVMFilename = 'SVMRM1.mat';
SVMRMCaption = {'ALL_ANN_resM', ...
                'SMALL_ANN_resM', ...
                'NORMAL_ANN_resM', ...
                'LONG_ANN_resM'};
SVMRM = load(SVMFilename,SVMRMCaption{:});

% Difference in absolute prediction errors between IOL calculation formulas
PE_p_ALL = ranksum(SVMRM.ALL_ANN_resM, ANNEM.ALL_ANN_resM)
PE_p_SMALL = ranksum(SVMRM.SMALL_ANN_resM, ANNEM.SMALL_ANN_resM)
PE_p_NORMAL = ranksum(SVMRM.NORMAL_ANN_resM, ANNEM.NORMAL_ANN_resM)
PE_p_LONG = ranksum(SVMRM.LONG_ANN_resM, ANNEM.LONG_ANN_resM)

% ALL
% In025
ANN_in_025_cnt_ALL = abs(SVMRM.ALL_ANN_resM') <= 0.25;
AR_in_025_cnt_ALL = abs(ANNEM.ALL_ANN_resM) <= 0.25;
in_025_ALL = [AR_in_025_cnt_ALL; ANN_in_025_cnt_ALL]';
in_025_11_ALL = length(in_025_ALL(in_025_ALL(:,1)==1 & in_025_ALL(:,2)==1));
in_025_10_ALL = length(in_025_ALL(in_025_ALL(:,1)==1 & in_025_ALL(:,2)==0));
in_025_01_ALL = length(in_025_ALL(in_025_ALL(:,1)==0 & in_025_ALL(:,2)==1));
in_025_00_ALL = length(in_025_ALL(in_025_ALL(:,1)==0 & in_025_ALL(:,2)==0));
p_in_025_ALL = mcn([in_025_11_ALL in_025_10_ALL; in_025_01_ALL in_025_00_ALL]);
p_SR_in_025_ALL = signtest(single(AR_in_025_cnt_ALL), single(ANN_in_025_cnt_ALL))

% In050
ANN_in_050_cnt_ALL = abs(SVMRM.ALL_ANN_resM') <= 0.50;
AR_in_050_cnt_ALL = abs(ANNEM.ALL_ANN_resM) <= 0.50;
in_050_ALL = [AR_in_050_cnt_ALL; ANN_in_050_cnt_ALL]';
in_050_11_ALL = length(in_050_ALL(in_050_ALL(:,1)==1 & in_050_ALL(:,2)==1));
in_050_10_ALL = length(in_050_ALL(in_050_ALL(:,1)==1 & in_050_ALL(:,2)==0));
in_050_01_ALL = length(in_050_ALL(in_050_ALL(:,1)==0 & in_050_ALL(:,2)==1));
in_050_00_ALL = length(in_050_ALL(in_050_ALL(:,1)==0 & in_050_ALL(:,2)==0));
p_in_050_ALL = mcn([in_050_11_ALL in_050_10_ALL; in_050_01_ALL in_050_00_ALL])
p_SR_in_050_ALL = signtest(single(AR_in_050_cnt_ALL), single(ANN_in_050_cnt_ALL))

% In075
ANN_in_075_cnt_ALL = abs(SVMRM.ALL_ANN_resM') <= 0.75;
AR_in_075_cnt_ALL = abs(ANNEM.ALL_ANN_resM) <= 0.75;
in_075_ALL = [AR_in_075_cnt_ALL; ANN_in_075_cnt_ALL]';
in_075_11_ALL = length(in_075_ALL(in_075_ALL(:,1)==1 & in_075_ALL(:,2)==1));
in_075_10_ALL = length(in_075_ALL(in_075_ALL(:,1)==1 & in_075_ALL(:,2)==0));
in_075_01_ALL = length(in_075_ALL(in_075_ALL(:,1)==0 & in_075_ALL(:,2)==1));
in_075_00_ALL = length(in_075_ALL(in_075_ALL(:,1)==0 & in_075_ALL(:,2)==0));
p_in_075_ALL = mcn([in_075_11_ALL in_075_10_ALL; in_075_01_ALL in_075_00_ALL])
p_SR_in_075_ALL = signtest(single(AR_in_075_cnt_ALL), single(ANN_in_075_cnt_ALL))

% In100
ANN_in_100_cnt_ALL = abs(SVMRM.ALL_ANN_resM') <= 1.00;
AR_in_100_cnt_ALL = abs(ANNEM.ALL_ANN_resM) <= 1.00;
in_100_ALL = [AR_in_100_cnt_ALL; ANN_in_100_cnt_ALL]';
in_100_11_ALL = length(in_100_ALL(in_100_ALL(:,1)==1 & in_100_ALL(:,2)==1));
in_100_10_ALL = length(in_100_ALL(in_100_ALL(:,1)==1 & in_100_ALL(:,2)==0));
in_100_01_ALL = length(in_100_ALL(in_100_ALL(:,1)==0 & in_100_ALL(:,2)==1));
in_100_00_ALL = length(in_100_ALL(in_100_ALL(:,1)==0 & in_100_ALL(:,2)==0));
p_in_100_ALL = mcn([in_100_11_ALL in_100_10_ALL; in_100_01_ALL in_100_00_ALL])
p_SR_in_100_ALL = signtest(single(AR_in_100_cnt_ALL), single(ANN_in_100_cnt_ALL))

% SMALL
ANN_in_025_cnt_SMALL = abs(SVMRM.SMALL_ANN_resM') <= 0.25;
AR_in_025_cnt_SMALL = abs(ANNEM.SMALL_ANN_resM) <= 0.25;
in_025_SMALL = [AR_in_025_cnt_SMALL; ANN_in_025_cnt_SMALL]';
in_025_11_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==1 & in_025_SMALL(:,2)==1));
in_025_10_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==1 & in_025_SMALL(:,2)==0));
in_025_01_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==0 & in_025_SMALL(:,2)==1));
in_025_00_SMALL = length(in_025_SMALL(in_025_SMALL(:,1)==0 & in_025_SMALL(:,2)==0));
p_in_025_SMALL = mcn([in_025_11_SMALL in_025_10_SMALL; in_025_01_SMALL in_025_00_SMALL])
p_SR_in_025_SMALL = signtest(single(AR_in_025_cnt_SMALL), single(ANN_in_025_cnt_SMALL))

% In050
ANN_in_050_cnt_SMALL = abs(SVMRM.SMALL_ANN_resM') <= 0.50;
AR_in_050_cnt_SMALL = abs(ANNEM.SMALL_ANN_resM) <= 0.50;
in_050_SMALL = [AR_in_050_cnt_SMALL; ANN_in_050_cnt_SMALL]';
in_050_11_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==1 & in_050_SMALL(:,2)==1));
in_050_10_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==1 & in_050_SMALL(:,2)==0));
in_050_01_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==0 & in_050_SMALL(:,2)==1));
in_050_00_SMALL = length(in_050_SMALL(in_050_SMALL(:,1)==0 & in_050_SMALL(:,2)==0));
p_in_050_SMALL = mcn([in_050_11_SMALL in_050_10_SMALL; in_050_01_SMALL in_050_00_SMALL])
p_SR_in_050_SMALL = signtest(single(AR_in_050_cnt_SMALL), single(ANN_in_050_cnt_SMALL))

% In075
ANN_in_075_cnt_SMALL = abs(SVMRM.SMALL_ANN_resM') <= 0.75;
AR_in_075_cnt_SMALL = abs(ANNEM.SMALL_ANN_resM) <= 0.75;
in_075_SMALL = [AR_in_075_cnt_SMALL; ANN_in_075_cnt_SMALL]';
in_075_11_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==1 & in_075_SMALL(:,2)==1));
in_075_10_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==1 & in_075_SMALL(:,2)==0));
in_075_01_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==0 & in_075_SMALL(:,2)==1));
in_075_00_SMALL = length(in_075_SMALL(in_075_SMALL(:,1)==0 & in_075_SMALL(:,2)==0));
p_in_075_SMALL = mcn([in_075_11_SMALL in_075_10_SMALL; in_075_01_SMALL in_075_00_SMALL])
p_SR_in_075_SMALL = signtest(single(AR_in_075_cnt_SMALL), single(ANN_in_075_cnt_SMALL))

% In100
ANN_in_100_cnt_SMALL = abs(SVMRM.SMALL_ANN_resM') <= 1.00;
AR_in_100_cnt_SMALL = abs(ANNEM.SMALL_ANN_resM) <= 1.00;
in_100_SMALL = [AR_in_100_cnt_SMALL; ANN_in_100_cnt_SMALL]';
in_100_11_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==1 & in_100_SMALL(:,2)==1));
in_100_10_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==1 & in_100_SMALL(:,2)==0));
in_100_01_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==0 & in_100_SMALL(:,2)==1));
in_100_00_SMALL = length(in_100_SMALL(in_100_SMALL(:,1)==0 & in_100_SMALL(:,2)==0));
p_in_100_SMALL = mcn([in_100_11_SMALL in_100_10_SMALL; in_100_01_SMALL in_100_00_SMALL])
p_SR_in_100_SMALL = signtest(single(AR_in_100_cnt_SMALL), single(ANN_in_100_cnt_SMALL))


% NORMAL
ANN_in_025_cnt_NORMAL = abs(SVMRM.NORMAL_ANN_resM') <= 0.25;
AR_in_025_cnt_NORMAL = abs(ANNEM.NORMAL_ANN_resM) <= 0.25;
in_025_NORMAL = [AR_in_025_cnt_NORMAL; ANN_in_025_cnt_NORMAL]';
in_025_11_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==1 & in_025_NORMAL(:,2)==1));
in_025_10_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==1 & in_025_NORMAL(:,2)==0));
in_025_01_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==0 & in_025_NORMAL(:,2)==1));
in_025_00_NORMAL = length(in_025_NORMAL(in_025_NORMAL(:,1)==0 & in_025_NORMAL(:,2)==0));
p_in_025_NORMAL = mcn([in_025_11_NORMAL in_025_10_NORMAL; in_025_01_NORMAL in_025_00_NORMAL])
p_SR_in_025_NORMAL = signtest(single(AR_in_025_cnt_NORMAL), single(ANN_in_025_cnt_NORMAL))

% In050
ANN_in_050_cnt_NORMAL = abs(SVMRM.NORMAL_ANN_resM') <= 0.50;
AR_in_050_cnt_NORMAL = abs(ANNEM.NORMAL_ANN_resM) <= 0.50;
in_050_NORMAL = [AR_in_050_cnt_NORMAL; ANN_in_050_cnt_NORMAL]';
in_050_11_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==1 & in_050_NORMAL(:,2)==1));
in_050_10_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==1 & in_050_NORMAL(:,2)==0));
in_050_01_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==0 & in_050_NORMAL(:,2)==1));
in_050_00_NORMAL = length(in_050_NORMAL(in_050_NORMAL(:,1)==0 & in_050_NORMAL(:,2)==0));
p_in_050_NORMAL = mcn([in_050_11_NORMAL in_050_10_NORMAL; in_050_01_NORMAL in_050_00_NORMAL])
p_SR_in_050_NORMAL = signtest(single(AR_in_050_cnt_NORMAL), single(ANN_in_050_cnt_NORMAL))

% In075
ANN_in_075_cnt_NORMAL = abs(SVMRM.NORMAL_ANN_resM') <= 0.75;
AR_in_075_cnt_NORMAL = abs(ANNEM.NORMAL_ANN_resM) <= 0.75;
in_075_NORMAL = [AR_in_075_cnt_NORMAL; ANN_in_075_cnt_NORMAL]';
in_075_11_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==1 & in_075_NORMAL(:,2)==1));
in_075_10_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==1 & in_075_NORMAL(:,2)==0));
in_075_01_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==0 & in_075_NORMAL(:,2)==1));
in_075_00_NORMAL = length(in_075_NORMAL(in_075_NORMAL(:,1)==0 & in_075_NORMAL(:,2)==0));
p_in_075_NORMAL = mcn([in_075_11_NORMAL in_075_10_NORMAL; in_075_01_NORMAL in_075_00_NORMAL])
p_SR_in_075_NORMAL = signtest(single(AR_in_075_cnt_NORMAL), single(ANN_in_075_cnt_NORMAL))

% In100
ANN_in_100_cnt_NORMAL = abs(SVMRM.NORMAL_ANN_resM') <= 1.00;
AR_in_100_cnt_NORMAL = abs(ANNEM.NORMAL_ANN_resM) <= 1.00;
in_100_NORMAL = [AR_in_100_cnt_NORMAL; ANN_in_100_cnt_NORMAL]';
in_100_11_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==1 & in_100_NORMAL(:,2)==1));
in_100_10_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==1 & in_100_NORMAL(:,2)==0));
in_100_01_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==0 & in_100_NORMAL(:,2)==1));
in_100_00_NORMAL = length(in_100_NORMAL(in_100_NORMAL(:,1)==0 & in_100_NORMAL(:,2)==0));
p_in_100_NORMAL = mcn([in_100_11_NORMAL in_100_10_NORMAL; in_100_01_NORMAL in_100_00_NORMAL])
p_SR_in_100_NORMAL = signtest(single(AR_in_100_cnt_NORMAL), single(ANN_in_100_cnt_NORMAL))

% LONG
ANN_in_025_cnt_LONG = abs(SVMRM.LONG_ANN_resM') <= 0.25;
AR_in_025_cnt_LONG = abs(ANNEM.LONG_ANN_resM) <= 0.25;
in_025_LONG = [AR_in_025_cnt_LONG; ANN_in_025_cnt_LONG]';
in_025_11_LONG = length(in_025_LONG(in_025_LONG(:,1)==1 & in_025_LONG(:,2)==1));
in_025_10_LONG = length(in_025_LONG(in_025_LONG(:,1)==1 & in_025_LONG(:,2)==0));
in_025_01_LONG = length(in_025_LONG(in_025_LONG(:,1)==0 & in_025_LONG(:,2)==1));
in_025_00_LONG = length(in_025_LONG(in_025_LONG(:,1)==0 & in_025_LONG(:,2)==0));
p_in_025_LONG = mcn([in_025_11_LONG in_025_10_LONG; in_025_01_LONG in_025_00_LONG])
p_SR_in_025_LONG = signtest(single(AR_in_025_cnt_LONG), single(ANN_in_025_cnt_LONG))

% In050
ANN_in_050_cnt_LONG = abs(SVMRM.LONG_ANN_resM') <= 0.50;
AR_in_050_cnt_LONG = abs(ANNEM.LONG_ANN_resM) <= 0.50;
in_050_LONG = [AR_in_050_cnt_LONG; ANN_in_050_cnt_LONG]';
in_050_11_LONG = length(in_050_LONG(in_050_LONG(:,1)==1 & in_050_LONG(:,2)==1));
in_050_10_LONG = length(in_050_LONG(in_050_LONG(:,1)==1 & in_050_LONG(:,2)==0));
in_050_01_LONG = length(in_050_LONG(in_050_LONG(:,1)==0 & in_050_LONG(:,2)==1));
in_050_00_LONG = length(in_050_LONG(in_050_LONG(:,1)==0 & in_050_LONG(:,2)==0));
p_in_050_LONG = mcn([in_050_11_LONG in_050_10_LONG; in_050_01_LONG in_050_00_LONG])
p_SR_in_050_LONG = signtest(single(AR_in_050_cnt_LONG), single(ANN_in_050_cnt_LONG))

% In075
ANN_in_075_cnt_LONG = abs(SVMRM.LONG_ANN_resM') <= 0.75;
AR_in_075_cnt_LONG = abs(ANNEM.LONG_ANN_resM) <= 0.75;
in_075_LONG = [AR_in_075_cnt_LONG; ANN_in_075_cnt_LONG]';

in_075_11_LONG = length(in_075_LONG(in_075_LONG(:,1)==1 & in_075_LONG(:,2)==1));
in_075_10_LONG = length(in_075_LONG(in_075_LONG(:,1)==1 & in_075_LONG(:,2)==0));
in_075_01_LONG = length(in_075_LONG(in_075_LONG(:,1)==0 & in_075_LONG(:,2)==1));
in_075_00_LONG = length(in_075_LONG(in_075_LONG(:,1)==0 & in_075_LONG(:,2)==0));
p_in_075_LONG = mcn([in_075_11_LONG in_075_10_LONG; in_075_01_LONG in_075_00_LONG])
p_SR_in_075_LONG = signtest(single(AR_in_075_cnt_LONG), single(ANN_in_075_cnt_LONG))

% In100
ANN_in_100_cnt_LONG = abs(SVMRM.LONG_ANN_resM') <= 1.00;
AR_in_100_cnt_LONG = abs(ANNEM.LONG_ANN_resM) <= 1.00;
in_100_LONG = [AR_in_100_cnt_LONG; ANN_in_100_cnt_LONG]';
in_100_11_LONG = length(in_100_LONG(in_100_LONG(:,1)==1 & in_100_LONG(:,2)==1));
in_100_10_LONG = length(in_100_LONG(in_100_LONG(:,1)==1 & in_100_LONG(:,2)==0));
in_100_01_LONG = length(in_100_LONG(in_100_LONG(:,1)==0 & in_100_LONG(:,2)==1));
in_100_00_LONG = length(in_100_LONG(in_100_LONG(:,1)==0 & in_100_LONG(:,2)==0));
p_in_100_LONG = mcn([in_100_11_LONG in_100_10_LONG; in_100_01_LONG in_100_00_LONG])
p_SR_in_100_LONG = signtest(single(AR_in_100_cnt_LONG), single(ANN_in_100_cnt_LONG))

RowNameWho = {'PE',...
              '±0,25',...
              '±0,50',...
              '±0,75',...
              '±1,00',...
              '±0,25 SR',...
              '±0,50 SR',...
              '±0,75 SR',...
              '±1,00 SR',...
           };
LONGEyes = table(...
               [PE_p_ALL; p_in_025_ALL; p_in_050_ALL; p_in_075_ALL; p_in_100_ALL; p_SR_in_025_ALL; p_SR_in_050_ALL; p_SR_in_075_ALL; p_SR_in_100_ALL],...
               [PE_p_SMALL; p_in_025_SMALL; p_in_050_SMALL; p_in_075_SMALL; p_in_100_SMALL; p_SR_in_025_SMALL; p_SR_in_050_SMALL; p_SR_in_075_SMALL; p_SR_in_100_SMALL],...
               [PE_p_NORMAL; p_in_025_NORMAL; p_in_050_NORMAL; p_in_075_NORMAL; p_in_100_NORMAL; p_SR_in_025_NORMAL; p_SR_in_050_NORMAL; p_SR_in_075_NORMAL; p_SR_in_100_NORMAL],...
               [PE_p_LONG; p_in_025_LONG; p_in_050_LONG; p_in_075_LONG; p_in_100_LONG; p_SR_in_025_LONG; p_SR_in_050_LONG; p_SR_in_075_LONG; p_SR_in_100_LONG],...
           'RowNames',RowNameWho);
LONGEyes.Properties.VariableNames = {'ALL' 'SHORT' 'NORMAL' 'LONG'};               
%writetable(LONGEyes,'C:\Users\šrámpjùtr\Documents\Škola\Èlánky\NNW\MANUSCRIPTS\PeerJ\Algo\Table.xlsx','Sheet','ALL','Range','A1','WriteRowNames',true);



