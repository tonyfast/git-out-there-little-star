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

%% Set parameters

param = struct( 'disqus','' );
keys = {'DisqusOn'};
for ii = 1 : numel( varargin )
    switch varargin{ii}
        case 'DisqusOn'
            param.disqus = varargin{ii+1};
    end
end


%% Exclude Argument afeter setting parameters
exc = {'DisqusOn'};

if numel( varargin ) > 0
    excid = find( ismember( varargin, exc) );
    excid = [excid(:)'; excid(:)'+1];
    varargin = { varargin{ setdiff( 1 : numel( varargin ), excid) } };
end




%%
% Run the publish function as normal, but place the images in the assets
% folder to conform with Jekyll's rules
fmatpub = publish( varargin{:}, 'outputDir', fullfile('.','assets') );

% The timestamp is needed for blog-aware features in Jekyll
timenow = clock;
to_file = fullfile( '_posts', sprintf( '%04i-%02i-%02i-%s.html', timenow(1), timenow(2), timenow(3), postname ) );

%% Write the new file
fto = fopen( to_file ,'w');

% Add the YAML front matter
fprintf( fto, '---\nlayout: post\n---\n' );


WebDat = fileread(fmatpub);
WebDat = regexprep( WebDat, '<body>', ...
    '<script type="text/javascript" src="{{site.baseurl}}/assets/javascripts/swapSrc.js"></script><body onload="swapSrc(''{{site.baseurl}}'',''{{site.imgbase}}'')">') ;
if numel( param.disqus ) > 0
    WebDat = regexprep( WebDat, '</body>', '' );
    WebDat = regexprep( WebDat, '</html>', '' );
end

if numel( param.disqus ) > 0
    WebDat = strvcat( WebDat , disqusbody( param.disqus), '</body></html>' );
end

% Insert a javascript to reorganize image paths
for ii = 1 : size(WebDat,1)
    fprintf( fto, '%s\n', WebDat(ii,:) );
end


% Close file
fclose(fto);

disp( 'Your Matlab script has been published.  It can now be hosted as a stand-alone page or a blog posting using Jekyll templates.')
disp( 'Please review you recent publication and push it to Github for the world to see.  You will need to add the /assets and /_posts folder to your commit.' );


end 

function s = disqusbody( user)

s =  char(cellstr( { '<div id="disqus_thread"></div>';
    '<script type="text/javascript">';
        '/* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */';
        regexprep('var disqus_shortname = ''wokkawokka''; // required: replace example with your forum shortname','wokkawokka',user);
        '/* * * DON''T EDIT BELOW THIS LINE * * */';
        '(function() {';
            'var dsq = document.createElement(''script''); dsq.type = ''text/javascript''; dsq.async = true;';
            'dsq.src = ''//'' + disqus_shortname + ''.disqus.com/embed.js'';';
            '(document.getElementsByTagName(''head'')[0] || document.getElementsByTagName(''body'')[0]).appendChild(dsq);';
        '})();';
    '</script>';
    '<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>';
    '<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>'} ) );


end