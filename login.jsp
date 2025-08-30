<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if(email != null && password != null) {
        // Hash the password using SHA-256
        String hashedPassword = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for(byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            hashedPassword = sb.toString();
        } catch(NoSuchAlgorithmException e) {
            out.println("<script>alert('Error hashing password'); window.location='login.html';</script>");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@//192.168.0.100", "SYSTEM", "a12345"
            );

            String sql = "SELECT user_type FROM users WHERE email=? AND password=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            rs = ps.executeQuery();

            if(rs.next()) {
                String userType = rs.getString("user_type");

                if("Student".equalsIgnoreCase(userType)) {
                    out.println("<script>alert('Login successful! Redirecting to Student Dashboard'); window.location='student_dashboard.jsp';</script>");
                } else if("Tutor".equalsIgnoreCase(userType)) {
                    out.println("<script>alert('Login successful! Redirecting to Teacher Dashboard'); window.location='teacher_dashboard.jsp';</script>");
                } else {
                    // Just in case
                    out.println("<script>alert('Login successful!'); window.location='dashboard.jsp';</script>");
                }
            } else {
                // Login failed
                out.println("<script>alert('Invalid email or password!'); window.location='login.html';</script>");
            }
        } catch(Exception e) {
            out.println("<script>alert('Error: "+ e.getMessage() +"'); window.location='login.html';</script>");
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception ignored) {}
            try { if(ps != null) ps.close(); } catch(Exception ignored) {}
            try { if(conn != null) conn.close(); } catch(Exception ignored) {}
        }
    }
%>
