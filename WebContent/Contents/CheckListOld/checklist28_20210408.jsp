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
소독약품 관리대장 (S838S020800)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", 
		   checklist_rev_no = "", regist_seq_no = "";
	
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

	DoyosaeTableModel table = new DoyosaeTableModel("M838S020800E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
			
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			    rowCnt: 41,
			    colCnt: 8,
			    rowRatio: [20/642, 19/642, 16/642, 16/642, 16/642, 16/642, 16/642, 16/642, 16/642, 16/642, 16/642, 16/642, 13/642, 16/642, 17/642, 16/642, 13/642, 16/642, 16/642, 16/642, 13/642, 16/642, 16/642, 16/642, 13/642, 16/642, 17/642, 15/642, 14/642, 16/642, 16/642, 16/642, 13/642, 16/642, 16/642, 16/642, 14/642, 16/642, 16/642, 15/642, 14/642],
			    colRatio: [24/486, 56/486, 69/486, 53/486, 52/486, 53/486, 126/486, 51/486],
			};


		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([81/723, 642/723])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(4)
		                .setHeadRowRatio([19/81, 32/81, 30/81])
		                .setHeadColRatio([307/486, 52/486, 53/486, 72/486])
		                .howManyBodies(1)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(43)
		                .setStartY(42)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			//mergeCell
			// body0
			for(var r=1; r<=10;r++){		
				cl.mergeCellsVertical(cl.bodies.body0, "row"+(4*r-3), "row"+(r*4), "col1");	
			} 

			// fillText
			//head
			cl.fillText(cl.head, "row1", "col1", data[0][2], "black", "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col2", data[0][3], "black", "13px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", data[0][4], "black", "13px arial", "center", "middle");
			
			//body0
			for(let i = 0; i < data.length; i++) {
				var date = data[i][0];
				
				var result = new Array();
				result = data[i][1].slice(1,-1).split(",");
				var dataArr = result;
				
				// 날짜
				cl.fillText(cl.bodies.body0, "row"+(4*i+1), "col1", date, "black", "10.5px arial", "center", "middle");
				
				var cnt = 0;				
				for(var j=1+4*i; j<=4+4*i; j++){
					
					var row = "row"+j
					
					for(var k=0; k<5; k++){
						var col = "col" + (3+k)
						cl.fillText(cl.bodies.body0, row, col, dataArr[k+cnt], "black", "12px arial", "center", "middle");
					}
					cnt = cnt+5;
				}	
				
			}
			
		}; // end of onload
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="574" height="809">
	</canvas>    
</div>