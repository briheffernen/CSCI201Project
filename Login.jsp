<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="google-signin-scope" content="profile email">
   		<meta name="google-signin-client_id" content="980066365986-v90mhlm9dncm5ivnf165211q6f8u3aq4.apps.googleusercontent.com">
    		<script src="https://apis.google.com/js/platform.js" async defer></script>
		<title>Login</title>
		<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
	<style>
	
	
	</style>
	
	</head>
	<body>
	<form id="form"></form>
	<div>
		<h1>Welcome!</h1>
		<h2>Click the button below to sign in.</h2>
	</div>
		<div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark"></div>
    		<script>
	      function onSignIn(googleUser) {
	        // Useful data for your client-side scripts:
	        	console.log("in onSignIn");
	        alert("signed in");
	        var profile = googleUser.getBasicProfile();
	        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
	        console.log('Full Name: ' + profile.getName());
	        console.log('Given Name: ' + profile.getGivenName());
	        console.log('Family Name: ' + profile.getFamilyName());
	        console.log("Image URL: " + profile.getImageUrl());
	        console.log("Email: " + profile.getEmail());
	
	        // The ID token you need to pass to your backend:
	        var id_token = googleUser.getAuthResponse().id_token;
	        console.log("ID Token: " + id_token);
	        
	        // send info and relocate to profile page
	        // window.location = "homepage.jsp";
	        //request.getSession().setAttribute("user", googleUser);
	        //request.getSession().setAttribute("id", id_token);   
	        //var xhttp = new XMLHttpRequest();
	        //xhttp.open("GET", "profile.jsp?id=" + id_token + "&name=" + profile.getName(), false);
	        //xhttp.send();
	        
	        var form = document.getElementById("form");
	        form.setAttribute("method", "POST");
	        form.setAttribute("action", "profile.jsp");
	        
	        var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", "user_id");
            hiddenField.setAttribute("value", profile.getId());
            
            form.appendChild(hiddenField);
            
            var hidden = document.createElement("input");
            hidden.setAttribute("type", "hidden");
            hidden.setAttribute("name", "name");
            hidden.setAttribute("value", profile.getName());

            form.appendChild(hidden);
            
            
	        
	        // document.body.appendChild(form);
	        form.submit();
	      };
	    </script>
	</body>
</html>