<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<!DOCTYPE html>

<%
/* 
S202S030111.jsp
이력번호 등록
*/

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	// tbm_our_company_info 데이터 불러오기 //
	String[] strColumnHeadE125    = { "bizno","revision_no","cust_nm","address","telno","boss_name","uptae","jongmok","faxno","homepage","zipno",
	                         "start_date","create_date","create_user_id","modify_date","modify_user_id","modify_reason","duration_date","seal_img_filename", "history_yn" };
	JSONObject jArrayE125 = new JSONObject();
	jArrayE125.put( "member_key", member_key);
	DoyosaeTableModel TableModelE125 = new DoyosaeTableModel("M101S040100E125", strColumnHeadE125, jArrayE125);
	int RowCountE125 =TableModelE125.getRowCount();
	
	String history_yn="";
	
	if(RowCountE125 < 1){
		history_yn="";
	}else{
		history_yn = TableModelE125.getValueAt(0,19).toString().trim();
	}
	// 데이터 불러오기 끝
	
	String GV_ORDERNO="",GV_LOTNO="";

	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	

	
	
%>
    
	<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S030100E111 = {
			PID:  "M202S030100E111", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S030100E111", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
    $(document).ready(function () {
	
        $("#dateHist").daterangepicker({
        	singleDatePicker: true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: "YYYY-MM-DD HH:mm:ss"
        	}
        });

    	var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());   
        

        $('#dateHist').data('daterangepicker').setStartDate(today);
        
    	if("<%=history_yn%>"=="N"){
    		$('#txt_HistNo').val("HENE00001");
    	}else{
    		$('#txt_HistNo').val();
    	}
        
    });	
    
    

    
	function SaveOderInfo() {        
		
		if($('#txt_HistNo').val()=='') { 
			alert("이력번호를 입력하여 주세요");
			return false;
		}
		var WebSockData="";
		
        var dataJson = new Object(); // JSON Object 선언
	    dataJson.hist_no		= $('#txt_HistNo').val(); 		
	    dataJson.order_no		= '<%=GV_ORDERNO%>';
	    dataJson.lotno			= '<%=GV_LOTNO%>';
	    dataJson.member_key		= '<%=member_key%>';
	    dataJson.create_date		= $('#dateHist').val(); 		

		SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		$('#txt_HistNo').val('');
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         		parent.Hist_List.click();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}      		

    </script>

	<div style="width: 100%"> 
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="HistNo">
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">이력번호</td>
	        		<td><input type="text" class="form-control" id="txt_HistNo"  ></input></td>
	        		<td><input type="hidden" id="dateHist" class="form-control" style="width: 200px; border: solid 1px #cccccc;"/></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td colspan="4" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				        <p style="text-align:center;">
				        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();" 
				        			style="font-weight: 900; font-size:18px;width:130px;height:60px;">저장</button>
					        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();" 
					        		style="font-weight: 900; font-size:18px;width:130px;height:60px;;margin-left:30px;">취소</button>
				        </p>
        			</td>
	        	</tr>
        	</table>
		</div> 

	