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
제품 및 작업도구 미생물검사 기록 캔버스 (S838S070750)
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

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070750E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>; 
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 14,
		    colCnt: 7,
		    rowRatio: [28/420, 27/420, 31/420, 30/420, 31/420, 30/420, 31/420, 30/420, 31/420, 30/420, 31/420, 30/420, 30/420, 30/420],
		    colRatio: [41/490, 106/490, 53/490, 76/490, 76/490, 76/490, 59/490],
		};


		bodyObj.body1 = {
		    rowCnt: 2,
		    colCnt: 2,
		    rowRatio: [60/129, 69/129],
		    colRatio: [199/490, 288/490],
		};


		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([124/673, 420/673, 129/673])
		                .setHeadRowCnt(4)
		                .setHeadColCnt(6)
		                .setHeadRowRatio([25/124, 45/124, 28/124, 26/124])
		                .setHeadColRatio([70/490, 31/490, 32/490, 239/490, 36/490, 79/490])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(43)
		                .setStartY(42)
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

			// merge cells
	 		cl.mergeCellsVertical(cl.bodies.body0, "row2", "row5", "col0");
	 		cl.mergeCellsVertical(cl.bodies.body0, "row6", "row9", "col0");
	 		cl.mergeCellsVertical(cl.bodies.body0, "row10", "row13", "col0");

			// === fill data ===
			//head
			cl.fillText(cl.head, "row1", "col5", data[0][24],
						'black', "14px arial", "center", "middle");	
			for(let i=0; i<2; i++){
				for(let j=0; j<4; j++){
					
					cl.fillText_left(cl.head, "row"+(i+2), "col"+(j+1), data[0][(16+(4*i)+j)],
							'black', j==3?"13px arial":"12px arial", 1.5, 13-(10*i));
				}	
			}
			
			//body0
			var colVal = [5,7,13,9,10,14,15];
			var plus = 2;
			for(let x=0; x<data.length; x++){
				
				if(x > 0 && data[x][5] != data[x-1][5]){ 
				
					if(x > 4){
						plus = (8-x)+2;
					} else{
						plus = (4-x)+2;
					}
					 
				}
				
				var row = "row" + (x+plus);
				
				cl.fillText(cl.bodies.body0, row.substr(3)<6?"row2":row.substr(3)<10?"row6":"row10", "col0", data[x][5],
						'black', "11px arxal", "center", "middle");
				
				for(let y=1; y<7; y++){
					
					cl.fillText(cl.bodies.body0, row, "col"+y, data[x][colVal[y]],
							'black', "12px arxal", "center", "middle");
				}	
			}
	
		}
		
		loadImg(bgImg, renderView, data);
 	});
</script>

<canvas id="myCanvas" width="578" height="759">
</canvas>