$(document).ready(function() {
    var slideIndex = 1;
    var per_page = parseInt( $('[id^=pre_]').attr('id').substring(4) );
    for(var k = 0; k < per_page; k++) {
        showSlides(slideIndex, k);
    }

    function plusSlides(n, id) {
        showSlides(slideIndex += n, id);
    }

    function currentSlide(n, id) {
        showSlides(slideIndex = n, id);
    }

    function showSlides(n, id) {
        var i;
        var name = "slides" + id;
        var slides = document.getElementsByName(name);
        if (n > slides.length) {slideIndex = 1}
        if (n < 1) {slideIndex = slides.length}
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }

        slides[slideIndex-1].style.display = "block";
    }

    $('.prev').click(function (e) {
        plusSlides(-1, this.classList[1]);
        e.stopPropagation();
    });
    $('.next').click(function (e) {
        plusSlides(1, this.classList[1]);
        e.stopPropagation();
    });


    // When the user clicks on the button, scroll to the top of the document
    $('.scrlBtn').click(function(){topFunction()});



    // Feedback Submit
    $('#show').click(function (e) {
        var $modal = $(this).next();
        $modal.modal('show');
    });
    $('#feed_form').submit(function (e) {
        var local_data = {};
        var update_url = $('#feed_form')[0].action;
        var subject = $('#Subject').val();
        var content = $('#Content').val();
        local_data['subject'] = subject;
        local_data['content'] = content;

        $.ajax({
            url: update_url,
            type: 'POST',
            data: local_data
        }).done(function(data) {
            // If Vue is applied, then this page can update with static refreshing
            $('#show').next().modal('hide');
            $('#feedback-info').removeClass('hide');
            topFunction();
        });
        e.preventDefault();
        e.stopPropagation();
        console.log(e)
    })



});

function topFunction() {
    document.body.scrollTop = 0; // For Chrome, Safari and Opera
    document.documentElement.scrollTop = 0; // For IE and Firefox
}

