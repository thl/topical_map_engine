
var floatYloc = -190; // take off the amount of pixels above the feature pane.

var browseHeight;

jQuery(document).scroll(function () { 
	var sctop = z_scrollTop();  // determine scroll amount
	newoffset = floatYloc + sctop + 40;
	if(newoffset < 0) {newoffset = 20;}
	newoffset += "px";
	//jQuery("#container-left-5050").animate({paddingTop:newoffset},{duration:400,queue:false});
	//jQuery("#FeatureTree").animate({marginTop:"-" + newoffset},{duration:401,queue:false});
});

jQuery(document).ready(function () {
	//setTimeout('scrollToSelected();',1000);
	//browseHeight = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight) - 40;
	//jQuery("#container-left-5050 .shell-2").css("overflow","auto").css("border","none").css("padding","3px");;
	//jQuery("#container-left-5050 .shell-2").height(browseHeight);
});

// Scroll to selected element in the FeatureTree
function scrollToSelected() {
	if(typeof(jQuery("#container-right-5050 .selected-node")) == "object" && jQuery("#container-right-5050 .selected-node").length > 0) {
		var offset = jQuery("#container-right-5050 .selected-node").offset().top - 10;
		//jQuery('html,body').animate({scrollTop: offset}, 200);
	}
}

// Calculates the pixel amount scrolled in a browser-generic way
function z_scrollTop() {
	return z_filterResults (
		window.pageYOffset ? window.pageYOffset : 0,
		document.documentElement ? document.documentElement.scrollTop : 0,
		document.body ? document.body.scrollTop : 0
	);
}

// Filters results from z_scrollTop
function z_filterResults(n_win, n_docel, n_body) {
	var n_result = n_win ? n_win : 0;
	if (n_docel && (!n_result || (n_result > n_docel)))
		n_result = n_docel;
	return n_body && (!n_result || (n_result > n_body)) ? n_body : n_result;
}

