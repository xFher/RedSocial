<%-- 
    Document   : friendsList
    Created on : Sep 1, 2018, 2:42:45 PM
    Author     : fernando
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<%
    if (request.getParameter("friendsRequests") != null) {
        try {
            Dba db = new Dba();
            db.conectar();
            String qry = "select a.uuid, a.firstname, a.lastname, a.email, a.createdAt, "
                    + "a.username, a.country, "
                    + "TO_CHAR(a.dateofbirth,'dd-Mon-yyyy') fecha_nacimiento, b.uuid requestid  "
                    + "from (select * from users where uuid <> '"
                    + session.getAttribute("s_userid") + "') a "
                    + "left join (select * "
                    + "from friendrequest "
                    + "where user_received = '"
                    + session.getAttribute("s_userid") + "' "
                    + "and requestStatus = 'SENT') b on a.uuid = b.user_sent "
                    + "where b.user_sent is not null";
            db.query.execute(qry);
            ResultSet rs = db.query.getResultSet();
%>
<div class="container">
    <h2>Solicitudes de Amistad</h2>
</div>
<br>
<div class="container">
    <div class="row">

        <%
            while (rs.next()) {
        %>
        <div class="col-sm-3">
            <div class="card-deck">
                <div class="card">
                    <img class="card-img-top" src="https://robohash.org/<%=rs.getString(6)%>" alt="<%=rs.getString(2)%> <%=rs.getString(3)%>">
                    <div class="card-body">
                        <h5 class="card-title"><%=rs.getString(2)%> <%=rs.getString(3)%></h5>
                        <p class="card-text">Email: <%=rs.getString(4)%></p>
                        <p class="card-text">Fecha Nac. <%=rs.getString(8)%></p>
                        <p class="card-text">Pais: <%=rs.getString(7)%></p>
                        <a class="btn btn-success btn-sm btn-block" href="handleFriends.jsp?acceptFriend=1&requestid=<%=rs.getString(9)%>" role="button">Aceptar</a>
                        <a class="btn btn-warning btn-sm btn-block" href="handleFriends.jsp?rejectFriend=1&requestid=<%=rs.getString(9)%>" role="button">Rechazar</a>
                    </div>
                </div>
            </div>
        </div>
        <%
                }
                db.desconectar();
            } catch (Exception e) {
                e.printStackTrace();
                out.println(e);
                request.getRequestDispatcher("home.jsp?projectsList=1&message=502").forward(request, response);
            }
        %>
    </div>
</div>
<%
    }
%>