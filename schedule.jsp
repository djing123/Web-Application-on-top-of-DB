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
                            "INSERT INTO Schedule VALUES (?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.setString(2, request.getParameter("Kind"));
                        pstmt.setString(3, request.getParameter("Date"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Time")));
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
                            "UPDATE schedule SET Kind = ?, Date = ? " +
                            "Time = ? WHERE Section_ID = ?");

                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.setString(1, request.getParameter("Kind"));
                        pstmt.setString(2, request.getParameter("Date"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("Time")));
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
                            "DELETE FROM Schedule WHERE Section_ID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
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
                        ("SELECT * FROM Schedule");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>SCHEDULE</tr>
                    <tr>
                        <th>Section_ID</th>
                        <th>Kind</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="schedule.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_ID" size="10"></th>
                            <th><select name="Kind">
                                <option value="Letture">Letture</option>
                                <option value="Discussion">Discussion</option>
                                <option value="Lab">Lab</option>                                                 
                            </select></th>
                            <th><select name="Date">
                                <option value="Monday">Monday</option>
                                <option value="Tuesday">Tuesday</option>
                                <option value="Wednesday">Wednesday</option>                                
                                <option value="Thursday">Thursday</option>
                                <option value="Friday">Friday</option>                           
                            </select></th>
                            <th><input value="" name="Time" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="schedule.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Section_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("Section_ID") %>" 
                                    name="Section_ID" size="10">
                            </td>
    
                            <%-- Get the Kind --%>
                            <td>
                                <input value="<%= rs.getString("Kind") %>" 
                                    name="Kind" size="10">
                            </td>
    
                            <%-- Get the Date --%>
                            <td>
                                <input value="<%= rs.getString("Date") %>" 
                                    name="Date" size="15">
                            </td>

                            <%-- Get the Time --%>
                            <td>
                                <input value="<%= rs.getInt("Time") %>" 
                                    name="Time" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="schedule.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Section_ID") %>" name="Section_ID">
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
