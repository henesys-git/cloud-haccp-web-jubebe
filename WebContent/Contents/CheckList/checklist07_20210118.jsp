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
자동 기록관리 시스템 점검 일지 (S838S020200)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", checklistDate = ""; 
	
	String  personWriteId = "", personApproveId = "", personWriter = "", personApprover = "";	
	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
	
	if(request.getParameter("checklist_date") != null)
		checklistDate = request.getParameter("checklist_date");
	
	if(request.getParameter("personWriteId") != null)
		personWriteId = request.getParameter("personWriteId");
	
	if(request.getParameter("personApproveId") != null)
		personApproveId = request.getParameter("personApproveId");
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklistId", checklistId);
	jArray.put("checklistRevNo", checklistRevNo);
	jArray.put("checklistDate", checklistDate);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020200E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		console.log(data);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 11,
			colCnt: 9,
			rowRatio: [15/257, 18/257, 24/257, 26/257, 25/257,
					   27/257, 25/257, 32/257, 30/257, 17/257,
					   18/257],
			colRatio: [44/512, 266/512, 29/512, 28/512, 30/512, 
					   30/512, 28/512, 30/512, 27/512]
		};
		
		bodyObj.body1 = {
			rowCnt: 2,
			colCnt: 4,
			rowRatio: [22/66, 44/66],
			colRatio: [52/512, 195/512, 63/512, 202/512]
		};
		
		bodyObj.body2 = {
			rowCnt: 12,
			colCnt: 9,
			rowRatio: [30/285, 14/285, 18/285, 23/285, 25/285, 
					   27/285, 25/285, 27/285, 31/285, 29/285, 
					   19/285, 17/285],
			colRatio: [44/512, 266/512, 29/512, 28/512, 30/512, 
					   30/512, 28/512, 30/512, 27/512]
		};
		
		bodyObj.body3 = {
				rowCnt: 2,
				colCnt: 4,
				rowRatio: [22/65, 43/65],
				colRatio: [52/512, 195/512, 63/512, 202/512]
			};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([25/698, 257/698, 66/710, 285/710, 65/710 ])
						.setHeadRowCnt(1)
						.setHeadColCnt(1)
						.setHeadRowRatio([25/25])
						.setHeadColRatio([512/512])
						.howManyBodies(4)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(28)
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
			console.log('here');
			console.log(data);
			// === draw background ===
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// === fill data ===
			var week = 7;
				
			for(let i = 0; i < week; i++) {
				var col = "col" + (2 + i);
				var date = data[i][0];
				var listCount = bodyObj.body0.rowCnt;
				console.log(listCount);
				// 월요일~일요일 날짜
				cl.fillText(cl.bodies.body0, "row0", col, date,
							'balck', "12px arial", "center", "middle");

				if(data[i][1]) {	// 체크리스트 별 결과값
					var temp = new Array();
					temp = data[i][1].slice(1, -1).split(",");
					var dataArr = temp;
					
					var personWrite = data[i][4];
					var personApprove = data[i][5];
					console.log(personWrite);
					console.log(personApprove);
					dataArr.push(personWrite);
					dataArr.push(personApprove);
				} else {	// 해당 날짜에 체크리스트 등록 안됐으면 빈 배열 생성
					var dataArr = [];
					
					for(let k = 0; k <listCount; k++) {
						dataArr.push("");	
					}
					
					dataArr.push("");	// 작성자 공간 채움
					dataArr.push("");	// 승인자 공간 채움
				}
				
				
				  for(let j = 2; j < listCount; j++) {
					var row = "row" + (j);
					var value = dataArr[j-2];
					cl.fillText(cl.bodies.body0, row, col, value,
								'balck', "12px arial", "center", "middle");
				} 
			}
			
			var week2 = 14;
			
			for(let i = 7; i < week2; i++) {
				var col = "col" + (i - 5);
				var date = data[i][0];
				var listCount = bodyObj.body2.rowCnt;
				console.log(listCount);
				// 아래쪽 월요일~일요일 날짜
				cl.fillText(cl.bodies.body2, "row1", col, date,
							'balck', "12px arial", "center", "middle");

				if(data[i][1]) {	// 체크리스트 별 결과값
					var temp = new Array();
					temp = data[i][1].slice(1, -1).split(",");
					var dataArr = temp;
					
					var personWrite = data[i][4];
					var personApprove = data[i][5];
					dataArr.push(personWrite);
					dataArr.push(personApprove);
				} else {	// 해당 날짜에 체크리스트 등록 안됐으면 빈 배열 생성
					var dataArr = [];
					
					for(let k = 0; k <listCount; k++) {
						dataArr.push("");	
					}
					
					dataArr.push("");	// 작성자 공간 채움
					dataArr.push("");	// 승인자 공간 채움
				}
				
				
				  for(let j = 3; j < listCount-3; j++) {
					var row = "row" + (j);
					var value = dataArr[j-3];
					cl.fillText(cl.bodies.body2, row, col, value,
								'balck', "12px arial", "center", "middle");
				} 
			}
			
			
			
			// 부적합 사항에 데이터를 넣는다
			for(var i = 0; i < week; i++) {
				var unsuit_detail = data[i][2];
				
				if(unsuit_detail) {
					cl.fillText(cl.bodies.body1, "row1", "col1", unsuit_detail,
								'balck', "12px arial", "center", "middle");
					// 줄바꿈
				}
			}
			
			// 개선조치사항에 데이터를 넣는다
			for(var i = 0; i < week; i++) {
				var improve_action = data[i][3];
				if(improve_action) {
					cl.fillText(cl.bodies.body1, "row1", "col3", improve_action,
								'balck', "12px arial", "center", "middle");
					// 줄바꿈
				}
			}
			
			
			// 아래쪽 부적합 사항에 데이터를 넣는다
			for(var i = 7; i < week2; i++) {
				var unsuit_detail = data[i][2];
				
				if(unsuit_detail) {
					cl.fillText(cl.bodies.body3, "row1", "col1", unsuit_detail,
								'balck', "12px arial", "center", "middle");
					// 줄바꿈
				}
			}
			
			// 아래쪽 개선조치사항에 데이터를 넣는다
			for(var i = 7; i < week2; i++) {
				var improve_action = data[i][3];
				if(improve_action) {
					cl.fillText(cl.bodies.body3, "row1", "col3", improve_action,
								'balck', "12px arial", "center", "middle");
					// 줄바꿈
				}
			}
		}
		
		loadImg(bgImg, renderView, data);
		
		<%-- bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
	 		
			cl.mergeCellsHorizon(cl.bodies.body0, "row7", "col0", "col1");
			cl.mergeCellsHorizon(cl.bodies.body0, "row8", "col0", "col1");
			cl.mergeCellsVertical(cl.bodies.body0, "row2", "row6", "col0");
			cl.mergeCellsVertical(cl.bodies.body0, "row0", "row1", "col0");
			cl.mergeCellsVertical(cl.bodies.body0, "row0", "row1", "col1");
			
			cl.mergeCellsHorizon(cl.bodies.body1, "row0", "col0", "col3");
	 		
			cl.mergeCellsHorizon(cl.bodies.body2, "row0", "col0", "col8");
			cl.mergeCellsHorizon(cl.bodies.body2, "row7", "col0", "col1");
			cl.mergeCellsHorizon(cl.bodies.body2, "row8", "col0", "col1");
			cl.mergeCellsVertical(cl.bodies.body2, "row2", "row6", "col0");
			cl.mergeCellsVertical(cl.bodies.body2, "row0", "row1", "col0");
			cl.mergeCellsVertical(cl.bodies.body2, "row0", "row1", "col1");

			cl.mergeCellsHorizon(cl.bodies.body3, "row0", "col0", "col3");
			
		}; --%>
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="572" height="810">
	</canvas>    
</div>