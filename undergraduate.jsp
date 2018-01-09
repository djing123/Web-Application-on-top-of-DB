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
                            "INSERT INTO Undergraduate VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Major"));
                        pstmt.setString(2, request.getParameter("Minor"));
                        pstmt.setString(3, request.getParameter("College"));
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
                            "UPDATE Undergraduate SET MAJOR = ?, MINOR = ?, " +
                            "COLLEGE = ?  WHERE Student_ID = ?");

                        pstmt.setString(1, request.getParameter("Major"));
                        pstmt.setString(2, request.getParameter("Minor"));
                        pstmt.setString(3, request.getParameter("College"));
                        pstmt.setString(4, request.getParameter("Student_ID"));

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
                            "DELETE FROM Undergraduate WHERE Student_ID = ?");

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
                        ("SELECT * FROM Undergraduate");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>UNDERGRADUATE</tr>
                    <tr>
                        <th>Major</th>
                        <th>Minor</th>
                        <th>College</th>
                        <th>Student_ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="undergraduate.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Major" size="10"></th>
                            <th><input value="" name="Minor" size="10"></th>
                            <th><select name="College">
                                <option value="Revelle">Revelle</option>
                                <option value="John Muir">John Muir</option>
                                <option value="Thurgood Marshall">hurgood Marshall</option>                                 
                                <option value="Earl Warren">Earl Warren</option>
                                <option value="Eleanor Roosevelt">Eleanor Roosevelt</option>                             
                                <option value="Sixth">Sixth</option>
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
                        <form action="undergraduate.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Major, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Major") %>" 
                                    name="Major" size="10">
                            </td>
    
                            <%-- Get the Minor --%>
                            <td>
                                <input value="<%= rs.getString("Minor") %>" 
                                    name="Minor" size="10">
                            </td>
    
                            <%-- Get the College --%>
                            <td>
                                <input value="<%= rs.getString("College") %>"
                                    name="College" size="15">
                            </td>
    
                            <%-- Get the Student_ID --%>
                            <td>
                                <input value="<%= rs.getString("Student_ID") %>" 
                                    name="Student_ID" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="undergraduate.jsp" method="get">
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