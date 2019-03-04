Highcharts.setOptions({
    lang: {
        drillUpText: '◁ Volver',
        decimalPoint: ',',
        thousandsSep: '.'
    },
    colors: ['#44575D', '#FF2900', '#FF7B00', '#FFBB00', '#089D83', '#1E2E39', '#Be3124', '#8C4002', '#A48200', '#066858', '#87919A', '#Ff6669', '#F0A44D', '#FFD342', '#6ECCC1', '#ADBFC1', '#F8AAB0', '#FFCB9E', '#F2E39B', '#B5E8DA']
});

function CargarGrafico(divObjetoTablero, page, height, tipoDeVista, url, tableroid) {
    let objid = divObjetoTablero.attr('data-id');
    let divGrafico = divObjetoTablero.find('.ObjGrafico');

    $.ajax({
        type: "POST",
        url: url,
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            objetoid: objid,
            page: page,
            tableroid: tableroid
        }),
        beforeSend: () => {
            divObjetoTablero.find('.Objloading').show();
            divObjetoTablero.find('.ObjSinDatos').hide();
            divObjetoTablero.find('.ObjGrafico').html('');
        },
        success: (data) => {
            divObjetoTablero.find('.Objloading').hide();
            if (data.Valores && data.Valores.length > 0) {
                divObjetoTablero.find('.ObjSinDatos').hide();
                divObjetoTablero.find('.dropdown').show();
                divObjetoTablero.find('.ObjGrafico').show();
                divObjetoTablero.find('.ObjGrafico').show();
                try {
                    data.height = height;
                    data.page = page;
                    data.objid = objid;
                    data.tipoDeVista = tipoDeVista;
                    //ESTA MAL TODO ESTO, PERO HAY QUE REESCRIBIR LA FUNCION
                    if (data.Tipo === 22) {
                        renderChartTipo22(divObjetoTablero, url, tableroid);
                    } else if (data.Tipo === 17) {
                        renderChartTipo17(divGrafico, objid, url);
                    } else if (data.Tipo === 16) {
                        renderChartTipo16(divObjetoTablero, url, tableroid);
                    } else if (data.Tipo === 15) {//ESTO DEBERIA VOLARLO AL PIGNO PERO EL T15 DEVUELVE EL HTML ARMADO Y NO UN JSON, SE PUEDE REHACER TRANQUILAMENTE
                        renderChartTipo15(divGrafico, divObjetoTablero, url, tableroid, objid);
                    } else {
                        chartSelector(data.Tipo, divGrafico, data);
                    }
                }
                catch (err) {
                    console.error(err);
                }
            }
            else {
                divObjetoTablero.find('.ObjGrafico').hide();
                divObjetoTablero.find('.ObjSinDatos').show();
                divObjetoTablero.find('.dropdown').hide();
            }
        }
    });
}

function chartSelector(objtipo, divGrafico, data) {
    switch (objtipo) {
        case 1:
            renderChartTipo1(divGrafico, data);
            break;
        case 2:
            renderChartTipo2(divGrafico, data);
            break;
        case 3:
            renderChartTipo3(divGrafico, data);
            break;
        case 5:
            renderChartTipo5(divGrafico, data);
            break;
        case 6:
            renderChartTipo6(divGrafico, data);
            break;
        case 7:
            renderChartTipo7(divGrafico, data);
            break;
        case 8:
            renderChartTipo8(divGrafico, data);
            break;
        case 9:
            renderChartTipo9(divGrafico, data);
            break;
        case 10:
            renderChartTipo10(divGrafico, data);
            break;
        case 11:
            renderChartTipo11(divGrafico, data);
            break;
        case 12:
            renderChartTipo12(divGrafico, data);
            break;
        case 13:
            renderChartTipo13(divGrafico, data);
            break;
        case 14:
            renderChartTipo14(divGrafico, data);
            break;
        //case 15:
        //    renderChartTipo15(divGrafico, data);
        //    break;
        //case 16:
        //    renderChartTipo16(divGrafico, data);
        //    break;
        //case 17:
        //    renderChartTipo17(divGrafico, data);
        //    break;
        case 18:
            renderCharTipo18(divGrafico, data);
            break;
        case 19:
            renderChartTipo19(divGrafico, data);
            break;
        case 20:
            renderChartTipo20(divGrafico, data);
            break;
        case 21:
            renderChartTipo21(divGrafico, data);
            break;
        //case 22:
        //    renderChartTipo22(divGrafico, data);
        //    break;
        case 23:
            renderChartTipo23(divGrafico, data);
            break;
        case 24:
            renderChartTipo24(divGrafico, data);
            break;
        case 25:
            renderChartTipo25(divGrafico, data);
            break;
        case 26:
            renderChartTipo26(divGrafico, data);
            break;
        case 27:
            renderChartTipo27(divGrafico, data);
            break;
        case 28:
            renderChartTipo28(divGrafico, data);
            break;
        case 29:
            renderChartTipo29(divGrafico, data);
            break;
        case 30:
            renderChartTipo30(divGrafico, data);
            break;
        case 31:
            renderChartTipo31(divGrafico, data);
            break;
        case 32:
            renderChartTipo32(divGrafico, data);
            break;
        default:
            console.log("no existe grafico");
            return false;
    }
}

function renderChartTipo1(divGrafico, data) {
    if(!data.ShowTitle)
        divGrafico.parent().siblings('.objeto-panel-heading').hide();
    if (data.Height > 0) {
        divGrafico.css({ 'height': data.Height + "px" });
        divGrafico.parent('.panel-body').css({ 'overflow-y': 'scroll' });
    }
 
    const t = divGrafico.parents('.objetoTablero').find('.objeto-panel-heading span.titulo').text();

    $(divGrafico).highcharts(
        {
            chart: {
                type: 'column',
                inverted: data.IsInverted
            },

            legend: {
                enabled: data.ShowLegend
            },

            exporting: {
                enabled: false
            },
            credits: {
                enabled: false
            },
            title: {
                text: !data.ShowTitle && t ? t : null
            },
            subtitle: {
                text: data.Totales
            },
            xAxis: {
                categories: data.Categories,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: null
                },
                max: data.IsPercentage ? 100 : null
            },
            tooltip: {
                formatter: function () {
                    let s = `<b>${this.x}</b>` + this.points.map((p) => {
                        return `<br/><span style="color:${p.series.color}">${p.series.name}</span>:
                                <b>${data.IsPercentage ? ` %` : ``}${p.y.toFixed(2)}</b>`;
                    }).join('');

                    s += data.LabelsEnabled === true ?
                        `<br/><b><span style="color:${this.points[1].series.color}">% ${this.points[1].series.name}</span></b>:
                                <b>${data.IsPercentage ? ` %` : ``}${(this.points[1].y * 100.0 / this.points[0].y).toFixed(2)}%</b>`
                        :
                        '';
                    return s;
                },
                shared: true
            },
            plotOptions: {
                series: {
                    borderWidth: 0,
                    dataLabels: { enabled: data.LabelsEnabled || data.ShowValues }
                },
                column: {
                    dataLabels: {
                        allowOverlap: true,
                        formatter: function () {
                            if (!data.ShowValues) {
                                let firstColumnValue = this.y;
                                let secondColumnValue = this.series.chart.series[1].yData[this.point.index];
                                let outVal;
                                let yourCalculation = 0;
                                if (this.color !== "#44575D") {
                                    outVal = '';
                                }
                                else {
                                    yourCalculation = 100.0 * secondColumnValue / firstColumnValue;
                                    outVal = yourCalculation.toFixed(2) + '%';
                                }
                                return outVal;
                            }
                            else {
                                return this.y;
                            }
                        }
                    },
                    grouping: false
                }
            },
            series: data.Valores
        });
}

function renderChartTipo2(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: null
        },
        tooltip: {
            pointFormat: '<b>{point.y:.0f}({point.percentage:.1f}%)</b>'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.y:.0f}({point.percentage:.1f}%)</b>',
                    distance: 5
                },
                showInLegend: true
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || 'white',
            shadow: true,
            maxHeight: 200,
            itemStyle: { fontSize: 8 }
        },
        series: [{
            name: null,
            colorByPoint: true,
            data: data.Valores
        }]
    });
}

function renderChartTipo3(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: { type: 'column' },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x: 0,
            y: 0,
            backgroundColor: '#ddd'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        xAxis: { categories: data.Categories },
        yAxis: {
            min: 0,
            title: { text: null },
            stackLabels: {
                enabled: false,
                rotation: -90,
                x: 3,
                y: -18,
                style: {
                    fontWeight: 'bold',
                    color: 'black',
                    fontSize: 9
                },
                formatter: function () {
                    return this.total;
                }
            }
        },
        tooltip: {
            pointFormat: data.IsPercentage === true ?
                '<span style="color:{series.color}">{series.name}</span>: <b>{point.texto}</b> <br/>'
                : '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
            shared: true
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: data.Visiblelabel,
                    y: -20,
                    verticalAlign: 'top',
                    style: {
                        color: 'black',
                        fontSize: 9
                    }
                },
                stacking: 'normal'
            }
        },
        series: data.Valores
    });
}

