function to_file = jekyllpublish( postname, varargin )
% Publish html versions of matlab scripts using the Jekyll interpreter on
% Github pages.

%% Examples
%
% jekyllpublish('Zip-Ya-Lips-Skinny', 'ZipSkeleton.m' ) - Publish a post with the
% title 'Example Post' which is the published version of ZipSkeleton.m
%
% jekyllpublish('Example-Post', varargin )- varargin obeys the Matlab
% published syntax starting from the first argument.

% Run the publish function as normal, but place the images in the assets
% folder to conform with Jekyll's rules
fmatpub = publish( varargin{:}, 'outputDir', fullfile('.','assets') );

% The timestamp is needed for blog-aware features in Jekyll
timenow = clock;
to_file = fullfile( '_posts', sprintf( '%04i-%02i-%02i-%s.html', timenow(1), timenow(2), timenow(3), postname ) );

%% Write the new file
fto = fopen( to_file ,'w');

% Add the YAML front matter
fprintf( fto, '---\nlayout:post\n---\n' );

% Insert a javascript to reorganize image paths
fprintf( fto,'%s\n', regexprep( fileread(fmatpub), '<body>', ...
    '<script type="text/javascript" src="{{site.baseurl}}/assets/javascripts/swapSrc.js"></script><body onload="swapSrc(''{{site.baseurl}}'',''{{site.imgbase}}'')">') );

% Close file
fclose(fto);

disp( 'Your Matlab script has been published.  It can now be hosted as a stand-alone page or a blog posting using Jekyll templates.')
disp( 'Please review you recent publication and push it to Github for the world to see.' );
