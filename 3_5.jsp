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
				ResultSet info = null;
				Connection conn1 = null;
                //Connection conn2 = null;


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
                        "SELECT SUM(g.number_grade)/COUNT(*) AS GPA " +
                        "FROM classestakeninpast e, section s, classes c, grade_conversion g " +
                        "WHERE e.course = c.course_number AND s.section_id = c.section_id AND e.section_id = s.section_id " + 
                        "AND e.grade = g.letter_grade " +
                        "AND c.course_number = ? AND s.faculty = ? " + 
                        "GROUP BY e.course"); 

                        pstmt.setString(1, s_course);
                        pstmt.setString(2, s_professor);

                        rs1 = pstmt.executeQuery();

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
                        <form action="3_5.jsp" method="get">
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
                if(rs1 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Overall_GPA</font></th></table>
                <table border="1">
                    <tr>
                        <th>GPA</th>

                        
                    </tr>

                    <%
                        while(rs1.next())
                        {
                    %>
                        <tr>
                            <%-- get the GPA --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("GPA") %>"
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