<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.FileReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	// Mysql_Menu UTLZ_XX 데이터 불러오기 
	/* Connection conn = null;
	String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
	System.out.println("jsonFilePath=" + jsonFilePath);
	   
	JSONParser parser = new JSONParser();
	Object obj = parser.parse(new FileReader(jsonFilePath));
	JSONObject jsonObject = (JSONObject) obj;
	   
	String use_intt_id ="";
	String JDBCStr = "";
	if(jsonObject.get("jdbc_mysql")== null) {
		System.out.println("Mysql 연동 안함");
	} else {
		String[] strColumnHeadE964    = { "use_intt_id" };
		DoyosaeTableModel TableModelE964 = new DoyosaeTableModel("M909S150100E964", strColumnHeadE964, "|");
		int RowCountE964 =TableModelE964.getRowCount();
	
		use_intt_id = TableModelE964.getValueAt(0,0).toString().trim();
	}
	*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString(); 

%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>      
    <script type="text/javascript">
    
	// 캐시 비적용
	<%-- <%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	%> --%>
    
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S150100E101 = {
			PID: "M909S150100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var bizNoCheck = false;
	var vSealImageFileName = "";
	var vLogoImageFileName = "";
	
	function SaveOderInfo() {
		
		var radio_hist = $(':input[name="txt_hist_yn"]:radio:checked').val();
		
		if ($('#txt_BizNo').val().length < 10) {
			alert("사업자등록번호를 정확히 입력하세요.\n[예:123-12-12345]");
			return;
		}
		if ($('#txt_Cust_nm').val().length < 1) {
			alert("회사 이름은 비워둘 수 없습니다.");
			return;
		}
		var dataJson = new Object(); // jSON Object 선언 
				dataJson.member_key = "<%=member_key%>";
				dataJson.BizNo = $('#txt_BizNo').val();
				dataJson.RevisionNo = $('#txt_RevisionNo').val();
				dataJson.Cust_nm = $('#txt_Cust_nm').val();
				dataJson.Juso = $('#txt_Juso').val();
				dataJson.TelNo = $('#txt_TelNo').val();
				dataJson.BossName = $('#txt_BossName').val();
				dataJson.Uptae = $('#txt_Uptae').val();
				dataJson.Jongmok = $('#txt_Jongmok').val();
				dataJson.Fax = $('#txt_Fax').val();
				dataJson.HomePage = $('#txt_HomePage').val();
				dataJson.Zipno = $('#txt_Zipno').val();
				dataJson.StartDate = $('#txt_StartDate').val();
				dataJson.user_id = "<%=loginID%>";
				dataJson.SealImageFileName = vSealImageFileName;
				dataJson.LogoImageFileName = vLogoImageFileName;
				<%-- dataJson.use_intt_id = "<%=use_intt_id%>"; --%>
				dataJson.haccp_no = $('#txt_haccp_No').val();
				dataJson.hist_yn = radio_hist;
				dataJson.kape_openapi_userid = $('#txt_kape_openapi_userid').val();
				dataJson.kape_openapi_apikey = $('#txt_kape_openapi_apikey').val();
		
		var chekrtn = confirm("등록하시겠습니까?"); 
				
		if(chekrtn){		

			SendTojsp(JSON.stringify(dataJson), M909S150100E101.PID); // 보내는 데이터묶음 하나일 때 => Object하나만
// 			SendTojsp(urlencode(params),M909S150100E101.PID);
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
// 	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		fn_image_file_upload(vSealImageFileName, 'form_SealImage') ;
		         	fn_image_file_upload(vLogoImageFileName, 'form_LogoImage') ;
		         	heneSwal.success('회사정보 등록에 성공하였습니다.'); 
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	error{
	        		heneSwal.error('회사정보 등록에 실패하였습니다.');
	        	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    
    $(document).ready(function () {
    	// 적용 시작일자(txt_StartDate) : datepicker설정 및 초기값(오늘날짜)세팅
       
    	new SetSingleDate2("", "#txt_StartDate", 0);
    	
        var today = new Date();
	    
      //직인 이미지 파일 칸에서 파일선택 클릭했을때, 사업자 등록번호 입력되었는지 체크
	    $("#SealImage").click(function(){
	    	// 파일선택 버튼 및 캔버스(이미지 미리보기) 초기화
	    	$(this).val(""); // 파일선택 value 초기화(같은이름 파일 올릴 때, onchange 이벤트 실행안되는거 방지) 
	    	var canvas = document.getElementById('SealImageFile');
			var context = canvas.getContext('2d');
	    	context.clearRect(0, 0, canvas.width, canvas.height);
	    	
	    	if($('#txt_BizNo').val().length < 3) {
	    		bizNoCheck = false; // 사업자등록 입력 안했을때, 파일 선택 방지
	    		$('#alertNote').html("사업자 등록번호를 입력하신 후 이미지 업로드를 해주세요.");
	   			$('#modalalert').show();
	   			return;
	    	} else {
	    		bizNoCheck = true; // 사업자등록 입력 했을때, 파일 선택 가능하게 함
	    	}	    
	    }); 

	    //직인 이미지 파일을 선택 했을때, 이벤트 정의
	    $("#SealImage").on('change',function(){
	    	if(bizNoCheck == false){ // 사업자등록 입력 안했을때, 이벤트 실행 안함
	   			$(this).val(""); // 파일선택 value 초기화(파일명 입력되는 현상 방지)
	   			return;
	    	} 
	    	
	    	// 선택파일 Validation Check 및  CompanyImageFileUpload.jsp 로 보낼 데이터(저장할 파일명) 설정
	    	var image_file_name = $(this).val(); // 선택한 파일명
	        if( image_file_name.indexOf(".") ) { // 파일명 검사(파일이 선택됐는지) 및  확장자 검사(이미지파일-jpg,jpeg,png,gif 맞는지)
	        	var aExt = image_file_name.split("."); // 파일명에서 확장자명 분리(aExt[1] : 파일 확장자)
	        	if( aExt[1]!='jpg' && aExt[1]!='JPG' && aExt[1]!='JPEG' && aExt[1]!='jpeg' 
	    			&& aExt[1]!='png' && aExt[1]!='PNG'  && aExt[1]!='gif' && aExt[1]!='GIF' ){
	        		alert("선택한 파일은 지원하지 않는 파일형식입니다." + "\n" + "jpg, jpeg, png, gif 형식의 파일을 선택하세요!!!");
	    	    	return;
	        	} else {
	        		vSealImageFileName = $('#txt_BizNo').val() + "_seal" + "." + aExt[1] ; // 실제로 저장할 파일명(사업자등록번호_직인)
	    	        var image_save_name = "temp" + "_seal" + "." + aExt[1] ; // 저장할 파일명(임시)
	        		fn_image_file_upload(image_save_name, 'form_SealImage', 'SealImageFile') ;
	        	}
	        }else {
	        	alert("등록할 이미지 파일을 선택하세요-!!");
		    	return;
	        }
	    }); // 직인 이미지 파일 이벤트 끝
	    
	    //회사 로고 이미지 파일 칸에서 파일선택 클릭했을때, 사업자 등록번호 입력되었는지 체크
	    $("#LogoImage").click(function(){
	    	// 파일선택 버튼 및 캔버스(이미지 미리보기) 초기화
	    	$(this).val(""); // 파일선택 value 초기화(같은이름 파일 올릴 때, onchange 이벤트 실행안되는거 방지) 
	    	var canvas = document.getElementById('LogoImageFile');
			var context = canvas.getContext('2d');
	    	context.clearRect(0, 0, canvas.width, canvas.height);
	    	
	    	if($('#txt_BizNo').val().length<3){
	    		bizNoCheck = false; // 사업자등록 입력 안했을때, 파일 선택 방지
	    		$('#alertNote').html("사업자 등록번호를 입력하신 후 이미지 업로드를 해주세요.");
	   			$('#modalalert').show();
	   			return;
	    	} else {
	    		bizNoCheck = true; // 사업자등록 입력 했을때, 파일 선택 가능하게 함
	    	}	    
	    }); 

	    //회사 로고 이미지 파일을 선택 했을때, 이벤트 정의
	    $("#LogoImage").on('change',function(){ 
	    	if(bizNoCheck == false){ // 사업자등록 입력 안했을때, 이벤트 실행 안함
	   			$(this).val(""); // 파일선택 value 초기화(파일명 입력되는 현상 방지)
	   			return;
	    	} 

	    	// 선택파일 Validation Check 및  CompanyImageFileUpload.jsp 로 보낼 데이터(저장할 파일명) 설정
	        var image_file_name = $(this).val(); // 선택한 파일명
	    	if( image_file_name.indexOf(".") != -1 ) { // 파일명 검사(파일이 선택됐는지)
	        	var aExt = image_file_name.split("."); // 파일명에서 확장자명 분리(aExt[1] : 파일 확장자)
	        	if( aExt[1]!='jpg' && aExt[1]!='JPG' && aExt[1]!='JPEG' && aExt[1]!='jpeg' 
	    			&& aExt[1]!='png' && aExt[1]!='PNG'  && aExt[1]!='gif' && aExt[1]!='GIF' ){ // 확장자 검사(이미지파일-jpg,jpeg,png,gif 맞는지)
	        		alert("선택한 파일은 지원하지 않는 파일형식입니다." + "\n" + "jpg, jpeg, png, gif 형식의 파일을 선택하세요!!!");
	    	    	return;
	        	} else {
	        		vLogoImageFileName = $('#txt_BizNo').val() + "_logo" + "." + aExt[1] ; // 실제로 저장할 파일명(사업자등록번호_로고)
	    	        var image_save_name = "temp" + "_logo" + "." + aExt[1] ; // 저장할 파일명(임시)
	        		fn_image_file_upload(image_save_name, 'form_LogoImage', 'LogoImageFile') ;
	        	}
	        }else {
	        	alert("등록할 이미지 파일을 선택하세요-!!");
		    	return;
	        }
	    }); // 회사 로고 이미지 파일 이벤트 끝
	    
    }); // $(document).ready 끝
    
	 // 미리보기 화면에 이미지파일 띄우기
    function fn_Set_Image_File(imageFile, canvasID){
		var canvas = document.getElementById(canvasID);
		var context = canvas.getContext('2d');
		var imgSrc = "<%=Config.this_SERVER_path%>/images/Company/"
					+ imageFile 
					+ "?v=" + Math.random() ; // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
		loadImages(imgSrc, context);
		function loadImages(ImgPage1, context) {
			  var images;
			  images = new Image();
			  images.onload = function() {
				  context.clearRect(0, 0, canvas.width, canvas.height);
				  context.drawImage(this, 0, 0, canvas.width, canvas.height);
			  };
			  images.onerror = function () {
			  };
			  images.src = ImgPage1;
		} 
    }
    
    
    
    function fn_image_file_upload(image_save_name, formID, canvasID) {
    	if(image_save_name == "") { // 파일명 없을때 실행안함
//     		alert(formID + "선택파일없음");
    		return;
    	}
    	
    	var form = $('#' + formID)[0]; // 파일선택 버튼이 속해있는 form
    	var data = new FormData(form);
    	data.append("fileName", image_save_name); // 보낼 데이터1(저장할 파일명)
    	
    	// ImageFileUpload.jsp 호출 (이미지파일을 서버폴더에 저장)
	    $.ajax({
			type: "POST",
	        enctype: "multipart/form-data",
	        url: "<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/CompanyImageFileUpload.jsp" , 
	        data: data,
	        processData: false,
	        contentType: false,
			cache: false,
	        timeout: 600000,	    	            
	        success: function (html) {
	        	// 화면에 저장한 이미지 미리보기로 띄움(canvasID가 있을때만 - 임시파일 저장할때만)
				if(html.length>0 && canvasID != undefined){
					<%-- var canvas = document.getElementById(canvasID);
					var context = canvas.getContext('2d');
					var imgSrc = "<%=Config.this_SERVER_path%>/images/Company/" 
								+ image_save_name
								+ "?v=" + Math.random(); // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
					loadImages(imgSrc, context);
					function loadImages(ImgPage1, context) {
						var images;
						images = new Image();
						images.onload = function() {
							context.clearRect(0, 0, canvas.width, canvas.height);
							context.drawImage(this, 0, 0, canvas.width, canvas.height);  //캔버스에 이미지 디스플레이
						};
						images.onerror = function () {
						};
						images.src = ImgPage1;
					}  --%>
					fn_Set_Image_File(image_save_name, canvasID);
                }
	        },
	        error: function (e) {
                console.log("ERROR : ", e);
	        }
	     });	
    }
	// 주소검색창 팝업
    function pop_add_search(obj) {
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S150106.jsp";
    	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText+"주소검색(S909S150106)", "1080px", "1080px");
     }
	// 검색주소 입력
    //var detail_address = "";
	
	function SetAddList_code(sido_name, sigungu_name, eupmyondong_name, 
			   				 road_name, building_main_no, building_sub_no, 
				   			 sigungu_building_name, detail_address, add_no, 
				   			 postcode){
    	
    	$("#txt_Juso").val(sido_name + " " + sigungu_name + " " + eupmyondong_name + " " +  
 			   road_name + " " + building_main_no + "-" + building_sub_no + " " +  
			   sigungu_building_name + " " + detail_address);
    }
    function SetPostcode(postcode){
 	$("#txt_Zipno").val(postcode);
 }

    
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    //document.getElementById("sample6_extraAddress").value = extraAddr;
                
                } else {
                    //document.getElementById("sample6_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('txt_Zipno').value = data.zonecode;
                document.getElementById("txt_Juso").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                //document.getElementById("sample6_detailAddress").focus();
            }
        }).open();
    }
    
    
    
    
    </script>
    
    <!-- 캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>
</head>
<body>
   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left; ">
   		<tr>
   			<td style="width: 30%">
	        <table class="table" style="width: 100%; margin: 0 auto; align:left">
	        	<tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	직인 이미지
		            </td>
		        </tr>
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	<canvas id="SealImageFile" width="300" height="300" style="border:1px solid #d3d3d3;" ></canvas>		            	
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style="width: 100%; font-weight: 900; font-size:14px; text-align:left">
		            <form id="form_SealImage" method="post" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/CompanyImageFileUpload.jsp">
						<input  type="file" id='SealImage' name="filename"  style="width:70%;float: left"/>
					</form>
		           	</td>
		        </tr>
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
						회사 로고 이미지
		            </td>
		        </tr>
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	<canvas id="LogoImageFile" width="300" height="100" style="border:1px solid #d3d3d3;" ></canvas>		            	
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style="width: 100%; font-weight: 900; font-size:14px; text-align:left">
		            <form id="form_LogoImage" method="post" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/CompanyImageFileUpload.jsp">
						<input  type="file" id='LogoImage' name="filename"  style="width:70%;float: left"/>
					</form>
		           	</td>
		        </tr>
		    </table>
        	</td>
        </tr>
        <tr>
   			<td style="width: 40%">
   				<table class="table" style="width: 100%; margin: 0 auto; align:left; ">
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">사업자등록번호</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_BizNo" style="width: 200px; float:left"  />&nbsp;&nbsp;
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">회사명</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Cust_nm" style="width: 200px; float:left"  />
           			</td>
        		</tr>
  				<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">주소</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Juso" style="width: 400px; float:left"readonly/>
           			&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="sample6_execDaumPostcode()" value="입력"></input></td>
        		</tr>
		         <tr style="background-color: #fff; height: 40px">
        		    <td style="font-weight:900;">우편번호</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Zipno" style="width: 200px; float:left" readonly />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">전화번호</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_TelNo" style="width: 200px; float:left"  />
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">대표자명</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_BossName" style="width: 200px; float:left"  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">업태</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Uptae" style="width: 200px; float:left"  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">종목</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Jongmok" style="width: 200px; float:left"  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">Fax</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_Fax" style="width: 200px; float:left"  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">Home Page</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_HomePage" style="width: 200px; float:left"  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">개정번호</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">적용시작일자</td>
            		<!-- <td> </td> -->
            		<td >
            			<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                			style="width: 220px; border: solid 1px #cccccc;"/>
           			</td>
        		</tr>
   				</table>
   			</td>
   			</tr>
   			<tr>
   			<td  style="width: 30%">
   			
   				<table class="table" style="width: 100%; margin: 0 auto; align:left; ">
   				
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">이력제 사용 여부</td>
            		<!-- <td> </td> -->
            		<td >
            			<input type="radio" id="txt_hist_yn" name="txt_hist_yn" value="Y" style="width: 60px;">사용</input>
			            <input type="radio" id="txt_hist_yn" name="txt_hist_yn" value="N" checked="checked" style="width: 60px;">사용안함</input>
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">HACCP인증번호</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_haccp_No" style="width: 200px; float:left"  />
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<!-- <td></td>
            		<td></td>
            		<td></td> -->
        		</tr>

		         <tr style="background-color: #fff; height: 40px">
        		    <td style="font-weight:900;">이력제 Open API 사용자 아이디</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_kape_openapi_userid" style="width: 200px; float:left"/>
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td style="font-weight:900;">이력제 Open API 서비스KEY</td>
            		<!-- <td> </td> -->
            		<td ><input type="text" class="form-control" id="txt_kape_openapi_apikey" style="width: 200px; float:left"  />
           			</td>
        		</tr>
   				</table>
   			</td>
   		</tr>
        <tr style="height: 60px">
            <td colspan="3" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
</body>
</html>