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
S838S015102.jsp
CCP 1B 모니터링 일지 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "",
			limit_unsuit = "", improve_action_result  ="",
			person_write_id = "", person_writer = "",
			person_check_id = "", person_checker = "", 
			person_approve_id = "", person_approver = "",
			person_improve_id = "", person_improver = "";
	
	String record_time = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	if(request.getParameter("limit_unsuit") != null)
		limit_unsuit = request.getParameter("limit_unsuit");
	
	if(request.getParameter("improve_action_result") != null)
		improve_action_result = request.getParameter("improve_action_result");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	if(request.getParameter("person_write_id") != null)
		person_write_id = request.getParameter("person_write_id");
	
	if(request.getParameter("person_writer") != null)
		person_writer = request.getParameter("person_writer");
	
	if(request.getParameter("person_approve_id") != null)
		person_approve_id = request.getParameter("person_approve_id");
	
	if(request.getParameter("person_approver") != null)
		person_approver = request.getParameter("person_approver");
	
	if(request.getParameter("person_improve_id") != null)
		person_improve_id = request.getParameter("person_improve_id");
	
	if(request.getParameter("person_improver") != null)
		person_improver = request.getParameter("person_improver");
	
	if(request.getParameter("person_check_id") != null)
		person_check_id = request.getParameter("person_check_id");
	
	if(request.getParameter("person_checker") != null)
		person_checker = request.getParameter("person_checker");
	
	if(request.getParameter("record_time") != null)
		record_time = request.getParameter("record_time");	
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
    	$('#ccp_date').attr('disabled', true);
    	
    	$('#ccp_date').val('<%=ccp_date%>');
    	$('#record_time').val('<%=record_time%>');
<%--   
    	$('#limit_unsuit').val('<%=limit_unsuit%>');
    	$('#improve_action_result').val('<%=improve_action_result%>');
 --%>    	
		
    });
	
    function SaveOderInfo() {
    	
        var dataJson = new Object();
        
									
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		dataJson.ccp_date = $('#ccp_date').val();
		dataJson.record_time = $('#record_time').val();
/* 		
		dataJson.limit_unsuit = $('#limit_unsuit').val();
		dataJson.improve_action_result = $('#improve_action_result').val();
 */		
		dataJson.person_write_id = '<%=loginID%>';
		
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S015100E102");
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
				heneSwal.success('모니터링 일지 수정이 완료되었습니다');

				$('#modalReport').modal('hide');
        		parent.fn_MainInfo_List(startDate, endDate);
         	} else {
				heneSwal.error('모니터링 일지 수정 실패했습니다, 다시 시도해주세요');	         		
         	}
         }
     });
}

</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			작성일자
		</td>
    	<td>
		<input type="text" data-date-format="yyyy-mm-dd" id="ccp_date" class="form-control">
		
		</td>
	</tr>
	<tr>
		<td>
			기록검증 시간
		</td>
    	<td>
		<input type="time" id="record_time" class="form-control">
		</td>
	</tr>
<!-- 	
	<tr>
		<td>
			한계기준 이탈내용
		</td>
   	 	<td>
		<input type="text" id="limit_unsuit" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			개선조치 및 결과
		</td>
    	<td>
		<input type="text" id="improve_action_result" class="form-control">
		</td>
	</tr>
	 -->
</table>