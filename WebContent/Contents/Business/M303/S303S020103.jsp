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
/* 
생산계획수정(S303S020102).jsp
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_JSPPAGE="", GV_NUM_GUBUN="", GV_DETAIL_SEQ="0";
	String GV_PROC_PLAN_NO="", GV_PROD_CD = "", GV_PROD_CD_REV = "", GV_PRODUCT_NM = "", 
		   GV_MIX_RECIPE_CNT = "", GV_START_DT = "", GV_END_DT = "", GV_PRODUCTION_STATUS="";

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	
	
	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("Proc_plan_no")== null)
		GV_PROC_PLAN_NO="";
	else
		GV_PROC_PLAN_NO = request.getParameter("Proc_plan_no");
		
	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("Prod_cd_rev");
	
	if(request.getParameter("Product_nm")== null)
		GV_PRODUCT_NM="";
	else
		GV_PRODUCT_NM = request.getParameter("Product_nm");

	if(request.getParameter("Mix_recipe_cnt")== null)
		GV_MIX_RECIPE_CNT="";
	else
		GV_MIX_RECIPE_CNT = request.getParameter("Mix_recipe_cnt");

	if(request.getParameter("Start_dt")== null)
		GV_START_DT="";
	else
		GV_START_DT = request.getParameter("Start_dt");

	if(request.getParameter("End_dt")== null)
		GV_END_DT="";
	else
		GV_END_DT = request.getParameter("End_dt");
	
	if(request.getParameter("Production_status")== null)
		GV_PRODUCTION_STATUS="";
	else
		GV_PRODUCTION_STATUS = request.getParameter("Production_status");
	
	Vector optCode =  null;
    Vector optName =  null;
    Vector Seolbi_gubunVector = CommonData.getSeolbiData();
    
%>
    <script type="text/javascript">
	var M303S020100E103 = {
		PID:  "M303S020100E103", 
		totalcnt: 0,
		retnValue: 999,
		colcnt: 0,
		colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
		data: []
	};  
	
	var SQL_Param = {
		PID:  "M303S020100E103", 
		excute: "queryProcess",
		stream: "N",
		param: ""
	};

	var vTableS303S020120;
	var TableS303S020120_info;
    var TableS303S020120_RowCount = 0;
    var S303S020120_Row_index = -1;    
	
	var vTableS303S020130;
    var S303S020130_Row_index = -1;
	var TableS303S020130_info;
    var TableS303S020130_RowCount;

    $(document).ready(function () {
        $("#txt_start_dt").daterangepicker({
        	singleDatePicker: true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: "YYYY-MM-DD HH:mm:ss"
        	}
        });
        $('#txt_end_dt').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'YYYY-MM-DD HH:mm:ss'
        	}
        });

    	$("#txt_proc_plan_no").val("<%=GV_PROC_PLAN_NO%>");
    	$("#txt_prod_cd").val("<%=GV_PROD_CD%>");
        $("#txt_prod_cd_rev").val("<%=GV_PROD_CD_REV%>");        
        $("#txt_product_nm").val("<%=GV_PRODUCT_NM%>");
        $("#txt_mix_recipe_cnt").val("<%=GV_MIX_RECIPE_CNT%>");
        $("#txt_start_dt").val("<%=GV_START_DT%>");
        $("#txt_end_dt").val("<%=GV_END_DT%>");
        
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        call_S303S020130();
    });	



    function call_S303S020130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020130.jsp", 
	        data: "caller=" + "S303S020103" 
	        	+ "&proc_plan_no="+ '<%=GV_PROC_PLAN_NO%>' 
	        	+ "&prod_cd=" + '<%=GV_PROD_CD%>' 
	        	+ "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>', 
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
	
	function SaveOderInfo() {        
		TableS303S020130_info = vTableS303S020130.page.info();
        TableS303S020130_RowCount = TableS303S020130_info.recordsTotal;
        
//         if(TableS303S020130_RowCount==0) {
//         	alert("공정을 하나이상 등록하세요");
// 			return false;
//         }
        
//    		if($('#txt_mix_recipe_cnt').val()== '' ) { 
//    			alert("배합수량을 입력하여 주세요");
//    			return false;
//    		}
             
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.jsp_page 			= '<%=GV_JSPPAGE%>';
        dataJsonHead.login_id 			= '<%=loginID%>'; 
        dataJsonHead.num_gubun 			= '<%=GV_NUM_GUBUN%>'; 
        dataJsonHead.detail_seq 		= '<%=GV_DETAIL_SEQ%>';
        dataJsonHead.member_key 		= "<%=member_key%>";
    	dataJsonHead.proc_plan_no  	 	= $('#txt_proc_plan_no').val();
        dataJsonHead.prod_cd		 	= $('#txt_prod_cd').val();
        dataJsonHead.prod_cd_rev     	= $('#txt_prod_cd_rev').val();   
    	dataJsonHead.mix_recipe_cnt	 	= $('#txt_mix_recipe_cnt').val();
    	dataJsonHead.start_dt        	= $('#txt_start_dt').val();
    	dataJsonHead.end_dt          	= $('#txt_end_dt').val();
    	dataJsonHead.production_status	= '<%=GV_PRODUCTION_STATUS%>';
    	dataJsonHead.proc_plan_no 		= $('#txt_proc_plan_no').val();
        var jArray = new Array(); // JSON Array 선언
        
	    for(var i=0; i<TableS303S020130_RowCount; i++){
	    	var dataJson = new Object(); // BOM Data용	    	
	    	dataJson.proc_plan_no = $('#txt_proc_plan_no').val();
	    	dataJson.prod_cd     = vTableS303S020130.cell(i, 4).data();
	    	dataJson.prod_cd_rev = vTableS303S020130.cell(i, 5).data();
	    	dataJson.order_no    = vTableS303S020130.cell(i, 1).data();
	    	dataJson.lotno       = vTableS303S020130.cell(i, 2).data();
	    	dataJson.member_key = "<%=member_key%>";	    	
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
	    
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
		console.log(SQL_Param.PID);
		
		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		var chekrtn = confirm("삭제하시겠습니까?"); 
		
		if(chekrtn){
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
		}
		
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		fn_MainInfo_List();
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
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">제품명</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_product_nm" style="float:left; width: 78%;" readonly></input>
            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly></input>
            	<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly></input>
				<button type="button" onclick="parent.pop_fn_ProductName_View(1,'02')" id="btn_SearchpROJECT" class="btn btn-info" style="width: 20%; margin-left:2%;" disabled>검색</button> 
			</td>
			<td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">배합수량</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="number" class="form-control" step="0.1" id="txt_mix_recipe_cnt" numberOnly disabled></input>
			</td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" colspan="1">공정시작예정일</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="1">
				<input type="text" class="form-control" id="txt_start_dt" disabled></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">공정완료예정일</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_end_dt"disabled ></input>
			</td>
        </tr>        	
	</table>

	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_result_body" style="width:100%; float:left"></div>
	</div>
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>