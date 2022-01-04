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
출고집계표(S858S010401.jsp)
*/	
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();

String format = "",  location_type = "", location_nm = "", chulha_date = "";

if(request.getParameter("format") != null)
	format = request.getParameter("format");

if(request.getParameter("chulha_date") != null)
	chulha_date = request.getParameter("chulha_date");

if(request.getParameter("location_type") != null)
	location_type = request.getParameter("location_type");

if(request.getParameter("location_type_nm") != null)
	location_nm = request.getParameter("location_type_nm");

JSONObject jArray = new JSONObject();
jArray.put("chulha_date", chulha_date);
jArray.put("location_nm", location_nm);
jArray.put("location_type", location_type);

VectorToJson vtj = new VectorToJson();

DoyosaeTableModel table2 = new DoyosaeTableModel("M858S010400E154", jArray); //지역별 총출하량
DoyosaeTableModel table3 = new DoyosaeTableModel("M858S010400E164", jArray); //지역명 조회
DoyosaeTableModel table4 = new DoyosaeTableModel("M858S010400E204", jArray); //p박스 출고량 조회


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
	    rowCnt: 19,
	    colCnt: 6,
	    rowRatio: [40/623, 21/623, 39/623, 20/623, 39/623, 
	    		   21/623, 31/623, 20/623, 40/623, 20/623,
	    		   40/623, 20/623, 39/623, 21/623, 40/623,
	    		   48/623, 34/623, 37/623, 43/623],
	    colRatio: [92/535, 78/535, 71/535, 76/535, 71/535, 147/535],
	};
	
	

	

	const cl = new CheckListWithImageBuilder()
	                .setDivId('myCanvas')
	                .setEntireRatio([81/704, 623/704])
	                .setHeadRowCnt(3)
	                .setHeadColCnt(7)
	                .setHeadRowRatio([27/81, 27/81, 27/81])
	                .setHeadColRatio([24/535, 68/535, 78/535, 71/535, 76/535, 71/535, 147/535])
	                .howManyBodies(1)
	                .setChildBodiesRowCol(bodyObj)
	                .setStartX(8)
	                .setStartY(53)
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
		
		
		if(data4.length == 0){
		
		var pbox_ChulgoAmt = 0
			
		}
		
		else {
		
		var pbox_ChulgoAmt = data4[0][0];	
		
		}
		
		
		
		
		// fill data
		
		//head
 		cl.fillText(cl.head, "row1", "col1", location_nm, //배송지역
				'balck', "12px arial", "center", "middle");
		
 		cl.fillText(cl.head, "row2", "col1", date,    //출하일자
				'balck', "12px arial", "center", "middle");
 		cl.fillText_left(cl.head, "row2", "col2", todayLabel,  //출하일자의 요일
				'balck', "10px arial", 12, 9);
 		
 		var else_cnt = 0;
 		
 		for(let i = 0; i<data2.length; i++){
 			
 			var prod_cd2 	=  data2[i][0];
 			var prod_nm2 	=  data2[i][2];
 	 		var chulha_cnt2  = data2[i][3];
 			
 				//제품 나열 순서는 출고 집계표에 나와 있는대로 기재하였음.	
 	 		
 				if(prod_cd2 == '1001'){											//제품명 : 염지닭 총출고량
 		 		cl.fillText(cl.bodies.body0, "row1", "col0", chulha_cnt2,		
 		 				'balck', "12px arial", "center", "middle");	
 		 		}
 				else if(prod_cd2 == '1201'){									//제품명 : 치킨무(깍두기) 총출고량
 	 		 	cl.fillText(cl.bodies.body0, "row1", "col1", chulha_cnt2,		
 	 		 	 	 	 'balck', "12px arial", "center", "middle");		
 	 		 	}
 		 		else if(prod_cd2 == '8003'){									//제품명 : 순살정육 매운맛 총출고량
 		 		cl.fillText(cl.bodies.body0, "row1", "col2", chulha_cnt2,		
 		 	 			'balck', "12px arial", "center", "middle");
 		 		}
 		 		else if(prod_cd2 == '8004'){									//제품명 : 순살정육 매운맛 총출고량
 		 	 	cl.fillText(cl.bodies.body0, "row1", "col3", chulha_cnt2,		
 		 	 	 		'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '8005'){									//제품명 : 크리스피닭 총출고량
 		 	 	cl.fillText(cl.bodies.body0, "row1", "col4", chulha_cnt2,		
 		 	 	 		'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1007'){									//제품명 : 안심 총출고량
 	 		 	cl.fillText(cl.bodies.body0, "row1", "col5", chulha_cnt2,		
 	 		 	 	 	'balck', "12px arial", "center", "middle");		
 	 		 	}
 		 		else if(prod_cd2 == '1605'){									//제품명 : 양념근위 총출고량
 	 	 		cl.fillText(cl.bodies.body0, "row3", "col0", chulha_cnt2,		
 	 	 		 	 	'balck', "12px arial", "center", "middle");		
 	 	 		}
 		 		else if(prod_cd2 == '1604'){									//제품명 : 무뼈닭발 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row3", "col1", chulha_cnt2,		
 	 	 	 		 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1656'){									//제품명 : (장)가라아게 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row3", "col2", chulha_cnt2,		
 	 	 	 	 		'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1607'){									//제품명 : 튀김용근위 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row3", "col3", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '8009'){									//제품명 : 포장무 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row3", "col4", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1657'){									//제품명 : 해물어묵탕 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row3", "col5", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1703'){									//제품명 : 해물짬뽕탕 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col0", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1813'){									//제품명 : 감자튀김 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col1", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1332'){									//제품명 : 크림 어니언소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col2", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1334'){									//제품명 : 국물떡볶이소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col3", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1308'){									//제품명 : 골뱅이소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col4", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1333'){									//제품명 : 고추핫소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row5", "col5", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1301'){									//제품명 : 양념(골드) 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col0", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1302'){									//제품명 : 양념(맛죤) 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col1", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1303'){									//제품명 : 데리야끼소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col2", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1310'){									//제품명 : 마늘소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col3", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1307'){									//제품명 : 파닭소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col4", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1305'){									//제품명 : 골드불닭소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row7", "col5", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1702'){									//제품명 : 맛존양념소금(소) 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row9", "col0", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1701'){									//제품명 : 맛존양념소금(대) 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row9", "col1", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1006'){									//제품명 : 냉동윙 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row9", "col3", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1013'){									//제품명 : 냉동북채 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row9", "col4", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1335'){									//제품명 : 아마겟돈소스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row9", "col5", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1501'){									//제품명 : 포장박스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col0", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1507'){									//제품명 : 반마리박스 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col1", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1505'){									//제품명 : 쇼핑백 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col2", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1506'){									//제품명 : 소봉투 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col3", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1510'){									//제품명 : 대봉투 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col4", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1807'){									//제품명 : 홀앞치마 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row11", "col5", chulha_cnt2,		
 	 	 	 	 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else if(prod_cd2 == '1101'){									//제품명 : 치킨파우더 총출고량
 		 	 	cl.fillText(cl.bodies.body0, "row13", "col0", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		else if(prod_cd2 == '1102'){									//제품명 : 물결파우더 총출고량
 		 	 	cl.fillText(cl.bodies.body0, "row13", "col1", chulha_cnt2,		
 		 	 	 	 	'balck', "12px arial", "center", "middle");		
 		 	 	}
 		 		/* else if(prod_cd2 == '1102'){									//제품명 : 9호닭 총출고량
 	 		 	cl.fillText(cl.bodies.body0, "row13", "col2", chulha_cnt2,		
 	 		 	 	 	'balck', "12px arial", "center", "middle");		
 	 		 	}
 		 		else if(prod_cd2 == '1102'){									//제품명 : 윙봉 총출고량
 	 	 		cl.fillText(cl.bodies.body0, "row13", "col3", chulha_cnt2,		
 	 	 		 	 	'balck', "12px arial", "center", "middle");		
 	 	 		} */
 		 		else if(prod_cd2 == '1819'){									//제품명 : 안내문구 총출고량
 	 	 	 	cl.fillText(cl.bodies.body0, "row13", "col5", chulha_cnt2,		
 	 	 	 		 	 	'balck', "12px arial", "center", "middle");		
 	 	 	 	}
 		 		else {															//기타 제품명 총출고내용 + 총출고량
 		 																		//0~9번까지 총 10개까지 들어간다
 		 		switch (else_cnt){
 		 		case 0 : 														
 		 			/* cl.wrapText_XY(cl, cl.bodies.body0, "row12", "col4", prod_nm2,	
 						'balck', "9px arial", "left", "top", 9, 2, 6, 6); */
 		 			 cl.fillText(cl.bodies.body0, "row12", "col4", prod_nm2,		
 	 		 	 	 	 	'balck', "10px arial", "center", "middle"); 
 		 	 		 cl.fillText(cl.bodies.body0, "row13", "col4", chulha_cnt2,		
 		 	 	 	 	'balck', "10px arial", "center", "middle"); 
 		 	 		else_cnt += 1;
 		 	 		break;
 		 		
 		 		case 1 :
 	 	 			cl.wrapText_XY(cl, cl.bodies.body0, "row14", "col1", prod_nm2 + " : " + chulha_cnt2,	
 	 					'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 			/* cl.fillText(cl.bodies.body0, "row15", "col1", chulha_cnt2,		
 	 	 		 	 	 'balck', "10px arial", "center", "bottom"); */
 	 	 			else_cnt += 1;
 		 			break;
 		 		
 		 		case 2 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row14", "col2", prod_nm2 + " : " + chulha_cnt2,	
 	 					'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row15", "col2", chulha_cnt2,		
 	 	 	 		 	'balck', "10px arial", "center", "bottom"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 		
 		 		case 3 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row14", "col3", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row15", "col3", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "bottom"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 		
 		 		case 4 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row14", "col4", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row15", "col4", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "bottom"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 		
 		 		case 5 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row14", "col5", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 15, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row15", "col5", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "bottom"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 			
 		 		case 6 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row15", "col1", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row17", "col2", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "middle"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 			
 		 		case 7 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row15", "col2", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row17", "col3", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "middle"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 		
 		 		case 8 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row15", "col3", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row17", "col4", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "middle"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 			
 		 		case 9 :
 	 	 	 		cl.wrapText_XY(cl, cl.bodies.body0, "row15", "col4", prod_nm2 + " : " + chulha_cnt2,	
 						'balck', "10px arial", "left", "top", 9, 3, 6, 6);
 	 	 	 		/* cl.fillText(cl.bodies.body0, "row17", "col5", chulha_cnt2,		
 	 	 	 	 		'balck', "10px arial", "center", "middle"); */
 	 	 	 		else_cnt += 1;
 		 			break;
 		 		
 		 		default : 
 		 			break;
 		 		}	
 		 		
 		 	 	}
 			
 		}
 		
 		cl.fillText(cl.bodies.body0, "row17", "col1", pbox_ChulgoAmt,		// pbox 출고량
	 				'balck', "12px arial", "center", "top");	
 		
 	    	
 	 	}

	 
	});

</script>
<div id="PrintAreaP">
<canvas id="myCanvas" width="555" height="810">
</canvas>    
</div>