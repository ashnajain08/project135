<%-- A module just for showing cart --%>

<%@page import="java.util.*, orderitem.*" %>

<b>My Cart</b>
<%
  if (session.getAttribute("mycart")==null) {
    session.setAttribute("mycart", new HashMap<Integer, OrderItem>());
  }
  HashMap<Integer, OrderItem> myCart = (HashMap<Integer, OrderItem>)session.getAttribute("mycart");
%>
<table border="1">
	<tr>
	  <th>pid</th>
	  <th>pname</th>
	  <th>num</th>
	  <th>price</th>
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
	  <th>total</th>
	  <th></th>
	  <th><%=total_price%></th>
    </tr>
</table>

