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
S101S040103.jsp
출하정보 삭제
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_CHULHANO="", GV_JSPPAGE="",
			GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("OrderDetail")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetail");
	
	if(request.getParameter("ChulhaNo")== null)
		GV_CHULHANO="";
	else
		GV_CHULHANO = request.getParameter("ChulhaNo");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
%>

<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S040100E103 = {
			PID:  "M101S040100E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S040100E103",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS101S040145;
    var S101S040145_Row_index = -1;
	var TableS101S040145_info;
    var TableS101S040145_RowCount;
    var TableS101S040145_Prev_RowCount = 0;
    
    $(document).ready(function () {
        fn_Chulha_List();
    });
    
    function fn_Chulha_List(){
    	$.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040145.jsp",  
	        data: "order_no=" +  '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>'
	        	  + "&chulha_no=" +  '<%=GV_CHULHANO%>' + "&mode=delete" + "&lotno=" + '<%=GV_LOTNO%>'
	        	  + "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_rev=" + '<%=GV_PROD_REV%>',
	        beforeSend: function () {
	            $("#inspect_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_body").hide().html(html).fadeIn(100);
	        }
 		});
    }
	
	function SaveOderInfo() {		
		
		if(S101S040145_Row_index == -1){
    		alert("삭제할 항목을 선택하세요");
    	} else {
    		var dataJson = new Object();
    		dataJson.chulha_no			= vTableS101S040145.cell(S101S040145_Row_index , 8).data(); 	// chulha_no
    		dataJson.order_no			= vTableS101S040145.cell(S101S040145_Row_index , 9).data(); 	// order_no
    		dataJson.order_detail_seq	= vTableS101S040145.cell(S101S040145_Row_index , 10).data(); 	// order_detail_seq
    		dataJson.chulha_seq			= vTableS101S040145.cell(S101S040145_Row_index , 26).data(); 	// chulha_seq
    		dataJson.lotno				= vTableS101S040145.cell(S101S040145_Row_index , 3).data(); 	// lotno
    		dataJson.prod_cd 			= vTableS101S040145.cell(S101S040145_Row_index , 2).data(); 	//prod_cd
	    	dataJson.prod_rev 			= vTableS101S040145.cell(S101S040145_Row_index , 14).data();	//prod_rev
    		dataJson.product_serial_no	= vTableS101S040145.cell(S101S040145_Row_index , 13).data(); 	// product_serial_no
    		dataJson.bigo	= vTableS101S040145.cell(S101S040145_Row_index , 16).data(); 	// chulha_bigo
    		dataJson.member_key				= '<%=member_key %>';

 			var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)

 			var chekrtn = confirm("삭제하시겠습니까?"); 
 			
 			if(chekrtn){
 			SendTojsp(JSONparam, SQL_Param.PID);
 			}
    	}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
		type: "POST",
			dataType: "json",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			data: {"bomdata" : bomdata, "pid" : pid },
			success: function (html) {	
	        	if(html > -1){
	        		fn_Chulha_List();
	        		parent.SubInfo_TradingList.click();
	        		vChulhaNo = "";
	        		clear_input();
	         	}
	    	}
		});		
	} 
	
	function clear_input(obj){
		$('#txt_product_nm').val("");
		$('#txt_prod_cd').val("");
		$('#txt_lotno').val("");
		$('#txt_lot_count').val("");
		$('#txt_chulha_cnt').val("");
		$('#txt_chulha_unit').val("");
		$('#txt_chulha_unit_price').val("");
		$('#txt_chulha_amount').val("");
		$('#txt_order_bigo').val("");
		S101S040145_Row_index = -1;
	}
</script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문명</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_project_name"  readonly></input>
            </td>            
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_nm"  readonly></input>
            </td>
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사 Po</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_pono"  readonly></input>
            </td>
            <td style="width: 9%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT수량</td>
            <td style="width: 5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_count"  readonly></input>
            </td>
            <td style="width: 6%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 16%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_no"  readonly></input>
            </td>
		</tr>
		<tr  style="background-color: #fff; ">
			<td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">주문비고</td>
            <td colspan="5">
            	<textarea class="form-control" id="txt_order_bigo" style="height:82px;resize: none;" readonly ></textarea>
            </td>
            <td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하비고</td>
            <td colspan="5">
            	<textarea class="form-control" id="txt_chulha_bigo" style="height:82px;resize: none;" readonly></textarea>
            </td>
        </tr>        
      	</table>
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="bom_table">
	        <tr style="vertical-align: middle">
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">Lot No</td>
				<td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일련번호</td>
				<td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고 수량</td>
	            <td style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단위</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td>
	        </tr>
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        		<input type="hidden" class="form-control" id="txt_chulha_no" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chulha_seq" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_prod_rev" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_cust_cd" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_cust_rev" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chuha_dt" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chulha_user_id" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_delivery_date" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_order_date" readonly></input>
	        		<input type="text" class="form-control" id="txt_product_nm" readonly></input>					
				</td>		           
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_prod_cd"  readonly></input> 
	           	</td>
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_lotno" readonly></input>
				</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="hidden" 	 class="form-control" id="txt_lot_count" readonly ></input> 
					<input type="hidden" class="form-control" maxlength="50" id="txt_product_serial_no_end"  readonly></input>
					<input type="text" class="form-control" maxlength="50" id="txt_product_serial_no"  readonly></input>	           
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_chulha_cnt" readonly ></input>	           
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0; width:0%; display: none;">
					<input type="text" class="form-control" id="txt_chulha_unit" readonly></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_unit_price" readonly></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_amount" readonly></input>
	           	</td>
	        </tr>
	        </tbody>
	    </table>
		<table style="width: 100%;">
			<tr>
				<td>
					<div>
						<div id="inspect_body" style="width:100%; float:left;"></div>
					</div>
				</td>
			</tr>
			<!-- <tr style="height: 60px;">
				<td style="text-align:center;">
					<p>
                		<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">삭제</button>
                		<button id="btn_Canc" class="btn btn-info" onclick="parent.$('#modalReport').hide();">닫기</button>
            		</p>
				</td>
            </tr> -->
        </table>
		