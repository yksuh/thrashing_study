<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/experimentResult">
		<HTML>
			<BODY background="../images/gray_rock.gif">
			
			<a name="Top"><h1 align="center" style="font-style:bold">Experiment Result</h1></a>

			<h1><xsl:value-of select="log/dbVersion/@name"/></h1>
			
			<ol>
			<xsl:for-each select="testResult">
				<xsl:variable name="testLink">Test<xsl:number value="position()" format="1"/></xsl:variable>
				<li><a href="#{$testLink}">Test <xsl:number value="position()" format="1"/> Result</a><BR/></li>
				<ol type="A">
				<xsl:for-each select="queryResult">
					<xsl:variable name="queryLink">Query<xsl:number value="position()" format="1"/></xsl:variable>
					<li><a href="#{$testLink}{$queryLink}">Query <xsl:number value="position()" format="1"/> Result - <xsl:value-of select="@sql"/></a><BR/></li>
				</xsl:for-each>
				</ol>
			</xsl:for-each>
			</ol>
			
			<HR/>
			<xsl:for-each select="testResult">
				<xsl:variable name="testLink">Test<xsl:number value="position()" format="1"/></xsl:variable>
				<a name="{$testLink}"><h1>Result for Test <xsl:number value="position()" format="1"/></h1></a>

				The table below contains describes the test configuration.  
				<table cellpadding="5" border="1" >
				<thead>
				<th>Table Name</th>
				<th>Actual Cardinality</th>
				<th>Type</th>
				</thead>
				<xsl:for-each select="tableSummary/table">
					<tr align="right">
						<td><xsl:value-of select="@name"/></td>
						<td><xsl:value-of select="@actualCardinality"/></td>
						<td>
							<xsl:choose>
								<xsl:when test="@type = 'fixed'">Fixed Cardinality</xsl:when>
								<xsl:otherwise>Variable Cardinality</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
				</table>
				
				<a href="#Top">Back to the top</a>
				<BR/>

				<xsl:for-each select="queryResult">
					<xsl:variable name="queryLink">Query<xsl:number value="position()" format="1"/></xsl:variable>
					<a name="{$testLink}{$queryLink}"><h3>Result for Query <xsl:number value="position()" format="1"/></h3></a>

					The query being test was:<BR/>
					<b><font face="courier" color="red" size="3"><xsl:value-of select="@sql"/></font></b>
					<BR/>
					<BR/>
					The following shows how the DBMS will behave under optimal circumstance.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
						<tr align="right">
							<td><xsl:value-of select="optimalPlan/table/@name"/></td>
							<td><xsl:value-of select="optimalPlan/table/@cardinality"/></td>
							<td><xsl:value-of select="optimalPlan/@planNumber"/></td>
							<td><xsl:value-of select="optimalPlan/@executionTime"/><xsl:if test="optimalPlan/@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</table>
					<BR/>
					
					The values in the table below show how the DBMS performed with incorrect
					cardinality statistics.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
					<xsl:for-each select="changePoint">
						<tr align="right">
						<td><xsl:value-of select="table/@name"/></td>
						<td><xsl:value-of select="table/@cardinality"/></td>
						<td><xsl:value-of select="@planNumber"/></td>
						<td><xsl:value-of select="@executionTime"/>
						<xsl:if test="@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</xsl:for-each>
					</table>
					<BR/>
					<a href="#Top">Back to the top</a>
				</xsl:for-each>
				
				<HR/>
			</xsl:for-each>
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="/testResult">
		<HTML>
			<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Test Result</h1></a>
			
			<ol type="A">
			<xsl:for-each select="queryResult">
				<xsl:variable name="queryLink">Query<xsl:number value="position()" format="1"/></xsl:variable>
				<li><a href="#{$queryLink}">Query <xsl:number value="position()" format="1"/> Result - <xsl:value-of select="@sql"/></a><BR/></li>
			</xsl:for-each>
			</ol>
			
			<HR/>
				The table below contains describes the test configuration.  
				<table cellpadding="5" border="1" >
				<thead>
				<th>Table Name</th>
				<th>Actual Cardinality</th>
				<th>Type</th>
				</thead>
				<xsl:for-each select="tableSummary/table">
					<tr align="right">
						<td><xsl:value-of select="@name"/></td>
						<td><xsl:value-of select="@actualCardinality"/></td>
						<td>
							<xsl:choose>
								<xsl:when test="@type = 'fixed'">Fixed Cardinality</xsl:when>
								<xsl:otherwise>Variable Cardinality</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
				</table>

				<a href="#Top">Back to the top</a>
				<BR/>

				<xsl:for-each select="queryResult">
					<xsl:variable name="queryLink">Query<xsl:number value="position()" format="1"/></xsl:variable>
					<a name="{$queryLink}"><h3>Result for Query <xsl:number value="position()" format="1"/></h3></a>

					The query being test was:<BR/>
					<b><font face="courier" color="red" size="3"><xsl:value-of select="@sql"/></font></b>
					<BR/>
					<BR/>
					The following shows how the DBMS will behave under optimal circumstance.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
						<tr align="right">
							<td><xsl:value-of select="optimalPlan/table/@name"/></td>
							<td><xsl:value-of select="optimalPlan/table/@cardinality"/></td>
							<td><xsl:value-of select="optimalPlan/@planNumber"/></td>
							<td><xsl:value-of select="optimalPlan/@executionTime"/><xsl:if test="optimalPlan/@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</table>
					<BR/>
					
					The values in the table below show how the DBMS performed with incorrect
					cardinality statistics.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
					<xsl:for-each select="changePoint">
						<tr align="right">
						<td><xsl:value-of select="table/@name"/></td>
						<td><xsl:value-of select="table/@cardinality"/></td>
						<td><xsl:value-of select="@planNumber"/></td>
						<td><xsl:value-of select="@executionTime"/>
						<xsl:if test="@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</xsl:for-each>
					</table>
					<BR/>
					<a href="#Top">Back to the top</a>
				</xsl:for-each>
				
				<HR/>
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="/queryResult">
		<HTML>
			<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Query Result</h1></a>
			
			<HR/>
					The query being test was:<BR/>
					<b><font face="courier" color="red" size="3"><xsl:value-of select="@sql"/></font></b>
					<BR/>
					<BR/>
					The following shows how the DBMS will behave under optimal circumstance.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
						<tr align="right">
							<td><xsl:value-of select="optimalPlan/table/@name"/></td>
							<td><xsl:value-of select="optimalPlan/table/@cardinality"/></td>
							<td><xsl:value-of select="optimalPlan/@planNumber"/></td>
							<td><xsl:value-of select="optimalPlan/@executionTime"/><xsl:if test="optimalPlan/@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</table>
					<BR/>
					
					The values in the table below show how the DBMS performed with incorrect
					cardinality statistics.
					<table cellpadding="5" border="1" >
					<thead>
					<th>Table Name</th>
					<th>Cardinality of Change Point</th>
					<th>Query Plan Number</th>
					<th>Execution Time of Plan</th>
					</thead>
					<xsl:for-each select="changePoint">
						<tr align="right">
						<td><xsl:value-of select="table/@name"/></td>
						<td><xsl:value-of select="table/@cardinality"/></td>
						<td><xsl:value-of select="@planNumber"/></td>
						<td><xsl:value-of select="@executionTime"/>
						<xsl:if test="@units = 'milli seconds'"> ms</xsl:if></td>
						</tr>
					</xsl:for-each>
					</table>
					<BR/>
					<a href="#Top">Back to the top</a>
				
				<HR/>
			</BODY>
		</HTML>
	</xsl:template>

</xsl:stylesheet>
