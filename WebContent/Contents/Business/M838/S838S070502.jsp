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
S838S070502.jsp
중요관리점(CCP) 검증점검표 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", check_date = "";
	
	String person_write_id = "", person_approve_id = "", limit_unsuit = "",
			action_result = "", action_yn = "", check_yn = "",
			check1 = "", check1_detail = "", check2 = "", check2_detail = "",
			check3 = "", check3_detail = "", check4 = "", check4_detail = "",
			check5 = "", check5_detail = "", check6 = "", check6_detail = "",
			check7 = "", check7_detail = "", check8 = "", check8_detail = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	if(request.getParameter("person_write_id") != null)
		person_write_id = request.getParameter("person_write_id");
	
	if(request.getParameter("person_approve_id") != null)
		person_approve_id = request.getParameter("person_approve_id");
	
	if(request.getParameter("limit_unsuit") != null)
		limit_unsuit = request.getParameter("limit_unsuit");
	
	if(request.getParameter("action_result") != null)
		action_result = request.getParameter("action_result");
	
	if(request.getParameter("action_yn") != null)
		action_yn = request.getParameter("action_yn");
	
	if(request.getParameter("check_yn") != null)
		check_yn = request.getParameter("check_yn");
	
	if(request.getParameter("check1") != null)
		check1 = request.getParameter("check1");
	
	if(request.getParameter("check1_detail") != null)
		check1_detail = request.getParameter("check1_detail");
	
	if(request.getParameter("check2") != null)
		check2 = request.getParameter("check2");
	
	if(request.getParameter("check2_detail") != null)
		check2_detail = request.getParameter("check2_detail");
	
	if(request.getParameter("check3") != null) 
		check3 = request.getParameter("check3");
	
	if(request.getParameter("check3_detail") != null)
		check3_detail = request.getParameter("check3_detail");
	
	if(request.getParameter("check4") != null) 
		check4 = request.getParameter("check4");
	
	if(request.getParameter("check4_detail") != null)
		check4_detail = request.getParameter("check4_detail");
	
	if(request.getParameter("check5") != null) 
		check5 = request.getParameter("check5");
	
	if(request.getParameter("check5_detail") != null)
		check5_detail = request.getParameter("check5_detail");
	
	if(request.getParameter("check6") != null) 
		check6 = request.getParameter("check6");
	
	if(request.getParameter("check6_detail") != null)
		check6_detail = request.getParameter("check6_detail");
	
	if(request.getParameter("check7") != null) 
		check7 = request.getParameter("check7");
	
	if(request.getParameter("check7_detail") != null)
		check7_detail = request.getParameter("check7_detail");
	
	if(request.getParameter("check8") != null) 
		check8 = request.getParameter("check8");
	
	if(request.getParameter("check8_detail") != null)
		check8_detail = request.getParameter("check8_detail");
	
	
	JSONObject jArray = new JSONObject();
	
	//check_date = java.time.LocalDate.now().toString();
 	jArray.put("check_date", check_date);
	
    //DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020200E114", jArray);
    //MakeGridData data = new MakeGridData(TableModel);
    
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
		new SetSingleDate2("", "#check_date", 0);
		
		$('#check_date').val('<%=check_date%>');
		$('#check_date').attr('disabled',true);
		
		$('#limit_unsuit').val('<%=limit_unsuit%>');
		$('#action_result').val('<%=action_result%>');
		
		if('<%=check1%>' == 'Y'){
			document.getElementById('check1_y').checked="on" }
		else{
			document.getElementById('check1_n').checked="on" }
		$('#check1_detail').val('<%=check1_detail%>');
		
		if('<%=check2%>' == 'Y'){
			document.getElementById('check2_y').checked="on" }
		else{
			document.getElementById('check2_n').checked="on" }
		$('#check2_detail').val('<%=check2_detail%>');
		
		if('<%=check3%>' == 'Y'){
			document.getElementById('check3_y').checked="on" }
		else{
			document.getElementById('check3_n').checked="on" }
		$('#check3_detail').val('<%=check3_detail%>');
		
		if('<%=check4%>' == 'Y'){
			document.getElementById('check4_y').checked="on" }
		else{
			document.getElementById('check4_n').checked="on" }
		$('#check4_detail').val('<%=check4_detail%>');
		
		if('<%=check5%>' == 'Y'){
			document.getElementById('check5_y').checked="on" }
		else{
			document.getElementById('check5_n').checked="on" }
		$('#check5_detail').val('<%=check5_detail%>');
		
		if('<%=check6%>' == 'Y'){
			document.getElementById('check6_y').checked="on" }
		else{
			document.getElementById('check6_n').checked="on" }
		$('#check6_detail').val('<%=check6_detail%>');
		
		if('<%=check7%>' == 'Y'){
			document.getElementById('check7_y').checked="on" }
		else{
			document.getElementById('check7_n').checked="on" }
		$('#check7_detail').val('<%=check7_detail%>');
		
		if('<%=check8%>' == 'Y'){
			document.getElementById('check8_y').checked="on" }
		else{
			document.getElementById('check8_n').checked="on" }
		$('#check8_detail').val('<%=check8_detail%>');
		
		if('<%=action_yn%>' == 'O'){
			document.getElementById('action_yn_y').checked="on" }
		else{
			document.getElementById('action_yn_n').checked="on" }
		
		if('<%=check_yn%>' == 'O'){
			document.getElementById('check_yn_y').checked="on" }
		else{
			document.getElementById('check_yn_n').checked="on" }
		
    });
    
	
	
	function sendToJsp() {
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(!chekrtn) {
			return false;
		} else {
			var obj = new Object();
			
			obj.person_write_id = "<%=loginID%>";
			obj.checklist_id = '<%=checklist_id%>';
			obj.checklist_rev_no = '<%=checklist_rev_no%>';
			obj.check_date = $('#check_date').val();
			obj.limit_unsuit = $('#limit_unsuit').val();
			obj.action_result = $('#action_result').val();
			obj.check1 = $('input:radio[name="check1"]:checked').val();
			obj.check1_detail = $('#check1_detail').val();
			obj.check2 = $('input:radio[name="check2"]:checked').val();
			obj.check2_detail = $('#check2_detail').val();
			obj.check3 = $('input:radio[name="check3"]:checked').val();
			obj.check3_detail = $('#check3_detail').val();
			obj.check4 = $('input:radio[name="check4"]:checked').val();
			obj.check4_detail = $('#check4_detail').val();
			obj.check5 = $('input:radio[name="check5"]:checked').val();
			obj.check5_detail = $('#check5_detail').val();
			obj.check6 = $('input:radio[name="check6"]:checked').val();
			obj.check6_detail = $('#check6_detail').val();
			obj.check7 = $('input:radio[name="check7"]:checked').val();
			obj.check7_detail = $('#check7_detail').val();
			obj.check8 = $('input:radio[name="check8"]:checked').val();
			obj.check8_detail = $('#check8_detail').val();
			
			obj.action_yn = $('input:radio[name="action_yn"]:checked').val();
			obj.check_yn = $('input:radio[name="check_yn"]:checked').val();
			
			obj = JSON.stringify(obj);
			
			$.ajax({
		        type: "post",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:obj, pid:"M838S070500E102"},
				success: function (html) {
					if(html > -1) {
						heneSwal.success('점검표 수정이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
		         	} else {
						heneSwal.error('점검표 수정 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		}
	}
</script>

<div class="container">
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		점검일자
	  	</div>
	  	<div class="col-4">
		  	<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
	  	</div>
	</div>
	
	<form id="form1">
		<div class="row">
			<div class="col-2 border" id="type01">
			<label class="form-check-label" for="type01">급속동결 공정</label>
			</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="check1">
			      	<label class="form-check-label" for="check1">
			      	종사자가 주기적으로 급냉실 온도를 확인하고 그 내용을 기록하고 있습니까?
			      	</label>	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check1_y" value="Y" checked name="check1">
					  <label class="form-check-label" for="check1_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check1_n" value="N" name="check1">
					  <label class="form-check-label" for="check1_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check1_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check1_detail" style='width:550px;'>
					</div>
		      	</div>
			  	<div class="row border">
			      	<div class="col-7 border" id="check2">
			      	<label class="form-check-label" for="check2">
			      	급냉실 온도계는 연 1회이상 검.교정이 이루어지고 있습니까?
			      	</label>	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check2_y" value="Y" checked name="check2">
					  <label class="form-check-label" for="check2_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check2_n" value="N" name="check2">
					  <label class="form-check-label" for="check2_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check2_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check2_detail" style='width:550px;'>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="check3">
			      	<label class="form-check-label" for="check3">
			      	종사자가 급냉실 온도 확인하는 방법을 정확히 알고 있습니까?
			      	</label>
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check3_y" value="Y" checked name="check3">
					  <label class="form-check-label" for="check3_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check3_n" value="N" name="check3">
					  <label class="form-check-label" for="check3_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check3_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check3_detail" style='width:550px;'>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="check4">
			      	<label class="form-check-label" for="check4">
			      	종사자가 한계기준 이탈 시 실시해야 하는 개선조치 방법을 알고 있으며, 이탈 및 개선조치 내용이 기록되고 있습니까?
			      	</label>	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check4_y" value="Y" checked name="check4">
					  <label class="form-check-label" for="check4_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check4_n" value="N" name="check4">
					  <label class="form-check-label" for="check4_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check4_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check4_detail" style='width:550px;'>
					</div>
				</div>
			</div>
		</div>
	
	
		<div class="row">
			<div class="col-2 border" id="type02">
			<label class="form-check-label" for="type02">금속검출 공정</label>
			</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="check5">
			      		<label class="form-check-label" for="check5">
			      		종사자가 주기적으로 테스트피스를 통해 금속검출기의 감도 이상 유무를 확인하고 있습니까?
			      		</label>
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check5_y" value="Y" checked name="check5">
					  <label class="form-check-label" for="check5_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check5_n" value="N" name="check5">
					  <label class="form-check-label" for="check5_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check5_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check5_detail" style='width:550px;'>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="check6">
			      		<label class="form-check-label" for="check6">
			      		금속검출기는 연 1회 검.교정(또는 정기점검)이 이루어지고 있습니까?
			      		</label>
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check6_y" value="Y" checked name="check6">
					  <label class="form-check-label" for="check6_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check6_n" value="N" name="check6">
					  <label class="form-check-label" for="check6_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check6_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check6_detail" style='width:550px;'>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="check7">
			      		<label class="form-check-label" for="check7">
			      		종사자가 금속검출기 감도를 확인하는 방법을 정확히 알고 있습니까?
			      		</label>
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check7_y" value="Y" checked name="check7">
					  <label class="form-check-label" for="check7_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check7_n" value="N" name="check7">
					  <label class="form-check-label" for="check7_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check7_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check7_detail" style='width:550px;'>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="check8">
			      		<label class="form-check-label" for="check8">
			      		종사자가 한계기준 이탈 시 실시해야 하는 개선조치 방법을 알고 있으며, 이탈 및 개선조치 내용이 기록되고 있습니까?
			      		</label>
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check8_y" value="Y" checked name="check8">
					  <label class="form-check-label" for="check8_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="check8_n" value="N" name="check8">
					  <label class="form-check-label" for="check8_n">N</label>
					</div>
					<div class="row border">
					 <label class="form-check-label" for="check8_detail">상세내용</label>
		      		 <input class="form-input" type="text" id="check8_detail" style='width:550px;'>
					</div>
		      	</div>
			</div>
		</div>
		
	</form>
	
	
	<div class="row border">
		<div class="col-6 border">
			<div class="row border">
				한계기준 이탈내용
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="limit_unsuit">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				개선조치 및 결과
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="action_result">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				조치
			</div>
		    <div class="row border">
		      <div class="col-2 border form-check form-check-inline">
		      	<input class="form-input" type="radio" id="action_yn_y" value="O" checked name="action_yn">
		      	<label class="form-check-label" for="action_yn_y">O</label>
		      </div>
		      <div class="col-2 border form-check form-check-inline">
		      	<input class="form-input" type="radio" id="action_yn_n" value="X" name="action_yn">
		      	<label class="form-check-label" for="action_yn_n">X</label>
		      </div>
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				확인
			</div>
		    <div class="row border">
		      <div class="col-2 border form-check form-check-inline">
		      	<input class="form-input" type="radio" id="check_yn_y" value="O" checked name="check_yn">
		      	<label class="form-check-label" for="check_yn_y">O</label>
		      </div>
		      <div class="col-2 border form-check form-check-inline">
		      	<input class="form-input" type="radio" id="check_yn_n" value="O" name="check_yn">
		      	<label class="form-check-label" for="check_yn_n">X</label>
		      </div>
			</div>
		</div>
	</div>
		
</div>