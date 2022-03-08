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
CCP 3B 모니터링일지 캔버스 (S838S015200)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", 
		   ccp_date = "", seq_no =""; 
		
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklistId", checklistId);
	jArray.put("checklistRevNo", checklistRevNo);
	jArray.put("ccp_date", ccp_date);

	VectorToJson vtj = new VectorToJson();
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S015200E144", jArray);
	String data = vtj.vectorToJson(table.getVector());
	
	DoyosaeTableModel table2 = new DoyosaeTableModel("M838S015200E145", jArray);
	String data2 = vtj.vectorToJson(table2.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		var data2 = <%=data2%>;
		
		data = data[0];
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 6,
		    colCnt: 2,
		    rowRatio: [22/235, 22/235, 19/235, 27/235, 25/235, 120/235],
		    colRatio: [58/486, 425/486],
		};

		bodyObj.body1 = {
		    rowCnt: 10,
		    colCnt: 6,
		    rowRatio: [39/359, 36/359, 36/359, 36/359, 36/359, 35/359, 36/359, 36/359, 35/359, 34/359],
		    colRatio: [57/486, 90/486, 43/486, 53/486, 90/486, 150/486],
		};

		bodyObj.body2 = {
		    rowCnt: 1,
		    colCnt: 5,
		    rowRatio: [32/32],
		    colRatio: [147/486, 74/486, 46/486, 48/486, 168/486],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([76/702, 235/702, 359/702, 32/702])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(9)
		                .setHeadRowRatio([22/76, 54/76])
		                .setHeadColRatio([28/486, 36/486, 44/486, 124/486, 90/486, 17/486, 49/486, 48/486, 47/486])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(44)
		                .setStartY(44)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// merge cells
			//body1
			for(let i=0; i<bodyObj.body1.rowCnt-2; i++){
				cl.mergeCellsHorizon(cl.bodies.body1, "row"+(2+i), "col2", "col3");	
			}
			
			// fill data
			//head
			// row 1 : col 1 > YY / col2 > MM / col3 > DD / col4 > 담당자 / col6 > 작성자 / col 7 > 검토자 / col 8 > 승인자
			for(let j = 1; j < 8; j++){
				
				if(j < 5){
					cl.fillText_left(cl.head, "row1", "col"+j, data[2 + j],	'black', "12px arial", 4, 36);	
				} else {
					cl.fillText(cl.head, "row1", "col"+(1+j), data[2+j], 'black', "12px arxal", "center", "middle");
				}
				
			}
			
			//body1
			for(let t = 0; t < data2.length; t++){
				var row = "row"+(t + 1);
				if(t == 6){ row = "row9"; }
				for(let p = 0; p < bodyObj.body1.colCnt-2; p++){
					var col = "col" + (1 + p);	
					
					if(t==0){ 
						
						if(p==0){ continue; }
						
						switch (data2[0][(1+p)]) {
						case "200.0":
							col = "col2";	// 부적합이여도 적합으로 보여주기 >> col = "col3";
							break;
						case "100.0":
							col = "col2";
							break;
			 			default : 
							col = "col" + (2 + p);
							break;
						}
												
						cl.fillText(cl.bodies.body1, "row1",col, p==1?"O":data2[t][(p + 1)], 'black', p==1?"27px arxal":"12px arxal", "center", "middle");
						 
					}
					else {
						
						if(p>1){  col = "col" + (2 + p); }
						cl.fillText(cl.bodies.body1, row, col, data2[t][(p + 1)], 'black', "12px arxal", "center", (p==0 && (t==1 || t==6))?"top":"middle");
					}
	
				}
				
			}
			
			//body2
			// row 0 : col 2 > 시 / col3 > 분 / col4 > 품질관리팀장 서명 
			for(let f = 0; f < bodyObj.body2.colCnt-2; f++){
				
				cl.fillText(cl.bodies.body2, "row0", "col"+(2+f), data[11+f], 'black', "12px arxal", "center", "middle");
			}
			
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="577" height="792">
	</canvas>    
</div>