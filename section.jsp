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
                            "INSERT INTO Section VALUES (?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.setString(2, request.getParameter("Lecture"));
                        pstmt.setString(3, request.getParameter("Discussion"));
                        pstmt.setString(4, request.getParameter("Lab"));
                        pstmt.setString(5, request.getParameter("Faculty"));
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
                            "UPDATE Section SET Lecture = ?, Discussion = ?, " +
                            "Lab = ?, Faculty = ? WHERE Section_ID = ?");

                        pstmt.setString(1, request.getParameter("Lecture"));
                        pstmt.setString(2, request.getParameter("Discussion"));
                        pstmt.setString(3, request.getParameter("Lab"));
                        pstmt.setString(4, request.getParameter("Faculty"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("Section_ID")));

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
                            "DELETE FROM Section WHERE Section_ID = ?");

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
                        ("SELECT * FROM Section");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>SECTION</tr>
                    <tr>
                        <th>Section_ID</th>
                        <th>Lecture</th>
                        <th>Discussion</th>
			            <th>Lab</th>
                        <th>Faculty</th>
                        <th>Action</th>

                    </tr>
                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_ID" size="10"></th>
                            <th><select name="Lecture">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select></th>                            
                            <th><select name="Discussion">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select></th>			                
                            <th><select name="Lab">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select></th>         
                            <th><input value="" name="Faculty" size="10"></th>        
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Section_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("Section_ID") %>" 
                                    name="Section_ID" size="10">
                            </td>
    
                            <%-- Get the Lecture --%>
                            <td>
                                <input value="<%= rs.getString("Lecture") %>" 
                                    name="Lecture" size="10">
                            </td>
    
                            <%-- Get the Discussion --%>
                            <td>
                                <input value="<%= rs.getString("Discussion") %>"
                                    name="Discussion" size="15">
                            </td>
    
                            <%-- Get the Lab --%>
                            <td>
                                <input value="<%= rs.getString("Lab") %>" 
                                    name="Lab" size="15">
                            </td>

                            <%-- Get the Lab --%>
                            <td>
                                <input value="<%= rs.getString("Faculty") %>" 
                                    name="Faculty" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
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
