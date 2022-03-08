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
교육훈련 기록부 canvas (S838S080300_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "";
	String seq_no = "", edu_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("edu_date") != null)
		edu_date = request.getParameter("edu_date");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("edu_date", edu_date);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S080300E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0];

		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 3,
		    colCnt: 6,
		    rowRatio: [21/64, 22/64, 21/64],
		    colRatio: [85/477, 130/477, 30/477, 66/477, 34/477, 130/477],
		};
	
		bodyObj.body1 = {
		    rowCnt: 1,
		    colCnt: 11,
		    rowRatio: [21/21],
		    colRatio: [85/477, 8/477, 70/477, 4/477, 74/477, 12/477, 66/477, 5/477, 73/477, 22/477, 56/477],
		};
	
		bodyObj.body2 = {
		    rowCnt: 2,
		    colCnt: 2,
		    rowRatio: [21/264, 243/264],
		    colRatio: [85/477, 390/477],
		};
	
		bodyObj.body3 = {
		    rowCnt: 10,
		    colCnt: 7,
		    rowRatio: [28/278, 27/278, 27/278, 27/278, 27/278, 27/278, 27/278, 27/278, 26/278, 35/278],
		    colRatio: [85/477, 65/477, 65/477, 65/477, 65/477, 65/477, 65/477],
		};
	
		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([81/708, 64/708, 21/708, 264/708, 278/708])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([26/81, 55/81])
		                .setHeadColRatio([285/477, 26/477, 54/477, 55/477, 54/477])
		                .howManyBodies(4)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(48)
		                .setStartY(48)
		                .setTest(false)
		                .build();
		
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		/* bgImg.src = heneServerPath + '/images/checklist/checklist14_20210113.jpg'; */
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
			//body0
			cl.mergeCellsHorizon(cl.bodies.body0, "row0", "col1", "col2");
			cl.mergeCellsHorizon(cl.bodies.body0, "row0", "col4", "col5");
	 		cl.mergeCellsHorizon(cl.bodies.body0, "row1", "col1", "col2");
	 		cl.mergeCellsHorizon(cl.bodies.body0, "row1", "col4", "col5");
	 		cl.mergeCellsHorizon(cl.bodies.body0, "row2", "col2", "col4");
		
	 		//body2
			cl.mergeCellsHorizon(cl.bodies.body3, "row9", "col1", "col6");
	 		
	 		
			// fill data
			//head
			for(let h = 0; h < 3; h++){
				
				cl.fillText(cl.head, "row1", "col"+(2 + h), data[(18 + h)], 'black', "14px arial", "center", "middle");
				
			}

			//body0
			for(let i = 0; i < 3; i++){	
				
				if(i<2){
					
					for(let j = 0; j < 2; j++){
						
						cl.fillText(cl.bodies.body0, "row"+i, j==1?"col4":"col1", data[((4*(i+1)) + j)],
								'black', "13px arial", "center", "middle");
					}
					
				} else {
					
					for(let j = 0; j < 3; j++){
					 
						cl.fillText(cl.bodies.body0, "row"+i, j<2?(j==1?"col2":"col1"):"col5", data[(10 + j)],
								'black', "13px arial", "left", "middle");
					}
				}
			}
			
			//body1
			var type = data[13].trim();
			var col = "";
			switch (type) {
			case "1":
				col = "col2";
				break;
			case "2":
				col = "col4";			
				break;
			case "3":
				col = "col6";
				break;
			case "4":
				col = "col8";
				break;
			case "5":
				col = "col10";
				break;
			};
			
			cl.fillText_left(cl.bodies.body1, "row0", col, "V", 'balck', "bold 15px arial", 0, 5);
			
			//body2
			cl.fillText_left(cl.bodies.body2, "row0", "col1", data[15],	'balck', "13px arial", 10, 5);
			cl.wrapText_XY(cl, cl.bodies.body2, "row1", "col1", data[16],	
					'balck', "13px arial", "left", "top", 29, 15, 9, 10);
			
			//body3
			cl.fillText_left(cl.bodies.body3, "row9", "col1", data[17], 'black', "13px arial", 10, 12);
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="575" height="806">
	</canvas>    
</div>