/*
thl plugin scripts -- jev3a@virginia.edu

depends on prototype.js, but not heavily

*/

var app = navigator.userAgent.match(/Firefox|Safari|MSIE|Opera?/i) ;
app = app[0] ;

// object that handles bookmarking -- works only for IE and Firefox
var bookmarker = {
	label: "bookmark" ,		// text for the bookmark link
	title: document.title ,	// title for the bookmark
	omit: ["Safari"] ,		// browsers that don't support js bookmarking (may need to refine to allow for versions)
	
	init: function() {
		if ( this.markable( app ) ) {	// check to see if the useragent is eligible for bookmarking
			target = $('content') ;		// the element before which the bookmark link will be inserted
			container_dims = target.getDimensions() ;	// for placing the link on the right
			bm_html = "<div id=\"bookmark\" name=\"bookmark\" style=\"position: absolute; z-index: 1; top: 0px; left:" + 
			(container_dims.width - 80) + 
			"px\"><a href=\"javascript:void(bookmarker.set());\"><img src=\"/images/bookmark_add.png\" alt=\"bookmark\" width=\"14\" height=\"14\" border=\"0\" align=\"left\" />&nbsp;" + this.label + "</a></div>" ;
			target.insert( {before: bm_html} ) ; 
		}
	},
	
	// method to check if current user agent is eligible for bookmarking ( can't be done programatically )
	markable: function( app ) {
		omit_apps = this.omit.toString() ;
		if ( omit_apps.indexOf( app ) == -1 ) {
			return true ;
		}
		return false ;
	},
	
	// method called when user clicks the bookmark link
	set: function() {
		if ( app == "MSIE" ) {
			window.external.AddFavorite( bookmark_url , this.title ); 
		} else if ( app = "Firefox" ) {
			// add in note about sidebar bookmarks?
			window.sidebar.addPanel( this.title , bookmark_url , ""); 	// ff 3 has new way to do this, but haven't found js api yet	
		} else {														// for all other browsers, send proper link to parent hash and notify to bookmark regularly (class_external.js looks for &bookmark=true)
			loc = "iframe=" + window.location.href ;
			loc += ( window.location.href.indexOf("?") == -1 ) ? "?" : "" ;
			loc += "&bookmark=true&title=" + this.title  ;
			parent.location.hash = loc ;
		}
	}
	
}

var frame_service = {

	hide_stuff: function() {
		// this is necessary for ie6
		document.getElementsByTagName("body").item(0).setStyle({ 'padding': '0px' , 'backgroundImage': 'none' , 'backgroundColor': 'white' , 'textAlign': 'left' }) ;
		
		$('unframe').hide() ; //TODO: change to look for .unframe so that an element can be given this class and be hidden automatically when in frame
	},

	init: function() {
		//bookmarker.init() ;
		this.hide_stuff() ;
	}

}