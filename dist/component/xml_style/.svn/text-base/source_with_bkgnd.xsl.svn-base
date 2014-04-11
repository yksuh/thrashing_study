<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/experiment">
		<HTML>
			<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Experiment '<xsl:value-of select="@name"/>' </h1></a>
						
			<h3>'<xsl:value-of select="@name"/>' Description</h3>
			<p>This experiment performs tests on an <xsl:value-of select="@dbms"/> DBMS.</p>
			<p><xsl:value-of select="description"/></p>
			
			<h3>Test Source Index</h3>
			<ol>
			<xsl:for-each select="test">
				<xsl:variable name="testLink">Test<xsl:number value="position()" format="1"/></xsl:variable>
				<li><a href="#{$testLink}">Test <xsl:number value="position()" format="1"/> Source</a><BR/></li>
			</xsl:for-each>
			</ol>
			
			<HR/>
			<xsl:for-each select="test">
				<xsl:variable name="testLink">Test<xsl:number value="position()" format="1"/></xsl:variable>
				<a name="{$testLink}"><h1>Source for Test <xsl:number value="position()" format="1"/></h1></a>

				<xsl:apply-templates/>

				<a href="#Top">Back to the top</a>
				<BR/>
				
				<HR/>
			</xsl:for-each>
			
			</BODY>
		</HTML>
	</xsl:template>
	
	<xsl:template match="/test">
		<HTML>
			<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Test</h1></a>
						
			<HR/>

			<xsl:variable name="testLink">Test<xsl:number value="position()" format="1"/></xsl:variable>
			<a name="{$testLink}"><h1>Source for Test <xsl:number value="position()" format="1"/></h1></a>

			<xsl:apply-templates/>

			<a href="#Top">Back to the top</a>
			<BR/>

			<HR/>
			
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="variableTableSet">
		<h3>Variable Table Summary</h3>
		<table cellpadding="5" border="1">
			<thead>
				<th>Table Name</th>
				<th>Minimum Cardinality</th>
				<th>Maximum Cardinality</th>
			</thead>
			<xsl:for-each select="table">
				<tr align="right">
					<td><xsl:value-of select="@name"/></td>
					<td><xsl:value-of select="cardinality/@hypotheticalMinimum"/></td>
					<td><xsl:value-of select="cardinality/@hypotheticalMaximum"/></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="fixedTableSet">
		<h3>Fixed Table Summary</h3>
		<table cellpadding="5" border="1">
			<thead>
				<th>Table Name</th>
				<th>Actual Cardinality</th>
			</thead>
			<xsl:for-each select="table">
				<tr align="right">
					<td><xsl:value-of select="@name"/></td>
					<td><xsl:value-of select="cardinality/@hypothetical"/></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="/dataDefinition">
	<HTML>
		<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Data Definition</h1></a>
			<h3>Description</h3>
			<xsl:value-of select="documentation"/>
			<HR/>
			<xsl:for-each select="table">
				<xsl:variable name="currentTable"><xsl:value-of select="@name"/></xsl:variable>
				<h3>Summary for Table '<xsl:value-of select="$currentTable"/>' with a cardinality of <xsl:value-of select="@cardinality"/>.</h3>			
				<table cellpadding="5" border="1">
					<thead>
						<th>Column Name</th>
						<th>Data Type</th>
						<th>Size of Column</th>
						<th>Data Generation Type</th>
						<th>Distribution Minimum</th>
						<th>Distribution Maximum</th>
						<th>In Primary Key</th>
					</thead>
					<xsl:for-each select="column">
						<tr align="right">
							<td><xsl:value-of select="@name"/></td>
							<td><xsl:value-of select="@dataType"/></td>
							<td><xsl:value-of select="@dataLength"/></td>
							<td><xsl:value-of select="@dataGenerationType"/></td>
							<td><xsl:value-of select="@distributionMinimum"/></td>
							<td><xsl:value-of select="@distributionMaximum"/></td>
							<td><xsl:value-of select="@inPrimaryKey"/></td>
						</tr>
					</xsl:for-each>
				</table>
			<h3>Summary of Referential Integrity</h3>
			<xsl:for-each select="referentialIntegrity">
			<h4>Table '<xsl:value-of select="$currentTable"/>' references table '<xsl:value-of select="@tableName"/>'</h4>
				<table cellpadding="5" border="1">
					<thead>
						<th>Column Name</th>
						<th>Referenced Column Name</th>
					</thead>
					<xsl:for-each select="column">
						<tr align="right">
							<td><xsl:value-of select="@name"/></td>
							<td><xsl:value-of select="@references"/></td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
			<a href="#Top">Back to the top</a>
			<BR/>
			<HR/>
			</xsl:for-each>
			

		</BODY>
	</HTML>
	</xsl:template>
	
	<xsl:template match="/grammar">
	<HTML>
		<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Grammar Query Generation</h1></a>
			<h2>SELECT Clause</h2>
			<p>
			<xsl:choose>
				<xsl:when test="select/@maxColumns = 'all'">All columns will be selected from this query (or SELECT *).</xsl:when>
				<xsl:otherwise>At most <xsl:value-of select="select/@maxColumns"/> columns will be selected.  One column is always selected.</xsl:otherwise>
			</xsl:choose>
			<h2>FROM Clause</h2>
			<xsl:choose>
				<xsl:when test="from/@maxTables = 'actual'">The number of tables is equal to or less than the number of tables in the data definition. One variable table is always selected.</xsl:when>
				<xsl:otherwise>At most <xsl:value-of select="from/@maxTables"/> tables will be selected.  One table is always selected.  One variable table is always selected.</xsl:otherwise>
			</xsl:choose>
			<h2>WHERE Clause</h2>
			<xsl:choose>
				<xsl:when test="where/@cartesianPossible = 'true'">Cartesian joins are possible for this query generator.</xsl:when>
				<xsl:otherwise>Cartesian joins are not possible for this query generator.</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="where/@maxIsAbsolute = 'true'">  The maximum number of simple predicates in the where clause will be greater than 1 and less than or equal to <xsl:value-of select="where/@maxPredicates"/>.</xsl:when>
				<xsl:otherwise>  The maximum number of simple predicates in the where clause will be greater than 1 and less than or equal to <xsl:value-of select="where/@maxPredicates"/> times the number of tables.  </xsl:otherwise>
			</xsl:choose>
			The query generator will tranform simple predicates into complex predicates <xsl:value-of select="where/@complexUsePercentage"/> % of the time.
			</p>
			<p>
			<h3>Binary Operators</h3>
			<ul>
			<xsl:for-each select="where/binaryOperators/operator">
			<li><xsl:value-of select="@symbol"/></li>
			</xsl:for-each>
			</ul>
			</p>
			
			<p>
			<h3>Binary Logical Operators</h3>
			<ul>
			<xsl:for-each select="where/binaryLogicalOperators/operator">
			<li><xsl:value-of select="@symbol"/></li>
			</xsl:for-each>
			</ul>
			</p>

			<p>
			<h3>Binary Operators</h3>
			<ul>
			<xsl:for-each select="where/unaryLogicalOperators/operator">
			<li><xsl:value-of select="@symbol"/> - used <xsl:value-of select="@usePercentage"/> % of the time.</li>
			</xsl:for-each>
			</ul>
			</p>

		</BODY>
	</HTML>
	</xsl:template>

	<xsl:template match="/predefinedQueries">
	<HTML>
		<BODY background="../images/gray_rock.gif">
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Predefined Query Generation</h1></a>
			<HR/>
			<h3>The predefined queries for this test are:</h3>
			<ul>
			<xsl:for-each select="query">
			<li><xsl:value-of select="@sql"/></li>	
			</xsl:for-each>
			</ul>
		</BODY>
	</HTML>
	</xsl:template>

</xsl:stylesheet>
