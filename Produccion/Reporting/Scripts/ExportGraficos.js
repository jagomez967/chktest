function exportData(divObjetoTablero, urldatos, urldownload, url) {
    var objtipo = divObjetoTablero.attr('data-tipoobj');

    switch (objtipo) {
        case "1":
            exportDataChartTipo1(divObjetoTablero);
            break;
        case "2":
            exportDataChartTipo2(divObjetoTablero);
            break;
        case "3":
            exportDataChartTipo1(divObjetoTablero);
            break;
        case "4":
            exportDataChartTipo4(divObjetoTablero);
            break;
        case "5":
            exportDataChartTipo1(divObjetoTablero);
            break;
        case "6":
            exportDataChartTipo6(divObjetoTablero);
            break;
        case "7":
            exportDataChartTipo6(divObjetoTablero);
            break;
        case "8":
            exportDataChartTipo1(divObjetoTablero);
            break;
        case "9":
            exportDataChartTipo9(divObjetoTablero, urldatos, urldownload);
            break;
        case "10":
            exportDataChartTipo1(divObjetoTablero);
            break;
        case "11":
            exportDataChartTipo2(divObjetoTablero);
            break;
        case "12":
            exportDataChartTipo12(divObjetoTablero);
            break;
        case "16":
            exportDataChartTipo16(divObjetoTablero);
            break;
        case "17":
            exportDataChartTipo17(divObjetoTablero, urldatos, urldownload, url);
            break;
        case "20":
            exportDataChartTipo9(divObjetoTablero, urldatos, urldownload);
            break;
        case "21":
            exportDataChartTipo21(divObjetoTablero);
            break;
        case "22":
            exportDataChartTipo22(divObjetoTablero);
            break;
        case "25":
            exportDataChartTipo9(divObjetoTablero, urldatos, urldownload);
            break;
        case "30":
            exportDataChartTipo9(divObjetoTablero, urldatos, urldownload);
            break;
        default:
            return false;
    };
};

function exportDataChartTipo1(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
    var titulo = divObjetoTablero.find('.titulo').text();
    var data = [];

    var cabecera = [];
    cabecera.push("");
    $.each(chart.series, function (key, serie) {
        cabecera.push(serie.name);
    });

    data.push(cabecera);

    $.each(chart.xAxis[0].categories, function (i, cat) {
        var fila = [];
        fila.push(cat);

        $.each(chart.series, function (key, serie) {
            if (serie.data[i]) {
                fila.push(serie.data[i].y.toFixed(2).replace('.', ','));
            }

        });

        data.push(fila);
    });

    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, false);
}

function exportDataChartTipo2(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
    var titulo = divObjetoTablero.find('.titulo').text();

    var data = [];
    $.each(chart.series, function (key, val) {
        $.each(val.data, function (i, n) {
            var itm = {};
            itm.name = n.name;
            itm.percentage = n.percentage.toFixed(1).replace('.', ',');
            data.push(itm);
        });
    });
    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, true);
}

function exportDataChartTipo6(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
    var titulo = divObjetoTablero.find('.titulo').text();
    var data = [];

    var cabecera = [];
    cabecera.push("");
    var i;
    var j;
    if (titulo == 'Distribucion Fisica Numérica Productos (Barras)') {

        for (i = 0; i < chart.series.length; i++) {
            cabecera.push(chart.series[i].name);
        }

        data.push(cabecera);

        for (i = 0; i < chart.xAxis[0].names.length; i++) {
            var fila = [];
            fila.push(chart.xAxis[0].names[i]);

            for (j = 0; j < chart.series.length; j++) {
                fila.push(chart.series[j].data[0].y.toFixed(2).replace('.', ','));
            }

            data.push(fila);
        }
    } else {
        $.each(chart.series, function (key, serie) {
            cabecera.push(serie.name);
        });

        data.push(cabecera);

        $.each(chart.xAxis[0].names, function (i, name) {
            var fila = [];
            fila.push(name);

            $.each(chart.series, function (key, serie) {
                fila.push(serie.data[i].y.toFixed(2).replace('.', ','));
            });

            data.push(fila);
        });
    }
    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, false);
}


