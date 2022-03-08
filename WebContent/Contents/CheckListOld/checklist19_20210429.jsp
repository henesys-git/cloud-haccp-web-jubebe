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
HACCP 팀 회의록 캔버스 (S838S080200)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", seq_no = "", meeting_date = "";
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("meeting_date") != null)
		meeting_date = request.getParameter("meeting_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("meeting_date", meeting_date);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S080200E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>
<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0]; 
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
		    rowCnt: 4,
		    colCnt: 6,
		    rowRatio: [28/110, 27/110, 28/110, 27/110],
		    colRatio: [69/482, 31/482, 37/482, 37/482, 47/482, 258/482],
		};

		bodyObj.body1 = {
		    rowCnt: 3,
		    colCnt: 2,
		    rowRatio: [190/410, 190/410, 30/410],
		    colRatio: [69/482, 410/482],
		};

		bodyObj.body2 = {
		    rowCnt: 2,
		    colCnt: 5,
		    rowRatio: [102/102, 0/102],
		    colRatio: [69/482, 168/482, 42/482, 27/482, 173/482],
		};

		const cl = new CheckListWithImageBuilder()
		                .setDivId('myCanvas')
		                .setEntireRatio([81/703, 110/703, 410/703, 102/703])
		                .setHeadRowCnt(2)
		                .setHeadColCnt(5)
		                .setHeadRowRatio([32/81, 49/81])
		                .setHeadColRatio([257/482, 30/482, 67/482, 61/482, 64/482])
		                .howManyBodies(3)
		                .setChildBodiesRowCol(bodyObj)
		                .setStartX(44)
		                .setStartY(53)
		                .setTest(false)
		                .build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);
			
			// merge cells
			cl.mergeCellsHorizon(cl.bodies.body0, "row3", "col1", "col5");
			
			// fill data	
			//head
			for(var h = 0; h < 3; h++){
				cl.fillText(cl.head, "row1", "col"+(2+h), data[(15+h)],
						'black', "15px arial", "center", "middle");
			}
			
			var day = getDateDay(data[2]);
			
			//body0
			for(var d = 0; d < 4; d++){
				
				cl.fillText_left(cl.bodies.body0, "row0", "col"+(2+d), d==3?day:data[(3+d)],
						'black', "14px arial", 3, 8);
			}
			
			cl.fillText_left(cl.bodies.body0, "row3", "col1", data[7],
					'black', "14px arial", 10, 8);
			
			//body1
			cl.wrapText_XY(cl, cl.bodies.body1, "row0", "col1", data[8],
					'black', "14px arial", "left", "top", 28, 10, 10, 35);
			cl.wrapText_XY(cl, cl.bodies.body1, "row1", "col1", data[9],
					'black', "14px arial", "left", "top", 28, 10, 10, 35);
			cl.fillText_left(cl.bodies.body1, "row2", "col1", data[10],
					'black', "14px arial", 80, 9);
			
			//body2
			for(var b = 0; b < 3; b++){
				
				cl.fillText_left(cl.bodies.body2, "row0", "col"+(2+b), data[(12+b)],
						'black', "13px arial", 2, 45);
			}
			
		};
 	});
	
	function getDateDay(date) {
		 
	    var day = "" ;
	     
	    var dayNum =  new Date(date).getDay();

	    switch(dayNum){
	        case 0:
	            day = "일";
	            break ;
	        case 1:
	            day = "월";
	            break ;
	        case 2:
	            day = "화";
	            break ;
	        case 3:
	            day = "수";
	            break ;
	        case 4:
	            day = "목";
	            break ;
	        case 5:
	            day = "금";
	            break ;
	        case 6:
	            day = "토";
	            break ;
	             
	    }
	     
	    return day ;
	}

</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="572" height="810">
	</canvas>    
</div>