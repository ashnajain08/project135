<html>

<body>
<table>
    <tr>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%    
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
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
                	
                    String query = "select id from categories where cname= ?";
                	pstmt = conn.prepareStatement(query);
                	pstmt.setString(1, request.getParameter("cname"));
                	rs = pstmt.executeQuery();
                	int id = (rs.getInt("id"));
                	pstmt.close();
                	rs.close();
                	
                	conn.setAutoCommit(false);
                    pstmt = conn.prepareStatement("UPDATE students SET cname = ?,description = ? WHERE id = ?");
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
                    String query = "select id from products NATURAL JOIN categories where cname= ?";
                	pstmt = conn.prepareStatement(query);
                	pstmt.setString(1, request.getParameter("cname"));
                	rs = pstmt.executeQuery();
                	pstmt.close();
                	if(!rs.next())
                	{
                    conn.setAutoCommit(false);
                    pstmt = conn.prepareStatement("DELETE FROM Students WHERE cname = ?");
                    pstmt.setString(1, request.getParameter("cname"));
                    int rowCount = pstmt.executeUpdate();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    pstmt.close();
                    rs.close();
                	}
                }
            %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                Statement statement = conn.createStatement();
                rs = statement.executeQuery("SELECT * FROM categories");
            %> 
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Category Name</th>
                <th>Description</th>
            </tr>
            
            <tr>
                <form action="ownerCategories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="cname" size="10"/></th>
                    <th><input value="" name="desc" size="30"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
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
                    <input value="<%=rs.getString("desc")%>" name="desc" size="30"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="ownerCategories.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getString("cname")%>" name="cname"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>
            <%
                }
            %>
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
        </table>
        </td>
    </tr>
</table>
</body>

</html>

