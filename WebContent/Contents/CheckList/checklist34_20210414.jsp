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
조도 점검표 (S838S020550)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", 
		   checklist_rev_no = "", check_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020550E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 2,
			    colCnt: 7,
			    rowRatio: [42/90, 48/90],
			    colRatio: [98/487, 37/487, 26/487, 27/487, 41/487, 85/487, 171/487],
		};

		bodyObj.body1 = {
		    rowCnt: 17,
		    colCnt: 7,
		    rowRatio: [24/539, 29/539, 24/539, 24/539, 33/539, 32/539, 30/539, 32/539, 33/539, 29/539, 30/539, 29/539, 30/539, 30/539, 29/539, 30/539, 71/539],
		    colRatio: [98/487, 65/487, 66/487, 85/487, 72/487, 45/487, 54/487],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([77/706, 90/706, 539/706])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(4)
		                .setHeadRowRatio([27/77, 50/77])
		                .setHeadColRatio([314/487, 57/487, 58/487, 55/487])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(42)
		                .setStartY(56)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			//mergeCell
			// body1
			cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col5");
			cl.mergeCellsVertical(cl.bodies.body1, "row0", "row1", "col6");	
			cl.mergeCellsVertical(cl.bodies.body1, "row2", "row3", "col5");
			cl.mergeCellsVertical(cl.bodies.body1, "row2", "row3", "col6");	
			cl.mergeCellsVertical(cl.bodies.body1, "row9", "row10", "col5");
			cl.mergeCellsVertical(cl.bodies.body1, "row9", "row10", "col6");	
			
			// fillText
			//head, body0
			for(var i=0; i<3; i++){
				
				cl.fillText(cl.head, "row1", "col"+(1+i), data[0][9+i], "black", "13px arial", "center", "middle");
				cl.fillText_left(cl.bodies.body0, "row0", "col"+(2+i), data[0][1+i], "black", "12px arial", 1.5, 17);
			}
			
			//body1
			var cnt = bodyObj.body1.rowCnt;
			
			for(var r=0; r<cnt-1; r++){
				
				cl.fillText(cl.bodies.body1, "row"+r, "col4", data[r][7], "black", "13px arial", "center", "middle");
				
				if(r == 1 || r == 3 || r == 10) continue;  
				
				cl.fillText(cl.bodies.body1, "row"+r, data[r][8] == "Y"?"col5":"col6", "O", "black", "30px arial", "center", "middle");
			}
	
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="573" height="822">
	</canvas>    
</div>