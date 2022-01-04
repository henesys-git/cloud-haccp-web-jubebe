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
원료육 검사기록 조회
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
	
	DoyosaeTableModel table = new DoyosaeTableModel("M838S070700E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 1,
		    colCnt: 2,
		    rowRatio: [59/59],
		    colRatio: [809/817, 6/817],
		};

		bodyObj.body1 = {
		    rowCnt: 2,
		    colCnt: 4,
		    rowRatio: [36/72, 36/72],
		    colRatio: [250/817, 188/817, 187/817, 189/817],
		};

		bodyObj.body2 = {
		    rowCnt: 1,
		    colCnt: 13,
		    rowRatio: [36/36],
		    colRatio: [250/817, 22/817, 72/817, 21/817, 73/817, 21/817, 73/817, 21/817, 72/817, 22/817, 72/817, 21/817, 74/817],
		};

		bodyObj.body3 = {
		    rowCnt: 4,
		    colCnt: 4,
		    rowRatio: [35/117, 36/117, 34/117, 12/117],
		    colRatio: [250/817, 188/817, 187/817, 189/817],
		};

		bodyObj.body4 = {
		    rowCnt: 12,
		    colCnt: 5,
		    rowRatio: [43/547, 41/547, 41/547, 42/547, 41/547,
		    	       41/547, 41/547, 42/547, 42/547, 44/547,
		    	       49/547, 83/547],
		    colRatio: [114/817, 138/817, 188/817, 187/817, 187/817],
		};

		bodyObj.body5 = {
		    rowCnt: 4,
		    colCnt: 3,
		    rowRatio: [40/166, 42/166, 42/166, 42/166],
		    colRatio: [227/817, 227/817, 365/817],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([153/1147, 59/1147, 72/1147, 36/1147, 117/1147, 547/1147, 166/1147])
		                .setHeadRowCnt(4)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([38/153, 39/153, 39/153, 37/153])
		                .setHeadColRatio([249/817, 188/817, 189/817, 182/817, 7/817])
		                .howManyBodies(6)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(53)
		                .setStartY(95)
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
			for(let i = 0; i < data.length; i++){
				
				//head
				for(let j = cl.head.rowCnt-1; j >= 0; j--){
					cl.fillText(cl.head, "row"+j, "col"+(i+1), j==0?data[i][4]:data[i][(j+24)],
							'black', "12px arxal", "center", "middle");			
				}
				
				//body1
				for(let j1 = 0; j1 < bodyObj.body1.rowCnt; j1++){
					cl.fillText(cl.bodies.body1, "row"+j1, "col"+(i+1), data[i][(j1+5)],
							'black', "12px arxal", "center", "middle");			
				}
				
				//body2
				cl.fillText_left(cl.bodies.body2, "row0", data[i][8]==1?"col"+((2*i)*2+2):"col"+((4*i)+4), "V",
						'black', "bold 13px arxal",0, 5);	
				
				//body3
				for(let j3 = 0; j3 < bodyObj.body3.rowCnt-1; j3++){
					cl.fillText(cl.bodies.body3, "row"+j3, "col"+(i+1), j3==2?data[i][(j3+9)] + " / " + data[i][(j3+10)]:data[i][(j3+9)],
							'black', "12px arxal", "center", "middle");			
				}
				
				//body4
				for(let j4 = 0; j4 < bodyObj.body4.rowCnt-3; j4++){
					cl.fillText(cl.bodies.body4, "row"+(j4+1), "col"+(i+2), data[i][(j4+13)],
							'black', "12px arxal", "center", "middle");			
				}
				
				//body4 - 적합/부적합
				cl.fillText_left(cl.bodies.body4, "row10", "col"+(i+2), "O",
						'black', "25px arxal", data[i][22]=="O"?21:63, 6);
				
				//body5
				for(let f = 0; f < bodyObj.body5.rowCnt-2; f++){
					
					cl.wrapText_XY(cl, cl.bodies.body5, "row"+(i+1), "col"+f, data[i][23+f],
							'black', "9px arxal", "left", "top", 12, 10, 18, 9);			
					
				}
				
			}
			
						
		}
		
		loadImg(bgImg, renderView, data);
	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="574" height="847">
	</canvas>    
</div>