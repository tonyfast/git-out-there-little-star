function to_file = jekyllpublish( postname, varargin )
% Publish html versions of matlab scripts using the Jekyll interpreter on
% Github pages.

%% Examples
%
% jekyllpublish('Post-Title', 'script_name.m' )
%
% jekyllpublish('Zip-Ya-Lips-Skinny', 'ZipSkeleton.m' ) - Publish a post with the
% title 'Zip Ya Lips Skinny' is the title of the post for the file sZipSkeleton.m
%
% jekyllpublish('Example-Post', varargin )- varargin obeys the Matlab
% published syntax starting from the first argument.
%
% Additional Parameters
%
% 'DisqusOn' adds a disqus comment widget at the bottom of your Jekyll
% page.  Go to disqus.com to sign up and remember your user name.
%
% jekyllpublish('Zip-Ya-Lips-Skinny', 'ZipSkeleton.m', 'DisqusOn',
% 'tonyfast' ) creates a webpage with Disqus comments attached to the
% username "tonyfast"

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
fprintf( fto, '---\nlayout: report\ntitle: %s\n---\n', regexprep( postname,'-',' ') );


WebDat = fileread(fmatpub);
% Moved this to main template
% WebDat = regexprep( WebDat, '<body>', ...
%     '<script type="text/javascript" src="{{site.baseurl}}/assets/javascripts/swapSrc.js"></script><body onload="swapSrc(''{{site.url}}'',''{{site.baseurl}}'',''{{site.imgbase}}'')">') ;
WebDat = regexprep( WebDat, '.content { font-size:1.2em; line-height:140%; padding: 20px; }', ...
    '.content { font-size:1.2em; line-height:140%; padding: 0px; }') ;
cssig = MatlabCSS();
for ii = 1 : numel(cssig)
    WebDat = regexprep( WebDat, cssig{ii}, '') ;
end

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

function s = MatlabCSS()

s = { 'html { min-height:100%; margin-bottom:1px; }';
    'html body { height:100%; margin:0px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#000; line-height:140%; background:#fff none; overflow-y:scroll; }';
    'html body td { vertical-align:top; text-align:left; }' };

s = cellfun( @(x)strtrim(x), cellstr(s), 'UniformOutput',false );

end

function s = matlabcss

s = {'html,pre,tt,code',
    'pre, tt, code { font-size:12px; }',
    'pre { margin:0px 0px 20px; }',
    'pre.error { color:red; }',
    'pre.codeoutput { padding:10px; border:1px solid #d3d3d3; background:#f7f7f7; }',
    'pre.codeinput { padding:10px 11px; margin:0px 0px 20px; background:#4c4c4c; color:white; }'};
end
