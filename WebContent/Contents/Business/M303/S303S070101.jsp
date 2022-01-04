<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);	

	String  GV_JSPPAGE="", GV_NUM_GUBUN="",
			GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="",GV_LOTNO="";
	
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
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
%>
    
    <script type="text/javascript">
	var M303S070100E101 = {
			PID:  "M303S070100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	var SQL_Param = {
			PID:  "M303S070100E101", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	};

	var vTableS303S070120;
	var TableS303S070120_info;
    var TableS303S070120_RowCount = 0;
    var S303S070120_Row_index = -1;    

	var vTableS303S070130;
    var S303S070130_Row_index = -1;
	var TableS303S070130_info;
    var TableS303S070130_RowCount = 0;

    $(document).ready(function () {
    	$("#txt_bulchul_date").datepicker({
    		format: 'yyyy-mm-dd',
    		autoclose: true,
    		language: 'ko'
    	});
    	var today = new Date();
    	$('#txt_bulchul_date').datepicker('update', today);
        
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_order_detail_seq").val("<%=GV_ORDER_DETAIL_SEQ%>");
        $("#txt_lotno").val("<%=GV_LOTNO%>");
        
		call_S303S070120();
        call_S303S070130();
    });	

    function call_S303S070120(){
    	$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S070120.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' 
	        		+ "&lotno=" + '<%=GV_LOTNO%>', 
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
    
    function call_S303S070130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S070130.jsp", 
	        data: "order_no=" +  "<%=GV_ORDERNO%>"  + "&order_detail_seq=" + "<%=GV_ORDER_DETAIL_SEQ%>"+ "&caller=" + "S303S070101"
	        		+ "&lotno=" + '<%=GV_LOTNO%>', 
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
    	if(S303S070120_Row_index == -1 && S303S070130_Row_index == -1) {
    		alert("불출요청 또는 수정할 원부자재을 선택하세요");
    	} else if(S303S070120_Row_index != -1 || S303S070130_Row_index != -1) { 
			if(S303S070120_Row_index != -1 && S303S070130_Row_index == -1) { //입력
    			vTableS303S070130.row.add( [
    				$("#txt_order_no").val(),
//     		    	$("#txt_order_detail_seq").val(),
    		    	$("#txt_lotno").val(),
    				'', // bulchul_req_no(채번 : 빈값)
    				$('#txt_part_cd').val(),
    				$('#txt_part_cd_rev').val(),
    				$('#txt_part_nm').val(),
    				$('#txt_req_date').val(),
    				$('#txt_dept_code').val(),
    				$('#txt_dept_code option:selected').text(), //code_name(부서명)
    				$('#txt_yongdo').val(),
    				$('#txt_gubun').val(),
    				$('#txt_req_count').val(),
    				$('#txt_unit').val(),
    				$('#txt_bigo').val(),
    				$('#txt_bulchul_date').val(),
        			'<%=loginID%>', // req_userid
    				$('#txt_reciept_userid').val(),
        			'<%=loginID%>', // damdanja
    				'' //삭제버튼
    	        ] ).draw();
        		clear_input(obj); 
        		S303S070120_Row_index = -1;
//     			vTableS303S070120.rows().nodes().to$().attr("class", "hene-bg-color_w");
				TableS303S070130_RowCount = vTableS303S070130.rows().count();
    			call_S303S070120(); //입력 후 왼쪽테이블 refresh
    		} else if(S303S070120_Row_index == -1 && S303S070130_Row_index != -1) { //수정
    			vTableS303S070130.cell( S303S070130_Row_index, 0).data( $('#txt_order_no').val() );
//     			vTableS303S070130.cell( S303S070130_Row_index, 1).data( $('#txt_order_detail_seq').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 1).data( $('#txt_lotno').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 2).data( $('#txt_bulchul_req_no').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 3).data( $('#txt_part_cd').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 4).data( $('#txt_part_cd_rev').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 5).data( $('#txt_part_nm').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 6).data( $('#txt_req_date').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 7).data( $('#txt_dept_code').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 8).data( $('#txt_dept_code option:selected').text() ); //code_name(부서명)
    			vTableS303S070130.cell( S303S070130_Row_index, 9).data( $('#txt_yongdo').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 10).data( $('#txt_gubun').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 11).data( $('#txt_req_count').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 12).data( $('#txt_unit').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 13).data( $('#txt_bigo').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 14).data( $('#txt_bulchul_date').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 15).data( '<%=loginID%>' ); // req_userid
    			vTableS303S070130.cell( S303S070130_Row_index, 16).data( $('#txt_reciept_userid').val() );
    			vTableS303S070130.cell( S303S070130_Row_index, 17).data( '<%=loginID%>' ); // damdanja
    			vTableS303S070130.draw();
        		clear_input(obj); 
        		S303S070130_Row_index = -1;
//     			vTableS303S070130.rows().nodes().to$().attr("class", "hene-bg-color_w");
    		}
    	}
    }  
	
	function clear_input(obj){
// 		$("#txt_order_no").val("");
//      $("#txt_order_detail_seq").val("");
//      $('#txt_bulchul_req_no').val("");
     	$('#txt_part_cd').val("");
     	$('#txt_part_cd_rev').val("");
     	$('#txt_part_nm').val("");
//      $('#txt_req_date').val("");
//      $('#txt_dept_code').val("");
     	$('#txt_yongdo').val("");
     	$('#txt_gubun').val("");
     	$('#txt_req_count').val("");
     	$('#txt_unit').val("");
     	$('#txt_bigo').val("");
     	$('#txt_bulchul_date').val("");
//      $('#txt_req_userid').val("");
     	$('#txt_reciept_userid').val("");
//      $('#txt_damdanja').val("");
	}
	
	function fn_mius_body(obj){
		vTableS303S070130.row($(obj).parents('tr')).remove().draw();

	    TableS303S070130_info = vTableS303S070130.page.info();
	    TableS303S070130_RowCount = TableS303S070130_info.recordsTotal;
	    
	    call_S303S070120(); //삭제 후 왼쪽테이블 refresh
    }       
	
	function fn_btn_plus_all_body(obj){  	
		TableS303S070120_info = vTableS303S070120.page.info();
        TableS303S070120_RowCount = TableS303S070120_info.recordsTotal;
        
        for(var i=0; i<TableS303S070120_RowCount; i++) {
        	if(vTableS303S070120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked")) {
        		vTableS303S070130.row.add( [
            		$("#txt_order_no").val(),
//     		    	$("#txt_order_detail_seq").val(),
    		    	$("#txt_lotno").val(),
    				'', // bulchul_req_no(채번 : 빈값)
    				vTableS303S070120.cell(i, 2).data(), // part_cd
    				vTableS303S070120.cell(i, 5).data(), // part_cd_rev
    				vTableS303S070120.cell(i, 3).data(), // part_nm
    				$('#txt_req_date').val(),
    				$('#txt_dept_code').val(),
    				$('#txt_dept_code option:selected').text(), //code_name(부서명)
    				$('#txt_yongdo').val(),
    				$('#txt_gubun').val(),
    				vTableS303S070120.cell(i, 4).data(), // req_count
    				$('#txt_unit').val(),
    				$('#txt_bigo').val(),
    				$('#txt_bulchul_date').val(),
        			'<%=loginID%>', // req_userid
    				$('#txt_reciept_userid').val(),
        			'<%=loginID%>', // damdanja
    				'' //삭제버튼
    	        ] );
        	}
        }
        vTableS303S070130.draw();
        
        TableS303S070130_RowCount = vTableS303S070130.rows().count();
        call_S303S070120(); //전체입력 후 왼쪽테이블 refresh
    }  
	
	function SaveOderInfo() {        
		
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;
		
		TableS303S070130_info = vTableS303S070130.page.info();
        TableS303S070130_RowCount = TableS303S070130_info.recordsTotal;
		
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.jsp_page = '<%=GV_JSPPAGE%>';
        dataJsonHead.login_id =  '<%=loginID%>'; 
        dataJsonHead.prefix = 'CHL'; 
        <%-- '<%=GV_GET_NUM_PREFIX%>' --%>
        dataJsonHead.detail_seq = '<%=GV_ORDER_DETAIL_SEQ%>';
		
        var jArray = new Array(); // JSON Array 선언
	    for(var i=0; i<TableS303S070130_RowCount; i++){
	    	var dataJson = new Object();
	    	
	    	dataJson.order_no 		=  vTableS303S070130.cell(i , 0).data(); 	//order_no 
	    	dataJson.lotno 			= vTableS303S070130.cell(i , 1).data(); 	//lotno
	    	dataJson.bulchul_req_no =  vTableS303S070130.cell(i , 2).data();	//bulchul_req_no : 이미 조회된 데이터가 있을경우 0번째 행의 bulchul_req_no, 없을 경우 'ㅋ'(가짜값)
	    	dataJson.part_cd 		= vTableS303S070130.cell(i , 3).data(); 	//part_cd
	    	dataJson.part_cd_rev 	= vTableS303S070130.cell(i , 4).data(); 	//part_cd_rev
	    	dataJson.req_date 		= vTableS303S070130.cell(i , 6).data(); 	//req_date
	    	dataJson.dept_code		= vTableS303S070130.cell(i , 7).data(); 	//dept_code
	    	dataJson.yongdo 		= vTableS303S070130.cell(i , 9).data(); 	//yongdo
	    	dataJson.gubun 			= vTableS303S070130.cell(i , 10).data(); 	//gubun
	    	dataJson.req_count 		= vTableS303S070130.cell(i , 11).data(); 	//req_count				
	    	dataJson.unit 			= vTableS303S070130.cell(i , 12).data(); 	//unit
	    	dataJson.bigo 			= vTableS303S070130.cell(i , 13).data(); 	//bigo
	    	dataJson.bulchul_date 	= vTableS303S070130.cell(i , 14).data(); 	//bulchul_date
	    	dataJson.req_userid 	= vTableS303S070130.cell(i , 15).data(); 	//req_userid
	    	dataJson.reciept_userid = vTableS303S070130.cell(i , 16).data(); 	//reciept_userid
	    	dataJson.damdanja 		= vTableS303S070130.cell(i , 17).data(); 	//damdanja
	    	dataJson.member_key = "<%=member_key%>";
			
			jArray.push(dataJson); 
	    }
	    var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		 parent.DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">원부자재명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_part_nm" readonly></input>
				<input type="hidden" class="form-control" id="txt_part_cd" readonly></input>
				<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
			</td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">부서명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<select class="form-control" id="txt_dept_code" disabled="disabled">
				<%
					optCode = (Vector) tIncongVector.get(0);
					optName = (Vector) tIncongVector.get(1);
	
					for (int i = 0; i < optName.size(); i++) {
						if(optName.get(i).toString().equals("생산")){
				%>
					<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
				<%
						} else {
				%>
					<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
				<%
						}
					}
				%>
				</select>
			</td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_order_no" readonly></input>
				<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
				<input type="hidden" class="form-control" id="txt_lotno" readonly></input>
				<input type="hidden" class="form-control" id="txt_bulchul_req_no" readonly></input>
				<input type="hidden" class="form-control" id="txt_req_date" readonly></input>
				<input type="hidden" class="form-control" id="txt_req_userid" readonly></input>
				<input type="hidden" class="form-control" id="txt_damdanja" readonly></input>
			</td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">용도</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_yongdo" ></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">구분</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_gubun" ></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수령인 ID</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_reciept_userid" ></input>
            </td>
        </tr>
        <tr  style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수량</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_req_count" ></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">단위</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_unit" ></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">불출일자</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_bulchul_date" readonly></input>
            </td>
        </tr>
        <tr  style="background-color: #fff; ">
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left">비고</td>
            <td style="width: 66.66%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left" colspan="4">
            	<textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4;resize:none;"></textarea>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left">
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
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	