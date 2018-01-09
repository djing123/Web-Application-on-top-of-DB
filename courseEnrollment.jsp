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
                            "INSERT INTO courseEnrollment VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Student_ID"));
                        pstmt.setString(2, request.getParameter("Course"));
                        pstmt.setString(3, request.getParameter("Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("Unit")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("Year")));
                        pstmt.setString(7, request.getParameter("Grade_Option"));
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
                            "UPDATE courseEnrollment SET Course = ?, Quarter = ?, Year = ? " +
                            ", Unit = ? , Grade_Option = ? WHERE Student_ID = ? AND Section_ID = ?");

                        pstmt.setString(1, request.getParameter("Course"));
                        pstmt.setString(2, request.getParameter("Quarter"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("Year")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Unit")));
                        pstmt.setString(5, request.getParameter("Grade_Option"));
                        pstmt.setString(6, request.getParameter("Student_ID"));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("Section_ID")));

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
                            "DELETE FROM courseEnrollment WHERE Student_ID = ? AND Section_ID = ?");

                        pstmt.setString(1, request.getParameter("Student_ID"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Section_ID")));
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
                        ("SELECT * FROM courseEnrollment");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>COURSE ENROLLMENT</tr>
                    <tr>
                        <th>Student_ID</th>
                        <th>Course</th>
                        <th>Quarter</th>
                        <th>Section_ID</th>
                        <th>Unit</th>
                        <th>Year</th>
                        <th>Grade_Option</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courseEnrollment.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Student_ID" size="15"></th>
                            <th><input value="" name="Course" size="15"></th>                            
                            <th><select name="Quarter">
                                <option value="Fall">Fall</option>
                                <option value="Winter">Winter</option>
                                <option value="Spring">Spring</option>                                
                                <option value="Summer 1">Summer 1</option>
                                <option value="Summer 2">Summer 2</option> 
                            </select></th>                           
                            <th><input value="" name="Section_ID" size="15"></th>
                            <th><select name="Unit">
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>                                
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select></th> 
                            <th><input value="" name="Year" size="15"></th> 
                            <th><select name="Grade_Option">
                                <option value="Letter">Letter</option>
                                <option value="S/U">S/U</option>
                                <option value="P/NP">P/NP</option>                                
                            </select></th>                
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courseEnrollment.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Student_ID --%>
                            <td>
                                <input value="<%= rs.getString("Student_ID") %>"
                                    name="Student_ID" size="15">
                            </td>
    
                            <%-- Get the Course --%>
                            <td>
                                <input value="<%= rs.getString("Course") %>" 
                                    name="Course" size="15">
                            </td>
                            <%-- Get the Quarter --%>
                            <td>
                                <input value="<%= rs.getString("Quarter") %>" 
                                    name="Quarter" size="15">
                            </td>

                            <%-- Get the Section_ID --%>
                            <td>
                                <input value="<%= rs.getInt("Section_ID") %>" 
                                    name="Section_ID" size="15">
                            </td>

                            <%-- Get the Unit --%>
                            <td>
                                <input value="<%= rs.getInt("Unit") %>" 
                                    name="Unit" size="15">
                            </td>

                            <%-- Get the Year --%>
                            <td>
                                <input value="<%= rs.getInt("Year") %>" 
                                    name="Year" size="15">
                            </td>

                            <%-- Get the grade_option --%>
                            <td>
                                <input value="<%= rs.getString("Grade_Option") %>" 
                                    name="Grade_Option" size="15">
                            </td>


                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courseEnrollment.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Student_ID") %>" name="Student_ID">
                            <input type="hidden" 
                                value="<%= rs.getInt("Section_ID") %>" name="Section_ID">
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