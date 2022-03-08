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
부자재·부재료 입고검사기록 조회 (S838S070100)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", checklistDate = "";
	
	String regist_seq_no = "", seq_no = "", ipgo_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
		
	if(request.getParameter("checklistDate") != null)
		checklistDate = request.getParameter("checklistDate");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S070100E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());

%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;	 
		
		let bodyObj = new Object();
		
		const cl = new CheckListWithImageBuilder()
				        .setDivId('myCanvas')
				        .setEntireRatio([642/642])
				        .setHeadRowCnt(13)
				        .setHeadColCnt(6)
				        .setHeadRowRatio([42/642, 44/642, 49/642, 55/642, 46/642, 35/642, 36/642, 41/642, 44/642, 172/642, 26/642, 26/642, 26/642])
				        .setHeadColRatio([95/469, 75/469, 74/469, 74/469, 74/469, 74/469])
				        .howManyBodies(0)
				        .setChildBodiesRowCol(bodyObj)
				        .setStartX(53)
				        .setStartY(107)
				        .setTest(false)
				        .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// fill data	
			for(let i = 0; i < data.length; i++){
				
				for(let j = 0; j < cl.head.rowCnt; j++){
					
					if(j > 3 && j < 8){	
						cl.fillText_left(cl.head, "row"+j, "col"+(1 + i), "O",
								'black', "24px arial", 30, data[i][(4+j)]=="X"?(j==4?24:19):3);
						continue;
					} else if(j == 8){
						cl.fillText(cl.head, "row"+j, "col"+(1 + i), data[i][(4+j)]=="O"?"확인":"미확인",
								'black', "13px arial", "center", "middle");
						continue;
					} else if(j == 9){
						cl.wrapText_XY(cl, cl.head, "row"+j, "col"+(1 + i), data[i][(4+j)],
								'black', "13px arial", "left", "top", 5, 10, 8, 10);
						continue;
					} else if(j == 3){
						data[i][7] = parseInt(data[i][7]);
					}

					cl.fillText(cl.head, "row"+j, "col"+(1 + i), data[i][(4+j)],
							'black', "13px arial", "center", "middle");
					
				}
				
			}
					
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="579" height="855"></canvas>    
</div>