<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	
	String seq_no = "", regist_date = "",
			unsuit_place = "", standard_unsuit = "", improve_action = "", action_result = "";
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	if(request.getParameter("unsuit_place") != null)
		unsuit_place = request.getParameter("unsuit_place");
	
	if(request.getParameter("standard_unsuit") != null)
		standard_unsuit = request.getParameter("standard_unsuit");
	
	if(request.getParameter("improve_action") != null)
		improve_action = request.getParameter("improve_action");
	
	if(request.getParameter("action_result") != null)
		action_result = request.getParameter("action_result");
%> 
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("<%=regist_date%>", "#regist_date", 0);
		
		$("#regist_date").attr("disabled",true);
		
	 	$("#unsuit_place").val('<%=unsuit_place%>');
	 	$("#standard_unsuit").val('<%=standard_unsuit%>');
	 	$("#improve_action").val('<%=improve_action%>');
	 	$("#action_result").val('<%=action_result%>');
		
    });	
	
	function SaveOderInfo() {
		
        var dataJson = new Object();
        
        dataJson.seq_no ='<%=seq_no%>';
	 	dataJson.regist_date ='<%=regist_date%>';
	 	dataJson.unsuit_place = $("#unsuit_place").val();
	 	dataJson.standard_unsuit = $("#standard_unsuit").val();
	 	dataJson.improve_action = $("#improve_action").val();
	 	dataJson.action_result = $("#action_result").val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S020400E112");
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
					heneSwal.success('이상 기록 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List(startDate, endDate);
					parent.fn_DetailInfo_List();
	         	} else {
					heneSwal.error('이상 기록 수정 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<form id = "formTest" >
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
		    	이상장소
	    	</td>
	    	<td>
				<input type="text"  id="unsuit_place" class="form-control">
			</td>
	  	</tr>
	  	<tr>
	 		<td>
		    	기준이탈
	    	</td>
	    	<td>
				<input type="text"  id="standard_unsuit" class="form-control">
			</td>
	  	</tr>
	  	<tr>
	 		<td>
		    	개선조치 내역
	    	</td>
	    	<td>
				<input type="text"  id="improve_action" class="form-control">
			</td>
	  	</tr>
	  	<tr>
	 		<td>
		    	조치결과
	    	</td>
	    	<td>
				<input type="text"  id="action_result" class="form-control">
			</td>
	  	</tr>
	</table>
</form>