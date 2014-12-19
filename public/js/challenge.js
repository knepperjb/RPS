function createChallenge() {
	$('#users').change(function() {
		$.post(
			"/match",
			{
				// challenger: $("username").val(),
				contender:  $('#users').val(),
				apiToken: sessionStorage.getItem("apiToken")
			}
		).success(function (bout) {
			console.log("bout created", bout);
		});

	});
};

createChallenge();