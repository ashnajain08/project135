<%-- A module just for showing cart --%>
<html>
<head>
<title>eShop</title>
<LINK href="stylesheet.css" rel="stylesheet" type="text/css">
</head>
<%@page import="java.util.*, orderitem.*" %>
<body>
<h1>My Cart</h1>
<%
  if (session.getAttribute("mycart")==null) {
    session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
  }
  HashMap<Integer, OrderItem> myCart = (HashMap<Integer, OrderItem>)session.getAttribute("mycart");
%>
<table class="products">
	<tr>
	  <th>Product ID</th>
	  <th>Name</th>
	  <th>Quantity</th>
	  <th>Price</th>
	</tr>
	<%
	  int total_price = 0;
	  for (Iterator iter = myCart.entrySet().iterator(); iter.hasNext();) {
	    Map.Entry pair = (Map.Entry)iter.next();
		OrderItem item = (OrderItem)pair.getValue();
	%>
	<tr>
	  <th><%=item.getPID()%></th>
	  <th><%=item.getPNAME()%></th>
	  <th><%=item.getNUM()%></th>
	  <th><%=item.getNUM()*item.getPRICE()%></th>
	</tr>
	<%
	    total_price += item.getNUM()*item.getPRICE();
	  }
	%>
	<tr>
	  <th></th>
	  <th>Total</th>
	  <th></th>
	  <th><%=total_price%></th>
    </tr>
</table>
</body>
</html>
