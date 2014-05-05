function [varargout] = matinpublish( varargin ); % post_name assets

% OUTPUT THE EXECUTION
%% Options and Parameters
% The Post title is defined here
% Options
% Disqus
% Dropbox

keys = {'title'};

param = struct( 'title', sprintf('Output-%i', round(1e5*rand(1)) ) , ...
    'isdataset', false, ...
    'isreport', false, ...
    'execute', false );

for ii = 1 : numel( varargin )
    if ischar( varargin{ii})
        switch varargin{ii}
            case 'title'
                param.title = varargin{ii+1};
        end
    end
end

%% Find the first time a paramter is called

lastid = numel( varargin );
if nargin > 1
    cid = find( cellfun( @(x)ischar( x ), varargin ) );
    if numel(cid) == 0
        lastid = numel( varargin );
    else
        lastid = find( ismember( {varargin{cid}}, keys), 1,'first');
        if numel(lastid) > 0
            lastid = cid(lastid)-1;
        else
            lastid = numel( varargin );
        end
    end
else
    lastid = 1;
end



%% Post Type
% Determine the post type
% If varargin{1} is
%    a function or structure - then a dataset is generated
%    a script - then a report is generated
% This process selects the next steps in scripting the post.

if iscell( varargin{1} ) | isstruct( varargin{1} )
    % dataset
    param.isdataset = true;
elseif ischar( varargin{1} )
    % report
    param.isreport = true;
    param.execute = true;
else
    try
        f = functions( varargin{1} );
        % dataset
        param.isdataset = true;
        param.execute = true;
    catch
        % error
    end
end

%% Parse Outputs

timenow = clock;
if param.isreport
    % Always default and send the contents to assets
    fmatpub = publish( varargin{1:lastid}, 'outputDir', fullfile('.','assets') );
    param.layout = 'report';
elseif param.isdataset
    if param.execute
        [ varargout{1:nargout} ] = varargin{1}( varargin{2:lastid} );
    else
        varargout = { varargin{1} };
    end
    param.layout = 'dataset';
else
    error('something bad happened');
end


if ~isdir( '_posts')
    mkdir('_posts');
end
to_file = fullfile( '_posts', sprintf( '%04i-%02i-%02i-%s.html', timenow(1), timenow(2), timenow(3), regexprep( param.title,' ','-') ) );

%% Write pages

fto = fopen( to_file ,'w');

%% YAML FRONT MATTER

fprintf( fto, '---\nlayout: %s\ntitle: %s\n', param.layout,regexprep( param.title,'-',' ') );

% close front matter header if is a report
if param.isreport
    fprintf(fto, '\n---\n');
    disp('Running Matlab''s publish function.');
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
    
    % Insert a javascript to reorganize image paths
    for ii = 1 : size(WebDat,1)
        fprintf( fto, '%s\n', WebDat(ii,:) );
    end
    % End report
else % STart dataset
    dskyfld = {'name','comment','image','url','link','description','include','html'};
    
    kyfld = {'value'};
    rpopt = {'title'};
    
    % Collective dataset level
    if lastid ~= numel( varargin )
        for ii = 1 : numel( rpopt )
            argid = cid(find(strcmp( cellstr({varargin{cid}}), rpopt{ii} )));
            if numel( argid ) > 0
                fprintf(fto, '%s: %s\n', rpopt{ii}, varargin{ argid + 1 });
            end
        end
    end
    
    
    %% Variable names
    unique_variables = {};
    for ii = 1 : numel( varargout{1} )
        if isstruct( varargout{1} ) || isnumeric( varargout{1} )
            flds = fieldnames( varargout{1}(ii) );
            GetEl = @(x)varargout{1}(x);
        elseif iscell( varargout{1} );
            flds = fieldnames( varargout{1}{ii} );
            GetEl = @(x)varargout{1}{x};
        end
        
        newfields = fieldnames(GetEl(ii));
        unreserved = logical(zeros( 1, numel( newfields ) ));
        for nn = 1 : numel( newfields )
            
            if ~ismember( newfields{nn}, dskyfld )
                unreserved(nn) = numel(getfield( GetEl(ii), newfields{nn} )) == 1;
            end
        end
        
        flds = fieldnames(GetEl(ii));
        if any( unreserved )
            unique_variables = union( unique_variables, {flds{unreserved}});
        end
    end
    
    
    fprintf( fto, 'var:\n' );
    for ii = 1 : numel( unique_variables )
        fprintf( fto, '  - %s\n', unique_variables{ii} );
    end
    
    
    % Individual dataset level
    fprintf( fto,'data: \n' );
    
    for ii = 1 : numel( varargout{1} )
        
        if isstruct( varargout{1}(ii) ) || isnumeric( varargout{1}(ii) )
            flds = fieldnames( varargout{1}(ii) );
            GetEl = @(x)varargout{1}(x);
        elseif iscell( varargout{1}(ii) );
            flds = fieldnames( varargout{1}{ii} );
            GetEl = @(x)varargout{1}{x};
        end
        
        
        
        for jj = 1 : numel( flds )
            fldstruct = getfield( GetEl(ii), flds{jj} );
            % All of this is performed on the first pass
            if jj == 1
                % dataset metadata
                initky = true;
                for kys = 1 : numel(dskyfld)
                    
                    [ fldval cont ] = CheckGetField( GetEl(ii),  dskyfld{kys} );
                    if cont
                        
                        if initky
                            fprintf( fto, '- %s: \n', dskyfld{kys});
                            initky=false;
                        else
                            fprintf( fto, '  %s: \n', dskyfld{kys});
                        end
                        
                        if iscell( fldval )
                            for qq = 1 : numel( fldval )
                                fprintf( fto, '  - %s \n', fldval{qq} );
                            end
                        else
                            fprintf( fto, '  - %s \n', fldval );
                        end
                        
                    end
                end
                if initky
                    fprintf( fto, '- metadata:\n');
                else
                    fprintf( fto, '  metadata:\n');
                end
            end
            
            
            
            if ~ismember( flds{jj}, dskyfld )
                fprintf( fto, '  - var: %s\n', flds{jj} );
                if isnumeric( fldstruct ) && numel( fldstruct ) == 1
                    fprintf( fto, '    value: %f\n', fldstruct );
                else
                    N = ndims( fldstruct );
                    fprintf( fto, '    dims: \n' );
                    for nn = 1 : N
                        fprintf( fto, '     - %i\n', size( fldstruct, nn) );
                    end
                    fprintf( fto, '    type: %s\n', class(fldstruct) );
                end
                
                for kys = 1 : numel( kyfld )
                    %                     [ fldval cont ] = CheckGetField( fldstruct, kyfld{kys} );
                    %                     if numel( fldval) > 1
                    %                         keyboard
                    %                     end
                    %                     if cont
                    %
                    %
                    %
                    %                     end
                end
            end
        end
    end
    
end

%% CLOSE FILES

if param.isdataset
    fprintf(fto, '\n---\n');
end
fclose(fto);

end % END function

%% DEPENDENCIES

%% For Reports

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


%% For Datasets
function [ value cont ] = CheckGetField( S, fld )
if isfield( S, fld)
    value = getfield( S, fld );
    cont = true;
else
    value = nan;
    cont = false;
end
end
