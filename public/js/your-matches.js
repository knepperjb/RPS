$(document).ready(function() {
    setInterval("yourMatches()", 7000);

  var source = $('#getmatch-template').html();
  var template = handlebars.compile(source);
  var token = sessionStorage.getItem('apiToken')
  
  function yourMatches() {
  
  		$.ajax({
  			type: "GET",
  			url: '/matches/' + token
  		}).success(function (data) {
  		  console.log(data);
  			data.forEach(function (user))
  			// handlebars:
  			var yourMatchesHtml = template();
  			$('#currentmatches').append(yourMatchesHtml);
  		});
};

yourMatches();

