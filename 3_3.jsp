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
                ResultSet rs5 = null;
				ResultSet info = null;
				Connection conn1 = null;


				try {
					Class.forName("org.postgresql.Driver");
					String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
					conn1 = DriverManager.getConnection(dbURL);
				
			%>


			<%-- -------- INSERT Code -------- --%>
			<%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn1.setAutoCommit(false);

                        String everything_s = request.getParameter("everything");
                        String[] token = everything_s.split(",");
                        String s_course = token[0];
                        String s_professor = token[1];

                        //String s_course = (token.length == 1) ? "CSE 200" : "CSE 299";

                        //String s_course = "CSE 299";


                        PreparedStatement pstmt = conn1.prepareStatement(
                        "SELECT COUNT(*) AS A_NUMBER FROM (SELECT DISTINCT p.grade, p.student_id " +
                        "FROM classestakeninpast p, section s, classes c " + 
                        "WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id " + 
                        "AND c.course_number = ? AND s.faculty = ? " +
                        "AND p.grade IN ('A+', 'A', 'A-')) AS A1"); 

                        pstmt.setString(1, s_course);
                        pstmt.setString(2, s_professor);

                        rs1 = pstmt.executeQuery();


                        PreparedStatement pstmt2 = conn1.prepareStatement(
                        "SELECT COUNT(*) AS B_NUM FROM (SELECT DISTINCT p.grade, p.student_id " +
                        "FROM classestakeninpast p, section s, classes c " + 
                        "WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id " + 
                        "AND c.course_number = ? AND s.faculty = ? " +
                        "AND p.grade IN ('B+', 'B', 'B-')) AS B1");

                        pstmt2.setString(1, s_course);
                        pstmt2.setString(2, s_professor);


                        rs2 = pstmt2.executeQuery();


                        PreparedStatement pstmt3 = conn1.prepareStatement(
                        "SELECT COUNT(*) AS C_NUM FROM (SELECT DISTINCT p.grade, p.student_id " +
                        "FROM classestakeninpast p, section s, classes c " + 
                        "WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id " + 
                        "AND c.course_number = ? AND s.faculty = ? " +
                        "AND p.grade IN ('C+', 'C', 'C-')) AS C1");

                        pstmt3.setString(1, s_course);
                        pstmt3.setString(2, s_professor);


                        rs3 = pstmt3.executeQuery();


                        PreparedStatement pstmt4 = conn1.prepareStatement(
                        "SELECT COUNT(*) AS D_NUM FROM (SELECT DISTINCT p.grade, p.student_id " +
                        "FROM classestakeninpast p, section s, classes c " + 
                        "WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id " + 
                        "AND c.course_number = ? AND s.faculty = ? " +
                        "AND p.grade IN ('D')) AS D1");

                        pstmt4.setString(1, s_course);
                        pstmt4.setString(2, s_professor);


                        rs4 = pstmt4.executeQuery();



                        PreparedStatement pstmt5 = conn1.prepareStatement(
                        "SELECT COUNT(*) AS OTHER_NUM FROM (SELECT DISTINCT p.grade, p.student_id " +
                        "FROM classestakeninpast p, section s, classes c " + 
                        "WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id " + 
                        "AND c.course_number = ? AND s.faculty = ? " +
                        "AND p.grade NOT IN ('D', 'C+', 'C', 'C-', 'B+', 'B', 'B-', 'A+', 'A', 'A-')) AS O1");

                        pstmt5.setString(1, s_course);
                        pstmt5.setString(2, s_professor);


                        rs5 = pstmt5.executeQuery();


                        // Commit transaction
                        conn1.commit();
                        conn1.setAutoCommit(true);
                        
                    }			
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn1.createStatement();
                info = s1.executeQuery("SELECT DISTINCT c.course_number AS COURSE, s.faculty AS Professor " +
                    "FROM classes c, section s " +
                    "WHERE c.section_id = s.section_id");

            %>

            <!-- Add an HTML table header row to format the results -->
            <table border="0"><th><font face = "Arial Black" size = "4">COURSE INFO</font></th></table>
                <table border="1">
                    <tr>
                        <th>COURSE DETAIL</th>
                    </tr>
                    <tr>
                        <form action="3_3.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <th><name="everything" size="20">
                            <select name = "everything">
                                <% 
                                    while ( info.next() ){
                                %>
                                     <option value="<%= info.getString("COURSE") %>,<%= info.getString("Professor") %>"><%= info.getString("COURSE") %>,<%= info.getString("Professor") %></option>
                                <%
                                    }
                                %>

                            <th><input type="submit" value="search"></th>
                        </form>
                    </tr>     
                </table> 



             <%
                if(rs1 != null && rs2 != null && rs3 != null && rs4 != null && rs5 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Grade_Count</font></th></table>
                <table border="1">
                    <tr>
                        <th>A_NUM</th>
                        <th>B_NUM</th>
                        <th>C_NUM</th>
                        <th>D_NUM</th>
                        <th>OTHER_NUM</th>
                        
                    </tr>

                    <%
                        while(rs1.next() && rs2.next() && rs3.next() && rs4.next() && rs5.next())
                        {
                    %>
                        <tr>
                            <%-- get the A_NUMBER --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("A_NUMBER") %>"
                                    name="A_NUMBER" size="10" readonly>
                            </td>
                            <%-- get the B_NUM --%>
                            <td align="middle">
                                <input value="<%= rs2.getString("B_NUM") %>"
                                    name="B_NUM" size="10" readonly>
                            </td>
                            <%-- get the C_NUM --%>
                            <td align="middle">
                                <input value="<%= rs3.getString("C_NUM") %>"
                                    name="C_NUM" size="10" readonly>
                            </td>
                            <%-- get the D_NUM --%>
                            <td align="middle">
                                <input value="<%= rs4.getString("D_NUM") %>"
                                    name="D_NUM" size="10" readonly>
                            </td>
                            <%-- get the OTHER_NUM --%>
                            <td align="middle">
                                <input value="<%= rs5.getString("OTHER_NUM") %>"
                                    name="OTHER_NUM" size="10" readonly>
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
                    // Close the ResultSet
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
                    if (info!=null)
                        info.close();
                    if(s1!=null)
                        s1.close();
                    if(conn1!=null)
                        conn1.close();

                }
            %>

</body>

</html>