var source = $('#getmatch-template').html();
var template = handlebars.compile(source);


function yourMatches() {
	$('#your-matches').click(function() {
		$.ajax({
			type: "GET",
			url: '/your-matches'
		}).success(function (data) {
			console.log(data);
			// handlebars:
			var yourMatchesHtml = template(data);
			$('#your-matches').append(yourMatchesHtml);
		});
	});

};

yourMatches();