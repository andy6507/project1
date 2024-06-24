<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*, org.apache.commons.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    PreparedStatement pstmt = null;

    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Part newFilePart = request.getPart("newFile");

        String fileName = null;
        String filePath = null;
        
        if (newFilePart != null && newFilePart.getSize() > 0) {
            fileName = newFilePart.getSubmittedFileName();
            filePath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + fileName;

            // 기존 파일 삭제
            pstmt = conn.prepareStatement("SELECT file_name FROM posts WHERE id = ?");
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String oldFileName = rs.getString("file_name");
                File oldFile = new File(getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + oldFileName);
                oldFile.delete();
            }
            
            // 새 파일 업로드
            newFilePart.write(filePath);
        } else {
            // 새 파일이 업로드되지 않은 경우 기존 파일 유지
            pstmt = conn.prepareStatement("SELECT file_name FROM posts WHERE id = ?");
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                fileName = rs.getString("file_name");
            }
        }
        pstmt = conn.prepareStatement("UPDATE posts SET title = ?, content = ?, file_name = ? WHERE id = ?");
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, fileName);
        pstmt.setInt(4, id);
        pstmt.executeUpdate();
        
        response.sendRedirect("board.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
