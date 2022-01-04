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
개선조치기록부(HACCP관리) 캔버스 (S838S015500)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", seq_no = "";	
	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S015500E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>


<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0]; 
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 2,
			colCnt: 3,
			rowRatio: [18/76, 58/76],
			colRatio: [103/522, 207/522, 209/522]
		};
		
		bodyObj.body1 = {
			rowCnt: 3,
			colCnt: 2,
			rowRatio: [26/255, 50/255, 179/255],		// 26/255 !229!/255 를 더 위으로 맞추기 no center			// 세부 내용 쪽은 x
			colRatio: [102/522, 417/522]		// 102/522 !417!/522 를 더 앞으로 맞추기 no middle
		};
		
		bodyObj.body2 = {
			rowCnt: 4,
			colCnt: 3,
			rowRatio: [88/349, 87/349, 87/349, 87/349],
			colRatio: [102/522, 85/522, 332/522]
		};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([48/728, 76/728, 255/728, 349/728])
						.setHeadRowCnt(1)
						.setHeadColCnt(1)
						.setHeadRowRatio([48/48])
						.setHeadColRatio([522/522])
						.howManyBodies(3)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(50)
						.setStartY(50)
						.setTest(false)
						.build();
		
		
		
		
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// === draw background ===
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// === merge cells ===
	 		cl.mergeCellsVertical(cl.bodies.body2, "row0", "row3", "col0");
			
			// === fill data ===
			//body0
			cl.fillText(cl.bodies.body0, "row1", "col0", data[8],
						'black', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col1", data[9],
					'black', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col2", data[10],
					'black', "15px arial", "center", "middle");
			
			//body1
			cl.fillText_left(cl.bodies.body1, "row1", "col1", data[1], 	// 발생내용
						'black', "15px arial", 15, 15);
			cl.wrapText_XY(cl, cl.bodies.body1, "row2", "col1", data[2],	// 발생원인
						'black', "15px arial", "left", "bottom", 26, 15); 
			
			//body2
			cl.fillText(cl.bodies.body2, "row0", "col2", data[3],
					'black', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col2", data[4],
					'black', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row2", "col2", data[5],
					'black', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row3", "col2", data[6],
					'black', "15px arial", "center", "middle");
		};
 	});

	 
					
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="625" height="829">
	</canvas>    
</div>