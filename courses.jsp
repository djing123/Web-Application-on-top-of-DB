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
                            "INSERT INTO Courses VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Course_Number"));
                        pstmt.setString(2, request.getParameter("Department"));
                        pstmt.setString(3, request.getParameter("Lab"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Units")));
                        pstmt.setString(5, request.getParameter("Grade_Option"));
                        pstmt.setString(6, request.getParameter("Next_Offer"));
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
                            "UPDATE Courses SET Department = ?, Lab = ? " +
                            "Units = ?, Grade_Option = ?, Next_Offer = ? WHERE Course_Number = ?");

                        pstmt.setString(6, request.getParameter("Course_Number"));
                        pstmt.setString(1, request.getParameter("Department"));
                        pstmt.setString(2, request.getParameter("Lab"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("Units")));
                        pstmt.setString(4, request.getParameter("Grade_Option"));
                        pstmt.setString(5, request.getParameter("Next_Offer"));
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
                            "DELETE FROM Courses WHERE Course_Number = ?");

                        pstmt.setString(1, request.getParameter("Course_Number"));
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
                        ("SELECT * FROM Courses");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>COURSES</tr>
                    <tr>
                        <th>Course_Number</th>
                        <th>Department</th>
                        <th>Lab</th>
                        <th>Units</th>
                        <th>Grade_Option</th>
                        <th>Next_Offer</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course_Number" size="10"></th>
                            <th><input value="" name="Department" size="10"></th>
                            <th><select name="Lab">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select></th>
                            <th><select name="Units">
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>                                
                                <option value="3">3</option>
                                <option value="4">4</option>                           
                            </select></th>
                            <th><select name="Grade_Option">
                                <option value="Letter">Letter</option>
                                <option value="P/NP">P/NP</option>                                
                            </select></th>
                            <th><input value="" name="Next_Offer" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Course_Number, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Course_Number") %>" 
                                    name="Course_Number" size="10">
                            </td>
    
                            <%-- Get the Department --%>
                            <td>
                                <input value="<%= rs.getString("Department") %>" 
                                    name="Department" size="10">
                            </td>
    
                            <%-- Get the Lab --%>
                            <td>
                                <input value="<%= rs.getString("Lab") %>" 
                                    name="Lab" size="15">
                            </td>

                            <%-- Get the Units --%>
                            <td>
                                <input value="<%= rs.getInt("Units") %>" 
                                    name="Units" size="15">
                            </td>

                            <%-- Get the Grade_Option --%>
                            <td>
                                <input value="<%= rs.getString("Grade_Option") %>" 
                                    name="Grade_Option" size="15">
                            </td>
    
                            <%-- Get the Next_Offer --%>
                            <td>
                                <input value="<%= rs.getString("Next_Offer") %>" 
                                    name="Next_Offer" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Course_Number") %>" name="Course_Number">
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
