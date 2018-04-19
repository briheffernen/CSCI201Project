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

#container {
	position: relative; 
}

#searchoptions {
    margin-top: 60px;
    text-align: center;
    font-size: 50px;
}

#map {
	top: 0; 
	left: 0;  
    width: 100%;
    float: left; 
}

#locInfo {
}

#title {
	font-style: bold; 
}

#reviews {


}

#details {


}

p {
	display: inline;

}

h4 {
	font-family: Arial, Helvetica, sans-serif	;
	font-size: 18pt; 	
	font-weight: bold; 
	display: inline; 
}

#reviewCard {
	width: 100%; 

}

.centerme {
    margin: auto auto;
    width: 80%;
}

#user {
	display: inline; 

}



</style> 

<body onLoad = "return loadReviews();">
	<nav class="navbar navbar-light bg-light navbar-expand-sm">
		<a href="/Final_Project/homepage.jsp" class="navbar-brand"><img src = "WhenWhereLogo.png" style="width:100px;height:50px;"></a>
	    	<button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
	    		<span class="navbar-toggler-icon"></span>
	    </button>
	    <div class="collapse navbar-collapse" id="navbarCollapse">
	    		<ul class="navbar-nav ml-auto">
	        	<li class="navbar-item">
	        		<a href="" id = "profile" class="nav-link">Profile</a>
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
    <div class = "container-fluid" id = "container">
	    
	    <div class = "row">   
	    		<div class = "col-lg-6" id = "map"></div>
	    		<div class = "col-lg-6" id = "locInfo">
		    		<div id = "title"></div>
		    		<div id = "detailsCard">
		    			<div class = "card-header"><h3>Address: </h3></div>
		    			<div class = "card-body">
		    				<h5 class = "card-text" id = "details"></h5>
		    			</div>
		    		</div>
		    		<div id = "reviewCard">
		    			<div class = "card-header"><h3>Reviews: </h3></div>
		    			<div class = "card-body">
		    				<h5 class = "card-text" id = "reviews"></h5>
		    			</div>
		    		</div>
		    		<div id = "reviewSection">
		    			<div class = "card-header"><h3>Leave Review: </h3></div>
		    			<div class = "card-body">
		    				<h5 class = "card-text">
			    				<form id = "review" method = "GET" action = "addReview">
			    					<div class = "row">
			    						<div class = "col-lg-6"><div id = "user" style = "width: 80%"><h4>Username: </h4></div>				</div>
			    						<div class =  "col-lg-6"><textarea id = "leaveReview" name = "leaveReview" style = "width: 100%" type = "text" placeholder = "Leave Review"></textarea></div>
			    						<input id = "loc" name = "loc" type = "hidden">
			    						<button type="submit" class="btn-lg btn-primary fader col-lg-12" id="directionsSearch">Submit</button>  

		    						</div>
			    				</form>		    			
		    				</h5>
		    			</div>
		    		</div>
		    </div>
	    </div>
	    
	    <script>console.log("reviews:\n" + document.getElementById("reviews").innerHTML)</script>
	    
    </div>
    
    <% HttpSession currentSession = request.getSession(); %> 
	<% String loggedin = (String) currentSession.getAttribute("userName");%> 
	<% System.out.println("Logged in as: " + loggedin); %>
    
    
    <div id = "username" type = "hidden" style = "display:none"><%=loggedin%></div>
    
    	<script> 
		var user1 = document.getElementById("username").innerHTML; 
		if (user1 == 'null' || user1 == '') {
			document.getElementById("profile").style.display = "none";
		} else {
		 	document.getElementById("profile").href="Profile.jsp?userName=" + user1; 			
		}
	 	console.log("user1: " + user1); 
	</script>
    
    <script type="text/javascript">

    //====================================== Creating a Map ===================================================
			
    var user2 = document.getElementById("username").innerHTML;
    console.log("user2: " + user2); 
    
    if (user2 == 'null' || user2 == '') {
        console.log("fake"); 

		document.getElementById("reviewSection").style.display = "none"; 
		console.log("changed display");

    } else {
        document.getElementById("user").innerHTML += "<p>" + user2 + "</p>"; 

    } 
    	
    var map;
	var tempAddy = location.search.split('locationName=')[1] 
	var addy;
	
	var isAnAddition = sessionStorage.address; 
	
	if (tempAddy != null) {
		addy = tempAddy.split('%20').join('+');
  		sessionStorage.address = addy;  

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

    	    		document.getElementById('title').innerHTML += "<h2>" + place.name + "</h2></br>";
    	    		//document.getElementById('details').innerHTML += "<h3>ID: <h3>" + place.place_id + "</br>";
    	    		document.getElementById('details').innerHTML += place.vicinity + "</br>";
    	    		
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