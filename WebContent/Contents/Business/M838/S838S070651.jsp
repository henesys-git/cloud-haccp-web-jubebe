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
S838S070651.jsp
부적합품 기록부 - 등록부분 
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
%>
    
<style>
#bom_table label {
	font-weight: normal !important;
	margin-right: 5px;
	margin-bottom: 0;
}

#bom_table label input { margin-left: 4px; }

#bom_table td { vertical-align: middle !important; }

.modal-body { padding-bottom: 0; }
</style>    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#regist_date", 0);
		new SetSingleDate2("", "#occur_date", 0);
		new SetSingleDate2("", "#action_date", 0);
		
		$('#regist_date').attr('disabled', true);
		
    });	
	
    function inputNullCheck() {

    	let flag = true; 
    	
		$("#bom_table input").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				
				flag = false;
				return false;
			}
			
		})
		
		if(flag){ SendTojsp(); }
	}
    
	function SendTojsp() {
		
		var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
	 	dataJson.regist_date = $('#regist_date').val();
	 	dataJson.inferior_nm = $('#inferior_nm').val();
	 	dataJson.inferior_gubun = $('input:radio[name="inferior_gubun"]:checked').val();
	 	dataJson.occur_date = $('#occur_date').val();
	 	dataJson.occur_place = $('#occur_place').val();
	 	dataJson.inferior_quantity = $('#inferior_quantity').val();
	 	dataJson.inferior_content = $('#inferior_content').val();
	 	dataJson.inferior_reason = $('#inferior_reason').val();
	 	dataJson.inferior_solution = $('#inferior_solution').val();
	 	dataJson.action_gubun = $('input:radio[name="action_gubun"]:checked').val();
	 	dataJson.action_date = $('#action_date').val();
	 	dataJson.action_quantity = $('#action_quantity').val();
	 	dataJson.action_detail = $('#action_detail').val();
	 	dataJson.result_check_yn = $('input:radio[name="result_check_yn"]:checked').val();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {

			 $.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data:  {"bomdata" : JSONparam, "pid" : "M838S070650E101"},
				success: function (html) {	
					if(html > -1) {
						heneSwal.success('기록표 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
		         	} else {
						heneSwal.error('기록표 등록 실패했습니다, 다시 시도해주세요');
		         	}
		         }
		     });
			
		}
		
	   
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td style = "width: 108px;">
			작성일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="regist_date" class="form-control">
		</td>
		<td style ="width: 88px;">
			품명
  		</td>
  		<td>
  			<input type="text" data-date-format="yyyy-mm-dd" id="inferior_nm" class="form-control">
  		</td>
	</tr>
   	<tr>
 		<td>
			제품유형
  		</td>
  		<td>
  			<label for = "inferior_gubun">원재료<input type = "radio" name = "inferior_gubun" value = "원재료" checked/></label>
  			<label for = "inferior_gubun">포장재<input type = "radio" name = "inferior_gubun" value = "포장재"/></label>
  			<label for = "inferior_gubun">공정품<input type = "radio" name = "inferior_gubun" value = "공정품"/></label>
  			<label for = "inferior_gubun">완제품<input type = "radio" name = "inferior_gubun" value = "완제품"/></label>
  		</td>
  		<td>
			수량
		</td>
	    <td>
			<input type="number" id="inferior_quantity" class="form-control"  min ="0">
		</td>
  	</tr>
 	<tr>
 		<td>
			발생일시
  		</td>
  		<td>
  			<input type="text" data-date-format="yyyy-mm-dd" id="occur_date" class="form-control">
  		</td>
  		<td>
			발생장소
		</td>
	    <td>
			<input type="text" id="occur_place" class="form-control">
		</td>
  	</tr>
  	<tr>
		<td>
			부적합 내용
		</td>
	    <td colspan = 3>
			<input type="text" id="inferior_content" class="form-control">
		</td>
	</tr>    	
  	<tr style = "border-top: 2px ​solid #dee2e6 !important">
		<td>
			부적합 원인
		</td>
	    <td colspan = 3>
			<input type="text" id="inferior_reason" class="form-control">
		</td>
	</tr>   
  	<tr>
		<td>
			대책
		</td>
	    <td colspan = 3>
			<input type="text" id="inferior_solution" class="form-control">
		</td>
	</tr>   
  	<tr>
		<td>
			조치내역
		</td>
	    <td colspan = 3>
			<label for = "action_gubun">재작업<input type = "radio" name = "action_gubun" value = "재작업" checked/></label>
  			<label for = "action_gubun">특채<input type = "radio" name = "action_gubun" value = "특채"/></label>
  			<label for = "action_gubun">반품<input type = "radio" name = "action_gubun" value = "반품"/></label>
  			<label for = "action_gubun">폐기<input type = "radio" name = "action_gubun" value = "폐기"/></label>
		</td>
	</tr>   
  	<tr>
		<td>
			처리일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="action_date" class="form-control">
		</td>
		<td>
			처리량
		</td>
	    <td>
			<input type="number" id="action_quantity" class="form-control" min ="0">
		</td>
	</tr> 
  	<tr>
		<td>
			처리내용
		</td>
	    <td colspan = 3>
			<input type="text" id="action_detail" class="form-control">
		</td>
	</tr>   
  	<tr>
		<td>
			결과 확인
		</td>
	    <td colspan = 3>
			<label for = "result_check_yn">적합<input type = "radio" name = "result_check_yn" value = "Y" checked/></label>
  			<label for = "result_check_yn">부적합<input type = "radio" name = "result_check_yn" value = "N"/></label>
		</td>
	</tr>
</table>