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
S838S070102.jsp
부자재 입고검사 대장 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ipgo_date = "",
			unsuit_detail = "", improve_action = "",
			person_write_id = "", person_writer = "",
			person_approve_id = "", person_approver = "",
			selected_date = ""; 
			
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");
	
	if(request.getParameter("unsuit_detail") != null)
		unsuit_detail = request.getParameter("unsuit_detail");
	
	if(request.getParameter("improve_action") != null)
		improve_action = request.getParameter("improve_action");
	
	if(request.getParameter("person_write_id") != null)
		person_write_id = request.getParameter("person_write_id");
	
	if(request.getParameter("person_writer") != null)
		person_writer = request.getParameter("person_writer");
	
	if(request.getParameter("person_approve_id") != null)
		person_approve_id = request.getParameter("person_approve_id");
	
	if(request.getParameter("person_approver") != null)
		person_approver = request.getParameter("person_approver");
	
	if(request.getParameter("selected_date") != null)
		selected_date = request.getParameter("selected_date");	
	
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
		$('#ipgo_date').val('<%=ipgo_date%>');
		$('#ipgo_date2').val('<%=ipgo_date%>');
		$('#unsuit_detail').val('<%=unsuit_detail%>');
		$('#improve_action').val('<%=improve_action%>');
		
		$('#ipgo_date').attr('disabled', true);
		
    });
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.ipgo_date = $('#ipgo_date').val();
			dataJson.ipgo_date2 = $('#ipgo_date2').val();
			dataJson.unsuit_detail = $('#unsuit_detail').val();
			dataJson.improve_action = $('#improve_action').val();
			dataJson.person_write_id = '<%=loginID%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S070200E102");
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
					heneSwal.success('입고검사 대장 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(toDate);
	         	} else {
					heneSwal.error('입고검사 대장 수정에 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
	
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			입고일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="ipgo_date" class="form-control">
			<input type="hidden" id="ipgo_date2" class="form-control">
			
		</td>
	</tr>
 	<tr>
		<td>
			부적합사항
		</td>
	    <td>
			<input type="text" id="unsuit_detail" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			개선조치 사항
		</td>
	    <td>
			<input type="text" id="improve_action" class="form-control">
		</td>
	</tr>
	
</table>