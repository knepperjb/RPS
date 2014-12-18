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
     console.log("signin success", token)
     sessionStorage.setItem("apiToken", token)
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
