<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tablet Content Main Popup</title>
	<link rel="shotcut icon" type="image/x-icon" href="${ctx }/henesys.jpg"/>
	<!-- <jsp:include page="/Contents/Common/linkcss_js.jsp" flush="false"/> -->
</head>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}	
	
// 	DoyosaeTableModel TableModel;
// 	JSONObject jArray = new JSONObject();
// 	jArray.put( "member_key", member_key);
//     TableModel = new DoyosaeTableModel("M900S020300E994", jArray);
// 	int RowCount =TableModel.getRowCount();
	
// 	StringBuffer DataArray = new StringBuffer();
// 	if(RowCount>0) {
// 		for(int i = 0; i < RowCount; i++){
// 			DataArray.append("[");			
// 		    DataArray.append("'"+ TableModel.getValueAt(i, 0).toString().trim()  + "',");	// 제목 
// 		    DataArray.append("'"+ TableModel.getValueAt(i, 1).toString().trim()  + "',");   // 전달사항
// 		    DataArray.append("'"+ TableModel.getValueAt(i, 2).toString().trim()  + "'");	// 일시
// 			if(i==RowCount-1) {
// 				DataArray.append( "]");
// 			} else {
// 				DataArray.append( "],");
// 			}
// 		}
// 	}
	
	request.setCharacterEncoding("UTF-8"); // 한글&공백 깨짐방지
	
	String sPageUrl = request.getParameter("OrderPageUrl").toString();
	String sParamData = request.getParameter("OrderParamData").toString();
	String sPageTitle= request.getParameter("OrderPageTitle").toString();
	
	
