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
자동 기록관리 시스템 수정 일지 (S838S020300)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", unsuit_date = "",
			record_seq_no =""; 
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("unsuit_date") != null)
		unsuit_date = request.getParameter("unsuit_date");
	
	if(request.getParameter("record_seq_no") != null)
		record_seq_no = request.getParameter("record_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	jArray.put("checklist_Date", unsuit_date);
	jArray.put("record_seq_no", record_seq_no);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020300E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		console.log(data);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 5,
			colCnt: 2,
			rowRatio: [30/561, 120/561, 113/561, 210/561, 88/561],
			colRatio: [83/475, 393/475]
		};
		
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([88/649, 561/649])
						.setHeadRowCnt(2)
						.setHeadColCnt(5)
						.setHeadRowRatio([21/88, 64/88])
						.setHeadColRatio([272/475, 30/475, 57/475, 57/475, 59/475])
						.howManyBodies(1)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(55)
						.setStartY(82)
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
			
			
			// fill data
			
			//head
			cl.fillText(cl.head, "row1", "col2", '<%=table.getValueAt(0,7)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,8)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col4", '<%=table.getValueAt(0,9)%>',
					'balck', "15px arial", "center", "middle");
			
			
			//body0
			cl.fillText(cl.bodies.body0, "row1", "col1", '<%=table.getValueAt(0,2)%>',
						'balck', "15px arial", "center", "bottom");
			cl.fillText(cl.bodies.body0, "row1", "col1", '<%=table.getValueAt(0,3)%>',
					'balck', "15px arial", "center", "top");
			cl.fillText(cl.bodies.body0, "row2", "col1", '<%=table.getValueAt(0,4)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row3", "col1", '<%=table.getValueAt(0,5)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row4", "col1", '<%=table.getValueAt(0,6)%>',
					'balck', "15px arial", "center", "middle");
			
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="814">
	</canvas>    
</div>