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
				ResultSet rs2 = null;
                ResultSet rs3 = null;
				ResultSet students = null;
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
                            "SELECT e.course AS COURSE, e.quarter AS QUARTER, e.year AS YEAR, e.unit AS UNITS, e.section_id AS SECTION_ID, e.grade AS GRADE " + 
                            "FROM student s, classestakeninpast e WHERE s.id = ? " + 
                            "AND s.id = e.student_id ORDER BY e.quarter, e.year");
                        pstmt.setString(1, request.getParameter("ID"));

                        rs1 = pstmt.executeQuery();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        	"SELECT e.quarter AS QUARTER, e.year AS YEAR, SUM(g.number_grade)/COUNT(*) AS GPA " +
                            "FROM student s, classestakeninpast e, grade_conversion g " + 
                            "WHERE s.id = e.student_id AND s.id = ? AND e.grade = g.letter_grade GROUP BY e.quarter, e.year");

                        pstmt2.setString(1, request.getParameter("ID"));
                        rs2 = pstmt2.executeQuery();


                        PreparedStatement pstmt3 = conn.prepareStatement(
                            "SELECT SUM(g.number_grade)/COUNT(*) AS GPA " +
                            "FROM student s, classestakeninpast e, grade_conversion g " + 
                            "WHERE s.id = e.student_id AND s.id = ? AND e.grade = g.letter_grade GROUP BY e.student_id");
                        pstmt3.setString(1, request.getParameter("ID"));
                        rs3 = pstmt3.executeQuery();


                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }			
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn.createStatement();
                students = s1.executeQuery("SELECT s.id AS ID, s.firstname AS FIRSTNAME, s.middlename AS MIDDLENAME, s.lastname AS LASTNAME FROM student s");
            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="0"><th><font face = "Arial Black" size = "4">All Students</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="1c.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><name="ID" size="20">
                            <select name = "ID">
                                <% 
                                    while ( students.next() ){
                                %>
                                     <option value="<%= students.getString("ID")%>"><%= students.getString("ID") %> | <%= students.getString("FIRSTNAME") %>, <%= students.getString("MIDDLENAME") %>, <%= students.getString("LASTNAME") %></option>
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
            	if(rs1 != null)
            	{
            %>
            
            	<table border="0"><th><font face = "Arial Black" size = "4">Taken Class</font></th></table>
            	<table border="1">
            		<tr>
                        <th>COURSE</th>
                        <th>QUARTER</th>
                        <th>YEAR</th>
                        <th>UNITS</th>
                        <th>SECTION_ID</th>
                        <th>GRADE</th>
            		</tr>

            		<%
            			while(rs1.next())
            			{
            		%>
            			<tr>
            				<%-- get the COURSE --%>
            				<td align="middle">
            					<input value="<%= rs1.getString("COURSE") %>"
            						name="COURSE" size="10" readonly>
            				</td>

            				<%-- get the QUARTER  --%>
            				<td align="middle">
            					<input value="<%= rs1.getString("QUARTER") %>"
            						name="QUARTER" size="10" readonly>
            				</td>

            				<%-- get the YEAR --%>
            				<td align="middle">
            					<input value="<%= rs1.getString("YEAR") %>"
            						name="YEAR" size="10" readonly>
            				</td>

            				<%-- get the UNITS --%>
            				<td align="middle">
            					<input value="<%= rs1.getString("UNITS") %>"
            						name="UNITS" size="10" readonly>
            				</td>

                            <%-- get the SECTION_ID --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("SECTION_ID") %>"
                                    name="SECTION_ID" size="10" readonly>
                            </td>

                            <%-- get the GRADE --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("GRADE") %>"
                                    name="GRADE" size="10" readonly>
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
            
                <table border="0"><th><font face = "Arial Black" size = "4">Quarterly GPA</font></th></table>
                <table border="1">
                    <tr>
                        <th>QUARTER</th>
                        <th>YEAR</th>
                        <th>GPA</th>
                    </tr>

                    <%
                        while(rs2.next())
                        {
                    %>
                        <tr>
                            <%-- get the QUARTER --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("QUARTER") %>"
                                    name="QUARTER" size="10" readonly>
                            </td>

                            <%-- get the YEAR  --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("YEAR") %>"
                                    name="YEAR" size="10" readonly>
                            </td>

                            <%-- get the GPA --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("GPA") %>"
                                    name="GPA" size="10" readonly>
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
                if(rs3 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Cumulative GPA</font></th></table>
                <table border="1">
                    <tr>
                        <th>GPA</th>
                    </tr>

                    <%
                        while(rs3.next())
                        {
                    %>
                        <tr>
                            <%-- get the GPA --%>
                            <td align="middle">
                                <input value="<%= rs3.getString("GPA") %>"
                                    name="GPA" size="10" readonly>
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