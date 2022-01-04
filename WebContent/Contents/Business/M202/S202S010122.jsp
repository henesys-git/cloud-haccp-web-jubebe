<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<%
	String loginID = session.getAttribute("login_id").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= {"order_no", "balju_no", "balju_text", "balju_send_date", "cust_cd", "cust_damdang", "tell_no", "fax_no", "balju_nabgi_date", 
		"nabpoom_location", "qa_ter_condtion", "balju_status", "review_no", "confirm_no"};	


	String GV_ORDERNO="",GV_ORDERDETAIL,GV_JSPPAGE,GV_BALJUNO="",GV_LOTNO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL = "";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE = "";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");

	String param =GV_ORDERNO+ "|" + GV_BALJUNO + "|";
	
    TableModel = new DoyosaeTableModel("M202S010100E134", strColumnHead, param);
 	int RowCount =TableModel.getRowCount();
%>

<script type="text/javascript">

	var vTableS202S010140;
	var TableS202S010140_info;
	var TableS202S010140_RowCount;
	var S202S010140_Row_index = -1;
	
    $(document).ready(function () {

		<%if(RowCount>0){%>
			$('#txt_order_no').val('<%=TableModel.getValueAt(0,0).toString().trim()%>');
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010140.jsp", 
            data: "order_no=" + '<%=GV_ORDERNO%>'+ "&balju_no=" + '<%=GV_BALJUNO%>',
	        beforeSend: function () {
	            $("#bom_tbody").children().remove();
	        },
	        success: function (html) {
	            $("#bom_tbody").hide().html(html).fadeIn(100);

// 	            TableS202S010140_info = vTableS202S010140.page.info();
// 	            TableS202S010140_RowCount = TableS202S010140_info.recordsTotal;
    			
	            for(var i=0; i<TableS202S010140_RowCount+1; i++){
	    			$($("#TableS202S010140 tr")[i]).find("td").eq(14).prop('style', 'width:0px; display: none;');
	    			$($("#TableS202S010140 tr")[i]).find("th").eq(14).prop('style', 'width:0px; display: none;');
	            }
	        },
	        error: function (xhr, option, error) {
	        }
 		});

    });

	function SaveOderInfo() {    
		var chekrtn = confirm("완료하시겠습니까?"); 
		
		var parmHead= "" ;
		if(chekrtn){
			parmHead += '<%=GV_JSPPAGE%>'		+ "|"
    				  + '<%=loginID%>'			+ "|"	//주문상세번호 GV_ORDERDETAIL
    				  + '<%=GV_ORDERNO%>'		+ "|"
    				  + '<%=GV_ORDERDETAIL%>'	+ "|"	//주문상세번호
    				  + '0' 					+ "|"	// indGB
    				  + '<%=GV_LOTNO%>'		+ "|"	// lotno
    				  + '<%=member_key%>' + "|"
    				  + '<%=Config.DATATOKEN%>' \
					;	
			SendTojsp(urlencode(parmHead), "M202S010100E122");

		}
	}

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
		        		 vOrderNo = "";  
		        		 vLotNo = "";
		        		DetailInfo_List.click();
		                parent.$("#ReportNote").children().remove();
		         		parent.$('#modalReport').hide();
		         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
 </script>


		<table class="table" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제목</td>
	            <td style="width: 43%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"colspan="3">
					<input type="text" 		class="form-control" id="txt_balju_text""  readonly/>
				</td>
	            <td style="width: 50%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left" colspan="4">
	           	</td>
			</tr>
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수신처</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" 		class="form-control" id="txt_S_CustName"     readonly/>
					<input type="hidden" 	class="form-control" id="txt_S_custcode" style="width: 120px" />
					<input type="hidden" 	class="form-control" id="txt_S_cust_rev" style="width: 120px" />
					
					
					<input type="hidden" 	class="form-control" id="txt_order_no" style="width: 120px" />
					<input type="hidden" 	class="form-control" id="txt_order_detail_seq" style="width: 120px" /> 
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수신인</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
					<input type="text" 		class="form-control" id="txt_Cust_damdang"   readonly/> 
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">전화번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" 		class="form-control" id="txt_telNo"   readonly/>
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">팩스번호</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" 		class="form-control" id="txt_FaxNo"   readonly/> 
	           	</td>
	        </tr>
	        
			<tr  style="background-color: #fff; ">
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">발주일자</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control"  readonly/>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">납기일자</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control"  readonly/>
	            </td>
	
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">납품장소</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text"  class="form-control" id="nabpoom_location"   readonly/>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">품질조건</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<textarea class="form-control" id="txt_qar" style="resize: none;"  readonly></textarea>
	         	</td>
	        </tr>        


      	</table> 

	<div id="bom_tbody">

	</div>
	
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">처리완료</button>
	    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
	</p>

