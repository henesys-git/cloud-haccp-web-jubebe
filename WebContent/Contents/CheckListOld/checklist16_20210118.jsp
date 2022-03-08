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
정기검증기록부 캔버스 (S838S070400)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", checklist_date = ""; 
	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");
	
	if(request.getParameter("checklistId") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("checklist_date") != null)
		checklist_date = request.getParameter("checklist_date");
	
	
	JSONObject jArray = new JSONObject();
	
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	jArray.put("checklist_date", checklist_date);
	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070500E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		console.log(data);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 1,
			colCnt: 4,
			rowRatio: [26/26],
			colRatio: [67/471, 159/471, 74/471, 171/471]
		};
		
		bodyObj.body1 = {
			rowCnt: 18,
			colCnt: 4,
			rowRatio: [13/498, 15/498, 38/498, 25/498, 37/498,
				       42/498, 36/498, 21/498, 38/498, 21/498,
				       37/498, 22/498, 28/498, 22/498, 24/498,
				       22/498, 37/498, 22/498],
			colRatio: [67/471, 305/471, 52/471, 47/471]
		};
		
		bodyObj.body2 = {
			rowCnt: 2,
			colCnt: 4,
			rowRatio: [13/67, 54/67],
			colRatio: [173/471, 199/471, 50/471, 49/471]
		};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([61/652, 26/652, 498/652, 67/652])
						.setHeadRowCnt(2)
						.setHeadColCnt(4)
						.setHeadRowRatio([19/61, 42/61])
						.setHeadColRatio([345/471, 27/471, 50/471, 49/471])
						.howManyBodies(3)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(50)
						.setStartY(57)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		function loadImg(img, cb, data) {
			img.onload = function() {
				cb(data);
			}
		}
		
		
		
		var renderView = function(data) {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			/* // merge cells
	 		cl.mergeCellsVertical(cl.head, "row0", "row1", "col0");
			cl.mergeCellsVertical(cl.head, "row0", "row1", "col1");
			
			cl.mergeCellsHorizon(cl.bodies.body1, "row0", "col2", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row3", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row5", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row7", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row9", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row11", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row13", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row15", "col1", "col3");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row17", "col1", "col3");
	 		
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col0");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col1");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row2", "row9", "col0");
	 		cl.mergeCellsVertical(cl.bodies.body1, "row10", "row17", "col0");
 */
			
			
			// fill data
			
			//head
			cl.fillText(cl.head, "row1", "col2", '<%=table.getValueAt(0,23)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,24)%>',
					'balck', "15px arial", "center", "middle");
			
			
			//body0
			cl.fillText(cl.bodies.body0, "row0", "col1", '<%=table.getValueAt(0,0)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row0", "col3", '<%=table.getValueAt(0,23)%>',
					'balck', "15px arial", "center", "middle");
			
			console.log(data[0][3]);
			
			//body1
			for(var i=2; i < 18; i+=2) {
			
			var row  = "row"+(i);
			var row2 = "row"+(i+1);
			var result = data[0][i+1];
			var result_detail = data[0][i+2];
			console.log(row);
			console.log(row2);
			console.log(result);
			console.log(result_detail);
			
			
			if(result == 'Y'){
			cl.fillText(cl.bodies.body1, row, "col2", result,
				'balck', "15px arial", "center", "middle");	
			}
			else{
			cl.fillText(cl.bodies.body1, row, "col3", result,
				'balck', "15px arial", "center", "middle");		
			}
			
			cl.fillText(cl.bodies.body1, row2, "col1", result_detail,
					'balck', "15px arial", "center", "middle");
			
			}
			
			cl.fillText(cl.bodies.body2, "row1", "col0", '<%=table.getValueAt(0,19)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col1", '<%=table.getValueAt(0,20)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col2", '<%=table.getValueAt(0,21)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col3", '<%=table.getValueAt(0,22)%>',
					'balck', "15px arial", "center", "middle");
			
			<%-- 
			cl.fillText(cl.bodies.body1, "row2", "col2", '<%=table.getValueAt(0,3)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row4", "col2", '<%=table.getValueAt(0,5)%>',
				'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row6", "col2", '<%=table.getValueAt(0,7)%>',
				'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row8", "col2", '<%=table.getValueAt(0,9)%>',
			'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row10", "col2", '<%=table.getValueAt(0,11)%>',
				'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row12", "col2", '<%=table.getValueAt(0,13)%>',
				'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row14", "col2", '<%=table.getValueAt(0,15)%>',
				'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row16", "col2", '<%=table.getValueAt(0,17)%>',
				'balck', "15px arial", "center", "middle");
			
			
			cl.fillText(cl.bodies.body1, "row3", "col1", '<%=table.getValueAt(0,4)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row5", "col1", '<%=table.getValueAt(0,6)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row7", "col1", '<%=table.getValueAt(0,8)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row9", "col1", '<%=table.getValueAt(0,10)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row11", "col1", '<%=table.getValueAt(0,12)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row13", "col1", '<%=table.getValueAt(0,14)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row15", "col1", '<%=table.getValueAt(0,16)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row17", "col1", '<%=table.getValueAt(0,18)%>',
					'balck', "15px arial", "center", "middle"); --%>
			
		}
		loadImg(bgImg, renderView, data);
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="572" height="770">
	</canvas>    
</div>