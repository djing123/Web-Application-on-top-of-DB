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
    "SELECT DISTINCT a1.section_id AS SECTION_ID1, b1.section_id AS SECTION_ID2, c1.course_number AS COURSE1, c1.title AS TITLE1, d1.course_number AS COURSE2, d1.title AS TITLE2 "+
    "FROM schedule a1, schedule b1, classes c1, classes d1 "+
    "WHERE a1.section_id IN "+
    "( "+
      "SELECT cls.section_id "+
      "FROM classes cls "+
      "WHERE cls.section_id NOT IN "+
      "( "+
        "SELECT ce.section_id "+
        "FROM courseenrollment ce "+
        "WHERE ce.student_id = ? AND ce.year = 2017 AND ce.quarter = 'Spring' "+
      ") AND cls.quarter = 'Spring' AND cls.year = 2017 "+
    ") "+
    "AND b1.section_id IN "+
    "( "+
      "SELECT ce.section_id "+
      "FROM courseenrollment ce "+
      "WHERE ce.student_id = ? AND ce.year = 2017 AND ce.quarter = 'Spring' "+
    ") "+
    "AND a1.section_id <> b1.section_id AND a1.date = b1.date AND a1.time = b1.time " + 
    "AND c1.section_id = a1.section_id AND d1.section_id = b1.section_id "
                        );
                        pstmt.setString(1, request.getParameter("ID"));
                        pstmt.setString(2, request.getParameter("ID"));
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
                        <form action="2a.jsp" method="get">
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
                <table border="0"><th><font face = "Arial Black" size = "4">Class Cant Be Took</font></th></table>
                <table border="1">
                    <tr>
                       
                        <th>SECTION_ID1</th>
                        <th>COURSE1</th>
                        <th>TITLE1</th>
                        <th>SECTION_ID2</th>
                        <th>COURSE2</th>
                        <th>TITLE2</th>
                    </tr>
            <%
                    while ( rs1.next() ) {      
            %>
                    <tr>

                            <%-- Get the SECTION_ID1, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs1.getInt("SECTION_ID1") %>" 
                                    name="SECTION_ID1" size="10" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs1.getString("COURSE1") %>" 
                                    name="COURSE1" size="10" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs1.getString("TITLE1") %>" 
                                    name="TITLE1" size="10" readonly>
                            </td>

                            <%-- Get the SECTION_ID2, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs1.getInt("SECTION_ID2") %>" 
                                    name="SECTION_ID2" size="10" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs1.getString("COURSE2") %>" 
                                    name="COURSE2" size="10" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs1.getString("TITLE2") %>" 
                                    name="TITLE2" size="10" readonly>
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