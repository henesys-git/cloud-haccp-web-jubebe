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
부적합품 기록부 (S838S070650)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "";
	String regist_seq_no = "";
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070650E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
				rowCnt: 6,
				colCnt: 7,
				rowRatio: [18/197, 17/197, 24/197, 25/197, 29/197, 84/197],
				colRatio: [48/480, 64/480, 145/480, 65/480, 21/480, 69/480, 65/480]
		};
		
		bodyObj.body1 = {
				rowCnt: 3,
				colCnt: 3,
				rowRatio: [30/195, 81/195, 84/195],
				colRatio: [48/480, 64/480, 365/480]
		};
		
		bodyObj.body2 = {	// 조치내역
				rowCnt: 1,
				colCnt: 7,
				rowRatio: [33/33],
				colRatio: [48/480, 64/480, 59/480, 73/480, 70/480, 69/480, 94/480]
		};
		
		bodyObj.body3 = {
				rowCnt: 2,
				colCnt: 5,
				rowRatio: [35/119, 84/119],
				colRatio: [48/480, 64/480, 145/480, 65/480, 155/480]
		};
		
		bodyObj.body4 = {	// 처리내용
				rowCnt: 1,
				colCnt: 5,
				rowRatio: [29/29],
				colRatio: [48/480, 64/480, 75/480, 162/480, 128/480]
		};
		
		bodyObj.body5 = {	// 확인자
				rowCnt: 1,
				colCnt: 5,
				rowRatio: [29/29],
				colRatio: [48/480, 64/480, 145/480, 65/480, 155/480]
		};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([75/685, 197/685, 195/685, 33/685, 119/685, 29/685, 29/685])		//218/685
						.setHeadRowCnt(2)							
						.setHeadColCnt(5)
						.setHeadRowRatio([23/75, 52/75])
						.setHeadColRatio([293/480, 29/480, 52/480, 52/480, 51/480])
						.howManyBodies(6)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(53)
						.setStartY(42)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			
			//draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
	 
			//mergeCell
			// body0
			cl.mergeCellsVertical(cl.bodies.body0, "row0", "row1", "col2");
			cl.mergeCellsHorizon(cl.bodies.body0, "row2", "col4", "col6");
			cl.mergeCellsHorizon(cl.bodies.body0, "row3", "col4", "col6");
			cl.mergeCellsHorizon(cl.bodies.body0, "row4", "col2", "col6");
			cl.mergeCellsHorizon(cl.bodies.body0, "row5", "col1", "col6");
			
			// body1
			cl.mergeCellsHorizon(cl.bodies.body1, "row1", "col1", "col2");
			cl.mergeCellsHorizon(cl.bodies.body1, "row2", "col1", "col2");
			
			// body3
			cl.mergeCellsHorizon(cl.bodies.body3, "row1", "col1", "col4");
	
			
			//fillText
			// head
 			cl.fillText(cl.head, "row1", "col2", data[0][17],
				'black', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", data[0][18],
				'black', "13px arial", "center", "middle");
 		 	cl.fillText(cl.head, "row1", "col4", data[0][19],
				'black', "13px arial", "center", "middle");   
			
			// body0
			cl.fillText_left(cl.bodies.body0, "row0", "col2", data[0][4],
				'black', "13px arial", 12.5, 12.5);
			cl.fillText_left(cl.bodies.body0, "row2", "col2", data[0][6],
				'black', "13px arial", 10, 6.5);
			cl.fillText_left(cl.bodies.body0, "row2", "col4", data[0][3],
				'black', "13px arial", 10, 6.5);
			cl.fillText_left(cl.bodies.body0, "row3", "col2", data[0][7],
				'black', "13px arial", 10, 6.5);
			cl.fillText_left(cl.bodies.body0, "row3", "col4", data[0][8],
				'black', "13px arial", 10, 6.5);
			cl.wrapText_XY(cl, cl.bodies.body0, "row5", "col1", data[0][9],	
					'black', "13px arial", "left", "top", 32, 4, 11.5, 13);	
			
			// body1
			cl.wrapText_XY(cl, cl.bodies.body1, "row1", "col1", data[0][10],	
				'black', "13px arial", "left", "top", 32, 4, 11.5, 18);	
			cl.wrapText_XY(cl, cl.bodies.body1, "row2", "col1", data[0][11],	
				'black', "13px arial", "left", "top", 32, 4, 11.5, 18);	
			
			// body3
			cl.fillText_left(cl.bodies.body3, "row0", "col2", data[0][13],	
				'black', "13px arial", 13, 9.5);
			cl.fillText_left(cl.bodies.body3, "row0", "col4", data[0][14],	
				'black', "13px arial", 13, 9.5);
			cl.wrapText_XY(cl, cl.bodies.body3, "row1", "col1", data[0][15],	
				'black', "13px arial", "left", "top", 32, 3, 11.5, 24.5);	
			cl.fillText(cl.bodies.body5, "row0", "col2", data[0][18],	
				'black', "13px arial", "center", "middle");
			cl.fillText(cl.bodies.body5, "row0", "col4", data[0][19],	
				'black', "13px arial", "center", "middle");
			
			// gubun
			var row = "", col = "";
			
			// 제품유형
			switch (data[0][5]) {	
			case "원재료":
				row = "row0"; col = "col5";
				break;
			case "포장재":
				row = "row0"; col = "col6";
				break;
			case "공정품":
				row = "row1"; col = "col5";
				break;
			case "완제품":
				row = "row1"; col = "col6";
				break;
			}
			
			cl.fillText_left(cl.bodies.body0, row, col, "V",		
					'black', "bold 13px arial", 4.5, 2);
			
			// 조치내역
			switch (data[0][12]) {
			case "재작업":
				row = "row0"; col = "col3";
				break;
			case "특채":
				row = "row0"; col = "col4";
				break;
			case "반품":
				row = "row0"; col = "col5";
				break;
			case "폐기":
				row = "row0"; col = "col6";
				break;
			} 
			
			cl.fillText_left(cl.bodies.body2, row, col, "V",		
					'black', "bold 13px arial", 4, 6.5);
			
			// 결과확인
			if(data[0][16] = "Y") { row = "row0"; col = "col3"; }
			else { row = "row0"; col = "col4"; }
			
			cl.fillText_left(cl.bodies.body4, row, col, "V",		
					'black', "bold 13px arial", 4.5, 4);	
				
		};
		
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="587" height="774">
	</canvas>    
</div>