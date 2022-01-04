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
제품운송 차량관리 기록 (S838S100200)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", checklistDate = "";
	
	String regist_seq_no = "", drive_date = "";
	
	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
		
	if(request.getParameter("checklistDate") != null)
		checklistDate = request.getParameter("checklistDate");
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("drive_date") != null)
		drive_date = request.getParameter("drive_date");

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("drive_date", drive_date);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S100200E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;		 
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 3,
		    colCnt: 3,
		    rowRatio: [30/80, 26/80, 24/80],
		    colRatio: [80/495, 300/495, 113/495],
		};

		bodyObj.body1 = {
		    rowCnt: 10,
		    colCnt: 6,
		    rowRatio: [32/317, 31/317, 29/317, 29/317, 30/317, 32/317, 35/317, 33/317, 35/317, 31/317],
		    colRatio: [80/495, 65/495, 64/495, 79/495, 60/495, 145/495],
		};

		bodyObj.body2 = {
		    rowCnt: 3,
		    colCnt: 3,
		    rowRatio: [20/184, 87/184, 77/184],
		    colRatio: [192/495, 200/495, 101/495],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([95/676, 80/676, 317/676, 184/676])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([25/95, 57/95, 13/95])
		                .setHeadColRatio([331/495, 19/495, 48/495, 48/495, 47/495])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(40)
		                .setStartY(55)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
			cl.mergeCellsHorizon(cl.bodies.body2, "row2", "col0", "col2");
			
			// fill data
			//head
			cl.fillText_left(cl.head, "row1", "col0", data[0][4] + "  " + data[0][5] + "    [" + data[0][6] + "]",
					'black', "14px arial",80, 36);
			
			cl.fillText(cl.head, "row1", "col2", data[0][17],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", data[0][18],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col4", data[0][19],
					'black', "11px arial", "center", "middle");
			
			//body0
			cl.fillText_left(cl.bodies.body0, "row1", "col2", "V",
					'black', "bold 16px arial",data[0][7]=="O"?39:82, 6);
			cl.fillText_left(cl.bodies.body0, "row2", "col2", "V",
					'black', "bold 16px arial",data[0][8]=="O"?39:82, 6);
			
			//body1
			for(let i = 0; i < data.length; i++){
				for(let j = 0; j < bodyObj.body1.colCnt - 1; j++){
					cl.fillText(cl.bodies.body1, "row"+(i + 1), "col"+j, data[i][(j + 12)],
							'black', j==3?"10px arial":"12px arial", "center", "middle");
				}
			}
			
			//body2
   			cl.wrapText_XY(cl, cl.bodies.body2, "row1", "col0", data[0][9],
					'black', "13px arial", "left", "top", 15, 5, 7, 8);		
 			cl.wrapText_XY(cl, cl.bodies.body2, "row1", "col1", data[0][10],
					'black', "13px arial", "left", "top", 16, 5, 7, 8); 
			cl.fillText(cl.bodies.body2, "row1", "col2", data[0][20],
					'black', "13px arial", "center", "middle");
 			cl.wrapText_XY(cl, cl.bodies.body2, "row2", "col0", data[0][11],
					'balck', "13px arial", "left", "top", 37, 3, 7, 29);
		};
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="579" height="788"></canvas>    
</div>