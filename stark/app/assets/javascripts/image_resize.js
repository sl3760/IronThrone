$(document).ready(
	function() {
		$(".estimate").each(function() {
			var $img = $(this);
			$img.css({
				width:$img.width() / 2,
				height:$img.height() / 2
			});
		});

		$(".estimate").hover(function() {
			var $img = $(this);
			$img.css({
				width:$img.width()*1.2,
				height:$img.height()*1.2,
			});
		}, function() {
			var $img = $(this);
			$img.css({
				width:$img.width() / 1.2,
				height:$img.height() / 1.2,
			});
		});
	}
)