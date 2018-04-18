<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
String url = "https://accounts.google.com/o/oauth2/v2/auth?";
String scope = "scope=https://www.googleapis.com/auth/calendar&"; //https://www.googleapis.com/auth/userinfo.profile&";
String access = "access_type=offline&";
String redirect = "redirect_uri=http://localhost:8080/Final/Validate&";
String re ="response_type=code&";
String client = "client_id=130203725109-1aapvdgu050h3glci9cu7go2qtji7rbu.apps.googleusercontent.com";
String fin = url+scope+access+redirect+re+client;
System.out.println(fin);
%>

</script>
	<a href= "<%=fin%>"> Click Here!</a>
</body>
</html>