$('.filtroitems').on('click', '.trimestres a', function () {
    var tr = $(this).data('trimestre');
    $(this).parents('.fechaitemctrol').find('.hddntrimestre').val(tr);
    $(this).parent().find('a').removeClass('active');
    $(this).addClass('active');
    return false;
})

$('.filtroitems').on('click', '.filtroitemfechasbotones a', function () {
    var div = $(this).data('target');
    var fecha = $(this).data('fecha');
    $(this).parent().find('a').removeClass('active');
    $(this).addClass('active');
    $(this).parents('.filtrofecha').find('.filtrotipofecha').hide();
    $(this).parents('.filtrofecha').find('.' + div).show();
    $(this).parents('.filtrofecha').find('.filtroitemtitulo').find('.badge').text(fecha);
    $(this).parents('.filtrofecha').find('.hddntipofecha').val(fecha);
    return false;
})

$('.filtroitems').on('click', '.filtroitem', function (event) {
    if (this === event.target) {
        $(this).toggleClass('expanded');
        $(this).find('.filtroitemfechasbotones').toggle('medium');
        $(this).find('.filtroitemfechascontroles').toggle('medium');
        $(this).find('.filtrocheckcontroles').toggle('medium');
        $(this).find('.filtrochecks').toggle('medium');
    }
});

$('.filtroitems').on('click', '.checkboxitemcheck', function () {


    var checked = $(this).is(':checked');
    var idNameItem = this.id;
    var idItem = idNameItem.substring(idNameItem.indexOf('Items_') + 6, idNameItem.lastIndexOf('_IdItem'));
    var idFiltro = idNameItem.substring(idNameItem.indexOf('FiltrosChecks_')+14 , idNameItem.indexOf('_Items'))
    var fltId = $("input[name='Filtros.FiltrosChecks["+idFiltro.toString()+"].Id']").val();



    if ($(this).is(':checked')) {       
        $(this).attr('name', $(this).attr('hiddenname'));
        $.each($(this).parent().find('input[type="hidden"]'), function (i, el) {
            $(this).attr('name', $(this).attr('hiddenname'));
        });
    } else {
        $(this).attr('name', '');
        $.each($(this).parent().find('input[type="hidden"]'), function (i, el) {
            $(this).attr('name', '');
        });
    }
});

$('.filtroitems').on('click', '.filtroitemtitulo', function (event) {
    if (this === event.target) {
        $(this).parent().toggleClass('expanded');
        $(this).parent().find('.filtroitemfechasbotones').toggle('medium');
        $(this).parent().find('.filtroitemfechascontroles').toggle('medium');
        $(this).parent().find('.filtrocheckcontroles').toggle('medium');
        $(this).parent().find('.filtrochecks').toggle('medium');
    }
});

$('.filtroitems').on('click', '.filtroitemtitulo span', function (event) {
    if (this === event.target) {
        $(this).parent().parent().toggleClass('expanded');
        $(this).parent().parent().find('.filtroitemfechasbotones').toggle('medium');
        $(this).parent().parent().find('.filtroitemfechascontroles').toggle('medium');
        $(this).parent().parent().find('.filtrocheckcontroles').toggle('medium');
        $(this).parent().parent().find('.filtrochecks').toggle('medium');
    }
});

$('.filtroitems').on('keyup','.typeahead', function () {
    var str = $(this).val();
    $(this).parents('.filtrocheck').find('.filtrochecks .listfiltrochecks li').hide();
    $(this).parents('.filtrocheck').find('.filtrochecks .listfiltrochecks li:icontains("' + str + '")').show();
});

$('.filtroitems').on('click','.ninguno', function () {
    $(this).prev().val('');
    $(this).parents('.filtrocheck').find('.filtrochecks .listfiltrochecks li').show();
    $(this).parents('.filtrocheck').find('.filtrochecks .listfiltrochecks li input:checkbox').removeAttr('checked');
    $(this).parents('.filtrocheck').find('.filtroitemtitulo .badge').text('0');

    return false;
})

$('.filtroitems').on('click','.itmcheckbox', function () {
        var c = $(this).parents('.listfiltrochecks').find('input:checkbox:checked').length;
        $(this).parents('.filtrocheck').find('.filtroitemtitulo .badge').text(c);
})

$('.filtroitems').on('click', '.filtrosLock', function () {
    var tabid = $('#tabs').find('.tabs-ReportingTablero .active').data('tabid');
    var isLocked = false;

    if ($('.filtrosLock').hasClass('fa-unlock'))
    {
        isLocked = true;
    }
    else
    {
        isLocked = false;
    }
    
    $.ajax({
        type: "POST",
        url: urlSaveFiltroLock,
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            filtrosLock: isLocked,
            tableroId: tabid
        }),
        beforeSend: function () {
            $('.filtrosLock').fadeTo(10, 0);
            $('.lockLoading').show();
        },
        success: function (data) {
            $('.filtroitems').html(data);
            enableOrDisableInputs();
        },
        complete: function () {
            $('.filtrosLock').fadeTo(0,10);
            $('.lockLoading').hide();
        }
    });
})

function enableOrDisableInputs() {
    if ($('.filtrosLock').hasClass('fa-lock')) {
        disableInputs();
    }
    else {
        enableInputs();
    }
}

    function enableInputs() {
        $('input').each(function () {
            $(this).prop('disabled', false);
        });
    }

    function disableInputs() {
        var itemsValue = [];

        $('.itemBloqueadoId').each(function () {
            var value = $(this).val();
            itemsValue.push(value);
        });

        if (itemsValue.length > 0) {
            $.each(itemsValue, function (index) {
                $('.filtros :input[value="' + itemsValue[index] + '"]').next().next().prop('disabled', true);
            });
        }
    }

    $(document).on('click', '.fa-exclamation-circle', {}, function (e) {
        $('#signoExclamacion').fadeToggle('fast', 'linear');
        $('#signoExclamacion').focus();
        e.stopPropagation();
    })

//NUEVO FILTRO
//function SeleccionarFiltroItem(elemento, item, tabid) {
//    if ($('#itemfiltro_' + item.value + '_' + tabid + '').length == 0)        
//    {

//        elemento.append('<button type="button" class="btn btn-labeled btn" id= "itemfiltro_' + item.value + '_' + tabid + '"><div><span class="btn-label"> </span > ' + item.label + ' <span aria-hidden="true"><i class="glyphicon glyphicon-remove"></i></span></div></button>')

        
//        if ($('#F_FC_' + tabid + '_i_' + item.value + '_v').length == 0)
//        {
//            $('<input>').attr({
//                type: 'hidden',
//                id: 'F_FC_' + tabid + '_i_' + item.value + '_v',
//                name: 'F.FC[' + tabid + '].item[' + item.value + '].value',
//                value: item.label
//            }).appendTo('form');
//        }
//    }
//}