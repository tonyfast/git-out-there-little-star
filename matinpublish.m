function [post_name assets] = matinpublish( varargin );

%% Options and Parameters
% Options
% Disqus
% Dropbox

keys = {'DisqusOn','title'};

%% Post title
% There is a default name and a user defined name

%% Post Type
% Determine the post type
% If varargin{1} is
%    a function or structure - then a dataset is generated
%    a script - then a report is generated
% This process selects the next steps in scripting the post.


