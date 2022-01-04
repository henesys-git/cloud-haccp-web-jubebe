<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	// 로그인한 사용자의 정보
	JSONObject jArrayUser = new JSONObject();
	jArrayUser.put( "USER_ID", loginID);
	jArrayUser.put( "member_key", member_key);
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "";
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	String  GV_JSPPAGE="",GV_NUM_GUBUN="",
			GV_PROC_PLAN_NO="", GV_PROD_CD="", GV_PROD_CD_REV="",
			GV_PROD_NM="",GV_MIX_RECIPE_CNT="",
			GV_START_DT="",GV_END_DT="", GV_PRODUCTION_END_DT="";

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("proc_plan_no")== null) 
		GV_PROC_PLAN_NO="";
	else 
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("product_nm")== null) 
		GV_PROD_NM="";
	else 
		GV_PROD_NM = request.getParameter("product_nm");
	
	if(request.getParameter("mix_recipe_cnt")== null) 
		GV_MIX_RECIPE_CNT="";
	else 
		GV_MIX_RECIPE_CNT = request.getParameter("mix_recipe_cnt");
	
	if(request.getParameter("start_dt")== null) 
		GV_START_DT="";
	else 
		GV_START_DT = request.getParameter("start_dt");
	
	if(request.getParameter("end_dt")== null) 
		GV_END_DT="";
	else 
		GV_END_DT = request.getParameter("end_dt");
	
	if(request.getParameter("production_end_dt")== null) 
		GV_PRODUCTION_END_DT="";
	else 
		GV_PRODUCTION_END_DT = request.getParameter("production_end_dt");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
		
	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M303S050100E145", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	StringBuffer html = new StringBuffer();
	if(RowCount>0){
		html.append("$('#txt_incog_date').datepicker('update', '"+ TableModel.getValueAt(0,0).toString().trim() +"');\n");
    	html.append("$('#txt_product_nm').val('"+ TableModel.getValueAt(0,4).toString().trim() +"');\n");
    	html.append("$('#txt_incog_prod_no').val('"+ TableModel.getValueAt(0,2).toString().trim() +"');\n");
    	html.append("$('#txt_incog_prod_rev').val('"+ TableModel.getValueAt(0,3).toString().trim() +"');\n");
    	html.append("$('#txt_proc_plan_no').val('"+ TableModel.getValueAt(0,1).toString().trim() +"');\n");
    	html.append("$('#txt_incong_note').val('"+ TableModel.getValueAt(0,5).toString().trim() +"');\n");
    	html.append("$('#txt_weight').val('"+ TableModel.getValueAt(0,6).toString().trim() +"');\n");
    	html.append("$('#txt_make_date').datepicker('update', '"+ TableModel.getValueAt(0,7).toString().trim() +"');\n");
    	html.append("$('#txt_proc_method').val('"+ TableModel.getValueAt(0,8).toString().trim() +"');\n");
	}

		
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M303S050100E141", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	$("#txt_incog_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
    	$("#txt_make_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
    	
    	var today = new Date();
    	
    	if(<%=RowCount%>>0) {
    		<%=html%>
    	} else {
    		$('#txt_incog_date').datepicker('update', today);
        	$("#txt_product_nm").val("<%=GV_PROD_NM%>");
        	$("#txt_incog_prod_no").val("<%=GV_PROD_CD%>");
        	$("#txt_incog_prod_rev").val("<%=GV_PROD_CD_REV%>");
        	$("#txt_proc_plan_no").val("<%=GV_PROC_PLAN_NO%>");
        	if("<%=GV_PRODUCTION_END_DT%>".length<1){
        		$('#txt_make_date').datepicker('update', today);
        	} else {
        		$('#txt_make_date').datepicker('update', "<%=GV_PRODUCTION_END_DT%>");
        	}
    	}
    	
    	$("#txt_writor_main").val("<%=loginID%>");
		$("#txt_writor_main_rev").val("<%=loginIDrev%>");	
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
    	
    });
    
    function add_txt(obj){
      	 var io_cnt = $("#txt_weight").val() + $(obj).text();
      	 $("#txt_weight").val(io_cnt)
      } 

   	function clear_txt(obj){
      	 var io_cnt = $("#txt_weight").val();
      	 var io_length = io_cnt.length;
      	 $("#txt_weight").val(io_cnt.substr(0,io_length-1));
      }
    
	function SaveOderInfo() {
		if($("#txt_weight").val() <= 0){
			alert("부적합품 총중량(g)을 입력하세요.");
			return false;
		}
		
		// write_date 등록 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); // 오늘날짜
		var write_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;

		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		
		dataJson.proc_plan_no = $("#txt_proc_plan_no").val();
		
		dataJson.incog_prod_no = $("#txt_incog_prod_no").val();
		dataJson.incog_prod_rev = $("#txt_incog_prod_rev").val();
		dataJson.part_cd = "";
		dataJson.part_cd_rev = "0";
		
		dataJson.incog_date = $("#txt_incog_date").val();
		dataJson.incong_note = $("#txt_incong_note").val();
		dataJson.weight = $("#txt_weight").val();
		dataJson.make_date = $("#txt_make_date").val();
		dataJson.proc_method = $("#txt_proc_method").val();
		dataJson.attch_doc = ""; // 문서 => 물어보고 수정

		dataJson.write_date = write_date;
		dataJson.writor_main = $("#txt_writor_main").val();
		dataJson.writor_main_rev = $("#txt_writor_main_rev").val();
		dataJson.approval_date = write_date;
		dataJson.approval = "";
		
		dataJson.member_key = "<%=member_key%>";
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
			
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	  	 	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.Incog_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
    
    </script>

<div style="width: 100%"> 
	<div style="width: 650px;float: left; vertical-align: top; margin-left:75px;">
	   <table class="table " style="width: 100%; margin: 0 auto; align:left">
	   	<tr>   
			<td style="width: 100%;">
	   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
	   				<tr style="background-color: #fff;">
			            <td style=" font-weight: 900; font-size:14px; text-align:left">부적합 발생일자</td>
			            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
			            	<input type="text" class="form-control" id="txt_incog_date" readonly/>
			            </td>
					</tr>
					<tr style="background-color: #fff;">
			            <td style=" font-weight: 900; font-size:14px; text-align:left">제품명</td>
			            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
			            	<input type="text" class="form-control" id="txt_product_nm" readonly/>
			            	<input type="hidden" class="form-control" id="txt_incog_prod_no" readonly/>
			            	<input type="hidden" class="form-control" id="txt_incog_prod_rev" readonly/>
			            	<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly/>
			            </td>
			        </tr>
			        <tr style="background-color: #fff" >
			            <td style=" font-weight: 900; font-size:14px; text-align:left">부적합 사항</td>
			            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
			            	<textarea class="form-control" id="txt_incong_note"  style="cols:10;rows:4;resize:none;" ></textarea>
			            </td>
			        </tr>
			        <tr style="background-color: #fff;">    
			            <td style=" font-weight: 900; font-size:14px; text-align:left">부적합품 총중량(g)</td>
			            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
			            	<input type="text" class="form-control" id="txt_weight" numberPoint/>
			            </td>
			        </tr>
			        <tr style="background-color: #fff;">
			            <td style=" font-weight: 900; font-size:14px; text-align:left">제조일자</td>
			            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
			            	<input type="text" class="form-control" id="txt_make_date" readonly/>
			            </td>
					</tr>
			        <tr>
			        	<td style=" font-weight: 900; font-size:14px; text-align:left">처리방법</td>
	                    <td>
	                        <select id="txt_proc_method" style="width:163px;">
	                            <option value="폐기">폐기</option>
	                            <option value="기증">기증</option>
	                            <option value="재작업">재작업</option>
	                            <option value="반송">반송</option>
	                        </select>
	                        <!-- 그외 나머지 hidden 데이터 -->
	                        <input type="hidden" id="txt_writor_main"></input>
	                        <input type="hidden" id="txt_writor_main_rev"></input>
	                        <input type="hidden" id="txt_approval"></input>
	                    </td>
	                </tr>
	        	</table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
	</div> 
	<div style="width: 400px;float: left; vertical-align: top; margin-left:50px;">
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px; " onclick="add_txt(this)" >1</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_2"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >2</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_3"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >3</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_4"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >4</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_5"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >5</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_6"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">6</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_7"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">7</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">8</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_8"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">9</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_11"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="clear_txt(this)"><=</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_10"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">0</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_12"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">.</button>
				</div>
			</div>
		</div>
</div>    
	    

