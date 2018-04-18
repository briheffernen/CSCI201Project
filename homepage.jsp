<%@page
	import="java.sql.SQLException, java.io.IOException, java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement, java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Homepage</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
<script type="text/javascript">
    function stopRKey(evt) {
        var evt = (evt) ? evt : ((event) ? event : null);
        var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
        if ((evt.keyCode == 13) && (node.type == "text")) { return false; }
    }

    document.onkeypress = stopRKey;
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

#mapsection {
	padding-top: 40px;
	padding-bottom: 30px;
}

#usersection {
	padding-top: 40px;
	display: none;
}

#createmeeting_button {
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

#userResults {
	margin: auto auto;
	width: 70%;
}
</style>

<body>
	<nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
	<a href="#" class="navbar-brand">When and Where</a>
	<button class="navbar-toggler" data-toggle="collapse"
		data-target="#navbarCollapse">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse" id="navbarCollapse">
		<ul class="navbar-nav ml-auto">
			<li class="navbar-item"><a href="#" class="nav-link">Profile</a>
			</li>
			<li class="navbar-item"><a href="#" class="nav-link">Settings</a>
			</li>
			<li class="navbar-item"><a href="#" class="nav-link">Logout</a>
			</li>
		</ul>
	</div>
	</nav>
	<div class="container-fluid">
		<div id="searchoptions">
			<button type="button" class="btn-lg btn-primary fader" href="#"
				id="locationSearch" title="Click to toggle">Searching for
				locations</button>
			<button type="button" class="btn-lg btn-success btn-disabled fader"
				href="#" id="userSearch" title="Click to toggle">Searching
				for users</button>
		</div>
		<!-- div container with map search -->
		<div id="mapsection">
			<form action="" method="" id="google-form">
				<div class="row centerme">
					<div class="col-xs-12 col-md-10">
						<input type="text" name="" id="address" class="form-control"
							placeholder="Enter an address or drop a pin in the map">
					</div>
					<!-- .form-group -->
					<div class="col-xs-12 col-md-2">
						<button type="submit" class="btn btn-primary col-xs-12 btn-block"
							id="locationSearchButton">Search</button>
					</div>
					<!-- .form-group -->
				</div>
			</form>
			<form action="CreateMeeting.jsp" method="GET" id="createMeeting">
				<div class="centerme">
					<input type="hidden" name="meetingAddress" id="meetingAddress"
						value="">
					<button type="submit" class="btn btn-primary btn-block"
						id="createmeeting_button" disabled>Create Meeting</button>
				</div>
			</form>
			<div id="map"></div>
		</div>
		<!-- div container with user search -->
		<div id="usersection">
			<form action="" method="" id="google-form">
				<div class="row centerme">
					<div class="col-xs-12 col-md-10">
						<input type="text" name="" id="user" class="form-control"
							placeholder="Enter a username...">
					</div>
					<!-- .form-group -->
					<div class="col-xs-12 col-md-2">
						<button type="button" class="btn btn-success col-xs-12 btn-block"
							id="userSearchButton" onclick="userSearch()">Search</button>
					</div>
					<!-- .form-group -->
				</div>
			</form>
			<!-- user results -->
			<div id="userResults">
				<table class="table table-striped">
					<br>
					<thead>
						<tr>
							<th>#</th>
							<th>Username</th>
						</tr>
					</thead>
					<tbody>
						<!-- Where the results go -->
						<tr>
							<td>1</td>
							<td><a href="profile.jsp?userID=4">Tommy Trojan</a></td>
						</tr>
						<tr>
							<td>2</td>
								<td><a href="profile.jsp?userID=5">Jessie Locke</a></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- .container-fluid -->
	<script type="text/javascript">
    //====================================== Users search ===================================================
    function userSearch() {
    	//clear the results if there are any
    	var tbody = document.querySelector("tbody");
			while(tbody.hasChildNodes()) { // loops until returns FALSE
				tbody.removeChild(tbody.firstChild);
			}
    	
    	
        //store the query value
        var query = document.getElementById("user").value;

        <%//connect to the database
			Connection conn = null;
			Statement st = null;
			PreparedStatement ps = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager
						.getConnection("jdbc:mysql://localhost/Users?user=root&password=Iaminla123&useSSL=false");
				st = conn.createStatement();
				String name = "Sheldon";
				// rs = st.executeQuery("SELECT * from Student where fname='" + name + "'");
				ps = conn.prepareStatement("SELECT * FROM Student WHERE fname=?");
				ps.setString(1, name); // set first variable in prepared statement

				//get the results back
				//iterate through the object and populate the userResults div with whatever was returned
				// !remember to attach link to userprofile page by appending the id
				rs = ps.executeQuery();
				int i = 1;
				while (rs.next()) {%>
            //Create the row
            var row = document.createElement("tr");

            var rowNumber = document.createElement("td");
            rowNumber.innerHTML = <%=i++%>;

            //Create the data cell
            var userCell = document.createElement("td");

            //create a link that will surround the username
            var userLink = document.createElement("a");
            var url = "userprofile.jsp?userID=" + "<%=rs.getString("userID")%>";
			//set the link to the userprofile page
			userLink.setAttribute('href', url);
			//populate the link's html with the actual username
			userLink.innerHTML = "<%=rs.getString("username")%>";

			//append the link to the userCell
			userCell.appendChild(userLink);
			//append the tds to the actual row
			row.appendChild(rowNumber);
			row.appendChild(userCell);

			//Append our <tr> 
			document.querySelector("tbody").appendChild(row);
	<%}

			} catch (SQLException sqle) {
				System.out.println("SQLException: " + sqle.getMessage());
			} catch (ClassNotFoundException cnfe) {
				System.out.println("ClassNotFoundException: " + cnfe.getMessage());
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
					if (st != null) {
						st.close();
					}
					if (ps != null) {
						ps.close();
					}
					if (conn != null) {
						conn.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle: " + sqle.getMessage());
				}
			}%>
		return false;
		}

		//====================================== Buttons at the top ===================================================

		//Adjusts the appearance of the search type buttons and replaces the page content
		document.getElementById("locationSearch").onclick = function() {
			if (this.classList.contains('btn-disabled')) {
				this.classList.remove('btn-disabled');
				document.getElementById("userSearch").classList
						.add('btn-disabled');
				// this.classList.add('btn-success');
				// this.innerHTML = "Searching for Users";
				document.getElementById("usersection").style.display = "none";
				document.getElementById("mapsection").style.display = "block";
				// document.getElementById("mapsection").style.display = "none";
				// document.getElementById("usersection").style.display = "block";
			}
		}

		document.getElementById("userSearch").onclick = function() {
			if (this.classList.contains('btn-disabled')) {
				this.classList.remove('btn-disabled');
				document.getElementById("locationSearch").classList
						.add('btn-disabled');
				// this.classList.add('btn-success');
				// this.innerHTML = "Searching for Users";

				document.getElementById("mapsection").style.display = "none";
				document.getElementById("usersection").style.display = "block";
			}
		}

		//====================================== Creating a Map ===================================================

		var map;
		var marker;
		var validQuery = "";
		var geocoder;
		var infoWindow;

		//This function adds the current location button on the bottom right of the map
		function addYourLocationButton(map, marker) {
			var controlDiv = document.createElement('div');

			var firstChild = document.createElement('button');
			firstChild.style.backgroundColor = '#fff';
			firstChild.style.border = 'none';
			firstChild.style.outline = 'none';
			firstChild.style.width = '28px';
			firstChild.style.height = '28px';
			firstChild.style.borderRadius = '2px';
			firstChild.style.boxShadow = '0 1px 4px rgba(0,0,0,0.3)';
			firstChild.style.cursor = 'pointer';
			firstChild.style.marginRight = '10px';
			firstChild.style.padding = '0';
			firstChild.title = 'Your Location';
			controlDiv.appendChild(firstChild);

			var secondChild = document.createElement('div');
			secondChild.style.margin = '5px';
			secondChild.style.width = '18px';
			secondChild.style.height = '18px';
			secondChild.style.backgroundImage = 'url(https://maps.gstatic.com/tactile/mylocation/mylocation-sprite-2x.png)';
			secondChild.style.backgroundSize = '180px 18px';
			secondChild.style.backgroundPosition = '0 0';
			secondChild.style.backgroundRepeat = 'no-repeat';
			firstChild.appendChild(secondChild);

			google.maps.event.addListener(map, 'center_changed', function() {
				secondChild.style['background-position'] = '0 0';
			});

			firstChild
					.addEventListener(
							'click',
							function() {
								var imgX = 0, animationInterval = setInterval(
										function() {
											imgX = -imgX - 18;
											secondChild.style['background-position'] = imgX
													+ 'px 0';
										}, 500);

								if (navigator.geolocation) {
									navigator.geolocation
											.getCurrentPosition(function(
													position) {
												var latlng = new google.maps.LatLng(
														position.coords.latitude,
														position.coords.longitude);
												map.setCenter(latlng);
												clearInterval(animationInterval);
												secondChild.style['background-position'] = '-144px 0';
											});
								} else {
									clearInterval(animationInterval);
									secondChild.style['background-position'] = '0 0';
								}
							});

			controlDiv.index = 1;
			map.controls[google.maps.ControlPosition.RIGHT_BOTTOM]
					.push(controlDiv);
		}

		function initMap() {
			var mapOptions = {
				zoom : 15,
				//this removes the street view control
				streetViewControl : false,
				fullscreenControl : false,
				//this is where the map is initially set to
				center : {
					lat : 34.0224,
					lng : -118.2851
				}

			}
			// Creating a new map
			map = new google.maps.Map(document.getElementById('map'),
					mapOptions);
			geocoder = new google.maps.Geocoder;
			infoWindow = new google.maps.InfoWindow;
			
			

			// Try HTML5 geolocation.
			if (navigator.geolocation) {
				navigator.geolocation.getCurrentPosition(function(position) {
					var pos = {
						lat : position.coords.latitude,
						lng : position.coords.longitude
					};

					currentLocation = new google.maps.Marker({
						position : pos,
						map : map,
						icon : {
							url : 'images/currentLocationMarker2.png',
							scaledSize : new google.maps.Size(28, 28)
						}
					});

					//this adds the current location button
					addYourLocationButton(map, currentLocation);

					// currentLocation.setIcon('https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png')
					// infoWindow.setPosition(pos);
					// infoWindow.setContent('Location found.');
					// infoWindow.open(map);
					map.setCenter(pos);
				}, function() {
					handleLocationError(true, infoWindow, map.getCenter());
				});

			} else {
				// Browser doesn't support Geolocation
				handleLocationError(false, infoWindow, map.getCenter());
			}

			function handleLocationError(browserHasGeolocation, infoWindow, pos) {
				infoWindow.setPosition(pos);
				infoWindow
						.setContent(browserHasGeolocation ? 'Error: The Geolocation service failed.'
								: 'Error: Your browser doesn\'t support geolocation.');
				infoWindow.open(map);
			}

			google.maps.event.addListener(map,'click',function(event) {
				placeMarker(event.latLng);
 				
		        if (event.placeId) {
		          getname(event.placeId)
		        } else {
		          geocoder.geocode({
		                'latLng': event.latLng
		              },
		              function(results, status) {
		                if (status == google.maps.GeocoderStatus.OK) {
		                	
		                  if (results[0]) {
		      				infoWindow.setContent(results[0].formatted_address);
		      				infoWindow.open(map, marker); 

		    					map.setCenter(results[0].geometry.location);
		    					marker.setPosition(results[0].geometry.location);
		                    	getname(results[0].place_id);
		                    
		                  }

		                }
		              });
		        }
		      });

		  function getname(place_id) {
		    var placesService = new google.maps.places.PlacesService(map);
		    placesService.getDetails({
		      placeId: place_id
		    }, function(results, status) {
				//infoWindow.setContent(results.formatted_address);
				//infoWindow.open(map, marker); 
				
				document.getElementById("address").value = results.name;

				validQuery = results.name;
				document.getElementById('meetingAddress').value = validQuery;
				console.log(document.getElementById('meetingAddress').value);
				enableCreateMeetingButton();

		    });
		  }
		

			//This function generates 
			document.querySelector("#google-form").onsubmit = function() {

				var addressInput = document.querySelector("#address").value
						.trim();

				var geotest = new google.maps.Geocoder();

				geotest.geocode({
					address : addressInput
				}, function(results) { // This anonymous function runs when geocode() is done 
					//(aka it is done converting the address into a latlng obj)
					// console.log("LatLng: ");
					// console.log(results[0].geometry.location.lat());
					// console.log(results[0].geometry.location.lng());

					map.setCenter(results[0].geometry.location);
					marker.setPosition(results[0].geometry.location);
					geocodeLatLng(geotest, map, infoWindow,
							results[0].geometry.location, "search");
					//don't update the address bar in this case
					console.log("The address is: "
							+ results[0].geometry.location);
				});
				//If a valid address has been found, activate the create meeting button
				if (!document.querySelector("#address").value.trim() == "") {

					document.getElementById("createmeeting_button").disabled = false;
				}
				return false;
			}

		  
		}
		
		

			// this function places the marker and populates the search input 
 			function placeMarker(location) {
				if (typeof marker !== 'undefined') {
					marker.setMap(null);
				}
				marker = new google.maps.Marker({
					position : location,
					map : map,
				// icon: {
				//     url: 'images/currentLocationMarker2.png',
				//     scaledSize: new google.maps.Size(24,24)
				// }
				});

			}
 
			// this function converts geocode (latitude and longitude) to a recognizable address
