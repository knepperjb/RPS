$(document).ready(function() {
	setInterval("matchHistory", 7000);
});

var source = $('#getmatch-template').html();
var template = Handlebars.compile(source);

function matchHistory() {
	var x = 
	$.ajax({
		type: "GET",
		url: "/match/" + x
	}).success(function (data) {
		data.forEach(function (x) {
			console.log(x['id'])
			var historyHtml = template(x['id']);
		});
		//handlebars shit goes here.
		
		$('#mymatches').append(historyHtml);
	});
};

matchHistory();
