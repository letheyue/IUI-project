$(document).ready(function() {


    $('tbody').on('click', "[id^='td_']", function (event) {
        var name = this.id.substring(3);
        $(this).replaceWith("<input type=\"hidden\" name=\"preference["+name+"]\" value=\"\" />" +
            "<span><label for=\"preference_"+name+"_1\"><input type=\"radio\" value=\"1\" name=\"preference["+name+"]\" id=\"preference_"+name+"_1\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+name+"_1\">Not important</label></label></span>" +
            "<span><label for=\"preference_"+name+"_2\"><input type=\"radio\" value=\"2\" name=\"preference["+name+"]\" id=\"preference_"+name+"_2\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+name+"_2\">Don&#39;t mind</label></label></span>" +
            "<span><label for=\"preference_"+name+"_3\"><input type=\"radio\" value=\"3\" name=\"preference["+name+"]\" id=\"preference_"+name+"_3\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+name+"_3\">Important</label></label></span>")
        $('#submit').removeClass('hide');
    });


    // If completely no-refreshing of page is desired, Vue/Angular is needed.
    $('#pform').submit(function (e) {
        var update_url = $('#pform')[0].action;
        var checked = $('[id^=preference]:checked');
        var local_data = {};
        local_data['preference'] = {};
        for(i=0; i<checked.length; i++) {
            local_data['preference'][checked[i].name.substring(checked[i].name.lastIndexOf('[')+1, checked[i].name.lastIndexOf(']'))] = checked[i].value;
        }

        $.ajax({
            url: update_url,
            type: 'PUT',
            data: local_data
        });
        e.preventDefault();
        e.stopPropagation();
    });


});