/* 			function geocodeLatLng(geocoder, map, infoWindow, latlng,
					requestType) {
				geocoder
						.geocode(
								{
									'location' : latlng
								},
								function(results, status) {
									if (status === 'OK') {
										if (results[0]) {
											
											infoWindow
													.setContent(results[0].formatted_address);
											infoWindow.open(map, marker);
											if (requestType == "click") {
												document.getElementById("address").value = results[0].formatted_address;
											}
											validQuery = results[0].formatted_address;
											
											var id = results[0].place_id; 
										    var request = {
										    		  placeId: id 
										    	};
										    
										    var name = getname(results[0]); 
										    console.log("NAME BE: " + name);
										    
										    var service = new google.maps.places.PlacesService(map);
										    service.getDetails(request, detailsCallback);
										    
										    function detailsCallback(place, status) {
										    	  	console.log("Entered callback for details"); 
										    	  	if (status == google.maps.places.PlacesServiceStatus.OK) {
										    	  		validQuery = place.name; 
										    	  		console.log("name: " + validQuery)
										    	  	}
										      }		
	
											document.getElementById('meetingAddress').value = validQuery;
											console.log(document.getElementById('meetingAddress').value);
											enableCreateMeetingButton();
											
										} else {
											window.alert('No results found');
										}
									} else {
										window.alert('Geocoder failed due to: '
												+ status);
									}
								});
			} */
			/*
			// Add a marker
			var marker = new google.maps.Marker({
			    position: {
			        lat: 34.0224,
			        lng: -118.2851
			    },
			    // In which map is the marker set
			    map: map,
			    //you can put a custom icon in here
			    icon: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'
			});

			var infoWindow = new google.maps.InfoWindow({
			    content:'<h1>University of Southern California</h1>'
			});
			marker.addListener('click', function(){
			    infoWindow.open(map,marker);
			})
			 */

			//     addMarker('private', {lat: 34.0224, lng: -118.2851});
			//     addMarker('public', {lat:34.025754, lng: -118.277299});

			//     // Add Marker Function -> a function to add a marker
			//     function addMarker(type, coords) {
			//         var marker = new google.maps.Marker({
			//             position: coords,
			//             // In which map is the marker set
			//             map: map,
			//             //you can put a custom icon in here
			//             icon: {
			//  url: "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png",
			//  // size: new google.maps.Size(36, 36),
			//  // anchor: new google.maps.Point(48,48),
			//  scaledSize: new google.maps.Size(36, 36),
			// }
			//         });
			//         // if(type == 'private') {
			//         //   console.log("in here at all?");
			//         //   // marker.setIcon('https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png');
			//         //   marker.setIcon('images/example.png')
			//         // }
			//         // else if (type == 'public') {
			//         //   console.log("only once");
			//         //   // marker.setIcon = default;
			//         // }
			//     }

		//}

		//====================================== Creating a Meeting ===================================================

		//These functions define the disable and enable createMeeting buttons

		function enableCreateMeetingButton() {
			if (!document.querySelector("#address").value.trim() == "") {
				document.getElementById("createmeeting_button").disabled = false;
			}
		}

		// function disableCreateMeetingButton() {
		//     document.getElementById("createmeeting_button").disabled = true;
		// }

		// document.getElementById("address").oninput = function() {
		//     if (document.getElementById("address").value.length == 0) {
		//         document.getElementById("createmeeting_button").disabled = false;
		//     } else {
		//         document.getElementById("createmeeting_button").disabled = true;
		//     }
		// }

		//This function disables and enables the Create Meeting button
		// document.getElementById("address").addEventListener('input', function() {
		//     console.log(document.getElementById("address").value);
		//     console.log("valid query: " + validQuery);
		//     if ((document.getElementById("address").value !== "") && (document.getElementById("createmeeting_button").disabled = false)) {
		//         validQuery = document.getElementById("address").value;
		//         disableCreateMeetingButton();
		//     } else if (document.getElementById("address").value.toUpperCase() == validQuery.toUpperCase()) {
		//         enableCreateMeetingButton();
		//     } else {
		//         disableCreateMeetingButton();
		//     }

		// });
	</script>
	<script
		src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCDV9Wi54vI3fIhOxEBHJDokoiEMAiLGu8&libraries=places&callback=initMap"></script>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
		integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
		crossorigin="anonymous"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
		integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
		crossorigin="anonymous"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
		integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
		crossorigin="anonymous"></script>
</body>

</html>