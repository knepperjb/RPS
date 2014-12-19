var source = $('#bouthistory-template').html();
var template = Handlebars.compile(source);



$('.match').on('click', function (e) {
	var matchId = e.currentTarget.id;
	console.log(e.currentTarget);
	alert(matchId);
	// $.ajax({
	// 	type: "GET",
	// 	url: "/matches/" + matchId
	// }).success(function (bouts) {
	// 	console.log(bouts);
	// 	bouts.forEach(function (bout) {
	// 		var boutsHtml = template(bout);	
	// 	});
	// 	$('#boutHistory').append(boutsHtml);

	// });
});