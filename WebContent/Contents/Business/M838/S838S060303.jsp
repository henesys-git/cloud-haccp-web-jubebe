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

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "", GV_SUBCONSTRACTOR_SEQ = "";
	
	if(request.getParameter("SubcontractorNo")== null)
		GV_SUBCONSTRACTOR_NO ="";
	else
		GV_SUBCONSTRACTOR_NO = request.getParameter("SubcontractorNo");
	
	if(request.getParameter("SubcontractorRev")== null)
		GV_SUBCONSTRACTOR_REV ="";
	else
		GV_SUBCONSTRACTOR_REV = request.getParameter("SubcontractorRev");
	
	if(request.getParameter("SubcontractorSeq")== null)
		GV_SUBCONSTRACTOR_SEQ ="";
	else
		GV_SUBCONSTRACTOR_SEQ = request.getParameter("SubcontractorSeq");
	
	int[] as_standard_value = {5,5,5,5,5,3,5,5,5,5,5,3,5,6,6,6,6,5,3,6,5,5,2,10,5,5,3,7,7,5,7,10,10,10,10};
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONSTRACTOR_SEQ);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S060300E124", jArray);
    
 	int RowCount = TableModel.getRowCount();
	StringBuffer html = new StringBuffer();
 	
	if(RowCount>0){
		html.append("$('#txt_subcontractor_no').val('" 	+ TableModel.getValueAt(0,0).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_rev').val('" 	+ TableModel.getValueAt(0,1).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_seq').val('" 	+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_name').val('" 	+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
		html.append("$('#txt_inspector').val('" 	+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
		html.append("$('#txt_inspector_rev').val('" 	+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
		html.append("$('#txt_assessment_date').val('" 	+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
		html.append("$('#txt_writor').val('" 	+ TableModel.getValueAt(0,15).toString().trim() + "');\n");
		html.append("$('#txt_writor_rev').val('" 	+ TableModel.getValueAt(0,16).toString().trim() + "');\n");
		html.append("$('#txt_write_date').val('" 	+ TableModel.getValueAt(0,17).toString().trim() + "');\n");
		html.append("$('#txt_checker').val('" 	+ TableModel.getValueAt(0,18).toString().trim() + "');\n");
		html.append("$('#txt_checker_rev').val('" 	+ TableModel.getValueAt(0,19).toString().trim() + "');\n");
		html.append("$('#txt_check_date').val('" 	+ TableModel.getValueAt(0,20).toString().trim() + "');\n");
		html.append("$('#txt_approval').val('" 	+ TableModel.getValueAt(0,21).toString().trim() + "');\n");
		html.append("$('#txt_approval_rev').val('" 	+ TableModel.getValueAt(0,22).toString().trim() + "');\n");
		html.append("$('#txt_approve_date').val('" 	+ TableModel.getValueAt(0,23).toString().trim() + "');\n");
		html.append("$('#txt_uptae').val('" 	+ TableModel.getValueAt(0,6).toString().trim() + "');\n");
		for(int i=0; i<RowCount; i++){			
			html.append( "fn_plus_body();\n" );
			html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(1).val('" + TableModel.getValueAt(i,8).toString().trim() + "');\n");
			html.append(" trInput.eq(2).val('" + TableModel.getValueAt(i,10).toString().trim() + "');\n");
			html.append(" trInput.eq(3).val('" + TableModel.getValueAt(i,11).toString().trim() + "');\n");
			html.append(" trInput.eq(4).val('" + TableModel.getValueAt(i,12).toString().trim() + "');\n");
			html.append(" trInput.eq(5).val('" + TableModel.getValueAt(i,13).toString().trim() + "');\n");
			html.append(" trInput.eq(6).val('"+ as_standard_value[i] +"');\n");
			html.append(" trInput.eq(7).val('" + TableModel.getValueAt(i,14).toString().trim() + "');\n");
		}
	}
%>    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M838S060300E103 = {
			PID:  "M838S060300E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M838S060300E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	var vOrderNo102 = "";
    var detail_seq=1;
	var vproduct_delete_table;
    var vproduct_delete_table_Row_index = -1;
	var vproduct_delete_table_info;
    var vproduct_delete_table_RowCount=0;

    $(document).ready(function () {
    	detail_seq=1;

	    vproduct_delete_table = $('#product_delete_table').DataTable({
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
    	
    	vproduct_delete_table_Row_index = vproduct_delete_table
        .row( trNum )
        .index();
// 	alert(vproduct_delete_table_Row_index);
    }
	
	function SetRecvData(){
		DataPars(M838S060300E103,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
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

		
        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 	

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
        for(var i=0; i<vproduct_delete_table_RowCount; i++){
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    		
    		var jsonAssessment = new Object(); // jSON Object 선언    		
        	jsonAssessment.assessment_no       = i;
        	jsonAssessment.exist_rev 		   = trInput.eq(1).val();
        	jsonAssessment.assessment_rev 	   = jsonAssessment.exist_rev +1;
    		jsonAssessment.assessment_division = trInput.eq(2).val();
    		jsonAssessment.assessment_article  = trInput.eq(3).val();
    		jsonAssessment.assessment_standard = trInput.eq(4).val();
    		jsonAssessment.assessment_result   = trInput.eq(5).val();
    		jsonAssessment.assessment_bigo     = trInput.eq(7).val();
    		jsonArray.push(jsonAssessment);
        }
        dataJson.assessment = jsonArray;
        
        var work_complete_delete_check = confirm("삭제하시겠습니까?");
        if(work_complete_delete_check == false)   return;
        
        var JSONparam = JSON.stringify(dataJson);
//        console.log(JSONparam);
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
	        		 parent.fn_DetailInfo_List();
	 	             parent.$("#ReportNote").children().remove();
	 	         	 parent.$('#modalReport').hide();
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
    
    function SetCustName_code(name, code, rev){
    	console.log(name + "~" + code + "~" + rev);
		$('#txt_subcontractor_name').val(name);
		$('#txt_subcontractor_no').val(code);
		$('#txt_subcontractor_rev').val(rev);
    }
    // 사용자선택
    function SetUser_Select(user_id, revision_no, user_nm){
    	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
		$("#"+ rowId).val(user_nm);
		$("#"+ rowId + "_rev").val(revision_no);
	}
    
    function fn_plus_body(){
    	vproduct_delete_table.row.add( [
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_no"+vproduct_delete_table_RowCount+"' value='" + vproduct_delete_table_RowCount + "' readonly></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_rev"+vproduct_delete_table_RowCount+"' style='display:none;' value='0'></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_division"+vproduct_delete_table_RowCount+"' disabled></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_article"+vproduct_delete_table_RowCount+"' disabled></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_standard"+vproduct_delete_table_RowCount+"' disabled></input>",
    		"	<input type='text' class='form-control' style='width: 80%; float: left;' id='txt_assessment_result"+vproduct_delete_table_RowCount+"' numberOnly></input>" + 
    		"	<input type='text' class='form-control' style='width: 20%;' id='txt_assessment_result_standard"+vproduct_delete_table_RowCount+"' readonly></input>",
    		"	<input type='text' class='form-control' style='width: 100%;' id='txt_assessment_bigo"+vproduct_delete_table_RowCount+"' ' disabled></input>",
    		""
        ] ).draw();
	    
        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 	
        
    }
    
    function fn_mius_body(){
        vproduct_delete_table
        .row( vproduct_delete_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal;
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
		            	&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_CustName_View(1,'I');" value="검색" disabled></input>
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
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_inspector')" value="입력" disabled></input></td>		           	
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >점검일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_assessment_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_writor" style="width: 400px; float:left" readonly />
						<input type="text" class="form-control" id="txt_writor_rev" style="width: 400px; float:left; display:none;" readonly />				
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_writor')" value="입력" disabled></input></td>		           	
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_write_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_checker" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_checker_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_checker')" value="입력" disabled></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_check_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
		        </tr>
		       <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인자</td>
		            					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_approval" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_approval_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_approval')" value="입력" disabled></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_approve_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
		        </tr>
		        <tr>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >업태</td>
		            <td colspan="3">
		            	<input type="text" id="txt_uptae" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" disabled />		            	        
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
        	<table class="table " id="product_delete_table" style="width: 100%; margin: 0 auto; align:left">
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
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
