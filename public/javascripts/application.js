var delay = 6000;
var count = 30;
var showing = 10;
var speed = 700;
var i = 0;
function move(i) {
  return function() {
    $('#event_'+i).remove().css('display', 'none').prependTo('#events-list');
  }
}
function scrollEvents() {
  var toShow = (i + showing) % count;
  $('#event_'+toShow).slideDown(speed, move(i));
  $('#event_'+i).slideUp(speed, move(i));
  i = (i + 1) % count;
  setTimeout('scrollEvents()', delay);
}    
$(document).ready(function() {
  setTimeout('scrollEvents()', delay);
});
