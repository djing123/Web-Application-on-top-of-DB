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
				ResultSet rs1 = null;
				ResultSet current_class = null;
				Connection conn = null;

				try {
					Class.forName("org.postgresql.Driver");
					String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
					conn = DriverManager.getConnection(dbURL);
				
			%>


			<%-- -------- INSERT Code -------- --%>
			<%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);

                        PreparedStatement pstmt = conn.prepareStatement(
                        	"SELECT DISTINCT s.ssn AS SSN, s.id AS Student_ID, s.firstname AS FIRSTNAME, s.middlename AS MIDDLENAME, " + 
                        	"s.lastname AS LASTNAME, s.residency AS RESIDENCY, s.enrollment_status AS Enrollment_Status, " + 
                        	"e.unit AS UNITS, e.grade_option AS Grade_Option FROM student s, courseenrollment e, classes c " +
                        	"WHERE s.id = e.student_id AND c.title = ? AND c.course_number = e.course");

                        pstmt.setString(1, request.getParameter("TITLE"));
                        rs1 = pstmt.executeQuery();


                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }			
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
            	s1 = conn.createStatement();
            	current_class = s1.executeQuery(
            				"SELECT DISTINCT c.title AS TITLE, c.course_number AS COURSE," +
                            " c.quarter AS QUARTER, c.year AS YEAR FROM classes c, courseenrollment e " +
                            "WHERE c.course_number = e.course AND c.quarter = 'Spring' AND c.year = 2017");
            %>

            <table border="0"><th><font face="Arial Black" size="4">Roster</font></th></table>
            	<table border="1">
            		<tr>
            			<th>Student Roster For</th>
            			<th>Action</th>
            		</tr>
            		<tr>
            			<form action="1b.jsp" method="get">
            			<input type="hidden" value="search" name="action">
            			<th><name="TITLE" size="20">
            			<select name="TITLE">
            				<%
            					while(current_class.next())
            					{
            				%>
            						<option value="<%=current_class.getString("TITLE") %>"><%= current_class.getString("TITLE") %> | <%= current_class.getString("COURSE") %>, <%= current_class.getString("QUARTER") %>, <%= current_class.getString("YEAR") %></option>
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
                <table border="0"><th><font face = "Arial Black" size = "4">Students Enrolled in Class Info</font></th></table>
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>Student_ID</th>
                        <th>FIRSTNAME</th>
                        <th>MIDDLENAME</th>
                        <th>LASTNAME</th>
                        <th>RESIDENCY</th>
                        <th>UNITS</th>
                        <th>Grade_Option</th>
                    </tr>
                    <%
                        while(rs1.next())
                        {
                    %>
                        <tr>
                            <%-- get the SSN --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("SSN") %>"
                                    name="SSN" size="10" readonly>
                            </td>

                            <%-- get the Student_ID  --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("Student_ID") %>"
                                    name="Student_ID" size="10" readonly>
                            </td>

                            <%-- get the FIRSTNAME --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("FIRSTNAME") %>"
                                    name="FIRSTNAME" size="10" readonly>
                            </td>

                            <%-- get the MIDDLENAME --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("MIDDLENAME") %>"
                                    name="MIDDLENAME" size="10" readonly>
                            </td>

                            <%-- get the LASTNAME --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("LASTNAME") %>"
                                    name="LASTNAME" size="10" readonly>
                            </td>

                            <%-- get the RESIDENCY --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("RESIDENCY") %>"
                                    name="RESIDENCY" size="10" readonly>
                            </td>

                            <%-- get the UNITS --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("UNITS") %>"
                                    name="UNITS" size="10" readonly>
                            </td>

                            <%-- get the Grade_Option --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("Grade_Option") %>"
                                    name="Grade_Option" size="10" readonly>
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
                    if (current_class!=null)
                        current_class.close();
                    if(s1!=null)
                        s1.close();
                    if(conn!=null)
                        conn.close();
                }
            %>

</body>

</html>