function renderChartTipo4(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: { type: 'area' },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        xAxis: {
            categories: data.Categories,
            tickmarkPlacement: 'on',
            title: { enabled: false }
        },
        yAxis: {
            title: { text: 'Percent' }
        },
        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} millions)<br/>',
            shared: true
        },
        plotOptions: {
            area: {
                stacking: 'percent',
                lineColor: '#ffffff',
                lineWidth: 1,
                marker: {
                    lineWidth: 1,
                    lineColor: '#ffffff'
                }
            }
        },
        series: data.Valores
    });
}

function renderChartTipo5(divGrafico, data) {
    $(divGrafico).highcharts({
        title: { text: null },
        exporting: { enabled: false },
        credits: { enabled: false },
        xAxis: { categories: data.Categories },
        yAxis: {
            min: 0,
            title: { text: null }
        },
        subtitle: { text: null },
        labels: {
            items: [{
                html: null,
                style: {
                    left: '50px',
                    top: '18px',
                    color: Highcharts.theme && Highcharts.theme.textColor || 'black'
                }
            }]
        },
        plotOptions: {
            series: {
                dataLabels: {
                    enabled: false,
                    rotation: -90,
                    y: -15,
                    style: { fontSize: 9 }
                }
            }
        },
        series: data.Valores
    });
}

function renderChartTipo6(divGrafico, data) {
    const parent_data = data.Valores.map(s => (
        {
            name: s.name,
            data: s.data.map(dt => ({
                name: dt.name,
                y: dt.y,
                drilldown: dt.drilldown
            }))
        })
    );

    const drill_down_data = data.DrillDown.map(dd => (
        {
            name: dd.name,
            id: dd.id,
            data: dd.data.map(dt => ({
                name: dt.name,
                y: dt.y
            }))
        })
    );

    $(divGrafico).highcharts({
        chart: {
            type: 'column'
        },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x: 0,
            y: 0,
            backgroundColor: '#ddd'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        xAxis: {
            type: 'category',
            labels: {
                formatter: function () { return this.value.length > 15 ? this.value.substring(0, 15) + '...' : this.value; }
            }
        },
        yAxis: {
            min: 0,
            title: { text: null },
            stackLabels: {
                enabled: false,
                rotation: -90,
                x: 3,
                y: -18,
                style: {
                    fontSize: 9,
                    fontWeight: 'bold',
                    color: Highcharts.theme && Highcharts.theme.textColor || 'gray'
                }
            }
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: data.Visiblelabel,
                    y: -20,
                    verticalAlign: 'top'
                },
                stacking: 'normal'
            }
        },
        series: parent_data,
        drilldown: { series: drill_down_data }
    });
}

function renderChartTipo7(divGrafico, data) {
    const parent_data = data.Valores.map(s => (
        {
            name: s.name,
            color: s.color,
            data: s.data.map(dt => ({
                name: dt.name,
                y: dt.y,
                ExtraText: dt.ExtraText,
                drilldown: dt.drilldown
            }))
        })
    );

    const drill_down_data = data.DrillDown.map(dd => (
        {
            name: dd.name,
            id: dd.id,
            data: dd.data.map(dt => ({
                name: dt.name,
                y: dt.y,
                drilldown: dt.drilldown
            }))
        })
    );

    $(divGrafico).highcharts({
        chart: {
            type: 'column'
        },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x: 0,
            y: 0,
            backgroundColor: '#ddd'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: {
            text: null
        },
        subtitle: {
            text: null
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            min: 0,
            title: {
                text: null
            },
            stackLabels: {
                enabled: false,
                style: {
                    fontSize: '9px',
                    fontWeight: 'bold',
                    color: Highcharts.theme && Highcharts.theme.textColor || 'gray'
                }
            }
        },
        tooltip: {
            formatter: function () {
                let s;
                let categoria = this.key;
                if (data.IsPercentage === true) {
                    if (this.colorIndex !== null) //Esto es la categoria, es undefined en el segundo nivel{
                    {
                        let propio = this.y;
                        let total = this.series.yData.reduce((a, b) => a + b);
                        let porcentaje = (propio * 100.0 / total).toFixed(2);
                        s = `${this.point.series.name} <b>${porcentaje} %</b>`;
                    }
                    else {
                        s = `${this.point.series.name}<br/> ${categoria}:<b> ${this.y}</b>`;
                    }
                    return s;
                }
                else {
                    s = `${this.point.series.name}<br/> ${categoria}:<b> ${this.y}</b>`;
                }
                return s;
            },
            shared: false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: data.Visiblelabel,
                    formatter: function () {
                        if (data.ShowText === true)
                            return this.point.ExtraText;
                        else
                            return this.y;
                    }
                }
            }
        },
        series: parent_data,
        drilldown: {
            series: drill_down_data
        }
    });
}

function renderChartTipo8(divGrafico, data) {
    const parent_data = data.Valores.map(s => (
        {
            name: s.name,
            data: s.data.map(dt => ({
                name: dt.name,
                y: dt.y,
                color: dt.color,
                drilldown: dt.drilldown
            }))
        })
    );

    const drill_down_data = data.DrillDown.map(dd => (
        {
            name: dd.name,
            id: dd.id,
            data: dd.data.map(dt => ({
                name: dt.name,
                y: dt.y,
                color: dt.color
            }))
        })
    );

    $(divGrafico).highcharts({
        chart: {
            type: 'column',
            inverted: data.IsInverted
        },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x: 0,
            y: 0,
            backgroundColor: '#ddd',
            enabled: data.ShowLegend
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        xAxis: { type: 'category' },
        yAxis: {
            min: 0,
            title: { text: null },
            stackLabels: {
                enabled: false,
                rotation: -90,
                x: 3,
                y: -18,
                style: {
                    fontSize: 9,
                    fontWeight: 'bold',
                    color: Highcharts.theme && Highcharts.theme.textColor || 'gray'
                }
            }
        },
        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}:</span> {point.y:.0f}  <span style="text-align:right"><b>({point.percentage:.2f}%)</b></span><br>',
            shared: false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: { enabled: false },
                stacking: 'percent'
            }
        },
        series: parent_data,
        drilldown: { series: drill_down_data }
    });
}

function renderChartTipo9(divGrafico, data) {
    const pages = data.pages;
    const numpage = parseInt(data.page);
    let esAnidada = false;
    let contieneAgrupador = false;
    let ColGroup = 0;
    let ColTot = data.Columns.length;

    const cols = data.Columns.map((c, i) => {
        if (c.esclave === 'True') {
            esAnidada = true;
        }
        if (c.esAgrupador === 'True') {
            contieneAgrupador = true;
            ColgGroup = i;
        }
        return {
            data: c.name,
            title: c.title,
            visible: c.esclave === 'False' && c.mostrar === 'True' || c.mostrar === null, //ESTO ES UN STRING, ESTA MAL OBVIAMENTE :S
            esclave: c.esclave === 'True',
            width: c.width + '%'
        };
    });

    if (esAnidada) {
        const colDetails = {
            className: 'details-control hideCol',
            orderable: false,
            data: null,
            defaultContent: '',
            visible: true,
            width: 0.2 + '%'
        };
        cols.unshift(colDetails);
        contieneAgrupador = false;
    }

    const divtabla = document.createElement('div');
    divtabla.style.width = "100%";

    const tableElem = document.createElement('table');
    tableElem.className += " table";
    tableElem.className += " table-striped";
    tableElem.className += " table-bordered";
    tableElem.className += " table-condensed";
    tableElem.setAttribute('id', data.objid);

    $(divtabla).append(tableElem);

    $(divGrafico).append(divtabla);

    $.fn.dataTable.ext.errMode = 'throw';

    $(tableElem).DataTable({
        info: false,
        ordering: true,
        searching: false,
        lengthChange: false,
        paging: false,
        scrollX: true,
        scrollY: data.height,
        scrollCollapse: true,
        data: data.Valores,
        columns: cols,
        autoWidth: false,
        aaSorting: [],
        drawCallback: function () {
            if (contieneAgrupador) {
                const api = this.api();
                const rows = api.rows({ page: 'current' }).nodes();
                let last = null;

                api.column(ColGroup, { page: 'current' }).data().each(function (group, i) {
                    if (last !== group) {
                        $(rows).eq(i).before(
                            '<tr class="group"><td colspan="' + (ColTot - ColGroup) + '"><b>' + group + '</b></td></tr>'
                        );
                        last = group;
                    }
                });
                api.column(ColGroup).visible(false);
            }
        }
    });

    if (pages > 1) {
        const divControles = $('<div class="tablaControles" style="margin-top:3px;">');
        const firstPage = $('<a>', { href: '#', text: '<<', style: 'margin-left:20px;', class: 'tablefirstpage' });
        const leftPage = $('<a>', { href: '#', text: '<', style: 'margin-left:20px;', class: 'tablepreviouspage' });
        const rightPage = $('<a>', { href: '#', text: '>', style: 'margin-left:20px;', class: 'tablenextpage' });
        const lastPage = $('<a>', { href: '#', text: '>>', style: 'margin-left:20px;', class: 'tablelastpage' });
        const spanPages = $('<span>', { text: 'página ' + numpage + ' de ' + pages, style: 'margin-left:20px;margin-top:-3px;' });
        const hddnPage = $('<input>', { type: 'hidden', class: 'numpage', value: numpage });
        hddnPage.attr('data-totalpages', pages);
        firstPage.appendTo(divControles);
        leftPage.appendTo(divControles);
        rightPage.appendTo(divControles);
        lastPage.appendTo(divControles);
        spanPages.appendTo(divControles);
        hddnPage.appendTo(divControles);
        divControles.appendTo(divGrafico);

        if (numpage === pages) {
            divGrafico.find('.tablenextpage').attr('disabled', 'disabled').addClass('aDisabled');
            divGrafico.find('.tablelastpage').attr('disabled', 'disabled').addClass('aDisabled');
            divGrafico.find('.tablefirstpage').removeAttr('disabled').removeClass('aDisabled');
            divGrafico.find('.tablepreviouspage').removeAttr('disabled').removeClass('aDisabled');
        }

        if (numpage === 1) {
            divGrafico.find('.tablenextpage').removeAttr('disabled').removeClass('aDisabled');
            divGrafico.find('.tablelastpage').removeAttr('disabled').removeClass('aDisabled');
            divGrafico.find('.tablefirstpage').attr('disabled', 'disabled').addClass('aDisabled');
            divGrafico.find('.tablepreviouspage').attr('disabled', 'disabled').addClass('aDisabled');
        }
    }
}

