<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>eShop</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
<%@ page import="java.sql.*" %>
<%

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSet rs1=null;
Statement st;

try {
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/cse135?" +
        "user=postgres&password=iphone");
    
    
    String username=request.getParameter("username"); 
    if(!username.equals(session.getAttribute("username")))
    {
    	session.setAttribute("mycart", null);
    	st=conn.createStatement();
    	rs1 = st.executeQuery("SELECT * FROM users WHERE uname='" + username + "'");
    	if (rs1.next()) 
    	{
    		session.setAttribute("username", rs1.getString("uname"));
    		session.setAttribute("userid", 1);
    	}
    }
    
    // Create the statement
   String query = "select role from users where uname= ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, username);
	rs = pstmt.executeQuery();
	if(rs.next())
	{
		String role1 = rs.getString("role");
		if(role1.equalsIgnoreCase("user"))
		{
			
			response.sendRedirect("homeUser.jsp");
		}
		else
		{
			session.setAttribute("username", username);
			response.sendRedirect("homeOwner.jsp");
		}	
	}
	else
	{
		response.sendRedirect("error.jsp");
	}
	rs.close();

    // Close the Statement
    pstmt.close();

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