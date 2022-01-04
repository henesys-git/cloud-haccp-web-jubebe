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
S838S020902.jsp
제조시설 및 설비점검표 - 수정부분
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String regist_date = "", occur_time = "", occur_place = "", unsuit_detail = "", improve_action = "";

	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	if(request.getParameter("occur_time") != null)
		occur_time = request.getParameter("occur_time");
	
	if(request.getParameter("occur_place") != null)
		occur_place = request.getParameter("occur_place");
	
	if(request.getParameter("unsuit_detail") != "")
		unsuit_detail = request.getParameter("unsuit_detail");
	
	if(request.getParameter("improve_action") != null) 
		improve_action = request.getParameter("improve_action"); 
	
	String mm_gubun = regist_date.substring(0,7);
	
%>
    
<script type="text/javascript">
    $(document).ready(function () {

		$("#regist_date").attr("disabled", true);
		
		$('#occur_time').val('<%=occur_time%>'); 
		$('#occur_place').val('<%=occur_place%>');
		$('#unsuit_detail').val('<%=unsuit_detail%>');
		$('#improve_action').val('<%=improve_action%>');
			
    });	
    	
	function SaveOderInfo() {
		
        var dataJson = new Object();
        
	 	dataJson.regist_date = '<%=regist_date%>';
	 	dataJson.occur_time = $('#occur_time').val();
	 	dataJson.occur_place = $('#occur_place').val();
	 	dataJson.unsuit_detail = $('#unsuit_detail').val();
	 	dataJson.improve_action = $('#improve_action').val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S020900E102");
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
					heneSwal.error('점검표 수정에 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			구분
		</td>
	    <td>
			<input type="text" id="regist_date" class="form-control" value = '<%=mm_gubun%>'>
		</td>
	</tr>
   	<tr>
 		<td>
			발생 시간
  		</td>
  		<td>
  			<input type="time" class="form-control" id="occur_time">
  		</td>
  	</tr>
 	<tr>
 		<td>
			발생 장소
  		</td>
  		<td>
  			<input type="text" class="form-control" id="occur_place">
  		</td>
  	</tr>
  	<tr>
		<td>
			이탈사항
		</td>
	    <td>
			<input type="text" id="unsuit_detail" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			조치방법
		<td>
			<input type="text" id="improve_action" class="form-control">
		</td>
	</tr>
</table>