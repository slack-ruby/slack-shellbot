$(document).ready(function() {
  // Slack OAuth
  var code = $.url('?code')
  if (code) {
    SlackShell.message('Working, please wait ...');
    $('#register').hide();
    $.ajax({
      type: "POST",
      url: "/api/teams",
      data: {
        code: code
      },
      success: function(data) {
        SlackShell.message('Team successfully registered!<br><br>Invite <b>@sh</b> to a channel.');
      },
      error: SlackShell.error
    });
  }
});
