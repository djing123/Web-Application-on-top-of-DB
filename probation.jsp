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
                            "INSERT INTO Probation VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Incident_ID"));
                        pstmt.setString(2, request.getParameter("Period"));
                        pstmt.setString(3, request.getParameter("Reason"));
                        pstmt.setString(4, request.getParameter("Student_ID"));
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
                            "UPDATE Probation SET Period = ?, Reason = ?, " +
                            "Student_ID = ? WHERE Incident_ID = ?");

                        pstmt.setString(1, request.getParameter("Period"));
                        pstmt.setString(2, request.getParameter("Reason"));
                        pstmt.setString(3, request.getParameter("Student_ID"));
                        pstmt.setString(4, request.getParameter("Incident_ID"));

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
                            "DELETE FROM Probation WHERE Incident_ID = ?");

                        pstmt.setString(
                            1, request.getParameter("Incident_ID"));
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
                        ("SELECT * FROM Probation");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>PROBATION</tr>
                    <tr>
                        <th>Incident_ID</th>
                        <th>Period</th>
                        <th>Reason</th>
			            <th>Student_ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Incident_ID" size="10"></th>
                            <th><input value="" name="Period" size="10"></th>
                            <th><input value="" name="Reason" size="15"></th>
			                <th><input value="" name="Student_ID" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Incident_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Incident_ID") %>" 
                                    name="Incident_ID" size="10">
                            </td>
    
                            <%-- Get the Period --%>
                            <td>
                                <input value="<%= rs.getString("Period") %>" 
                                    name="Period" size="10">
                            </td>
    
                            <%-- Get the Reason --%>
                            <td>
                                <input value="<%= rs.getString("Reason") %>"
                                    name="Reason" size="15">
                            </td>
    
                            <%-- Get the Student_id --%>
                            <td>
                                <input value="<%= rs.getString("Student_ID") %>" 
                                    name="Student_ID" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Incident_ID") %>" name="Incident_ID">
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