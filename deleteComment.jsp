<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="dbconn.jsp" %>
<%

String comment_id = request.getParameter("id");


PreparedStatement pstmt = null;
try {
    pstmt = conn.prepareStatement("DELETE FROM comments WHERE comment_id = ?");
    pstmt.setString(1, comment_id);
    pstmt.executeUpdate();
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    if (pstmt != null) {
        try {
            pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    response.sendRedirect("board.jsp"); 
}
%>
