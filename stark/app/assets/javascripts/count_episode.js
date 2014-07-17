$(document).ready(function() {
	$('#word-num-calc').val(500)
	$('#word-controlled-area').bind("keyup", function() {
		return wordNumberController(500, this, "#word-num-calc")
	})
});