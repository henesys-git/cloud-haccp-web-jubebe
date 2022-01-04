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
S838S015112.jsp
CCP1B 모니터링일지 측정일지 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "", check_time ="", seq_no = "";
	
	String remarks = "";
		
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	if(request.getParameter("check_time") != null)
		check_time = request.getParameter("check_time");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("remarks") != null)
		remarks = request.getParameter("remarks");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		$('#check_time').val('<%=check_time%>');
		
		$("#check_time").attr("disabled", true);

    });
 	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        			
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.remarks = $('#remarks').val();
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.ccp_date = '<%=ccp_date%>;'
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S015100E112");
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
					heneSwal.success('측정일지 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	         	} else {
					heneSwal.error('측정일지 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			측정시각
		</td>
	    <td>
			<input type="time" id="check_time" class="form-control">	
		</td>
	</tr>
	<tr>
		<td>
			점검결과 특이사항
		</td>
	    <td>
			<input type="text" id="remarks" class="form-control">
		</td>
	</tr>
</table>