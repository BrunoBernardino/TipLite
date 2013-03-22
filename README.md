# tipLite - A Lightweight & Simple jQuery Tooltip Plugin

tipLite is a lightweight & simple jQuery tooltip plugin. Currently at version 2.0, it's now built in CoffeeScript, compiled to unminified and minified JavaScript.

It's built off of Chapter 3 of Pro jQuery Plugins ( http://projqueryplugins.com ).

## Usage

Get https://raw.github.com/BrunoBernardino/TipLite/master/jquery.tiplite.min.js and https://raw.github.com/BrunoBernardino/TipLite/master/jquery.tiplite.css, include them in your site and call the following (supposing you'd want tooltips on all img elements):

>> $("img").tipLite();

## Features

* HTML5 data-* attributes, and falls back to the title attribute
* 4 positions for the tooltip (above, below, left, and right)
* 2 "show" animation types: "fade" and "slide"
* Callback support for when the "show" animation finishes
* Tooltip following the mouse option

## Dev features

* Namespaced events
* jQuery 1.9.1 tested
* Callable plugin methods
* CoffeeScript & SCSS

## Available Options & Default Values

* dataTooltip:     "tiplite" # data-* property to check for the tooltip's content
* dataPosition:    "tiplitePosition" # data-* property to check for the tooltip's position
* tooltipClass:    "tipLite"
* position:        "above" # Supports 'above', 'below', 'left' and 'right'
* positionMargin:  10
* animationType:   "fade" # Supports 'fade' and 'slide'
* animationSpeed:  "fast"
* animationEasing: "swing"
* animationOnComplete: $.noop
* followMouse:     true