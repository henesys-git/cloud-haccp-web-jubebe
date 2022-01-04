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
거래명세표 조회(S303S010105.jsp)
*/	
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();

String format = "",  location_type = "", order_date = "", order_no = "", order_rev_no = "";

if(request.getParameter("format") != null)
	format = request.getParameter("format");

if(request.getParameter("order_date") != null)
	order_date = request.getParameter("order_date");

if(request.getParameter("location_type") != null)
	location_type = request.getParameter("location_type");

if(request.getParameter("order_no") != null)
	order_no = request.getParameter("order_no");

if(request.getParameter("order_rev_no") != null)
	order_rev_no = request.getParameter("order_rev_no");

JSONObject jArray = new JSONObject();
jArray.put("order_date", order_date);
jArray.put("order_no", order_no);
jArray.put("order_rev_no", order_rev_no);
jArray.put("location_type", location_type);

VectorToJson vtj = new VectorToJson();

DoyosaeTableModel table1 = new DoyosaeTableModel("M303S010100E144", jArray); //지역별 총출하량
DoyosaeTableModel table2 = new DoyosaeTableModel("M303S010100E154", jArray); //지역명 조회
DoyosaeTableModel table3 = new DoyosaeTableModel("M303S010100E164", jArray); //지역명 조회


String data1 = vtj.vectorToJson(table1.getVector());
String data2 = vtj.vectorToJson(table2.getVector());
String data3 = vtj.vectorToJson(table3.getVector());

%>

<script>



