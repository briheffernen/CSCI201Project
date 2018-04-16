<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Driver" %>


<!DOCTYPE html>
<html>
<head>
    <title>Location</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
	<script> 
		function loadReviews() {
			
			var xhttp = new XMLHttpRequest(); 
			xhttp.open("GET", "queryReviews?search=" + document.getElementById("loc").value + "&sentFrom=location", false); 
			console.log("Sent parameter for reviews: " + document.getElementById("loc").value);
			xhttp.send();  //if you get to this line, then you have gotten a response 
			if(xhttp.responseText.trim().length > 0) {	
				document.getElementById("reviews").innerHTML = xhttp.responseText; 
			}
			return true; 
		}
		
		
	</script>
</head>
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

</style> 

<body onLoad = "return loadReviews();">
    <nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
        <a href="/Final_Project/Test.jsp" class="navbar-brand">When and Where</a>
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
    <div id = "title"></div>
    <div id = "map"></div>
    <div id = "details"></div>
    <div id = "reviews">${reviews}</div>
    <script>console.log("reviews:\n" + document.getElementById("reviews").innerHTML)</script>
    <form id = "review" method = "GET" action = "addReview">
    		<input id = "leaveReview" name = "leaveReview" type = "text" placeholder = "Leave Review"/>
    		<input id = "user" name = "user" type = "text">    		
    		<input id = "loc" name = "loc" type = "hidden">
    	
    		<input id = "submit" type = "submit">
    </form>
    
    <script type="text/javascript">

    //====================================== Creating a Map ===================================================

    var map;
	var tempAddy = location.search.split('VAR=')[1] 
	var addy;
	
	var isAnAddition = sessionStorage.address; 
	
	if (tempAddy != null) {
		addy = tempAddy.split('%20').join('+');
	} else {
		addy = isAnAddition; 
	}
	
	var marker; 
    var geocoder;
	
    	var service;

    function initialize() {

      var usc = new google.maps.LatLng(34.0224,-118.2851);

      map = new google.maps.Map(document.getElementById('map'), {
          center: usc,
          zoom: 15
        });
      geocoder = new google.maps.Geocoder;

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
      if (status == google.maps.places.PlacesServiceStatus.OK) {
    	    marker = new google.maps.Marker({
    	        map: map,
    	        place: {
    	          placeId: results[0].place_id,
    	          location: results[0].geometry.location
    	        }
    	      });
      }
     
      var request = {
    		  placeId: marker.place.placeId 
    		};
      
      service.getDetails(request, detailsCallback);
      
      function detailsCallback(place, status) {
    	  	console.log("Entered callback for details"); 
    	  	if (status == google.maps.places.PlacesServiceStatus.OK) {
    	  		
    	  		sessionStorage.placeName = place.name; 
    			
    	  		document.getElementById('loc').value = place.name; 

    	    		document.getElementById('details').innerHTML += "Name: " + place.name + "</br>";
    	    		document.getElementById('details').innerHTML += "ID: " + place.place_id + "</br>";
    	    		document.getElementById('details').innerHTML += "Address: " + place.vicinity + "</br>";
    	    		
    	    		console.log("Address name: " + place.name + "\n" + "Address ID: " + place.place_id); 
    	    		
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