function renderChartTipo10(divGrafico, data) {

    let cloneToolTip = [];
    for (iSerie = 0; iSerie < data.Valores.length; iSerie++) {
        cloneToolTip[iSerie] = [];
    }

    $(divGrafico).highcharts({
        exporting: { enabled: false },
        credits: { enabled: false },
        title: {
            text: null,
            x: -20
        },
        subtitle: {
            text: null,
            x: -20
        },
        tooltip: {
            crosshairs: true,
            pointFormat: data.showText === true ? '<span style="color:{series.color}">{series.name}</span>: <b>{point.texto}</b> <br/>' : '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> <br/>'
        },
        plotOptions: {
            series: {
                events: {
                    click: function (event) {
                        if (data.Visibletooltip === true) {
                            var ix = this.index;
                            var chartContainer = this.chart.container;
                            var chartSeries = this.chart.series;
                            var newNodeToAdd = chartSeries[ix].chart.tooltip.label.element.cloneNode(true);
                        }
                        var cat = event.point.index;
                        var serieCloneToolTip = cloneToolTip[ix];

                        serieCloneToolTip[cat] = newNodeToAdd;
                        chartContainer.firstChild.appendChild(serieCloneToolTip[cat]);
                    }
                }
            }
        },
        xAxis: {
            categories: data.Categories
        },
        yAxis: {
            title: { text: null },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
            shadow: true,
            maxHeight: 200,
            itemStyle: { fontSize: 8 }
        },
        series: data.Valores
    });
}

function renderChartTipo11(divGrafico, data) {
    let labels;
    if (data.showVal !== null && data.showVal === false) {
        labels = '<b>{point.percentage:.1f}%</b>';
    }
    else {
        labels = '<b>{point.percentage:.1f}% ({point.y})</b>';
    }
    $(divGrafico).highcharts({
        chart: {
            type: 'pie'
        },
        title: {
            text: null
        },
        subtitle: {
            text: null
        },
        tooltip: {
            pointFormat: '<b>{point.percentage:.1f}%</b>'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: labels,
                    distance: 5
                },
                showInLegend: true
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
            shadow: true,
            maxHeight: 200,
            width: 120,
            itemStyle: {
                fontSize: 8
            }
        },
        series: [{
            name: 'Empresas',
            colorByPoint: true,
            data: data.Valores
        }],
        drilldown: {
            series: data.DrillDown
        }
    });
}

function renderChartTipo12(divGrafico, data) {
    let html = data.Valores.map(itm => (
        `<div class="nivelMetrica" data-nivel="${itm.nivel}">`
        + itm.data.map(dat => (
            `<div class="graficot12">` +
            (dat.logo
                ? `<div class="t12logo">
                          <img src="data:image/png;base64,${dat.logo}" />
                       </div>`
                : '')
            + `<div class="t12titulo">
                      <span>${dat.info}</span>
                   </div>
                   <div class="t12circliful" data-color="#${dat.color}" data-text="${dat.valor}"></div>
                </div>`
        )).join('')
        + '</div>'
    )).join('');

    divGrafico.html(html);

    $.each(divGrafico.find(".t12circliful"), function () {
        let color = $(this).data('color');
        let text = $(this).data('text');

        $(this).circliful({
            percent: text,
            text: '',
            replacePercentageByText: text,
            foregroundColor: color,
            textSize: 28,
            textStyle: 'font-size: 12px;',
            textColor: '#FFF'
        });
    });
}

function renderChartTipo13(divGrafico, data) {

    let maxY = 0;
    for (var i = 0; i < data.Valores.length; i++) {
        var maxSerie = Math.ceil(Math.max.apply(null, data.Valores[i].data));
        if (maxSerie > maxY) {
            maxY = maxSerie;
        }
    }
    let tickInterval = Math.ceil(maxY / 5);
    $(divGrafico).highcharts({
        chart: {
            polar: true,
            type: 'line'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: {
            text: null,
            x: -20
        },
        subtitle: {
            text: null,
            x: -20
        },
        tooltip: {
            shared: true,
            crosshairs: true
        },
        xAxis: {
            categories: data.Categories,
            tickmarkPlacement: 'on',
            lineWidth: 0
        },
        yAxis: {
            gridLineInterpolation: 'polygon',
            plotBands: [{

                from: 0,
                to: maxY
            }],
            tickInterval: tickInterval,
            startOnTick: false,
            tickmarkPlacement: "on",
            max: maxY
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
            shadow: true,
            maxHeight: 200,
            itemStyle: {
                fontSize: 8
            }
        },
        series: data.Valores
    });
}

function renderChartTipo14(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: {
            type: 'column'
        },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x: 0,
            y: 0,
            backgroundColor: '#ddd'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        xAxis: { categories: data.Categories },
        yAxis: {
            min: 0,
            title: { text: null },
            stackLabels: {
                enabled: false,
                rotation: -90,
                x: 3,
                y: -18,
                style: {
                    fontWeight: 'bold',
                    color: 'black',
                    fontSize: 9
                },
                formatter: function () {
                    return this.total;
                }
            }
        },
        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
            shared: true
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: false,
                    rotation: -90,
                    style: {
                        color: 'black',
                        fontSize: 9
                    }
                },
                stacking: 'percent'
            }
        },
        series: data.Valores
    });
}

///A ESTA FUNCION NO LA HICE TODAVIA Y NO SE COMO HACERLA
function renderChartTipo15(divGrafico, divObjetoTablero, url, tableroid, objid) {
    var tipoDeVista = divObjetoTablero.attr('data-size');
    $(divGrafico).renderImagenes({
        urlDatosFn: url,
        parametros: {
            objetoid: objid,
            tableroid: tableroid
        },
        size: tipoDeVista
    });
}

//A ESTA FUNCION TAMPOCO LA HICE LPM
function renderChartTipo16(divObjetoTablero, url, tableroid) {
    $(divObjetoTablero).etiquetaLayout({
        urlDatosFn: url,
        parametros: {
            tableroid: tableroid
        },
        viewType: 'S'
    });
}

//A ESTA FUNCION TAMPOCO LA HICE!!!!
function renderChartTipo17(divGrafico, objid, url) {
    $(divGrafico).Timeline({
        urlDatosFn: url,
        parametros: {
            objetoId: objid
        }
    });
}

function renderChartTipo18(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false,
            type: 'pie'
        },
        title: { text: null },
        subtitle: { text: null },
        tooltip: { pointFormat: '<b>{point.y:.0f}({point.percentage:.1f}%)</b>' },
        exporting: { enabled: false },
        credits: { enabled: false },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.y:.0f}({point.percentage:.1f}%)</b>',
                    distance: -50
                },
                startAngle: -90,
                endAngle: 90,
                showInLegend: true
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
            shadow: true,
            maxHeight: 200,
            itemStyle: { fontSize: 8 }
        },
        series: [{
            type: 'pie',
            name: null,
            innerSize: '50%',
            colorByPoint: true,
            data: data.Valores
        }]
    });
}

function renderChartTipo19(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: { zoomType: 'xy' },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: { text: null },
        subtitle: { text: null },
        plotOptions: {
            spline: {
                dataLabels: { enabled: true }
            },
            column: {
                dataLabels: { enabled: true }
            }
        },
        xAxis: [{
            categories: data.Categories,
            crosshair: true
        }],
        yAxis: data.YAxis,
        tooltip: { shared: true },
        legend: {
            align: 'center',
            verticalAlign: 'bottom',
            x: 0,
            y: 0,
            floating: false,
            borderWidth: 1,
            backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
            shadow: true,
            maxHeight: 65
        },
        series: data.Valores
    });
}

