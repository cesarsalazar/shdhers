$(document).ready(function(){
		var token = 'UA-00000000-0';
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    $.getScript(gaJsHost + "google-analytics.com/ga.js", function(){

        try {
            var pageTracker = _gat._getTracker(token);
            pageTracker._trackPageview();
        } catch(err) {}

        var filetypes = /\.(zip|exe|pdf|doc*|xls*|ppt*|mp3)$/i;

        $('a').each(function(){
            var href = $(this).attr('href');

            if ((href.match(/^https?\:/i)) && (!href.match(document.domain))){
                $(this).click(function() {
                    var extLink = href.replace(/^https?\:\/\//i, '');
                    pageTracker._trackEvent('External', 'Click', extLink);
                });
            }
            else if (href.match(/^mailto\:/i)){
                $(this).click(function() {
                    var mailLink = href.replace(/^mailto\:/i, '');
                    pageTracker._trackEvent('Email', 'Click', mailLink);
                });
            }
            else if (href.match(filetypes)){
                $(this).click(function() {
                    var extension = (/[.]/.exec(href)) ? /[^.]+$/.exec(href) : undefined;
                    var filePath = href.replace(/^https?\:\/\/(www.)mydomain\.com\//i, '');
                    pageTracker._trackEvent('Download', 'Click - ' + extension, filePath);
                });
            }
        });
    });
});