<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Phd VALUES (?, ?, ?)");
                        pstmt.setString(1, request.getParameter("Status"));
                        pstmt.setString(2, request.getParameter("Student_ID"));
                        pstmt.setString(3, request.getParameter("Faculty_Name"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Phd SET Status = ?, Faculty_Name = ? WHERE Student_ID = ?");

                        pstmt.setString(1, request.getParameter("Status"));
                        pstmt.setString(2, request.getParameter("Faculty_Name"));
                        pstmt.setString(3, request.getParameter("Student_ID"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Phd WHERE Student_ID = ?");

                        pstmt.setString(1, request.getParameter("Student_ID"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Phd");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>Phd</tr>
                    <tr>
                        <th>Status</th>
                        <th>Student_ID</th>
                        <th>Faculty_Name</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Phd.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Status" size="10"></th>
                            <th><input value="" name="Student_ID" size="15"></th>
                            <th><input value="" name="Faculty_Name" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Phd.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Status, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Status") %>" 
                                    name="Status" size="10">
                            </td>
                            <%-- Get the Student_ID --%>
                            <td>
                                <input value="<%= rs.getString("Student_ID") %>" 
                                    name="Student_ID" size="15">
                            </td>
                            <%-- Get the Faculty_Name --%>
                            <td>
                                <input value="<%= rs.getString("Faculty_Name") %>" 
                                    name="Faculty_Name" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Phd.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Student_ID") %>" name="Student_ID">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>