<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    // Declare variables here so they are visible everywhere
    String message = null;
    String redirectPage = null;

    // Handle form submission only if request method is POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
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
            message = "Error hashing password.";
            redirectPage = "register.jsp";
        }

        if (hashedPassword != null) {
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                Class.forName("oracle.jdbc.OracleDriver");
                conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@//192.168.0.100", "SYSTEM", "a12345"
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
                    message = "Registration successful!";
                    redirectPage = "login.jsp";
                } else {
                    message = "Registration failed. Please try again.";
                    redirectPage = "register.jsp";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                redirectPage = "register.jsp";
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <link rel="stylesheet" href="style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<body>
<%-- <%@ include file="header.jsp" %> --%>

    <% if (message != null) { %>
        <div class="message-box <%= (message.contains("successful")) ? "success" : "error" %>">
            <p><%= message %></p>
            <form action="<%= redirectPage %>" method="get">
                <button class="btn-ok" type="submit">OK</button>
            </form>
        </div>
    <% } %>

    <div class="container">
        <h2>Register</h2>
        <form action="register.jsp" method="post" onsubmit="return validateForm()">
            
            <label for="name">Full Name</label>
            <input type="text" name="name" required>

            <label for="email">Email</label>
            <input type="email" name="email" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
            <input type="checkbox" onclick="password.type=this.checked?'text':'password'"> Show Password

            <label for="userType">User Type</label>
            <select name="userType" id="userType" required>
                <option value="">-- Select User Type --</option>
                <option value="Student">Student</option>
                <option value="Tutor">Tutor</option>
            </select>

            <label for="qualification">Last Education Qualification</label>
            <select name="qualification" id="qualification" required>
                <option value="">-- Select Qualification --</option>
                <option value="Masters">Masters</option>
                <option value="Undergraduation">Undergraduation</option>
                <option value="HSC">HSC</option>
                <option value="SSC">SSC</option>
                <option value="Below SSC">Below SSC</option>
            </select>

            <button type="submit">Register</button>
        </form>
    </div>

    <script>
        function validateForm() {
            const userType = document.getElementById("userType").value;
            const qualification = document.getElementById("qualification").value;

            // Tutor must have more than HSC
            if (userType === "Tutor" && (qualification === "SSC" || qualification === "Below SSC" || qualification === "HSC")) {
                alert("A Tutor must have education qualification above HSC (Undergraduation or Masters).");
                return false; // Prevent form submission
            }
            return true;
        }
    </script>
</body>
</html>