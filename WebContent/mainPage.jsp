<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>eShop</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
<center>
<h2 style="margin-top : 5%;font-size: 35px">Welcome to eShop</h2> 
<br/><br/>
<form class="myform" action="loginCheck.jsp" method="post"> 
   
    <p> 
    	<label for="name">Username</label>
        <input type="text" name="username" id="name" /> 
    </p> 
    <br/>
   
    <p class="mySubmit"> 
        <input type="submit" value="LogIn" /> 
    </p> 
   
</form>
<br/><br/><br/>
<form class="myform" action="signUp.jsp"> 
     
     <label for="newUser">New User</label> 
     <br/>
      <p class="mySubmit"> 
     <input  type="submit" value="Sign Up" />
   </p>
</form>
</center>
</body>
</html>

