<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 쓰기</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label, input, textarea {
            display: block;
            margin-bottom: 10px;
        }
        input[type="file"], input[type="text"], textarea {
            width: 100%;
            padding: 8px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            display: block;
            margin-top: 10px;
            text-align: center;
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function validateForm() {
            var fileInput = document.getElementById('file');
            // 파일 선택 여부 확인
            if (fileInput.files.length === 0) {
                // 파일을 선택하지 않은 경우
                return confirm('파일을 첨부하지 않고 업로드하시겠습니까?');
            }
            // 추가적인 유효성 검사를 원하면 여기에 추가할 수 있음
            return true;
        }
    </script>
</head>
<body>
    <h1>글 쓰기</h1>
    <form action="uploadFile.jsp" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <label for="file">파일 선택:</label>
        <input type="file" id="file" name="file"><br>
        <label for="title">제목:</label>
        <input type="text" id="title" name="title"><br>
        <label for="content">내용:</label>
        <textarea id="content" name="content" rows="5"></textarea><br>
        <input type="submit" value="업로드">
    </form>
    <!-- 게시판 목록으로 돌아가는 링크 -->
    <a href="board.jsp">목록으로</a>
</body>
</html>
