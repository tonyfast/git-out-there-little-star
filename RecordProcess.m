function varargout = RecordProcess( varargin )
%%
% Options
% Title
%%

%%

toyaml = 'tofile.yml';

fo = fopen( toyaml, 'w' );
fprintf(fo, '---\n');
%%

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


%%

% dataset keys
dskyfld = {'comment','name'};
% variable keys
kyfld = {'value','image','url','description','include','html'};


for ii = 1 : numel( varargout{1} )
    if isstruct( varargout{1} ) || isnumeric( varargout{1} )
        varargout{1}(ii)
        flds = fieldnames( varargout{1}(ii) );
        GetEl = @(x)varargout{1}(x);
    elseif iscell( varargout{1} );
        flds = fieldnames( varargout{1}{ii} );
        GetEl = @(x)varargout{1}(x);
    end
    
    for jj = 1 : numel( flds )
        fldstruct = getfield( GetEl(ii), flds{jj} );
        if jj == 1
            fprintf( fo, '- metadata:\n' )
            for kys = 1 : numel(dskyfld)
                
                [ fldval cont ] = CheckGetField( GetEl(ii), dskyfld{kys} );
                if cont && numel(fldval) > 0
                    fprintf( fo, '  %s: %s\n', dskyfld{kys}, fldval );
                end
            end
        end
        
        
        if ~ismember( flds{jj}, dskyfld )
            fprintf( fo, '  - var: %s\n', flds{jj} )
            
            for kys = 1 : numel( kyfld )
                [ fldval cont ] = CheckGetField( fldstruct, kyfld{kys} );
                if cont
                    
                    switch kyfld{kys}
                        case 'value'
                            if isnumeric( fldval ) && numel( fldval ) == 1
                                fprintf( fo, '    value: %i\n', fldval )
                            else
                                N = ndims( fldval );
                                fprintf( fo, '    size: \n' );
                                for nn = 1 : N
                                    fprintf( fo, '    - dim: %i\n', size( fldval, nn) );
                                end
                                fprintf( fo, '    type: %s\n', class(fldval) );
                            end
                        otherwise
                            fprintf( fo, '    %s: \n', kyfld{kys} )
                            
                            fldval = cellstr(fldval );
                            for nn = 1 : numel( fldval )
                                fprintf( fo, '    - %s\n', fldval{nn} );
                            end
                    end
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
