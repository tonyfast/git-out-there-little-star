Git Out There Little Star
=========================

**Git Out There Little Star** is a Jekyll template designed to rapidly publish webpages compiled using Matlab's [``publish``](http://www.mathworks.com/help/matlab/ref/publish.html).

Let your codes shine while in development.  Rapidly share your progress with your advisor, boss, mentor, or collaborator.  Git Out There Little Star wraps up published HTML Matlab code into a format for use with [Github pages](pages.github.com) and [Jekyll](www.jekyllrb.com), the blog-aware, static site generater.

Currently, this project a basic familiarity with the Git command line.

## Getting Started

1. Initialize Github Thingie
 
  Create a [new](www.github.com/new) Github repository and initialize it locally.

2. Set up the Projects Github Pages

  *[Github Pages](https://pages.github.com/) provide web hosting services.  This project requires that your username.github.io is set up.  The Github command line tool should be installed too.*
  
  In your local repository, create and switch to the ``gh-pages`` that is the web server
  
  ``
  !git checkout -b gh-pages
  ``
  
  ``!`` is only needed in the Matlab command window.
  

3. Download and Unpack the Jekyll Skeletion on the ``gh-pages`` branch


  The following steps need to be completed once for the repo.  Copy the following code
  
  ```
   unzip('https://github.com/tonyfast/jekyll-skeleton/raw/master/jekyll-skeleton.zip');
   jekfiles = dir( 'jekyll-skeleton' );
   arrayfun(@(x)movefile(horzcat('jekyll-skeleton/',x.name),x.name),jekfiles(3:end));
   rmdir( 'jekyll-skeleton','s');
  ```
  
  or Download this [Gist](https://gist.github.com/tonyfast/10406766) which will be most up-to-date.
  
4. Modify _config.yml

  Change ``baseurl: /jekyll-skeleton`` to ``baseurl: /your-repo``
  The website will be hosted at [username.github.io/your-repo](username.github.io/your-repo).

5. Publish Your Jekyll Page 

   Use the same syntax that [``publish``](http://www.mathworks.com/help/matlab/ref/publish.html) except replace publish with ``jekyllpublish``.

