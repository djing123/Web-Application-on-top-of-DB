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
                            "INSERT INTO DEGREE VALUES (?, ?, ?)");

                        pstmt.setString(1, request.getParameter("Major"));
                        pstmt.setString(2, request.getParameter("Department"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("Total_Units")));
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
                            "UPDATE DEGREE SET Department = ?, Total_Units = ? WHERE Major = ?");

                        pstmt.setString(1, request.getParameter("Department"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Total_Units")));
                        pstmt.setString(3, request.getParameter("Major"));

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
                            "DELETE FROM DEGREE WHERE MAJOR = ?");

                        pstmt.setString(1, request.getParameter("Major"));
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
                        ("SELECT * FROM DEGREE");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>DEGREE</tr>
                    <tr>
                        <th>Major</th>
                        <th>Department</th>
                        <th>Total_Units</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Major" size="10"></th>
                            <th><input value="" name="Department" size="10"></th>
                            <th><input value="" name="Total_Units" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Major, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Major") %>" 
                                    name="Major" size="10">
                            </td>
    
                            <%-- Get the Department --%>
                            <td>
                                <input value="<%= rs.getString("Department") %>" 
                                    name="Department" size="10">
                            </td>
    
                            <%-- Get the Total_Units --%>
                            <td>
                                <input value="<%= rs.getInt("Total_Units") %>"
                                    name="Total_Units" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Major") %>" name="Major">
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