// 	String notice = "";
// 	for(int i=0; i<RowCount; i++) {
// 		if(i<4){
// 			notice += TableModel.getValueAt(i, 1).toString().trim();
// 			for(int j=0; j<150; j++){ notice += "&nbsp;"; }		
// 		}
// 	}
	
	
%>
<body style="overflow-y:hidden;">
	<script type="text/javascript">
	
	// 창 크기 최대화
	window.onload = resizeWindow;
	function resizeWindow() {
		self.moveTo(0,0);
		self.resizeTo(screen.availWidth, screen.availHeight);
	}
	var order_data_array = [];
	var production_data_array = [];
	var notice_data_array = [];
	
	
    $(document).ready(function () {
    	document.title = "<%=sPageTitle%>";
        
    	//canvas담는 div 높이지정
//     	var head_bottom_height = $("#head_table").height() + $("#realtime_notice").height() ;
		var canvas_height = screen.availHeight - 235;
    	$("#realtime_order_contents").attr('style','height:'+canvas_height+'px;overflow-y:auto;');
    	$("#realtime_production_contents").attr('style','height:'+canvas_height+'px;overflow-y:auto;');
    	
    	//최초로 canvas 화면부르기
    	fn_realtime_order_canvas();
    	fn_realtime_production_canvas();
    	fn_realtime_notice_canvas();
    	fn_realtime_order_list_first();
    	fn_realtime_production_list_first();
    	fn_realtime_notice_list_first();
    	
    	//시계,하단공지
    	printClock();
//     	showSlides();
    });
    
    function fn_realtime_order_canvas() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010100_canvas.jsp",//주문현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	        	$("#realtime_order_contents").children().remove();
   	        },
   	        success: function (html) {
   	            $("#realtime_order_contents").hide().html(html).fadeIn(100);
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
		return false;
	}
	
	function fn_realtime_production_canvas() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010110_canvas.jsp",//생산현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	            $("#realtime_production_contents").children().remove();
   	        },
   	        success: function (html) {
   	            $("#realtime_production_contents").hide().html(html).fadeIn(100);
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
		return false;
	}
	
	function fn_realtime_notice_canvas() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010120_canvas.jsp",//공지
   	        data: "member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	            $("#realtime_notice").children().remove();
   	        },
   	        success: function (html) {
   	            $("#realtime_notice").hide().html(html).fadeIn(100);
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
		return false;
	}
	
	function fn_realtime_order_list_first() { //주문현황 변동체크    
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010105.jsp",//주문현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
	   	        	var change_data = html.trim();
	   	        	order_data_array = change_data;
	   	        	console.log("주문데이터:"+order_data_array);
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
    	return false;
	}
	
	function fn_realtime_production_list_first() { //생산현황 변동체크
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010115.jsp",//생산현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
   	        		var change_data = html.trim();
   	        		production_data_array = change_data;
   	        		console.log("생산데이터:"+production_data_array);
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
		return false;
	}
	
	function fn_realtime_notice_list_first() { //공지 변동체크
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010120.jsp",//공지
   	        data: "member_key=" + "<%=member_key%>",
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
   	        		var change_data = html.trim();
   	        		notice_data_array = change_data;
   	        		console.log("공지:"+notice_data_array);
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
		return false;
	}
	
	function fn_realtime_order_list() { //주문현황 변동체크    
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010105.jsp",//주문현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
			async: false,
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
   	        		var change_check = false;
   	        		var change_data = html.trim();
   	   	        	for(i=0; i<order_data_array.length; i++) {
   	   	        		for(j=0; j<order_data_array[i].length; j++) {
   	   	        			if(order_data_array[i][j]!=change_data[i][j]) {
   	   	        				change_check = true;
   	   	        			}
   	   	        		}
   	   	        	}
   	   	      		console.log("주문현황 변동체크:"+change_check);
   	   	        	if(change_check) {
   	   	        		order_data_array = html.trim(); // 바뀐게 있을경우 배열 갱신
   	   	        		fn_realtime_order_canvas();
   	   	        		
   	   	        	}
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
    	return false;
	}
	
	function fn_realtime_production_list() { //생산현황 변동체크
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010115.jsp",//생산현황
   	        data: "plan_month=" + "" + "&proc_cd=" + "" + "&member_key=" + "<%=member_key%>",
   	     	async: false,
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
	   	        	var change_check = false;
	   	        	var change_data = html.trim();
	   	        	for(i=0; i<production_data_array.length; i++) {
	   	        		for(j=0; j<production_data_array[i].length; j++) {
	   	        			if(production_data_array[i][j]!=change_data[i][j]) {
	   	        				change_check = true;
	   	        			}
	   	        		}
	   	        	}
	   	        	console.log("생산현황 변동체크:"+change_check);
	   	        	if(change_check) {
	   	        		production_data_array = html.trim(); // 바뀐게 있을경우 배열 갱신
	   	        		fn_realtime_production_canvas();
	   	        	}
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
    	return false;
	}
	
	function fn_realtime_notice_list() { //공지 변동체크
		$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010120.jsp",//공지
   	        data: "member_key=" + "<%=member_key%>",
   	     	async: false,
   	        beforeSend: function () {
   	        },
   	        success: function (html) {
   	        	if(html.length>0) {
	   	        	var change_check = false;
	   	        	var change_data = html.trim();
	   	        	for(i=0; i<notice_data_array.length; i++) {
	   	        		for(j=0; j<notice_data_array[i].length; j++) {
	   	        			if(notice_data_array[i][j]!=change_data[i][j]) {
	   	        				change_check = true;
	   	        			}
	   	        		}
	   	        	}
	   	        	console.log("공지 변동체크:"+change_check);
	   	        	if(change_check) {
	   	        		notice_data_array = html.trim(); // 바뀐게 있을경우 배열 갱신
	   	        		fn_realtime_notice_canvas();
	   	        	}
   	        	}
   	        },
   	        error: function (xhr, option, error) {
   	        }
   	    });
    	return false;
	}
    
    //특정 시간마다 데이터 조회 후 소켓 데이터 통신    
	REFRESHTIMEID2 = setInterval(function(){
		fn_realtime_order_list(); // 주문현황에 변동이 있는지 체크
		fn_realtime_production_list(); // 생산현황에 변동이 있는지 체크
		fn_realtime_notice_list(); // 공지에 변동이 있는지 체크
	
	}, 10000);
    
