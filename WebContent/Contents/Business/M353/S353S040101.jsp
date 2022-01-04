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

	String  GV_ORDERNO="", GV_LOTNO="",
			GV_BOM_CD="", GV_BOM_CD_REV="", GV_BOM_NAME="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD = "";
	else
		GV_BOM_CD = request.getParameter("bom_cd");
	
	if(request.getParameter("bom_cd_rev")== null)
		GV_BOM_CD_REV = "";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");
	
	if(request.getParameter("bom_name")== null)
		GV_BOM_NAME = "";
	else
		GV_BOM_NAME = request.getParameter("bom_name");
	
%>
    <script type="text/javascript">
	var SQL_Param = {
			PID:  "M353S040100E111", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	}; 

    $(document).ready(function () {
    	$("#txt_bulchul_date").datepicker({
    		format: 'yyyy-mm-dd',
    		autoclose: true,
    		language: 'ko'
    	});
    	var today = new Date();
    	$('#txt_bulchul_date').datepicker('update', today);
        
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_lot_no").val("<%=GV_LOTNO%>");
    	$("#txt_bom_cd").val("<%=GV_BOM_CD%>");
        $("#txt_bom_cd_rev").val("<%=GV_BOM_CD_REV%>");
        $("#txt_bom_name").val("<%=GV_BOM_NAME%>");
        
        call_S353S040120();
    });	

    function call_S353S040120(){
    	$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S040120.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&lotno=" + '<%=GV_LOTNO%>'
	        	+ "&bom_cd=" + '<%=GV_BOM_CD%>' + "&bom_cd_rev=" + '<%=GV_BOM_CD_REV%>', 
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
	
	function fn_btn_plus_all_body(obj){
		if($("#txt_part_cd").val().length < 1) {
			alert("원부자재를 선택하세요.");
			return;
		}
		
		if($("#txt_unit").val().length < 1) {
			alert("실중량을 입력하세요.");
			return;
		}
		
		td.eq(16).text($("#txt_part_cnt").val());
		td.eq(35).text($("#txt_unit").val());
		$("#tableS353S040120_2_body").append(tr);
		
		clear_input(); 
    }
	
	function clear_input(){
		$('#txt_part_cd').val("");
		$('#txt_part_cd_rev').val("");
		$('#txt_part_nm').val("");
		$('#txt_unit').val("");
	}
	
	function SaveOderInfo() {    
		var result_data = $("#tableS353S040120_2_body >tr");
		var total_length = result_data.length;
		
		if(total_length<1) {
			heneSwal.warning('배합정보등록', '원부재료를 등록해주세요')
			return false;
		}
		
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;
		
        var jArray = new Array(); // JSON Array 선언
	    for(var i=0; i<total_length; i++){
	    	var dataJson = new Object();
	    	var innerData = result_data.eq(i).children();
	    	dataJson.order_no 		= innerData.eq(0).text(); 			//order_no 
	    	dataJson.lotno 			= innerData.eq(1).text(); 			//lotno
	    	dataJson.revision_no 	= innerData.eq(2).text();			//revision_no 
	    	dataJson.bom_cd 		= innerData.eq(3).text(); 			//bom_cd
	    	dataJson.bom_cd_rev 	= innerData.eq(4).text(); 			//bom_cd_rev
	    	dataJson.last_no		= innerData.eq(5).text(); 			//last_no
	    	dataJson.sys_bom_id 	= innerData.eq(6).text(); 			//sys_bom_id
	    	dataJson.type_no 		= innerData.eq(7).text(); 			//type_no
	    	dataJson.geukyongpoommok= innerData.eq(8).text(); 			//geukyongpoommok				
	    	dataJson.dept_code 		= innerData.eq(9).text(); 		//dept_code
	    	dataJson.approval_date 	= innerData.eq(10).text(); 		//approval_date
	    	dataJson.approval 		= innerData.eq(11).text(); 		//approval
	    	dataJson.part_cd 		= innerData.eq(12).text(); 		//part_cd
	    	dataJson.part_cd_rev 	= innerData.eq(13).text(); 		//part_cd_rev
	    	dataJson.bom_name 		= innerData.eq(14).text();			//bom_name
	    	
	    	dataJson.part_nm 		= innerData.eq(15).text();			//bom_name
	    	dataJson.part_cnt 		= innerData.eq(16).text(); 		//part_cnt
	    	dataJson.mesu 			= innerData.eq(17).text(); 		//mesu
	    	dataJson.gubun 			= innerData.eq(18).text();			//gubun
	    	dataJson.qar 			= innerData.eq(19).text(); 		//qar
	    	dataJson.inspect_selbi 	= innerData.eq(20).text(); 		//inspect_selbi
	    	dataJson.packing_jaryo 	= innerData.eq(21).text();			//packing_jaryo
	    	dataJson.modify_note 	= innerData.eq(22).text(); 		//modify_note
	    	dataJson.cust_code 		= innerData.eq(23).text(); 		//cust_code
	    	dataJson.cust_rev 		= innerData.eq(24).text(); 		//cust_rev
	    	dataJson.bigo 			= innerData.eq(25).text(); 		//bigo
	    	dataJson.create_user_id = '<%=loginID%>'; 			//create_user_id
	    	dataJson.create_date 	= new Date(); 		//create_date
	    	dataJson.modify_user_id = '<%=loginID%>'; 			//modify_user_id
	    	dataJson.modify_date 	= new Date(); 		//modify_date
	    	dataJson.modify_reason 	= innerData.eq(30).text(); 		//modify_reason
	    	dataJson.review_no 		= innerData.eq(31).text(); 		//review_no
	    	dataJson.confirm_no 	= innerData .eq(32).text();		//confirm_no
	    	dataJson.order_detail_seq = innerData.eq(33).text(); 		//order_detail_seq
	    	dataJson.member_key 	= "<%=member_key%>";		//member_key
	    	dataJson.unit 			= innerData.eq(35).text();		//unit
			
			jArray.push(dataJson); 
	    }
		var dataJsonMulti = new Object();
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
	        		parent.fn_DetailInfo_List();
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
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_order_no" readonly></input>
			</td>
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">Lot_No</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_lot_no" readonly></input>
			</td>
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">BOM코드</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_bom_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_bom_cd_rev" readonly></input>
			</td>
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">배합(BOM)명</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_bom_name" readonly></input>
            </td>
		</tr>
		<tr  style="background-color: #fff; ">
		<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">원부자재코드</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_part_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
			</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">원부자재명</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_part_nm" readonly></input>
            </td>
<!--             <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">비율</td> -->
<!--             <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
<!--             	<input type="text" class="form-control" id="txt_part_cnt" ></input> -->
<!--             </td> -->
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">실중량</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_unit" ></input>
            </td>
            <td colspan=2>
            	<button class="btn btn-info"  onclick="fn_btn_plus_all_body(this);">등록</button>
            </td>
           
        </tr>       
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_Request_body" style="width:40%; float:left"></div>
		<div style="width:6%;  height:330px; vertical-align: middle ;float:left;visibility: hidden;">
			<label style="height:100px;"></label>
	        <button id="btn_plus_all" class="form-control btn btn-info" onclick="fn_btn_plus_all_body(this);">>></button>
		</div>
		<div id="inspect_result_body" style="width:54%; float:left">
	<table class='table table-bordered nowrap table-hover' id="tableS353S040120_2" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>order_no</th>
		     <th style='width:0px; display: none;'>lotno</th>
		     <th style='width:0px; display: none;'>revision_no</th>
		     <th style='width:0px; display: none;'>bom_cd</th>
		     <th style='width:0px; display: none;'>bom_cd_rev</th>
		     <th style='width:0px; display: none;'>last_no</th>
		     <th style='width:0px; display: none;'>sys_bom_id</th>
		     <th style='width:0px; display: none;'>type_no</th>
		     <th style='width:0px; display: none;'>geukyongpoommok</th>
		     <th style='width:0px; display: none;'>dept_code</th>
		     <th style='width:0px; display: none;'>approval_date</th>
		     <th style='width:0px; display: none;'>approval</th>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th style='width:0px; display: none;'>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th>비율</th>
		     <th style='width:0px; display: none;'>mesu</th>
		     <th style='width:0px; display: none;'>gubun</th>
		     <th style='width:0px; display: none;'>qar</th>
		     <th style='width:0px; display: none;'>inspect_selbi</th>
		     <th style='width:0px; display: none;'>packing_jaryo</th>
		     <th style='width:0px; display: none;'>modify_note</th>
		     <th style='width:0px; display: none;'>cust_code</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>bigo</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>review_no</th>
		     <th style='width:0px; display: none;'>confirm_no</th>
		     <th style='width:0px; display: none;'>order_detail_seq</th>
		     <th style='width:0px; display: none;'>member_key</th>
		     <th>실중량</th>				    
		</tr>
		</thead>
		<tbody id="tableS353S040120_2_body">		
		</tbody>
	</table>
		
		</div>
	</div>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	