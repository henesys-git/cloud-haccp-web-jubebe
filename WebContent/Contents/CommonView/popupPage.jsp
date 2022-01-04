<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.conf.*" %>
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
	
	request.setCharacterEncoding("UTF-8"); // 한글&공백 깨짐방지
	
	String sPageUrl = request.getParameter("pageUrl").toString();
	String sParamData = request.getParameter("paramData").toString();
	String sPageTitle= request.getParameter("pageTitle").toString();
%>
<body>
	<script type="text/javascript">
	
    $(document).ready(function () {
    	document.title = "<%=sPageTitle%>";

        $.ajax(
        {
            type: "POST",
            async: false,
<%--             url: "<%=Config.this_SERVER_path%>/Contents/<%=sHeadmenuID%>/<%=sProgramId%>", // 일반화면 url --%>
            url: "<%=sPageUrl%>", // Tablet화면 url
            data: "<%=sParamData%>",
            beforeSend: function () {
                $("#popMainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#popMainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
//             	console.log("code:"+xhr.status+"\n"+"error:"+error+"\n"+"message:"+xhr.responseText);
            	var error_info = "";
				if(xhr.status=="404") {
					error_info = "페이지가 존재하지 않습니다" ;
				} else {
					error_info = "페이지에 에러가 있습니다(에러코드:" + xhr.status + ")" ;
				}
            	alert("<%=sPageUrl%>" + "\n" + error_info);
            	window.close(); // 팝업창 닫기
            }
        });
    });
    
    function pop_fn_popUpScr(url,title, height, width) {

    	var posX = $('#modalReport').offset().left - $(document).scrollLeft() - width + $('#modalReport').outerWidth();
    	var posY = $('#modalReport').offset().top - $(document).scrollTop() + $('#modalReport').outerHeight();
//     	   $("#dialog").dialog({width:width, height:height ,position:[posX, posY]});

        $("#modalReport_Title").text(title);
        $("#modalReport").find(".modal-body").css("top", $('#modalReport').scrollTop());
//                 $("#modalReport").find(".modal-body").css("top", posY);
//                 $("#modalReport").find(".modal-body").css("left", posX);
		$("#modalReport").find(".modal-body").css("height", height);
		$("#modalReport").find(".modal-dialog").css("width", width);
//  		$("#modalReport").attr("closeOnEscape", "false");
 		
		$.ajax({
	    	type: "POST",
	    	url:  url , 
	 	 	beforeSend: function () { 
	            $("#ReportNote").children().remove();
	   		},
	   	  	success: function (html) {
		   	  	$('#ReportNote').hide().html(html).fadeIn(100);
				$('#modalReport').show(); 
				$('#btn_Canc').on("click",function(){
					$('#modalReport').hide();
					
				});
	   	   	},
	   	 	error: function (xhr, option, error) {
	   	  	}
		});
		return false;
     }
    
    function pop_fn_popUpScr_nd(url,title, height, width) {

    	var posX = $('#modalReport_nd').offset().left - $(document).scrollLeft() - width + $('#modalReport_nd').outerWidth();
    	var posY = $('#modalReport_nd').offset().top - $(document).scrollTop() + $('#modalReport_nd').outerHeight();
//     	   $("#dialog").dialog({width:width, height:height ,position:[posX, posY]});
        $("#modalReport_Title_nd").text(title);
        $("#modalReport_nd").find(".modal-body").css("top", $('#modalReport_nd').scrollTop());
        $("#modalReport_nd").find(".modal-body").css("height", height);
    	$("#modalReport_nd").find(".modal-dialog").css("width", width);
		$("#modalReport_nd").attr("closeOnEscape", "false");
		$.ajax({
	    	type: "POST",
	    	url:  url , 
	 	 	beforeSend: function () { 
	            $("#ReportNote_nd").children().remove();
	   		},
	   	  	success: function (html) {
		   	  	$('#ReportNote_nd').html(html);
				$('#modalReport_nd').show();
				$('#btn_Canc').on("click",function(){
					$('#modalReport_nd').hide();
					
				});
	   	  	
	   	   	},
	   	 	error: function (xhr, option, error) {
	   	  	}
		});
		return false;
     }
    
    function pop_fn_CustName_View(caller,Custom_gubun) {
//     	var Custom_gubun = "B"; //발주:협력/외주업체
//     	var Custom_gubun = "O"; //주문고객사
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CustomView.jsp?Custom_gubun=" + Custom_gubun + "&caller="+caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "고객사코드 조회", '650px', '1360px');
		return false;
     }
    
    function pop_fn_PartList_View(caller) {
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeView.jsp?caller="+caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "원부자재코드 조회", '700px', "85%");
		return false;
     }
    
    function pop_fn_SeolbiList_View(caller) {
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/SeolbiCodeView.jsp?caller="+caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "설비코드 조회", '600px', "75%");
		return false;
     }
    
    function pop_fn_ProductName_View(caller) {
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProductViewHead.jsp?"
    							+ "caller=" + caller  + "&select_count=" + select_count;
    	pop_fn_popUpScr_nd(modalContentUrl, "제품코드 조회", '750px', '1460px');
		return false;
     }
    
    function pop_fn_UserList_View(caller, rowId) {
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/UserListView.jsp?caller=" + caller + "&rowId=" + rowId;
		
    	pop_fn_popUpScr_nd(modalContentUrl, "사용자 목록 조회("+ rowId +")", '600px', "75%");
		return false;
     }
    
     function pop_fn_NwStock_View(caller){
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/NwStockView3.jsp?caller=" + caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "현재고량 조회", '500px', '100%');
    	return false;
    } 
    
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
	    
		if(Baseline=='middle') y -= (line_height * (lineArray.length - 1) / 2) ;  // 수직 중간 맞춤을 위한 y좌표 조정
	    
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
    
	</script>

    <div id="popMainInfo_List_contents" style="clear:both;">
    </div>
<!-- 	         
1차 Pop Up 띄우는 DIV 시작
 -->
	<div class="modal collapse " role="dialog"  id="modalReport" style="width: 100%;height:100%; closeOnEscape:false; margin: 0 auto text-align:center; overflow-y:scroll; ">
		<div class="modal-dialog"  style="top:3px; width: 100%; margin: 0 auto text-align:center">
			<div class="modal-content panel panel-default" >
				<div class="modal-header panel-heading">
					<a type="button" class="close" data-dismiss="modal" onclick="$('#modalReport').hide()">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</a>
					<strong><span class="modal-title" id="modalReport_Title" ></span></strong>
				</div>
				<div class="modal-body panel-body" style="height:90%;">
					<div id="ReportNote" class="modal-body panel-body" >
					</div>
				</div>
			</div>
		</div>
	</div>	
<!-- 	         
1차 Pop Up 띄우는 DIV 끝
 -->	
 <!-- 	         
2차 Pop Up 위 Pop Up 띄우는 DIV 시작
 -->
    <div class="modal collapse " role="dialog"  id="modalReport_nd" style="width: 100%;height:100%; closeOnEscape:false; margin: 0 auto text-align:center; overflow-y:scroll; ">
		<div class="modal-dialog"  style="top:30px; width: 100%; margin: 0 auto text-align:center">
    		<div class="modal-content panel panel-default">
                <div class="modal-header panel-heading">
                    <a type="button" class="close" data-dismiss="modal" onclick="$('#modalReport_nd').hide()">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span></a>
                    	<strong><span class="modal-title" id="modalReport_Title_nd" ></span></strong>
                </div>
                <div class="modal-body panel-body" style="height: 50px">
					<div id="ReportNote_nd" class="modal-body panel-body"  style=" width: 100%;float:left">
					</div>
                </div>
			</div>
		</div>
    </div>		 
	
<!-- 	         
2차 Pop Up 위 Pop Up 띄우는 DIV 끝
 -->	
</body>
</html>