////// canvas 공통함수 부분 //////////////////////////////////////////////////////////////
	
	// 박스 그리기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,테두리 컬러,선두께)
	function ctx_Box(ctx, startX, startY, endX, endY, color, lineWidth){
		ctx.lineWidth = lineWidth; // 선 굵기
 		ctx.beginPath();
	    ctx.moveTo(startX, startY);
	    ctx.lineTo(endX, startY);
	    ctx.lineTo(endX, endY);
	    ctx.lineTo(startX, endY);
	    ctx.lineTo(startX, startY);
		ctx.strokeStyle = color; // 테두리 컬러
	    ctx.stroke(); // 테두리 컬러 적용
	    
	}
	
	// 선 그리기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,선 컬러,선두께)
	function ctx_Line(ctx, startX, startY, endX, endY, color, lineWidth){
		ctx.lineWidth = lineWidth; // 선 굵기
		ctx.beginPath();
		ctx.moveTo(startX, startY);
		ctx.lineTo(endX, endY);
		ctx.strokeStyle = color;
		ctx.stroke(); //테두리	
	}
	
	// 색 채우기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,채울 색)
	function ctx_fillColor(ctx, startX, startY, endX, endY, color){
		ctx.fillStyle = color; // 박스 내부 컬러
		ctx.fillRect(startX,startY,endX-startX,endY-startY); // 박스 내부 컬러 적용(시작좌표x,시작좌표y,영역 가로길이,영역 세로길이)
	}
	
	// 원 그리기(컨텍스트,원 중심 좌표x&y,반지름,선 컬러,선두께)
	function ctx_circle(ctx, centerX, centerY, radius, color, lineWidth){
		ctx.beginPath();
		ctx.arc(centerX, centerY, 20, 0, Math.PI*2, true);
		ctx.lineWidth = lineWidth;
		ctx.strokeStyle = color;
		ctx.stroke();
	}
	
	// 글자넣기 (컨텍스트,시작좌표x&y,입력할 글자,글자색,글자체&크기,수평정렬,수직정렬)
	//	baseline에는  alphabetic, bottom, hanging, ideographic, middle, top이 있습니다
	//	x += ctx.measureText(text).width;문자열 크키측정
	function ctx_fillText(ctx, startX, StartY, text, color, font, textAlign, Baseline){ 
		ctx.fillStyle  = color;
		ctx.font = font;
		ctx.textAlign = textAlign;
		ctx.textBaseline = Baseline;
		ctx.fillText(text, startX, StartY);
	}
	
	// 글자에 밑줄넣기(컨텍스트, 기준좌표x&y, 입력할 글자, 밑줄 색, 글자와 밑줄 사이 간격)
	function ctx_textUnderline(ctx, x, y, text, color, size, offset){
		var width = ctx.measureText(text).width;
	
		switch(ctx.textAlign){
	    	case "center":
	    		x -= (width/2); break;
	    	case "right":
	    		x -= width; break;
	  	}
	
		y += size + offset ;
		switch(ctx.textBaseline){
			case "top": break;
			case "middle":
				y -= (size/2); break;
			case "bottom":
				y -= size ; break;
		}
	
	  	ctx.beginPath();
	  	ctx.strokeStyle = color;
	  	ctx.lineWidth = size * 0.05 ;
	  	ctx.moveTo(x,y);
	  	ctx.lineTo(x+width,y);
	  	ctx.stroke();
	}
	
	// 한줄에 지정된 글자수 넘어가면 줄바꿈(컨텍스트, 기준좌표x&y, 입력할 글자, 글자색, 글자체&크기, 수평정렬, 수직정렬, 한줄 최대 너비, 줄바꿈 높이)
	function ctx_wrapText(context, x, y, text, color, font, textAlign, Baseline, line_width, line_height)
	{
		var lineArray = new Array();
	    var line = '';
	    var paragraphs = text.split('\n');
	    for (var i = 0; i < paragraphs.length; i++)
	    {
	        var words = paragraphs[i].split(''); // 한글자씩 배열로 저장
	        for (var n = 0; n < words.length; n++)
	        {
	            var testLine = line + words[n] ;
	            var metrics = context.measureText(testLine);
	            var testWidth = metrics.width;
	            if (testWidth > line_width && n > 0)
	            {
	            	lineArray.push(line);
	                line = words[n] ;
	            }
	            else
	            {
	                line = testLine;
	            }
	        }
	        lineArray.push(line);
	        line = '';
	    }
	    
	    if(Baseline=='middle') y -= (line_height * (lineArray.length - 1) / 2) ; // 수직 중간 맞춤을 위한 y좌표 조정
	    
	    for(var i = 0; i < lineArray.length; i++) {
	    	ctx_fillText(context, x, y, lineArray[i], color, font, textAlign,Baseline);
	    	y += line_height;
	    }
	    
	    return lineArray.length; // 라인 수 리턴
	}
	
	// 한줄에 지정된 글자수 넘어가면 줄바꿈 - 공백(스페이스바,띄어쓰기)으로 줄 구분
	function ctx_wrapText_space(context, x, y, text, color, font, textAlign, Baseline, line_width, line_height)
	{
	    var line = '';
	    var lineArray = new Array();
	    var paragraphs = text.split('\n');
	    for (var i = 0; i < paragraphs.length; i++)
	    {
	        var words = paragraphs[i].split(' '); // space(공백) 단위로 잘라서 배열로 저장
	        for (var n = 0; n < words.length; n++)
	        {
	            var testLine = line + words[n] + ' ';
	            var metrics = context.measureText(testLine);
	            var testWidth = metrics.width;
	            if (testWidth > line_width && n > 0)
	            {
	            	lineArray.push(line.substring(0, line.length-1));
	                line = words[n] + ' ';
	            }
	            else
	            {
	                line = testLine;
	            }
	        }
	        lineArray.push(line.substring(0, line.length-1));
	        line = '';
	    }
	    
		if(Baseline=='middle') y -= (line_height * (lineArray.length - 1) / 2) ; // 수직 중간 맞춤을 위한 y좌표 조정
	    
	    for(var i = 0; i < lineArray.length; i++) {
	    	ctx_fillText(context, x, y, lineArray[i], color, font, textAlign,Baseline);
	    	y += line_height;
	    }
	}
	
	// 지정된 폭에 택스트 넣을때 줄바꿈 몇번인지 계산(컨텍스트, 텍스트, 한줄 최대 너비)
	function ctx_wrapText_lineCount(context, text, line_width)
	{
		var lineArray = new Array();
	    var line = '';
	    var paragraphs = text.split('\n');
	    for (var i = 0; i < paragraphs.length; i++)
	    {
	        var words = paragraphs[i].split(''); // 한글자씩 배열로 저장
	        for (var n = 0; n < words.length; n++)
	        {
	            var testLine = line + words[n] ;
	            var metrics = context.measureText(testLine);
	            var testWidth = metrics.width;
	            if (testWidth > line_width && n > 0)
	            {
	            	lineArray.push(line);
	                line = words[n] ;
	            }
	            else
	            {
	                line = testLine;
	            }
	        }
	        lineArray.push(line);
	        line = '';
	    }
	    
	    var str='';
	    for(var i = 0; i < lineArray.length; i++) {
	    	str += lineArray[i]+"\n"
	    }
	    
	    return lineArray.length; // 라인 수 리턴
	}
	
	 // 숫자 관련(세자리마다 콤마, 숫자를 한글로 표기)
	var ctx_mony_to_hangle={
		arrNumberWord: 	["","일","이","삼","사","오","육","칠","팔","구"],
		arrDigitWord: 	["","십","백","천"],
		arrManWord:		["","만","억", "조"],
		numberWithCommas: function(x) { // 세자리마다 콤마
		    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		},
		change_hangul_money: function(num){ // 숫자를 한글로 표기
	    	var num_value = num.toString();
	   		var num_length = num_value.length;
	      	if(isNaN(num_value) == true)
	        	return;
	    	var han_value = "";
	    	var man_count = 0;      // 만단위 0이 아닌 금액 카운트.
	
			for(i=0; i < num_value.length; i++){
	       		// 1단위의 문자로 표시.. (0은 제외)
	       		var strTextWord = this.arrNumberWord[num_value.charAt(i)];
	          	// 0이 아닌경우만, 십/백/천 표시
	        	if(strTextWord != ""){
	            	man_count++;
	           		strTextWord += this.arrDigitWord[(num_length - (i+1)) % 4];
	           	}
	        	// 만단위마다 표시 (0인경우에도 만단위는 표시한다)
	    		if(man_count != 0 && (num_length - (i+1)) % 4 == 0){
	            	man_count = 0;
	           		strTextWord = strTextWord + this.arrManWord[(num_length - (i+1)) / 4];
	      		}
	   			han_value += strTextWord;
	//	   			console.log(han_value);
	  		}
	//			if(num_value != 0)
	//	        	han_value = "금 " + han_value + " 원";
	       	return han_value;
		}
	}
	 
	// 프린트 버튼 눌렀을때 -> 프린트 화면으로 넘어감
	function print_area(){
		const dataUrl = document.getElementById('myCanvas').toDataURL();
		// for 태양 거래명세표
		if(document.getElementById('PrintAreaP').childElementCount == 2) {	
			var cutLine = "<br><br><hr style='background-color: #fff; border-top: 2px dashed #8c8b8b;'>";
 			var dataUrl2 = document.getElementById('myCanvas').toDataURL();
		} else {
			cutLine = "";
			dataUrl2 = "";
		}
		
		let windowContent = '<!DOCTYPE html>';
		windowContent += '<html>';
		windowContent += '<head><title>Print canvas</title></head>';
		windowContent += '<body>';
		windowContent += '<img src="' + dataUrl + '">';
		windowContent += cutLine;
		windowContent += '<img src="' + dataUrl2 + '">';
		windowContent += '</body>';
		windowContent += '</html>';

		const printWin = window.open('', '', 'width=' + (screen.availWidth*0.8) + ',height=' + (screen.availHeight*0.95) + ',top=1 ,left=0');
		printWin.document.open();
		printWin.document.write(windowContent); 

		printWin.document.addEventListener('load', function() {
		    printWin.focus();
		    printWin.print();
		    printWin.document.close();
		    printWin.close();
		}, true);
	}
	
