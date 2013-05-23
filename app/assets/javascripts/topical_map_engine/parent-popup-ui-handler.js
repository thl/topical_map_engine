$(function() {
	$( '#parent_popup_dialog' ).dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		position: [100,100],
		buttons: {
			'Select': function() { 
				$('#selected_category_id').val($('#current_category_id').val());
			  	$('#category_name').html($('#current_category_title').val());
			  	$('#category_selector').attr('href', $('#current_category_selector').val());
			  	$('#category_parent_id').val($('#current_category_id').val());
				$( this ).dialog( 'close' );
			},
			'Cancel': function() { $( this ).dialog( 'close' ); }
		},
		close: function() { }
	});
});