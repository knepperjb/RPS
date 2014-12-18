function ajaxMove () {
  $("#moveBtn").click(function() {
    console.log("in move")
    $.post(
      "/move",
      {
        username: $("#usernameSignup").val(),
        matchid: $("#currentMatch").attr("data-match_id"),
        selection: $("input[name=userSelection]:checked").val(),
        apitoken: sessionStorage.getItem("apiToken")
      }
    ).success(function () {
      console.log("move success")
      // inform user of successful signup, hide and clear inputs.
    })
  })
};

ajaxMove();
