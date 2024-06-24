<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="dbconn.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 400px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button[type="submit"] {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-top: 10px;
            text-align: center;
        }
        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>회원가입</h1>
    <form method="post" action="signup.jsp">
        <label for="username">사용자 이름:</label>
        <input type="text" id="username" name="username" required>
        <br>
        <label for="user_password">비밀번호:</label>
        <input type="password" id="user_password" name="user_password" required>
        <br>
        <button type="submit">가입</button>
        <%-- 중복 가입 에러 메시지 --%>
        <%
            String errorMessage = (String) request.getAttribute("error_message");
            if (errorMessage != null) {
        %>
        <p class="error-message"><%= errorMessage %></p>
        <%
            }
        %>
    </form>

    <%
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("user_password");

        if (newUsername != null && newPassword != null) {
            Connection dbConn = null;
            PreparedStatement pstmtCheck = null;

            try {
                dbConn = (Connection) application.getAttribute("connection");
                if (dbConn == null) {
                    throw new SQLException("데이터베이스 연결이 없습니다.");
                }

                // 사용자 이름 중복 확인
                String checkSql = "SELECT * FROM users WHERE username = ?";
                pstmtCheck = dbConn.prepareStatement(checkSql);
                pstmtCheck.setString(1, newUsername);
                ResultSet rs = pstmtCheck.executeQuery();

                if (rs.next()) {
                    // 이미 가입된 사용자일 경우
                    request.setAttribute("error_message", "이미 가입된 회원입니다.");
                } else {
                    // 가입 처리
                    String insertSql = "INSERT INTO users (username, password) VALUES (?, ?)";
                    PreparedStatement pstmtInsert = dbConn.prepareStatement(insertSql);
                    pstmtInsert.setString(1, newUsername);
                    pstmtInsert.setString(2, newPassword);
                    pstmtInsert.executeUpdate();

                    // 가입 성공 시 로그인 페이지로 이동
                    response.sendRedirect("login.jsp");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>오류: " + e.getMessage() + "</p>");
            } finally {
                try { if (pstmtCheck != null) pstmtCheck.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>
    <a href="login.jsp">이미 회원이신가요? 로그인하기</a>
</body>
</html>
