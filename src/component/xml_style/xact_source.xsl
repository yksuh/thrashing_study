<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/transactionExperiment">
		<HTML>
			<BODY>
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Experiment '<xsl:value-of select="@name"/>' </h1></a>
						
			<h3>'<xsl:value-of select="@name"/>' Description</h3>
			<p>This experiment performs tests on an <xsl:value-of select="@dbms"/> DBMS.</p>
			<p><xsl:value-of select="description"/></p>
			
			<br/>
			
			<HR/>
			
			<h3>Multi-core Configuration</h3>
			<table cellpadding="5" border="1">
				<!-- <thead>
					<th>Number of Cores</th>
					<th>Actual Cardinality</th>
				</thead>-->
				<tr align="right">
					<td>Number of Cores</td>
					<td><xsl:value-of select="multiCoreConfiguration/@numberCores"/></td>
				</tr>
			</table>
			
			<HR/>
			
			<h3>Run Duration</h3>
			<table cellpadding="5" border="1">
				<tr align="right">
					<td>Duration</td>
					<td><xsl:value-of select="duration/@seconds"/>(seconds)</td>
				</tr>
			</table>
			
			<HR/>
			
			<h3>Multiprogramming Level (MPL)</h3>
			<table cellpadding="5" border="1">
				<!-- <thead>
					<th>Number of Cores</th>
					<th>Actual Cardinality</th>
				</thead>-->
				<tr align="right">
					<td>MPL</td>
					<td><xsl:value-of select="terminalConfiguration/@numberTerminals"/></td>
				</tr>
			</table>
			
			
			<!-- <h3>Experiment Source</h3>
			<ol>
			<xsl:for-each select="experimentrun">
				<xsl:variable name="testLink">Experiment Run<xsl:number value="position()" format="1"/></xsl:variable>
				<li><a href="#{$testLink}">Experiment Run <xsl:number value="position()" format="1"/> Source</a><BR/></li>
			</xsl:for-each>
			</ol>
			
			<HR/>
			<xsl:for-each select="experimentrun">
				<xsl:variable name="testLink">Experiment Run<xsl:number value="position()" format="1"/></xsl:variable>
				<a name="{$testLink}"><h1>Source for Experiment Run <xsl:number value="position()" format="1"/></h1></a>

				<xsl:apply-templates/>

				<a href="#Top">Back to the top</a>
				<BR/>
				
				<HR/>
			</xsl:for-each>
			-->
			</BODY>
		</HTML>
	</xsl:template>
	
	<xsl:template match="/experimentrun">
		<HTML>
			<BODY>
			<a name="Top"><h1 align="center" style="font-style:bold">Source for Experiment Run</h1></a>
						
			<HR/>

			<xsl:variable name="testLink">Experiment Run<xsl:number value="position()" format="1"/></xsl:variable>
			<a name="{$testLink}"><h1>Source for Experiment Run <xsl:number value="position()" format="1"/></h1></a>

			<xsl:apply-templates/>

			<a href="#Top">Back to the top</a>
			<BR/>

			<HR/>
			
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="tableSet">
		<h3>Table Summary</h3>
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
		<BODY>
			<a name="Top">
			<h1 align="center" style="font-style:bold">Source for Data Definition</h1></a>
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
</xsl:stylesheet>
