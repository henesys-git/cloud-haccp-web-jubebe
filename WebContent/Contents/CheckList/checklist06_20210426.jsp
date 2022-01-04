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
일일위생점검일지 캔버스 (S838S020100)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistDate = "", check_date = "";	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklist_date") != null)
		checklistDate = request.getParameter("checklist_date");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020100E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>; 
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 28,
		    colCnt: 4,
		    rowRatio: [21/527, 19/527, 19/527, 23/527, 19/527, 20/527, 20/527, 19/527, 17/527, 17/527, 16/527, 20/527, 20/527, 18/527, 19/527, 20/527, 17/527, 17/527, 17/527, 19/527, 22/527, 17/527, 19/527, 17/527, 19/527, 19/527, 18/527, 19/527],
		    colRatio: [41/490, 318/490, 67/490, 62/490],
		};

		bodyObj.body1 = {
		    rowCnt: 3,
		    colCnt: 2,
		    rowRatio: [34/77, 43/77, 0/77],
		    colRatio: [40/490, 448/490],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([83/687, 527/687, 77/687])
		                .setHeadRowCnt(5)
		                .setHeadColCnt(4)
		                .setHeadRowRatio([22/83, 16/83, 17/83, 16/83, 12/83])
		                .setHeadColRatio([295/490, 63/490, 65/490, 62/490, 3/490])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(40)
		                .setStartY(55)
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
			// === draw background ===
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// === fill data ===
			//head
 			cl.fillText_left(cl.head, "row0", "col2", data[0][3]+"      "+data[0][4],
						'black', "12px arial", 5,7);
			
			for(var p=0; p<3; p++){
				cl.fillText(cl.head, "row"+(p+1), "col2", data[0][10-p],
						'black', "11px arial", "center", "middle");	
			}
			
			//body0
			var results = data[0][5].slice(1,-1).split(",");
			for(let i = 0; i < results.length; i++) {
				
				cl.fillText(cl.bodies.body0, "row"+i, "col2", results[i].trim(),
						'black', "12px arial", "center", "middle");
				
			}
	
			//body1
			cl.fillText_left(cl.bodies.body1, "row1", "col1", data[0][6],
					'black', "12px arial", 10, 5);
			cl.fillText_left(cl.bodies.body1, "row1", "col1", data[0][7],
					'black', "12px arial", 10, 28);

		}
		
		loadImg(bgImg, renderView, data);
 	});
</script>

<canvas id="myCanvas" width="573" height="799">
</canvas>