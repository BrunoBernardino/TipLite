/***
TipLite by Bruno Bernardino - www.brunobernardino.com
v1.1 - 2012/04/24
***/
jQuery.fn.tipLite = function(options) {
	var opts = $.extend({}, $.fn.tipLite.defaults, options);
	
	this.each(function() {
		var sourceElement = this;
		
		$(sourceElement).mouseover(function(e) {
			var tip = $(this).prop('title');
			$(this).prop('title', '');
			
			$(this).append('<div id="tipLite">' + tip + '</div>');

			if (opts.staticPosition) {
				$('#tipLite').css('top', $(sourceElement).offset().top);
				$('#tipLite').css('left', $(sourceElement).offset().left);
				switch (opts.staticPosition) {
					case 'left':
						$('#tipLite').css('margin-left', ($('#tipLite').outerWidth() + 10) * -1 );
					break;
					case 'right':
						$('#tipLite').css('margin-left', $(sourceElement).outerWidth() + 10 );
					break;
					case 'top':
						$('#tipLite').css('margin-top', ($(sourceElement).innerHeight() + 10) * -1 );
						$('#tipLite').css('margin-left', ($(sourceElement).outerWidth() - $('#tipLite').outerWidth()) / 2 );
					break;
					case 'bottom':
					default:
						$('#tipLite').css('margin-top', $(sourceElement).innerHeight() + 10 );
						$('#tipLite').css('margin-left', ($(sourceElement).outerWidth() - $('#tipLite').outerWidth()) / 2 );
					break;
				}
			}
			
			$('#tipLite').fadeIn(opts.fadeSpeed);
			
		}).mousemove(function(e) {
			if (!opts.staticPosition) {
				$('#tipLite').css('top', e.pageY + 10 );
				$('#tipLite').css('left', e.pageX + 20 );
			}
		}).mouseout(function() {
			$(this).children('#tipLite').hide();
			$(this).prop('title', $('#tipLite').html());
			$(this).children('#tipLite').remove();
		});
	});
};

jQuery.fn.tipLite.defaults = {
	fadeSpeed: 'fast',
	staticPosition: null
};