<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "javax.servlet.http.HttpSession"%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Scheduled Meeting</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">


<style>
#searchoptions {
    margin-top: 60px;
    text-align: center;
    font-size: 50px;
}

#map {
    height: 400px;
    width: 90%;
    margin: auto auto;
}

.centerme {
    margin: auto auto;
    width: 80%;
}

#mapsection {
    padding-top: 40px;
    padding-bottom: 30px;
}

#directionsSearch {
    margin: 20px auto;
    width: 200px;
}

button:focus {
    outline: none !important;
}

.btn-disabled {
    opacity: 0.5;
}

.fader {
    -webkit-transition: .6s;
    transition: .6s;
}

.btn:hover {
    cursor: pointer;
}

.btn-lg:hover {
    cursor: pointer;
}

.row {
    text-align: center;
}
</style> 

    <script> 

		var query = location.search.split("meetingName=")[1]; 
		var name = query.replace('%20', ' ');
				
		query = name.replace(' ', '+'); 
		console.log("meeting name is " + name); 
		
		var xhttp = new XMLHttpRequest(); 
		
		xhttp.open("POST", "queryMeeting?meetingName=" + query + "&sentFrom=meeting", false); 
		console.log("Sent parameter for meeting: " + query);
		xhttp.send();  //if you get to this line, then you have gotten a response 
		

	</script>


