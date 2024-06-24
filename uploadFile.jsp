<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        
        String sql = "INSERT INTO posts (title, content, file_name) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, fileName);
        pstmt.executeUpdate();

        // 파일 업로드 처리 코드
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);
        
        response.sendRedirect("board.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("board.jsp");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
