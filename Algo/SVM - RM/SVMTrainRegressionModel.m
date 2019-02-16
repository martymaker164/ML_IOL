function [trainedModel, validationRMSE, validationMSE] = SVMTrainRegressionModel(trainingData)
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7'});
predictorNames = {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_7;
isCategoricalPredictor = [false, false, false, false, false, false];
% Train a regression model
% This code specifies all the model options and trains the model.
responseScale = iqr(response);
if ~isfinite(responseScale) || responseScale == 0.0
    responseScale = 1.0;
end
boxConstraint = responseScale/1.349;
epsilon = responseScale/13.49;
regressionSVM = fitrsvm(...
    predictors, ...
    response, ...
    'OptimizeHyperparameters','all');
% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x', 'VariableNames', predictorNames);
svmPredictFcn = @(x) predict(regressionSVM, x);
trainedModel.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));
%Add additional fields to the result struct
trainedModel.RegressionSVM = regressionSVM;
trainedModel.About = 'Matlab R2017a.';
trainedModel.HowToPredict = sprintf('');
%Convert input to table
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7'});
predictorNames = {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_7;
isCategoricalPredictor = [false, false, false, false, false, false];
%Set up holdout validation
cvp = cvpartition(size(response, 1), 'Holdout', 0.3);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
trainingIsCategoricalPredictor = isCategoricalPredictor;
%Create the result struct with predict function
svmPredictFcn = @(x) predict(regressionSVM, x);
validationPredictFcn = @(x) svmPredictFcn(x);
%Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
validationPredictions = validationPredictFcn(validationPredictors);
%Compute validation RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(validationResponse);
validationRMSE = sqrt(nansum(( validationPredictions - validationResponse ).^2) / numel(validationResponse(isNotMissing) ));
validationMSE = (nansum(( validationPredictions - validationResponse )) / numel(validationResponse(isNotMissing) ));
 
