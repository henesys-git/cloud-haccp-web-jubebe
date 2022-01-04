function addMethod(object, name, fn) {
    var old = object[ name ];
    object[ name ] = function() {
        if(fn.length == arguments.length) {
            return fn.apply(this, arguments);
        } else if(typeof old == 'function') {
            return old.apply(this, arguments);
        }
    }
}

function fn_MainInfo_List() {
    addMethod(this, "display", function(url, custCode, jspPage) {
        var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
        var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');

        $.ajax({
            type: "POST",
            url: url, 
            data: "custcode=" + custCode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + jspPage,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    });

    addMethod(this, "display", function(url, custCode, startDate, endDate, jspPage) {
        $.ajax({
            type: "POST",
            url: url, 
            data: "custcode=" + custCode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + jspPage,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    });
}

function clearList() {
    
}