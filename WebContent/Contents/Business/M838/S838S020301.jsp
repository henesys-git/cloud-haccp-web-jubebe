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
S838S020301.jsp
자동기록관리 시스템 수정일지 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#unsuit_date", 0);
		
		
    });	
	
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.unsuit_date = $('#unsuit_date').val();
			dataJson.unsuit_detail = $('#unsuit_detail').val();
			dataJson.unsuit_reason = $('#unsuit_reason').val();
			dataJson.improve_action = $('#improve_action').val();	
			dataJson.improve_action_check = $('#improve_action_check').val();
			dataJson.person_write_id = '<%=loginID%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020300E101");
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
					heneSwal.success('수정일지 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('수정일지 등록에 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			발생일시
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="unsuit_date" class="form-control">
		</td>
	</tr>
   	<tr>
 		<td>
			발생내용
  		</td>
  		<td>
  			<input type="text" class="form-control" id="unsuit_detail"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			발생원인
  		</td>
  		<td>
  			<input type="text" class="form-control" id="unsuit_reason"/>
  		</td>
  	</tr>
  	<tr>
		<td>
			개선 조치사항
		</td>
	    <td>
			<input type="text" id="improve_action" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			개선 조치사항 확인
		</td>
	    <td>
			<input type="text" id="improve_action_check" class="form-control">
		</td>
	</tr>
	
</table>