function renderChartTipo20(divGrafico, data) {
    divGrafico.show().addClass("tabla-botones");
    divGrafico.show().css("display", "inline-block");

    const divtabla = document.createElement('div');
    divtabla.style = 'height:100%';

    const tableElem = document.createElement('table');
    tableElem.className += " table";
    tableElem.className += " table-striped";
    tableElem.className += " table-bordered";
    tableElem.className += " table-condensed";

    tableElem.setAttribute('id', data.objid);

    $(divtabla).append(tableElem);
    $(divGrafico).append(divtabla);

    const cols = data.Columns.map(c => (
        {
            data: c.name,
            title: c.title,
            visible: c.esclave === 'False' && c.mostrar === 'True' || c.mostrar === null,
            esclave: c.esclave === 'True',
            width: c.width + '%'
        }
    ));

    $.fn.dataTable.ext.errMode = 'throw';
    $(tableElem).DataTable({
        language: {
            info: "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            paginate: {
                previous: '  <  ',
                first: '  <<  ',
                next: '  >  ',
                last: '  >>  '
            }
        },
        dom: '<"toptable"rt><"bottom"pi>',
        pagingType: 'full',
        info: true,
        lengthChange: false,
        searching: false,
        pageLength: data.tipoDeVista === 'D' ? 50 : 7,
        data: data.Valores,
        columns: cols,
        fixedHeader: { footer: true },
        autoWidth: false,
        aaSorting: []
    });
}

function renderChartTipo21(divGrafico, data) {
    $(divGrafico).highcharts({
        chart: {
            type: 'scatter',
            zoomType: 'xy',
            spacingBottom: 30,
            spacingLeft: 5,
            spacingRight: 60
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        title: {
            text: null
        },
        subtitle: {
            text: null
        },
        tooltip: {
            headerFormat: '<b>{point.key}: </b>',
            pointFormat: '{point.z} ${point.y:.2f}'
        },
        xAxis: {
            title: {
                text: data.xTitulo,
                enabled: false
            },
            type: "category",
            align: 'center',
            labels: {
                useHTML: true,
                formatter: function () {
                    var imagen;
                    for (var im in data.imagenes) {
                        if (im === this.value)
                            imagen = data.imagenes[im];
                    }
                    if (!imagen) {
                        imagen = this.value;
                    }
                    return imagen;
                }
            }
        },
        yAxis: {
            title: {
                enabled: false,
                text: data.yTitulo
            },
            labels: { enabled: false }
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            series: {
                dataLabels: {
                    allowOverlap: true,
                    overflow: 'none',
                    crop: false,
                    float: true,
                    enabled: true,
                    formatter: function () {
                        return '<b>' + this.point.z.slice(0, 20) + '</b>  $' + this.point.y.toFixed(2);
                    }
                }
            },
            scatter: {
                marker: {
                    radius: 4,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                }
            }
        },
        series: [{
            data: data.Valores
        }
        ]
        , drilldown: { series: data.dataDrillDown }
    });
}

//EL T22 es una bosta, tiene bocha de propiedades que no sirven para nada
function renderChartTipo22(divObjetoTablero, url, tableroid) {
    var objid = divObjetoTablero.attr('data-id');
    var divGrafico = divObjetoTablero.find('.ObjGrafico');
    var n = url.indexOf("/Tableros/GetDataGraficoJson");
    var strEnd = url.substring(0, n + 1);
    var urlRepo = strEnd + "Tableros/GetReporteT22";

    $.ajax({
        type: "POST",
        url: url,
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            objetoid: objid,
            page: page,
            tableroid: tableroid
        }),
        beforeSend: function () {
            divObjetoTablero.find('.Objloading').show();
            divObjetoTablero.find('.ObjSinDatos').hide();
            divObjetoTablero.find('.ObjGrafico').html('');
        },
        error: function (textStatus, errorThrown) {
            alert("Status: " + textStatus); alert("Error: " + errorThrown);
        },
        success: function (data) {        
            var weekday = new Array(7);
            weekday[0] = "Sunday";
            weekday[1] = "Monday";
            weekday[2] = "Tuesday";
            weekday[3] = "Wednesday";
            weekday[4] = "Thursday";
            weekday[5] = "Friday";
            weekday[6] = "Saturday";

            divObjetoTablero.find('.Objloading').hide();


            for (var valor in data.Valores) {

                var arrayPrecio = data.Valores[valor].data;
                data.Valores[valor].legendIndex = valor;

                for (let j = 0; j < arrayPrecio.length; j++) {
                    if (arrayPrecio[j].y === 0) {
                        arrayPrecio[j] = null;
                    }
                }

            }
            var Fecha = data.Categories[0].substring(0, 6) === "Semana" ? false : true;

            var formatFecha = [];
            if (Fecha) {

                var PlotLineX = [];
                for (var i in data.Categories) {
                    var fechaPre = data.Categories[i].split("/");
                    var f = new Date(fechaPre[2], fechaPre[1] - 1, fechaPre[0]);


                    var month_ = String(f.getMonth() + 1);
                    var day_ = String(f.getDate());

                    if (month_.length < 2) month_ = '0' + month_;
                    if (day_.length < 2) day_ = '0' + day_;

                    weekday = new Array(7);
                    weekday[0] = "Sunday";
                    weekday[1] = "Monday";
                    weekday[2] = "Tuesday";
                    weekday[3] = "Wednesday";
                    weekday[4] = "Thursday";
                    weekday[5] = "Friday";
                    weekday[6] = "Saturday";

                    var nombreDia = weekday[f.getDay()];
                    var ffor = nombreDia + '<br>' + day_ + '/' + month_;

                    formatFecha.push(ffor);

                    if (f.getDay() === 6) {
                        var valorI = i;
                        var plotBand = {
                            color: '#058DC733',
                            from: (valorI * 1.0) + 0.5,
                            to: (valorI * 1.0) - 0.5
                        };
                        PlotLineX.push(plotBand);
                    }
                }
                var newPlotband = [];
                for (pb in data.PlotBands) {
                    var leyenda = data.PlotBands[pb].label.text;
                    var oldColorPlotband = data.PlotBands[pb].color;
                    var oldFromPlotband = data.PlotBands[pb].from;
                    var oldToPlotband = data.PlotBands[pb].to;

                    var newpb = {
                        color: oldColorPlotband,
                        from: oldFromPlotband,
                        to: oldToPlotband,

                        label: {
                            text: leyenda,
                            align: 'right',
                            style: {
                                color: 'gray',
                                fontWeight: 'bold'
                            }
                        }
                    };
                    newPlotband.push(newpb);
                }

            }
            if (data.Valores.length > 0) {

                var cloneToolTip = [];
                var clickDetected = false;

                for (iSerie = 0; iSerie < data.Valores.length; iSerie++) {
                    cloneToolTip[iSerie] = [];
                }
                divObjetoTablero.find('.ObjSinDatos').hide();
                divObjetoTablero.find('.dropdown').show();

                charto = $(divGrafico).highcharts({
                    chart: {
                        defaultSeriesType: 'spline',
                        zoomType: 'xy',
                        spacingLeft: 35,
                        marginBottom: 130
                    },

                    exporting: { enabled: false },
                    credits: { enabled: false },
                    title: {
                        text: null,
                        x: -20
                    },
                    subtitle: {
                        text: null,
                        x: -20
                    },
                    plotOptions: {
                        series: {
                            connectNulls: true,
                            events: {
                                click: function (event) {
                                    const chartContainer = this.chart.container;
                                    const chartSeries = this.chart.series;
                                    let thisName = this.name;
                                    let ix = this.index;

                                    if (clickDetected) {
                                        const producto = thisName;
                                        const fecha = data.Categories[event.point.x];
                                        const precio = event.point.y; 
                                        const anio = event.point.valorFecha;
                                 
                                        $.ajax({
                                            type: "POST",
                                            url: urlRepo,
                                            contentType: "application/json; charset=utf-8",
                                            data: JSON.stringify({
                                                producto: producto,
                                                fecha: fecha,
                                                precio: precio,
                                                tableroid: tableroid,
                                                tipoPrecio: data.TipoPrecio,
                                                anio: anio
                                            }),
                                            error: function (textStatus, errorThrown) {
                                                alert("Status: " + textStatus); alert("Error: " + errorThrown);
                                            },
                                            beforeSend: function () {
                                                $('#waitLoadTablero').show();
                                            },
                                            complete: function () {
                                                $('#waitLoadTablero').hide();
                                            },
                                            success: function (data) {

                                                if (data.length > 0) {
                                                    let resFinal = '';

                                                    for (let i in data) {

                                                        if (data[i].hasOwnProperty('IdReporte')) {
                                                            resFinal += 'Fecha Creacion:' + data[i].Fecha + '\n';
                                                            resFinal += 'Reporte: ' + data[i].IdReporte + '\n';
                                                            resFinal += 'Usuario: ' + data[i].Usuario + '\n';
                                                            resFinal += 'Punto de Venta: ' + data[i].PuntoDeVenta + '\n';
                                                            resFinal += '\n';
                                                        }

                                                        if (data[i].hasOwnProperty('Pais')) {
                                                            resFinal += 'Pais: ' + data[i].Pais + '\n';
                                                            resFinal += 'Valor: ' + data[i].Valor + '\n';
                                                            resFinal += '\n';
                                                        }
                                                    }
                                                    swal({
                                                        title: "Detalle reportes cargados",
                                                        text: resFinal,
                                                        buttons: {
                                                            cancel: "Cerrar",
                                                        }
                                                    });
                                                }
                                            },
                                            timeout: 10000
                                        });
                                        clickDetected = false;


                                        let cat = event.point.index;
                                        let serieCloneToolTip = cloneToolTip[ix];

                                        if (serieCloneToolTip[cat]) {
                                            chartContainer.firstChild.removeChild(serieCloneToolTip[cat]);

                                            serieCloneToolTip[cat] = null;
                                        }
                                    } else {
                                        clickDetected = true;
                                        const newNodeToAdd = chartSeries[ix].chart.tooltip.label.element.cloneNode(true);
                                        setTimeout(function () {
                                            let cat = event.point.index;
                                            let serieCloneToolTip = cloneToolTip[ix];


                                            if (serieCloneToolTip[cat]) {
                                                chartContainer.firstChild.removeChild(serieCloneToolTip[cat]);

                                                serieCloneToolTip[cat] = null;
                                            }
                                            else {
                                                serieCloneToolTip[cat] = newNodeToAdd;
                                                chartContainer.firstChild.appendChild(serieCloneToolTip[cat]);
                                            }
                                            clickDetected = false;
                                        }, 500);
                                    }
                                }
                            }
                        }
                    },
                    tooltip: {
                        formatter: function () {
                            var returnValueTT;
                            if (this.point.reportes < 0) {
                                returnValueTT = `<b>${this.point.name}</b> $${this.point.y.toFixed(2)}`;
                            } else {
                                returnValueTT = `<b>${this.point.name}</b> $${this.point.y.toFixed(2)} (${this.point.reportes})`;
                            }
                            return returnValueTT;
                        }
                    },
                    xAxis: {
                        categories: Fecha ? formatFecha : data.Categories,
                        plotBands: data.Categories                    },
                    yAxis: {
                        title: { text: null },
                        labels: { enabled: false }
                    },
                    legend: {
                        align: 'center',
                        verticalAlign: 'bottom',
                        x: 0,
                        y: 0,
                        floating: false,
                        borderWidth: 1,
                        backgroundColor: Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF',
                        shadow: true,
                        maxHeight: 65,
                        itemStyle: {
                            fontSize: 8
                        },
                        labelFormatter: function () {
                            if (data.LabelFullName === true) {
                                return this.name.substr(nombre.indexOf(" ") + 1);
                            }
                            else {
                                return this.name;
                            }
                        }
                    },
                    series: data.Valores
                });
                divObjetoTablero.find('.ObjGrafico').show();
            }
            else {
                divObjetoTablero.find('.ObjGrafico').hide();
                divObjetoTablero.find('.ObjSinDatos').show();
                divObjetoTablero.find('.dropdown').hide();
            }
        }
    });
}

