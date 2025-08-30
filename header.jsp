<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header class="header">
        <div class="logo">
            <a href="index.jsp">MyLogo</a>
        </div>

        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="login.jsp">Sign In</a>
            <a href="signup.jsp">Sign Up</a>
        </nav>

        <form action="search.jsp" method="get" class="search-bar">
            <input type="text" name="query" placeholder="Search..." required>
            <button type="submit">🔍</button>
        </form>
    </header>
</body>
</html>