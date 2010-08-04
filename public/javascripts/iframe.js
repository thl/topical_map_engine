jQuery(document).ready(function(){

	// On the onclick of each <a> tag, decide how to properly treat the click in the iframe.
	// The first two clauses are dependent on the setup of the app; the last two clauses area
	// likely to be used in any context. 
	jQuery('a').live('click', function() {
		var matches;
		
		// "/iframe/" link: don't change it
		if(matches = this.href.match(/\/iframe\//)){
		
		// Link with events already bound to it (e.g. AJAX): don't change it
		}else if( typeof (jQuery(this).data('events')) != 'undefined' ){
		
		// Otherwise: make the link open in the iframe's _parent
		}else{
			this.target = "_parent";
		}
		
		return true;
	});

});

// Set the automatic scrolling offset to 0
floatYloc = 0;