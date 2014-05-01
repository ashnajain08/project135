<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*,java.util.*" errorPage="" %>
<%
/*
Author: Ryan L. Balcom

Assumptions:
	- After inserting a new product, confirmation can be derived from parameters rather than another query. 
	- After inserting a new product the category id is a sufficient form of confirmation.  
*/

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSet cats = null;
HashMap<Integer, String> categories = new HashMap<Integer, String>();
String success = request.getParameter("success");
String baseUrl = "ownerProducts.jsp";
String cid = request.getParameter("cid");
String action = request.getParameter("action");
String search = request.getParameter("search");
String sqlSearch = null;

try {
	// Registering Postgresql JDBC driver with the DriverManager
	Class.forName("org.postgresql.Driver").newInstance();
	conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/cse135","postgres","iphone");	
	Statement statement = conn.createStatement();
	Statement catStatement = conn.createStatement();

	// Do something if set 
	if( action != null && success == null ) {
		 
		 // insert product
		 if( action.equals("insert") ) {
			 
			 // Throw exception if anything parameter is null.
			 Enumeration paramNames = request.getParameterNames();
			 while( paramNames.hasMoreElements() ) {
				  String paramName = ( String )paramNames.nextElement();
				  String paramValue = request.getParameter( paramName );
				  
				  if( paramValue.equals("") ) {
						throw new NullPointerException();  
				  }
			  }
			 
			 String insertName = request.getParameter( "insert-name" );
			 String insertSku = request.getParameter( "insert-sku" );
			 int insertCategory = Integer.parseInt( request.getParameter( "insert-category" ) );
			 int insertPrice = Integer.parseInt( request.getParameter( "insert-price" ) );
			 
			 // begin transaction
			 conn.setAutoCommit(false);
			 pstmt = conn
			 .prepareStatement("INSERT INTO products (pname,sku,category,price) VALUES (?, ?, ?, ?)");			
			 pstmt.setString(1, insertName);
			 pstmt.setString(2, insertSku);
			 pstmt.setInt(3, insertCategory);
			 pstmt.setInt(4, insertPrice);
			 int rowCount = pstmt.executeUpdate();
			 conn.commit();
			 conn.setAutoCommit(true);
			 // end transaction
			 
			 // redirect on complete
			 response.sendRedirect( baseUrl +"?action=insert&success=true&name="+insertName+"&sku="+insertSku+"&category="+insertCategory+"&price="+insertPrice);
		 }
		 
		 // update products
		 if ( action.equals("update") ) {
			 
			 // Throw exception if anything parameter is null.
			 Enumeration paramNames = request.getParameterNames();
			 while( paramNames.hasMoreElements() ) {
				  String paramName = ( String )paramNames.nextElement();
				  String paramValue = request.getParameter( paramName );
				  
				  if( paramValue.equals("") ) {
						throw new NullPointerException();  
				  }
			  }
			 	
			 String updateName = request.getParameter( "update-name" );
			 String updateSku = request.getParameter( "update-sku" );
			 int updateCategory = Integer.parseInt( request.getParameter( "update-category" ) );
			 int updatePrice = Integer.parseInt( request.getParameter( "update-price" ) );
			 int pid = Integer.parseInt( request.getParameter( "pid" ) );
			 			 
			 // begin transaction
       conn.setAutoCommit(false);
			 pstmt = conn
			 .prepareStatement("UPDATE products SET pname=?, sku=?, category=?, price=? WHERE pid=?");
			 
			 pstmt.setString( 1, updateName );
			 pstmt.setString( 2, updateSku );
			 pstmt.setInt( 3, updateCategory );
			 pstmt.setInt( 4, updatePrice );
			 pstmt.setInt( 5, pid );
			 int rowCount = pstmt.executeUpdate();
			 
			 conn.commit();
			 conn.setAutoCommit(true);
			 // end transaction
			 
			 //response.sendRedirect( baseUrl + "?action=update&success=true");
		 }
		 
		 // delete products
		 if ( action.equals("delete") ) {
			 int pid = Integer.parseInt( request.getParameter("pid") );

			 // begin transaction
       conn.setAutoCommit(false);
			 
			 pstmt = conn
			 .prepareStatement("DELETE FROM products WHERE pid=?");
			 
			 pstmt.setInt( 1, pid );
			 int rowCount = pstmt.executeUpdate();
			 
			 conn.commit();
			 conn.setAutoCommit(true);
			 // end transaction
		 }
		 
		 // process redirects
		 if ( action.equals("update") || action.equals("delete") ) {
			 if ( cid != null ) {
				 response.sendRedirect( baseUrl + "?cid="+ cid +"&action="+ action +"&success=true");
		 	 } else {
				 response.sendRedirect( baseUrl + "?action="+ action +"&success=true");
		 	 } 
	   }
		 
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>135</title>
<link href="stylesheet.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div class="container">
  <div class="sidebar1">
  <a href="">Home</a>
    <ul class="nav">
      <li><a href="<%= baseUrl %>">All</a></li>
      <%
	  for (Map.Entry entry : categories.entrySet()) {
		  out.println("<li><a href='"+baseUrl+"?cid="+entry.getKey()+"' >"+ entry.getValue() +"</a></li>");
 	  } 
      %>
    </ul>
    <!-- end .sidebar1 --></div>
  <div class="content">
    <h1>New Product</h1>
    <%
		if( success != null && success.equals( "false" ) && action != null && action.equals("insert") ) {
		%>
   	<span class="insertFailure">Failure to insert new product</span>
    <%
		}
		%>
    <table class="newProducts">
      <tr>
        <th>Name</th>
        <th>Sku</th>
        <th>Category</th>
        <th>Price</th>
        <th></th>
      </tr>
      <tr>
        <form name="new-product" action="<%= baseUrl + "?action=insert" %>" method="post">
          <input type="hidden" name="action" value="insert" />
          <td><input type="text" name="insert-name" /></td>
          <td><input type="text" name="insert-sku" /></td>
          <td><select name="insert-category">
              <option value=""></option>
              <%
			  for (Map.Entry entry : categories.entrySet()) {
			  	out.println("<option value='"+(Integer)entry.getKey()+"' >"+ entry.getValue() +"</option>");
 			  } 
			  %>
            </select></td>
          <td><input type="text" name="insert-price" /></td>
          <td><input type="submit" value="Insert" /></td>
        </form>
      </tr>
      <tr>
      <%
			// Handle results
			if( success != null && success.equals("true") && action !=null && action.equals("insert") ) {
				Enumeration paramNames = request.getParameterNames();
   			while(paramNames.hasMoreElements()) {
					String paramName = (String)paramNames.nextElement();
      		String paramValue = request.getParameter(paramName);
					
					if( !paramName.equals("success")  && !paramName.equals("action") ) {
			%>
      		<td><input type="text" readonly="readonly" disabled="disabled" value="<%= paramValue %>" /></td>
      <%
					}
					
					if( paramName.equals("price") ) {
			%>
      			<td><b>Success</b></td>	
      <%
					}
   			}
			}
			%>
      
      </tr>
    </table>
    <br />
    <h1>Products</h1>
    <form name="search-products" action="<%= (cid != null) ? ( baseUrl + "?cid="+cid):(baseUrl) %>" method="post">
    <input type="hidden" name="action" value="search" />
  Search:
  <input name="search" type="text" value="" />
  <input type="submit" value="Submit" />
</form>
    <%
		if( success != null && success.equals( "true" ) && action !=null && !action.equals("insert") ) {
			out.println("<span class='statusSuccess'>The operation was completed successfully!</span>");
		}
		if( success != null && success.equals( "false" ) && action != null && action.equals("update") ) {
		%>
    	<span class="insertFailure">Failure to update product.</span>
    <%
		}
		%>
    <table class="products">
      <tr>
        <th>Name</th>
        <th>Sku</th>
        <th>Category</th>
        <th>Price</th>
        <th>Update</th>
        <th>Delete</th>
      </tr>
      <%
	  // set form action and iterate over ResultSet 
      while ( rs.next() ) {	
  	  %>
      <tr>
        <form name="update" action="<%= (cid != null) ? ( baseUrl + "?cid="+cid):(baseUrl) %>" method="post">
          <input type="hidden" name="action" value="update" />
          <input type="hidden" name="pid" value="<%=rs.getString("pid") %>" />
          <td><input name="update-name" type="text" id="name" value="<%=rs.getString("pname")%>" /></td>
          <td><input name="update-sku" type="text" id="sku" value="<%=rs.getString("sku")%>" /></td>
          <td><select name="update-category">
              <%
		  for (Map.Entry entry : categories.entrySet()) {
			  if( Integer.parseInt( rs.getString( "category" ) ) == ( Integer )entry.getKey() ) {
				  out.println("<option value='"+(Integer)entry.getKey()+"' selected >"+ entry.getValue() +"</option>");
			  } else {
				  out.println("<option value='"+(Integer)entry.getKey()+"' >"+ entry.getValue() +"</option>");
		  	  }
 		  } 
		  %>
            </select></td>
          <td><input name="update-price" type="text" id="price" value="<%=rs.getInt("price")%>" /></td>
          <td><input type="submit" value="Update" /></td>
        </form>
        <td><form name="delete" action="<%= (cid != null) ? ( baseUrl + "?cid="+cid):(baseUrl) %>" method="post">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="pid" value="<%=rs.getString("pid") %>" />
            <input type="submit" value="Delete" />
          </form></td>
      </tr>
      <% } %>
      <!-- end function call-->
    </table>
    <!-- end .content --></div>
  <div class="footer">
    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>
<%-- -------- Close Connection Code -------- --%>
<%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();
				catStatement.close();

                // Close the Connection
                conn.close();
				
			// Catch and fail on any exception.
			} catch ( Exception e) {
				out.print("<h1>"+e+"</h1>");
				String error = null;
				if( cid != null && action != null ) {
					error = baseUrl + "?cid="+cid+"&action="+action+"&success=false";
				}
				
				if( cid == null && action != null ) {
					error = baseUrl + "?action="+action+"&success=false";
				}
					
				//response.sendRedirect( error );
				
				
            } finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>