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
S838S020512.jsp
외부인출입자 관리대장 명단 수정
*/
/* 	String loginID = session.getAttribute("login_id").toString(); */
	
	String regist_seq_no = "", seq_no = "", visit_date = "", company = "", visitor_name = "", 
		   visit_purpose = "", visit_time = "", disease_checkyn = "", confirm_check = "";
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");

	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	if(request.getParameter("visit_date") != null)
		visit_date = request.getParameter("visit_date");
	
	if(request.getParameter("company") != null)
		company = request.getParameter("company");
	
	if(request.getParameter("visitor_name") != null)
		visitor_name = request.getParameter("visitor_name");
	
	if(request.getParameter("visit_purpose") != null)
		visit_purpose = request.getParameter("visit_purpose");
	
	if(request.getParameter("visit_time") != null)
		visit_time = request.getParameter("visit_time");
	
	if(request.getParameter("disease_checkyn") != null)
		disease_checkyn = request.getParameter("disease_checkyn");
	
	if(request.getParameter("confirm_check") != null)
		confirm_check = request.getParameter("confirm_check");
	
	if("양호".equals(disease_checkyn))
		disease_checkyn = "O";
	else 
		disease_checkyn = "X";
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("<%=visit_date%>", "#visit_date", 0);
		
		$('#company').val('<%=company%>');
		$('#visitor_name').val('<%=visitor_name%>');
		$('#visit_purpose').val('<%=visit_purpose%>');
		$('#visit_time').val('<%=visit_time%>');
		$('input:radio[name="disease_checkyn"]:input[value="'+'<%=disease_checkyn%>'+'"]').attr("checked",true);
		$('input:radio[name="confirm_check"]:input[value="'+'<%=confirm_check%>'+'"]').attr("checked",true);
		
		$('#confirm_check').attr('disabled',true);
		
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
	        							
			dataJson.visit_date = $('#visit_date').val();
			dataJson.company = $('#company').val();
			dataJson.visitor_name = $('#visitor_name').val();
			dataJson.visit_purpose = $('#visit_purpose').val();
			dataJson.purpose= $('#purpose').val();	
			dataJson.visit_time = $('#visit_time').val();
			dataJson.disease_checkyn = $('input:radio[name="disease_checkyn"]:checked').val();
			dataJson.confirm_check =  $('input:radio[name="confirm_check"]:checked').val();
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.regist_seq_no = '<%=regist_seq_no%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020500E112");
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
					heneSwal.success('관리대장 명단 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	         	} else {
					heneSwal.error('관리대장 명단 수정 실패했습니다, 다시 시도해주세요');	         		
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