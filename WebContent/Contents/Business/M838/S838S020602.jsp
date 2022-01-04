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
S838S020602.jsp
공정관리 점검표
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_date = "", unsuit_detail = "", improve_action = "" ;
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("unsuit_detail") != null)
		unsuit_detail = request.getParameter("unsuit_detail");
	
	if(request.getParameter("improve_action") != null)
		improve_action = request.getParameter("improve_action");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
%>
<style>
label {
	font-weight: normal !important;
	margin-bottom: 0;
}

td {
	vertical-align:middle !important; 
}

</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#regist_date", 0);
		
		$('#regist_date').attr("disabled", true);

		$('#regist_date').val('<%=regist_date%>');
		$('#unsuit_detail').val('<%=unsuit_detail%>');
		$('#improve_action').val('<%=improve_action%>');
		
    });	
		
	function SaveOderInfo() {
		
        var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
	 	dataJson.regist_date = '<%=regist_date%>';
	 	dataJson.unsuit_detail = $('#unsuit_detail').val();
	 	dataJson.improve_action = $('#improve_action').val();
	 	dataJson.person_write_id = '<%=loginID%>';

	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S020600E102");
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
					heneSwal.success('점검표 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('점검표 등록 수정했습니다, 다시 시도해주세요');
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
			<input type="text" data-date-format="yyyy-mm-dd" id="regist_date" class="form-control">
		</td>
	</tr>
	<tr>
 		<td>
			부적합사항
  		</td>
  		<td>
  			<input type="text" class="form-control" id="unsuit_detail">
  		</td>
  	</tr>
 	<tr>
 		<td>
			개선조치
  		</td>
  		<td>
  			<input type="text" class="form-control" id="improve_action">
  		</td>
  	</tr>
</table>