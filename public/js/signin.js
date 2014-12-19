function ajaxSignin() {
 $("#signinBtn").click(function() {
   console.log("in click")
   $.post(
     "/signin",
     {
     username: $("#usernameSignin").val(),
     password: $("#passwordSignin").val()
     }
   ).success(function (token) {
     token = JSON.parse(token)
     console.log("signin success");
     sessionStorage.setItem("apiToken", token["apiToken"])
     yourMatches();
     // inform user of successful signup, hide and clear inputs.
     alert($("#usernameSignin").val() + " successfully signed in.");
     $(".signinContainer").hide();
     $(".spacerSignin").hide();
     $("#usernameSignin").val('');
     $("#passwordSignin").val('');
   })
 })
};

ajaxSignin();
