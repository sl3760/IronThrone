$(document).ready(
  function() {
	function parseTime(time) {
		time = time.replace(/(^\s*)|(\s*$)/g, "");
		var two_parts = time.split(" ");
		var part_one = two_parts[0];
		var part_two = two_parts[1];
		var t1 = Date.parse(part_one);
		var pos_half = part_two.split(":");
		var hour = parseInt(pos_half[0]);
		var minute = parseInt(pos_half[1]);
		var second = parseInt(pos_half[2]);
		var t2 = hour * 3600 + minute * 60 + second;
		return t1 + t2;
	}

	function computeTime(itemElem) {
		var time = $(itemElem).find(".time").text();
		return parseTime(time);
	}

	var $control_area = $("#episode-container").isotope({
		itemSelector: ".episode-item",
		resizesContainer: false,
		getSortData: {
			hottest: ".hottest parseInt",
			coldest: ".coldest parseInt",
			oldest: computeTime,
			newest: computeTime,
			"comment-number": ".comment-number parseInt"
		}
	});

	$("#sorts").on('click', 'button', function() {
		var sortValue = $(this).attr("data-sort-value");
		var sortOrder = $(this).attr("data-sort-order");
		var __sort__ = true;
		if (sortOrder == "Descending") {
			__sort__ = false;
		}
		$control_area.isotope({
			sortBy: sortValue,
			sortAscending: __sort__
		});
	});

	$(".button-group").on('click', 'button', function(e) {
		$btn = $(this);
		if (!$btn.hasClass("is-checked")) {
			$(".button-group").find("button").removeClass("is-checked");
			$btn.addClass("is-checked");
		}
	});
  }
);