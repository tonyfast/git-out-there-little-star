%% MATIN Publish
% Matin publish is built to use in combination with GitHub Pages.  It
% requires:
% A gh-pages branch with Bootstrap installed.
%
% Matin publish replaces & augments Matlab's publish function.
% Matin publish is aware of there different types of webpages.
% 1. Dataset Data & Metadata
% 2. Report Metadata
% 3. Posts
% 4. Content

%% A report

matinpublish('ZipSkeleton.m','disqus','tonyfast','title','A Test Report')
disp('Report Successful')
%% A dataset execution

p = matinpublish(@myfunc,'title','Execute to Array Structure')
disp('DATASET EXECUTION ARRAY Successful')

%% A dataset execution

p = matinpublish(@myfunc,'cell',checkerboard(10),'title','Execute to Cell Structure')
disp('DATASET EXECUTION CELL Successful')

%% An array dataset 
S = myfunc('array',2);
[ S] = matinpublish(S,'disqus','tonyfast','title','Array Structure');
disp('DATASET ARRAY Successful')
%% An cell dataset
S = myfunc('cell',rand(100,200,4));

p = matinpublish(S,'title','Cell Structure')
disp('DATASET CELL Successful')

%% All Parametes
