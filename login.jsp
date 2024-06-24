<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="dbconn.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
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
        .error-message {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h1>로그인</h1>
    <form method="post" action="login.jsp">
        <label for="username">사용자 이름:</label>
        <input type="text" id="username" name="username" required>
        <br>
        <label for="password">비밀번호:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <button type="submit">로그인</button>
        <div class="error-message">
            <%-- 에러 메시지 출력 부분 --%>
            <% 
                String loginUsername = request.getParameter("username");
                String loginPassword = request.getParameter("password");

                if (loginUsername != null && loginPassword != null) {
                    Connection dbConnLogin = null; 
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        dbConnLogin = (Connection) application.getAttribute("connection");
                        if (dbConnLogin == null || dbConnLogin.isClosed()) {
                            throw new SQLException("데이터베이스 연결이 없습니다.");
                        }

                        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                        pstmt = dbConnLogin.prepareStatement(sql);
                        pstmt.setString(1, loginUsername);
                        pstmt.setString(2, loginPassword);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            HttpSession userSession = request.getSession(); // 변수명을 session에서 userSession으로 변경
                            userSession.setAttribute("username", loginUsername);
                            response.sendRedirect("board.jsp");
                        } else {
                            out.println("<p>로그인 정보가 올바르지 않습니다. 다시 시도해 주세요.</p>");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<p>로그인 중 오류가 발생했습니다. 다시 시도해 주세요.</p>");
                    } finally {
                        // 리소스 정리
                        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            %>
        </div>
    </form>

    <a href="signup.jsp">아직 회원이 아니신가요? 회원가입하기</a>
</body>
</html>
