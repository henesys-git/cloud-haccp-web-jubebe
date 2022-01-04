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
건강관리대장 canvas (S838S080400_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklistFormat = "";
	
	String checklist_id = "", checklist_rev_no = "", regist_seq_no = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");
	
	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S080400E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		let bodyObj = new Object();
		
		const cl = new CheckListWithImageBuilder()
			        .setDivId('myCanvas')
			        .setEntireRatio([644/644])
			        .setHeadRowCnt(19)
			        .setHeadColCnt(7)
			        .setHeadRowRatio([56/611, 34/611, 32/611, 33/611, 32/611,
			        	              33/611, 33/611, 33/611, 32/611, 32/611,
			        	              33/611, 32/611, 33/611, 33/611, 33/611,
			        	              32/611, 33/611, 32/611, 33/611])
			        .setHeadColRatio([36/476, 81/476, 93/476, 94/476, 56/476, 57/476, 57/476])
			        .howManyBodies(0)
			        .setStartX(55)
			        .setStartY(97)
			        .setTest(false)
			        .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		function loadImg(img, cb, data) {
			img.onload = function() {
				cb(data);
			}
		}
		
		var renderView = function(data) { 
			// === draw background ===
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// === fill data ===
			//head
			for(let i = 0; i < data.length; i++){
				
				for(let j = 0; j < cl.head.colCnt - 1; j++){
					cl.fillText(cl.head, "row"+(i+1), "col"+(j+1), data[i][(j+6)],
							'black', "12px arxal", "center", "middle");			
				}
			}
						
		}
		
		loadImg(bgImg, renderView, data);
	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="589" height="807">
	</canvas>    
</div>