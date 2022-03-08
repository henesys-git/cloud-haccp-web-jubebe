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
리콜제품 회수결과 보고서 (S838S090100)
*/	
	String loginID = session.getAttribute("login_id").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", 
		   regist_seq_no = "", prod_date = "", prod_cd = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	if(request.getParameter("prod_date") != null)
		prod_date = request.getParameter("prod_date");
	
	if(request.getParameter("prod_cd") != null)
		prod_cd = request.getParameter("prod_cd");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("prod_date", prod_date);
	jArray.put("prod_cd", prod_cd);
	
    DoyosaeTableModel table = new DoyosaeTableModel("M838S090100E134", jArray);	// 출고/회수내역 data
    VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
	
    DoyosaeTableModel table2 = new DoyosaeTableModel("M838S090100E154", jArray); 	// haccp_recall
    VectorToJson vtj2 = new VectorToJson();
	String data2 = vtj.vectorToJson(table2.getVector());
%>

<script>

	$(document).ready(function() {
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 2,
		    colCnt: 5,
		    rowRatio: [24/47, 23/47],
		    colRatio: [176/489, 78/489, 78/489, 77/489, 78/489],
		};

		bodyObj.body1 = {
		    rowCnt: 18,
		    colCnt: 5,
		    rowRatio: [22/392, 21/392, 22/392, 22/392, 22/392, 22/392, 22/392, 22/392, 21/392, 22/392, 22/392, 22/392, 22/392, 21/392, 22/392, 22/392, 22/392, 21/392],
		    colRatio: [73/489, 103/489, 78/489, 117/489, 116/489],
		};

		bodyObj.body2 = {
		    rowCnt: 2,
		    colCnt: 2,
		    rowRatio: [90/184, 94/184],
		    colRatio: [73/489, 414/489],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([79/702, 47/702, 392/702, 184/702])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([26/79, 53/79])
		                .setHeadColRatio([283/489, 28/489, 59/489, 58/489, 59/489])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(41)
		                .setStartY(41)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// fill data
			var data = <%=data%>, data2 = <%=data2%>;
		
			//head
			cl.fillText(cl.head, "row1", "col2", data2[0][7], 'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", data2[0][8], 'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col4", data2[0][9], 'black', "13px arial", "center", "middle");
			
			//body0
			cl.fillText(cl.bodies.body0, "row0", "col2", data[0][6],'black', "11.5px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row0", "col4", data[0][5],'black', "12px arial", "center", "middle");
			
			cl.fillText(cl.bodies.body0, "row1", "col2", data[1][9] + " / " + data[1][10],'black', "13px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col4", data[1][16],'black', "12px arial", "center", "middle");
			
			//body1
			var plus = 0;
			for(let i = 0; i < data.length; i++){
				
				cl.fillText(cl.bodies.body1, "row"+(i+1), "col1", data[i][11],'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+1), "col2", (parseInt(data[i][14])+parseInt(data[i][15]==""?0:data[i][15])),'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+1), "col3", "원우푸드",'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+1), "col4", data[i][17],'black', "12px arial", "center", "middle");
			
				if(data[i][15] == "") {plus = plus - 1; continue; } // 반품하지 않은 목록 제외하고 1 row 올려주기
				
				cl.fillText(cl.bodies.body1, "row"+(i+10+plus), "col1", data[i][11],'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+10+plus), "col2", data[i][15],'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+10+plus), "col3", data[i][11],'black', "12px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+(i+10+plus), "col4", data[i][17],'black', "12px arial", "center", "middle");
			}
			
			//body2
			cl.wrapText_XY(cl, cl.bodies.body2, "row0", "col1", data2[0][5],'black', "12px arial", "left", "top", 34, 6, 5, 4);
			cl.wrapText_XY(cl, cl.bodies.body2, "row1", "col1", data2[0][6],'black', "12px arial", "left", "top", 34, 6, 5, 3);
		};
		
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="576" height="788">
	</canvas>    
</div>