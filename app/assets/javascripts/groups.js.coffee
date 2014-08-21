# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Select box for tags
jQuery -> 
	$('#group_tag_list, #tag_list').select2({tags:[]});
