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
S838S020601.jsp
공정관리 점검표
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
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
		
		$('input:radio:input[value="Y"]').attr("checked", true);
		
		$("#check_time").change(function() {
			
			var check_date = $("#regist_date").val();
			var check_time = $(this).val()
			
			var dataAjax = {
							"check_date": check_date,
							"check_time": check_time
						  };
			
			dataAjax = JSON.stringify(dataAjax);
			
			 $.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		        data:  {"prmtr" : dataAjax, "pid" : "M838S020600E124"},
				success: function (data) {	
					if(data.length > 1) {
						console.log(data);
						// 작업실 온도[temp_dev02 : 작업장]
						$("#temp_processing1").val(data[0][4]);
						$("#temp_processing2").val(data[0][4]);
						$("#temp_packing").val(data[0][4]);
						
						// 해동실 온도[temp_dev10 : 해동실]
						$("#temp_defrosting").val(data[5][4]);
						
						// 냉동실 온도[temp_dev05 : 원우냉동실]
						$("#temp_frosting").val(data[1][4]);
		         	} else {
						heneSwal.error('정확한 일자와 점검시간을 선택해주세요.');
		         	}
		         }
		     });
			
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
	 	dataJson.regist_date = $('#regist_date').val();
	 	dataJson.check_time = $('#check_time').val();
	 	dataJson.temp_processing1 = $('#temp_processing1').val();
	 	dataJson.temp_processing2 = $('#temp_processing2').val();
	 	dataJson.temp_packing = $('#temp_packing').val();
	 	dataJson.temp_prod = $('#temp_prod').val();
	 	dataJson.mixing_hour_yn = $('input[name=mixing_hour_yn]:checked').val();
	 	dataJson.clean_status_yn = $('input[name=clean_status_yn]:checked').val();
	 	dataJson.appearance_yn = $('input[name=appearance_yn]:checked').val();
	 	dataJson.packing_hour_yn = $('input[name=packing_hour_yn]:checked').val();
	 	dataJson.packing_status_yn = $('input[name=packing_status_yn]:checked').val();
	 	dataJson.indication_comply_yn = $('input[name=indication_comply_yn]:checked').val();
	 	dataJson.expiration_date_yn = $('input[name=expiration_date_yn]:checked').val();
	 	dataJson.temp_defrosting = $('#temp_defrosting').val();
	 	dataJson.defrosting_yn = $('input[name=defrosting_yn]:checked').val();
	 	dataJson.temp_frosting = $('#temp_frosting').val();
	 	dataJson.unsuit_detail = $('#unsuit_detail').val();
	 	dataJson.improve_action = $('#improve_action').val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data:  {"bomdata" : JSONparam, "pid" : "M838S020600E101"},
				success: function (html) {	
					if(html > -1) {
						heneSwal.success('점검표 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
		         	} else {
						heneSwal.error('점검표 등록 실패했습니다, 다시 시도해주세요');
		         	}
		         }
		     });
			
		}
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td style="width: 24%;">
			작성일자
		</td>
	    <td colspan = 2>
			<input type="text" data-date-format="yyyy-mm-dd" id="regist_date" class="form-control" required="required">
		</td>
	</tr>
	<!--  -->
	<tr style = "display: none">
		<td>
			작업점검일시
		</td>
	    <td>
	    	오전
			<input type="radio" data-date-format="yyyy-mm-dd" name="ampm_gubun">
			오후
			<input type="radio" data-date-format="yyyy-mm-dd" name="ampm_gubun">
		</td>
	</tr>
	<tr>
		<td>
			점검시간
		</td>
	    <td colspan = 2>
			<input type="time" id="check_time" class="form-control" required="required">
		</td>
	</tr>
	<tr>
		<td rowspan = 3>작업실<br>온도</td>
		<td style="width: 29%;">
			가공실(1구역)
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_processing1" class="form-control" readonly />
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
		<td>
			가공실(2구역)
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_processing2" class="form-control" readonly />
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
		<td>
			포장실
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_packing" class="form-control" readonly />
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
		<td>
			제품<br>심부온도
		</td>
		<td>
			심부온도
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_prod" class="form-control" required="required"/>
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
		<td rowspan = 2>
			혼합<br>(텀블러)
		</td>
		<td>
			작업시간
		</td>
	    <td>
	    	<label>
				적합&nbsp;
				<input type="radio" name="mixing_hour_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="mixing_hour_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td>
			청결상태
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="clean_status_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="clean_status_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td rowspan = 3>
			포장 
		</td>
		<td>
			성상
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="appearance_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="appearance_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td>
			작업시간
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="packing_hour_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="packing_hour_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td>
			포장상태
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="packing_status_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="packing_status_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td rowspan = 2>
			표기사항
		</td>
		<td>
			표기사항 준수
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="indication_comply_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="indication_comply_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td>
			유통기한
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="expiration_date_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="expiration_date_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td rowspan = 2>
			해동보관
		</td>
		<td>
			해동실 온도
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_defrosting" class="form-control" readonly />
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
		<td>
			해동육<br>식별표시 부착
		</td>
	    <td>
			<label>
				적합&nbsp;
				<input type="radio" name="defrosting_yn" value = "Y">
			</label>
			&nbsp;
			<label>
				부적합&nbsp;
				<input type="radio" name="defrosting_yn" value = "N">
			</label>
		</td>
	</tr>
	<tr>
		<td>
			냉동보관
		</td>
		<td>
			냉동실 온도
		</td>
	    <td>
			<div class="input-group">
				<input type="text"  id="temp_frosting" class="form-control" readonly />
				<div class="input-group-append">
				     <span class="input-group-text">&#8451;</span>
		        </div>
		    </div>
		</td>
	</tr>
	<tr>
 		<td>
			부적합사항
  		</td>
  		<td colspan = 2>
  			<textarea id="unsuit_detail" class="form-control"></textarea>
  		</td>
  	</tr>
 	<tr>
 		<td>
			개선조치
  		</td>
  		<td colspan = 2>
  			<textarea id="improve_action" class="form-control"></textarea>
  		</td>
  	</tr>
</table>