function renderChartTipo23(divGrafico, data) {
    divGrafico.parent().siblings('.objeto-panel-heading').hide();
    divGrafico.css({ 'height': '85px' });
    divGrafico.parent().css({
        'min-height': '91px',
        'max-height': '91px',
        'margin-top': '8px'
    });

    const uList = document.createElement('ul');
    uList.style = 'list-style-type:none;display:flex;margin-left:-40px;justify-content:space-around;flex:1;margin-top:2px;line-height: normal;';

    data.Valores.map(value => {
        const listItem = document.createElement('li');
        listItem.style = 'padding-left:3px;padding-right:3px;';

        const divPanel = document.createElement('div');
        divPanel.className += 'panel panel-default';
        divPanel.style = 'top:-3px;background-color:#F2F2F2;';
        divPanel.title = value.Descripcion;

        const divPanelBody = document.createElement('div');
        divPanelBody.className += 'panel-body';
        divPanelBody.style = 'top:-18px;max-height: 73px;overflow: hidden;width: max-content;';

        const spanIcon = document.createElement('span');
        spanIcon.className += 'stat-icon';
        spanIcon.style = 'font-size:40px;display:inline-block;float:left;padding-right:10px;padding-left:10px';

        const icon = document.createElement('i');
        icon.className += value.Icono;
        icon.style = 'display:-webkit-inline-box;vertical-align:middle;';

        spanIcon.appendChild(icon);
        divPanelBody.appendChild(spanIcon);

        const divTexto = document.createElement('div');
        divTexto.className += 'pull-right text-center';
        divTexto.style = 'font-family:avenir next regular;padding-right:20px;color:#000;';

        const divTextoMain = document.createElement('div');
        divTextoMain.style = 'font-size:35px;font-weight:bold;';

        const textoDato = document.createTextNode(value.Valor);
        divTextoMain.appendChild(textoDato);

        const divTextoTitulo = document.createElement('div');
        divTextoTitulo.style = 'margin-top:-10px;';

        const textoTitulo = document.createTextNode(value.Titulo);
        divTextoTitulo.appendChild(textoTitulo);

        divTexto.appendChild(divTextoMain);
        divTexto.appendChild(divTextoTitulo);

        divPanelBody.appendChild(divTexto);

        divPanel.appendChild(divPanelBody);

        listItem.appendChild(divPanel);
        $(uList).append(listItem);
    });
    $(divGrafico).append(uList);

}

function renderChartTipo24(divGrafico, data) {
    //PARA EL COMPETIMETER Y PARA EL KPI ELIMINO EL TITULO LPM
    divGrafico.parent().siblings('.objeto-panel-heading').hide();
    divGrafico.css({ 'height': '85px' });
    divGrafico.parent().css({
        'min-height': '91px',
        'max-height': '91px',
        'margin-top': '8px'
    });

    const propioList = data.Producto.split(',');
    const competenciaList = data.Competencia.split(',');

    let listaProductos = '';
    let itemLista = '';

    if (propioList.length === competenciaList.length) {
        for (let i = 0; i < propioList.length; i++) {
            if (propioList[i].trim().length > 0 && competenciaList[i].trim().length > 0) {

                itemLista = propioList[i].trim().slice(0, 22) + " vs " + competenciaList[i].trim().slice(0, 22);
                if (listaProductos.indexOf(itemLista) === -1) { //Si no existe cadena en la lista, inserto                                          
                    listaProductos += itemLista + "<br/>";
                }
            }
        }
    }
    else {
        listaProductos = data.Productos.slice(0, 20) + " vs " + data.Competencia.slice(0, 20);
    }

    const MyCategorie = data.Etiquetas.reduce(function (map, obj) {
        map[obj.Valor] = obj.Label;
        return map;
    }, {});


    if (data.Valor > 0 || data.MaxValor > 0) {
        let valorCalculado = data.Valor;
        let lblMaxValor = data.MaxValor;

        if (lblMaxValor > 10) lblMaxValor = 10;

        if (data.Valor > 10) {
            valorCalculado = (-10 / 3 * valorCalculado) + (400 / 3);
        }
        else {
            valorCalculado = (2 * valorCalculado) + 80;
        }
        if (valorCalculado < 0) valorCalculado = 0;
        if (valorCalculado > 100) valorCalculado = 100;

        if (data.ExplicitValues === true) {
            valorCalculado = data.Valor;
            lblMaxValor = data.MaxValor;
        }

        //divObjetoTablero.find('.ObjSinDatos').hide();
        //divObjetoTablero.find('.dropdown').show();

        Highcharts.Renderer.prototype.symbols.line = function (x, y, width, height) {
            return ['M', x, y + width / 2, 'L', x + height, y + width / 2];
        };

        Highcharts.SVGRenderer.prototype.symbols.cross = function (x, y, w, h) {
            return ['M', x + w, y, 'L', x, y + h / 2, 'M', x, y + h / 2, 'L', x + w, y + h, 'M', x + w, y, 'L', x + w, y + h, 'z'];
        };
        if (Highcharts.VMLRenderer) {
            Highcharts.VMLRenderer.prototype.symbols.cross = Highcharts.SVGRenderer.prototype.symbols.cross;
        }

        $(divGrafico).highcharts({
            chart: {
                type: 'bar',
                margin: [30, 15, 5, 15],
                bottom: 0
            },
            credits: { enabled: false },
            exporting: { enabled: false },
            legend: { enabled: false },
            title: {
                useHTML: true,
                align: 'center',
                text: '<div class="competimeter-head" style="font-family:Avenir Next Medium;font-size:20px;font-style:italic;letter-spacing:10px;color:#9da4a7">' + data.Texto + '</div>',
                y: 18,
                style: {
                    fontSize: '20px',
                    padding: 2,
                    fontWeight: 'bold',
                    fontFamily: 'Avenir Next'
                }
            },
            xAxis: {
                tickLength: 0,
                lineColor: '#999',
                lineWidth: 0,
                labels: { enabled: false },
                bottom: 5
            },
            yAxis: {
                max: 102,
                showEmpty: true,
                labels: {
                    y: 0,
                    formatter: function () {
                        return MyCategorie[this.value];
                    },
                    autoRotation: false,
                    overflow: 'justify',
                    align: 'center',
                    style: {
                        fontWeight: 'bold',
                        fontFamily: 'Avenir Next Medium',
                        staggerLines: 1,
                        step: 1
                    }
                },
                tickInterval: 34,
                tickColor: '#fff',
                tickWidth: 1,
                tickLength: 2,
                gridLineWidth: 0,
                showLastLabel: true,
                startOnTick: true,
                title: { text: '' }
            },
            tooltip: {
                enabled: true,
                backgroundColor: 'rgba(255, 255, 255, .85)',
                borderWidth: 0,
                shadow: true,
                style: {
                    fontSize: '10px',
                    padding: 2,
                    fontweight: 'bold'
                },
                formatter: function () {
                    if (this.y < 102 && data.ExplicitValues === true) {
                        return "<b>" + this.series.name + "%</b><br/>" + listaProductos + "";
                    }
                    else {
                        return "<b>" + this.series.name + "%</b>";
                    }
                }
            },
            plotOptions: {
                bar: {
                    y: 10,
                    color: {
                        linearGradient: { x1: 0, x2: 0, y1: 1, y2: 0 },
                        stops: [
                            [0, 'rgb(255,0,0)'],
                            [0.5, 'rgb(255,255,0)'],
                            [1, 'rgb(0,255,0)']
                        ]
                    },
                    shadow: false,
                    borderWidth: 0
                },
                scatter: {
                    marker: {
                        symbol: 'cross',
                        lineWidth: 2,
                        radius: 10,
                        lineColor: '#000'
                    }
                }
            },
            series: [{ name: Highcharts.numberFormat(lblMaxValor, 2), pointWidth: 20, data: [102] },
            { name: Highcharts.numberFormat(data.Valor, 2), type: 'scatter', data: [valorCalculado] }]
        });
    }
}

