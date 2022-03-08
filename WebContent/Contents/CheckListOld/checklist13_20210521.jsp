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
	검·교정 기록부
	checklist13_20210521.jpg 
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", check_date = "";
		
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");
		   
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");

	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070300E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>; 
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 16,
		    colCnt: 9,
		    rowRatio: [51/649, 30/649, 29/649, 29/649, 30/649, 29/649, 29/649, 30/649, 29/649, 29/649, 30/649, 29/649, 29/649, 30/649, 29/649, 187/649],
		    colRatio: [24/500, 59/500, 59/500, 59/500, 59/500, 59/500, 58/500, 59/500, 61/500],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([98/747, 649/747])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(11)
		                .setHeadRowRatio([18/98, 45/98, 35/98])
		                .setHeadColRatio([52/500, 21/500, 18/500, 21/500, 20/500, 21/500, 171/500, 26/500, 49/500, 49/500, 48/500])//324/500, 26/500, 49/500, 49/500, 48/500])
		                .howManyBodies(1)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(36)
		                .setStartY(28)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// fill data
			//head
			var check_date = '<%=table.getValueAt(0,2)%>';
			var dateArr = check_date.split("-");
			dateArr[0] = dateArr[0].slice(-2);
			for(let d = 0; d < dateArr.length; d++){
				
				cl.fillText(cl.head, "row1", "col"+(2*d+1), dateArr[d],
						'black', "14px arial", "center", "top");
						
				cl.fillText(cl.head, "row1", "col"+(d+8), data[0][(12+d)],
						'black', "13px arial", "center", "middle");
			}
			
			//body0
			for(let i = 0; i < bodyObj.body0.rowCnt - 3; i++){
				
				for(let j = 0; j < bodyObj.body0.colCnt - 4; j++){
					
					if(j==3){
						
						cl.fillText_left(cl.bodies.body0, "row"+(i+1), "col6", "O",
								'black', "21px arial", data[i][10] == "Y"?8:33, 7);
						continue;
						
					} else if(j==4){
						
						cl.wrapText_XY(cl, cl.bodies.body0, "row"+(1+i), "col8", data[i][11],
								'black', "11px arial", "left", "top", 5, 2, 4, 4);
						continue;
					}
					
					cl.fillText(cl.bodies.body0, "row"+(1 + i), "col"+(j + 3), data[i][(7+j)],
							'black', "12px arial", "center", "middle");
				}
				
			} // end body0

		};
 	});
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="574" height="803">
	</canvas>    
</div>