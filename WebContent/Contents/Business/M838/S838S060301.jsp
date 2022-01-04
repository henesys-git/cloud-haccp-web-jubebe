﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	DoyosaeTableModel TableModel;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	StringBuffer html = new StringBuffer();
	
	String[] as_division = {"기본 서류평가","기본 서류평가","기본 서류평가","기본 서류평가","기본 서류평가","시설, 주변환경 및 작업장 외부","시설, 주변환경 및 작업장 외부","시설, 주변환경 및 작업장 외부","시설, 주변환경 및 작업장 외부",
							"시설, 주변환경 및 작업장 외부","시설, 주변환경 및 작업장 외부","시설, 주변환경 및 작업장 외부","작업장 내부","작업장 내부","작업장 내부","작업장 내부","작업장 내부","작업장 내부","작업장 내부","작업장 내부",
							"작업장 내부","작업장 내부","작업장 내부","창고","창고","창고","창고","제품관리","제품관리","제품관리","제품관리","입고검사","납기준수","협조도","협조도"};
	String[] as_article = {"영업허가증","품목제조보고서","법적 서류구비","공급업체 과거실적","사업자등록증","화장실","외벽","폐기물관리","작업장 위치","진입로","창고","탈의실","내벽","환기","바닥","문","창","천장","채광 및 조명",
						   "방충, 방서","청소도구","이격보관","폐기물관리","냉동, 냉장창고","구분관리","내포장재","이격보관","제품보관","선입선출","표기사항","보관방법","합격률","납기의 신뢰도","차량위생상태","협조도"};
	String[] as_standard = {"평가기준","영업허가증","제조보고 서류비치","수입검사필증, 원산지 증명서 서류비치","거래명세표","사업자등록증 비치","청결상태, 환기설비구비, 손소독 실시여부","청결 및 적정유지보수","청결유지 및 외부차단성",
							"오염발생원과 일정거리 이격","먼지발생방지","원부자재 및 완제품용 창고보유여부","작업복 보관함 보유 여부","청결유지, 적정유지보수","매연, 악취, 증기등의 환기상태","물고임 상태 및 청결유지","밀폐성, 청결유지",
							"밀폐성, 청결유지","응축수 발생여부, 청결유지","조명보호구 설치 여부, 적정 밝기 유지","방충 및 방서 관리상태","일정장소 보관, 청결관리 여부","바닥, 벽과 이격보관","폐기물 전용용기 사용, 주기적 반출여부",
							"보관품 특성별 적정 온도관리, 청결유지","부적함품과 별도 구분관리","오염방지를 위한 밀봉 구분관리","보관품의 바닥, 벽과 이격보관","처음 보관상태는 적절한가","선입선출여부","표기사항은 적절한가",
							"보관품 특성별 적정 온도관리","입고검사서 합격률","납기일 준수여부","차량 내, 외부 청결도, 차량온도","노력의 정도, 거래처의 능력, 잠재성"};
	int[] as_standard_value = {5,5,5,5,5,3,5,5,5,5,5,3,5,6,6,6,6,5,3,6,5,5,2,10,5,5,3,7,7,5,7,10,10,10,10};
	String[] as_result = {};
	String[] as_bigo = {};
	for(int i = 0; i<as_standard_value.length; i++){
		html.append( "fn_plus_body();\n" );
		html.append(" var trInput = $($('#product_tbody tr')["+ i +"]).find(':input');\n");
		html.append(" trInput.eq(1).val('0');\n");
		html.append(" trInput.eq(2).val('"+ as_division[i] +"');\n");
		html.append(" trInput.eq(3).val('"+ as_article[i] +"');\n");
		html.append(" trInput.eq(4).val('"+ as_standard[i] +"');\n");
		html.append(" trInput.eq(6).val('"+ as_standard_value[i] +"');\n");
	}
