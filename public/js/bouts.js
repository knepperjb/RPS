var source = $('#bouthistory-template').html();
var template = Handlebars.compile(source);



$('.match').on('click', function () {
	var matchId = $(this).attr("id");
	$.ajax({
		type: "GET",
		url: "/matches/" + matchId
	}).success(function (bouts) {
		console.log(bouts);
		bouts.forEach(function (bout) {
			var boutsHtml = template(bout);	
		});
		$('#boutHistory').append(boutsHtml);

	});
});