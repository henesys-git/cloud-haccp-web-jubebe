<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String[] strColumnHead = {"", "", "", "", ""} ;
		
	String  GV_ORDER_NO="",GV_LOTNO="";
	String  GV_PROD_CD="",GV_PROD_CD_REV="", GV_JOB_ORDER_NO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("job_order_no")== null)
		GV_JOB_ORDER_NO="";
	else
		GV_JOB_ORDER_NO = request.getParameter("job_order_no");
	
	JSONObject jArray = new JSONObject();
	
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M101S030100E805", jArray);
	int ColCount =TableModel.getColumnCount();
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	// 데이터를 가져온다.
	Vector ModelVector = (Vector)(TableModel.getVector().get(0));
	
%>    
    <script type="text/javascript">

//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	
//         $("#txt_StartDate").datepicker({
//         	format: 'yyyy-mm-dd',
//         	autoclose: true,
//         	language: 'ko'
//         });        

//         var today = new Date();
//         var fromday = new Date();
//         fromday.setDate(today.getDate());

//         $('#txt_StartDate').datepicker('update', fromday);

		//주문별 원부자재 재고현황
    	$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040140.jsp",
			data: "OrderNo=" + "<%=GV_ORDER_NO%>" + "&caller=" + "S303S040101" 
				+ "&LotNo=" + "<%=GV_LOTNO%>" ,
			beforeSend: function () {
				$("#partlist_tbody").children().remove();
			},
			success: function (html) {
				$("#partlist_tbody").hide().html(html).fadeIn(100);
			},
           	error: function (xhr, option, error) {
           	}
		});
		
    	//주문별 생산계획 현황
    	$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020110.jsp",
            data: "OrderNo=" + "<%=GV_ORDER_NO%>" + "&LotNo=" + "<%=GV_LOTNO%>" 
            	+ "&prod_cd=" + "<%=GV_PROD_CD%>" + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>",
			beforeSend: function () {
				$("#process_tbody").children().remove();
			},
			success: function (html) {
				$("#process_tbody").hide().html(html).fadeIn(100);
			},
           	error: function (xhr, option, error) {
           	}
		});
		
		//주문별 작업자 현황
		$.ajax({
            type: "POST",
			async: false,
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040160.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo="  + '<%=GV_LOTNO%>'
            	+ "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_cd_rev="  + '<%=GV_PROD_CD_REV%>'
            	+ "&job_order_no=" + '<%=GV_JOB_ORDER_NO%>',
            beforeSend: function () {
                $("#order_worker_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#order_worker_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });		

	    
    });
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
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
    
    
    btn_Print.onclick = function (e) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/S303S040150_print.jsp"
				+ "?OrderNo=" + "<%=GV_ORDER_NO%>" 
				+ "&lotno=" + "<%=GV_LOTNO%>"  
				+ "&prod_cd=" + "<%=GV_PROD_CD%>"  
				+ "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>"  
				+ "&job_order_no=" + "<%=GV_JOB_ORDER_NO%>"  
    	fn_CommonPopup(url, "", 1000, 900);
    	parent.$('#modalReport').hide();
	
	}
    
    
    </script>
    
   	<div style="width:100%; height:750px; overflow:auto;" id="JobOrderDetailTable">
   	<table class="table table-bordered" style="width: 100%;  margin: 0 auto; align:left; ">
   	<tr>   
		<td style="width: 100%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_cust_name" style="width: 150px; float:left" 
		            		value="<%=ModelVector.get(0).toString()%>" readonly />
		           	</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제품명</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >
						<input type="text" class="form-control" id="txt_product_name" style="width: 150px; float:left" 
		            		value="<%=ModelVector.get(1).toString()%>" readonly />
		           	</td>
		           	<td style=" font-weight: 900; font-size:14px; text-align:left">고객사PONO</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >
						<input type="text" class="form-control" id="txt_cust_pono" style="width: 150px; float:left" 
		            		value="<%=ModelVector.get(2).toString()%>" readonly />
		            </td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
		            <td >
		            	<input type="text"  id="txt_order_date" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=ModelVector.get(5).toString()%>" readonly />
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT NO</td>
		            <td> 
		            	<input type="text"  id="txt_lotno" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=ModelVector.get(6).toString()%>" readonly />
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT 수량</td>
		            <td>
		            	<input type="text"  id="txt_lot_count" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=ModelVector.get(7).toString()%>" readonly />
		            </td>		

       
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문번호</td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_OrderNo" class="form-control" style="width: 150px; border: solid 1px #cccccc;"  
		            		value="<%=ModelVector.get(13).toString()%>" readonly />
		            </td>	
		            <td style=" font-weight: 900; font-size:14px; text-align:left">현상태명</td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_process_name" class="form-control" style="width: 150px; border: solid 1px #cccccc;"  
		            		value="<%=ModelVector.get(14).toString()%>" readonly />
		            </td>	 
		            <td style=" font-weight: 900; font-size:14px; text-align:left">납기일</td>
		            <td >
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_delivery_date" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=ModelVector.get(11).toString()%>" readonly />
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">시리얼번호 시작</td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_product_serial_no" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=ModelVector.get(16).toString()%>" readonly />
		            </td>		        
		            <td style=" font-weight: 900; font-size:14px; text-align:left">시리얼번호 끝</td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_product_serial_no_end" class="form-control" style="width: 150px; border: solid 1px #cccccc;"  
		            		value="<%=ModelVector.get(17).toString()%>" readonly />
		            </td>	
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="6">비고</td>
		        </tr>
		        <tr>
		            <td colspan="6"><textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled" ><%=ModelVector.get(15).toString() %> </textarea></td>		           
		        </tr>
		          
        	</table>
        </td>
	</tr>
	
    <tr style="background-color: #fff;" >
        <td style=" font-weight: 900; font-size:14px; text-align:left">
        	<button id="btn_partlist_tbody"  class="btn btn-info" style="width: 100%; text-align:left">주문제품 원부자재 재고현황</button>
        </td>
    </tr>
    <tr style="height: 60px;" >
        <td align="center" colspan="2">
        <div id="partlist_tbody"></div>
        </td>
    </tr>
    
    <tr style="background-color: #fff;" >
        <td style=" font-weight: 900; font-size:14px; text-align:left">
        	<button id="btn_process_tbody"  class="btn btn-info" style="width: 100%; text-align:left">주문별 생산계획 현황</button>
        </td>
    </tr>
    <tr style="height: 60px;" >
        <td align="center" colspan="2">
        <div id="process_tbody"></div>
        </td>
    </tr>
    
    <tr style="background-color: #fff;" >
        <td style=" font-weight: 900; font-size:14px; text-align:left">
        	<button id="btn_order_worker_tbody"  class="btn btn-info" style="width: 100%; text-align:left">주문별 작업자 현황</button>
        </td>
    </tr>
    <tr style="height: 60px;" >
        <td align="center" colspan="2">
        <div id="order_worker_tbody"></div>
        </td>
    </tr>
    
    <tr style="height: 60px;" >
        <td align="center" colspan="2">
        <div id="Suju_SubInfo_List_Doc"></div>
        </td>
    </tr>
  </table>
  </div>
  
<table style="width: 100%;">
	<tr style="height: 40px;">
		<td style="text-align:center;">
			<p>
				<button id="btn_Print"  class="btn btn-info"  >프린트</button>
            	<!-- <button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>    -->
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">닫기</button>
			</p>
		</td>
	</tr>
</table>
