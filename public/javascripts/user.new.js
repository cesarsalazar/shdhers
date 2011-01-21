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

});
