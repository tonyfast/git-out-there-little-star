%% Zip Skeleton
% Zip up a the files necessary to make a modified Jekyll template to
% publish Matlab scripts to Github pages.
%% The files to include and exclude in the zip file
fn = dir('.');

% exclude files in zip
exc = {'_site','.git','*~','.','..','.gitignore','ZipSkeleton.m~','ZipSkeleton.m'};
zipfiles = {fn( find(~ismember( {fn.name}, exc ))).name};

%% Wrap up all the files into a *.zip file

zip('jekyll-skeleton.zip',zipfiles);

%% Visualization files
% And plot a picture for illustraction

peaks(10);
snapnow