function renderChartTipo25(divGrafico, data) {
    let paginaCount = 6;

    divGrafico.show().addClass("tabla-botones");
    divGrafico.show().css("display", "inline-block");

    const divtabla = document.createElement('div');
    divtabla.style = 'height:90%';

    const tableElem = document.createElement('table');
    tableElem.className += " table";
    tableElem.className += " table-striped";
    tableElem.className += " table-bordered";
    tableElem.className += " table-condensed";

    tableElem.setAttribute('id', objid);
    $(divtabla).append(tableElem);
    $(divGrafico).append(divtabla);

    const cols = data.Columns.map(c => ({
        data: c.name,
        title: c.title,
        width: c.widht + '%'
    }));

    $.fn.dataTable.ext.errMode = 'throw';

    $(tableElem).DataTable({
        language: {
            info: data.Totales !== null ? data.Totales : '',
            paginate: {
                previous: '  ◀️  ',
                first: '  ⏪  ',
                next: '  ▶️  ',
                last: '  ⏩  '
            }
        },
        dom: '<"toptable"rt><"bottom"pi>',
        pagingType: 'full',
        info: true,
        lengthChange: false,
        searching: false,
        pageLength: paginaCount,
        data: data.Valores,
        columns: cols,
        fixedHeader: {
            footer: true
        },
        autoWidth: false,
        aaSorting: []
    });
}


function renderChartTipo26(divGrafico, data) {
    let html = '<div style="width:100%;overflow-x:scroll;overflow-y:hidden;white-space:nowrap;">';
    $.each(data.Valores, function (i, v) {
        var value = data.Valores[i].AlwaysFull == 1 ? 100 : v.Valor
        html += `
                        <div class="graficot26">
                            <div class="graficocontentt26">
                                <div class="divtablet26">
                                    <div  class="divboxt26 circlet26" data-color="`+ v.Color + `" data-image="` + v.Imagen + `" data-value="` + value + `"></div>
                                    <div class="divboxt26 infot26">
                                        <h3>`+ v.Title + `</h3>
                                        <p>`+ v.SubTitle + `</p> 
                                        <h3 style="color:`+ v.Color + `">` + v.Valor + v.Unidad + `</h3>
                                        <p style="color:`+ v.Color + `">` + v.LabelValor + `</p>                                 
                                    </div>
                                </div>
                                <div class="divinfot26">`
        $.each(v.SubItems, function (subi, subv) {
            html += `<div class="detailitemt26">
                                        <div class="detailitemimaget26">`
            if (subv.Imagen) {

                html += `<img src="data:image/png;base64,` + subv.Imagen + `" />`;

            } else {
                html += `<span>` + subv.Text + `</span>`;
            }

            html += `</div>
                                        <div class="detailitemtextt26">
                                            <svg height="20" width="20">
                                                <circle cx="10" cy="10" r="8" stroke-width="3" fill="`+ v.Color + `" />
                                            </svg>
                                            <span style="color: `+ v.Color + `">` + subv.Valor + subv.Unidad + `</span>
                                        </div>
                                    </div>`;
        });

        html += `</div>
                            </div>
                        </div>`;
    });

    html += '</div>';

    divGrafico.html(html);

    $.each(divGrafico.find(".circlet26"), function (i, v) {
        var value = $(v).attr('data-value');
        var img = $(v).attr('data-image');
        var color = $(v).attr('data-color');

        $(v).circliful({
            animation: 1,
            animationStep: 5,
            percent: value,
            textSize: 28,
            textStyle: 'font-size: 12px;',
            text: '',
            foregroundColor: (!color ? '#22B573' : color),
            iconPosition: 'middle',
            replacePercentageByText: '',
            backgroundColor: '#fff'
        });

        $(v).find('svg').css('background-image', 'url(\'data:image/jpeg;base64,' + img + '\')');
    });
}

