function swapSrc( baseurl, imgurl ) {
    // Get all images on the document
    var images = document.getElementsByTagName('img');

    // Count the number of image elements and switch alt and src
    var i = images.length;
    while (i--) {
        images[i].src =  baseurl + imgurl + "/" + 
        images[i].src.split('/').slice(-1)[0];
    }
};


// Usage
// Replace <body> in Matlab's published html file with
//
// <script type="text/javascript" src="{{site.baseurl}}/assets/javascripts/swapSrc.js"></script>
// <body onload="swapSrc('{{site.baseurl}}','{{site.imgbase}}')">