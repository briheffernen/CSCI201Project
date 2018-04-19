<!DOCTYPE html>
<html>

<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Homepage</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
    <script type="text/javascript">
    function stopRKey(evt) {
        var evt = (evt) ? evt : ((event) ? event : null);
        var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
        if ((evt.keyCode == 13) && (node.type == "text")) { return false; }
    }
    document.onkeypress = stopRKey;
    </script>
<%
Connection conn = null;
Statement st = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=Chalked1512!&useSSL=false");
st = conn.createStatement();
ArrayList<String> userIDs = new ArrayList<String>();
ArrayList<String> userNames = new ArrayList<String>();

ps = conn.prepareStatement("SELECT * FROM users");

rs = ps.executeQuery();
while (rs.next()) {
userIDs.add(rs.getString(“userID”);
userNames.add(rs.getString(“userName”);
}

System.out.println(userID);
} catch (SQLException sqle) {
System.out.println ("SQLException: " + sqle.getMessage());
} catch (ClassNotFoundException cnfe) {
System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
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
}


%>




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
    padding-top: 80px;
    display: block;
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
}
</style>

<body>
    <nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
        <a href="#" class="navbar-brand">When and Where</a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav ml-auto">
                <li class="navbar-item"><a href="http://localhost:8080/FinalProjTeam/profile.jsp" class="nav-link">Profile</a>
                </li>
                <li class="navbar-item"><a href="#" class="nav-link">Settings</a>
                </li>
                <li class="navbar-item"><a href="<%=fin%>" class="nav-link">Login</a>
                </li>
            </ul>
        </div>
    </nav>
        <!-- div container with user search -->
        <div id="usersection">
        	<div class="container">
        		<h2>User Search Results</h2>
                <div class="row">
                    <div class="col-xs-12 col-md-2">
                       <a href="homepage.jsp"> <button type="button" class="btn btn-success col-xs-12 " id="userSearchButton" >Back Home</button></a>
                    </div>
                </div>
                <!-- results -->
                <div id="userResults">
                	<table class="table table-striped">
					<br>
					<thead>
						<tr>
							<th></th>
							<th>Username</th>
						</tr>
					</thead>
					<tbody>
						<!-- Where the results go -->
						<tr>
							<td>1</td>
							<td><a href="userprofile.jsp?userID=4">Tommy Trojan</a></td>
						</tr>
						<tr>
							<td>2</td>
								<td><a href="userprofile.jsp?userID=5">Jessie Locke</a></td>
						</tr>
					</tbody>
				</table>
                </div>
        	</div>
            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>

</html>