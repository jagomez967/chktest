

"use strict";

(function ($) {
    $.fn.Timeline = function (options) {
        var settings = $.extend({}, $.fn.Timeline.defaults, options);

        if (settings.parametros.objetoId === 0) {
          
            return;
        }

        var obj = this;
        getDatos(obj);

        function getDatos(obj) {
            var divLoading = obj.parent().find('.Objloading');
            var divNodata = obj.parent().find('.ObjSinDatos');
            var divGrafico = obj.parent().find('.ObjGrafico');
            var tableroId = $('#TableroId').val();
            var divTimelineAmpliado = document.getElementById('vistaAmpliadaDeGrafico')
        
            $.ajax({
                url: settings.urlDatosFn,
                dataType: 'json',
                type: 'POST',
                data: { objetoid: settings.parametros.objetoId, tableroid: tableroId, page:-1 },
                beforeSend: function () {
                    divLoading.show();
                    divNodata.hide();
                },
                success: function (result) {
                 
                    obj.empty();
                    divGrafico.empty();
                    divLoading.hide();
                

                    if (result && result.Valores) {
                        divNodata.hide();
                        divGrafico.show();

                        if (divTimelineAmpliado === null) {
                            renderTimelineHorizontal(obj, result);
                        }
                        else {
                            renderTimelineVertical(obj, result);
                        }

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
    $.fn.Timeline.defaults = {
        urlDatosFn: null,
        parametros: {
            objetoId: null
        }
    };
}(jQuery))




function renderTimelineHorizontal(obj, result) {
   
    var htmlcontent = "Content/timeline-h/timeline-horizontal-template.html";

    obj.load(htmlcontent, function () {

        var events = $('.cd-horizontal-timeline').find('.events');
        var eventsol = document.createElement('ol');
        var eventsspan = $('<span>', { class: 'filling-line' });
        var eventsContent = $('.cd-horizontal-timeline').find('.events-content');
        var eventsContentol = document.createElement('ol');

        events.append(eventsol);
        events.append(eventsspan);
        eventsContent.append(eventsContentol);

        $.each(result.Valores, function (i, val) {
            var eventsli = document.createElement('li');
            var eventsa = document.createElement('a');
            //var aText = document.createTextNode(val.FechaCreacion);
            var eventsContentli = document.createElement('li');
            var timelinePanel = $('<div>', { class: 'timeline-horizontal-panel' });
            var timelineHeading = $('<div>', { class: 'timeline-horizontal-heading' });
            var timelineTitle = $('<div>', { class: 'timeline-horizontal-title' });
            var h4 = document.createElement('h4');
            var h6 = document.createElement('h6');
            var timelineUser = $('<div>', { class: 'timeline-horizontal-user' });
            var timelineAvatar = $('<div>', { class: 'timeline-horizontal-avatar' });
            var imgPerfil = document.createElement('img');
            var timelineUserdata = $('<div>', { class: 'timeline-horizontal-userdata' });
            var timelineUsernombre = $('<div>', { class: 'timeline-horizontal-userNombre' });
            var timelineFecha = document.createElement('small');
            var timelineBody = $('<div>', { class: 'timeline-horizontal-body' });
            var p = document.createElement('p');
            var p2 = document.createElement('p');
            // var p = $('<p>',{style:''})
            var divnombre = document.createElement('div');

            eventsol.appendChild(eventsli);
            eventsli.appendChild(eventsa);
            eventsli.append(divnombre);
            //eventsa.appendChild(aText);

            var fechaHora = val.FechaCreacion.split(/ +/);
            var pFecha = document.createElement('p');
            pFecha.innerHTML = fechaHora[0];
            var pHora = document.createElement('p');
            pHora.innerHTML = fechaHora[1];
            var icon = document.createElement('i');
            var timelineHbadge = document.createElement('div');
            var nombreCliente = val.Cliente;

            switch (val.AccionTipo) {
                case 'Login': icon.className = 'icon-horizontal fa fa-sign-in';
                    timelineHbadge.className = 'timelineHBadge badgeLogin';
                    break;
                case 'Logout': icon.className = 'icon-horizontal fa fa-sign-out';
                    timelineHbadge.className = 'timelineHBadge badgeLogout';
                    break;
                case 'CheckIn': icon.className = 'icon-horizontal fa fa-check';
                    timelineHbadge.className = 'timelineHBadge badgeCheckin';
                    break;
                case 'CheckOut': icon.className = 'icon-horizontal fa fa-times';
                    timelineHbadge.className = 'timelineHBadge badgeCheckout';
                    break;
                case 'Reporte': icon.className = 'icon-horizontal fa fa-file-text-o';
                    timelineHbadge.className = 'timelineHBadge badgeReporte';
                    break;
                case 'Info': icon.className = 'icon-horizontal fa fa-info-circle';
                    timelineHbadge.className = 'timelineHBadge badgeInfo';
                    break;
            }

            timelineHbadge.append(icon);
            eventsli.append(timelineHbadge);
            eventsa.append(pFecha);
            eventsa.append(pHora);

            divnombre.append(val.NombreUsuario + ' ' + val.ApellidoUsuario);
            divnombre.className = 'divnombreTimeline';

            eventsContentol.append(eventsContentli);
            $(eventsContentli).append(timelinePanel);
            timelinePanel.append(timelineHeading);
            timelineHeading.append(timelineTitle);
            timelineTitle.append(h6);
            timelineHeading.append(timelineUser);
            timelineUser.append(timelineAvatar);
            timelineAvatar.append(imgPerfil);
            timelineUser.append(timelineUserdata);
            timelineUserdata.append(timelineUsernombre);
            timelineUserdata.append(timelineFecha);
            timelinePanel.append(timelineBody);

            timelineFecha.className = "timeline-horizontal-fecha";
            eventsa.setAttribute('href', "#0");
            $(eventsa).attr('data-date', val.FechaCreacion);
            $(eventsContentli).attr('data-date', val.FechaCreacion);

            if (i == 0) {
                eventsa.className = "selected";
                eventsContentli.className = "selected";
            }

            h6.append(val.AccionTipo + ': ' + nombreCliente);
            imgPerfil.src = "images/Perfil.jpg";
            timelineUsernombre.append(val.NombreUsuario + ' ' + val.ApellidoUsuario);
            timelineFecha.append(val.FechaCreacion);
            var res = val.Descripcion.split(";");

            p.append(res[0]);
            timelineBody.append(p);                
            if (res.length == 2)
            {
                p2.append('Punto de Venta: ' + res[1]);
                timelineBody.append(p2);                
            }


            //res.forEach(function (itemDescripcion) {
             //   p.append(itemDescripcion);
             //   timelineBody.append(p);                
            //});


            //p.append(val.Descripcion);

        });

        triggerTimelineHorizontalScript();
    });
}

function renderTimelineVertical(obj, result) {
    var timelineContainer = $('<div>', { class: 'timeline-container' });
    timelineContainer.appendTo(obj);

    var ul = document.createElement('ul');
    ul.className = "timeline-vertical";
    timelineContainer.append(ul);

    $.each(result.Valores, function (i, val) {
        var li = document.createElement('li');
        var timelineBadge = document.createElement('div');
        var timelineIcon = document.createElement('i');
        var timelinePanel = document.createElement('div');
        var timelineHeading = document.createElement('div');
        var timelineTitle = document.createElement('div');
        var title = document.createElement('h6');
        var timelineUser = document.createElement('div');
        var timelineAvatar = document.createElement('div');
        var avatarImg = document.createElement('img');
        var userData = document.createElement('div');
        var userNombre = document.createElement('div');
        var fecha = document.createElement('small');
        var timelineBody = document.createElement('div');
        var bodyParagraph = document.createElement('p');
        var nombreCliente = val.Cliente;


        timelinePanel.className = "timeline-panel";
        timelineHeading.className = "timeline-heading";
        timelineTitle.className = "timeline-title";
        timelineUser.className = "timeline-user";
        timelineAvatar.className = "timeline-avatar";
        avatarImg.src = "images/Perfil.jpg";
        userData.className = "timeline-userdata";
        userNombre.className = "timeline-userNombre";
        fecha.className = "timeline-fecha";
        timelineBody.className = "timeline-body";

        ul.appendChild(li);

        if (i % 2 === 0) {
            li.className = "";
        }
        else {
            li.className = "timeline-inverted";
        }

        switch (val.AccionTipo) {
            case 'Login': timelineIcon.className = 'icon-vertical fa fa-sign-in';
                timelineBadge.className = 'timelineVBadge badgeLogin';
                break;
            case 'Logout': timelineIcon.className = 'icon-vertical fa fa-sign-out';
                timelineBadge.className = 'timelineVBadge badgeLogout';
                break;
            case 'CheckIn': timelineIcon.className = 'icon-vertical fa fa-check';
                timelineBadge.className = 'timelineVBadge badgeCheckin';
                break;
            case 'CheckOut': timelineIcon.className = 'icon-vertical fa fa-times';
                timelineBadge.className = 'timelineVBadge badgeCheckout';
                break;
            case 'Reporte': timelineIcon.className = 'icon-vertical fa fa-file-text-o';
                timelineBadge.className = 'timelineVBadge badgeReporte';
                break;
            case 'Info': timelineIcon.className = 'icon-vertical fa fa-info-circle';
                timelineBadge.className = 'timelineVBadge badgeInfo';
                break;
        }

        li.append(timelineBadge);
        timelineBadge.append(timelineIcon);
        li.append(timelinePanel);
        timelinePanel.append(timelineHeading);
        timelineHeading.append(timelineTitle);
        timelineTitle.append(title);
        timelineHeading.append(timelineUser);
        timelineUser.append(timelineAvatar);
        timelineAvatar.append(avatarImg);
        timelineUser.append(userData);
        userData.append(userNombre);
        userData.append(fecha);
        timelinePanel.append(timelineBody);
        timelineBody.append(bodyParagraph);

        // panel data 
        title.append(val.AccionTipo + ': ' + nombreCliente);
        userNombre.append(val.NombreUsuario + ' ' + val.ApellidoUsuario);
        fecha.append(val.FechaCreacion);
        bodyParagraph.append(val.Descripcion);
    })
}

function triggerTimelineHorizontalScript() {
    jQuery(document).ready(function ($) {
        var timelines = $('.cd-horizontal-timeline'),
            eventsMinDistance = 120;

        (timelines.length > 0) && initTimeline(timelines);

        function initTimeline(timelines) {
            timelines.each(function () {
                var timeline = $(this),
                    timelineComponents = {};
                //cache timeline components 
                timelineComponents['timelineWrapper'] = timeline.find('.events-wrapper');
                timelineComponents['eventsWrapper'] = timelineComponents['timelineWrapper'].children('.events');
                timelineComponents['fillingLine'] = timelineComponents['eventsWrapper'].children('.filling-line');
                timelineComponents['timelineEvents'] = timelineComponents['eventsWrapper'].find('a');
                timelineComponents['timelineDivs'] = timelineComponents['eventsWrapper'].find('.divnombreTimeline');
                timelineComponents['timelineBadge'] = timelineComponents['eventsWrapper'].find('.timelineHBadge');

                timelineComponents['timelineDates'] = parseDate(timelineComponents['timelineEvents']);
                timelineComponents['eventsMinLapse'] = minLapse(timelineComponents['timelineDates']);
                timelineComponents['timelineNavigation'] = timeline.find('.cd-timeline-navigation');
                timelineComponents['eventsContent'] = timeline.children('.events-content');

                //assign a left postion to the single events along the timeline
                setDatePosition(timelineComponents, eventsMinDistance);

                //assign a width to the timeline
                var timelineTotWidth = setTimelineWidth(timelineComponents, eventsMinDistance);
                //the timeline has been initialize - show it
                timeline.addClass('loaded');

                //detect click on the next arrow
                timelineComponents['timelineNavigation'].on('click', '.next', function (event) {
                    event.preventDefault();
                    updateSlide(timelineComponents, timelineTotWidth, 'next');
                });
                //detect click on the prev arrow
                timelineComponents['timelineNavigation'].on('click', '.prev', function (event) {
                    event.preventDefault();
                    updateSlide(timelineComponents, timelineTotWidth, 'prev');
                });
                //detect click on the a single event - show new event content
                timelineComponents['eventsWrapper'].on('click', 'a', function (event) {
                    event.preventDefault();
                    timelineComponents['timelineEvents'].removeClass('selected');
                    $(this).addClass('selected');
                    updateOlderEvents($(this));
                    updateFilling($(this), timelineComponents['fillingLine'], timelineTotWidth);
                    updateVisibleContent($(this), timelineComponents['eventsContent']);
                });

                //on swipe, show next/prev event content
                timelineComponents['eventsContent'].on('swipeleft', function () {
                    var mq = checkMQ();
                    (mq === 'mobile') && showNewContent(timelineComponents, timelineTotWidth, 'next');
                });
                timelineComponents['eventsContent'].on('swiperight', function () {
                    var mq = checkMQ();
                    (mq === 'mobile') && showNewContent(timelineComponents, timelineTotWidth, 'prev');
                });

                //keyboard navigation
                $(document).keyup(function (event) {
                    if (event.which === '37' && elementInViewport(timeline.get(0))) {
                        showNewContent(timelineComponents, timelineTotWidth, 'prev');
                    } else if (event.which === '39' && elementInViewport(timeline.get(0))) {
                        showNewContent(timelineComponents, timelineTotWidth, 'next');
                    }
                });
            });
        }

        function updateSlide(timelineComponents, timelineTotWidth, string) {
            //retrieve translateX value of timelineComponents['eventsWrapper']
            var translateValue = getTranslateValue(timelineComponents['eventsWrapper']),
                wrapperWidth = Number(timelineComponents['timelineWrapper'].css('width').replace('px', ''));
            //translate the timeline to the left('next')/right('prev') 
            (string == 'next')
                ? translateTimeline(timelineComponents, translateValue - wrapperWidth + eventsMinDistance, wrapperWidth - timelineTotWidth)
                : translateTimeline(timelineComponents, translateValue + wrapperWidth - eventsMinDistance);
        }

        function showNewContent(timelineComponents, timelineTotWidth, string) {
            //go from one event to the next/previous one
            var visibleContent = timelineComponents['eventsContent'].find('.selected'),
                newContent = (string === 'next') ? visibleContent.next() : visibleContent.prev();

            if (newContent.length > 0) { //if there's a next/prev event - show it
                var selectedDate = timelineComponents['eventsWrapper'].find('.selected'),
                    newEvent = (string === 'next') ? selectedDate.parent('li').next('li').children('a') : selectedDate.parent('li').prev('li').children('a');

                updateFilling(newEvent, timelineComponents['fillingLine'], timelineTotWidth);
                updateVisibleContent(newEvent, timelineComponents['eventsContent']);
                newEvent.addClass('selected');
                selectedDate.removeClass('selected');
                updateOlderEvents(newEvent);
                updateTimelinePosition(string, newEvent, timelineComponents);
            }
        }

        function updateTimelinePosition(string, event, timelineComponents) {
            //translate timeline to the left/right according to the position of the selected event
            var eventStyle = window.getComputedStyle(event.get(0), null),
                eventLeft = Number(eventStyle.getPropertyValue("left").replace('px', '')),
                timelineWidth = Number(timelineComponents['timelineWrapper'].css('width').replace('px', '')),
                timelineTotWidth = Number(timelineComponents['eventsWrapper'].css('width').replace('px', ''));
            var timelineTranslate = getTranslateValue(timelineComponents['eventsWrapper']);

            if ((string === 'next' && eventLeft > timelineWidth - timelineTranslate) || (string === 'prev' && eventLeft < -timelineTranslate)) {
                translateTimeline(timelineComponents, -eventLeft + timelineWidth / 2, timelineWidth - timelineTotWidth);
            }
        }

        function translateTimeline(timelineComponents, value, totWidth) {
            var eventsWrapper = timelineComponents['eventsWrapper'].get(0);
            value = (value > 0) ? 0 : value; //only negative translate value
            value = (!(typeof totWidth === 'undefined') && value < totWidth) ? totWidth : value; //do not translate more than timeline width
            setTransformValue(eventsWrapper, 'translateX', value + 'px');
            //update navigation arrows visibility
            (value === 0) ? timelineComponents['timelineNavigation'].find('.prev').addClass('inactive') : timelineComponents['timelineNavigation'].find('.prev').removeClass('inactive');
            (value === totWidth) ? timelineComponents['timelineNavigation'].find('.next').addClass('inactive') : timelineComponents['timelineNavigation'].find('.next').removeClass('inactive');
        }

        function updateFilling(selectedEvent, filling, totWidth) {
            //change .filling-line length according to the selected event
            var eventStyle = window.getComputedStyle(selectedEvent.get(0), null),
                eventLeft = eventStyle.getPropertyValue("left"),
                eventWidth = eventStyle.getPropertyValue("width");
            eventLeft = Number(eventLeft.replace('px', '')) + Number(eventWidth.replace('px', '')) / 2;
            var scaleValue = eventLeft / totWidth;
            setTransformValue(filling.get(0), 'scaleX', scaleValue);
        }

        function setDatePosition(timelineComponents, min) {
            //for (var i = 0; i < timelineComponents['timelineDates'].length; i++) {
            //    var distance = daydiff(timelineComponents['timelineDates'][0], timelineComponents['timelineDates'][i]),
            //        distanceNorm = Math.round(distance / timelineComponents['eventsMinLapse']) + 2;
            //    timelineComponents['timelineEvents'].eq(i).css('left', distanceNorm * min - 220 + 'px');
            //    timelineComponents['timelineDivs'].eq(i).css('left', distanceNorm * min - 210 + 'px');

            //}
            var distprev = 0;
            var distnew = 0;

            for (var i = 0; i < timelineComponents['timelineDates'].length; i++) {
                var distance = Math.abs(daydiff(timelineComponents['timelineDates'][0], timelineComponents['timelineDates'][i])),
                distanceNorm = Math.round(distance / timelineComponents['eventsMinLapse']) + 2;
                distnew = distprev + 120;
                timelineComponents['timelineEvents'].eq(i).css('left', distnew - 100 + 'px');
                timelineComponents['timelineDivs'].eq(i).css('left', distnew - 105 + 'px');
                timelineComponents['timelineBadge'].eq(i).css('left', distnew - 65 + 'px');

                distprev = distnew;
            }
        }

        function setTimelineWidth(timelineComponents, width) {
            var timeSpan = daydiff(timelineComponents['timelineDates'][0], timelineComponents['timelineDates'][timelineComponents['timelineDates'].length - 1]),
                timeSpanNorm = timeSpan / timelineComponents['eventsMinLapse'],
                timeSpanNorm = Math.round(timeSpanNorm) + 4,
                //totalWidth = timeSpanNorm * width;
                //totalWidth = (timelineComponents['timelineDates'].length * 100) + 220;
                totalWidth = (timelineComponents['timelineDates'].length * eventsMinDistance) + 220;

            timelineComponents['eventsWrapper'].css('width', totalWidth + 'px');
            updateFilling(timelineComponents['eventsWrapper'].find('a.selected'), timelineComponents['fillingLine'], totalWidth);
            updateTimelinePosition('next', timelineComponents['eventsWrapper'].find('a.selected'), timelineComponents);

            return totalWidth;
        }

        function updateVisibleContent(event, eventsContent) {
            var eventDate = event.data('date'),
                visibleContent = eventsContent.find('.selected'),
                selectedContent = eventsContent.find('[data-date="' + eventDate + '"]'),
                selectedContentHeight = selectedContent.height();

            //var eventDate = event.data('date');
            //var visibleContent = eventsContent.find('.selected');
            //var selectedContent = eventsContent.find('[date="' + eventDate + '"]');
            //var selectedContentHeight = selectedContent.height();

            if (selectedContent.index() > visibleContent.index()) {
                var classEnetering = 'selected enter-right',
                    classLeaving = 'leave-left';
            } else {
                var classEnetering = 'selected enter-left',
                    classLeaving = 'leave-right';
            }

            selectedContent.attr('class', classEnetering);
            visibleContent.attr('class', classLeaving).one('webkitAnimationEnd oanimationend msAnimationEnd animationend', function () {
                visibleContent.removeClass('leave-right leave-left');
                selectedContent.removeClass('enter-left enter-right');
            });
            eventsContent.css('height', selectedContentHeight + 'px');
        }

        function updateOlderEvents(event) {
            event.parent('li').prevAll('li').children('a').addClass('older-event').end().end().nextAll('li').children('a').removeClass('older-event');
        }

        function getTranslateValue(timeline) {
            var timelineStyle = window.getComputedStyle(timeline.get(0), null),
                timelineTranslate = timelineStyle.getPropertyValue("-webkit-transform") ||
                    timelineStyle.getPropertyValue("-moz-transform") ||
                    timelineStyle.getPropertyValue("-ms-transform") ||
                    timelineStyle.getPropertyValue("-o-transform") ||
                    timelineStyle.getPropertyValue("transform");

            if (timelineTranslate.indexOf('(') >= 0) {
                var timelineTranslate = timelineTranslate.split('(')[1];
                timelineTranslate = timelineTranslate.split(')')[0];
                timelineTranslate = timelineTranslate.split(',');
                var translateValue = timelineTranslate[4];
            } else {
                var translateValue = 0;
            }

            return Number(translateValue);
        }

        function setTransformValue(element, property, value) {
            element.style["-webkit-transform"] = property + "(" + value + ")";
            element.style["-moz-transform"] = property + "(" + value + ")";
            element.style["-ms-transform"] = property + "(" + value + ")";
            element.style["-o-transform"] = property + "(" + value + ")";
            element.style["transform"] = property + "(" + value + ")";
        }

        
        function parseDate(events) {
            var dateArrays = [];
            events.each(function () {
                var singleDate = $(this),
                    dateComp = singleDate.data('date').split('T');
                if (dateComp.length > 1) { //both DD/MM/YEAR and time are provided
                    var dayComp = dateComp[0].split('/'),
                        timeComp = dateComp[1].split(':');
                } else if (dateComp[0].indexOf(':') >= 0) { //only time is provide
                    var dayComp = ["2000", "0", "0"],
                        timeComp = dateComp[0].split(':');
                } else { //only DD/MM/YEAR
                    var dayComp = dateComp[0].split('/'),
                        timeComp = ["0", "0"];
                }
                var newDate = new Date(dayComp[2], dayComp[1] - 1, dayComp[0], timeComp[0], timeComp[1]);
                dateArrays.push(newDate);
            });
            return dateArrays;
        }

        function daydiff(first, second) {
            return Math.round((second - first));
        }

        function minLapse(dates) {
            var dateDistances = [];
            for (var i = 1; i < dates.length; i++) {
                var distance = daydiff(dates[i - 1], dates[i]);
                dateDistances.push(distance);
            }
            return Math.min.apply(null, dateDistances);
        }

        function elementInViewport(el) {
            var top = el.offsetTop;
            var left = el.offsetLeft;
            var width = el.offsetWidth;
            var height = el.offsetHeight;

            while (el.offsetParent) {
                el = el.offsetParent;
                top += el.offsetTop;
                left += el.offsetLeft;
            }

            return (
                top < (window.pageYOffset + window.innerHeight) &&
                left < (window.pageXOffset + window.innerWidth) &&
                (top + height) > window.pageYOffset &&
                (left + width) > window.pageXOffset
            );
        }

        function checkMQ() {
            return window.getComputedStyle(document.querySelector('.cd-horizontal-timeline'), '::before').getPropertyValue('content').replace(/'/g, "").replace(/"/g, "");
        }
    });
}
