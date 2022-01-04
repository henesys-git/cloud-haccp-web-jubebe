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
공정관리 점검표 (S838S020600)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", 
		   seq_no = "";
	String 	regist_date = "";
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	jArray.put("regist_date", regist_date);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S020600E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
				rowCnt: 2,
				colCnt: 9,
				rowRatio: [24/44, 20/44],
				colRatio: [59/492, 105/492, 146/492, 14/492, 34/492, 42/492, 14/492, 35/492, 41/492]
		};
		
		bodyObj.body1 = {
				rowCnt: 1,
				colCnt: 1,
				rowRatio: [2/2],
				colRatio: [492/492]
		};
		
		bodyObj.body2 = {
				rowCnt: 14,
				colCnt: 7,
				rowRatio: [35/488, 35/488, 35/488, 42/488, 31/488,
						   31/488, 29/488, 28/488, 40/488, 43/488,
						   42/488, 31/488, 31/488, 33/488],
				colRatio: [59/492, 105/492, 146/492, 46/492, 44/492, 48/492, 42/492]
		};
		
		bodyObj.body3 = {
				rowCnt: 3,
				colCnt: 3,
				rowRatio: [17/94, 30/94, 44/94],
				colRatio: [65/492, 216.5/492, 216.5/492]
		};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([71/697, 44/697, 2/697, 486/697, 94/691])		
						.setHeadRowCnt(3)							
						.setHeadColCnt(8)
						.setHeadRowRatio([26/71, 19/71, 26/71])
						.setHeadColRatio([101/492, 50/492, 45/492, 87/492, 27/492, 60/492, 60/492, 60/492])
						.howManyBodies(4)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(45)
						.setStartY(44)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
	
			// mergeCell
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col5");
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col6");
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col7");
			
			var arr = [0,1,2,3,11,13]

			for(var i=0; i<arr.length; i++){
				
				cl.mergeCellsHorizon(cl.bodies.body2, "row"+arr[i], "col3", "col4");
				cl.mergeCellsHorizon(cl.bodies.body2, "row"+arr[i], "col5", "col6");
				
			}
			
			// fill data
			//head		
			 cl.fillText(cl.head, "row2", "col1", data[0][3],
				'black', "13px arial", "right", "middle");
			cl.fillText(cl.head, "row2", "col2", data[0][4],
				'black', "13px arial", "right", "middle");
			cl.fillText_left(cl.head, "row2", "col3", data[0][5],
				'black', "13px arial", 11, 7); 
			
			cl.fillText(cl.head, "row1", "col5", data[0][27],
				'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col6", data[0][28],
				'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col7", data[0][29],
				'black', "13px arial", "center", "middle");
			
			//body0 - body2
			var am = 0, pm = 1;
			
			if(data.length == 1){
				
				switch(data[0][6]) {
				case "am" : 
						am = 0;
						morning(am);
						break;
				case "pm" : 
						pm = 0;
						afternoon(pm);
						break;
				}
				
			} else {
				
				morning(am);
				afternoon(pm);
				
			}
			
			/* 	오전오후 둘 다 있을때만 출력하게 하려면 이게 코드 길이가 적음 /////
			
			//body0
			cl.fillText(cl.bodies.body0, "row1", "col4", data[0][9],
				'black', "13px arial", "right", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col5", data[0][10],
				'black', "13px arial", "right", "middle");
			
			cl.fillText(cl.bodies.body0, "row1", "col7", data[1][9],
				'black', "13px arial", "right", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col8", data[1][10],
				'black', "13px arial", "right", "middle");
			
			//body2
			for(var i=0; i<data.length+30; i++) {			
					
				var j = 11;

				if(j == 25) break;
				
				if(arr[i] == i || arr[4] == i || arr[5] == i) {
					
					cl.fillText(cl.bodies.body2, "row"+[i], "col3", data[0][j+i],
							'black', "13px arial", "center", "middle");
					
					cl.fillText(cl.bodies.body2, "row"+[i], "col5", data[1][j+i],
							'black', "13px arial", "center", "middle");
					
				} else {
					
					switch (data[0][j+i]) {
						case "Y":
							cl.fillText(cl.bodies.body2, "row"+[i], "col3", "O",
									'black', "bold 16.5px arial", "center", "middle");
							break;
	
						case "N":
							cl.fillText(cl.bodies.body2, "row"+[i], "col4", "O",
									'black', "bold 16.5px arial", "center", "middle");
							break;
					}
					
					switch (data[1][j+i]) {
						case "Y":
							cl.fillText(cl.bodies.body2, "row"+[i], "col5", "O",
									'black', "bold 16.5px arial", "center", "middle");
							break;
	
						case "N":
							cl.fillText(cl.bodies.body2, "row"+[i], "col6", "O",
									'black', "bold 16.5px arial", "center", "middle");
							break;
					}

				}
				
				j++;
			}
 */			
			//body3
			cl.fillText(cl.bodies.body3, "row2", "col0", data[0][2],
				'black', "11.75px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row2", "col1", data[0][25],
				'black', "13px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row2", "col2", data[0][26],
					'black', "13px arial", "center", "middle");
			
			
			// 오전 모아놓기
			function morning(am){
				
				//body0
				cl.fillText_left(cl.bodies.body0, "row1", "col4", data[am][9],
					'black', "13px arial", 2, 2.5);
				cl.fillText_left(cl.bodies.body0, "row1", "col5", data[am][10],
					'black', "13px arial", 3, 2.5);
				//body2
				for(var i=0; i<data.length+30; i++) {			
						
					var j = 11;

					if(j == 25) break;
					
					if(arr[i] == i || arr[4] == i || arr[5] == i) {
						
						cl.fillText(cl.bodies.body2, "row"+[i], "col3", data[am][j+i],
								'black', "13px arial", "center", "middle");
						
					} else {
						
						switch (data[am][j+i]) {
							case "Y":
								cl.fillText(cl.bodies.body2, "row"+[i], "col3", "O",
										'black', "30px arial", "center", "middle");
								break;
		
							case "N":
								cl.fillText(cl.bodies.body2, "row"+[i], "col4", "O",
										'black', "30px arial", "center", "middle");
								break;
						}

					}
					
					j++;
				}
				
			}// end of function morning()
			
			// 오후 모아놓기
			function afternoon(pm){
				
				//body0
				cl.fillText_left(cl.bodies.body0, "row1", "col7", data[pm][9],
					'black', "13px arial", 2, 2.5);
				cl.fillText_left(cl.bodies.body0, "row1", "col8", data[pm][10],
					'black', "13px arial", 3, 2.5);
			
				//body2
				for(var i=0; i<data.length+30; i++) {			
						
					var j = 11;
					
					if(j == 25) break;
					
					if(arr[i] == i || arr[4] == i || arr[5] == i) {
						
						cl.fillText(cl.bodies.body2, "row"+[i], "col5", data[pm][j+i],
								'black', "13px arial", "center", "middle");
						
					} else {
											
						switch (data[pm][j+i]) {
							case "Y":
								cl.fillText(cl.bodies.body2, "row"+[i], "col5", "O",
										'black', "30px arial", "center", "middle");
								break;
		
							case "N":
								cl.fillText(cl.bodies.body2, "row"+[i], "col6", "O",
										'black', "30px arial", "center", "middle");
								break;
						}

					}
					
					j++;
				}
				
			} // end of function afternoon()
						
		};
		
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="790">
	</canvas>    
</div>