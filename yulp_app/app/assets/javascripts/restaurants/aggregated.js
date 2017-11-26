var customLabel = {
    restaurant: {
        label: 'R'
    },
    bar: {
        label: 'B'
    }
};

var clickedMarker = null;
var pin = null;

function initMap() {
    var map = new google.maps.Map(document.getElementById('map'), {
        center: new google.maps.LatLng(30.6280, -96.3344),
        zoom: 12
    });
    var infoWindow = new google.maps.InfoWindow;
    var sv = new google.maps.StreetViewService();

    // Change this depending on the name of your PHP or XML file
    // The callback(request) is function(data) here
    // Notice that the reason why write as function(data) is due to function downloadUrl allows this format
    downloadUrl('', function(data) {
        var xml = data.responseXML;
        var markers = xml.documentElement.getElementsByTagName('marker');
        Array.prototype.forEach.call(markers, function(markerElem) {
            var id = markerElem.getAttribute('id');
            var name = markerElem.getAttribute('name');
            var address = markerElem.getAttribute('address');
            var type = markerElem.getAttribute('type');
            var point = new google.maps.LatLng(
                parseFloat(markerElem.getAttribute('lat')),
                parseFloat(markerElem.getAttribute('lng')));

            var infowincontent = document.createElement('div');
            var strong = document.createElement('strong');
            strong.textContent = name;
            infowincontent.appendChild(strong);
            infowincontent.appendChild(document.createElement('br'));

            var streetview = document.createElement('div');
            streetview.style.width = "200px";
            streetview.style.height = "200px";
            infowincontent.appendChild(streetview);

            var label = document.createElement('div');
            label.className = 'hide';
            label.id = 'marker'+id;

            var text = document.createElement('text');
            text.textContent = address;
            infowincontent.appendChild(text);

            infowincontent.appendChild(label);

            var icon = customLabel[type] || {};
            var marker = new google.maps.Marker({
                map: map,
                position: point,
                label: icon.label
            });
            marker.addListener('click', function() {
                clickedMarker = marker;
                sv.getPanoramaByLocation(marker.getPosition(), 50, processSVData);
                pin = new google.maps.MVCObject();

                google.maps.event.addListenerOnce(infoWindow, "domready", function() {
                    panorama = new google.maps.StreetViewPanorama(streetview, {
                        navigationControl: false,
                        enableCloseButton: false,
                        addressControl: false,
                        linksControl: false,
                        visible: true
                    });
                    panorama.bindTo("position", pin);
                });

                var captionId = 'rest_' + infowincontent.children[4].id.substring(6);
                $('[id^=rest_]').addClass('hide');

                var $caption = $('#caption');
                $caption.html($('#' + captionId).clone()[0]);
                $caption.children().removeClass('hide');
                $caption.children().prop("id", "captionDiv");


                infoWindow.setContent(infowincontent);
                infoWindow.open(map, marker);
            });
        });
    });
}

function processSVData(data, status) {
    if (status === google.maps.StreetViewStatus.OK) {
        if (!!panorama && !!panorama.setPano) {

            panorama.setPano(data.location.pano);
            panorama.setPov({
                heading: 270,
                pitch: 0,
                zoom: 1
            });
            panorama.setVisible(true);

            google.maps.event.addListener(clickedMarker, 'click', function() {

                var markerPanoID = data.location.pano;
                // Set the Pano to use the passed panoID
                panorama.setPano(markerPanoID);
                panorama.setPov({
                    heading: 270,
                    pitch: 0,
                    zoom: 1
                });
                panorama.setVisible(true);
            });
        }
    } else {
        panorama.setVisible(false);
        // alert("Street View data not found for this location.");
    }
}

// Asyn exe by default. This function will RUN callback(request) and return request.status when request is loaded
function downloadUrl(url, callback) {
    var request = window.ActiveXObject ?
        new ActiveXObject('Microsoft.XMLHTTP') :
        new XMLHttpRequest;

    request.onreadystatechange = function() {
        if (request.readyState === 4) {
            request.onreadystatechange = doNothing;
            callback(request, request.status);
        }
    };

    request.open('GET', "/test.xml", true);
    request.send(null);
    console.log(request)
}

function doNothing() {}
