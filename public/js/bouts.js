var source = $('#bouthistory-template').html();
var template = Handlebars.compile(source);



$(document).on('click', '.match', function (e) {
	console.log("hi there")
	var matchId = e.currentTarget.id;
	console.log(e.currentTarget);
	$.ajax({
		type: "GET",
		url: "/match/" + matchId
	}).success(function (bouts) {
		bouts = JSON.parse(bouts)
		console.log(bouts);
		bouts.forEach(function (bout) {
			console.log(bout)
			var boutsHtml = template(bout);	
		});
		$('#boutHistory').append(boutsHtml);

	});
});