function exportDataChartTipo9(divObjetoTablero, urldatos, urldownload) {

    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var titulo = divObjetoTablero.find('.titulo').text();
    var filename = titulo.replace(/ /g, '') +  '.xlsx';
    var objId = divObjetoTablero.attr('data-id');

    $.ajax({
        url: urldatos,
        method: 'POST',
        data: {
            ObjetoId: objId
        },
        success: function (result) {
            if (result.length <= 0) {
                return;
            }

            var dl = document.createElement("a");
            dl.href = urldownload + "?token=" + result;
            dl.download = filename;
            dl.style = "visibility:hidden;";
            dl.onclick = 'return false;';
            document.body.appendChild(dl);
            dl.click();
            document.body.removeChild(dl);
        }
    });
}

function exportDataChartTipo12(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var metrica = divObjetoTablero.find('.ObjGraficoMetrica').children().children('a').children('div');
    var titulo = divObjetoTablero.find('titulo').text();
    var data = [];

    if (objSinDatos == 1) return false;

    metrica.each(function () {
        var item = {};
        item.name = $(this).children('div').text();
        item.percentBig = $(this).data('text');
        item.percentSmall = $(this).data('info');
        data.push(item);
    });

    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, true);
}

function exportDataChartTipo16(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var etiquetaContainer = divObjetoTablero.find('.ObjGrafico').children();
    var titulo = divObjetoTablero.find('titulo').text();
    var data = [];
    var percentArray = [];

    if (objSinDatos == 1) return false;

    etiquetaContainer.children('.percentDiv').each(function (index, value) {
        var percentItems = {};
        percentItems.index = index;
        percentItems.percent = $(value).text();
        percentArray.push(percentItems);
    });

    etiquetaContainer.children('.etiqueta').each(function (index, value) {
        var item = {};
        var nameAndQty = $(value).text();
        var nameAndQtyFix = nameAndQty.replace('Q', ' Q');
        item.nameAndQty = nameAndQtyFix;
        item.percent = percentArray[index].percent;
        data.push(item);
    });

    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, true);
}

function exportDataChartTipo17(divObjetoTablero, urldatos, urldownload, url) {

    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var data = [];

    var tableroId = $('#TableroId').val();
    var objid = divObjetoTablero.attr('data-id');

    var titulo;

    $.ajax({
        url: url,
        dataType: 'json',
        type: 'POST',
        data: { objetoid: objid, tableroid: tableroId, page: -1 },
        success: function (result) {

            titulo = 'Timeline';

            var eventos = result.TimelineItems;
            var item = {};
            var res = [];

            for (var i = 0; i < eventos.length; i++) {

                item = {};
                item.Nombre_Usuario = eventos[i].NombreUsuario;
                item.Apellido_Usuario = eventos[i].ApellidoUsuario;
                item.Fecha_Creacion = eventos[i].FechaCreacion;
                item.Tipo_Accion = eventos[i].AccionTipo;
                res = eventos[i].Descripcion.split(";");
                item.Descripcion = res[0];
                if (res.length == 2) {
                    item.Punto_de_venta = res[1];
                }

                data.push(item);
            }

            JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, true);
        }
    });


}



function exportImage(divObjetoTablero) {
   
    var objId = divObjetoTablero.attr('data-id');
    var tipoObj = divObjetoTablero.attr('data-tipoobj');
    var titulo = divObjetoTablero.find('.titulo').text();

    if (tipoObj != 9 && tipoObj != 22) {
        multiplicador = 1.2;
        if (tipoObj == 2 || tipoObj == 11) {
            multiplicador = 0.65;
        }
        var pwidth = $(window).width();
        var pheight = $(window).height();
        var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
        var options = chart.options;
        var pwidth = $(window).width();
        var pheight = $(window).height();
        $('#previewTitulo').text(titulo);

        var popupChart = new Highcharts.Chart(Highcharts.merge(options, {
            chart: {
                renderTo: 'full-screen-box-body',
                width: pwidth * multiplicador,
                height: pheight * multiplicador
            },
            legend: {
                maxHeight: 800,
                itemStyle: {
                    fontSize: 14
                }
            }
        }));

        switch (tipoObj) {
            case 1:
                for (var i = 0; i < popupChart.series.length; i++) {
                    popupChart.series[i].update({
                        dataLabels: {
                            rotation: 0,
                            inside: false,
                            enabled: true,
                            y: -3,
                            style: {
                                fontSize: 18,
                                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                            }
                        }
                    });
                }
                break;
            case 2:
            case 11:
                popupChart.options.plotOptions.pie.dataLabels.style.fontSize = 10;
                popupChart.legend.itemStyle.fontSize = 8;
                break;
            case 3:
            case 5:
                for (var i = 0; i < popupChart.series.length; i++) {
                    if (popupChart.series[i].type == 'spline') {
                        popupChart.series[i].update({
                            dataLabels: {
                                rotation: 0,
                                inside: false,
                                enabled: false,
                                y: -3,
                                style: {
                                    fontSize: 18,
                                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                                }
                            }
                        });
                    } else {
                        popupChart.series[i].update({
                            dataLabels: {
                                rotation: 0,
                                inside: false,
                                enabled: true,
                                y: -3,
                                style: {
                                    fontSize: 18,
                                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                                }
                            }
                        });
                    }
                }
                break;
            case 6:
            case 7:
            case 8:
                popupChart.yAxis[0].update({
                    stackLabels: {
                        enabled: true,
                        rotation: 0,
                        y: -3,
                        style: {
                            fontSize: 14,
                            color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                        }
                    }
                });
                break;

        }
        save_chart($('#full-screen-box-body').highcharts(), titulo);

    } else if (tipoObj == 22) {
        getScreenshotGrafico(divObjetoTablero);
    }
}

