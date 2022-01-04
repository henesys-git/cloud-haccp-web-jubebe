<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String GV_JSPPAGE = "", GV_OVEN="", GV_OVEN2="", GV_PROD_NAME="",FROM = "", TO="";

	if (request.getParameter("jspPage") == null)
		GV_JSPPAGE = "";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if (request.getParameter("oven") == null)
		GV_OVEN = "";
	else
		GV_OVEN = request.getParameter("oven");
	
	if (request.getParameter("oven2") == null)
		GV_OVEN2 = "";
	else
		GV_OVEN2 = request.getParameter("oven2");
	
	if (request.getParameter("prod_name") == null)
		GV_PROD_NAME = "";
	else
		GV_PROD_NAME = request.getParameter("prod_name");
	
	if (request.getParameter("from") == null)
		FROM = "";
	else
		FROM = request.getParameter("from");
	
	if (request.getParameter("to") == null)
		TO = "";
	else
		TO = request.getParameter("to");
	
	JSONObject jArray = new JSONObject();
	
	jArray.put( "oven" , GV_OVEN);
	jArray.put( "oven2" , GV_OVEN2);
	jArray.put( "from" , FROM);
	jArray.put( "to" , TO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M808S010100E154", jArray);	
	
%>
<script type="text/javascript">
var M808S030100E101 = {
		PID:  "M808S010100E111", 
		totalcnt: 0,
		retnValue: 999,
		colcnt: 0,
		colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
		data: []
};  

var SQL_Param = {
		PID:  "M808S010100E111", 
		excute: "queryProcess",
		stream: "N",
		param: ""
};


    $(document).ready(function () {
    	
        $('#select_oven').val('<%=GV_OVEN%>');
        $('#select_oven2').val('<%=GV_OVEN2%>');
    	$('#txt_product_name').val('<%=GV_PROD_NAME%>');
    	
    	if($('#select_oven').val() =="OV07") {
    		$('#select_oven2').css('display','block');
    	} else {
    		$('#select_oven2').css('display','none');
    	}
    });

    
    function pop_fn_plan_View(caller,num,doc_gubun,doc_no) {
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp"
    						+"?From="+$("#dateFrom").val() + "&To="+$("#dateTo").val() + "&Caller=1";
    	pop_fn_popUpScr_nd(modalContentUrl, "생산계획 관리", '600px', '1360px');
		return false;
     }
    
    
	function SaveOderInfo() {      
		
	 	if ($("#txt_product_name").val()==""){
        	alert("제품을 선택해주세요");
        	return false;
        }
	 	if ($("#txt_writer").val()==""){
        	alert("작성자를 입력해주세요");
        	return false;
        }
	 	if ($("#txt_grantor").val()==""){
        	alert("승인자를 입력해주세요");
        	return false;
        }
	 	if ($("#txt_checker").val()==""){
        	alert("점검자를 입력해주세요");
        	return false;
        }


		var dataJson = new Object();
			
			dataJson.product_name	= $('#txt_product_name').val();
			dataJson.select_oven	= $("#select_oven option:selected").val();
			dataJson.entry_top		= $("#txt_entry_top").val();
			dataJson.entry_bottom	= $('#txt_entry_bottom').val();
			dataJson.mid_top		= $('#txt_mid_top').val();;
			dataJson.mid_bottom		= $('#txt_mid_bottom').val();
			dataJson.exit_top		= $('#txt_exit_top').val();
			dataJson.exit_bottom	= $('#txt_exit_bottom').val();
			dataJson.rpm			= $('#txt_rpm').val();
			dataJson.material		= $('#txt_material').val();
			dataJson.writer			= $('#txt_writer').val();
			dataJson.grantor		= $('#txt_grantor').val();
			dataJson.checker		= $('#txt_checker').val();
			dataJson.decision		= $("input[name='decision']:checked").val();
			dataJson.member_key = '<%=member_key%>'; //insert update delete
			
			var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			SendTojsp(JSONparam, SQL_Param.PID);

	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", // insert_update_delete_json.jsp로 연결
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        	   	//parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  
    
    
    
    function change_oven() {
    	var oven = $('#select_oven');
    	var oven2 = $('#select_oven2')
    	if($(oven).val() == 'OV07') {
    		$(oven2).css('display','block');
    	} else {
    		$(oven2).css('display','none');
    	}
    	
            
        	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M808/S808S010101.jsp"
        						+ "?oven=" + $('#select_oven').val()
        						+ "&oven2=" + $('#select_oven2').val()
        						+ "&from=" + $('#dateFrom').val()
        						+ "&to=" + $('#dateTo').val()
        						+ "&prod_name=" + $('#txt_product_name').val()

        	
            pop_fn_popUpScr(modalContentUrl, "측 정(S808S010101)", '700px','500px');
    		return false;
         
    }
   
    </script>

<table class="table " style="width: 100%; margin: 0 auto; align: left">
	<tbody id="Doc_tbody">
		<tr>
			<td style='vertical-align: middle'>제품</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_product_name"name="txt_product_name" style="width: 214px; float: left" readonly="readonly"></input>
				<button type="button" onclick="pop_fn_plan_View()"id="btn_SearchProd" class="btn btn-info"style="margin-left: 10px; float: left">검색</button> 
			</td>
		</tr>
		
 		<tr>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">작업</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
								
				<select class="form-control" id="select_oven" style="width: 80px;float: left;"onchange="change_oven()">
						<option value="OV01">1호기</option>
						<option value="OV07">2호기</option>
				</select>
				<select class="form-control" id="select_measurements" style="width: 110px;float: left;">
						<option value="start">작업시작</option>
						<option value="ing">작업 2시간</option>
						<option value="finish">작업완료</option>
				</select>
				<select class="form-control" id="select_oven2" style="width: 80px;float: left;"onchange="change_oven()">
						<option value="top">상단</option>
						<option value="bottom">하단</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td style='font-weight: 900;vertical-align: middle;width: 80px'>입구</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				 <input type="text" class="form-control" id="txt_entry_top" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(1, 3)%>'></input>
				 <input type="text" class="form-control" id="txt_entry_bottom" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(2, 3)%>'></input>
			</td>
		</tr> 
		<tr>
			<td style='font-weight: 900;vertical-align: middle;width: 80px'>중앙</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				 <input type="text" class="form-control" id="txt_mid_top" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(3, 3)%>'></input>
				 <input type="text" class="form-control" id="txt_mid_bottom" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(4, 3)%>'></input>
			</td>
		</tr> 
		<tr>
			<td style='font-weight: 900;vertical-align: middle;width: 80px'>출구</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				 <input type="text" class="form-control" id="txt_exit_top" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(5, 3)%>'></input>
				 <input type="text" class="form-control" id="txt_exit_bottom" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(6, 3)%>'></input>
			</td>
		</tr> 
		<tr>
			<td style='font-weight: 900;vertical-align: middle;width: 80px'>가열속도</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				 <input type="text" class="form-control" id="txt_rpm" name="docname"style="width: 150px; float: left" readonly value='<%=TableModel.getValueAt(0, 3)%>'></input>
			</td>
		</tr> 
		<tr>
			<td style='font-weight: 900;vertical-align: middle;width: 80px'>품온</td>
			<td style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				 <input type="text" class="form-control" id="txt_material" name="docname"style="width: 150px; float: left"></input>
			</td>
		</tr> 
		
		
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle;width: 80px">작성자</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_writer" name="external_doc_source" style="width: 150px; float: left"></input>
			</td>
		</tr>
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle;width: 80px">승인자</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_grantor" name="external_doc_source" style="width: 150px; float: left"></input>
			</td>
		</tr>
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle;width: 80px">점검자</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_checker" name="external_doc_source" style="width: 150px; float: left"></input>
			</td>
		</tr>
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle;width: 80px">판정</td>
			<td style="font-size: 14px; text-align: left; vertical-align: middle">
				<input type="radio" name="decision" checked="checked" value="O" /> O
  				<input type="radio" name="decision" value="X" /> X
			</td>
		</tr>
		
		<tr style="height: 60px">
			<td colspan="2" align="center">
				<p>
					<button id="btn_Save" class="btn btn-info" style="width: 100px"
						onclick="SaveOderInfo(); return false; parent.$('#modalReport').hide().fadeIn(100);">등록</button>
					<button id="btn_Canc" class="btn btn-info" style="width: 100px"
						onclick="parent.$('#modalReport').hide();return false;">취소</button>
				</p>
			</td>
		</tr>
	</tbody>
</table>
