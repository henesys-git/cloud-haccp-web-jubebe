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
부자재 입고검사대장 캔버스 (S838S070200)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", checklistDate = "", 
		   ipgo_date = "";
	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
	
	if(request.getParameter("checklistDate") != null)
		checklistDate = request.getParameter("checklistDate");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklistId", checklistId);
	jArray.put("checklistRevNo", checklistRevNo);
	jArray.put("checklistDate", checklistDate);
	jArray.put("ipgo_date", ipgo_date);
	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070200E144", jArray);
	DoyosaeTableModel table2 = new DoyosaeTableModel("M838S070200E154", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
	String data2 = vtj.vectorToJson(table2.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		var data2 = <%=data2%>;
		console.log(data);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 5,
			colCnt: 5,
			rowRatio: [30/153, 31/153, 31/153, 30/153, 31/153],
			colRatio: [139/523, 96/523, 97/523, 95/523, 99/523]
		};
		
		bodyObj.body1 = {
			rowCnt: 3,
			colCnt: 6,
			rowRatio: [46/138, 47/138, 45/138],
			colRatio: [49/523, 89/523, 97/523, 95/523, 96/523, 98/523]
		};
		
		bodyObj.body2 = {
			rowCnt: 4,
			colCnt: 5,
			rowRatio: [38/152, 38/152, 38/152, 38/152],
			colRatio: [138/523, 97/523, 95/523, 96/523, 98/523]
		};
		
		bodyObj.body3 = {
				rowCnt: 3,
				colCnt: 2,
				rowRatio: [28/221, 63/221, 130/221],
				colRatio: [262/523, 262/523]
			};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([67/731, 153/731, 138/731, 152/731, 221/731])
						.setHeadRowCnt(2)
						.setHeadColCnt(4)
						.setHeadRowRatio([23/67, 44/67])
						.setHeadColRatio([394/523, 23/523, 54/523, 55/523])
						.howManyBodies(4)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(29)
						.setStartY(42)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
	 		cl.mergeCellsVertical(cl.head, "row0", "row1", "col0");
			cl.mergeCellsVertical(cl.head, "row0", "row1", "col1");
			
			cl.mergeCellsVertical(cl.bodies.body1, "row0", "row2", "col0");

			cl.mergeCellsHorizon(cl.bodies.body3, "row2", "col0", "col1");
			
			// fill data
			
			//head
			cl.fillText(cl.head, "row1", "col2", '<%=table.getValueAt(0,3)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,5)%>',
					'balck', "15px arial", "center", "middle");
			
			cl.fillText(cl.bodies.body3, "row1", "col0", '<%=table.getValueAt(0,6)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body3, "row1", "col1", '<%=table.getValueAt(0,7)%>',
				'balck', "15px arial", "center", "middle");
			
			//body
			for(var i=0; i<data2.length; i++){
			
			var standard_yn = data2[i][9];
			var packing_status = data2[i][10];
			var visual_inspection = data2[i][11];
			var car_clean = data2[i][12];
			var docs_yn = data2[i][13];
			var unsuit_reaction = data2[i][14];
			
				
			//body0
			cl.fillText(cl.bodies.body0, "row0", "col"+[i+1], data2[i][1],
						'balck', "15px arial", "center", "1iddle");
			cl.fillText(cl.bodies.body0, "row1", "col"+[i+1], data2[i][4],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row2", "col"+[i+1], data2[i][5],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row3", "col"+[i+1], data2[i][7],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row4", "col"+[i+1], data2[i][6],
					'balck', "15px arial", "center", "middle");
			
			//body1
			
			//body1
			if(standard_yn == '적합'){
			cl.fillText(cl.bodies.body1, "row0", "col"+[i+2], "O",
			'balck', "30px arial", "right", "middle");
			} else{
			cl.fillText(cl.bodies.body1, "row0", "col"+[i+2], "O",
			'balck', "30px arial", "left", "middle");
			}
			
			if(packing_status == '적합'){
			cl.fillText(cl.bodies.body1, "row1", "col"+[i+2], "O",
			'balck', "30px arial", "right", "middle");
			} else{
			cl.fillText(cl.bodies.body1, "row1", "col"+[i+2], "O",
			'balck', "30px arial", "left", "middle");
			}
			
			if(visual_inspection == '양호'){
			cl.fillText(cl.bodies.body1, "row2", "col"+[i+2], "O",
			'balck', "30px arial", "right", "middle");
			} else{
			cl.fillText(cl.bodies.body1, "row2", "col"+[i+2], "O",
			'balck', "30px arial", "left", "middle");
			}
			
		/* 	cl.fillText(cl.bodies.body1, "row0", "col"+[i+2], data[i][17],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row1", "col"+[i+2], data[i][18],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row2", "col"+[i+2], data[i][19],
					'balck', "15px arial", "center", "middle"); */
			
			
			//body2
			
			if(car_clean == '양호'){
				cl.fillText(cl.bodies.body2, "row0", "col"+[i+1], "O",
				'balck', "30px arial", "right", "middle");
				} else{
				cl.fillText(cl.bodies.body2, "row0", "col"+[i+1], "O",
				'balck', "30px arial", "left", "middle");
				}
				
			if(docs_yn == '유'){
				cl.fillText(cl.bodies.body2, "row1", "col"+[i+1], "O",
				'balck', "30px arial", "right", "middle");
				} else{
				cl.fillText(cl.bodies.body2, "row1", "col"+[i+1], "O",
				'balck', "30px arial", "left", "middle");
				}
				
			if(unsuit_reaction == '반품'){
				cl.fillText(cl.bodies.body2, "row2", "col"+[i+1], "O",
				'balck', "30px arial", "right", "middle");
				} else{
				cl.fillText(cl.bodies.body2, "row2", "col"+[i+1], "O",
				'balck', "30px arial", "left", "middle");
				}
			
			/* cl.fillText(cl.bodies.body2, "row0", "col"+[i+1], data[i][20],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col"+[i+1], data[i][21],
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row2", "col"+[i+1], data[i][22],
					'balck', "15px arial", "center", "middle"); */
			cl.fillText(cl.bodies.body2, "row3", "col"+[i+1], data2[i][15],
					'balck', "15px arial", "center", "middle");
			}
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="583" height="810">
	</canvas>    
</div>