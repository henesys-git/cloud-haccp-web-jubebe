<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%
/* 
CCP 4P 모니터링일지 캔버스 (S838S015400)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", ccp_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklistId", checklistId);
	jArray.put("checklistRevNo", checklistRevNo);
	jArray.put("ccp_date", ccp_date);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S015400E144", jArray);
	DoyosaeTableModel table2 = new DoyosaeTableModel("M838S015400E154", jArray);
	
	VectorToJson vtj = new VectorToJson();
	
	String data = vtj.vectorToJson(table.getVector());
	String data2 = vtj.vectorToJson(table2.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		var data2 = <%=data2%>;
		console.log(data);
		console.log(data2);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 3,
			colCnt: 3,
			rowRatio: [17/135, 18/135, 100/135],
			colRatio: [59/456, 190/456, 207/456]
		};
		
		bodyObj.body1 = {
			rowCnt: 9,
			colCnt: 23,
			rowRatio: [14/162, 21/162, 23/162, 18/162, 16/162, 
					   18/162, 17/162, 17/162, 18/162],
			colRatio: [59/456, 33/456, 18/456, 20/456, 19/456,
					   20/456, 18/456, 19/456, 18/456, 17/456,
					   19/456, 12/456, 12/456, 13/456, 13/456,
					   12/456, 13/456, 13/456, 12/456, 12/456,
					   13/456, 25/456, 46/456]
		};
		
		bodyObj.body2 = {
			rowCnt: 7,
			colCnt: 4,
			rowRatio: [17/248, 15/248, 19/248, 19/248, 19/248,
				       19/248, 140/248],
			colRatio: [59/456, 120/456, 82/456, 195/456]
		};
		
		bodyObj.body3 = {
				rowCnt: 2,
				colCnt: 4,
				rowRatio: [17/54, 37/54],
				colRatio: [162/456, 121/456, 66/456, 107/456]
			};
		
		
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([46/645, 135/645, 162/645, 248/645, 54/645])
						.setHeadRowCnt(2)
						.setHeadColCnt(4)
						.setHeadRowRatio([12/46, 34/46])
						.setHeadColRatio([295/456, 54/456, 53/456, 54/456])
						.howManyBodies(4)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(55)
						.setStartY(79)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
	 		/* cl.mergeCellsVertical(cl.head, "row0", "row1", "col0");
			
			cl.mergeCellsHorizon(cl.bodies.body0, "row0", "col1", "col2");
			cl.mergeCellsHorizon(cl.bodies.body0, "row2", "col1", "col2");
			
			cl.mergeCellsHorizon(cl.bodies.body1, "row0", "col0", "col22");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col2", "col4");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col5", "col7");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col8", "col10");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col11", "col15");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col16", "col20");
	 		
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col0");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col1");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col21");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col22");

			cl.mergeCellsHorizon(cl.bodies.body2, "row0", "col0", "col3");
			cl.mergeCellsHorizon(cl.bodies.body2, "row6", "col1", "col3"); */
			
			// fill data
			
			//head
			cl.fillText(cl.head, "row1", "col1", '<%=table.getValueAt(0,2)%>',
						'balck', "10px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col2", '<%=table.getValueAt(0,5)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,6)%>',
					'balck', "15px arial", "center", "middle");
			
			
			//body1
			for(var i= 0; i<data.length; i++){
			var fe_only = data[i][11];
			var sus_only = data[i][12];
			var prod_only = data[i][13];
			var fe_with_prod = data[i][14];
			var sus_with_prod = data[i][15];
			
			var row = "row" +(i+3);
			
			cl.fillText(cl.bodies.body1, row, "col0", data[i][10],
						'balck', "10px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col1", data[i][9],
						'balck', "10px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col2", fe_only.substr(0,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col3", fe_only.substr(1,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col4", fe_only.substr(2,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col5", sus_only.substr(0,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col6", sus_only.substr(1,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col7", sus_only.substr(2,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col8", prod_only.substr(0,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col9", prod_only.substr(1,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col10", prod_only.substr(2,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col11", fe_with_prod.substr(0,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col12", fe_with_prod.substr(1,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col13", fe_with_prod.substr(2,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col14", fe_with_prod.substr(3,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col15", fe_with_prod.substr(4,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col16", sus_with_prod.substr(0,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col17", sus_with_prod.substr(1,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col18", sus_with_prod.substr(2,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col19", sus_with_prod.substr(3,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col20", sus_with_prod.substr(4,1),
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col21", data[i][16],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, row, "col22", data[i][17],
					'balck', "15px arial", "center", "middle");
			}
			
			<%-- //body2
			for(var i=0; i=data2.length; i++){
			var row2 = "row"+(i+2);
				
			cl.fillText(cl.bodies.body2, row2, "col1", '<%=table.getValueAt(0,1)%>',
					'balck', "15px arial", "center", "middle");
			
			cl.fillText(cl.bodies.body2, row2, "col3", '<%=table.getValueAt(0,7)%>',
					'balck', "15px arial", "center", "middle");
			
			} --%>
			 
			//body3
			cl.fillText(cl.bodies.body3, "row1", "col0", '<%=table.getValueAt(0,3)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row1", "col1", '<%=table.getValueAt(0,4)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row1", "col2", '<%=table.getValueAt(0,7)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row1", "col3", '<%=table.getValueAt(0,8)%>',
					'balck', "15px arial", "center", "middle");
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="566" height="805">
	</canvas>    
</div>