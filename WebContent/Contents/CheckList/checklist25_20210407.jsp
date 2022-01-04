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
폐기물 처리 기록부 (S838S020700)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", 
		   checklist_rev_no = "", check_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020750E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 1,
			    colCnt: 8,
			    rowRatio: [49/49],
			    colRatio: [15/491, 43/491, 207/491, 47/491, 44/491, 46/491, 44/491, 43/491],
			};
		
		bodyObj.body1 = {
			    rowCnt: 11,
			    colCnt: 8,
			    rowRatio: [38/432, 38/432, 38/432, 38/432, 37/432, 38/432, 38/432, 37/432, 50/432, 39/432, 41/432],
			    colRatio: [15/491, 43/491, 207/491, 47/491, 44/491, 46/491, 44/491, 43/491],
			};

		bodyObj.body2 = {
		    rowCnt: 3,
		    colCnt: 6,
		    rowRatio: [30/108, 37/108, 41/108],
		    colRatio: [58/491, 86/491, 87/491, 86/491, 86/491, 86/491],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([99/689, 49/689, 432/689, 108/689])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(8)
		                .setHeadRowRatio([34/99, 33/99, 32/99])
		                .setHeadColRatio([219/491, 19/491, 27/491, 47/491, 43/491, 47/491, 44/491, 43/491])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(43)
		                .setStartY(57)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// fillText
			for(let i = 0; i < data.length; i++) {
				var col = "col" + (3 + i);
				var col2 = "col" + (1 + i);
				var date = data[i][0];
				var listCount = bodyObj.body1.rowCnt;
				
				// 월요일~일요일 날짜
				cl.fillText(cl.bodies.body0, "row0", col, date,
							'black', "12px arial", "center", "middle");
				
				cl.fillText(cl.bodies.body2, "row0", col2, date,
						'black', "12px arial", "center", "middle");

				// 점검항목 외 				
				var temp = new Array();
				temp = data[i][1].slice(1, -1).split(",");
				var dataArr = temp;

				var unsuit_detail = data[i][2];
				var improve_action = data[i][3];
				var personWrite = data[i][4];
				var personCheck = data[i][5];
				var personApprove = data[i][6];
				
				cl.fillText(cl.head, "row0", col, personApprove,
						'black', "12px arial", "center", "middle");
				cl.fillText(cl.head, "row1", col, personCheck,
						'black', "12px arial", "center", "middle");
				cl.fillText(cl.head, "row2", col, personWrite,
						'black', "12px arial", "center", "middle");
				
				cl.fillText(cl.bodies.body2, "row1", col2, unsuit_detail,
						'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body2, "row2", col2, improve_action,
						'black', "12px arial", "center", "middle");
				
				// 점검항목 같이
				
				for(let j = 0; j < listCount; j++) {
					var row = "row" + j;
					
					var value = dataArr[j];
					cl.fillText(cl.bodies.body1, row, col, value,
								'black', "12px arial", "center", "middle");
				}

			}
			
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="580" height="805">
	</canvas>    
</div>