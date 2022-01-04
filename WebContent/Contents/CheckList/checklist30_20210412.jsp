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
작업장 낙하세균 검사기록 (S838S020850)
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

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020850E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 2,
			    colCnt: 6,
			    rowRatio: [25/48, 23/48],
			    colRatio: [72/466, 36/466, 36/466, 193/466, 89/466, 38/466],
		};

		bodyObj.body1 = {
		    rowCnt: 15,
		    colCnt: 5,
		    rowRatio: [38/574, 36/574, 34/574, 33/574, 34/574, 32/574, 33/574, 34/574, 33/574, 33/574, 33/574, 34/574, 33/574, 32/574, 102/574],
		    colRatio: [41/466, 72/466, 126/466, 112/466, 113/466],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([62/684, 48/684, 574/684])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(3)
		                .setHeadRowRatio([22/62, 40/62])
		                .setHeadColRatio([351/466, 32/466, 81/466])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(60)
		                .setStartY(42)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// fillText
			//head
			cl.fillText(cl.head, "row1", "col2", data[0][18], "black", "13px arial", "center", "middle");
			
			//body0
			for(var b = 0; b<2; b++){
				
				cl.fillText_left(cl.bodies.body0, "row"+b, "col1", data[0][3+(b*3)], "black", "13px arial", 5, 10-(b*5));
				cl.fillText_left(cl.bodies.body0, "row"+b, "col2", data[0][4+(b*3)], "black", "13px arial", 5, 10-(b*5));
				cl.fillText_left(cl.bodies.body0, "row"+b, "col3", data[0][5+(b*3)], "black", "13px arial", 5, 10-(b*5));
				cl.fillText(cl.bodies.body0, "row"+b, "col4", data[0][16+b], "black", "13px arial", "center", "middle");
				
			}
					
			//body1
			var listCount = bodyObj.body1.rowCnt;
			var cnt = 0;
			var flag = false;
			for(let i=0; i<data.length; i++){
				
				if(i > 0 && data[i][10] != data[i-1][10]){ 
					
					if(flag == true || i > 4){
						cnt = 8 - i;
					} else{
						cnt = 4 - i;
					}
					flag = true;
				} else {
					flag = false;
				}
				
				var row = "row"+(cnt+i+2);
				
				for(var c=0; c<4; c++){
					
					var col = "col"+(1+c);
					
					cl.fillText(cl.bodies.body1, row, col, data[i][12+c], "black", "13px arial", "center", "middle");
					
				}
				
			} 

		};
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="588" height="770">
	</canvas>    
</div>