// CASE INSENSITIVE TEXT SEARCH
jQuery.expr[':'].icontains = function (a, i, m) {
    return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
}

//JSON to CSV
function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
    var CSV = '';
    CSV += 'sep=;' + '\r\n';
    CSV += ReportTitle + '\r\n\n';
    if (ShowLabel) {
        var row = "";
        for (var index in arrData[0]) {
            row += index + ';';
        }

        row = row.slice(0, -1);
        CSV += row + '\r\n';
    }

    for (var i = 0; i < arrData.length; i++) {
        var row = "";
        for (var index in arrData[i]) {
            row += '"' + arrData[i][index] + '";';
        }
        row.slice(0, row.length - 1);
        CSV += row + '\r\n';
    }

    if (CSV == '') {
        alert("Invalid data");
        return;
    }

    var fileName = "";
    fileName += ReportTitle.replace(/ /g, "_");

    var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);

    var link = document.createElement("a");
    link.href = uri;

    link.style = "visibility:hidden";
    link.download = fileName + ".csv";

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function setFechasDowngradeBrowsers() {


    $('.date-filtro-day').attr('type', 'text');
    $('.date-filtro-month').attr('type', 'text');
    $('.date-filtro-week').attr('type', 'text');

    $('.date-filtro-day').datepicker();
    $('.date-filtro-month').MonthPicker({ Button: false, MonthFormat: 'yy-mm' });

    $('.date-filtro-week').each(function (i, el) {
        convertToWeekPicker($(el));
    });


}

$(".onlyinteger").on("keypress keyup blur", function (event) {
    $(this).val($(this).val().replace(/[^\d].+/, ""));
    if ((event.which < 48 || event.which > 57)) {
        event.preventDefault();
    }
});

function b64toBlob(b64Data, contentType, sliceSize) {
    contentType = contentType || '';
    sliceSize = sliceSize || 512;

    var byteCharacters = atob(b64Data);
    var byteArrays = [];

    for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
        var slice = byteCharacters.slice(offset, offset + sliceSize);

        var byteNumbers = new Array(slice.length);
        for (var i = 0; i < slice.length; i++) {
            byteNumbers[i] = slice.charCodeAt(i);
        }

        var byteArray = new Uint8Array(byteNumbers);

        byteArrays.push(byteArray);
    }

    var blob = new Blob(byteArrays, { type: contentType });
    return blob;
}


var exportTablesToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,'
        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{tables}</body></html>'
        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
    return function (url, urldescarga, tables, worksheet_name, filename, show_details, si_only) {

        var bodycontent = '';

        for (var i = 0; i < tables.length; i++) {
            if (!tables[i].nodeType) {
                tables[i] = document.getElementById(tables[i]);

                var tablahtml = '<table><thead>';

                for (var j = 0; j < tables[i].rows.length; j++) {

                    var rowHTML = tables[i].rows[j];
                    if (show_details || (!show_details && !si_only && !$(rowHTML).hasClass('xls-detail')) || (!show_details && si_only && $(rowHTML).hasClass('SIRow'))) {
                        var rowStyle = rowHTML.style.cssText.replace("none", "block");

                        tablahtml += '<tr style="' + rowStyle + '">';

                        for (var k = 0; k < tables[i].rows[j].cells.length; k++) {

                            var cellHTML = tables[i].rows[j].cells[k];
                            var cellStyle = cellHTML.style.cssText.replace("none", "block");
                            var cellText = (si_only && cellHTML.getAttribute('class') == 'SIHeader') ? "" : (si_only && ((cellHTML.getAttribute('data-value') == 'Sales In') || (cellHTML.getAttribute('data-value') == cellHTML.parentElement.parentElement.parentElement.getAttribute('data-sku')))) ? (cellHTML.parentElement.parentElement.parentElement.getAttribute('data-sku')) : cellHTML.getAttribute('data-value');
                            var cellMonth = cellHTML.getAttribute('data-month');
                            var cellYear = cellHTML.getAttribute('data-year');

                            if (cellText == 'null' || cellText == null) {
                                cellText = '';
                            }

                            if (cellMonth != null && cellYear != null) {
                                cellText = (moment(cellMonth, 'MM').locale(window.navigator.language).format('MMM') + ' ' + cellYear).charAt(0).toUpperCase() + (moment(cellMonth, 'MM').locale(window.navigator.language).format('MMM') + ' ' + cellYear).slice(1) + ' ' + cellText.substring(cellText.indexOf('('));
                            }

                            var cell = '';
                            if (j === 0) {
                                if ((si_only && cellHTML.getAttribute('class').trim() != 'futurecol' && cellHTML.getAttribute('class').trim() != 'fchddncol' && cellHTML.getAttribute('class').trim() != 'sifyttl') || !si_only) {
                                    cell = '<th style="' + (!si_only ? cellStyle : "") + '">' + (si_only && k == 0 ? 'Material' : cellText) + '</th>' + (si_only && k == 0 ? '<th style=""></th>' : '');
                                }
                            } else {
                                if ((si_only && cellHTML.getAttribute('class').trim() != 'futurecol' && cellHTML.getAttribute('class').trim() != 'fchddncol' && cellHTML.getAttribute('class').trim() != 'sifyttl') || !si_only) {
                                    if (si_only && cellText.split(";")[1] != null) {
                                        cell = '<td style="' + (!si_only ? cellStyle : "") + '">' + cellText.split(";")[0] + '</td>' + '<td style="' + (!si_only ? cellStyle : "") + '">' + cellText.split(";")[1] + '</td>';
                                    }
                                    else {
                                        cell = '<td style="' + (!si_only ? cellStyle : "") + '">' + cellText + '</td>';
                                    }
                                }
                            }

                            tablahtml += cell;
                        }

                        if (j === 0) {
                            tablahtml += '</tr></thead><tbody>';
                        } else {
                            tablahtml += '</tr>';
                        }
                    }
                }

                tablahtml += '</tbody></table>';

                bodycontent += tablahtml;
            }
        }

        //Vuelvo para atras el Excel posta porque anda lento, tremendo.
        if (!si_only) {
            var ctx = { worksheet: worksheet_name || 'Worksheet', tables: bodycontent }


            workbookXML = format(template, ctx);

            var link = document.createElement("a");


            var blob = b64toBlob(base64(format(template, ctx)), "application/vnd.ms-excel");

            var blobUrl = URL.createObjectURL(blob);


            link.href = blobUrl;

            link.download = filename || 'Workbook.xls';

            link.target = '_blank';

            document.body.appendChild(link);

            link.click();

            document.body.removeChild(link);
        }
        else {
            var ctx = { worksheet: worksheet_name || 'Worksheet', tables: bodycontent }
            workbookXML = format(template, ctx);

            $.ajax({
                type: "POST",
                url: url,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ HtmlDoc: workbookXML.toString(), Soar: (si_only ? true : false) }),
                success: function (result) {
                    console.log(result);
                    if (result.length <= 0) {
                        return;
                    }

                    var dl = document.createElement("a");
                    dl.href = urldescarga + "?fc=true&token=" + result;
                    dl.download = filename + ".xlsx";
                    dl.style = "visibility:hidden;";
                    dl.onclick = 'return false;';
                    document.body.appendChild(dl);
                    dl.click();
                    document.body.removeChild(dl);

                },
                error: function (err) {
                    console.log(err);
                }
            });
        }


        

    }
})()