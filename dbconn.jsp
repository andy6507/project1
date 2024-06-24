<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/boardDB";
    String user = "root";
    String password = "1234";

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        application.setAttribute("connection", conn);
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        throw new RuntimeException("데이터베이스 연결 오류: " + e.getMessage());
    }
%>
