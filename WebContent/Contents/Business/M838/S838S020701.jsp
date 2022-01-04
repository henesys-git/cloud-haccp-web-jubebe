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
S838S210323_1.jsp
폐기물 처리 기록부 - 등록부분  // 개선조치기록부 카피(M838S015501.jsp)
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_seq_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
%>
<script type="text/javascript">

	$(document).ready(function () {
    	
		new SetSingleDate2("", "#occur_date", 0);

		$("input:radio[name='check_yn']:input[value='Y']").attr("checked",true);
		
		$("#weight").click(function() {
			
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020701_modal.jsp"
						+ '?numStrID=' + $('#weight').attr("id")
						+ '&numStrVal=' + $('#weight').val();
 			var footer = ""; 
			var title = "Numpad";
			var heneModal = new HenesysModal2(url, 'small', title, footer);
			heneModal.open_modal();
			
		});
		
    });	
	
	function SaveOderInfo() {
		
		var flag = true;
		
		$("#bom_table input").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				flag = false;
				return false;
			}
			
		});
		
		if(flag){
			SendTojsp();
		}
	}
	
	function SendTojsp() {
		
		var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
	 	dataJson.occur_date = $('#occur_date').val();
	 	dataJson.waste_nm = $('#waste_nm').val();
	 	dataJson.weight = $('#weight').val();
	 	dataJson.content = $('#content').val();
	 	dataJson.check_yn = $('input:radio[name=check_yn]:checked').val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {

			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data:  {"bomdata" : JSONparam, "pid" : "M838S020700E101"},
				success: function (html) {	
					if(html > -1) {
						heneSwal.success('처리 기록 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
						parent.fn_MainInfo_List(startDate, endDate);
		        		
		         	} else {
						heneSwal.error('처리 기록 등록 실패했습니다, 다시 시도해주세요');
		         	}
		         }
		     });
		}
	}
</script>

<table class="table" id="bom_table" style = "margin-bottom:0;">
	<tr>
		<td>
			폐기물 발생일
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="occur_date" class="form-control">
		</td>
	</tr>
   	<tr>
 		<td>
			폐기물 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="waste_nm">
  		</td>
  	</tr>
 	<tr>
 		<td>
			중량
  		</td>
  		<td>
  			<div class="input-group">
	  			<input type="text" class="form-control" id="weight">
	  			<div class="input-group-append">
				     <span class="input-group-text">kg</span>
		        </div>
	        </div>
  		</td>
  	</tr>
  	<tr>
		<td>
			처리내용
		</td>
	    <td>
			<input type="text" id="content" class="form-control">
		</td>
	</tr>
  	<tr>
		<td>
			수거업체 확인
	    <td>
			<label style = "font-weight: normal !important">예<input type="radio" name="check_yn" value = "Y" style = "margin-left : 7px;"></label> 
			<label style = "font-weight: normal !important"><span style = "margin-left : 27px">아니오</span><input type="radio" name="check_yn"  value = "N" style = "margin-left : 7px;"></label>			
		</td>
	</tr>
</table>