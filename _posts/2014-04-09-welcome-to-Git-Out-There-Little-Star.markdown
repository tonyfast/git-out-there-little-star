---
layout: bootstrap
title:  "Welcome to Git Out There Little Star!"
date:   2014-04-09 22:25:24
tags: rapid publish data metadata
---

## Git Out There Little Star

This project replaces Matlab's ``publish`` with ``jekyllpublish`` to instantly generate blog-aware, static webpages hosted by Github pages and Jekyll.

## Getting Started

This package makes it very easy to integrate Matlab's HTML publishing capabilities with Github pages.  To use this package
it is necessary to have an existing Github repository.  Using Matlab, simply copy and paste the following code into Matlab Command Window on the ``gh-pages`` branch of your repository.

{% gist tonyfast/10406766 %}

This script initializes the [Jekyll](www.jekyllrb.com) templates that [Github pages](pages.github.com) interpret.

## Matlab Markup

This project requires that Matlab scripts are written in [Matlab's markup](www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html) language.  The markup language assures that webpages are interpreted appropriately.

## Using GOTLiSt

Simply execute the command

``jekyllpublish( 'post-title','script_name.m','arg1',val1,.., 'argN',varN, 'jparg1', jpval1, .., 'jpargN', jpvalN)``

### Inputs Describe

  - ``post-title`` - The title of the blog post, *hyphens are interpretted as spaces*.
  - ``script_name.m`` - The name of the script that is being published
  - ``arg*``, ``val*`` - These arguments the same as the arguments in [``publish``](http://www.mathworks.com/help/matlab/ref/publish.html).
  - ``jparg*``, ``jpval*`` - These arguments are interpretted by ``jekyllpublish`` to include widgets and formatting.


## Jekyll Modifications

The following modifications were made to the Jekyll skeleton

- ``baseurl`` was inserted in ``_config.yml`` and each ``_layout``.
- ``/assets/javascript/swapSrc.js`` changes ``<img>`` src to the ``assets`` directory.
- jekyllpublish

  1. Publishes a Matlab script to the ``/assets`` folder.

     ``/assets`` holds images and HTML created by the ``jekyllpublish`` function by default.

  2. The ``*.html`` file Matlab creates is moved to the ``_posts`` folder where Jekyll interprets blog posts

     During the move:
     - The name of the post is given a title.
     - Some of the native Matlab publishing HTML is changed.
     - Widgets can be added to
       - [Disqus](www.disqus.com) - A global comment system that only requires a user name.

          ``jekyllpublish( 'post-title','script_name.m','DisqusOn', 'tonyfast')``

          ``tonyfast`` is the username that Disqus comment system will be associated with.


## Using Jekyll

Check out the [Jekyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll's GitHub repo][jekyll-gh].

[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com

{% include disqus.html %}     
