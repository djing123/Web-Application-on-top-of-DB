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
                ResultSet rs3 = null;
                ResultSet rs4 = null;
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
                        "SELECT (SELECT d.total_units FROM degree d WHERE d.major = ?) - (SELECT SUM(e.unit) FROM classestakeninpast e WHERE e.student_id = ? AND e.grade IN ('A+','A','A-','B+','B','B-','C+','C','C-','D')) AS REMAIN_UNIT");

                        pstmt.setString(1, request.getParameter("NAME"));
                        pstmt.setString(2, request.getParameter("ID"));
                        

                        rs1 = pstmt.executeQuery();

                        PreparedStatement pstmt2 = conn1.prepareStatement(
                        "SELECT (SELECT d.min_units " +
                        "FROM category d " + 
                        "WHERE d.major = ? AND d.category_name = 'Lower') - " + 
                        "(SELECT CASE WHEN SUM(e.unit) IS NULL THEN 0 ELSE SUM(e.unit) END AS LOWER_CATEGORY " + 
                        "FROM classestakeninpast e, undergraduate s, category c, category_course cc " + 
                        "WHERE c.major = ? AND c.major = cc.major AND c.category_name = cc.category_name AND c.category_name = 'Lower' " + 
                        "AND e.course = cc.course_name AND e.student_id = s.student_id AND s.major = c.major AND e.student_id = ?) AS LOWER_REMAINING");

                        pstmt2.setString(1, request.getParameter("NAME"));
                        pstmt2.setString(2, request.getParameter("NAME"));
                        pstmt2.setString(3, request.getParameter("ID"));


                        rs2 = pstmt2.executeQuery();


                        PreparedStatement pstmt3 = conn1.prepareStatement(
                        "SELECT (SELECT d.min_units " +
                        "FROM category d " + 
                        "WHERE d.major = ? AND d.category_name = 'Upper') - " + 
                        "(SELECT CASE WHEN SUM(e.unit) IS NULL THEN 0 ELSE SUM(e.unit) END AS UPPER_CATEGORY " + 
                        "FROM classestakeninpast e, undergraduate s, category c, category_course cc " + 
                        "WHERE c.major = ? AND c.major = cc.major AND c.category_name = cc.category_name AND c.category_name = 'Upper' " + 
                        "AND e.course = cc.course_name AND e.student_id = s.student_id AND s.major = c.major AND e.student_id = ?) AS UPPER_REMAINING");

                        pstmt3.setString(1, request.getParameter("NAME"));
                        pstmt3.setString(2, request.getParameter("NAME"));
                        pstmt3.setString(3, request.getParameter("ID"));


                        rs3 = pstmt3.executeQuery();



                        PreparedStatement pstmt4 = conn1.prepareStatement(
                        "SELECT (SELECT d.min_units " +
                        "FROM category d " + 
                        "WHERE d.major = ? AND d.category_name = 'Elective') - " + 
                        "(SELECT CASE WHEN SUM(e.unit) IS NULL THEN 0 ELSE SUM(e.unit) END " + 
                        "FROM classestakeninpast e, undergraduate s, category c, category_course cc " + 
                        "WHERE c.major = ? AND c.major = cc.major AND c.category_name = cc.category_name AND c.category_name = 'Elective' " + 
                        "AND e.course = cc.course_name AND e.student_id = s.student_id AND s.major = c.major AND e.student_id = ?) AS TE_REMAINING "
                        );

                        pstmt4.setString(1, request.getParameter("NAME"));
                        pstmt4.setString(2, request.getParameter("NAME"));
                        pstmt4.setString(3, request.getParameter("ID"));


                        rs4 = pstmt4.executeQuery();


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
                                            "AND s.id IN (SELECT student_id FROM undergraduate)");

                s2 = conn2.createStatement();
                degrees = s2.executeQuery(
                        "SELECT d.major AS NAME FROM degree d WHERE d.major LIKE 'B%'");
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
                        <form action="1d.jsp" method="get">
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
            <%-- -------- Iteration Code -------- --%>
            <%
                if(rs1 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Remainning Units</font></th></table>
                <table border="1">
                    <tr>
                        <th>Remain</th>
                    </tr>

                    <%
                        while(rs1.next())
                        {
                    %>
                        <tr>
                            <%-- get the units --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("REMAIN_UNIT") %>"
                                    name="REMAIN_UNIT" size="10" readonly>
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
            
                <table border="0"><th><font face = "Arial Black" size = "4">Remainning Lower Units</font></th></table>
                <table border="1">
                    <tr>
                        <th>Remain</th>
                    </tr>

                    <%
                        while(rs2.next())
                        {
                    %>
                        <tr>
                            <%-- get the units --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("LOWER_REMAINING") %>"
                                    name="LOWER_REMAINING" size="10" readonly>
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
            
                <table border="0"><th><font face = "Arial Black" size = "4">Remainning Upper Units</font></th></table>
                <table border="1">
                    <tr>
                        <th>Remain</th>
                    </tr>

                    <%
                        while(rs3.next())
                        {
                    %>
                        <tr>
                            <%-- get the units --%>
                            <td align="middle">
                                <input value="<%= rs3.getString("UPPER_REMAINING") %>"
                                    name="UPPER_REMAINING" size="10" readonly>
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
                if(rs4 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Remainning TE Units</font></th></table>
                <table border="1">
                    <tr>
                        <th>Remain</th>
                    </tr>

                    <%
                        while(rs4.next())
                        {
                    %>
                        <tr>
                            <%-- get the units --%>
                            <td align="middle">
                                <input value="<%= rs4.getString("TE_REMAINING") %>"
                                    name="TE_REMAINING" size="10" readonly>
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