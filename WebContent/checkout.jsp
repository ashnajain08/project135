<html>
  <head>
    <title>Checkout Page</title>
	<LINK href="stylesheet.css" rel="stylesheet" type="text/css">

    <%-- Initialization code for session variable --%>
	<%
	  String username = (String)(session.getAttribute("username"));
	  int userid = (Integer)session.getAttribute("userid");
	%>
  </head>
  <body>
	Logged In Owner : <%=session.getAttribute("username")%> <br>
<a style="color : #663300; margin-left : 90%" href="checkout.jsp">Checkout</a>
	<center><h1>Checkout page</h1></center>
	<jsp:include page="showcart.jsp"/>
	<hr>
	<form class ="myForm" action="confirm.jsp" method="POST">
	  <p>
	  <label>Credit card</label>
	  <input name="cardnum" value=""/>
	  </p>
	  <p class="mySubmit">
	  <input type="submit" value="purchase"/>
	  </p>
	</form>
  </body>
</html>
