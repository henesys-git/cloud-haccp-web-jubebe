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
공정관리 - 원료수불일보
*/	
	String checklistFormat = "", checklistId = "", checklistRevNo = "", 
		   ccpDate = "", partCd = "", startDate = "", endDate = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");

	if(request.getParameter("ccpDate") != null)
		ccpDate = request.getParameter("ccpDate");
	
	if(request.getParameter("partCd") != null)
		partCd = request.getParameter("partCd");
	
	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");
	
	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");
	
	JSONObject jArray = new JSONObject();
	jArray.put("partCd", partCd);
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M353S010100E004", jArray);
	VectorToJson vj = new VectorToJson();
	String data = vj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		var prevStock = data[0][5];	// 전기재고
		data.splice(0, 1);			// 전기재고용 행 삭제
		
		if(data.length > 25) {
			heneSwal.warning("조회된 데이터가 25건 이하가 되도록 날짜 설정을 다시 해주세요");
		}
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 26,
			    colCnt: 7,
			    rowRatio: [23/581, 22/581, 22/581, 23/581, 
			    		   22/581, 22/581, 23/581, 22/581, 
			    		   22/581, 23/581, 22/581, 22/581, 
			    		   23/581, 22/581, 22/581, 23/581, 
			    		   22/581, 22/581, 23/581, 22/581, 
			    		   23/581, 22/581, 22/581, 23/581, 
			    		   22/581, 22/581],
			    colRatio: [74/511, 86/511, 62/511, 62/511, 
			    		   59/511, 65/511, 101/511]
			};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([117/698, 581/698])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(2)
		                .setHeadRowRatio([73/117, 44/117])
		                .setHeadColRatio([74/511, 435/511])
		                .howManyBodies(1)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(37)
		                .setStartY(26)
		                .setTest(false)
		                .build();
						
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// 원료명 입력
			cl.fillText(cl.head, "row1", "col1", vPartNm,
					'black', "15px arial", "left", "middle");
			
			// 전기이월 데이터 입력
			cl.fillText(cl.bodies.body0, "row1", "col2", prevStock,
						'black', "10.5px arial", "center", "middle");
			
			// 나머지 데이터 입력
			// row0은 컬럼명이라서 i+1부터 데이터 입력
			for(var i = 0; i < data.length; i++) {
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col0", data[i][0],
						'black', "10.5px arial", "center", "middle");
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col1", data[i][1],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col2", data[i][2],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col3", data[i][3],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col4", data[i][4],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col5", data[i][5],
						'black', "11px arial", "center", "middle");
			}
			 
		};
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="750">
	</canvas>
</div>