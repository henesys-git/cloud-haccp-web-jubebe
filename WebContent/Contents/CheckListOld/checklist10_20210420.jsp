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
외부인출입관리대장 (S838S020500)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", 
		   regist_seq_no = "";
	
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

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020500E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 21,
		    colCnt: 7,
		    rowRatio: [35/604, 28/604, 26/604, 28/604, 26/604, 29/604, 29/604, 29/604, 29/604, 29/604, 29/604, 29/604, 28/604, 29/604, 29/604, 28/604, 29/604, 29/604, 29/604, 29/604, 28/604],
		    colRatio: [64/484, 79/484, 55/484, 120/484, 58/484, 62/484, 43/484],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([61/665, 604/665])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([24/61, 34/61, 3/61])
		                .setHeadColRatio([294/484, 26/484, 53/484, 54/484, 53/484])
		                .howManyBodies(1)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(50)
		                .setStartY(88)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// fill data
			//head
			for(let i=0; i<3; i++){
				cl.fillText(cl.head, "row1", "col"+(2+i), data[0][(3+i)],
						'balck', "14px arial", "center", "middle");
			}
			
			//body0
			for(let j=0; j<data.length; j++){
				
				var row = "row" + (j+1);
				
				for(let k=0; k<bodyObj.body0.colCnt; k++){
					var col = "col" + k;
					
					cl.fillText(cl.bodies.body0, row, col, data[j][(7+k)],
							'balck', "11.5px arial", "center", "middle");					
				}
				
			}

		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="587" height="842">
	</canvas>    
</div>