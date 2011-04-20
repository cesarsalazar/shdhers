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
    console.log($('#location select').data('value'));
    $.each(data, function(index, value){
      var option = $('<option value="'+value.slug+'">'+value.name+'</option>');
      $('#location select').append(option);
      if(value.slug == $('#location select').data('value')) {
          option.attr('selected', true);
      }
    });
    $('#location select').selectmenu({style:'dropdown'});
  })

});
