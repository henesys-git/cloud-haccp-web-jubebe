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
S838S015502.jsp
개선조치기록부(HACCP관리)
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", seq_no = "",
			unsuit_date = "", unsuit_detail = "", unsuit_reason = "",
			improve_action1 = "", improve_action2 = "",
			improve_action3 = "", improve_action4 = "",
			person_write_id = "", person_writer = "",
			person_check_id = "", person_checker = "",
			person_approve_id = "", person_approver = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("unsuit_date") != null)
		unsuit_date = request.getParameter("unsuit_date");
	
	if(request.getParameter("unsuit_detail") != null)
		unsuit_detail = request.getParameter("unsuit_detail");
	
	if(request.getParameter("unsuit_reason") != null)
		unsuit_reason = request.getParameter("unsuit_reason");
	
	if(request.getParameter("improve_action1") != null)
		improve_action1 = request.getParameter("improve_action1");
	
	if(request.getParameter("improve_action2") != null)
		improve_action2 = request.getParameter("improve_action2");
	
	if(request.getParameter("improve_action3") != null)
		improve_action3 = request.getParameter("improve_action3");
	
	if(request.getParameter("improve_action4") != null)
		improve_action4 = request.getParameter("improve_action4");
	
	if(request.getParameter("person_write_id") != null)
		person_write_id = request.getParameter("person_write_id");
	
	if(request.getParameter("person_writer") != null)
		person_writer = request.getParameter("person_writer");
	
	if(request.getParameter("person_check_id") != null)
		person_check_id = request.getParameter("person_check_id");
	
	if(request.getParameter("person_checker") != null)
		person_checker = request.getParameter("person_checker");
	
	if(request.getParameter("person_approve_id") != null)
		person_approve_id = request.getParameter("person_approve_id");
	
	if(request.getParameter("person_approver") != null)
		person_approver = request.getParameter("person_approver");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#unsuit_date", 0);
		
		$('#unsuit_date').attr('disabled', true);
		
		$('#unsuit_date').val('<%=unsuit_date%>');
		$('#unsuit_detail').val('<%=unsuit_detail%>');
		$('#unsuit_reason').val('<%=unsuit_reason%>');
		$('#improve_action1').val('<%=improve_action1%>');
		$('#improve_action2').val('<%=improve_action2%>');
		$('#improve_action3').val('<%=improve_action3%>');
		$('#improve_action4').val('<%=improve_action4%>');
    });	
	
	
	function SaveOderInfo() {
        var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		dataJson.seq_no = '<%=seq_no%>';
	 	dataJson.unsuit_date = $('#unsuit_date').val();
	 	dataJson.unsuit_detail = $('#unsuit_detail').val();
	 	dataJson.unsuit_reason = $('#unsuit_reason').val();
	 	dataJson.improve_action1 = $('#improve_action1').val();
	 	dataJson.improve_action2 = $('#improve_action2').val();
	 	dataJson.improve_action3 = $('#improve_action3').val();
	 	dataJson.improve_action4 = $('#improve_action4').val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S015500E102");
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
					heneSwal.success('기록부 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('기록부 수정에 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			부적합 발생일시
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="unsuit_date" class="form-control">
			<input type="hidden" class="form-control" id="seq_no">
		</td>
	</tr>
   	<tr>
 		<td>
			부적합 내용
  		</td>
  		<td>
  			<input type="text" class="form-control" id="unsuit_detail">
  		</td>
  	</tr>
 	<tr>
 		<td>
			부적합 발생원인
  		</td>
  		<td>
  			<input type="text" class="form-control" id="unsuit_reason">
  		</td>
  	</tr>
  	<tr>
		<td>
			개선조치사항1
		</td>
	    <td>
			<input type="text" id="improve_action1" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			개선조치사항2
		</td>
	    <td>
			<input type="text" id="improve_action2" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			개선조치사항3
		</td>
	    <td>
			<input type="text" id="improve_action3" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			개선조치사항4
		</td>
	    <td>
			<input type="text" id="improve_action4" class="form-control">
		</td>
	</tr>
</table>