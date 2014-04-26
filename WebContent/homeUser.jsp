<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>

<br/><br/><br/><br/><br/> 
<center> 
<h2> 
<% 
String a=session.getAttribute("username").toString(); 
out.println("Hello "+a); 
%> 
</h2> 
<br/> <br/> 
What would you like to do today?<br/>
<a href="browsing.jsp">Shop</a> <br/>
<a href="checkout.jsp">View Cart</a> <br/>
</center> 

</body>
</html>