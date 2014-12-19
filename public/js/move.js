var pizza_audio = new Audio('../pizza.m4a');
var cutter_audio = new Audio('../cutter.m4a');
var pan_audio = new Audio('../pan.m4a');

function ajaxMove () {
  $(document).on("click", "#moveBtn", function(e) {
    e.preventDefault();
    var choice = $("input[name=radio]:checked").val();
    console.log($("input[name='radio']:checked"))
    console.log("hi")
    console.log(choice)
    if (choice === "pizza") {
      pizza_audio.play();
    }
    else if (choice === "cutter") {
      cutter_audio.play();
    }
    else {
      pan_audio.play();
    }
    console.log("in move")
    $.post(
      "/move",
      {
        username: $("#usernameSignup").val(),
        matchid: $("#currentMatch").attr("data-match_id"),
        selection: choice,
        apitoken: sessionStorage.getItem("apiToken")
      }
    ).success(function () {
      console.log("move success")

      // inform user of successful signup, hide and clear inputs.
    })
  })
};

ajaxMove();
