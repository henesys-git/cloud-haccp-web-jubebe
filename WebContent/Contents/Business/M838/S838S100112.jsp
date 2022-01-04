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
S838S210323_2.jsp
폐기물 처리 기록부 - 수정부분
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", seq_no = "",			
		   regist_date = "", approve_date = "", supply_item = "", 
		   cust_nm = "", cust_address = "", cust_telno = "", approve_reason = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	if(request.getParameter("approve_date") != null)
		approve_date = request.getParameter("approve_date");
	
	if(request.getParameter("supply_item") != "")
		supply_item = request.getParameter("supply_item");
	
	if(request.getParameter("cust_nm") != null)
		cust_nm = request.getParameter("cust_nm");
	
	if(request.getParameter("cust_address") != null)
		cust_address = request.getParameter("cust_address");
		
	if(request.getParameter("cust_telno") != null)
		cust_telno = request.getParameter("cust_telno");

	if(request.getParameter("approve_reason") != null)
		approve_reason = request.getParameter("approve_reason");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
    	new SetSingleDate2("", "#approve_date", 0);
    	
		$('#approve_date').val('<%=approve_date%>'); 
		$('#supply_item').val('<%=supply_item%>');
		$('#cust_nm').val('<%=cust_nm%>');
		$('#cust_address').val('<%=cust_address%>');
		$('#cust_telno').val('<%=cust_telno%>');
		$('#approve_reason').val('<%=approve_reason%>');

    });	
    	
    function inputNullCheck() {

    	let flag = true; 
    	
		$("#bom_table input").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				
				flag = false;
				return false;
			}
			
		})
		
		return flag;
	}
    
	function SaveOderInfo() {
			
		var flag = inputNullCheck();
		
		if(flag){
		
	        var dataJson = new Object();
	        
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.regist_date = '<%=regist_date%>';
		 	dataJson.approve_date = $('#approve_date').val();
		 	dataJson.supply_item = $('#supply_item').val();
		 	dataJson.cust_nm = $('#cust_nm').val();
		 	dataJson.cust_address = $('#cust_address').val();
		 	dataJson.cust_telno = $("#cust_telno").val();
		 	dataJson.approve_reason = $("#approve_reason").val();
		 	dataJson.person_write_id = '<%=loginID%>';
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?");
			
			if(chekrtn) {
								
				SendTojsp(JSONparam, "M838S100100E112");
				
			}
		}
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('처리 명단 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
					
					parent.fn_MainInfo_List(startDate, endDate);
					parent.fn_DetailInfo_List();

	         	} else {
					heneSwal.error('처리 명단 수정에 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
 		<td>
			승인일자
  		</td>
  		<td>
  			<input type="text" data-date-format="yyyy-mm-dd" id="approve_date" class="form-control">
  		</td>
  	</tr>
   	<tr>
 		<td>
			공급 품목
  		</td>
  		<td>
  			<input type="text" id="supply_item" class="form-control">
  		</td>
  	</tr>
 	<tr>
 		<td>
			공급 업체명
  		</td>
  		<td>
  			<input type="text"  id="cust_nm" class="form-control">
  		</td>
  	</tr>
  	<tr>
		<td>
			업체주소
		</td>
	    <td>
			<input type="text" id="cust_address" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			연락처
		</td>
	    <td>
			<input type="text" id="cust_telno" class="form-control">
		</td>
	</tr> 
  	<tr>
		<td>
			승인이유
		</td>
	    <td>
			<input type="text" id="approve_reason" class="form-control">
		</td>
	</tr>
</table>