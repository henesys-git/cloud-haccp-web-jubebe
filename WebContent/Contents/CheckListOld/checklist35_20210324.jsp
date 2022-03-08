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
		   seq_no = "", regist_seq_no = "";
	String 	regist_date = "";
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("regist_seq_no", regist_seq_no);
	

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020700E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		
		bodyObj.body0 = {
			rowCnt: 15,
			colCnt: 8,
			rowRatio: [42/529, 42/529, 42/529, 42/529, 42/529, 
					   42/529, 42/529, 42/529, 42/529, 42/529, 
					   42/529, 42/529, 42/529, 42/529, 42/529],
			colRatio: [64/488, 57/488, 37/488, 133/488, 53/488, 48/488, 48/488, 48/488]
		};
		
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([59/529, 475/529])			
						.setHeadRowCnt(1)							
						.setHeadColCnt(1)
						.setHeadRowRatio([59/59])
						.setHeadColRatio([488/488])
						.howManyBodies(1)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(49)
						.setStartY(115)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			for(var i=0; i<data.length+10; i++){
				
			cl.fillText(cl.bodies.body0, "row"+[i], "col0", data[i][3],
					'black', "10.5px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col1", data[i][4],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col2", data[i][5],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col3", data[i][6],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col4", data[i][7],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col5", data[i][8],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col6", data[i][9],
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row"+[i], "col7", data[i][10],
					'black', "11px arial", "center", "middle");
			
			} 
			 
		};
 	});
	
	
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="750">
	</canvas>    
</div>