<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>

<%@ page import="java.sql.*" %>
<%

String username=request.getParameter("username"); 

Connection conn = null;
PreparedStatement pstmt = null;
PreparedStatement pstmt1 = null;
ResultSet rs = null;

try {
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/cse135?" +
        "user=postgres&password=iphone");
    // Create the statement
    String query = "select id from users where uname= ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, username);
	rs = pstmt.executeQuery();
	if(!rs.next()){
	String firstname=request.getParameter("firstname"); 
	String lastname=request.getParameter("lastname"); 
	String role=request.getParameter("role"); 
	int age=Integer.parseInt(request.getParameter("age")); 
	String state=request.getParameter("state"); 
	conn.setAutoCommit(false);
	pstmt1 = conn.prepareStatement("INSERT INTO users (uname,role,age,state) VALUES (?, ?, ?, ?)");
    pstmt1.setString(1, username);
    pstmt1.setString(2,role);
    pstmt1.setInt(3, age);
    pstmt1.setString(4, state);
    int rowCount = pstmt1.executeUpdate();
    // Commit transaction
    conn.commit();
    conn.setAutoCommit(true);
	response.sendRedirect("mainPage.jsp");	
	}
	else
	{
	response.sendRedirect("error1.jsp");
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