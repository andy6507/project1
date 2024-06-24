<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>

<%

String username = (String) session.getAttribute("username");


if (request.getParameter("logout") != null && request.getParameter("logout").equals("true")) {
    session.invalidate(); 
    response.sendRedirect("login.jsp");
    return; 
}


if (username == null) {
    response.sendRedirect("login.jsp");
    return; 
}

PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    pstmt = conn.prepareStatement("SELECT * FROM posts");
    rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        a {
            text-decoration: none;
            color: #007bff;
        }
        a:hover {
            text-decoration: underline;
        }
        .logout-link {
            float: right;
            margin-top: 10px;
            margin-right: 20px;
        }
        .write-link {
            margin-top: 20px;
            display: inline-block;
            background-color: #007bff;
            color: #fff;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
        }
        .write-link:hover {
            background-color: #0056b3;
        }
         .comment-form {
            margin-top: 10px;
            padding: 10px;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
        }

        
        .comment-form {
            margin-top: 10px;
            padding: 10px;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
        }

        
        .comment-form button {
            padding: 6px 12px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .comment-form button:hover {
            background-color: #0056b3;
        }
        .username {
            float: right;
            margin-top: 15px;
            margin-right: 10px;
            font-weight: bold; 
        }
    </style>
</head>
<body>
    <h1>게시판</h1>
    <span class="username"><%= username %></span><br>
    <a href="?logout=true" class="logout-link">로그아웃</a>
    <a href="writePost.jsp" class="write-link">글 쓰기</a>
    <h2>게시물 목록</h2>
    <table>
        <tr>
            <th>제목</th>
            <th>내용</th>
            <th>첨부 파일</th>
            <th>수정</th>
            <th>삭제</th>
        </tr>
        <% while(rs.next()) { %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("content") %></td>
                <td><a href="downloadFile.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("file_name") %></a></td>
                <td><a href="editPost.jsp?id=<%= rs.getInt("id") %>">수정</a></td>
                <td><a href="deletePost.jsp?id=<%= rs.getInt("id") %>">삭제</a></td><br>
                <td>
                <% 
                    boolean liked = false;                    
                    PreparedStatement pstmt_likes = null;
                    ResultSet rs_likes = null;
                    try {
                        pstmt_likes = conn.prepareStatement("SELECT * FROM likes WHERE post_id = ? AND username = ?");
                        pstmt_likes.setInt(1, rs.getInt("id"));
                        pstmt_likes.setString(2, username);
                        rs_likes = pstmt_likes.executeQuery();
                        
                        liked = rs_likes.next(); 
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs_likes != null) rs_likes.close();
                        if (pstmt_likes != null) pstmt_likes.close();
                    }
                %>
                <% if (liked) { %>
                    <a href="unlike.jsp?id=<%= rs.getInt("id") %>">좋아요 해제</a>
                <% } else { %>
                    <a href="like.jsp?id=<%= rs.getInt("id") %>">좋아요</a>
                <% } %>
                </td>
            </tr>

  
        <% 
        
        PreparedStatement pstmt_comments = null;
        ResultSet rs_comments = null;
        try {
            pstmt_comments = conn.prepareStatement("SELECT * FROM comments WHERE post_id = ?");
            pstmt_comments.setInt(1, rs.getInt("id"));
            rs_comments = pstmt_comments.executeQuery();

            while (rs_comments.next()) {
        %>
                <tr>
                    <td colspan="5"><%= rs_comments.getString("comment_text") %></td>
                    <td><a href="deleteComment.jsp?id=<%= rs_comments.getInt("comment_id") %>">삭제</a></td>
                </tr>
            <% }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs_comments != null) rs_comments.close();
            if (pstmt_comments != null) pstmt_comments.close();
        }
        %>
        <tr>
                <td colspan="5">
                    <form action="addComment.jsp" method="post">
                        <input type="hidden" name="post_id" value="<%= rs.getInt("id") %>">
                        <input type="text" name="comment_text" placeholder="댓글을 입력하세요">
                        <button type="submit">댓글 추가</button>
                    </form>
                </td>
            </tr>    
        <% } %>
    </table>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
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
