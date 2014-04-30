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
	Hello: <%=username%> <br>
	<div align="center"><font size="16">Checkout page</font></div>
    <hr>
	<jsp:include page="showcart.jsp"/>
	<hr>
	<form action="confirm.jsp" method="POST">
	  Credit card:<input name="cardnum" value=""/>
	  <input type="submit" value="purchase"/>
	</form>
  </body>
</html>
