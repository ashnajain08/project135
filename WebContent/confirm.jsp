<%@page import = "java.sql.*"%>
<%@page import="java.util.*, orderitem.*" %>

<%
	String baseUrl = "confirm.jsp";
	String  success = request.getParameter("success");
	String username = (String)(session.getAttribute("username"));
    int userid = (Integer)session.getAttribute("userid");
	  if (session.getAttribute("mycart")==null) {
	    session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
	  }
	  HashMap<Integer, OrderItem> myCart = (HashMap<Integer, OrderItem>)session.getAttribute("mycart");

%>
<html>
  <head>
    <title>Confirmation Page</title>
	<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
    
      </head>
  <body>
    Logged In Owner : <%=session.getAttribute("username")%> <br>
	<a style="color : #663300; margin-left : 90%" href="checkout.jsp">Checkout</a>
	<center><h1>Confirm page</h1>
	Your order
	</center>
	<jsp:include page="showcart.jsp"/>
	<hr>

	<%
	if (success != null && success == "false") {
		out.println("an error occured during payment");
		out.println("Return to browsing page<a href='browsing.jsp'>browsing</a>");
	}
	else {
	%>

    <%-- open sql connection --%>
	<%
    Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
    try {
	  //Register postgresql jdbc driver
	  Class.forName("org.postgresql.Driver");
	  //Open a connection
	  conn = DriverManager.getConnection(
			  "jdbc:postgresql://localhost:5432/cse135?" +
		        "user=postgres&password=iphone");
    %>
	<%-- Store info to db --%>
    <%
	  conn.setAutoCommit(false);
	  pstmt = conn.prepareStatement(
	      "INSERT INTO orders (uid, pid, qty, cost) VALUES (?, ?, ?, ?)");
	  for (Iterator iter = myCart.entrySet().iterator(); iter.hasNext();) {
	    Map.Entry pair = (Map.Entry)iter.next();
		OrderItem item = (OrderItem)pair.getValue();

		pstmt.setInt(1, userid);
		pstmt.setInt(2, item.getPID());
		pstmt.setInt(3, item.getNUM());
        pstmt.setInt(4, item.getNUM()*item.getPRICE());
		//pstmt.executeUpdate(); do not use database to store store info
		conn.commit();
	  }

	%>
    <%
	  //rs.close();
	  pstmt.close();
	  conn.close();
	} catch (SQLException e) {
		String error = baseUrl + "&success=false";
		myCart = null;
		response.sendRedirect( error );
	  throw new RuntimeException(e);
	}
	finally {
	  // Release resources
	  if (rs != null) {
	    try {
		  rs.close();
		} catch (SQLException e) {}
		rs = null;
	  }
	  if (pstmt != null) {
	    try {
		  pstmt.close();
		} catch (SQLException e) {}
		pstmt = null;
	  }if (conn != null) {
	    try {
		  conn.close();
		} catch (SQLException e) {}
		conn = null;
	  }

	}
	}//end of ifeslse for success
	%>
	<%-- Clean my cart, jump to browsing page --%>
	<%
      session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
	  //response.setHeader("Refresh", "5, browsing.jsp");
	%>
	<a style="color : #663300" href="browsing.jsp">Back to browsing</a>
 
  </body>
</html>
