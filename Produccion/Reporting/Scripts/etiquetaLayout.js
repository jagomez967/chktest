"use strict";

(function ($) {
    $.fn.etiquetaLayout = function (options) {
        var settings = $.extend({}, $.fn.etiquetaLayout.defaults, options);


        if (!settings.parametros.tableroid) {

            return;
        }

        var obj = this;

        getDatos(obj, 1);

        function getDatos(obj, numpage) {
            var objetoid = obj.attr('data-id');
            var divLoading = obj.find('.Objloading');
            var divNodata = obj.find('.ObjSinDatos');
            var divGrafico = obj.find('.ObjGrafico');

            $.ajax({
                url: settings.urlDatosFn,
                dataType: 'json',
                type: 'POST',
                data: { objetoid: objetoid, page: numpage, tableroid: settings.parametros.tableroid },
                beforeSend: function () {
                    divLoading.show();
                    divNodata.hide();
                },
                success: function (result) {
                    divGrafico.empty();
                    divLoading.hide();

                    if (result.Valores && result.Valores.length > 0) {                       
                        divGrafico.show();

                        var etiquetaContainer = $('<div>', { class: 'etiquetaContainer' });
                        etiquetaContainer.appendTo(divGrafico);
                        var totalFrentes = 0;

                        //  totalFrentes
                        $.each(result.Valores, function (i, value) {
                            totalFrentes += value.Cantidad;
                        });

                        $.each(result.Valores, function (i, value) {
                            var porcentaje = 0;

                            if (i == 0) {
                                var img = $('<img>', { src: 'images/Layouts/' + value.IdCliente + '.jpg', class: 'etiquetaContainerImg' });
                                img.attr('id', 'etiquetaImg');
                                img.appendTo(etiquetaContainer);
                            }

                            var divInfo = $('<div>',{class:'percentDiv'});
                            divInfo.css("left", value.PosX + "px");
                            divInfo.css("top", value.PosY + "px");

                            //var spanExhibidor = $('<span>', { class: 'label label-danger' });
                            //spanExhibidor.text(value.NombreExhibidor);
                            //spanExhibidor.appendTo(divInfo);

                            var spanValores = $('<span>', { class: 'label' });

                            if (totalFrentes > 0) {
                                porcentaje = (value.Cantidad / totalFrentes) * 100;
                            } else {
                                porcentaje = 0;
                            }

                            var porcentajeRounded = Math.round(porcentaje * 10) / 10;
                            spanValores.text(porcentajeRounded + '% (' + value.Cantidad + ')');
                            spanValores.css("display", "block");

                            spanValores.appendTo(divInfo);

                            var spanTexto = $('<span>', { class: 'label' });
                            spanTexto.text(value.NombreExhibidor);
                            spanTexto.css("display", "block");
                            spanTexto.appendTo(divInfo);
                            //var etiquetaCircle = $('<div>', { class: 'etiquetaCircle' });
                            //etiquetaCircle.attr('id', value.Label);
                            //etiquetaCircle.attr('Exhibidor-id', value.NombreExhibidor + '-' + value.IdExhibidor);
                            //etiquetaCircle.css("left", value.PosxHover + "%");
                            //etiquetaCircle.css("top", value.PosyHover + "%");

                            //var percentDiv = $('<div>', { class: 'percentDiv' })
                            //percentDiv.attr('id', value.Label);
                            //percentDiv.attr('Exhibidor-id', value.NombreExhibidor + '-' + value.IdExhibidor);
                            //percentDiv.css("left", value.PosxPorcentaje + "%");
                            //percentDiv.css("top", value.PosyPorcentaje + "%");

                            //var etiquetaDiv = $('<div>', { class: 'etiqueta' });
                            //etiquetaDiv.attr('id', 'popLabel' + value.Label);
                            //etiquetaDiv.attr('Exhibidor-id', value.NombreExhibidor + '-' + value.IdExhibidor);


                            //var etiquetaNombre = $('<div>');
                            //var etiquetaQty = $('<div>');
                            //var etiquetaPercent = $('<div>', { class: 'etiquetaPercent' });

                            //etiquetaNombre.text(value.NombreExhibidor);
                            //etiquetaQty.text("Qty: " + value.Cantidad);

                            //if (totalFrentes > 0) {
                            //    porcentaje = (value.Cantidad / totalFrentes) * 100;
                            //} else {
                            //    porcentaje = 0;
                            //}
                            
                            //var porcentajeRounded = Math.round(porcentaje * 10) / 10;
                            //etiquetaPercent.text(value.NombreExhibidor + ': ' + porcentajeRounded + '% (' + value.Cantidad + ')');

                            //etiquetaNombre.appendTo(etiquetaDiv);
                            //etiquetaQty.appendTo(etiquetaDiv);
                            //etiquetaPercent.appendTo(percentDiv);

                            ////place bubble div etiquetaDiv
                            //etiquetaDiv.css("left", value.PosX + "%");
                            //etiquetaDiv.css("top", value.PosY + "%");

                            //etiquetaCircle.appendTo(etiquetaContainer);
                            //etiquetaDiv.appendTo(etiquetaContainer);
                            //percentDiv.appendTo(etiquetaContainer);

                            divInfo.appendTo(etiquetaContainer);
                        });
                    } else {
                        divGrafico.hide();
                        divNodata.show();
                    }
                },
                error: function (xhr, status, errorThrown) {
                    divLoading.hide();
                    divGrafico.hide();
                    divNodata.show();

                }
            });
        };

        return this;
    };
    $.fn.etiquetaLayout.defaults = {
        urlDatosFn: null,
        parametros: {
            tableroid:null
        },
        viewType: 'small',
        allowAutoRowSpan: false
    };
}(jQuery))
