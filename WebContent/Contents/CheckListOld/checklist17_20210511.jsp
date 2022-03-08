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
개선조치기록부 캔버스 (S838S070600)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklist_id = "", checklist_rev_no = "", unsuit_date = "",
			seq_no ="";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("unsuit_date") != null)
		unsuit_date = request.getParameter("unsuit_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	jArray.put("unsuit_date", unsuit_date);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S070600E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
	
	String file_path = (String)table.getValueAt(0, 16);
%>
<style>
#showImg {
	width: 87.85px;
    height: 38.8px;
    position: relative;
    bottom: 119px;
    left: 119px;
}
.modal-body{
    padding-bottom: 0;
}
</style>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0];
		
		if('<%= file_path %>' == ""){
			$("#showImg").attr("disabled", true);
		}
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 9,
		    colCnt: 3,
		    rowRatio: [35/510, 46/510, 35/510, 34/510, 72/510, 162/510, 44/510, 51/510, 31/510],
		    colRatio: [45/496, 190/496, 258/496],
		};

		bodyObj.body1 = {
		    rowCnt: 1,
		    colCnt: 3,
		    rowRatio: [92/92],
		    colRatio: [211/496, 24/496, 258/496],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([85/687, 510/687, 92/687])
		                .setHeadRowCnt(3)
		                .setHeadColCnt(6)
		                .setHeadRowRatio([26/85, 33/85, 26/85])
		                .setHeadColRatio([158/496, 168/496, 27/496, 47/496, 47/496, 46/496])
		                .howManyBodies(2)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(42)
		                .setStartY(44)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col3");
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col4");
			cl.mergeCellsVertical(cl.head, "row1", "row2", "col5");
			
			// fill data
			//head
			cl.fillText(cl.head, "row2", "col0", data[2].substr(0,4) + " 년 " + data[2].substr(5,2) + " 월 " + data[2].substr(8) + " 일 ",
					'black', "12px arial", "center", "middle");
			cl.fillText(cl.head, "row2", "col1", '<%=table.getValueAt(0,12)%>',
					'black', "12px arial", "center", "middle");
			
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,12)%>',
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col4", '<%=table.getValueAt(0,13)%>',
					'black', "11px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col5", '<%=table.getValueAt(0,14)%>',
					'black', "11px arial", "center", "middle");
			
			//body0
			for(let i = 0; i < bodyObj.body0.rowCnt - 1; i++){
				
				if(i == 4){
					
					data[8] = data[8].replace(/\//gi, "\n");
					cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i + 1), "col2", data[(i + 4)],
							'black', "13px arial", "left", "top",30,10,10,10);
				} else if(i == 0 || i == 2 || i == 3){
					
					cl.fillText_left(cl.bodies.body0, "row"+(i + 1), "col2", data[(i + 4)],
							'black', "13px arial", i==2?100:10,i==2?3:10);
				}
				else {
					
					cl.fillText(cl.bodies.body0, "row"+(i + 1), "col2", data[(i + 4)],
							'black', "13px arial", (i==1 || i == 5)?"center":"right", (i==2 || i==7 || i == 6)?"bottom":(i==5)?"middle":"top");	
				}
				
			}
		
			//body1
			//button
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="585" height="778">
	</canvas>    
</div>
<button type="button" id = "showImg" onclick = "window.open('<%= request.getContextPath() %><%= table.getValueAt(0, 16) %>')" >첨부자료</button>