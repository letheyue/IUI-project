$(document).ready(function() {
    var slideIndex = 1;
    for(var k = 0; k < 5; k++) {
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
        var name = "slides" + id
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

});