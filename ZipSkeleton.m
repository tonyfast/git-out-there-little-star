fn = dir('.');

exc = {'_site','.git','*~','.','..','.gitignore'};

zip('jekyll-skeleton.zip',{fn( find(~ismember( {fn.name}, exc ))).name});

