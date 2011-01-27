var tags = new Array();

$(function(){
  
  
  $.get('/tags/all', function(data) {
    
    $.each(data, function(index, value) { 
      tags.push(value.name);
    });
    
    $("#interests_field").taggable({
     availableTags: tags,
     field_name: 'user[interests]'
    });
  	
  	$("#expertise_field").taggable({
  		availableTags: tags,
  		field_name: 'user[expertise]'
  	});
  
  });
  
  $.get('/locations/all', function(data){  
    $.each(data, function(index, value){
      $('#location select').append('<option value="'+value.slug+'">'+value.name+'</option')
    })
    $('#location select').selectmenu({style:'dropdown'});
  })

});
