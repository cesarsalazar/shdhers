var tags = new Array();

$(function(){
  
  
  $.get('/tags/all', function(data) {
    
    $.each(data, function(index, value) { 
      tags.push(value.name);
    });
    
    $("#interests_field").tag({
     availableTags: tags,
     field_name: 'user[interests]'
    });
  	
  	$("#expertise_field").tag({
  		availableTags: tags,
  		field_name: 'user[expertise]'
  	});
  
  });

});

(function($) {

	$.fn.tag = function(options) {
		
		const BACKSPACE	= 8;
		const ENTER			= 13;
		const SPACE			= 32;
		const COMMA			= 44;
		
		var el = this;

		el.addClass("tagit").html("<li class='tagit-new'><input class='tagit-input' type='text' /></li>");

		var tag_input = el.find(".tagit-input");		

		$(this).click(function(e){
			if (e.target.tagName == 'A') {
				// Removes tag
				$(e.target).parent().remove();
			}
			else {
				// Sets the focus to the input field, if the user clicks anywhere inside the UL.
				tag_input.focus();
			}
		});
		
		tag_input.keypress(function(e){
			if (e.which == BACKSPACE && tag_input.val() == "") {
					$(el).children(".tagit-choice:last").remove();
			}
			else if (e.which == COMMA || e.which == SPACE || e.which == ENTER) {
				e.preventDefault();
				var typed = tag_input.val().replace(/,+$/,"").replace(/^\s+|\s+$/g,"");
				if (typed && is_new(typed)) {
					create_choice (typed);
					tag_input.val("");
				}
				$(this).data("autocomplete").close();
			}
		});

		tag_input.autocomplete({
			
			source: options.availableTags, 
			
			select: function(event,ui){
				if ( is_new(ui.item.value) ) {
					create_choice(ui.item.value);
				}
				tag_input.val("");
				return false;
			},
			open: function(event, ui) {
        var current = this.value;
        var suggested = $(this).data("autocomplete").menu.element.find("li:first-child a").text();
        this.value = suggested;
        this.setSelectionRange(current.length, suggested.length);      
      }
		});

		var is_new = function(value){
			var is_new = true;
			tag_input.parents("ul").children(".tagit-choice").each(function(i){
				if (value == $(this).children("input").val()) {
					is_new = false;
				}
			})
			return is_new;
		}
		
		var create_choice = function(value){
			var el  = "<li class='tagit-choice'>";
			el += value;
			el += "<a class='close'>x</a>";
			el += "<input type='hidden' style='display:none;' value='"+value+"' name='"+options.field_name+"[]'>";
			el += "</li>";
			var li_search_tags = tag_input.parent();
			$(el).insertBefore(li_search_tags);
			tag_input.val("");
		}
	};

})(jQuery);