//////canvas 공통함수 부분 끝 //////////////////////////////////////////////////////////////
		function printClock() {
	    
	    var clock = document.getElementById("clock");            // 출력할 장소 선택
	    var currentDate = new Date();                                     // 현재시간
	    var calendar = currentDate.getFullYear() + "-" + addZeros((currentDate.getMonth()+1),2) + "-" + addZeros(currentDate.getDate(),2) // 현재 날짜
	    var amPm = 'AM'; // 초기값 AM
	    var currentHours = addZeros(currentDate.getHours(),2); 
	    var currentMinute = addZeros(currentDate.getMinutes() ,2);
	    var currentSeconds =  addZeros(currentDate.getSeconds(),2);
	    
	    if(currentHours >= 12){ // 시간이 12보다 클 때 PM으로 세팅, 12를 빼줌
	    	amPm = 'PM';
	    	currentHours = addZeros(currentHours - 12,2);
	    }

	    if(currentSeconds >= 50){// 50초 이상일 때 색을 변환해 준다.
	       currentSeconds = '<span style="color:#de1951;">'+currentSeconds+'</span>'
	    }
	    clock.innerHTML = calendar + "  " + currentHours+":"+currentMinute +" <span style='font-size:30px;'>"+ amPm+"</span>"; //날짜를 출력해 줌
	    
	    setTimeout("printClock()",1000);         // 1초마다 printClock() 함수 호출
	}

	function addZeros(num, digit) { // 자릿수 맞춰주기
		  var zero = '';
		  num = num.toString();
		  if (num.length < digit) {
		    for (i = 0; i < digit - num.length; i++) {
		      zero += '0';
		    }
		  }
		  return zero + num;
	}

	var slideIndex = 0;	
	function showSlides() {
	    var i;
	    var slides = document.getElementsByClassName("mySlides");
	    var dots = document.getElementsByClassName("dot");
	    for (i = 0; i < slides.length; i++) {
	       slides[i].style.display = "none";
	    }
	    slideIndex++;
	    if (slideIndex > slides.length) {slideIndex = 1}    
	    for (i = 0; i < dots.length; i++) {
	        dots[i].className = dots[i].className.replace(" active", "");
	    }
	    slides[slideIndex-1].style.display = "block";  
	    dots[slideIndex-1].className += " active";
// 	    setTimeout(showSlides, 5000);
	}
	</script>
	
	<table style="width:100%" id='head_table' >
		<tr>
		   	<td style="width:30%; vertical-align: top; padding-top: 10px; border-bottom: 2px brown solid; padding-left: 30px;" >
		   		<img id="yamsam_logo" src="../../images/yamsam_logo.png" style="width:auto; height:50px;" />
		   	</td>
		   	<td style="width:70%; vertical-align: top; padding-top: 30px; border-bottom: 2px brown solid;" >
		   		<div onclick="printClock()" style="height:50px; line-height:50px; color:#666;font-size:30px; text-align:right; padding-right: 30px;" id="clock"></div>
		   	</td>
		</tr>
		</table>
		<table style="width:100%" >
		<tr style="width:100%">
	    	<td style="width:75%; vertical-align: top;" ><div id="realtime_order_contents" ></div></td>
	    	<td style="width:25%; vertical-align: top;" ><div id="realtime_production_contents" ></div></td>
	    </tr>
	<!--     <tr><td colspan="2"> -->
			
	<!--     </td></tr> -->
	<!--     <tr><td colspan="2"> -->
	<!--     <div> -->
	<!--     	<p style="text-align:center;" > -->
	<!--         	<button id="btn_Canc"  class="btn btn-info"  onclick="clearInterval(REFRESHTIMEID2); window.close();">닫기</button> -->
	<!--         <button id="btn_Canc"  class="btn btn-info"  onclick="window.close();">닫기</button> -->
	<!--     	</p> -->
	<!-- 	</div> -->
	<!-- 	</td></tr> -->
	</table>
	<div id='realtime_notice' style="position: absolute; bottom: 0px; height: 50px;">
	<!-- 	<marquee width=100% height=50px bgcolor="blue" scrollamount="10" > -->
	<%-- 			<font size="6" color="white" ><b><%=notice%></b></font> --%>
	<!-- 	</marquee> -->
	</div>
</body>
</html>