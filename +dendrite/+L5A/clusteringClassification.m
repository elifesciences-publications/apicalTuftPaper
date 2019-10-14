matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
matfiles = dir(fullfile(matfolder,'*.mat'));

% Load features
for i=1:length(matfiles)
    curVar = struct2table...
        (load(fullfile(matfiles(i).folder,matfiles(i).name)));
    if isrow(curVar{1,1}{1})
        curVar{1,1} = ...
            cellfun(@(x) x',curVar{1,1},'uni',0);
    end
    features{i} = ...
        curVar;
end
% Concatenate
features = cat(2,features{:});
features = util.varfunKeepNames(@(x) cat(1,x{:}),features);
X = features.Variables;
Y = categorical(repelem({'L5tt','L5st'},[12,6]));

%% fit a support vector machine on the initial samples test on new samples
indicesTrain = [1:10,13:15];
indicesTest = [11,12,16:18];
train_X = X(indicesTrain,:);
train_Y = Y (indicesTrain)';

svmModel = fitcsvm(train_X,train_Y,'Standardize',true);
[classes,score] = predict(svmModel,X(indicesTest,:));

% Plot the support vector
sv = svmModel.SupportVectors;
figure
gscatter(train_X(:,1),train_X(:,2),train_Y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('versicolor','virginica','Support Vector')
hold off