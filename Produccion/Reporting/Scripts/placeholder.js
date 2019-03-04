(function( $ ){

   $.fn.placeHolder = function() {  
      var input = this;
      var text = input.attr('placeholder');  // make sure you have your placeholder attributes completed for each input field
      if (text) input.val(text).css({ color:'grey' });
      input.focus(function(){  
         if (input.val() === text) input.css({ color:'lightGrey' }).selectRange(0,0).one('keydown', function(){     
            input.val("").css({ color:'black' });  
         });
      });
      input.blur(function(){ 
         if (input.val() == "" || input.val() === text) input.val(text).css({ color:'grey' }); 
      }); 
      input.keyup(function(){ 
        if (input.val() == "") input.val(text).css({ color:'lightGrey' }).selectRange(0,0).one('keydown', function(){
            input.val("").css({ color:'black' });
        });               
      });
      input.mouseup(function(){
        if (input.val() === text) input.selectRange(0,0); 
      });   
   };

   $.fn.selectRange = function(start, end) {
      return this.each(function() {
        if (this.setSelectionRange) { this.setSelectionRange(start, end);
        } else if (this.createTextRange) {
            var range = this.createTextRange();
            range.collapse(true); 
            range.moveEnd('character', end); 
            range.moveStart('character', start); 
            range.select(); 
        }
      });
   };
   
    $('.ie8 [placeholder][type="password"]').each(function(){
        
        $(this).wrap('<div style="position: relative;"></div>');
        $('<span style=" position: absolute;top: 5px;left:14px;" class="ie8Lbls">'+$(this).attr('placeholder')+'</span>').insertAfter($(this));
        $(this).attr('placeholder','');
        if($(this).val() == "") {$(this).parent().find('.ie8Lbls').show();}
    }).on('focus',function(){
        //$(this).parent().find('.ie8Lbls').hide();
        $(this).parent().find('.ie8Lbls').css('color','#ccc');
    }).on('blur',function(){
        if($(this).val() == "") {$(this).parent().find('.ie8Lbls').show();}
        $(this).parent().find('.ie8Lbls').css('color','#999999');
    }).on('keydown',function(){
        
            $(this).parent().find('.ie8Lbls').hide();
        
    }).on('keyup',function(){
        
        if ($(this).val().length != 0){
            $(this).parent().find('.ie8Lbls').hide();
        } else {
            $(this).parent().find('.ie8Lbls').show();
        }
    });

    $(document).on('click','.ie8Lbls',function(){
        $(this).parent().find('input').focus();
    });
    
})( jQuery );


    
    
