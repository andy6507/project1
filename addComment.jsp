<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="dbconn.jsp" %>
<%
// POST로 전달된 데이터 받기
String post_id = request.getParameter("post_id");
String comment_text = request.getParameter("comment_text");

// 데이터베이스에 댓글 추가
PreparedStatement pstmt = null;
try {
    pstmt = conn.prepareStatement("INSERT INTO comments (post_id, comment_text) VALUES (?, ?)");
    pstmt.setString(1, post_id);
    pstmt.setString(2, comment_text);
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
