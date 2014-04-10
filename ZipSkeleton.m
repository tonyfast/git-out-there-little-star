fn = dir('.');

% exclude files in zip
exc = {'_site','.git','*~','.','..','.gitignore','ZipSkeleton.m~','ZipSkeleton.m'};

zip('jekyll-skeleton.zip',{fn( find(~ismember( {fn.name}, exc ))).name});