function renderChartTipo27(divGrafico, data) {
    divGrafico.parent().siblings('.objeto-panel-heading').hide();
    let label;
    let secondlabel;

    $(divGrafico).highcharts({
        chart: {
            type: 'pie',
            events: {
                redraw: function () {
                    if (label) label.destroy();
                    if (secondlabel) secondlabel.destroy();
                    label = this.renderer.html('<div align="center" style="font-size: 25px; color: #000000; width: ' + divGrafico.width() + 'px">' + data.Total + '</div>', 0, divGrafico.find('.highcharts-plot-background')[0].y.baseVal.value + (divGrafico.find('.highcharts-plot-background')[0].height.baseVal.value * 0.5) - 12).add();
                    secondlabel = this.renderer.html('<div align="center" style="font-size: 12px; color: #000000; width: ' + divGrafico.width() + 'px">' + data.Target + '</div>', 0, divGrafico.find('.highcharts-plot-background')[0].y.baseVal.value + (divGrafico.find('.highcharts-plot-background')[0].height.baseVal.value * 0.70) - 6).add();
                },
                load: function () {
                    if (label) label.destroy();
                    if (secondlabel) secondlabel.destroy();
                    label = this.renderer.html('<div align="center" style="font-size: 25px; color: #000000; width: ' + divGrafico.width() + 'px">' + data.Total + '</div>', 0, divGrafico.find('.highcharts-plot-background')[0].y.baseVal.value + (divGrafico.find('.highcharts-plot-background')[0].height.baseVal.value * 0.5) - 12).add();
                    secondlabel = this.renderer.html('<div align="center" style="font-size: 12px; color: #000000; width: ' + divGrafico.width() + 'px">' + data.Target + '</div>', 0, divGrafico.find('.highcharts-plot-background')[0].y.baseVal.value + (divGrafico.find('.highcharts-plot-background')[0].height.baseVal.value * 0.70) - 6).add();
                }
            }
        },
        title: {
            text: '<p style="font-family:Avenir Next Medium">' + data.SerieName + '</p>',
            y: 10,
            align: 'left'
        },
        subtitle: {
            text: '<p style="font-family:Avenir Next Medium; font-size: 10px; padding: 0px">' + data.SubTitle/*'08/2018'*/ + '</p>',
            y: 10,
            align: 'right'
        },
        legend: {
            verticalAlign: 'bottom',
            itemStyle: {
                fontSize: data.LegendFontSize
            }
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        plotOptions: {
            pie: {
                showInLegend: true,
                shadow: false,
                dataLabels: {
                    enabled: false
                }
            }
        },
        tooltip: {
            formatter: function () {
                return '<span style="color:' + this.color + '">\u25CF</span> ' + '<b>' + this.key + '</b>' + ': ' + (data.showText === 0 ? this.y : this.point.text);
            }
        },
        series: [{
            name: data.SerieName,
            data: data.Valores,
            size: '120%',
            innerSize: data.FullPie === 1 ? null : '70%'
        }]
    });
}

function renderChartTipo28(divGrafico, data) {
    divGrafico.parent().siblings('.objeto-panel-heading').hide();

    let cloneToolTip;
    $(divGrafico).highcharts({
        chart: {
            type: 'column',
            events: {
                redraw: function () {
                    /*if (label) label.destroy();
                    label = this.renderer.label(data.Percent, (divObjetoTablero.find('.ObjGrafico').width() - ((14 * divObjetoTablero.find('.ObjGrafico').width()) / 100)), (divObjetoTablero.find('.ObjGrafico').height() / 2), 'rect', 1, 1, 1, 1, 'deletme')
                        .css({
                            fontSize: '15px',
                            color: '#000000',
                        })
                        .add();*/
                },
                load: function () {
                    /*label = this.renderer.label(data.Percent, (divObjetoTablero.find('.ObjGrafico').width() - ((14 * divObjetoTablero.find('.ObjGrafico').width()) / 100)), (divObjetoTablero.find('.ObjGrafico').height() / 2), 'rect', 1, 1, 1, 1, 'deletme')
                        .css({
                            fontSize: '15px',
                            color: '#000000'
                        })
                        .add();*/
                }
            }
        },
        title: {
            text: '<p style="font-family:Avenir Next Medium">' + data.SerieName + '</p>',
            y: 10,
            align: 'left'
        },
        subtitle: {
            text: (data.Percent ? '<p style="font-family:Avenir Next Medium"><b><span style="color:' + (data.Percent > 0 ? 'green;">▲</span> ' + data.Percent.toString() : 'red;">▼</span> ' + data.Percent.toString()) + ' %</b></p>' : ''),
            y: 80,
            useHTML: true,
            align: 'center'
        },
        legend: {
            y: 15,
            verticalAlign: 'bottom'
        },
        exporting: { enabled: false },
        credits: { enabled: false },
        plotOptions: {
            column: {
                showInLegend: true,
                dataLabels: {
                    enabled: true,
                    formatter: function () {
                        return this.point.perc;
                    }
                }
            },
            line: {
                showInLegend: true,
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    formatter: function () {
                        return this.point.perc;
                    }
                }
            },
            scatter: {
                marker: {
                    symbol: 'line',
                    lineWidth: 3
                }
            },
            series: {
                stacking: data.stack !== 0 ? 'normal' : undefined,
                groupPadding: 0,
                maxPointWidth: 100,
                events: {
                    click: function () {
                        if (data.PersistTooltip) {
                            var quit;
                            cloneToolTip = this.chart.tooltip.label.element.cloneNode(true);
                            cloneToolTip.classList.add("cloned");

                            for (var i = 0; i < this.chart.container.firstChild.childNodes.length; i++) {
                                if (this.chart.container.firstChild.childNodes[i].classList.contains("cloned")) {
                                    if (this.chart.container.firstChild.childNodes[i].innerHTML === cloneToolTip.innerHTML) {
                                        this.chart.container.firstChild.childNodes[i].remove();
                                        quit = true;
                                    }
                                }
                            }

                            if (quit) return;
                            this.chart.container.firstChild.appendChild(cloneToolTip);
                        }
                    }
                }
            }
        },
        yAxis: {
            enabled: false,
            min: data.minY !== 0 ? data.minY : null,
            max: data.maxY !== 0 ? data.maxY : null,
            tickInterval: 5,
            title: {
                enabled: false
            },
            labels: {
                enabled: data.ShowYAxisLabels !== 0 ?true:false,
                formatter: function () {
                    return data.ShowYAxisLabels !== 0 ?this.value + '%':this.value;
                }
            },
            gridLineWidth: 0,
            plotLines: data.PlotLines,
            plotBands: data.PlotBands,
        },
        xAxis: {
            lineWidth: 0,
            tickWidth: 0,
            categories: data.Categories
        },
        tooltip: {
            formatter: function () {
                return '<span style="color:' + this.series.color + '">\u25CF</span> ' + '<b>' + this.series.name + '</b>' + ': ' + (data.showText === 0 ? this.y : this.point.text);
            }
        },
        series: data.Valores
    });
}

function renderChartTipo29(divGrafico, data) {
    divGrafico.parent().siblings('.objeto-panel-heading').hide();

    let label;
    let secondlabel;

    $(divGrafico).highcharts({
        chart: {
            type: 'solidgauge',
            events: {
                redraw: function () {
                    if (label) label.destroy();
                    if (secondlabel) secondlabel.destroy();
                    label = this.renderer.html('<div align="center" style="font-size: 25px;color: #000000; width: ' + divObjetoTablero.find('.ObjGrafico').width() + 'px">' + data.Value + '</div>', 0, divObjetoTablero.find('.ObjGrafico').height() * .7).add();
                    secondlabel = this.renderer.html('<div align="center" style="font-size: 12;color: #000000; width: ' + divObjetoTablero.find('.ObjGrafico').width() + 'px"> ' + data.TargetLabel + ' <div style="color: #0000FF">' + data.Target + '</div></div>', 0, divObjetoTablero.find('.ObjGrafico').height() * .85).add();
                },
                load: function () {
                    if (label) label.destroy();
                    if (secondlabel) secondlabel.destroy();
                    label = this.renderer.html('<div align="center" style="font-size: 25px;color: #000000; width: ' + divObjetoTablero.find('.ObjGrafico').width() + 'px">' + data.Value + '</div>', 0, divObjetoTablero.find('.ObjGrafico').height() * .7).add();
                    secondlabel = this.renderer.html('<div align="center" style="font-size: 12;color: #000000; width: ' + divObjetoTablero.find('.ObjGrafico').width() + 'px"> ' + data.TargetLabel + ' <div style="color: #0000FF">' + data.Target + '</div></div>', 0, divObjetoTablero.find('.ObjGrafico').height() * .85).add();
                }
            }
        },
        title: {
            text: '<p style="font-family:Avenir Next Medium">' + data.SerieName + '</p>',
            y: 10,
            align: 'left'
        },
        legend: {
            y: divObjetoTablero.find('.ObjGrafico').width() + 15,
            verticalAlign: 'bottom'
        },
        exporting: { enabled: false },
        credits: { enabled: false },

        pane: {
            center: ['50%', '85%'],
            size: '140%',
            startAngle: -90,
            endAngle: 90,
            background: {
                backgroundColor: Highcharts.theme && Highcharts.theme.background2,
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
            }
        },
        yAxis: {
            min: data.MinY,
            max: data.MaxY,
            lineWidth: 0,
            title: {
                text: data.AxisLabel,
                y: -80
            },
            labels: {
                y: 16
            }
        },
        plotOptions: {
            solidgauge: {
                dataLabels: {
                    enabled: false,
                    y: 5,
                    borderWidth: 0,
                    useHTML: true
                }
            }
        },
        tooltip: {
            enabled: false
        },
        series: [{
            name: data.SerieName,
            data: [{ y: data.Value, color: data.Color }],
            size: '120%'
        }, {
            name: 'Target',
            isRectanglePoint: true,
            type: 'gauge',
            data: [{ y: data.Target }],
            dial: {
                backgroundColor: '#0000FF',
                rearLength: '-121%'
            },
            dataLabels: {
                enabled: false
            },
            pivot: {
                radius: 0
            }
        }]
    });
}

function renderChartTipo30(divGrafico, data) {
    let i;
    let j;
    const eDiv = document.createElement('div');
    eDiv.style.overflowX = 'auto';
    eDiv.style.overflowY = 'auto';
    eDiv.style.width = divGrafico.parent().width().toString() + 'px';

    const eTable = document.createElement('table');
    eTable.style.borderCollapse = 'collapse';
    eTable.style.borderSpacing = '0';
    eTable.style.width = '100%';
    eTable.style.border = '1px solid #ddd';

    const eHeader = document.createElement('tr');
    let eHeaderCell;

    if (data.Headers !== undefined) {
        for (i = 0; i < data.Headers.length; i++) {
            eHeaderCell = document.createElement('th');
            eHeaderCell.style.textAlign = 'left';
            eHeaderCell.style.padding = '8px';
            eHeaderCell.style.border = '1px solid #ddd';
            eHeaderCell.innerHTML = data.Headers[i];
            eHeader.append(eHeaderCell);
        }
    } else {
        for (var k in data.Valores[0]) {
            eHeaderCell = document.createElement('th');
            eHeaderCell.style.textAlign = 'left';
            eHeaderCell.style.padding = '8px';
            eHeaderCell.style.border = '1px solid #ddd';
            eHeaderCell.innerHTML = k;
            eHeader.append(eHeaderCell);
        }
    }

    eTable.append(eHeader);

    let eRow;
    let eCell;
    if (data.Headers !== undefined) {
        for (i = 0; i < data.Valores.length; i++) {

            eRow = document.createElement('tr');

            for (j = 0; j < data.Valores[i].length; j++) {
                eCell = document.createElement('td');
                eCell.style.textAlign = 'left';
                eCell.style.padding = '8px';
                eCell.style.border = '1px solid #ddd';
                eCell.innerHTML = data.Valores[i][j];
                eRow.append(eCell);
            }

            eTable.append(eRow);
        }
    } else {
        for (i = 0; i < data.Valores.length; i++) {

            eRow = document.createElement('tr');

            for (var v in data.Valores[i]) {
                eCell = document.createElement('td');
                eCell.style.textAlign = 'left';
                eCell.style.padding = '8px';
                eCell.style.border = '1px solid #ddd';
                eCell.innerHTML = data.Valores[i][v];
                eRow.append(eCell);
            }
            eTable.append(eRow);
        }
    }
    eDiv.append(eTable);

    divGrafico.append(eDiv);
}

