function varargout = RecordProcess( varargin )
%%
% Options
% Title
%% Keywords
dskyfld = {'name','comment','image','url','link','description','include','html'};

%%

toyaml = '_posts/2012-07-14-testdset.html';

fo = fopen( toyaml, 'w' );
fprintf(fo, '---\nlayout: dataset\n');
%% Function Options

rpopt = {'title'};
if nargin > 1
    cid = find( cellfun( @(x)ischar( x ), varargin ) );
    if numel(cid) == 0
        lastid = numel( varargin );
    else
        lastid = find( ismember( {varargin{cid}}, rpopt), 1,'last');
        lastid = cid(lastid)-1;
    end
else
    lastid = 1;
end

%% Write Options

if lastid ~= numel( varargin )
    for ii = 1 : numel( rpopt )
        argid = cid(find(strcmp( cellstr({varargin{cid}}), rpopt{ii} )));
        if numel( argid ) > 0
            fprintf(fo, '%s: %s\n', rpopt{ii}, varargin{ argid + 1 });
        end
    end
end

%% Execute Process

[ varargout{1:nargout} ] = varargin{1}( varargin{2:lastid} );

% varargout{1} must be a cell array with elements of structures
%% Unique Searchable Variables


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
            unreserved(nn) = numel(getfield( GetEl(ii), newfields{nn} )) == 1
        end
    end
    
    flds = fieldnames(GetEl(ii));
    if any( unreserved )
        unique_variables = union( unique_variables, {flds{unreserved}});
    end
end


fprintf( fo, 'var:\n' );
for ii = 1 : numel( unique_variables )
    fprintf( fo, '  - %s\n', unique_variables{ii} );
end

%% Start data output

fprintf( fo,'data: \n' );

% dataset keys

% variable keys
kyfld = {'value'};


for ii = 1 : numel( varargout{1} )
    if isstruct( varargout{1} ) || isnumeric( varargout{1} )
        flds = fieldnames( varargout{1}(ii) );
        GetEl = @(x)varargout{1}(x);
    elseif iscell( varargout{1} );
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
                        fprintf( fo, '- %s: \n', dskyfld{kys});
                        initky=false;
                    else
                        fprintf( fo, '  %s: \n', dskyfld{kys});
                    end
                    
                    if iscell( fldval )
                        for qq = 1 : numel( fldval )
                            fprintf( fo, '  - %s \n', fldval{qq} );
                        end
                    else
                        fprintf( fo, '  - %s \n', fldval );
                    end
                    
                end
            end
        end
        
        if jj == 1
            fprintf( fo, '  metadata:\n');
        end
        
        if ~ismember( flds{jj}, dskyfld )
            fprintf( fo, '  - var: %s\n', flds{jj} );            
            if isnumeric( fldstruct ) && numel( fldstruct ) == 1
                fprintf( fo, '    value: %f\n', fldstruct );
            else
                N = ndims( fldstruct );
                fprintf( fo, '    dims: \n' );
                for nn = 1 : N
                    fprintf( fo, '     - %i\n', size( fldstruct, nn) );
                end
                fprintf( fo, '    type: %s\n', class(fldstruct) );
            end
            
            
            
            
            
            for kys = 1 : numel( kyfld )
                [ fldval cont ] = CheckGetField( fldstruct, kyfld{kys} );
                if numel( fldval) > 1
                    keyboard
                end
                if cont
                    
                    
                    
                end
            end
        end
    end
end
fprintf(fo, '---\n');
fclose(fo);

end

%%

function [ value cont ] = CheckGetField( S, fld )
if isfield( S, fld)
    value = getfield( S, fld );
    cont = true;
else
    value = nan;
    cont = false;
end
end

%%
