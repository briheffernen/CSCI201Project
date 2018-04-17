<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta name="google-signin-scope" content="profile email">
   		<meta name="google-signin-client_id" content="980066365986-v90mhlm9dncm5ivnf165211q6f8u3aq4.apps.googleusercontent.com">
    		<script src="https://apis.google.com/js/platform.js" async defer></script>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js">
  </script>
  <script src="https://apis.google.com/js/client:platform.js?onload=start" async defer>
  </script>
		<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Submit Calendar</title>
</head>
<body>
	<form id="form"></form>
	<div>
		<h1>Welcome!</h1>
		<h2>Click the button below to add your Google Calendar.</h2>
	</div>
		<div id="my-signin2"></div>
  <script>
    function onSuccess(googleUser) {
      console.log('Logged in as: ' + googleUser.getBasicProfile().getName());
    }
    function onFailure(error) {
      console.log(error);
    }
    function renderButton() {
      gapi.signin2.render('my-signin2', {
        'scope': 'profile email',
        'width': 240,
        'height': 50,
        'longtitle': true,
        'theme': 'dark',
        'onsuccess': onSuccess,
        'onfailure': onFailure
      });
    }
  </script>

  <script src="https://apis.google.com/js/platform.js?onload=renderButton" async defer></script>
    		<script>
    		
    		gapi.load('auth2', function(){
    			
    			alert("in gapi.load");
    		      // Retrieve the singleton for the GoogleAuth library and set up the client.
    		    auth2 = gapi.auth2.init({
    		        client_id: '980066365986-v90mhlm9dncm5ivnf165211q6f8u3aq4.apps.googleusercontent.com',
    		        cookiepolicy: 'single_host_origin',
    				scope: 'email https://www.googleapis.com/auth/calendar'});                // Base scope
    				
    		      var options = new gapi.auth2.SigninOptionsBuilder(
    		    	        {'scope': 'email https://www.googleapis.com/auth/calendar'});

    		    	googleUser = auth2.currentUser.get();
    		    	googleUser.grant(options).then(
    		    	    function(success){
    		    	      console.log(JSON.stringify({message: "success", value: success}));
    		    	      auth2.grantOfflineAccess().then(signInCallback);
    		    	    },
    		    	    function(fail){
    		    	      alert(JSON.stringify({message: "fail", value: fail}));
    		    	    });
    		    });
    		 
    		
    		function signInCallback(authResult) {
    			  if (authResult['code']) {
    				alert("authresult: " + authResult['code']);
				console.log("authresult: " + authResult['code']);

    			    // Hide the sign-in button now that the user is authorized, for example:
    			    //$('#signinButton').attr('style', 'display: none');

    			    // Send the code to the server
    			    $.ajax({
    			      type: 'GET',
    			      url: 'http://localhost:8080/FinalProjTeam/Validate',
    			      
    			      // Always include an `X-Requested-With` header in every AJAX request,
    			      // to protect against CSRF attacks.
    			      headers: {
    			        'X-Requested-With': 'XMLHttpRequest'
    			      },
    			      contentType: 'application/octet-stream; charset=utf-8',
    			      success: function(result) {
    			        // Handle or verify the server response.
    			        alert("result" + result);
    			        console.log("result: " + result);
    			        alert("authresult: " + authResult['code']);
    			        
    			      },
    			      processData: false,
    			      data: authResult['code']
    			      
    			    });
    			  } else {
    			    // There was an error.
    			    alert("error");
    			  }
    			  
    			  alert("finished sign in call back");
    			}
    		</script>
</body>
</html>