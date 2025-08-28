<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Hashing the password using SHA-256
    String hashedPassword = null;
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(password.getBytes());
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b));
        }
        hashedPassword = sb.toString();
    } catch (NoSuchAlgorithmException e) {
        out.println("Error hashing password.");
        return;
    }

    // Oracle DB connection
    Connection conn = null;
    PreparedStatement ps = null;

    try {
<<<<<<< HEAD
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@//192.168.0.100:1521", "SYSTEM", "a12345"
        );

        String sql = "INSERT INTO tusers (username, email, password) VALUES (?, ?, ?)";
=======
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@//192.168.1.50:1521/tuitionDB", "SYSTEM", "a12345"
        );

        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
>>>>>>> 597282772e67fc6b995af3a5b4d27ebf1dcab7f2
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, hashedPassword);

        int result = ps.executeUpdate();

        if (result > 0) {
            out.println("<h3>Registration successful!</h3>");
        } else {
            out.println("<h3>Registration failed.</h3>");
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
<<<<<<< HEAD
%>
=======
%>
>>>>>>> 597282772e67fc6b995af3a5b4d27ebf1dcab7f2
