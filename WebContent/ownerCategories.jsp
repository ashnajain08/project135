<html>
<head>
<title>eShop</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
Logged In Owner : <%=session.getAttribute("username")%> <br>
<a style="color : #663300; margin-left : 90%" href="homeOwner.jsp">Homepage</a>
     
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%    
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement pstmt1 = null;
            ResultSet rs = null;
            ResultSet rs1 = null; 
            try 
            {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/cse135?" +
                    "user=postgres&password=iphone");
            %>
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) 
                {
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement and use it to
                    pstmt = conn.prepareStatement("INSERT INTO categories (cname,description) VALUES (?, ?)");
                    pstmt.setString(1, request.getParameter("cname"));
                    pstmt.setString(2, request.getParameter("desc"));
                    int rowCount = pstmt.executeUpdate();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    pstmt.close();
                }
            %>     
            <%-- -------- UPDATE Code -------- --%>
            <%
                if (action != null && action.equals("update")) 
                {
                	
                    String query = "select cid from categories where cname= ?";
                	pstmt = conn.prepareStatement(query);
                	pstmt.setString(1, request.getParameter("cname"));
                	rs = pstmt.executeQuery();
                	int id = (rs.getInt("cid"));
                	pstmt.close();
                	rs.close();
                	
                	conn.setAutoCommit(false);
                    pstmt = conn.prepareStatement("UPDATE students SET cname = ?,description = ? WHERE cid = ?");
                    pstmt.setInt(3, id);
                    pstmt.setString(1, request.getParameter("cname"));
                    pstmt.setString(2, request.getParameter("desc"));
                    int rowCount = pstmt.executeUpdate();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    pstmt.close();
                }
            %>
            <%-- -------- DELETE Code -------- --%>
            <%
                if (action != null && action.equals("delete")) 
                {
                
					//Check if category is refered by a product
					String query = "select pid from categories,products where categories.cid=products.category and cname= ?";
                	pstmt1 = conn.prepareStatement(query);
                	pstmt1.setString(1, request.getParameter("cname"));
                	rs1 = pstmt1.executeQuery();
					if(rs1.next())
					{
						response.sendRedirect("error2.jsp");
					}
					else
					{
                    conn.setAutoCommit(false);
                    pstmt = conn.prepareStatement("DELETE FROM categories WHERE cname = ?");
                    pstmt.setString(1, request.getParameter("cname"));
                    int rowCount = pstmt.executeUpdate();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    pstmt.close();
					}
					pstmt1.close();
                    rs1.close();
                }
            %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                Statement statement = conn.createStatement();
                rs = statement.executeQuery("SELECT * FROM categories");
            %> 
            
<div class="content"> 
<h1>New Category</h1>      
      <table class="newCategories">
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th></th>
      </tr>      
            <tr>
                <form action="ownerCategories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <%--  <th>&nbsp;</th> --%>
                    <th><input value="" name="cname" size="10"/></th>
                    <th><input value="" name="desc" size="30"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
        </table>
        <br/>
  		<table class="categories">
  		<h1>Categories</h1>
            <tr>
                <th>Category Name</th>
                <th>Description</th>
            </tr>  
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
                <form action="ownerCategories.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="cname" value="<%=rs.getString("cname")%>"/>
                <td>
                    <input value="<%=rs.getString("cname")%>" name="cname" size="15"/>
                </td>
                <td>
                    <input value="<%=rs.getString("description")%>" name="desc" size="30"/>
                </td>
                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
           
                <form action="ownerCategories.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getString("cname")%>" name="cname"/>
                    <%-- Button --%>
                    <%
                    String query = "select pid from categories,products where categories.cid=products.category and cname= ?";
                	pstmt = conn.prepareStatement(query);
                	pstmt.setString(1, rs.getString("cname"));
                	rs1 = pstmt.executeQuery();
                	if(rs1.next())
                	{
                	%>
                		 <td><input type="submit" value="Delete" disabled="disabled"/></td> 	
                	<%
                	}
                	else
                	{
                	%>
                		<td><input type="submit" value="Delete" /></td> 
                	<%
                	}
                	pstmt.close();
                	rs1.close();
                    
                    %>
     
            <%
                }
            %>
                      </form>
            </tr>
            </table>
</div><!-- end .content -->
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
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
        
</body>

</html>

