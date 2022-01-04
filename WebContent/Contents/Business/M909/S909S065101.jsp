<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);	

	String  GV_JSPPAGE="", GV_NUM_GUBUN="",
			GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="",
			GV_PROD_CD="", GV_PROD_CD_REV="", GV_PROD_NM="" ;
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("prod_nm")== null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
	
%>
    
    <script type="text/javascript">
	var M909S065100E101 = {
			PID:  "M909S065100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	var SQL_Param = {
			PID:  "M909S065100E101", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	};

	var vTableS909S065120;
	var TableS909S065120_info;
    var TableS909S065120_RowCount = 0;
    var S909S065120_Row_index = -1;    

	var vTableS909S065130;
    var S909S065130_Row_index = -1;
	var TableS909S065130_info;
    var TableS909S065130_RowCount = 0;

    $(document).ready(function () {
        $("#txt_prod_nm").val("<%=GV_PROD_NM%>");
        $("#txt_prod_cd").val("<%=GV_PROD_CD%>");
        $("#txt_prod_cd_rev").val("<%=GV_PROD_CD_REV%>");
        
		call_S909S065120();
        call_S909S065130();
    });	

    function call_S909S065120(){
    	$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065120.jsp", 
            data: "prod_cd=" +  "<%=GV_PROD_CD%>"  + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>" , 
	        beforeSend: function () {
	            $("#inspect_Request_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_Request_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }
    
    function call_S909S065130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065130.jsp", 
	        data: "prod_cd=" +  "<%=GV_PROD_CD%>"  + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>"+ "&caller=" + "S909S065101", 
	        beforeSend: function () {
	            $("#inspect_result_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_result_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }

	function fn_Update_body(obj){  	
    	if(S909S065120_Row_index == -1 && S909S065130_Row_index == -1) {
    		alert("등록 또는 수정할 문서를 선택하세요");
    	} else if(S909S065120_Row_index != -1 || S909S065130_Row_index != -1) { 
			if(S909S065120_Row_index != -1 && S909S065130_Row_index == -1) { //입력
    			vTableS909S065130.row.add( [
    				'ㅋ', //prod_doc_no : 채번
    				'0', //revision_no (default : 0)
	   		      	$("#txt_prod_cd").val(),
		   		    $("#txt_prod_cd_rev").val(),
		   		 	$("#txt_prod_nm").val(),
 					$('#txt_document_no').val(),
 					$('#txt_document_no_rev').val(),
 					$('#txt_document_name').val(),	
		   		    $('#txt_reg_gubun').val(),
		   		 	$('#txt_gubun_code_name').val(),
    				$('#txt_regist_no').val(),
    				$('#txt_regist_no_rev').val(),
    				$('#txt_file_view_name').val(),
    				$('#txt_file_real_name').val(),
    				'' //삭제버튼
    	        ] ).draw();
        		clear_input(obj); 
        		S909S065120_Row_index = -1;
//     			vTableS909S065120.rows().nodes().to$().attr("class", "hene-bg-color_w");
				TableS909S065130_RowCount = vTableS909S065130.rows().count();
    			call_S909S065120(); //입력 후 왼쪽테이블 refresh
    		} else if(S909S065120_Row_index == -1 && S909S065130_Row_index != -1) { //수정
    			vTableS909S065130.cell( S909S065130_Row_index, 0).data( $('#txt_prod_doc_no').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 1).data( $('#txt_revision_no').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 2).data( $('#txt_prod_cd').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 3).data( $('#txt_prod_cd_rev').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 4).data( $('#txt_prod_nm').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 5).data( $('#txt_document_no').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 6).data( $('#txt_document_no_rev').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 7).data( $('#txt_document_name').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 8).data( $('#txt_reg_gubun').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 9).data( $('#txt_gubun_code_name').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 10).data( $('#txt_regist_no').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 11).data( $('#txt_regist_no_rev').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 12).data( $('#txt_file_view_name').val() );
    			vTableS909S065130.cell( S909S065130_Row_index, 13).data( $('#txt_file_real_name').val() );
    			vTableS909S065130.draw();
        		clear_input(obj); 
        		S909S065130_Row_index = -1;
//     			vTableS909S065130.rows().nodes().to$().attr("class", "hene-bg-color_w");
    		}
    	}
    }  
	
	function clear_input(obj){
		$('#txt_prod_doc_no').val("");
		$('#txt_revision_no').val("");
// 		$("#txt_prod_nm").val("");
//      $("#txt_prod_cd").val("");
//      $("#txt_prod_cd_rev").val("");
        $('#txt_gubun_code_name').val("");
		$('#txt_reg_gubun').val("");
		$('#txt_regist_no').val("");
		$('#txt_regist_no_rev').val("");
		$('#txt_file_view_name').val("");
		$('#txt_file_real_name').val("");
		$('#txt_document_name').val("");
		$('#txt_document_no').val("");
		$('#txt_document_no_rev').val("");
	}
	
	function fn_mius_body(obj){
		vTableS909S065130.row($(obj).parents('tr')).remove().draw();

	    TableS909S065130_info = vTableS909S065130.page.info();
	    TableS909S065130_RowCount = TableS909S065130_info.recordsTotal;
	    
	    call_S909S065120(); //삭제 후 왼쪽테이블 refresh
    }       
	
	function fn_btn_plus_all_body(obj){  	
		TableS909S065120_info = vTableS909S065120.page.info();
        TableS909S065120_RowCount = TableS909S065120_info.recordsTotal;
        
        for(var i=0; i<TableS909S065120_RowCount; i++) {
        	if(vTableS909S065120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked")) {
        		vTableS909S065130.row.add( [
        			'ㅋ', //prod_doc_no : 채번
    				'0', //revision_no (default : 0)
	   		      	$("#txt_prod_cd").val(),
		   		    $("#txt_prod_cd_rev").val(),
		   		 	$("#txt_prod_nm").val(),
		   		 	vTableS909S065120.cell(i, 2).data(), // document_no
 					vTableS909S065120.cell(i, 3).data(), // document_no_rev
 					vTableS909S065120.cell(i, 4).data(), // document_name
 					vTableS909S065120.cell(i, 1).data(), // reg_gubun
 					vTableS909S065120.cell(i, 6).data(), // gubun_code_name
 					vTableS909S065120.cell(i, 9).data(), // regist_no
 					vTableS909S065120.cell(i, 10).data(), // regist_no_rev
 					vTableS909S065120.cell(i, 7).data(), // file_view_name
 					vTableS909S065120.cell(i, 8).data(), // file_real_name
    				'' //삭제버튼
    	        ] );
        	}
        }
        vTableS909S065130.draw();
        
        TableS909S065130_RowCount = vTableS909S065130.rows().count();
        call_S909S065120(); //전체입력 후 왼쪽테이블 refresh
    }  
	
	function SaveOderInfo() {        
		TableS909S065130_info = vTableS909S065130.page.info();
        TableS909S065130_RowCount = TableS909S065130_info.recordsTotal;
        
        var jArray = new Array(); // JSON Array 선언

	    for(var i=0; i<TableS909S065130_RowCount; i++){
	    	var dataJson = new Object(); // jSON Object 선언 
	    	dataJson.member_key = "<%=member_key%>";
        	dataJson.jsp_page = '<%=GV_JSPPAGE%>';
        	dataJson.user_id = '<%=loginID%>';
        	dataJson.prefix = '<%=GV_NUM_GUBUN%>';
        	dataJson.detail_seq = '1';
	    	dataJson.prod_doc_no = vTableS909S065130.cell(i , 0).data();	//prod_doc_no 
	    	dataJson.revision_no = vTableS909S065130.cell(i , 1).data();	//revision_no
	    	dataJson.prod_cd = vTableS909S065130.cell(i , 2).data(); 	//prod_cd
	    	dataJson.prod_cd_rev = vTableS909S065130.cell(i , 3).data(); 	//prod_cd_rev
	    	dataJson.document_no = vTableS909S065130.cell(i , 5).data(); 	//document_no
	    	dataJson.document_no_rev = vTableS909S065130.cell(i , 6).data(); 	//document_no_rev
	    	dataJson.reg_gubun = vTableS909S065130.cell(i , 8).data(); 	//reg_gubun
	    	dataJson.regist_no = vTableS909S065130.cell(i , 10).data(); 	//regist_no
	    	dataJson.regist_no_rev = vTableS909S065130.cell(i , 11).data();	//regist_no_rev				
	    	dataJson.file_view_name = vTableS909S065130.cell(i , 12).data();	//file_view_name
	    	dataJson.file_real_name = vTableS909S065130.cell(i , 13).data();	//file_real_name

	    	
	    	jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
	    
// 		SQL_Param.params = parmHead + parmBody;
		
//  	SendTojsp(urlencode(SQL_Param.params),SQL_Param.PID);

		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)

		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
		
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		 parent.DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제품명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="hidden" class="form-control" id="txt_prod_doc_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_revision_no" readonly></input>
            	<input type="text" class="form-control" id="txt_prod_nm" readonly></input>
            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly></input>
				<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly></input>
            </td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">문서명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_document_name" readonly></input>
            	<input type="hidden" class="form-control" id="txt_document_no" readonly></input>
				<input type="hidden" class="form-control" id="txt_document_no_rev" readonly></input>
            </td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">문서구분</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_gubun_code_name" readonly></input>
            	<input type="hidden" class="form-control" id="txt_reg_gubun" readonly></input>
			</td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">등록번호</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_regist_no" readonly></input>
				<input type="hidden" class="form-control" id="txt_regist_no_rev" readonly></input>
			</td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">파일명</td>
            <td style="width: 33.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
            	<input type="text" class="form-control" id="txt_file_view_name" readonly></input>
				<input type="hidden" class="form-control" id="txt_file_real_name" readonly></input>
			</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<button id="btn_plus" class="form-control btn btn-info" onclick="fn_Update_body(this)">입력</button>
            </td>
        </tr>
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_Request_body" style="width:40%; float:left"></div>
		<div style="width:6%;  height:330px; vertical-align: middle ;float:left">
			<label style="height:100px;"></label>
	        <button id="btn_plus_all" class="form-control btn btn-info" onclick="fn_btn_plus_all_body(this);">>></button>
		</div>
		<div id="inspect_result_body" style="width:54%; float:left"></div>
	</div>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="$('#modalReport').modal('hide');">취소</button>
        </p>
	</div>
	