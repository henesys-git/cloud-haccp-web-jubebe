<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
출하집계표(S858S010402.jsp)
*/	
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();

String format = "", location_type = "", chulha_date = "";

if(request.getParameter("format") != null)
	format = request.getParameter("format");

if(request.getParameter("chulha_date") != null)
	chulha_date = request.getParameter("chulha_date");

if(request.getParameter("location_type") != null)
	location_type = request.getParameter("location_type");

JSONObject jArray = new JSONObject();
jArray.put("chulha_date", chulha_date);
jArray.put("location_type", location_type);

VectorToJson vtj = new VectorToJson();

DoyosaeTableModel table2 = new DoyosaeTableModel("M858S010400E154", jArray); //지역별 총출하량
DoyosaeTableModel table3 = new DoyosaeTableModel("M858S010400E164", jArray); //지역명 조회
DoyosaeTableModel table4 = new DoyosaeTableModel("M858S010400E184", jArray); //가맹점명 조회

String data2 = vtj.vectorToJson(table2.getVector());
String data3 = vtj.vectorToJson(table3.getVector());
String data4 = vtj.vectorToJson(table4.getVector());

%>

<script>

$(document).ready(function() {
	
	var data2 = <%=data2%>;
	var data3 = <%=data3%>;
	var data4 = <%=data4%>;
	
	let bodyObj = new Object();
	
	bodyObj.body0 = {
	    rowCnt: 39,
	    colCnt: 15,
	    rowRatio: [17/637, 16/637, 16/637, 16/637, 17/637, 
	    		   16/637, 16/637, 16/637, 16/637, 16/637,
	    		   16/637, 16/637, 16/637, 16/637, 16/637,
	    		   16/637, 16/637, 16/637, 15/637, 16/637,
	    		   17/637, 16/637, 16/637, 16/637, 18/637,
	    		   17/637, 18/637, 16/637, 17/637, 18/637,
	    		   16/637, 16/637, 17/637, 16/637, 17/637,
	    		   16/637, 17/637, 16/637, 16/637],
	    colRatio: [22/529, 68/529, 29/529, 25/529, 23/529,
	    		   24/529, 25/529, 22/529, 26/529, 27/529,
	    		   23/529, 22/529, 22/529, 26/529, 145/529],
	};
	
	

	

	const cl = new CheckListWithImageBuilder()
	                .setDivId('myCanvas')
	                .setEntireRatio([33/670, 637/670])
	                .setHeadRowCnt(2)
	                .setHeadColCnt(3)
	                .setHeadRowRatio([15/33, 18/33])
	                .setHeadColRatio([22/529, 68/529, 439/529])
	                .howManyBodies(1)
	                .setChildBodiesRowCol(bodyObj)
	                .setStartX(9)
	                .setStartY(70)
	                .setTest(false)
	                .build();
						
	var bgImg = new Image();
	bgImg.src = '<%= format %>';
	
	bgImg.onload = function() {
		// draw background
		cl.drawBackgroundImg(cl.ctx, bgImg);
		var location_nm = data3[0][0];
		
		var week = new Array('일', '월', '화', '수', '목', '금', '토');
		
		var date = '<%=chulha_date%>';
		
		var aa = new Date(date);
		var day = aa.getDay();
		var todayLabel = week[day];
		var resultArr = new Array();
		
		//merge cells
		
		
		// fill data
		
		//head
 		cl.fillText_left(cl.head, "row1", "col1", location_nm,
				'balck', "12px arial", 20, 4);
		
 		cl.fillText_left(cl.bodies.body0, "row0", "col1", date,    //출하일자
				'balck', "10px arial", 0, 3);
 		cl.fillText(cl.bodies.body0, "row1", "col1", todayLabel,  //출하일자의 요일
				'balck', "12px arial", "right", "middle");
 		
 		// else cnt 용도
 		//기타에 들어가야 하는 제품명이 많을 경우 양식의 기타의 다음줄에 입력되고
 		//다음 가맹점 정보는 그 다음 줄에 입력되게 하기 위해서 count 하기 위한 변수
 		var else_cnt = 0; 
 		var else_cnt_temp = new Number();
 		
 		for(let i = 2; i<data4.length+2; i++){
 			console.log("top else_cnt_temp==========" + else_cnt_temp);
 	 		console.log("top========== i : " + i);
 	 		var row = "row" + (i);
 	 		var cust_nm4 	= data4[i-2][0];
 	 		var cust_cd4 	= data4[i-2][1];
 	 		
 	 		
 	 		cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col1", cust_nm4,	 //가맹점명
 	 				'balck', "10px arial", "center", "middle");	
 	 		
 	 			
 	 		
 	 		var dataJson = new Object();
 	 	 		
 	 	 		
 	 	 	dataJson.cust_cd = cust_cd4;
 	 	 	dataJson.chulha_date = '<%=chulha_date%>';
 	 	 	dataJson.location_type = '<%=location_type%>';
 	 			
 	 	 	var jsonStr = JSON.stringify(dataJson);
 	 		
 	 		var newArr =  doAjax2(jsonStr);
 	 		
 	 		for(let j = 0; j<newArr.length; j++){
 	 		
 	 		var cc = newArr[j].prod_cd;
 	 		var dd = newArr[j].chulha_count;
 	 		var ee = newArr[j].product_nm;
 	 		
 	 		if(cc == '1001'){										//제품명 : 염지닭 출하량
 	 	 		cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col2", dd,		
 	 	 				'balck', "12px arial", "center", "middle");	
 	 	 		}
 	 	 		else if(cc == '8003'){									//제품명 : 순살정육 매운맛 출하량
 	 	 		cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col3", dd,		
 	 	 	 			'balck', "12px arial", "center", "middle");
 	 	 		}
 	 	 		else if(cc == '8004'){									//제품명 : 순살정육 매운맛 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col4", dd,		
 	 	 	 	 		'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1010'){									//제품명 : 크리스피닭 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col5", dd,		
 	 	 	 	 		'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1101'){									//제품명 : 치킨파우더 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col6", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1102'){									//제품명 : 물결파우더 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col7", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1201'){									//제품명 : 치킨무(깍두기) 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col8", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1301'){									//제품명 : 골드치킨용양념 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col9", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1302'){									//제품명 : 치킨소스(맛죤) 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col10", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1303'){									//제품명 : 데리야끼소스 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col11", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1310'){									//제품명 : 마늘소스 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col12", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else if(cc == '1307'){									//제품명 : 파닭소스 출하량
 	 	 	 	cl.fillText(cl.bodies.body0, "row"+(i+else_cnt_temp), "col13", dd,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 	 	 		else {	//기타 제품명 출고내용 + 출하량											
 	 	 		
 	 	 		switch (else_cnt){
 	 	 		
 	 	 		case 0 :
 	 	 			else_cnt += 1;
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)-1)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			
 	 	 			break;
 	 	 		
 	 	 		case 1 :
 	 	 			
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt))), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 			
 	 	 		case 2 :
 	 	 			
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+1)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 			
 	 	 		case 3 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+2)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 		
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 			
 	 	 		case 4 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+3)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			
 	 	 			else_cnt += 1;
 	 	 			break;
				
 	 	 		case 5 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+4)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 		
 	 	 		case 6 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+5)), ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 		
 	 	 		case 7 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+6)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 			
 	 	 		case 8 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+7)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 		
 	 	 		case 9 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row"+(i+else_cnt_temp+(parseInt(else_cnt)+8)), "col14", ee + ":" + dd,	
 							'balck', "9px arial", "left", "top", 20, 2, 5, 5);
 	 	 			else_cnt += 1;
 	 	 			break;
 	 	 		
 	 	 		default : 
 		 			break;
 	 	 			
 	 	 			}
 	 	 		
 	 	 	 	}
 	 			
 	 		  }
 	 		
 	 		if(else_cnt == 0){
 	 		else_cnt_temp += parseInt(else_cnt);	
 	 		}
 	 		
 	 		else {
 	 		else_cnt_temp += (parseInt(else_cnt)-1);	
 	 		}
 	 		
 	 		
 	 		console.log("bottom else_cnt_temp==========" + else_cnt_temp);
 	 		console.log("bottom i ======= : " + i);
 	 		
 	 		else_cnt = 0;
 	 		}
 		
 		var else_cnt2 = 0;
 		
 		for(let i = 0; i<data2.length; i++){
 			
 			var prod_cd2 	=  data2[i][0];
 			var prod_nm2 	=  data2[i][2];
 	 		var chulha_cnt2  = data2[i][3];
 			
 			
 				if(prod_cd2 == '1001'){										//제품명 : 염지닭 총출하량
 		 		cl.fillText(cl.bodies.body0, "row30", "col2", chulha_cnt2,		
 		 				'balck', "12px arial", "center", "middle");	
 		 		}
 		 		else if(prod_cd2 == '8003'){									//제품명 : 순살정육 매운맛 총출하량
 		 		cl.fillText(cl.bodies.body0, "row30", "col3", chulha_cnt2,		
 		 	 			'balck', "12px arial", "center", "middle");
 		 		}
 		 		else if(prod_cd2 == '8004'){									//제품명 : 순살정육 매운맛 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col4", chulha_cnt2,		
 		 	 	 		'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1010'){									//제품명 : 크리스피닭 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col5", chulha_cnt2,		
 		 	 	 		'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1101'){									//제품명 : 치킨파우더 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col6", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1102'){									//제품명 : 물결파우더 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col7", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1201'){									//제품명 : 치킨무(깍두기) 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col8", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1301'){									//제품명 : 골드치킨용양념 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col9", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1302'){									//제품명 : 치킨소스(맛죤) 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col10", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1303'){									//제품명 : 데리야끼소스 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col11", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1310'){									//제품명 : 마늘소스 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col12", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1307'){									//제품명 : 파닭소스 총출하량
 		 	 	cl.fillText(cl.bodies.body0, "row30", "col13", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else {														//기타 제품명 총출하내용 + 총출하량
 		 		
 		 			
 		 			switch (else_cnt2){
 	 	 	 		
 	 	 	 		case 0 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row30", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 		
 	 	 	 		case 1 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row31", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 			
 	 	 	 		case 2 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row32", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 			
 	 	 	 		case 3 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row33", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 			
 	 	 	 		case 4 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row34", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 					
 	 	 	 		case 5 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row35", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 		
 	 	 	 		case 6 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row36", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 		
 	 	 	 		case 7 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row37", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 			
 	 	 	 		case 8 :
 	 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row38", "col14", prod_nm2 + ":" + chulha_cnt2,	
 	 							'balck', "9px arial", "left", "top", 20, 2, 1, 1);
 	 	 	 			else_cnt2 += 1;
 	 	 	 			break;
 	 	 	 		
 	 	 	 		
 	 	 	 		
 	 	 	 		default : 
 	 		 			break;
 	 	 	 			
 	 	 	 		}	
 		 	 	
 		 	 	}
 			
 			}
 		
 	    	
 	 	}

	 
	});
	
	function doAjax2(jsonStr) {
	  	var outerArr = new Array();

	  $.ajax({
	      type: "POST",
	      dataType: "json",
	      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
	      data: {"prmtr" : jsonStr, "pid" : "M858S010400E194"},
	      async: false,
	      success: function (data) {
	        for(var j = 0; j < data.length; j++) {
	            var data1 = data[j];
	            var obj = new Object();
	            
	            obj.prod_cd = data1[0];
	            obj.product_nm = data1[1];
	            obj.chulha_count = data1[2];
	           
	            outerArr.push(obj);
	        }
	      }
	    }); 
	
	  return outerArr;
}
	

</script>
<div id="PrintAreaP">
<canvas id="myCanvas" width="546" height="810">
</canvas>    
</div>