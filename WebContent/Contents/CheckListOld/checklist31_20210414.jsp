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
제조시설 및 설비점검표 (S838S020900)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", 
		   checklist_rev_no = "", regist_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_date", regist_date);	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020900E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 25,
			    colCnt: 9,
			    rowRatio: [24/583, 25/583, 25/583, 24/583, 25/583, 
			    		   22/583, 25/583, 22/583, 21/583, 23/583,
			    		   22/583, 25/583, 24/583, 24/583, 22/583,
			    		   24/583, 21/583, 19/583, 21/583, 20/583,
			    		   20/583, 23/583, 22/583, 30/583, 30/583],
			    colRatio: [11/497, 59/497, 74/497, 175/497, 37/497,
			    	 	   34/497, 37/497, 33/497, 35/497],
		};


		bodyObj.body1 = {
		    rowCnt: 4,
		    colCnt: 5,
		    rowRatio: [20/71, 18/71, 10/71, 23/71],
		    colRatio: [70/497, 137/497, 127/497, 79/497, 82/497],
		};


		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([60/714, 583/714, 71/714])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(1)
		                .setHeadRowRatio([45/60, 15/60])
		                .setHeadColRatio([495/497])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(44)
		                .setStartY(44)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// mergeCell
			//body1
			cl.mergeCellsVertical(cl.bodies.body1, "row2", "row3", "col1");
			cl.mergeCellsVertical(cl.bodies.body1, "row2", "row3", "col2");
			
			// fillText
			//body0
			for(let i = 0; i < data.length; i++) {
				var col = "col" + (4 + i);
				var date = data[i][2];
				var listCount = bodyObj.body0.rowCnt;
				
				cl.fillText(cl.bodies.body0, "row0", col, date,
					'black', "12px arial", "center", "middle");
				
				// 점검항목 				
				var check = new Array();
				check = data[i][3].slice(1, -1).split(",");
				var dataArr = check;
				dataArr.push(data[i][4]);	// 생산팀장
				dataArr.push(data[i][5]);	// HACCP 팀장
				
				for(let j=0; j<listCount-1; j++){
					
					var row = "row" + (j+1);
					
					cl.fillText(cl.bodies.body0, row, col, dataArr[j],
						'black', "12px arial", "center", "middle");
					
				}
				
			}
			
			//body1
			cl.fillText(cl.bodies.body1, "row2", "col0", data[0][6], "black", "12px arial", "center", "top");
			cl.fillText(cl.bodies.body1, "row3", "col0", data[0][7], "black", "12px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row2", "col1", data[0][8], "black", "12px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row2", "col2", data[0][9], "black", "12px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row3", "col3", data[0][10], "black", "12px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row3", "col4", data[0][11], "black", "12px arial", "center", "middle");
			
	/*		
			
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
				
				var col;
				
				if(data[r][8] == "Y"){ col = "col5"; }
				else { col = "col6"; }
				
				if(r == 1 || r == 3 || r == 10) continue;  
				
				cl.fillText(cl.bodies.body1, "row"+r, col, "O", "black", "bold 13px arial", "center", "middle");
			}
	*/
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="588" height="804">
	</canvas>    
</div>