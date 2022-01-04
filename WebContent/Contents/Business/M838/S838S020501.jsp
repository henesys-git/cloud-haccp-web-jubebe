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
S838S020501.jsp
외부인 출입자 관리대장 등록
*/
	String loginID = session.getAttribute("login_id").toString(); 
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
	    var heneDate = new HeneDate();
	    var sysTime = heneDate.getDateTime().slice(11,-3); 
	    new SetSingleDate2("", "#visit_date", 0);

	    $("#visit_time").val(sysTime);
	    $("input:radio:input[value='O']").attr("checked", true);  	
    });
	
	function SaveOderInfo() {
    	
		var flag = true;
		
		$("#out_table input").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				flag = false;
				return false;
			}
			
		});
		
		if(flag){
			var dataJson = new Object();
	        
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.visit_date = $("#visit_date").val();
			dataJson.company = $("#company").val();
			dataJson.visitor_name = $("#visitor_name").val();
			dataJson.visit_purpose = $("#visit_purpose").val();
			dataJson.visit_time = $("#visit_time").val();
			dataJson.disease_checkyn = $('input:radio[name="disease_checkyn"]:checked').val();
			dataJson.confirm_check =  $('input:radio[name="confirm_check"]:checked').val();
			dataJson.person_write_id = '<%=loginID%>';
			
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020500E101");
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
					heneSwal.success('관리대장 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	         	} else {
					heneSwal.error('관리대장 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
	
</script>

<table class="table" id="out_table">
	<tr>
		<td>
			출입일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="visit_date" class="form-control">
		</td>
	</tr>
 	<tr>
		<td>
			업체명
		</td>
	    <td>
			<input type="text" id="company" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			성명
		</td>
	    <td>
			<input type="text" id="visitor_name" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			출입목적
		</td>
	    <td>
			<input type="text" id="visit_purpose" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			방문시간
		</td>
	    <td>
			<input type="time" id="visit_time" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			건강이상유무
		</td>
	    <td>
			<input type="radio" name="disease_checkyn" value = "O"> 양호
			<input type="radio" name="disease_checkyn" value = "X"> 이상있음
		</td>
	</tr>
	<tr>
		<td>
			확인
		</td>
	    <td>
			<input type="radio" name="confirm_check" value = "O"> O
			<input type="radio" name="confirm_check" value = "X"> X
		</td>
	</tr>
</table>