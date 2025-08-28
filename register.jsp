<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String userType = request.getParameter("userType");
    String qualification = request.getParameter("qualification");

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
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@//192.168.0.100:1521", "SYSTEM", "a12345"
        );

        String sql = "INSERT INTO webusers (name, email, password, user_type, qualification) VALUES (?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, hashedPassword);
        ps.setString(4, userType);
        ps.setString(5, qualification);

        int result = ps.executeUpdate();

        if (result > 0) {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Registration successful! Redirecting to login page...');");
                    out.println("window.location.href = 'login.html';");
                    out.println("</script>");
                } else {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Registration failed. Please try again.');");
                    out.println("window.location.href = 'register.html';");
                    out.println("</script>");
                }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>