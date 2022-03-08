<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%
/* checklist14_20210510.jpg */	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", seq_no = "";
		
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");
		   
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S090200E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0]; 
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 2,
		    colCnt: 4,
		    rowRatio: [31/175, 144/175],
		    colRatio: [64/474, 234/474, 52/474, 121/474],
		};

		bodyObj.body1 = {
		    rowCnt: 2,
		    colCnt: 3,
		    rowRatio: [35/71, 36/71],
		    colRatio: [64/474, 36/474, 371/474],
		};

		bodyObj.body2 = {
		    rowCnt: 2,
		    colCnt: 3,
		    rowRatio: [151/314, 163/314],
		    colRatio: [64/474, 79/474, 328/474],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([72/632, 175/632, 71/632, 314/632])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([23/72, 49/72])
		                .setHeadColRatio([280/474, 26/474, 53/474, 57/474, 55/474])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(56)
		                .setStartY(58)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
			cl.mergeCellsHorizon(cl.bodies.body0, "row1", "col1", "col3");
			
			// fill data
			//head
			for(let i = 0; i < cl.head.colCnt - 2; i++){
			
				cl.fillText(cl.head, "row1", "col"+(i+2), data[(i+10)],
						'black', "14px arial", "center", "middle");
				
			}
			
			//body0
			var claim_date = '<%=table.getValueAt(0,3)%>';
			var dateArr = claim_date.split("-");
			
			cl.fillText_left(cl.bodies.body0, "row0", "col1", dateArr[0] + " 년 " + dateArr[1] + " 년 " + dateArr[2] + " 일",
						'black', "14px arial", 10, 9.5);

			cl.fillText_left(cl.bodies.body0, "row0", "col3", data[4],
					'black', "14px arial", 10, 9.5);
			
			cl.wrapText_XY(cl, cl.bodies.body0, "row1", "col1", data[5],
					'black', "14px arial", "left", "top", 30, 10, 10, 10);
			
			//body1
			cl.fillText_left(cl.bodies.body1, "row0", "col2", data[6],
					'black', "14px arial", 10, 12);
			cl.fillText_left(cl.bodies.body1, "row1", "col2", data[7],
					'black', "14px arial", 10, 12);
			
			//body2
			cl.wrapText_XY(cl, cl.bodies.body2, "row0", "col2", data[8],
					'black', "14px arial", "left", "top", 25, 9, 10, 10);
			cl.wrapText_XY(cl, cl.bodies.body2, "row1", "col2", data[9],
					'black', "14px arial", "left", "top", 25, 10, 10, 10);
			
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="588" height="750">
	</canvas>    
</div>