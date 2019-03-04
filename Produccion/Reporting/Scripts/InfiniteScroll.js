 $(window).scroll(ulScrollHandler);

var page = 0,
    inCallback = false,
    hasReachedEndOfInfiniteScroll = false;

var ulScrollHandler = function () {
    var _windowHeight = window.innerHeight       //Modern Browsers (Chrome, Firefox)
    || document.documentElement.clientHeight //Modern IE, including IE11
    || document.body.clientHeight;           //Old IE, 6,7,8

    var _scrollPos = window.scrollY              //Modern Browsers (Chrome, Firefox)
        || window.pageYOffset                    //Modern IE, including IE11
        || document.documentElement.scrollTop    //Old IE, 6,7,8

    var offScroll = document.body.offsetHeight - (_windowHeight + _scrollPos);

    if (hasReachedEndOfInfiniteScroll == false && offScroll <= 150) {
        loadMoreToInfiniteScrollUl(false);
    }
}

function loadMoreToInfiniteScrollUl(initPages) {
    if (initPages)
        page = 0;

    if (page > -1 && !inCallback) {
        inCallback = true;
        page++;
        $("#loading").show();
        $.ajax({
            type: 'POST',
            url: urlGetFotosThumb,
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                pageNum: page
            }),
            success: function (data, textstatus) {

                if (data != '') {
                    $('.nohayfotos').hide();
                    $('#imagenes').append(data);
                }
                else {
                    page = -1;
                    var cantFotos = $('#imagenes').find('img');

                    if (cantFotos.length === 0) {
                        $('.nohayfotos').show();
                    }
                }

                inCallback = false;
                $("#loading").hide();
            }
        });
    }
}

function showNoMoreRecords() {
    hasReachedEndOfInfiniteScroll = true;
}