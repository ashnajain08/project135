<%@page import="java.sql.*, java.util.*, java.io.*"%>
<%
String username = (String)(session.getAttribute("username"));
String cid = request.getParameter("cid");
String action = request.getParameter("action");
String search = request.getParameter("search");
String success = request.getParameter("success");
String sqlSearch = null;
HashMap<Integer, String> categories = new HashMap<Integer, String>();
String baseUrl = "browsing.jsp";
//open sql connection
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSet cats = null;


try {
	  //Register postgresql jdbc driver
	  Class.forName("org.postgresql.Driver");
	  //Open a connection
	  conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/cse135?" +
        "user=postgres&password=iphone");


	  Statement statement = conn.createStatement();
	  Statement catStatement = conn.createStatement();

	// Do something if set 
	if( action != null ) {
		// search products
		 if ( action.equals("search") ) {
			 if ( cid != null ) {
				 sqlSearch = "SELECT * FROM products WHERE category='"+ cid +"' AND pname LIKE '%"+ search +"%' ORDER BY pid";
			 } else {
				 sqlSearch = "SELECT * FROM products WHERE pname LIKE '%"+ search +"%' ORDER BY pid";
			 }
		 }
	}
	// Show a category's products
	if ( cid != null && search == null ) {
		sqlSearch = "SELECT * FROM products WHERE category='"+ cid +"' ORDER BY pid";
		} else if( cid == null && search == null ){
			sqlSearch = "SELECT * FROM products ORDER BY pid";
		}

		//out.println(sqlSearch);
		rs = statement.executeQuery(sqlSearch);

	  // Grab the categories list.
	cats = catStatement.executeQuery("SELECT * FROM categories");

	while( cats.next() ) {
		categories.put(cats.getInt("cid"),cats.getString("cname"));
	}
	  %>

<html>
<head>
<title>Product browsing</title>
<link href="stylesheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
Logged In Owner : <%=session.getAttribute("username")%> <br>
<a style="color : #663300; margin-left : 90%" href="checkout.jsp">Checkout</a>
	<div class="container">

		<%
	  		if (username == null) {
	  			out.println("Please Log in first<br><a href='mainPage.jsp'>login</a>");
	  	} else {
	  	%>
		<div class="header">
			<h1>Browsing page</h1>
			<!-- end .header -->
		</div>

		<div class="sidebar1">
			<ul class="nav">
				<li><a href="<%= baseUrl %>">All</a></li>
				<%
	  for (Map.Entry entry : categories.entrySet()) {
		  out.println("<li><a href='"+baseUrl+"?cid="+entry.getKey()+"' >"+ entry.getValue() +"</a></li>");
 	  } 
      %>
			</ul>
			<!-- end .sidebar1 -->
		</div>

		<div class="content">
			<form name="search-products" action="" method="POST">
				<input type="hidden" name="action" value="search" /> Search: <input
					name="search" type="text" value="" /> <input type="submit"
					value="Submit" />
			</form>
			<%
			if (success != null && success == "false") {
				out.println("an error occured");
			}
			%>
			<table class="products">
				<tr>
					<th>Product Id</th>
					<th>Product Name</th>
					<th>SKU</th>
					<th>Category</th>
					<th>Price</th>
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
					<td>
						<form action="order.jsp" method="POST">
							<input type="hidden" name="action" value="order"> <input
								type="hidden" name="pid" value="<%=rs.getInt("pid")%>" /> <input
								type="hidden" name="pname" value="<%=rs.getString("pname")%>" />
							<input type="hidden" name="price" value="<%=rs.getInt("price")%>" />
							<input type="submit" value="order" />
						</form>
					</td>
				</tr>
				<%
				}//bracket for rs.next
	    %>
				</table>
				<!-- end .content -->
				</div>
				<%
	  }//end of if else

	  %>
				<!-- end .container -->
				</div>
</body>
</html>
<%-- Close Connection --%>
<%
rs.close();
statement.close();
conn.close();
} catch (SQLException e) {
	String error = baseUrl + "?success=false";
	response.sendRedirect( error );
	throw new RuntimeException(e);
} finally {
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

</html>
