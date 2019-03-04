"use strict";

(function ($) {
    $.fn.renderImagenes = function (options) {
        var settings = $.extend({}, $.fn.renderImagenes.defaults, options);            
        var obj = this;

        getDatos(obj, 1);

        function getDatos(obj, numpage) {
            var divLoading = obj.parent().find('.Objloading');
            var divNodata = obj.parent().find('.ObjSinDatos');
            var objtipo = obj.parents('.objetoTablero').attr('data-tipoobj');
        
            $.ajax({
                url: settings.urlDatosFn,
                dataType: 'html',
                type: 'POST',
                data: { objetoid: settings.parametros.objetoid, page: numpage, tableroid:settings.parametros.tableroid, tipoobj: objtipo, tipoDeVista: settings.size },
                beforeSend: function () {
                    divLoading.show();
                    divNodata.hide();
                },
                success: function (result) {
                    
                    if (result) {
                    obj.html(result);

                        var pages = result.pages;
                        if (numpage === 0) {
                            numpage = pages;
                        }
                        divLoading.hide();
                        divNodata.hide();
                        obj.show();
                    } else {
                        obj.empty();
                        obj.hide();
                        divNodata.show();
                    }
                },
                error: function (xhr, status, errorThrown) {
                    divLoading.hide();
                    obj.hide();
                    divNodata.show();
                }
            });
        };

        return this;

    };
    $.fn.renderImagenes.defaults = {
        urlDatosFn: null,
        parametros: {
            objetoid: null,
            tableroid: null
        },
        size: 'S'
    };
}(jQuery))