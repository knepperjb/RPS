  var source = $('#getmatch-template').html();
  var template = Handlebars.compile(source);
  var token = sessionStorage.getItem("apiToken")
  console.log(token)

function yourMatches() {
  		console.log('finding matches!!!!')
  		$.ajax({
  			type: "GET",
  			url: '/matches/' + token
  		}).success(function (data) {
  		  console.log(data);
  			data.forEach(function (user){
  			// handlebars:
  			var yourMatchesHtml = template(user);
  			$('#currentmatches').append(yourMatchesHtml);
  		});
	});
  };

$(document).ready(function() {

yourMatches();
setInterval(yourMatches(), 7000);

})




