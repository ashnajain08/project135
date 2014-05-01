<%@page import="java.util.*, orderitem.*" %>
<html>
  <head>

<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
	<%-- Initialization code for session variable --%>
	<%
	  String username = (String)(session.getAttribute("username"));
	  int userid = (Integer)session.getAttribute("userid");
	  if (session.getAttribute("mycart")==null) {
	    session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
	  }
	  HashMap<Integer, OrderItem> myCart = (HashMap<Integer, OrderItem>)session.getAttribute("mycart");
	%>
	<title>Order Page</title>
  <head>
  <body>
	Logged In Owner : <%=session.getAttribute("username")%> <br>
<a style="color : #663300; margin-left : 90%" href="checkout.jsp">Checkout</a>
	<div class="header">
			<h1>Order</h1>
			<!-- end .header -->
		</div>

	<%
	  String action = request.getParameter("action");
	%>
	<%-- IF action is put in cart, add it in cart and jump to browsing --%>
	<%
	  if (action != null && action.equals("putincart")) {
	    int pid = Integer.parseInt(request.getParameter("pid"));
		String pname = (String)request.getParameter("pname");
		int price = Integer.parseInt(request.getParameter("price"));
		int num = Integer.parseInt(request.getParameter("num"));
		OrderItem item = myCart.get(pid);
		if (item == null) {
		  item = new OrderItem(pid, pname, price, num);
		} else {
		  item.setNUM(item.getNUM()+num);
		}
		myCart.put(pid, item);
	    response.sendRedirect("browsing.jsp"); 
	  }
	  //If action is order
	  else if (action != null && action.equals("order")) 
	  {
	    int pid = Integer.parseInt(request.getParameter("pid"));
	    String pname  = request.getParameter("pname");
	    int price = Integer.parseInt(request.getParameter("price"));
	%>

	<%-- Show current product and issue put in cart command --%>
	Current Product
	<table class="products">
	<tr>
	  <th>Product ID</th>
	  <th>Name</th>
	  <th>Price</th>
	  <th>Quantity</th>
	</tr>
	<tr>
	  <td><%=pid%></td>
	  <td><%=pname%></td>
	  <td><%=price%></td>
	  <form action="order.jsp" method="GET">
		<input type="hidden" name="action" value="putincart"/>
		<input type="hidden" name="pid" value="<%=pid%>"/>
		<input type="hidden" name="pname" value="<%=pname%>"/>
		<input type="hidden" name="price" value="<%=price%>"/>
	    <td> <input value="1" name="num"/></td>
	    <td><input type="submit" value="put in cart"/></td>
	  </form>
	</tr>
	</table>
<br/><br/>
    <%-- show my cart --%>
	<jsp:include page="showcart.jsp"/>
	<%
	  } //end of if
	  else {
	%>
	<p>Invalid Request
	<%
	  }
	%>
  </body>
</html>
