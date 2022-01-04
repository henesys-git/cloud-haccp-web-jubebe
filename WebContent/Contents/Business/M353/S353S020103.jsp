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

	String  GV_PROC_PLAN_NO="", GV_PRODUCT_NM="",
			GV_PROD_CD="", GV_PROD_CD_REV="", GV_MIX_RECIPE_CNT="" ;
	
	if(request.getParameter("proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if(request.getParameter("product_nm")== null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV = "";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("mix_recipe_cnt")== null)
		GV_MIX_RECIPE_CNT = "";
	else
		GV_MIX_RECIPE_CNT = request.getParameter("mix_recipe_cnt");
	
%>
    <script type="text/javascript">
    var tr="";
	var SQL_Param = {
			PID:  "M353S020100E103", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	}; 
	
	var vTableS353S020140 ;
	var TableS353S020140_RowCount = 0 ;

    $(document).ready(function () {
//     	$("#txt_production_date").datepicker({
//     		format: 'yyyy-mm-dd',
//     		autoclose: true,
//     		language: 'ko'
//     	});
//     	var today = new Date();
//     	$('#txt_production_date').datepicker('update', today);
        
    	$("#txt_proc_plan_no").val("<%=GV_PROC_PLAN_NO%>");
    	$("#txt_bom_cd").val("<%=GV_PROD_CD%>");
        $("#txt_bom_cd_rev").val("<%=GV_PROD_CD_REV%>");
        $("#txt_bom_name").val("<%=GV_PRODUCT_NM%>");
        $("#txt_product_nm").val("<%=GV_PRODUCT_NM%>");
        $("#txt_mix_recipe_cnt").val("<%=GV_MIX_RECIPE_CNT%>");
        
        call_S353S020140();
        
    });	

    function call_S353S020140(){
    	$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S020140.jsp", 
            data: "proc_plan_no=" + '<%=GV_PROC_PLAN_NO%>'
        		+ "&bom_cd=" + '<%=GV_PROD_CD%>' + "&bom_cd_rev=" + '<%=GV_PROD_CD_REV%>',  
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
	
	function SaveOderInfo() {    
		var result_data = $("#tableS353S020140_body > tr");
		var total_length = result_data.length;
		
		if(total_length<1) {
			heneSwal.warning('원부재료를 등록해주세요')
			return false;
		}
		
		var work_complete_insert_check = confirm("삭제하시겠습니까?");
		if(work_complete_insert_check == false)	return;
		
        
    	var dataJson = new Object();
    	
    	
    	dataJson.proc_plan_no 	= $("#txt_proc_plan_no").val(); 	//proc_plan_no 
    	dataJson.bom_cd 		= $("#txt_bom_cd").val(); 			//bom_cd
    	dataJson.bom_cd_rev 	= $("#txt_bom_cd_rev").val(); 		//bom_cd_rev
    	dataJson.member_key 	= "<%=member_key%>";
		
    	
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		console.log(JSONparam);
		
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
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제조일자</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_production_date" readonly></input>
			</td>
			
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left;">제품 이름</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left;">
            	<input type="text" class="form-control" id="txt_product_nm" readonly></input>
            	
            	<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_bom_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_bom_cd_rev" readonly></input>
            	<input type="hidden" class="form-control" id="txt_bom_name" readonly></input>
            	
            	
            	<input type="hidden" class="form-control" id="txt_order_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_lot_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_part_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
            	<input type="hidden" class="form-control" id="txt_part_nm" readonly></input>
            	<input type="hidden" class="form-control" id="txt_cust_nm" readonly></input>
            	
            </td>
            
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">배합수</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_mix_recipe_cnt" readonly></input>
			</td>
		</tr>
                 
	</table>
	<div id="inspect_Request_body" style="width: 100%;height: 500px;">

	</div>

		
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>	