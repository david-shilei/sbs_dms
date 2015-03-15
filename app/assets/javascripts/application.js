// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap/dropdown
//= require bootstrap/modal
//= require bootstrap/alert
//= require bootstrap/collapse
//= require bootstrap/transition
//= require bootstrap/tooltip
//= require bootstrap/popover
//= require turbolinks
//= require_tree .

/* Listen for click events on list item documents */
$(document).ready(function($) {
  $(".list-item").click(function() {
    // redirect to document#show when clicking on list item
    window.document.location = $(this).attr("href");
  });
});

/* Listen for Bootstrap popover events */
$(document).ready(function(){
  $('button').popover({ html: true, animation: true });
});