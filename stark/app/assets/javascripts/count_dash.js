$(document).ready(function() {
	$('#word-num-calc').val(140)
	$('#word-controlled-area').bind("keyup", function() {
		return wordNumberController(140, this, "#word-num-calc")
	})
});