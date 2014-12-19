function ajaxSignup () {
  $("#signupBtn").click(function() {
    console.log("in signup")
    $.post(
      "/signup",
      {
        username: $("#usernameSignup").val(), 
        password: $("#passwordSignup").val()
      }
    ).success(function () {
      console.log("signup success")
      // inform user of successful signup, hide and clear inputs.
      alert($("#usernameSignup").val() + " successfully signed up.");
      $(".signupContainer").hide();
      $(".spacerSignup").hide();
      $("#usernameSignup").val('');
      $("#passwordSignup").val('');
    })
  })
};

ajaxSignup();