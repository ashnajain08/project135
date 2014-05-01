<%@page import = "java.sql.*"%>
<%@page import="java.util.*, orderitem.*" %>

<html>
  <head>
    <title>Confirmation Page</title>
	<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
    
    <%String username = (String)(session.getAttribute("username"));
      int userid = (Integer)session.getAttribute("userid");
	  if (session.getAttribute("mycart")==null) {
	    session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
	  }
	  HashMap<Integer, OrderItem> myCart = (HashMap<Integer, OrderItem>)session.getAttribute("mycart");
    %>
  </head>
  <body>
    Logged In Owner : <%=session.getAttribute("username")%> <br>
	<a style="color : #663300; margin-left : 90%" href="checkout.jsp">Checkout</a>
	<center><h1>Confirm page</h1>
	Your order is successfully put
	</center>
	<jsp:include page="showcart.jsp"/>
	<hr>

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
		pstmt.executeUpdate();
		conn.commit();
	  }

	%>
    <%
	  //rs.close();
	  pstmt.close();
	  conn.close();
	} catch (SQLException e) {
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
	%>
	<%-- Clean my cart, jump to browsing page --%>
	<%
      session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
	  //response.setHeader("Refresh", "5, browsing.jsp");
	%>
	<a style="color : #663300" href="browsing.jsp">Back to browsing</a>
 
  </body>
</html>
