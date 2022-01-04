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
S838S015312.jsp
CCP-2P 측정일지 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String seq_no = "", check_time = "", remarks = "";
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");	

	if(request.getParameter("check_time") != null)
		check_time = request.getParameter("check_time");	

	if(request.getParameter("remarks") != null)
		remarks = request.getParameter("remarks");	
	
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	$('#check_time').val('<%=check_time%>');
		$('#remarks').val('<%=remarks%>');
		$("#check_time").attr("disabled", true);		
    });
    
    function SendTojsp() {
    	
        var dataJson = new Object();
        
        dataJson.seq_no = '<%=seq_no%>';
        dataJson.check_time = '<%=check_time%>';
		dataJson.remarks = $('#remarks').val();
		
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn) {

			 $.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data:  {"bomdata" : JSONparam, "pid" : "M838S015300E112"},
				success: function (html) {	
					if(html > -1) {
						heneSwal.success('측정일지 수정이 완료되었습니다');
		
						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.fn_DetailInfo_List();
		         	} else {
						heneSwal.error('측정일지 수정 실패했습니다, 다시 시도해주세요');	         		
		         	}
		         }
		     });
		}
	
	}

</script>

<table class="table" id="bom_table">
	<tr>
		<td>측정시각</td>
	    <td>
			<input type="time" id="check_time" class="form-control">	
		</td>
	</tr>
	<tr>
		<td>점검결과 특이사항</td>
	    <td>
			<input type="text" id="remarks" class="form-control">
		</td>
	</tr>
</table>