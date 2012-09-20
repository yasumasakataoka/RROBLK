$(function() {
  var randomElement = $("#randomquote");
  if (randomElement) {
    $.get("/quotes/random.blog", null, function(data, textStatus) {
        $("#randomquote").html(data);
    }, "html");
  }
});