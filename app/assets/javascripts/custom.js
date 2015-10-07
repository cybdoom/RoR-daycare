$(document).ready(function(){
    $(".add_link a").click(function(){

        $(".append_div").append(" <div class='input_field_col'> <input name='' type='text' placeholder='Daycare department name'> </div>");
    });
	
	$(".menu_icons").click(function(){
		$("nav").toggleClass("dis_block")	
	})

});