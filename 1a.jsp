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
                Connection conn = null;
                Statement s1 = null;
                ResultSet rs1 = null;
                ResultSet students = null;

                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
                    conn = DriverManager.getConnection(dbURL);

            %>


            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    if (action != null && action.equals("search")) {

                        conn.setAutoCommit(false);

                        PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT e.course AS COURSE, e.quarter AS QUARTER, e.year AS YEAR, e.unit AS UNITS, e.section_id AS SECTION_ID " + 
                            "FROM student s, courseenrollment e WHERE s.id = ? " + 
                            "AND s.id = e.student_id AND e.quarter = 'Spring' AND e.year = 2017");
                        pstmt.setString(1, request.getParameter("ID"));
                        rs1 = pstmt.executeQuery();

                        
                        
                        
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn.createStatement();
                students = s1.executeQuery("SELECT DISTINCT s.id, s.firstname, s.middlename AS middlename, s.lastname FROM student s, courseenrollment e WHERE s.id = e.student_id");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="0"><th><font face = "Arial Black" size = "4">Currently Taken</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="1a.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><name="ID" size="20">
                            <select name = "ID">
                                <% 
                                    while ( students.next() ){
                                %>
                                     <option value=<%= students.getString("id") %>><%= students.getString("id") %> | <%= students.getString("FIRSTNAME") %>, <%= students.getString("MIDDLENAME") %>, <%= students.getString("LASTNAME") %></option>
                                <%
                                    }
                                %>
                                 
                            </select></th>
                            <th><input type="submit" value="search"></th>
                        </form>
                    </tr>     
                </table>          

            <%-- -------- Iteration Code -------- --%>
            <%

                if(rs1 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Current Class</font></th></table>
                <table border="1">
                    <tr>
                        <th>COURSE</th>
                        <th>QUARTER</th>
                        <th>YEAR</th>
                        <th>UNITS</th>
                        <th>SECTION_ID</th>
                    </tr>
            <%
                    while ( rs1.next() ) {      
            %>
                    <tr>

                            <%-- Get the COURSE, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("COURSE") %>" 
                                    name="COURSE" size="10" readonly>
                            </td>

                            <%-- Get the QUARTER --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("QUARTER") %>"
                                    name="QUARTER" size="15" readonly>
                            </td>
    
                            <%-- Get the YEAR --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("YEAR") %>" 
                                    name="YEAR" size="15" readonly>
                            </td>
    
                            <%-- Get the UNITS --%>
                            <td align="middle" >
                                <input value="<%= rs1.getString("UNITS") %>" 
                                    name="UNITS" size="15" readonly>
                            </td>

                            <%-- Get the SECTION_ID --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("SECTION_ID") %>" 
                                    name="SECTION_ID" size="15" readonly>
                            </td>

                    </tr>
                
            <%
                    }
            %>
            </table>
            <%
                }
            %>


            <%-- -------- Close Connection Code -------- --%>
            <%
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                } finally{
                    if (rs1!=null)
                        rs1.close();
                    if (students!=null)
                        students.close();
                    if(s1!=null)
                        s1.close();
                    if(conn!=null)
                        conn.close();
                }
            %>

</body>

</html>