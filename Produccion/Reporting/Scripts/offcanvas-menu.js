/**************************************************************/
/* Prepares the cv to be dynamically expandable/collapsible   */
/**************************************************************/
function prepareList() {
    $('#expList').find('li:has(ul)')
    .click(function (event) {
        if (this == event.target) {
            $(this).toggleClass('expanded');
            $(this).children('ul').toggle('medium');
           
        }
    });
    $('#expList').find('span.titulo')
    .click(function (event) {
        if (this == event.target) {
            $(this).closest('li').toggleClass('expanded');
            $(this).closest('li').children('ul').toggle('medium'); 
        }
    });
};


/**************************************************************/
/* Functions to execute on loading the document               */
/**************************************************************/
$(document).ready( function() {
    prepareList()
});