$(document).ready(function() {
	
	var data1 = <%=data1%>;
	var data2 = <%=data2%>;
	var data3 = <%=data3%>;
	
	let sum_price = new Number();
	let sum_count = new Number();
	let sum_supply_price = new Number();
	let sum_tax = new Number();
	
	
	let bodyObj = new Object();
	
	bodyObj.body0 = {
	    rowCnt: 17,
	    colCnt: 7,
	    rowRatio: [17/229, 12/229, 13/229, 14/229, 13/229, 
	    		   14/229, 13/229, 13/229, 14/229, 13/229,
	    		   13/229, 14/229, 13/229, 13/229, 14/229,
	    		   13/229, 13/229],
	    colRatio: [40/549, 148/549, 148/549, 37/549, 52/549, 67/549, 57/549],
	};
	
	bodyObj.body1 = {
		    rowCnt: 1,
		    colCnt: 7,
		    rowRatio: [17/17],
		    colRatio: [171/549, 49/549, 116/549, 37/549, 52/549, 67/549, 57/549],
		};
	
	bodyObj.body2 = {
		    rowCnt: 1,
		    colCnt: 8,
		    rowRatio: [16/16],
		    colRatio: [62/549, 78/549, 65/549, 77/549, 63/549, 72/549, 53/549, 79/549],
		};
	
	bodyObj.body3 = {
		    rowCnt: 1,
		    colCnt: 1,
		    rowRatio: [25/25],
		    colRatio: [549/549],
		};
	
	bodyObj.body4 = {
		    rowCnt: 5,
		    colCnt: 11,
		    rowRatio: [27/90, 15/90, 16/90, 16/90, 16/90],
		    colRatio: [54/549, 39/549, 95/549, 32/549, 78/549, 8/549, 54/549, 40/549, 39/549, 31/549, 79/549],
		};
	
	bodyObj.body5 = {
		    rowCnt: 17,
		    colCnt: 7,
		    rowRatio: [15/229, 13/229, 14/229, 13/229, 14/229, 
	    		   	   13/229, 13/229, 13/229, 14/229, 13/229,
	    		   	   14/229, 13/229, 13/229, 13/229, 14/229,
	    		   	   13/229, 14/229],
		    colRatio: [40/549, 148/549, 148/549, 37/549, 52/549, 67/549, 57/549],
		};
	
	bodyObj.body6 = {
		    rowCnt: 1,
		    colCnt: 7,
		    rowRatio: [15/15],
		    colRatio: [171/549, 49/549, 116/549, 37/549, 52/549, 67/549, 57/549],
		};
	
	bodyObj.body7 = {
		    rowCnt: 1,
		    colCnt: 8,
		    rowRatio: [16/16],
		    colRatio: [62/549, 78/549, 65/549, 77/549, 63/549, 72/549, 53/549, 79/549],
		};
	
	

	

	const cl = new CheckListWithImageBuilder()
	                .setDivId('myCanvas')
	                .setEntireRatio([83/720, 229/720, 17/720, 16/720, 25/720, 90/720, 229/720, 15/720, 16/720])
	                .setHeadRowCnt(5)
	                .setHeadColCnt(11)
	                .setHeadRowRatio([22/83, 16/83, 16/83, 16/83, 13/83])
	                .setHeadColRatio([54/549, 39/549, 95/549, 32/549, 78/549, 8/549, 54/549, 40/549, 39/549, 31/549, 79/549])
	                .howManyBodies(8)
	                .setChildBodiesRowCol(bodyObj)
	                .setStartX(15)
	                .setStartY(45)
	                .setTest(false)
	                .build();
						
	var bgImg = new Image();
	bgImg.src = '<%= format %>';
	
	bgImg.onload = function() {
		// draw background
		cl.drawBackgroundImg(cl.ctx, bgImg);
		
		var week = new Array('일', '월', '화', '수', '목', '금', '토');
		
		var date = '<%=order_date%>';
		
		var aa = new Date(date);
		var day = aa.getDay();
		var todayLabel = week[day];
		
		var driver_nm 		  = data3[0][0];
		var hp_no 	  		  = data3[0][1];
		var location_nm 	  = data3[0][2];
		
		// fill data
		
		
		//거래명세서(공급자용) 가맹점 정보 내역
 		cl.fillText_left(cl.head, "row0", "col0", date,    //주문일자
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row1", "col2", data1[0][1],    //가맹점 등록번호
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row2", "col1", data1[0][0],    //가맹점명
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row2", "col4", data1[0][2],    //가맹점주 성명
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row3", "col1", data1[0][3],    //가맹점 주소
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row4", "col1", data1[0][4],    //가맹점 업태
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.head, "row4", "col4", data1[0][5],    //가맹점 종목
				'balck', "10px arial", 3, 3);
 		
 		
 		//body
 		
 		for(let i = 0; i<data2.length; i++){
 			
 			var row = "row" + (i+1);
 			
 			var prod_nm = data2[i][0];
 			var gugyuk = data2[i][1];
 	 		var order_count  =  "";
 	 		var unit_price   =  "";
 	 		var supply_price =  "";
 	 		var tax 		 =  "";
 	 		
 	 		if(data2[i][2] == "") {
 	 			order_count = 0;	
 	 		}
 	 		else{
 	 			order_count = parseInt(data2[i][2]);	
 	 		}
 	 		
 	 		if(data2[i][3] == "") {
 	 	 		unit_price = 0;	
 	 	 	}
 	 	 	else{
 	 	 		unit_price = parseInt(data2[i][3]);	
 	 	 	}
 	 		
 	 		if(data2[i][4] == "") {
 	 	 		supply_price = 0;	
 	 	 	}
 	 	 	else{
 	 	 		supply_price = parseInt(data2[i][4]);	
 	 	 	}
 	 		
 	 		if(data2[i][5] == "") {
 	 	 		tax = 0;	
 	 	 	}
 	 	 	else{
 	 	 		tax = parseInt(data2[i][5]);	
 	 	 	}
 			
 			/* var prod_nm 	 =  data2[i][0];
 			var gugyuk 		 =  data2[i][1];
 	 		var order_count  =  data2[i][2];
 	 		var unit_price   =  data2[i][3];
 	 		var supply_price =  data2[i][4];
 	 		var tax 		 =  data2[i][5]; */
 			
 	 		//거래명세서(공급자용) 주문제품내역
 		 	 cl.fillText_left(cl.bodies.body0, row, "col0", i+1,		//순번
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_left(cl.bodies.body0, row, "col1", prod_nm, //품명
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_left(cl.bodies.body0, row, "col2", gugyuk, //규격
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body0, row, "col3", addComma(order_count), //주문수량
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body0, row, "col4", addComma(unit_price), //단가
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body0, row, "col5", addComma(supply_price), //공급가액
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body0, row, "col6", addComma(tax), //세액
 		 			'balck', "10px arial", 1, 1);
 		 	
 		 	//거래명세서(공급받는자용) 주문제품내역
 		 	cl.fillText_left(cl.bodies.body5, row, "col0", i+1,		//순번
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_left(cl.bodies.body5, row, "col1", prod_nm, //품명
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_left(cl.bodies.body5, row, "col2", gugyuk, //규격
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body5, row, "col3", addComma(order_count), //주문수량
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body5, row, "col4", addComma(unit_price), //단가
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body5, row, "col5", addComma(supply_price), //공급가액
 		 			'balck', "10px arial", 1, 1);
 		 	cl.fillText_right(cl.bodies.body5, row, "col6", addComma(tax), //세액
 		 			'balck', "10px arial", 1, 1); 
 		 	
 		 	sum_price += (parseInt(unit_price) * order_count);
 		 	sum_count += parseInt(order_count);
 		 	sum_supply_price += parseInt(supply_price);
 		 	sum_tax += parseInt(tax);
 		 	
 			
 		}
 		
 		//거래명세서(공급받는자용) 가맹점 정보 내역
 		cl.fillText_left(cl.bodies.body4, "row0", "col0", date,    //주문일자
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row1", "col2", data1[0][1],    //가맹점 등록번호
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row2", "col1", data1[0][0],    //가맹점명
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row2", "col4", data1[0][2],    //가맹점주 성명
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row3", "col1", data1[0][3],    //가맹점 주소
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row4", "col1", data1[0][4],    //가맹점 업태
				'balck', "10px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body4, "row4", "col4", data1[0][5],    //가맹점 종목
				'balck', "10px arial", 3, 3);
 		
 		cl.fillText_left(cl.bodies.body1, "row0", "col0",     			//거래명세서(공급자용) 배송기사정보
 				"기사정보 : " + location_nm + "(" + driver_nm + ")" + "(" + hp_no  +")",    
				'balck', "9px arial", 3, 3);
 		cl.fillText_left(cl.bodies.body6, "row0", "col0",     			//거래명세서(공급받는자용) 배송기사정보
 				"기사정보 : " + location_nm + "(" + driver_nm + ")" + "(" + hp_no  +")",    
				'balck', "9px arial", 3, 3);
 		
 		cl.fillText_right(cl.bodies.body1, "row0", "col2", addComma(sum_price),    //거래명세서(공급자용) 금액 합계
				'balck', "10px arial", 3, 3);
 		cl.fillText_right(cl.bodies.body6, "row0", "col2", addComma(sum_price),    //거래명세서(공급받는자용) 금액 합계
				'balck', "10px arial", 3, 3);
 		
 		cl.fillText_right(cl.bodies.body1, "row0", "col3", addComma(sum_count),    //거래명세서(공급자용) 수량 합계
				'balck', "10px arial", 3, 3);
 		cl.fillText_right(cl.bodies.body6, "row0", "col3", addComma(sum_count),    //거래명세서(공급받는자용) 수량 합계
				'balck', "10px arial", 3, 3);
 		
 		cl.fillText_right(cl.bodies.body1, "row0", "col5", addComma(sum_supply_price),    //거래명세서(공급자용) 공급가액 합계
				'balck', "10px arial", 5, 3);
 		cl.fillText_right(cl.bodies.body6, "row0", "col5", addComma(sum_supply_price),    //거래명세서(공급받는자용) 공급가액 합계
				'balck', "10px arial", 5, 3);
 		
 		cl.fillText_right(cl.bodies.body1, "row0", "col6", addComma(sum_tax),    //거래명세서(공급자용) 세액 합계
				'balck', "10px arial", 3, 3);
 		cl.fillText_right(cl.bodies.body6, "row0", "col6", addComma(sum_tax),    //거래명세서(공급받는자용) 세액 합계
				'balck', "10px arial", 3, 3);
 		
 		cl.fillText_right(cl.head, "row0", "col10", "합계 : " + addComma(sum_price),    //거래명세서(공급자용) 상단 금액 합계
				'balck', "10px arial", 3, 3);
 		cl.fillText_right(cl.bodies.body4, "row0", "col10", "합계 : " + addComma(sum_price),    //거래명세서(공급받는자용) 상단 금액 합계
				'balck', "10px arial", 3, 3);
 		
 	    	
 	 	}

	 
	});

</script>
<div id="PrintAreaP">
<canvas id="myCanvas" width="578" height="810">
</canvas>    
</div>