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
폐기물 처리 기록부 (S838S020700)
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
	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S100100E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
				rowCnt: 1,
				colCnt: 1,
				rowRatio: [1/1],
				colRatio: [491/491]
		};
		
		bodyObj.body1 = {
				rowCnt: 10,
				colCnt: 6,
				rowRatio: [41/517, 53/517, 53/517, 53/517,
						   53/517, 53/517, 53/517, 53/517, 53/517,
						   53/517],
				colRatio: [69/491, 73/491, 73/491, 137/491, 72/491, 68/491]
		};
		
	
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([74/632, 1/632, 570/632])		
						.setHeadRowCnt(2)							
						.setHeadColCnt(5)
						.setHeadRowRatio([24/75, 50/75])
						.setHeadColRatio([296/491, 30/491, 55/491, 55/491, 56/491])
						.howManyBodies(2)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(42)
						.setStartY(55)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
		
			
			// fill data
			
			//head				
			cl.fillText(cl.head, "row1", "col2", data[0][8],
					'balck', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", data[0][9],
				'balck', "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col4", data[0][10],
				'balck', "13px arial", "center", "middle");
			
			
			//body1
			for(var i=1; i<data.length+9; i++){
				
				cl.fillText(cl.bodies.body1, "row"+[i], "col0", data[i-1][2],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+[i], "col1", data[i-1][3],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+[i], "col2", data[i-1][4],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+[i], "col3", data[i-1][5],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+[i], "col4", data[i-1][6],
						'black', "11px arial", "center", "middle");
				cl.fillText(cl.bodies.body1, "row"+[i], "col5", data[i-1][7],
						'black', "11px arial", "center", "middle");
				
			}
			
			 
		};
 	});
	
	
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="572" height="755">
	</canvas>    
</div>