function createChallenge() {
	$('#challenge').change(function() {
		$.post(
			"/challenge",
			{
				challenger: $("username").val(),
				contender:  $('#challenge').val(),
				apiToken: sessionStorage.getItem("apiToken")
			}
		).success(function (bout) {
			console.log("bout created", bout)
		})

	})
});

createChallenge();