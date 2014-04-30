<%@page import = "java.sql.*"%>
<html>
  <head>
    <title>Product Browsing</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">

  </head>
  <body>
    <%
      String username = (String)(session.getAttribute("username"));
	  if (username == null) {
	%>
	  Please Log in first<p>
	  <a href="index.html">login</a>
	<%
	  } else {
	%>
	    Logged In User: <%=username%> <br>
	    <a style="color : #663300; margin-left : 90%" href="checkout.jsp">CheckOut</a>
	    <div align="center"><font size="16">Browsing page</font></div>
	    <div align="right">
	    </div><hr>

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
	      <%-- Predefine func to implement function --%>
	  	  <%-- SELECT * statement code, get data from db --%>
	<%
          Statement statement = conn.createStatement();
	      rs = statement.executeQuery("SELECT * FROM products");
	%>
	
		  <!-- Add html table -->
          <table border="1">
	      <tr>
	        <th>pid</th>
            <th>pname</th>
	        <th>sku</th>
	        <th>category</th>
	        <th>price</th>
	      </tr>
          <%-- Iteration code to go through all products in db --%>
	<%
	      while (rs.next()) {
    %>
	        <tr>
	          <td><%=rs.getInt("pid")%></td>
	          <td><%=rs.getString("pname")%></td>
	          <td><%=rs.getString("sku")%></td>
	          <td><%=rs.getInt("category")%></td>
	          <td><%=rs.getInt("price")%></td>
	          <!-- button for order -->
	          <!-- TODO: use post or get? -->
	          <td>
	            <form action="order.jsp" method="POST">
		          <input type="hidden" name="action" value="order">
	              <input type="hidden" name="pid" value="<%=rs.getInt("pid")%>"/>
	              <input type="hidden" name="pname" value="<%=rs.getString("pname")%>"/>
	              <input type="hidden" name="price" value="<%=rs.getInt("price")%>"/>
		          <input type="submit" value="order"/>
	            </form>
	          </td>
	        </tr>
	<%
	      } //bracket for rs.next
    %>
	      <%-- Close Connection --%>
    <%
	      rs.close();
	      statement.close();
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
      </talble>
	<%
	  } //end of else
	%>
  </body>
</html>
