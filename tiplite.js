/***
LiteTip by Bruno Bernardino - www.brunobernardino.com
v1.0 - 2010/10/27
***/
jQuery.fn.tipLite = function(options) {
	var opts = $.extend({}, $.fn.tipLite.defaults, options);
	
	this.each(function() {
		var $this = $(this);
		
		$this.mouseover(function(e) {
			var tip = $(this).attr('title');
			$(this).attr('title','');
			
			$(this).append('<div id="tipLite">' + tip + '</div>');
			
			$('#tipLite').fadeIn(opts.fadeSpeed);
			
		}).mousemove(function(e) {
			$('#tipLite').css('top', e.pageY + 10 );
			$('#tipLite').css('left', e.pageX + 20 );
		}).mouseout(function() {
			$(this).children('#tipLite').hide();
			$(this).attr('title',$('#tipLite').html());
			$(this).children('#tipLite').remove();
		});
	});
};

jQuery.fn.tipLite.defaults = {
	fadeSpeed: 'fast'
};