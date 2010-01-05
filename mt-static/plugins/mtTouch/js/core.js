/*
 * WPtouch 1.9.x -The WPtouch Core JS File
 * This file holds all the default jQuery & Ajax functions for the theme
 * Copyright (c) 2008-2009 Duane Storey & Dale Mugford (BraveNewCode Inc.)
 * Licensed under GPL.
 *
 * Last Updated: December 24th, 2009
 */

/////// -- Get out of frames! -- ///////
if (top.location!= self.location) {top.location = self.location.href}


/////// -- Let's play nice in jQuery -- ///////
//$wptouch = jQuery.noConflict();


/////// -- Switch Magic -- ///////
function wptouch_switch_confirmation() {
if (document.cookie && document.cookie.indexOf("wptouch_switch_cookie") > -1) {
// just switch
	$("a#switch-link").toggleClass("offimg");
	setTimeout('switch_delayer()', 1250); 
} else {
// ask first
	var answer = confirm("Switch to regular view? \n \n You can switch back to mobile view again in the footer.");
	if (answer){
	$("a#switch-link").toggleClass("offimg");
	setTimeout('switch_delayer()', 1350); 
		}
	}
}

setTimeout(function() { $('#prowl-success').fadeOut(400); }, 5250);
setTimeout(function() { $('#prowl-fail').fadeOut(400); }, 5250);

//  function wptouch_toggle_text() {
//	  $("p").toggleClass("fontsize");
//  }


/////// -- Menus -- ///////
// Creating a new function, fadeToggle()
$.fn.fadeToggle = function(speed, easing, callback) { 
	return this.animate({opacity: 'toggle'}, speed, easing, callback); 
};
 
function bnc_jquery_menu_drop() {
	$('#wptouch-menu').fadeToggle(400);
	$("#headerbar-menu a").toggleClass("open");
}

function bnc_jquery_login_toggle() {
	$('#wptouch-login').fadeToggle(400);
}

function bnc_jquery_search_toggle() {
	$('#wptouch-search').fadeToggle(400);
}

function bnc_jquery_gigpress_toggle() {
	$('#wptouch-gigpress').fadeToggle(400);
}


function bnc_jquery_prowl_open() {
	$('#prowl-message').fadeToggle(400);
}

function bnc_jquery_wordtwit_open() {
	$('#wptouch-wordtwit').fadeToggle(400);
}


/////// -- Ajax comments -- ///////
function bnc_showhide_coms_toggle() {
	$('#commentlist').fadeToggle(400);
	$("img#com-arrow").toggleClass("com-arrow-down");
	$("h3#com-head").toggleClass("comhead-open");
}

function commentAdded() {
    if ($('#errors')) {
        $('#errors').hide();
	}
        
    if ($('#nocomment')) {
        $('#nocomment').hide();
    }
    
    if($('#hidelist')) {
        $('#hidelist').hide();
    }

    $("#commentform").hide();
    $("#the-new-comment").fadeIn(400);
    $("#refresher").fadeIn(400);
}


/////// --Single Post Page -- ///////

function wptouch_toggle_twitter() {
	$('#twitter-box').fadeToggle(400);
}

function wptouch_toggle_bookmarks() {
	$('#bookmark-box').fadeToggle(400);
}

/////// --jQuery Tabs-- ///////

$(function () {
    var tabContainers = $('#menu-head > ul');
    
    $('#tabnav a').click(function () {
        tabContainers.hide().filter(this.hash).show();
        
        $('#tabnav a').removeClass('selected');
        $(this).addClass('selected');
        
        return false;
    }).filter(':first').click();
});

/////// -- Tweak jQuery Timer -- ///////
$.timerId = setInterval(function(){
	var timers = jQuery.timers;
	for (var i = 0; i < timers.length; i++) {
		if (!timers[i]()) {
			timers.splice(i--, 1);
		}
	}
	if (!timers.length) {
		clearInterval(jQuery.timerId);
		jQuery.timerId = null;
	}
}, 83);

// End WPtouch jS

