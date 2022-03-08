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
CCP 2P 모니터링일지 캔버스 (S838S015300)
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

	DoyosaeTableModel table = new DoyosaeTableModel("M838S015300E144", jArray);
	DoyosaeTableModel table2 = new DoyosaeTableModel("M838S015300E154", jArray);
	
	VectorToJson vtj = new VectorToJson();
	
	String data = vtj.vectorToJson(table.getVector());
	String data2 = vtj.vectorToJson(table2.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0];
		var data2 = <%=data2%>;
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 6,
		    colCnt: 2,
		    rowRatio: [26/224, 28/224, 21/224, 59/224, 28/224, 62/224],
		    colRatio: [58/486, 425/486],
		};

		bodyObj.body1 = {
		    rowCnt: 9,
		    colCnt: 7,
		    rowRatio: [40/309, 34/309, 34/309, 33/309, 34/309, 34/309, 33/309, 34/309, 33/309],
		    colRatio: [58/486, 53/486, 69/486, 45/486, 45/486, 50/486, 163/486],
		};

		bodyObj.body2 = {
		    rowCnt: 2,
		    colCnt: 3,
		    rowRatio: [33/64, 31/64],
		    colRatio: [180/486, 140/486, 163/486],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([80/677, 224/677, 309/677, 64/677])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(6)
		                .setHeadRowRatio([19/80, 61/80])
		                .setHeadColRatio([236/486, 86/486, 18/486, 48/486, 48/486, 47/486])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(50)
		                .setStartY(44)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// fill data
			//head
			for(let h = 0; h < cl.head.colCnt-1; h++){
				if(h<2){
					cl.fillText_left(cl.head, "row1", "col"+h, data[2+h], 'black', "14.5px arial", 16, 44);
				} else {
					cl.fillText(cl.head, "row1", "col"+(1+h), data[2+h], 'black', "10px arial", "center", "middle");	
				}
			}
 						
			//body1
			for(let i = 0; i < data2.length; i++){
				var row = "row"+(i+1); 
				if(i == (data2.length-1) && data2[i][2] == "작업후"){ row = "row8"; }
				for(let j=1; j<bodyObj.body1.colCnt; j++){
					var col = "col"+j;
					if(j == 2 && data2[i][j].length > 6){
						if(data2[i][j].length>12){
							cl.wrapText_XY(cl, cl.bodies.body1, row, col, data2[i][j], 'black', "8px arial", "center", "top", 9, 3, 36, 6);	
						} else {
							cl.wrapText_XY(cl, cl.bodies.body1, row, col, data2[i][j], 'black', "10.5px arial", "center", "top", 6, 3, 35, 6);	
						}
					} else {
						cl.fillText(cl.bodies.body1, row, col, data2[i][j],
								'black', ((j==3||j==4)?"16px":"11px")+" arial", "center", (j==1 && (i==0 || (i==data2.length-1 && data2[i][2] == "작업후")))?"top":"middle");
					}
					
				}
			} 
			
			//body2
 			for(let r = 0; r < bodyObj.body2.rowCnt; r++){
				for(let s = 1; s < bodyObj.body2.colCnt; s++){
					cl.fillText(cl.bodies.body2, "row"+r, "col"+s, data[6+s+(2*r)],'black', "14px arial", s==1?"left":"center", "middle");
				}
			} 

		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="589" height="767">
	</canvas>    
</div>