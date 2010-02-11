var Home = function($){ 
  var delay = 9000;
	var speed = 1500;

	var scrollEvents = function () {
	  var move = function (e) {
	    return function() {
	      $(e).hide().remove().prependTo("#events");
	    };
	  };

	  $("#events li:hidden").filter(":last").slideDown(speed);

	  var e = $("#events li:visible").filter(":last");
	  e.slideUp(speed, move(e));

	  setTimeout(scrollEvents, delay);
	};
	
	return {
		rotateEvents: function (limit) {
			$(document).ready(function() {
				if ($("#events li").size() > limit) {
				  setTimeout(scrollEvents, delay);
				}
			});
		}
	};
}(jQuery);
