$(document).ready(function() {
	setInterval("matchHistory", 7000);
});

function matchHistory() {
	$.ajax({
		type: "GET",
		url: "/match-history"
	}).success(function (data) {
		console.log(data);
		//handlebars shit goes here.
		var historyHtml = template(data);
		$('#history').append(historyHtml);
	});
};

matchHistory();
