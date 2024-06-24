<%@ include file="dbconn.jsp" %>
<%@ page import="java.sql.PreparedStatement, java.sql.SQLException" %>
<%
    PreparedStatement pstmt = null;
    try {
        // 좋아요 추가 로직
        String postIdStr = request.getParameter("id");
        int postId = Integer.parseInt(postIdStr);
        String username = (String) session.getAttribute("username");
        
        pstmt = conn.prepareStatement("INSERT INTO likes (post_id, username) VALUES (?, ?)");
        pstmt.setInt(1, postId);
        pstmt.setString(2, username);
        pstmt.executeUpdate();
        
        response.sendRedirect("board.jsp"); // 성공 시 게시판 페이지로 리다이렉트
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
        
    }
%>
