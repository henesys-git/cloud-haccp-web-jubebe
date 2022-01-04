<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
Balju_form_view.jsp
발주서 View Form 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
	String[] strColumnHead 	= {
								"order_no", "balju_no", "balju_text", 
								"balju_send_date", "cust_cd", "cust_damdang", 
								"tell_no", "fax_no", "balju_nabgi_date", 
								"nabpoom_location", "qa_ter_condtion", "balju_status", 
								"review_no", "confirm_no"
							  };
	
	String GV_ORDERNO = "", GV_ORDER_DETAIL_SEQ = "", 
		   GV_JSPPAGE = "", GV_NUM_GUBUN = "", GV_BALJUNO = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");

	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("BaljuNo") == null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");	
	
	String param =GV_ORDERNO+ "|"+GV_BALJUNO+"|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "baljuno", GV_BALJUNO);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel("M202S010100E234", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();
%>
    
<script type="text/javascript">
    var JOB_GUBUN = "";
	var vTableS202S010240;
	var TableS202S010240_info;
    var TableS202S010240_RowCount;
    var S202S010240_Row_index = -1;
    
    $(document).ready(function () {
		<%if(RowCount>0){%>
			$('#txt_order_no').val('<%=TableModel.getValueAt(0,0).toString().trim()%>');
			$('#txt_balju_no').val('<%=TableModel.getValueAt(0,1).toString().trim()%>');
			$('#txt_balju_text').val('<%=TableModel.getValueAt(0,2).toString().trim()%>');
			$('#txt_S_CustName').val('<%=TableModel.getValueAt(0,4).toString().trim()%>');
			$('#txt_Cust_damdang').val('<%=TableModel.getValueAt(0,5).toString().trim()%>');
			$('#txt_telNo').val('<%=TableModel.getValueAt(0,6).toString().trim()%>');
			$('#txt_FaxNo').val('<%=TableModel.getValueAt(0,7).toString().trim()%>');
			$('#dateOrder').val('<%=TableModel.getValueAt(0,3).toString().trim()%>');
			$('#dateDelevery').val('<%=TableModel.getValueAt(0,8).toString().trim()%>');
			$('#nabpoom_location').val('<%=TableModel.getValueAt(0,9).toString().trim()%>');
			$('#txt_qar').val('<%=TableModel.getValueAt(0,10).toString().trim()%>');    	
    	<%}%> 
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010240.jsp", 
            data: "order_no=" + '<%=GV_ORDERNO%>'+ "&balju_no=" + '<%=GV_BALJUNO%>',  
	        beforeSend: function () {
	            $("#bom_tbody").children().remove();
	        },
	        success: function (html) {
	            $("#bom_tbody").hide().html(html).fadeIn(100);
	        }
 		});

    });	
    
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S08000E013 = {
			PID: "M202S010100E203",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["부서그룹","USER_ID","이름","비밀번호"],
			data: []
	};  
	
	var SQL_Param = {
			PID: "M202S010100E203",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝
    
	function SetRecvData(){
		DataPars(M202S020100E203,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function DeleteProductInfo() {        
		
		TableS202S010240_info = vTableS202S010240.page.info();
        TableS202S010240_RowCount = TableS202S010240_info.recordsTotal;
		
		var chekrtn = confirm("삭제하시겠습니까?"); 
		var WebSockData="";
		
		
		var dataJson = new Object();
	        
		dataJson.balju_no = $('#txt_balju_no').val();
		dataJson.member_key = "<%=member_key%>";

		var JSONparam = JSON.stringify(dataJson);
		
		SendTojsp(JSONparam,SQL_Param.PID);
	}
 
	function SendTojsp(bomdata, pid) {
		$.ajax({
			type: "POST",
			dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : bomdata, "pid" : pid },
	        success: function (html) {
	        	if(html > -1) {
	        	   	parent.fn_MainInfo_List();
	        	   	$("modalReport").modal('hide');
	         	}
	        }
		});		
	}
</script>
    
<table class="table" style="width:100%; margin:0 auto; align:left">
	<tr style="background-color: #fff;">
		<td style="width: 7%; font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">
			수신처
		</td>
		<td style="width: 18%; font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">
			<input type="hidden" class="form-control" id="txt_balju_text" readonly/>
			<input type="text" class="form-control" id="txt_S_CustName" readonly/>
			<input type="hidden" class="form-control" id="txt_S_custcode" style="width: 120px" />
			<input type="hidden" class="form-control" id="txt_S_cust_rev" style="width: 120px" />
			
			<input type="hidden" class="form-control" id="txt_order_no" style="width: 120px" />
			<input type="hidden" class="form-control" id="txt_balju_no" style="width: 120px" />
			<input type="hidden" class="form-control" id="txt_order_detail_seq" style="width: 120px" />
			
			<input type="hidden" class="form-control" id="txt_Cust_damdang" readonly/> 
			<input type="hidden" class="form-control" id="txt_FaxNo" readonly/> 
			<input type="hidden" class="form-control" id="nabpoom_location" readonly/> 
		</td>

		<td style="width:7%; font-weight:900; font-size:14px; vertical-align:middle; text-align:left">
			전화번호
		</td>
		<td style="width:18%; font-weight:900; font-size:14px; vertical-align:middle; text-align:left">
			<input type="text" class="form-control" id="txt_telNo" readonly/>
		</td>
	</tr>
      
	<tr style="background-color: #fff; ">
	    <td style=" font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">발주일자</td>
	    <td style=" font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">
	    	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control" readonly/>
	    </td>
	    <td style=" font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">납기일자</td>
	    <td style=" font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">
	    	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control" readonly/>
	    </td>
	</tr>
</table>

<div id="bom_tbody">
</div>