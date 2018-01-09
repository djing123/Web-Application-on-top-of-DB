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
                            "INSERT INTO Classes VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Course_Number"));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("Section_id")));
                        pstmt.setString(3, request.getParameter("Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Year")));
                       pstmt.setString(5, request.getParameter("Title"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("Enrollment_Limit")));
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
                            "UPDATE Classes SET Course_Number = ?, Quarter = ?, " +
                            "Year = ?, Title = ?, Enrollment_Limit = ? WHERE Section_id = ?");

                        pstmt.setString(1, request.getParameter("Course_Number"));
                        pstmt.setString(2, request.getParameter("Quarter"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("Year")));
                        pstmt.setString(4, request.getParameter("Title"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("Enrollment_Limit")));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("Section_id")));
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
                            "DELETE FROM Classes WHERE  Section_id= ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("Section_id")));
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
                        ("SELECT * FROM Classes");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>CLASSES</tr>
                    <tr>
                        <th>Course_Number</th>
                        <th>Section_id</th>
                        <th>Quarter</th>
			            <th>Year</th>
                        <th>Title</th>
                        <th>Enrollment_Limit</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course_Number" size="10"></th>
                            <th><input value="" name="Section_id" size="10"></th>
                            <th><select name="Quarter">
                                <option value="Fall">Fall</option>
                                <option value="Winter">Winter</option>
                                <option value="Spring">Spring</option>                                
                                <option value="Summer 1">Summer 1</option>
                                <option value="Summer 2">Summer 2</option> 			                
                            </select></th>
                            <th><input value="" name="Year" size="15"></th>
                            <th><input value="" name="Title" size="15"></th>
                            <th><input value="" name="Enrollment_Limit" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Course_Number, which is a string --%>
                            <td>
                                <input value="<%= rs.getString("Course_Number") %>" 
                                    name="Course_Number" size="10">
                            </td>
    
                            <%-- Get the section_ID --%>
                            <td>
                                <input value="<%= rs.getInt("Section_id") %>" 
                                    name="Section_id" size="10">
                            </td>
    
                            <%-- Get the  Quarter--%>
                            <td>
                                <input value="<%= rs.getString("Quarter") %>"
                                    name="Quarter" size="15">
                            </td>
    
                            <%-- Get the Year --%>
                            <td>
                                <input value="<%= rs.getInt("Year") %>" 
                                    name="Year" size="15">
                            </td>
    
			                <%-- Get the Title --%>
                            <td>
                                <input value="<%= rs.getString("Title") %>" 
                                    name="Title" size="15">
                            </td>

                            <%-- Get the Enrollment_Limit --%>
                            <td>
                                <input value="<%= rs.getInt("Enrollment_Limit") %>" 
                                    name="Enrollment_Limit" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("Section_id") %>" name="Section_id">
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
