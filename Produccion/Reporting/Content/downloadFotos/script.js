

jQuery.expr[':'].icontains = function (a, i, m) {
            return jQuery(a).text().toUpperCase()
                .indexOf(m[3].toUpperCase()) >= 0;
        }

 $("#typeahead-fotos").on('keyup', function () {
            var str = $(this).val();

            $('.list-group-item').hide();
            $('.list-group-item:icontains("' + str + '")').show();
        });