<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>eShop</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
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
<br/><br/>
What would you like to do today?<br/><br/><br/>
<a style ="color: #663300" href="ownerCategories.jsp">Browse Categories</a> <br/><br/>
<a style ="color: #663300" href="ownerProducts.jsp">Browse Products</a> <br/>
</center> 

</body>
</html>