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
공정관리 - 제품생산일보
*/	
	String checklistFormat = "", prodCd = "", prodRevNo= "",
		   prodGubunBig = "", prodGubunMid = "", prodNm = "",
		   inputAmt = "", outputAmt = "", lossRate = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("prodCd") != null)
		prodCd = request.getParameter("prodCd");
	
	if(request.getParameter("prodRevNo") != null)
		prodRevNo = request.getParameter("prodRevNo");
	
	if(request.getParameter("prodGubunBig") != null)
		prodGubunBig = request.getParameter("prodGubunBig");

	if(request.getParameter("prodGubunMid") != null)
		prodGubunMid = request.getParameter("prodGubunMid");
	
	if(request.getParameter("prodNm") != null)
		prodNm = request.getParameter("prodNm");
	
	if(request.getParameter("inputAmt") != null)
		inputAmt = request.getParameter("inputAmt");
	
	if(request.getParameter("outputAmt") != null)
		outputAmt = request.getParameter("outputAmt");
	
	if(request.getParameter("lossRate") != null)
		lossRate = request.getParameter("lossRate");

	JSONObject jArray = new JSONObject();
	jArray.put("prodCd", prodCd);
	jArray.put("prodRevNo", prodRevNo);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M353S015100E114", jArray);
	VectorToJson vj = new VectorToJson();
	String data = vj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		let data = <%=data%>;
		
		const lossRate = parseFloat(<%=lossRate%>) * 100 + "%";
		
		const ratioArr = data.map(value => value[1] * 100);
		
		let ratioSum = ratioArr.reduce(function(result, item) {
			return result + parseInt(item);
		}, 0);
		
		ratioSum = ratioSum + "%";
		
		let partInputSum = 0; 
		
		let bodyObj = new Object();
		bodyObj.body0 = {
			    rowCnt: 21,
			    colCnt: 4,
			    rowRatio: [23.8/504, 23.8/504, 23.8/504, 23.8/504, 
			    		   23.8/504, 23.8/504, 23.8/504, 23.8/504, 
			    		   23.8/504, 23.8/504, 23.8/504, 23.8/504, 
			    		   23.8/504, 23.8/504, 23.8/504, 23.8/504, 
			    		   23.8/504, 23.8/504, 23.8/504, 23.8/504, 
			    		   23.8/504],
			    colRatio: [132/510, 117/510, 152/510, 107/510],
			};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([140/644, 504/644])
		                .setHeadRowCnt(5)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([29/140, 24/140, 39/140, 24/140, 24/140])
		                .setHeadColRatio([132/510, 117/510, 76/510, 76/510, 107/510])
		                .howManyBodies(1)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(37)
		                .setStartY(50)
		                .setTest(false)
		                .build();
						
		var bgImg = new Image();
		bgImg.src = '<%=checklistFormat%>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// 대분류
			cl.fillText(cl.head, "row0", "col1", "<%=prodGubunBig%>",
					'black', "13px arial", "center", "middle");
			
			// 중분류
			cl.fillText(cl.head, "row0", "col3", "<%=prodGubunMid%>",
					'black', "13px arial", "center", "middle");
			
			// 원료명
			cl.fillText(cl.head, "row2", "col0", "<%=prodNm%>",
					'black', "10.5px arial", "center", "middle");
			
			// 투입량
			cl.fillText(cl.head, "row2", "col1", "<%=inputAmt%>",
						'black', "10.5px arial", "center", "middle");
			
			// 생산량
			cl.fillText(cl.head, "row2", "col2", "<%=outputAmt%>",
						'black', "10.5px arial", "center", "middle");

			// 수율
			cl.fillText(cl.head, "row2", "col3", lossRate,
						'black', "10.5px arial", "center", "middle");
			
			// 배합비율 총합
			cl.fillText(cl.bodies.body0, "row20", "col1", ratioSum,
						'black', "11px arial", "center", "middle");
			
			// row0은 컬럼명이라서 i+1부터 데이터 입력
			for(var i = 0; i < data.length; i++) {
				// 재료명
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col0", data[i][0],
						'black', "10.5px arial", "center", "middle");
				// 배합비율
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col1", ratioArr[i] + "%",
						'black', "11px arial", "center", "middle");
				// 투입량
				var partInputAmt = removeComma("<%=inputAmt%>") * ratioArr[i] / 100;
				cl.fillText(cl.bodies.body0, "row"+[i+1], "col2", addComma(partInputAmt),
						'black', "11px arial", "center", "middle");
				
				partInputSum = parseFloat(partInputSum) + parseFloat(partInputAmt);
			}
			
			// 재료 투입량 총합
			cl.fillText(cl.bodies.body0, "row20", "col2", addComma(partInputSum),
						'black', "11px arial", "center", "middle");
		};
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="750">
	</canvas>
</div>