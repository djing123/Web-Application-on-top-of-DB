<html>
<body>

	<table border="1">
		<tr>
			<td valign="top">
				<jsp:include page="menu.html" />
			</td>
			<td>

			<%@ page language="java" import="java.sql.*" %>

			<%
				Statement s1 = null;
				Statement s2 = null;
				ResultSet rs1 = null;
				ResultSet rs2 = null;
				ResultSet students = null;
                ResultSet degrees = null;
				Connection conn1 = null;
                Connection conn2 = null;

				try {
					Class.forName("org.postgresql.Driver");
					String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
					conn1 = DriverManager.getConnection(dbURL);
                    conn2 = DriverManager.getConnection(dbURL);
				
			%>


			<%-- -------- INSERT Code -------- --%>
			<%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn1.setAutoCommit(false);
                        conn2.setAutoCommit(false);
                        
                        
                        PreparedStatement pstmt = conn1.prepareStatement(
                        "SELECT CONCENTRATION "+
                        "FROM (SELECT c.concentration_name AS CONCENTRATION, SUM(p.unit) AS UNIT_HAVE, AVG(gpa.number_grade) AS Curr_GPA " + 
                        "FROM concentration c, classestakeninpast p, concentration_course cc, master s, graduate g, grade_conversion gpa " +
                        "WHERE s.student_id = g.student_id AND s.student_id = p.student_id AND p.student_id = ? " +
                        "AND c.major = cc.major AND cc.major = g.major AND c.major = ? " +
                        "AND c.concentration_name = cc.concentration_name " +
                        "AND p.course = cc.course_name AND p.grade = gpa.letter_grade " + 
                        "GROUP BY c.concentration_name) AS COMPLETE, concentration x " +
                        "WHERE UNIT_HAVE >= x.units AND CONCENTRATION = x.concentration_name AND Curr_GPA >= CAST(x.GPA AS DECIMAL(9,2))");

                        
                        pstmt.setString(1, request.getParameter("ID"));
                        pstmt.setString(2, request.getParameter("NAME"));

                        rs1 = pstmt.executeQuery();


                        PreparedStatement pstmt2 = conn1.prepareStatement(
                        "SELECT DISTINCT cc.course_name AS COURSE, cc.concentration_name AS CONCENTRATION, a.next_offer AS NEXT_OFFERING " +
                        "FROM concentration_course cc, courses a " +
                        "WHERE cc.course_name = a.course_number AND cc.course_name NOT IN (SELECT p.course FROM classestakeninpast p, concentration_course xx, master s, graduate g " + 
                        "WHERE p.course = xx.course_name AND xx.concentration_name = cc.concentration_name AND xx.major = cc.major AND p.student_id = ? AND s.student_id = p.student_id AND g.student_id = p.student_id AND g.major = ? AND g.major = cc.major)");
/*
                        "SELECT DISTINCT cc.course_name AS COURSE, cc.concentration_name AS CONCENTRATION, a.next_offer AS NEXT_OFFERING " +
                        "FROM concentration c, classestakeninpast p, concentration_course cc, master s, graduate g, courses a " +
                        "WHERE s.student_id = g.student_id AND s.student_id = p.student_id AND p.student_id = ? " +
                        "AND c.major = cc.major AND cc.major = g.major AND c.major = ? " +
                        "AND c.concentration_name = cc.concentration_name AND a.course_number = cc.course_name " + 
                        "AND cc.course_name NOT IN (SELECT p.course FROM classestakeninpast p, concentration_course xx " + 
                        "WHERE p.course = xx.course_name AND xx.concentration_name = cc.concentration_name AND xx.major = cc.major)"




                        


                        "SELECT DISTINCT cc.course_name AS COURSE, cc.concentration_name AS CONCENTRATION " +
                        "FROM concentration c, classestakeninpast p, concentration_course cc, master s, graduate g " +
                        "WHERE s.student_id = g.student_id AND s.student_id = p.student_id AND p.student_id = ? " +
                        "AND c.major = cc.major AND cc.major = g.major AND c.major = ? " +
                        "AND c.concentration_name = cc.concentration_name " + 
                        "AND cc.course_name NOT IN (SELECT p.course FROM classestakeninpast p, concentration_course xx " + 
                        "WHERE p.course = xx.course_name AND xx.concentration_name = cc.concentration_name AND xx.major = cc.major)"

*/

                        pstmt2.setString(1, request.getParameter("ID"));
                        pstmt2.setString(2, request.getParameter("NAME"));


                        rs2 = pstmt2.executeQuery();


                        // Commit transaction
                        conn1.commit();
                        conn1.setAutoCommit(true);
                        conn2.commit();
                        conn2.setAutoCommit(true);
                        
                    }			
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn1.createStatement();
                students = s1.executeQuery("SELECT DISTINCT s.id AS ID, s.firstname AS FIRSTNAME, s.middlename AS MIDDLENAME, " +
                                            "s.lastname AS LASTNAME FROM student s, courseenrollment e WHERE s.id = e.student_id " +
                                            "AND s.id IN (SELECT student_id FROM master)");

                s2 = conn2.createStatement();
                degrees = s2.executeQuery(
                        "SELECT d.major AS NAME FROM degree d WHERE d.major LIKE 'M%'");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="0"><th><font face = "Arial Black" size = "4">Degree Report</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student</th>
                        <th>Degree</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="1e.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><name="ID" size="20">
                            <select name = "ID">
                                <% 
                                    while ( students.next() ){
                                %>
                                     <option value="<%= students.getString("ID") %>"><%= students.getString("ID") %> | <%= students.getString("FIRSTNAME") %>, <%= students.getString("MIDDLENAME") %>, <%= students.getString("LASTNAME") %></option>
                                <%
                                    }
                                %>
                                 
                            </select></th>
                            <th><name="NAME" size="20">
                            <select name = "NAME">
                                <% 
                                    while ( degrees.next() ){
                                %>
                                    <option value="<%= degrees.getString("NAME") %>"><%= degrees.getString("NAME") %></option>
                                <%
                                    }
                                %>
                                 
                            </select></th>
                            <th><input type="submit" value="search"></th>
                        </form>
                    </tr>     
                </table> 

            <%
                if(rs1 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Finished concentration</font></th></table>
                <table border="1">
                    <tr>
                        <th>CONCENTRATION</th>
                    </tr>

                    <%
                        while(rs1.next())
                        {
                    %>
                        <tr>
                            <%-- get the CONCENTRATION --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("CONCENTRATION") %>"
                                    name="CONCENTRATION" size="10" readonly>
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
                if(rs2 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Classes NOT Taken</font></th></table>
                <table border="1">
                    <tr>
                        <th>COURSE</th>
                        <th>CONCENTRATION</th>
                        <th>NEXT_OFFERING</th>
                    </tr>

                    <%
                        while(rs2.next())
                        {
                    %>
                        <tr>
                            <%-- get the COURSE --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("COURSE") %>"
                                    name="COURSE" size="10" readonly>
                            </td>
                            <%-- get the CONCENTRATION --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("CONCENTRATION") %>"
                                    name="CONCENTRATION" size="10" readonly>
                            </td>

                            <%-- get the NEXT_OFFERING --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("NEXT_OFFERING") %>"
                                    name="NEXT_OFFERING" size="10" readonly>
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
                    if (students!=null)
                        students.close();
                    if(degrees!= null)
                        degrees.close();
                    if(s1!=null)
                        s1.close();
                    if(s2!=null)
                        s2.close();
                    if(conn1!=null)
                        conn1.close();
                    if(conn2!=null)
                        conn2.close();
                }
            %>

</body>

</html>