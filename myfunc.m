function S = myfunc( k, val )

if nargin == 0;
    k = 'array';
end

if nargin < 2
    val = rand(100,300);
end

%% A test figure

pcolor( rand(100));
nm ='matin-test.png';
saveas( gcf, fullfile('/Users/afast3/Dropbox/Public/',nm));

plot(rand(1,100));
nm2 ='matin-test-2.png';
saveas( gcf, fullfile('/Users/afast3/Dropbox/Public/',nm2));


switch k
    case 'array'
        S(1).gopher = 1
        S(2).gopher = val;
        S(1).cow = rand(1);
        S(2).cow = peaks(111);
        S(2).image = horzcat('https://dl.dropboxusercontent.com/u/22455492/',nm2);
        S(1).name = 'Test Dataset Name';
        S(2).name = 'Waldo Waldorf III';
        S(1).image{1} = horzcat('https://dl.dropboxusercontent.com/u/22455492/',nm);
        S(1).image{2} = horzcat('https://dl.dropboxusercontent.com/u/22455492/',nm);
    case 'cell'
        S{1}.comment = 'Yo we fly';
        S{1}.gopher = 1
        S{2}.gopher = val;
        S{2}.beaver = rand(10);
        S{3}.beaver = 9;
        S{3}.octopus = rand(100,20);
        S{3}.name = 'Waldo Waldorf III';
        S{1}.image = horzcat('https://dl.dropboxusercontent.com/u/22455492/',nm);
end
 