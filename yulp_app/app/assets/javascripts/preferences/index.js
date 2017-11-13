$(document).ready(function() {

    var $create = $('#button-create');


    if ($("[id^=preference]").length) {
        $create.attr({
            disabled: true
        })
    } else {
        $('#button-delete').attr({
            disabled: true
        })
    }

    $('[id^=button-]').click(function (e) {
        if ($(this).attr("disabled")) {
            e.preventDefault();
        }
    })



});