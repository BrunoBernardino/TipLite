###
tipLite v2.0 by Bruno Bernardino | 2013.03.22 | https://github.com/BrunoBernardino/TipLite
###
# Helper function to generate a unique id, GUID-style. Idea from http://guid.us/GUID/JavaScript
helpers = generateID: ->
	S4 = ->
		(((1 + window.Math.random()) * 0x10000) | 0).toString(16).substring 1

	(S4() + S4() + "-" + S4() + "-4" + S4().substr(0, 3) + "-" + S4() + "-" + S4() + S4() + S4()).toLowerCase()

methods =
	init: (options) ->
		defaults =
			dataTooltip:     "tiplite" # data-* property to check for the tooltip's content
			dataPosition:    "tiplitePosition" # data-* property to check for the tooltip's position
			tooltipClass:    "tipLite"
			position:        "above" # Supports 'above', 'below', 'left' and 'right'
			positionMargin:  10
			animationType:   "fade" # Supports 'fade' and 'slide'
			animationSpeed:  "fast"
			animationEasing: "swing"
			animationOnComplete: $.noop
			followMouse:     true

		options = $.extend(defaults, options)
		@each ->
			$this = $(this)
			data = $this.data("tipLite")

			unless data
				$this.data "tipLite",
					target: $this

				# Create the tooltip
				methods.create.call this, options

				# Bind the show on mouse in/hover
				$(this).on "mouseenter.tipLite", ->
					methods.show.call this, options

				# Bind the hide on mouse out
				$(this).on "mouseleave.tipLite", ->
					methods.hide.call this, options

				if options.followMouse

					# Bind the chaseCursor in mouse move
					$(this).on "mousemove.tipLite", (event) ->
						methods.chaseCursor.call this, event, options

	destroy: ->
		$(window).off ".tipLite"
		@each ->
			$this = $(this)
			data = $this.data("tipLite")
			$this.removeData "tipLite"


	create: (options) ->
		$this = $(this)
		data = $this.data("tipLite")
		chosenPosition = options.position
		tooltipContent = ""
		
		# Get the tooltip content, and if it doesn't exist, default to the title attribute
		unless $this.data(options.dataTooltip)
			tooltipContent = $this.attr("title")
		else
			tooltipContent = $this.data(options.dataTooltip)
		
		# We now need to empty the title attribute to avoid the default browser behavior and showing it together with the tooltip
		$this.attr "title", ""
		generatedID = helpers.generateID.call(this)
		tipLiteID = "tipLite-#{ generatedID }"
		tipLiteHTML = "<div id=\"#{ tipLiteID }\" class=\"#{ options.tooltipClass }\">#{ tooltipContent }</div>"
		
		# Add the tooltip inside the body
		$(tipLiteHTML).appendTo "body"
		
		# Store the tipLiteID in the calling/parent element
		data.tipLiteID = tipLiteID
		
		# Check if there is a position set in the element
		chosenPosition = $this.data(options.dataPosition)	if $this.data(options.dataPosition)
		unless options.followMouse
			
			# Get the real element's width & height, by creating a dummy clone inline element with the same content and using it as reference
			dummyElement = $this.clone().css(
				display: "inline"
				visibility: "hidden"
			).appendTo("body")
			
			# Put the tooltip in the same "starting position", so the positioning is consistent and flexible: in the bottom left of the calling/parent element
			$("#" + tipLiteID).css
				top: $this.offset().top + dummyElement.outerHeight()
				left: $this.offset().left

			
			# Get the appropriate margin-left so we can position the tooltip in the center of the element, horizontally
			marginLeft = (dummyElement.outerWidth() - $("#" + tipLiteID).outerWidth()) / 2
			marginTop = ((dummyElement.outerHeight() + $("#" + tipLiteID).outerHeight() + options.positionMargin) * -1)
			
			# Position the tooltip to the left, right, above, or below the element
			switch chosenPosition
				when "left"
					marginTop = (dummyElement.outerHeight() * -1)
					marginLeft = ((dummyElement.outerWidth() + options.positionMargin) * -1)
				when "right"
					marginTop = (dummyElement.outerHeight() * -1)
					marginLeft = dummyElement.outerWidth() + options.positionMargin
				when "below"
					marginTop = options.positionMargin
				else #"above"
			
			# We don't need to do anything here, as the default marginTop is for this 'above' position already
			$("#" + tipLiteID).css
				"margin-top": marginTop
				"margin-left": marginLeft

			
			# Check if the tooltip element is cropped on the top of the window view
			$("#" + tipLiteID).css "margin-top": 0	if ($this.offset().top + marginTop) < 0
			
			# Check if the tooltip element is cropped on the bottom of the window view
			if ($this.offset().top + marginTop + $("#" + tipLiteID).outerHeight()) > $(document).height()
				heightDifference = $("#" + tipLiteID).offset().top + $("#" + tipLiteID).outerHeight() - $(document).height()
				$("#" + tipLiteID).css "margin-top": ($("#" + tipLiteID).css("margin-top") - heightDifference)
			
			# Check if the tooltip element is cropped on the left of the window view
			$("#" + tipLiteID).css "margin-left": 0	if ($this.offset().left + marginLeft) < 0
			
			# Check if the tooltip element is cropped on the right of the window view
			if $this.offset().left + marginLeft + $("#" + tipLiteID).outerWidth() > $(document).width()
				widthDifference = $("#" + tipLiteID).offset().left + $("#" + tipLiteID).outerWidth() - $(document).width()
				$("#" + tipLiteID).css "margin-left": ($("#" + tipLiteID).css("margin-left") - widthDifference)
			
			# Store these values, as we might need them
			data.marginLeft = $("#" + tipLiteID).css("margin-left")
			data.marginTop = $("#" + tipLiteID).css("margin-top")
			
			# Remove the dummy element
			dummyElement.remove()

	show: (options) ->
		$this = $(this)
		data = $this.data("tipLite")
		tipLiteElement = $("#" + data.tipLiteID)
		
		# Animate tooltip showing
		switch options.animationType
			when "slide"
				finalMarginLeft = parseInt(data.marginLeft, 10)
				tipLiteElement.stop().css(
					opacity: 0
					display: "block"
					"margin-left": (finalMarginLeft - (options.positionMargin * 2))
				).animate
					opacity: 1
					"margin-left": finalMarginLeft
				, options.animationSpeed, options.animationEasing, options.animationOnComplete
			else # "fade"
				tipLiteElement.stop().fadeIn options.animationSpeed, options.animationEasing, options.animationOnComplete

	hide: () ->
		$this = $(this)
		data = $this.data("tipLite")
		$("#" + data.tipLiteID).stop().hide()

	hideAllTipLites: (options) ->
		$("." + options.tooltipClass).stop().hide()

	chaseCursor: (event, options) ->
		$this = $(this)
		data = $this.data("tipLite")
		chosenPosition = options.position
		topPosition = 0
		leftPosition = 0
		
		# Check if there is a position set in the element
		chosenPosition = $this.data(options.dataPosition)	if $this.data(options.dataPosition)
		tipLiteElement = $("#" + data.tipLiteID)
		leftPosition = event.pageX + options.positionMargin
		switch chosenPosition
			when "below"
				topPosition = event.pageY + options.positionMargin
			else # "above"
				topPosition = event.pageY - options.positionMargin - tipLiteElement.outerHeight()
		tipLiteElement.css
			top: topPosition
			left: leftPosition


$.fn.tipLite = (method) ->
	if methods[method]
		methods[method].apply this, Array::slice.call(arguments, 1)
	else if typeof method is "object" or not method
		methods.init.apply this, arguments
	else
		$.error "Method #{ method } does not exist on jQuery.tipLite"