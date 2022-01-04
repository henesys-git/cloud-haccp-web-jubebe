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
방충방서 점검표 캔버스 (S838S020400)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", regist_date = "", checklist_rev_no = "", checklist_date ="";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	JSONObject jArray = new JSONObject();
	
	jArray.put("regist_date", regist_date);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S020400E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>; 
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 14,
		    colCnt: 14,
		    rowRatio: [20/493, 28/493, 39/493, 41/493, 39/493,
		    		   39/493, 38/493, 40/493, 38/493, 36/493, 
		    		   35/493, 36/493, 33/493, 31/493],
		    colRatio: [69/483, 65/483, 28/483, 27/483, 34/483, 
		    		   26/483, 27/483, 27/483, 36/483, 30/483, 
		    		   31/483, 28/483, 26/483, 27/483],
		};

		bodyObj.body1 = {
		    rowCnt: 5,
		    colCnt: 4,
		    rowRatio: [30/123, 25/123, 24/123, 22/123, 22/123],
		    colRatio: [106/483, 143/483, 101/483, 131/483],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([76/692, 493/692, 123/692])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(7)
		                .setHeadRowRatio([16/76, 33/76, 27/76])
		                .setHeadColRatio([49/483, 192/483, 35/483, 27/483, 66/483, 59/483, 53/483])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(43)
		                .setStartY(58)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// merge cells
			cl.mergeCellsHorizon(cl.head, "row2", "col4", "col6");
			
			// fill data
			//head
			cl.fillText(cl.head, "row1", "col4", '<%=table.getValueAt(0,6)%>',
					'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col5", '<%=table.getValueAt(0,7)%>',
					'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col6", '<%=table.getValueAt(0,8)%>',
					'black', "13px arial", "center", "middle");
			
			cl.fillText(cl.head, "row2", "col1", '<%=table.getValueAt(0,2)%>',
					'black', "14px arial", "center", "middle");
			cl.fillText(cl.head, "row2", "col4", '<%=table.getValueAt(0,6)%>',
					'black', "14px arial", "center", "middle");
			
			//body0
			//해충 & 설치위치
			var insectArr = data[0][3].slice(1, -1).split(",");
			var positionArr = data[0][4].slice(1, -1).split(",");
			var cnt = 72;
			for(let i=0; i<10; i++){
				var row = "row"+(i+2);
			
				if(i<6){
				
					for(let j=0; j<12; j++){
						
						var col = "col" + (j+2);
											 
						cl.fillText(cl.bodies.body0, row, col, insectArr[j+(12*i)],
								'black', "14px arial", "center", "middle");

					}
					
				} else {
					
					for(let j=0; j<2; j++){
						
						cl.fillText(cl.bodies.body0, row, "col"+(j+12), insectArr[cnt],
								'black', "14px arial", "center", "middle");

						cnt++;
					}
					
					cl.fillText(cl.bodies.body0, row, "col1", positionArr[i-6],
							'black', "12px arial", "center", "middle");
				}
				
			}
			
			//body1
			//이상 기록
			if(data[0][5].length > 2){
			
				var detailArr = data[0][5].slice(1, -1).split(",");
				var datalen = (detailArr.length / 4);
				for(let d = 0; d < datalen; d++){
					var row = "row"+(d+1);
					
					for(let t = 0; t < 4; t++){
						
						cl.fillText(cl.bodies.body1, row, "col"+t, detailArr[t+(4*d)],
								'black', "12px arial", "center", "middle");
						
					}
					
				}
			}
		}; 
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="571" height="810">
	</canvas>    
</div>