</head>
<body>
    <nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
        <a href="#" class="navbar-brand">When and Where</a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav ml-auto">
                <li class="navbar-item">
                    <a href="#" class="nav-link">Profile</a>
                </li>
                <li class="navbar-item">
                    <a href="#" class="nav-link">Settings</a>
                </li>
                <li class="navbar-item">
                    <a href="#" class="nav-link">Logout</a>
                </li>
            </ul>
        </div>
    </nav>
    <!-- .container-fluid -->
    <div class = "container-fluid" id = "map"></div>
    
    <div class = "container-fluid" id = "title"></div>
    <script>	document.getElementById("title").innerHTML = location.search.split("meetingName=")[1].replace('%20', ' ');</script>
    
    <div class = "container" id = "details"></div>
    <div class = "container" id="lyft-web-button-parent"></div>
    
    <!-- Directions -->
    <button type="button" class="btn-lg btn-primary fader" href="#" id="directionsSearch" title="Click to toggle">Get Directions</button>
    <div class = "container" id = "directions" style = "display:none"></div>
        
    <!-- Meeting Info -->
    <%String details = (String) request.getSession().getAttribute("locationName"); %>
	<%String locationName = (String) request.getSession().getAttribute("locationName");%>	
	
    <div class = "container" id = "meetingDetails"><%=details%></div>
	<div id = "placeName" type = "hidden"><%=locationName %></div>
   
    <script>
		console.log("meeting data:\n" + document.getElementById("meetingDetails").innerHTML);
		console.log("location name:\n" + document.getElementById("placeName").value);  
    </script>
    

    <!-- Directions Info -->
    <div id = "address" type = "hidden"></div>
    <div id = "destLat" type = "hidden"></div>
    <div id = "destLng" type = "hidden"></div>
    
    <script type="text/javascript">
    //====================================== Directions ===================================================
    
    document.getElementById("directionsSearch").onclick = function() {
       
        var directionsDisplay = new google.maps.DirectionsRenderer;
        var directionsService = new google.maps.DirectionsService;
        
        directionsDisplay.setMap(map);
        directionsDisplay.setPanel(document.getElementById('directions'));
        
        calculateAndDisplayRoute(directionsService, directionsDisplay);
       	
        function calculateAndDisplayRoute(directionsService, directionsDisplay) {
        		console.log("getting directions");
        		var pos; 
            var end = document.getElementById("address").value;
            
            console.log(end);
            
            directionsService.route({
              origin: {
            	  	lat: 34.0224,
            	  	lng: -118.2851
              },
              destination: end,
              travelMode: 'DRIVING'
            }, function(response, status) {
              if (status === 'OK') {
                directionsDisplay.setDirections(response);
              } else {
                window.alert('Directions request failed due to ' + status);
              }
            });
          }
        
        document.getElementById("directions").style.display = "block";

    }
    //====================================== Lyft ===================================================
  	var destLat = document.getElementById('destLat').value; 
  	var destLng = document.getElementById('destLng').value; 

    var OPTIONS = {
    	      scriptSrc: 'lyftWebButton.js',
    	      namespace: '',
    	      clientId: '',
    	      clientToken: '',
    	      location: {
    	        pickup: {},
    	        destination: {
    	          latitude: '37.7604',
    	          longitude: '-122.4132',
    	        },
    	      },
    	      parentElement: document.getElementById('lyft-web-button-parent'),
    	      queryParams: {
    	        credits: ''
    	      },
    	      theme: 'multicolor large',
    	    };
    	    (function(options) {
    	      var window = this.window;
    	      var document = this.document;
    	      window.lyftInstanceIndex = window.lyftInstanceIndex || 0;
    	      var parentElement = options.parentElement;
    	      var scriptElement = document.createElement('script');
    	      scriptElement.async = true;
    	      scriptElement.onload = function() {
    	        window.lyftInstanceIndex++;
    	        var instanceName = options.namespace ? ('lyftWebButton' + options.namespace + window.lyftInstanceIndex) : 'lyftWebButton' + window.lyftInstanceIndex;
    	        window[instanceName] = window['lyftWebButton'];
    	        options.objectName = instanceName
    	        window[instanceName].initialize(options);
    	      };
    	      scriptElement.src = options.scriptSrc;
    	      parentElement.insertBefore(scriptElement, parentElement.childNodes[0]);
    	    }).call(this, OPTIONS);


    //====================================== Creating a Map ===================================================

    var map;
	var tempAddy = document.getElementById("placeName").innerHTML; 
	
	var addy = tempAddy.split('%20').join('+');
	var marker; 
	
    	var service;
    var infowindow;

    function initialize() {

      var usc = new google.maps.LatLng(34.0224,-118.2851);

      map = new google.maps.Map(document.getElementById('map'), {
          center: usc,
          zoom: 15
        });
      
      
     
      console.log("Address: " + addy); 

      var request = {
        location: usc,
        radius: '50000',
        keyword: addy,
        rankby: 'distance', 
        key: 'AIzaSyCDV9Wi54vI3fIhOxEBHJDokoiEMAiLGu8'
      };

      service = new google.maps.places.PlacesService(map);
      service.nearbySearch(request, callback);
    }

    function callback(results, status) {
    	var latLng; 
      if (status == google.maps.places.PlacesServiceStatus.OK) {
    	    marker = new google.maps.Marker({
    	        map: map,
    	        place: {
    	          placeId: results[0].place_id,
    	          location: results[0].geometry.location
    	        }
    	    
    	      });
    	    latLng = marker.place.location; 
    	    map.setCenter(latLng);
      }
     
      var request = {
    		  placeId: marker.place.placeId 
    		};
      
      service.getDetails(request, detailsCallback);
      
      function detailsCallback(place, status) {
    	  	console.log("Entered callback for details"); 
    	  	if (status == google.maps.places.PlacesServiceStatus.OK) {
    	  		sessionStorage.placeName = place.name; 
    	  		
    			document.getElementById('address').value = place.vicinity; 
    			document.getElementById('destLat').value = place.geometry.location.lat; 
    			document.getElementById('destLng').value = place.geometry.location.lng; 
    			console.log("first name part: " + place.name);
			var query = place.name; 
			console.log("sending id query " + query);
    	    		document.getElementById('details').innerHTML += "Location: " + "<a href=\"Location.jsp?VAR=" + query + "\">" + place.name + "</a></br>";
    	    		document.getElementById('details').innerHTML += "Address: " + place.vicinity + "</br>";
    	    		document.getElementById('details').innerHTML += "ID: " + place.id + "</br>";
    	    		console.log("Address name: " + place.name.replace(' ', '+') + "\n" + "Address ID: " + place.place_id); 
    	    		
    	  	}
      }		
    }
        
    </script>
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCDV9Wi54vI3fIhOxEBHJDokoiEMAiLGu8&libraries=places&callback=initialize"></script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</body>
</html>
