%%  Installing an executing a workflow
% 
%% Download a Git Repository

if ~isdir( './SpatialStatisticsFFT' )
    system('sudo git clone https://github.com/tonyfast/SpatialStatisticsFFT.git');
    addpath( genpath( './SpatialStatisticsFFT' ) );
end

%% Create a dataset with spatial fields

S.phase = round(checkerboard(10));

%% Compute Spatial Statistics on the phase

S.stats = SpatialStatsFFT( S.phase,[],'display', true );

% Save the displayed spatial statistics
S.image{1} = 'testwf-stats-1.png';
S.image{2} = 'testwf-stats-2.png';
S.name = 'Example dataset when using workflows';
saveas( gcf, './assets/testwf-stats-1.png' );

pcolor( S.phase );
saveas( gcf, './assets/testwf-stats-2.png' );
drawnow;
%%

matinpublish( S, 'title', 'Workflow Test Output' )


%%
% wrap the output results

S = rmfield( S, 'image' );

wrapout = @(x)setfield( x, 'stats', SpatialStatsFFT( x.phase,[],'display', true ) );

matinpublish( wrapout, S, 'title', 'Workflow Test Execute' );
drawnow;

%% Create a Report
