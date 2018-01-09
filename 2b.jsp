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
                ResultSet rs2 = null;
                ResultSet rs3 = null;
                ResultSet rs4 = null;
                ResultSet rs5 = null;
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

                        PreparedStatement pstmt1 = conn.prepareStatement(
      "SELECT d.day_time AS VALID_TIME "+
      "FROM daily d "+
      "WHERE d.day_time NOT IN "+
      "( "+
        "SELECT sc.time "+
        "FROM schedule sc "+
        "WHERE sc.section_id IN "+
        "( "+
          "SELECT ec.section_id "+
          "FROM courseenrollment ec, courseenrollment ec1 "+
          "WHERE ec.year = 2017 AND ec.quarter = 'Spring' AND ec1.section_id = ? "+
          "AND ec1.year = 2017 AND ec1.quarter = 'Spring' AND ec.student_id = ec1.student_id "+
        ") "+ 
        "AND sc.date = 'Monday' " + 
      ")" );
                        pstmt1.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        rs1 = pstmt1.executeQuery();

                        
                        PreparedStatement pstmt2 = conn.prepareStatement(
      "SELECT d.day_time AS VALID_TIME "+
      "FROM daily d "+
      "WHERE d.day_time NOT IN "+
      "( "+
        "SELECT sc.time "+
        "FROM schedule sc "+
        "WHERE sc.section_id IN "+
        "( "+
          "SELECT ec.section_id "+
          "FROM courseenrollment ec, courseenrollment ec1 "+
          "WHERE ec.year = 2017 AND ec.quarter = 'Spring' AND ec1.section_id = ? "+
          "AND ec1.year = 2017 AND ec1.quarter = 'Spring' AND ec.student_id = ec1.student_id "+
        ") "+ 
        "AND sc.date = 'Tuesday' " + 
      ")" );
                        pstmt2.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        rs2 = pstmt2.executeQuery();                       
 

                        PreparedStatement pstmt3 = conn.prepareStatement(
      "SELECT d.day_time AS VALID_TIME "+
      "FROM daily d "+
      "WHERE d.day_time NOT IN "+
      "( "+
        "SELECT sc.time "+
        "FROM schedule sc "+
        "WHERE sc.section_id IN "+
        "( "+
          "SELECT ec.section_id "+
          "FROM courseenrollment ec, courseenrollment ec1 "+
          "WHERE ec.year = 2017 AND ec.quarter = 'Spring' AND ec1.section_id = ? "+
          "AND ec1.year = 2017 AND ec1.quarter = 'Spring' AND ec.student_id = ec1.student_id "+
        ") "+ 
        "AND sc.date = 'Wednesday' " + 
      ")" );
                        pstmt3.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        rs3 = pstmt3.executeQuery();  



                        PreparedStatement pstmt4 = conn.prepareStatement(
      "SELECT d.day_time AS VALID_TIME "+
      "FROM daily d "+
      "WHERE d.day_time NOT IN "+
      "( "+
        "SELECT sc.time "+
        "FROM schedule sc "+
        "WHERE sc.section_id IN "+
        "( "+
          "SELECT ec.section_id "+
          "FROM courseenrollment ec, courseenrollment ec1 "+
          "WHERE ec.year = 2017 AND ec.quarter = 'Spring' AND ec1.section_id = ? "+
          "AND ec1.year = 2017 AND ec1.quarter = 'Spring' AND ec.student_id = ec1.student_id "+
        ") "+ 
        "AND sc.date = 'Thursday' " + 
      ")" );
                        pstmt4.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        rs4 = pstmt4.executeQuery();  



                        PreparedStatement pstmt5 = conn.prepareStatement(
      "SELECT d.day_time AS VALID_TIME "+
      "FROM daily d "+
      "WHERE d.day_time NOT IN "+
      "( "+
        "SELECT sc.time "+
        "FROM schedule sc "+
        "WHERE sc.section_id IN "+
        "( "+
          "SELECT ec.section_id "+
          "FROM courseenrollment ec, courseenrollment ec1 "+
          "WHERE ec.year = 2017 AND ec.quarter = 'Spring' AND ec1.section_id = ? "+
          "AND ec1.year = 2017 AND ec1.quarter = 'Spring' AND ec.student_id = ec1.student_id "+
        ") "+ 
        "AND sc.date = 'Friday' " + 
      ")" );
                        pstmt5.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        rs5 = pstmt5.executeQuery();  





                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn.createStatement();
                students = s1.executeQuery("SELECT  c.section_id AS Section_ID, c.course AS COURSE FROM " +
                "courseenrollment c ");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="0"><th><font face = "Arial Black" size = "4">Schedule A Review Session</font></th></table>
                <table border="1">
                    <tr>
                        <th>Info</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="2b.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><name="Section_ID" size="20">
                            <select name = "Section_ID">
                                <% 
                                    while ( students.next() ){
                                %>
                                     <option value="<%= students.getString("Section_ID") %>"><%= students.getString("Section_ID") %> | <%= students.getString("COURSE") %></option>
                                <%
                                    }
                                %>

                            <th><input type="submit" value="search"></th>
                        </form>
                    </tr>    
                </table>          

            <%-- -------- Iteration Code -------- --%>
            <%

                if(rs1 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Possible Time At Monday</font></th></table>
                <table border="1">
                    <tr>
                        <th>VALID_TIME</th>
                    </tr>
            <%
                    while ( rs1.next() ) {      
            %>
                    <tr>

                            <%-- Get the VALID_TIME, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("VALID_TIME") %>" 
                                    name="VALID_TIME" size="10" readonly>
                            </td>

                    </tr>
                
            <%
                    }
            %>
            </table>
            <%
                }
            %>


                        <%

                if(rs2 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Possible Time At Tuesday</font></th></table>
                <table border="1">
                    <tr>
                        <th>VALID_TIME</th>
                    </tr>
            <%
                    while ( rs2.next() ) {      
            %>
                    <tr>

                            <%-- Get the VALID_TIME, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("VALID_TIME") %>" 
                                    name="VALID_TIME" size="10" readonly>
                            </td>

                    </tr>
                
            <%
                    }
            %>
            </table>
            <%
                }
            %>


                        <%

                if(rs3 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Possible Time At Wednesday</font></th></table>
                <table border="1">
                    <tr>
                        <th>VALID_TIME</th>
                    </tr>
            <%
                    while ( rs3.next() ) {      
            %>
                    <tr>

                            <%-- Get the VALID_TIME, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs3.getString("VALID_TIME") %>" 
                                    name="VALID_TIME" size="10" readonly>
                            </td>

                    </tr>
                
            <%
                    }
            %>
            </table>
            <%
                }
            %>


                        <%

                if(rs4 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Possible Time At Thursday</font></th></table>
                <table border="1">
                    <tr>
                        <th>VALID_TIME</th>
                    </tr>
            <%
                    while ( rs4.next() ) {      
            %>
                    <tr>

                            <%-- Get the VALID_TIME, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs4.getString("VALID_TIME") %>" 
                                    name="VALID_TIME" size="10" readonly>
                            </td>

                    </tr>
                
            <%
                    }
            %>
            </table>
            <%
                }
            %>


                        <%

                if(rs5 != null){
            %>
                <table border="0"><th><font face = "Arial Black" size = "4">Possible Time At Friday</font></th></table>
                <table border="1">
                    <tr>
                        <th>VALID_TIME</th>
                    </tr>
            <%
                    while ( rs5.next() ) {      
            %>
                    <tr>

                            <%-- Get the VALID_TIME, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs5.getString("VALID_TIME") %>" 
                                    name="VALID_TIME" size="10" readonly>
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
                    if (rs2!=null)
                        rs2.close();
                    if (rs3!=null)
                        rs3.close();
                    if (rs4!=null)
                        rs4.close();
                    if (rs5!=null)
                        rs5.close();
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