%>    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M838S060300E101 = {
			PID:  "M838S060300E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M838S060300E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	var vOrderNo101 = "";
    var detail_seq=1;
	var vproduct_input_table;
    var vproduct_input_table_Row_index = -1;
	var vproduct_input_table_info;
    var vproduct_input_table_RowCount=0;

    $(document).ready(function () {
    	detail_seq=1;

	    vproduct_input_table = $('#product_input_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:3%;'); 
		       		}
				},
		    	{
		       		'targets': [4],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,5,6], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:15%;'); 
		       		}
				},
 		    	{
		       		'targets': [1,7],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
				} 

            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	
    	// 날짜용
        
        new SetSingleDate2("","#txt_assessment_date",0);
        new SetSingleDate2("","#txt_write_date",0);
        new SetSingleDate2("","#txt_check_date",0);
        new SetSingleDate2("","#txt_approve_date",0);
        
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        today.setDate(today.getDate()+180);

	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
	    <%=html%>
	    null_chk();
    });
    
    function select_product(obj){
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    	
    	vproduct_input_table_Row_index = vproduct_input_table
        .row( trNum )
        .index();
// 	alert(vproduct_input_table_Row_index);
    }
	
	function SetRecvData(){
		DataPars(M838S060300E101,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
   		$('#modalReport').modal('hide');
	}
	
	function SaveOderInfo() {
		
		
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		if($('#txt_projrctName').val()=='') { 
			alert("주문명을 입력하여 주세요");
			return false;
		}
		
		if($("#txt_custname").val()=='') { 
			alert("고객사를 검색하여 선택하세요");
			return false;
		}

		
        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal; 	

		var jArray = new Array(); // JSON Array 선언
		
   		if($('#txt_subcontractor_no').val()== '' ) { 
   			alert("협력업체를 입력하여 주세요");
   			return false;
   		}
   		if($('#txt_inspector').val()== '' ) { 
   			alert("점검자를 입력하여 주세요");
   			return false;
   		}
   		if($('#txt_writor_rev').val()== '' ) { 
   			alert("작성자를 입력하여 주세요");
   			return false;
   		}    		
   		if($('#txt_checker').val()== '' ) { 
   			alert("검토자를 입력하여 주세요");
   			return false;
   		}
   		if($('#txt_approval').val()== '' ) { 
   			alert("승인자를 입력하여 주세요");
   			return false;
   		}
   		if($('#txt_uptae').val()== '' ) { 
   			alert("업태를 입력하여 주세요");
   			return false;
   		}
   		
   		var dataJson = new Object(); // jSON Object 선언
   		dataJson.subcontractor_no    = $('#txt_subcontractor_no').val();
   		dataJson.subcontractor_rev   = $('#txt_subcontractor_rev').val();
   		dataJson.subcontractor_seq   = $('#txt_subcontractor_seq').val();
   		dataJson.subcontractor_name  = $('#txt_subcontractor_name').val();
   		dataJson.inspector           = $('#txt_inspector').val();
   		dataJson.inspector_rev       = $('#txt_inspector_rev').val();
   		dataJson.uptae               = $('#txt_uptae').val();
   		dataJson.assessment_date     = $('#txt_assessment_date').val();
   		dataJson.writor              = $('#txt_writor').val();
   		dataJson.writor_rev          = $('#txt_writor_rev').val();
   		dataJson.write_date          = $('#txt_write_date').val();
   		dataJson.checker             = $('#txt_checker').val();
   		dataJson.checker_rev         = $('#txt_checker_rev').val();
   		dataJson.check_date          = $('#txt_check_date').val();
   		dataJson.approval            = $('#txt_approval').val();
   		dataJson.approval_rev        = $('#txt_approval_rev').val();
   		dataJson.approve_date        = $('#txt_approve_date').val();    		
		dataJson.member_key = "<%=member_key%>";
			
		var jsonArray = new Array();
        for(var i=0; i<vproduct_input_table_RowCount; i++){
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    		
    		var jsonAssessment = new Object(); // jSON Object 선언    	
        	jsonAssessment.assessment_no       = i;
        	jsonAssessment.assessment_rev      = trInput.eq(1).val();
    		jsonAssessment.assessment_division = trInput.eq(2).val();
    		jsonAssessment.assessment_article  = trInput.eq(3).val();
    		jsonAssessment.assessment_standard = trInput.eq(4).val();
    		jsonAssessment.assessment_result   = trInput.eq(5).val();
    		jsonAssessment.assessment_bigo     = trInput.eq(7).val();
    		jsonArray.push(jsonAssessment);
        }
        dataJson.assessment = jsonArray;

        var work_complete_insert_check = confirm("등록하시겠습니까?");
        if(work_complete_insert_check == false)   return;
        
        var JSONparam = JSON.stringify(dataJson);
//	        console.log(JSONparam);
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
	function SendTojsp(bomdata, pid){	
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){	         
	        		 parent.fn_MainInfo_List();
	 	             parent.$("#ReportNote").children().remove();
	 	            $('#modalReport').modal('hide');
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetUser_Select(user_id, revision_no, user_nm){
 //   	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
		$("#"+ rowId).val(user_nm);
		$("#"+ rowId + "_rev").val(revision_no);
	}
	function SetCustName_code(name, code, rev){
		$('#txt_subcontractor_name').val(name);
		$('#txt_subcontractor_no').val(code);
		$('#txt_subcontractor_rev').val(rev);
	}
    
    function fn_plus_body(){
    	vproduct_input_table.row.add( [
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_no"+vproduct_input_table_RowCount+"' value='" + vproduct_input_table_RowCount + "' readonly></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_rev"+vproduct_input_table_RowCount+"' style='display:none;' value='0'></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_division"+vproduct_input_table_RowCount+"' ></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_article"+vproduct_input_table_RowCount+"' ></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_standard"+vproduct_input_table_RowCount+"' ></input>",
    		"	<input type='text' class='form-control' style='width: 80%; float: left;' id='txt_assessment_result"+vproduct_input_table_RowCount+"' numberOnly></input>" + 
    		"	<input type='text' class='form-control' style='width: 20%;' id='txt_assessment_result_standard"+vproduct_input_table_RowCount+"' readonly></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_bigo"+vproduct_input_table_RowCount+"' '></input>",
    		""
        ] ).draw();
	    
        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal; 	
        
    }
    
    function fn_mius_body(){
        vproduct_input_table
        .row( vproduct_input_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal;
    }   

	// input 필드 null 여부 체크 
    function null_chk(){
/* 		// 사용할 null_chk 필드아이디 추가할것
		var chk = ["#txt_subcontractor_no", "#txt_subcontractor_name", "#txt_uptae"];
		var null_chk = ["#subcontractor_no_null_chk", "#subcontractor_name_null_chk", "#uptae_null_chk"];
		for(i = 0; i<chk.length; i++){
			var chk_val = chk[i].val();
			var null_chk_val = null_chk[i].val();
			
			if($(chk_val).val() == ''){
				$($("nullchk" + i)).val(" ✘");	
		    	$($("nullchk" + i)).css("background-color", "tomato");	
			} else {
	        	$($("nullchk" + i)).val(" ✔");
		        $($("nullchk" + i)).css("background-color", "lightgreen");	
			}    
		    $(chk_val).change(function(){	    	
		        if($(chk_val).val() != ''){	        	
		        	$($("nullchk" + i)).val(" ✔");
			        $($("nullchk" + i)).css("background-color", "lightgreen");	
		        } else {
		        	$($("nullchk" + i)).val(" ✘");
		        	$($("nullchk" + i)).css("background-color", "tomato");	
		        }	    	
		    });
		} */
	    
		var chk1 = "#txt_uptae";
		var null_chk1 = '#uptae_null_chk';
		if($(chk1).val() == ''){
			$(null_chk1).val(" ✘");	
	    	$(null_chk1).css("background-color", "tomato");	
		} else {
        	$(null_chk1).val(" ✔");
	        $(null_chk1).css("background-color", "lightgreen");	
		}	 	    
	    $(chk1).change(function(){	    	
	        if($(chk1).val() != ''){	        	
	        	$(null_chk1).val(" ✔");
		        $(null_chk1).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk1).val(" ✘");
	        	$(null_chk1).css("background-color", "tomato");	
	        }	    	
	    });
	}

    </script>

   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table " style="width: 100%; margin: 0 auto; align:left">
		        <tr class="subcontractor" style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >협력업체 등록번호</td>
		            <td colspan="3">
		            	<input type="text" id="txt_subcontractor_no" class="form-control" style="width: 400px; border: solid 1px #cccccc; float: left;" readonly/>
		            	<input type="text" id="txt_subcontractor_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;"/>
		            	<input type="text" id="txt_subcontractor_seq" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" />
		            	&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_CustName_View(1,'I');" value="검색"></input>
		            </td>		          
		            <td style=" font-weight: 900; font-size:14px; text-align:left">협력업체명</td>
		            <td colspan="3"> 
		            	<input type="text" id="txt_subcontractor_name" class="form-control" style="width: 400px; border: solid 1px #cccccc; float: left;" readonly/>				
		            </td>
		        </tr>

		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >점검자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_inspector" style="width: 400px; float:left" readonly />
						<input type="text" class="form-control" id="txt_inspector_rev" style="width: 400px; float:left; display:none;" readonly />				
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_inspector')" value="입력"></input></td>		           	
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >점검일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_assessment_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_writor" style="width: 400px; float:left" readonly />
						<input type="text" class="form-control" id="txt_writor_rev" style="width: 400px; float:left; display:none;" readonly />				
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_writor')" value="입력"></input></td>		           	
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_write_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_checker" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_checker_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_checker')" value="입력"></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_check_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인자</td>
		            					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_approval" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_approval_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_approval')" value="입력"></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_approve_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
		        <tr>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >업태</td>
		            <td colspan="3">
		            	<input type="text" id="txt_uptae" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" />		            	        
		            	<input type="text" id="uptae_null_chk" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
		            </td>
<!--   		        <td style=" font-weight: 900; font-size:14px; text-align:left" >협력업체 등록번호</td>
		            <td colspan="3">
		            	<input type="text" id="txt_subcontractor_no" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" />        
		            	<input type="text" id="subcontractor_no_null_chk" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
		            </td> -->
		        </tr>

        	</table>
        	<!-- 검사항목 -->
        	<table class="table " id="product_input_table" style="width: 100%; margin: 0 auto; align:left">
				<thead>
			        <tr style="vertical-align: middle">
			            <th style="width: 3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
			            <th style="width: 3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">점검rev</th>
			            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">분류</th>
			            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">항목</th>
			            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">기준</th>
			            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">평가결과 / 배점</th>
			            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
			            <th style="width: 7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" disabled>+</button>
		                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" disabled>-</button></th>
			        </tr>
				</thead>
		        <tbody id="product_tbody">
		        </tbody>
		    </table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
