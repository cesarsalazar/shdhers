$(function(){
  $('#slug input').blur(function(){
    $.get('/'+$(this).val()+'/exists', function(data) {
      if($.parseJSON(data).slug == -1){
        console.log("Available");
      }
      else{
        console.log("Taken")
      }
    })
  })
})