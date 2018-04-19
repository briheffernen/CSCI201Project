<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "javax.servlet.http.HttpSession"%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type refresh" content="text/html; charset=UTF-8">
<title>Scheduled Meeting</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>


<style>

#title {
	font-family: Arial, Helvetica, sans-serif	;
	font-size: 28pt; 	
	font-weight: bold; 
}

#map {
    height: 400px;
    width: 90%;
    margin: auto auto;
    float: left; 
}

#mapsection {
    padding-top: 40px;
    padding-bottom: 30px;
}


#directionsSearch {
    float: left; 
}

#details {
	text-align: center; 
}

#meetingDetails {
	text-align: left; 
}

button:focus {
    outline: none !important;
}

.btn {
	float: left; 

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

#accordion {
    height: 400px;
    width: 90%;
}

.row {
    text-align: center;
}

.lyft-web-button.large > .cta-eta > .eta {
  font-size: 20px;
}
.lyft-web-button.large > .arrow-icon {
  margin-left: 20px;
}
.lyft-web-button.large > .price-range {
  font-size: 20px;
}
.lyft-web-button.large > .lyft-logo > svg {
  width: 55px; /* fix svg rendering for IE */
  height: 40px; /* fix svg rendering for IE */
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
		
		window.onload = function() {
		    if(!window.location.hash) {


		        window.location = window.location + '#loaded';
		        window.location.reload();
		    }
		}

	</script>


</head>
<body>
    <nav class="navbar navbar-light bg-light navbar-expand-sm">
		<a href="/Final_Project/homepage.jsp" class="navbar-brand"><img src = "WhenWhereLogo.png" style="width:100px;height:50px;"></a>
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
    <!-- Meeting Info -->
    <%String time = (String) request.getSession().getAttribute("time"); %>
	<%String users = (String) request.getSession().getAttribute("users"); %>
	<%String teams = (String) request.getSession().getAttribute("teams"); %>
	
	<%String locationName = (String) request.getSession().getAttribute("locationName");%>	
    
    <!-- .container-fluid -->
    <div class = "container-fluid" id = "container">
    		<div class = "row">
    		     <div class = "col-lg-12" id = "title"></div>
    		</div>
    		<div class = "row">    			
    			<div class = "col-lg-12" id = "details"></div>
    		</div>
    		<div class = "row">
    			<div class = "col-lg-6" id = "map"></div>
			<div class = "col-lg-6" id="accordion">
			  <div class="card">
			    <div class="card-header" id="headingOne">
			      <h5 class="mb-0">
			        <button class="btn btn-link" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
			          Meeting Time
			        </button>
			      </h5>
			    </div>
			
			    <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordion">
			      <div class="card-body"><%=time %></div>
			    </div>
			  </div>
			  <div class="card">
			    <div class="card-header" id="headingTwo">
			      <h5 class="mb-0">
			        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
			          Other Users
			        </button>
			      </h5>
			    </div>
			    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordion">
			      <div class="card-body"><%=users %></div>
			    </div>
			  </div>
			  <div class="card">
			    <div class="card-header" id="headingThree">
			      <h5 class="mb-0">
			        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
			          Teams
			        </button>
			      </h5>
			    </div>
			    <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordion">
			      <div class="card-body"><%=teams %></div>
			    </div>
			  </div>
			  <div class = "container" id="lyft-web-button-parent"></div>        				  
			</div>

    		</div>
    		<div class = "row">
    		    	<button type="button" class="btn-lg btn-primary fader col-lg-6" href="#" id="directionsSearch" title="Click to toggle">Get Directions</button>  
    		</div>
    		<div class = "row">
    			<div class = "col-lg-6" id = "directions" style = "display:none"></div>
    		</div>
    </div>
    
    <!-- Meeting & Place Name Info -->
    <script>	document.getElementById("title").innerHTML = location.search.split("meetingName=")[1].replace('%20', ' ');</script>
    
	<div id = "placeName" type = "hidden" style = "display:none"><%=locationName %></div>  

    <!-- Directions Info -->
    <div id = "address" type = "hidden"></div>
    <div id = "destLat" type = "hidden"></div>
    <div id = "destLng" type = "hidden"></div>
    <a href="/webpack-dev-server/production.single.html" target="_parent"></a>
    
    <script type="text/javascript">
    
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
    	    
		var lat = results[0].geometry.location.lat();
		var lng = results[0].geometry.location.lng();
			
		
	    //====================================== Lyft ===================================================
	  	console.log("set to " + lat + ", " + lng);

	    var OPTIONS = {
	    	      scriptSrc: 'lyftWebButton.js',
	    	      namespace: 'lyftWebButton',
	    	      clientId: '5qMs_F9Ny8aE',
	    	      clientToken: 'H0EOqDiJUGw5LiI2wPs1QT6ypLUEOVjdaG+sQ4yHPs+7X13Y0Fjoz6RgmWjGE0AIeDvVcpzBQ3HQmysnKoHz0Te0Sb8HbMSxTc9gFAQ+jv8Ext/qOjyJky4=',
	    	      location: {
	    	        pickup: {},
	    	        destination: {
	    	          latitude: lat,
	    	          longitude: lng,
	    	        },
	    	      },
	    	      parentElement: document.getElementById('lyft-web-button-parent'),
	    	      queryParams: {
	    	        credits: ''
	    	      },
	    	      theme: 'mulberry-dark',
	    	    };
	    	    (function(options) {
	    	    		console.log("running");
	    	      var window = this.window;
	    	      var document = this.document;
	    	      window.lyftInstanceIndex = window.lyftInstanceIndex || 0;
	    	      var parentElement = options.parentElement;
	    	      var scriptElement = document.createElement('script');
	    	      scriptElement.async = true;
	    	      scriptElement.onload = function() {
	    	    	  	console.log("loaded");
	    	        window.lyftInstanceIndex++;
	    	        var instanceName = options.namespace ? ('lyftWebButton' + options.namespace + window.lyftInstanceIndex) : 'lyftWebButton' + window.lyftInstanceIndex;
	    	        window[instanceName] = window['lyftWebButton'];
	    	        options.objectName = instanceName;
	    	        window[instanceName].initialize(options);
	    	      };
	    	      scriptElement.src = options.scriptSrc;
	    	      parentElement.insertBefore(scriptElement, parentElement.childNodes[0]);
	    	    }).call(this, OPTIONS);


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
    			    			
    			var query = place.name; 
    	    		
    			document.getElementById('details').innerHTML += "Location: " + "<a href=\"Location.jsp?locationName=" + query + "\">" + place.name + "</a></br>";
    	    		document.getElementById('details').innerHTML += "Address: " + place.vicinity + "</br>";
    	    		document.getElementById('details').innerHTML += "</br>";
    	    		
    	  	}
      }		
    }
    

    //====================================== Directions ===================================================
    
    document.getElementById("directionsSearch").onclick = function() {
       
        var directionsDisplay = new google.maps.DirectionsRenderer;
        var directionsService = new google.maps.DirectionsService;
        
        directionsDisplay.setMap(map);
        document.getElementById('directions').innerHTML = ''; 
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
    </script> 
    
    <script>
     
    </script>
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCDV9Wi54vI3fIhOxEBHJDokoiEMAiLGu8&libraries=places&callback=initialize"></script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>

</body>
</html>

