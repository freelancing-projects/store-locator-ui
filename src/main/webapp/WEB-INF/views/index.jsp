
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<html>

<head>

<meta name="viewport" content="initial-scale=1.0, user-scalable=no">

<meta charset="utf-8">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<script src="./resources/js/distance.js"></script>

<script
	src="https://maps.googleapis.com/maps/api/js?v=3.11&key=AIzaSyACowyhqChRBi1XCrVqEFDOrBGmsgvXd-Q&sensor=false"
	type="text/javascript"></script>

<script type="text/javascript" src="./resources/js/stores.json"></script>

<style>

/* Always set the map height explicitly to define the size of the div

* element that contains the map. */
#map {
	height: 100%;
}

/* Optional: Makes the sample page fill the window. */
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}
</style>

<script>

var myStores = JSON.parse(stores);

var myTable = $("#myTable");

 

function getLatLongFromZip(){

       var zip = $("#StoreSearch_ZIP").val();

       var radius = $("#radius").val();

       if(zip != null){   

              $.get("https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyACowyhqChRBi1XCrVqEFDOrBGmsgvXd-Q&address="+zip+" NL", function( data ) {

                          

                           var lat  = data.results[0].geometry.location.lat;

                           var lng = data.results[0].geometry.location.lng;

                           var url = "http://localhost:9090/store-locator-ui/showAddress?lat="+ lat + "&lng=" + lng + "&radius=" + radius ;

                           $.ajax({

                                  type : "POST",

                                  url : url,

                                  data : "",

                                  async : false,

                                  success : function(result) {

                                         var jsonData = JSON.parse(result);

                                         var latlng = new Array();

                                        

                                         $('#myTable tbody').html('');

                                         for (var i = 0; i < jsonData.locations.length; i++) {

                                                       var row = "<tr><td>" + (i + 1) + "</td><td>"

                                                                     + jsonData.locations[i].address + "</td><td>"

                                                                     + jsonData.locations[i].lat + " , "

                                                                     + jsonData.locations[i].lng + "</td><td>"

                                                                     + jsonData.locations[i].distance + "KM" + "</td></tr>"

                                                       $("#myTable tbody").append(row);

                                                }

                                        

                                         console.log(jsonData.locations);

                                         showMap(jsonData.locations);

                                        

                                  },

                                  error : function(e) {

                                         console.log("ERROR: ", e);

                                  },

                                  done : function(e) {

                                         console.log("DONE");

                                  }

 

                           });

                          

                    

              });

       }

}

function showMap(locations){

       var map = new google.maps.Map(document.getElementById('map'), {

      zoom: 10,

      center: new google.maps.LatLng(52.336693, 5.231883),

      mapTypeId: google.maps.MapTypeId.ROADMAP

    });

 

    var infowindow = new google.maps.InfoWindow();

 

    var marker, i;

 

    for (i = 0; i < locations.length; i++) {

      marker = new google.maps.Marker({

        position: new google.maps.LatLng(locations[i].lat, locations[i].lng),

        map: map

      });

 

      google.maps.event.addListener(marker, 'click', (function(marker, i) {

        return function() {

          infowindow.setContent(locations[i].address);

          infowindow.open(map, marker);

        }

      })(marker, i));

    }

}

 

function toggleBounce() {

        if (marker.getAnimation() !== null) {

          marker.setAnimation(null);

        } else {

          marker.setAnimation(google.maps.Animation.BOUNCE);

        }

      }

</script>

<style>
.center {
	margin: auto;
	border: 3px solid green;
	padding: 10px;
}
</style>

</head>

<body>



	<div class="center">

		<input type="text" placeholder="Enter the zip code" class="center"
			name="StoreSearch_ZIP" id="StoreSearch_ZIP" value=""
			autocomplete="off"> <select name="radius" class="center"
			id="radius">

			<option name="400" value="400">All</option>

			<option name="5" value="5" selected="selected">5 km</option>

			<option name="10" value="10">10 km</option>

			<option name="25" value="25">25 km</option>

			<option name="50" value="50">50 km</option>

		</select> <input type="submit" id="searchStore" class="center" name="Search"
			value="Search" align="right" onclick="getLatLongFromZip();">





		<table id="myTable" border="1" class="center">



			<thead>

				<tr>

					<th>Sr. No.</th>

					<th>Address</th>

					<th>Lat,Long</th>

					<th>Distance</th>

				</tr>

			</thead>

			<tbody></tbody>



		</table>



	</div>

	<div id="map"></div>





</body>

</html>