EXPORT_WIDTH = 2500;

function getScreenshotGrafico(divObjetoTablero) {

    var filename = divObjetoTablero.find('.titulo').text();
    html2canvas(divObjetoTablero.find('.ObjGrafico')[0], {
        useCORS: true
    }).then(function (canvas) {
        $("#downloadCanvasGraph").attr('href', canvas.toDataURL("image/png"));
        $("#downloadCanvasGraph").attr('download', filename + '.png');
        $("#downloadCanvasGraph")[0].click();
        })
        .catch(function (err) { console.log(err); });
}

function save_chart(chart, filename) {
    var render_width = EXPORT_WIDTH;
    var render_height = render_width * chart.chartHeight / chart.chartWidth
    var svg = chart.getSVG({
        exporting: {
            sourceWidth: chart.chartWidth,
            sourceHeight: chart.chartHeight
        }
    });
    var canvas = document.createElement('canvas');
    canvas.height = render_height;
    canvas.width = render_width;
    var image = new Image;
    $(image).on('load', function () {
        canvas.getContext('2d').drawImage(this, 0, 0, render_width, render_height);
        var data = canvas.toDataURL("image/png")
        download(data, filename + '.png');
    });

    image.src = 'data:image/svg+xml;utf-8,' + svg;
}


function exportDataChartTipo21(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;

    var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
    var titulo = divObjetoTablero.find('.titulo').text();
    var dataRows = [];
    var data = []
    var categories = [];

    categories.push("");
    $.each(chart.axes[0].names, function (ix, cat) {
        categories.push(cat);
    });

    $.each(chart.series[0].data, function (i, dat) {
        var row = [];
        row.push(dat.name);
        row.push(dat.z);
        row.push(dat.y);

        dataRows.push(row);
    });

    $.each(categories, function (ix, cat) {

        var first = true;
        $.each(dataRows, function (i, r) {
            var data_r = [];
            if (r[0] == cat) {
                if (first) {
                    data_r.push(r[0]);
                    first = false;
                } else {
                    data_r.push("");
                }
                data_r.push(r[1]);
                data_r.push(r[2]);
                data.push(data_r);

            }
        });

    });
    
    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, false);
}

function exportDataChartTipo22(divObjetoTablero) {
    if (divObjetoTablero.find('.ObjSinDatos').is(':visible')) return false;
    
    var chart = divObjetoTablero.find('.ObjGrafico').highcharts();
    var titulo = divObjetoTablero.find('.titulo').text();
    var data = [];

    var categories = [];

    categories.push("");

    $.each(chart.axes[0].categories, function (key, cat) {
        //var newcat = serie.category.replace('<br>',' ');
        //if (!(categories.indexOf(newcat) > -1)) {
        //   categories.push(newcat);
        //}
        categories.push(cat.replace("<br>", " "));

    });
    data.push(categories);

    

    $.each(chart.axes[1].series, function (key, serie) {
        var fila = [];
        fila.push(serie.name);
        $.each(serie.data, function (index, dat) {
            if (dat.y == null) {
                fila.push("");
            } else {
                fila.push(dat.y);
            }
        });
        data.push(fila);
    });


   


    JSONToCSVConvertor(JSON.parse(JSON.stringify(data)), titulo, false);
}

//function download(data, filename) {
//    var a = document.createElement('a');
//    a.download = filename;
//    a.href = data
//    document.body.appendChild(a);
//    a.click();
//    a.remove();
//}