function renderChartTipo31(divGrafico, data) {
    if (!data.showTitle)
        divGrafico.parent().siblings('.objeto-panel-heading').hide();

    const t = divGrafico.parents('.objetoTablero').find('.objeto-panel-heading span.titulo').text();

    const divresult = document.createElement('div');

    const div = document.createElement('div');
    div.style.display = 'block';
    div.style.width = '100%';
    div.style.height = '100%';
    div.style.padding = '5px 20px 20px 20px';
    //div.style.paddingLeft = '20px';
    //div.style.paddingRight = '20px';

    const colgroup = document.createElement('colgroup');
    const col1 = document.createElement('col');
    col1.setAttribute('span', '1');
    col1.style.width = '40%';

    const col2 = document.createElement('col');
    col2.setAttribute('span', '1');
    col2.style.width = '60%';

    colgroup.append(col1);
    colgroup.append(col2);

    const titulo = document.createElement('h2');
    titulo.innerHTML = t;

    const table = document.createElement('table');
    table.style.width = '100%';
    table.style.height = '100%';

    const thead = document.createElement('thead');
    const thtr = document.createElement('tr');
    const thh1 = document.createElement('th');
    const thh2 = document.createElement('th');

    thtr.append(thh1);
    thtr.append(thh2);
    thead.append(thtr);

    const tbody = document.createElement('tbody');

    const titlerow = document.createElement('tr');
    const titletd = document.createElement('td');
    titletd.style.color = '#333333';
    titletd.style.fontSize = '18px';
    titletd.style.fill = '#333333';
    titletd.style.fontFamily = '"Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif';
    titletd.colSpan = '2';
    titlerow.style.textAlign = 'center';
    titletd.innerHTML = t;

    titlerow.append(titletd);
    tbody.append(titlerow);
    let lastPosition = 0;
    $.each(data.Valores, function (i, v) {
        let tr = document.createElement('tr');
        tr.style.paddingTop = '2px';
        tr.style.paddingBottom = '2px';
        tr.style.borderBottom = '1px solid #ddd';
        let trtd1 = document.createElement('th');
        trtd1.innerHTML = v.name;
        let trtd2 = document.createElement('td');

        trtd2.setAttribute('data-sparkline', v.data.map(t => t.y));
        trtd2.setAttribute('data-sparkline-date-from', v.data.map(t => t.dateFrom));
        trtd2.setAttribute('data-sparkline-date-to', v.data.map(t => t.dateTo));
        trtd2.setAttribute('data-position', i);

        lastPosition = i;

        tr.append(trtd1);
        tr.append(trtd2);
        tbody.append(tr);
    });

    table.append(colgroup);
    table.append(thead);
    table.append(tbody);
    div.append(table);
    divGrafico.append(divresult);
    divGrafico.append(div);

    
    Highcharts.SparkLine = function (a, b, c) {


        let actualGraphPosition = a.getAttribute('data-position');
        
     
        var hasRenderToArg = typeof a === 'string' || a.nodeName,
            options = arguments[hasRenderToArg ? 1 : 0],
            defaultOptions = {
                chart: {
                    renderTo: (options.chart && options.chart.renderTo) || this,
                    backgroundColor: null,
                    borderWidth: 0,
                    type: 'area',
                    margin: [2, 0, 2, 0],
                    style: {
                        overflow: 'visible'
                    },

                    // small optimalization, saves 1-2 ms each sparkline
                    skipClone: true
                },
                title: {
                    text: ''
                },
                credits: {
                    enabled: false
                },
                exporting: {
                    enabled: false
                },
                xAxis: {
                    labels: {
                        enabled: (actualGraphPosition == lastPosition)? true: false
                    },
                    title: {
                        text: null
                    },
                    //startOnTick: false,
                    //endOnTick: false,
                    //tickPositions: [],
                    categories: data.Categories                     
                },
                yAxis: {
                    endOnTick: false,
                    startOnTick: false,
                    labels: {
                        enabled: false
                    },
                    title: {
                        text: null
                    },
                    tickPositions: [0]
                },
                legend: {
                    enabled: false
                },
                tooltip: {
                    hideDelay: 0,
                    outside: true,
                    shared: true
                },
                plotOptions: {
                    series: {
                        animation: false,
                        lineWidth: 1,
                        shadow: false,
                        states: {
                            hover: {
                                lineWidth: 1
                            }
                        },
                        marker: {
                            radius: 1,
                            states: {
                                hover: {
                                    radius: 2
                                }
                            }
                        },
                        fillColor: "transparent"
                    },
                    column: {
                        negativeColor: '#3EA9F5',
                        borderColor: '#0000FF'
                    }
                }
            };

        options = Highcharts.merge(defaultOptions, options);

        return hasRenderToArg ?
            new Highcharts.Chart(a, options, c) :
            new Highcharts.Chart(options, b);
    };

    var start = +new Date(),
        $tds = divGrafico.find('td[data-sparkline]'),
        fullLen = $tds.length,
        n = 0;

    // Creating 153 sparkline charts is quite fast in modern browsers, but IE8 and mobile
    // can take some seconds, so we split the input into chunks and apply them in timeouts
    // in order avoid locking up the browser process and allow interaction.
    function doChunk() {
        var time = +new Date(),
            i,
            len = $tds.length,
            $td,
            stringdata,
            arr,
            data,
            chart,
            stringdatefrom,
            stringdateto,
            arrfrom,
            arrto,
            datafrom,
            datato;

        for (i = 0; i < len; i += 1) {
            $td = $($tds[i]);
            stringdata = $td.data('sparkline');
            arr = stringdata.split('; ');
            data = $.map(arr[0].split(','), parseFloat);

            stringdatefrom = $td.data('sparkline-date-from');
            arrfrom = stringdatefrom.split('; ');
            datafrom = arrfrom[0].split(',');

            stringdateto = $td.data('sparkline-date-to');
            arrto = stringdateto.split('; ');
            datato = arrto[0].split(',');

            chart = {};
            
            let newData = [];
            for (j = 0; j < data.length; j++) {
                let newObj = {
                    y: data[j],
                    dateFrom: datafrom[j],
                    dateTo:datato[j]
                }; 
                newData.push(newObj);
            }

            if (arr[1]) {
                chart.type = arr[1];
            }
            $td.highcharts('SparkLine', {
                series: [{
                    data: newData,
                    pointStart: 0
                }],                
                tooltip: {
                   // headerFormat: '<span style="font-size: 10px">{point.dateFrom} </span><br/>',
                   // pointFormat: '<b>{point.y}</b> $'
                    formatter: function () {
                        return `<i>Desde:<b>${this.points[0].point.dateFrom}</b><br/>
                                 Hasta:<b>${this.points[0].point.dateTo}</b><br/></i>
                                <b>${this.y.toFixed(2)}</b>$`;
                    },
                    backgroundColor: '#FFFFFF55'
                },
                chart: chart
            });

            n += 1;

            // If the process takes too much time, run a timeout to allow interaction with the browser
            if (new Date() - time > 500) {
                $tds.splice(0, i + 1);
                setTimeout(doChunk, 0);
                break;
            }
        }
    }
    doChunk();


}

function renderChartTipo32(divGrafico, data) {
    divGrafico.parent().siblings('.objeto-panel-heading').hide();

    const spantitulo = document.createElement('span');
    spantitulo.innerHTML = data.Valores[0].Titulo;
    spantitulo.style = 'font-size: 14pt;';

    const spannumero = document.createElement('span');
    spannumero.style = 'font-size: 40pt;';
    spannumero.innerHTML = data.Valores[0].Valor;

    const spanicon = document.createElement('span');
    spanicon.className += 'stat-icon';
    //spanicon.style = 'font-size:40px;';

    const icon = document.createElement('i');
    //icon.className += value.Icono;
    icon.className += data.Valores[0].Icono;
    icon.style = 'display:-webkit-inline-box;vertical-align:middle;width:90px;height:90px;';
    spanicon.appendChild(icon);

    const divtitulo = document.createElement('div');
    divtitulo.style = 'display:block;width:100%;';

    const divnumero = document.createElement('div');
    divnumero.style = 'display:block;width:100%;';

    const divicon = document.createElement('div');
    divicon.style = 'display:block;width:100%;';

    divicon.append(spanicon);
    divtitulo.append(spantitulo);
    divnumero.append(spannumero);

    const div = document.createElement('div');
    div.style = 'display:block;width:100%;height:100%;text-align:center;padding-top: 20px;';

    div.append(divicon);
    div.append(divnumero);
    div.append(divtitulo);

    $(divGrafico).append(div);

}