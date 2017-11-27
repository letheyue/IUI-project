$(document).ready(function() {

    var $body = $('tbody');

    $body.on('click', "[id^='td_']", function (event) {
        var field_name = this.id.substring(3);
        if(field_name === 'restaurants_per_page') {
            $(this).replaceWith("<select name=\"preference["+field_name+"]\" id=\"s-preference_"+field_name+"\"><option value=\"5\">5</option>\n" +
                "<option value=\"10\">10</option>\n" +
                "<option value=\"15\">15</option>\n" +
                "<option value=\"All\">All</option></select>");
        } else {
            $(this).replaceWith("<input type=\"hidden\" name=\"preference["+field_name+"]\" value=\"\" />" +
                "<span><label for=\"preference_"+field_name+"_1\"><input type=\"radio\" value=\"1\" name=\"preference["+field_name+"]\" id=\"preference_"+field_name+"_1\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+field_name+"_1\">Not important</label></label></span>" +
                "<span><label for=\"preference_"+field_name+"_2\"><input type=\"radio\" value=\"2\" name=\"preference["+field_name+"]\" id=\"preference_"+field_name+"_2\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+field_name+"_2\">Don&#39;t mind</label></label></span>" +
                "<span><label for=\"preference_"+field_name+"_3\"><input type=\"radio\" value=\"3\" name=\"preference["+field_name+"]\" id=\"preference_"+field_name+"_3\" />" +
                "<label class=\"collection_radio_buttons\" for=\"preference_"+field_name+"_3\">Important</label></label></span>");
        }
        $('#submit').removeClass('hide');
    });

    $body.on('click', "[id^='tdd_']", function (e) {
        var field_name = this.id.substring(4);
        $(this).replaceWith("<input type=\"hidden\" name=\"preference["+field_name+"]\" value=\"\" />" +
            "<span><label for=\"preference_"+field_name+"_true\"><input type=\"radio\" value=\"true\" name=\"preference["+field_name+"]\" id=\"preference_"+field_name+"_true\" />" +
            "<label class=\"collection_radio_buttons\" for=\"preference_"+field_name+"_true\">Yes</label></label></span>" +
            "<span><label for=\"preference_"+field_name+"_false\"><input type=\"radio\" value=\"false\" name=\"preference["+field_name+"]\" id=\"preference_"+field_name+"_false\" />" +
            "<label class=\"collection_radio_buttons\" for=\"preference_"+field_name+"_false\">No</label></label></span>");
        $('#submit').removeClass('hide');
    });


    // If completely no-refreshing of page is desired, Vue/Angular is needed.
    $('#pform').submit(function (e) {
        var update_url = $('#pform')[0].action;
        var checked_radios = $('[id^=preference]:checked');
        var selected_rests = $('[id^=s-preference]');
        var local_data = {};
        local_data['preference'] = {};
        for(i=0; i<checked_radios.length; i++) {
            local_data['preference'][checked_radios[i].name.substring(checked_radios[i].name.lastIndexOf('[')+1, checked_radios[i].name.lastIndexOf(']'))] = checked_radios[i].value;
        }

        for(i=0; i<selected_rests.length; i++) {
            local_data['preference'][selected_rests[i].name.substring(selected_rests[i].name.lastIndexOf('[')+1, selected_rests[i].name.lastIndexOf(']'))] = selected_rests[i].value;
        }

        $.ajax({
            url: update_url,
            type: 'PUT',
            data: local_data
        }).done(function(data) {
            // If Vue is applied, then this page can update with static refreshing
        });
        e.preventDefault();
        e.stopPropagation();
    });


});