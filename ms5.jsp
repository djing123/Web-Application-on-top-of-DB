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
				ResultSet info1 = null;
                ResultSet info2 = null;
				Connection conn1 = null;
                Connection conn2 = null;

				try {
					Class.forName("org.postgresql.Driver");
					String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
					conn1 = DriverManager.getConnection(dbURL);
                    conn2 = DriverManager.getConnection(dbURL);

				
			%>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                s1 = conn1.createStatement();
                info1 = s1.executeQuery("SELECT * FROM CPQG");
                s2 = conn2.createStatement();
                info2 = s2.executeQuery("SELECT * FROM CPG");
            %>

            <%
                if(info1 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Grade_Count_With_YEAR_Quarter</font></th></table>
                <table border="1">
                    <tr>
                        <th>COURSE</th>
                        <th>Professor</th>
                        <th>QUARTER</th>
                        <th>YEAR</th>
                        <th>GRADE</th>
                        <th>COUNT</th>
                        
                    </tr>

                    <%
                        while(info1.next())
                        {
                    %>
                        <tr>
                            <%-- get the COURSE --%>
                            <td align="middle">
                                <input value="<%= info1.getString("COURSE") %>"
                                    name="COURSE" size="10" readonly>
                            </td>
                            <%-- get the Professor --%>
                            <td align="middle">
                                <input value="<%= info1.getString("Professor") %>"
                                    name="Professor" size="10" readonly>
                            </td>
                            <%-- get the QUARTER --%>
                            <td align="middle">
                                <input value="<%= info1.getString("QUARTER") %>"
                                    name="QUARTER" size="10" readonly>
                            </td>
                            <%-- get the YEAR --%>
                            <td align="middle">
                                <input value="<%= info1.getString("YEAR") %>"
                                    name="YEAR" size="10" readonly>
                            </td>
                            <%-- get the GRADE --%>
                            <td align="middle">
                                <input value="<%= info1.getString("GRADE") %>"
                                    name="GRADE" size="10" readonly>
                            </td>
                            <%-- get the COUNT --%>
                            <td align="middle">
                                <input value="<%= info1.getString("COUNT") %>"
                                    name="COUNT" size="10" readonly>
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
                if(info2 != null)
                {
            %>
            
                <table border="0"><th><font face = "Arial Black" size = "4">Grade_Count_Without_YEAR_Quarter</font></th></table>
                <table border="1">
                    <tr>
                        <th>COURSE</th>
                        <th>Professor</th>
                        <th>GRADE</th>
                        <th>COUNT</th>
                        
                    </tr>

                    <%
                        while(info2.next())
                        {
                    %>
                        <tr>
                            <%-- get the COURSE --%>
                            <td align="middle">
                                <input value="<%= info2.getString("COURSE") %>"
                                    name="COURSE" size="10" readonly>
                            </td>
                            <%-- get the Professor --%>
                            <td align="middle">
                                <input value="<%= info2.getString("Professor") %>"
                                    name="Professor" size="10" readonly>
                            </td>
                            <%-- get the GRADE --%>
                            <td align="middle">
                                <input value="<%= info2.getString("GRADE") %>"
                                    name="GRADE" size="10" readonly>
                            </td>
                            <%-- get the COUNT --%>
                            <td align="middle">
                                <input value="<%= info2.getString("COUNT") %>"
                                    name="COUNT" size="10" readonly>
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
                    if (info1!=null)
                        info1.close();
                    if (info2!=null)
                        info2.close();
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