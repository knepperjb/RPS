var source = $('#getusers-template').html();
var template = Handlebars.compile(source);

function getUsers() {
	$.ajax({
		type: "GET",
		url: '/users'
	}).success(function (users) {
		for (var key in users) {
			console.log(users[key].username)
			var usersHtml = template({
				username: users[key].username
			});
			$('#users').append(usersHtml);	
		}
	})
}
getUsers();