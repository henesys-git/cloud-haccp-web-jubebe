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
S838S070212.jsp
부자재 입고검사 대장 부자재 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", seq_no = "",
		   ipgo_date = "", part_cd = "", part_rev_no = "", part_nm = "",
		   trace_key = "", standard_yn = "", packing_status = "", visual_inspection = "",
		   car_clean = "", docs_yn ="",
		   unsuit_action  = "", check_yn = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");
	
	if(request.getParameter("part_cd") != null)
		part_cd = request.getParameter("part_cd");
	
	if(request.getParameter("part_rev_no") != null)
		part_rev_no = request.getParameter("part_rev_no");
	
	if(request.getParameter("part_nm") != null)
		part_nm = request.getParameter("part_nm");
	
	if(request.getParameter("trace_key") != null)
		trace_key = request.getParameter("trace_key");
	
	if(request.getParameter("standard_yn") != null)
		standard_yn = request.getParameter("standard_yn");
	
	if(request.getParameter("packing_status") != null)
		packing_status = request.getParameter("packing_status");
	
	if(request.getParameter("visual_inspection") != null)
		visual_inspection = request.getParameter("visual_inspection");
	
	if(request.getParameter("car_clean") != null)
		car_clean = request.getParameter("car_clean");
	
	if(request.getParameter("docs_yn") != null)
		docs_yn = request.getParameter("docs_yn");
	
	if(request.getParameter("unsuit_action") != null)
		unsuit_action = request.getParameter("unsuit_action");
	
	if(request.getParameter("check_yn") != null)
		check_yn = request.getParameter("check_yn");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#ipgo_date", 0);
		
		$('#seq_no').val('<%=seq_no%>');
		$('#ipgo_date').val('<%=ipgo_date%>');
		$('#part_cd').val('<%=part_cd%>');
		$('#part_rev_no').val('<%=part_rev_no%>');
		$('#part_nm').val('<%=part_nm%>');
		$('#trace_key').val('<%=trace_key%>');
		$('#standard_yn').val('<%=standard_yn%>');
		$('#packing_status').val('<%=packing_status%>');
		$('#visual_inspection').val('<%=visual_inspection%>');
		$('#car_clean').val('<%=car_clean%>');
		$('#docs_yn').val('<%=docs_yn%>');
		$('#unsuit_action').val('<%=unsuit_action%>');
		$('#check_yn').val('<%=check_yn%>');
		
		$('#ipgo_date').attr('disabled', true);
		
		$('#part_nm').click(function() {
			pop_fn_PartIpgo_View('<%=ipgo_date%>', 02)
		});
		
		if('<%=standard_yn%>' == '적합'){
			document.getElementById('standard_yn_y').checked="on"}
			else{
			document.getElementById('standard_yn_n').checked="on"
			}
	    
	    if('<%=packing_status%>' == '적합'){
			document.getElementById('packing_status_y').checked="on"}
			else{
			document.getElementById('packing_status_n').checked="on"}
	    	
	    if('<%=visual_inspection%>' == '양호'){
	    	document.getElementById('visual_inspection_y').checked="on"}
	    	else{
	    	document.getElementById('visual_inspection_n').checked="on"}
	    	
	    if('<%=car_clean%>' == '양호'){
	        document.getElementById('car_clean_y').checked="on"}
	        else{
	        document.getElementById('car_clean_n').checked="on"}
	    	
	    if('<%=docs_yn%>' == '유'){
	        document.getElementById('docs_yn_y').checked="on"}
	        else{
	        document.getElementById('docs_yn_n').checked="on"}
	    	
	    if('<%=unsuit_action%>' == '반품'){
	        document.getElementById('unsuit_action_recall').checked="on"}
	    else if('<%=unsuit_action%>' == '폐기'){
	        document.getElementById('unsuit_action_disposal').checked="on"}
	        else{
	        document.getElementById('unsuit_action_none').checked="on"}
	    	
	    if('<%=check_yn%>' == 'O'){
	        document.getElementById('check_yn_y').checked="on"}
	        else{
	        document.getElementById('check_yn_n').checked="on"}
	
    });
    
	// 원부자재 검색 2차 팝업창에서 행 클릭했을때
	function SetpartName_code(part_cd, part_nm, part_rev_no, trace_key) { 
		$('#part_cd').val(part_cd);
		$('#part_rev_no').val(part_rev_no);
		$('#part_nm').val(part_nm);
		$('#trace_key').val(trace_key);
  	}
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.ipgo_date = $('#ipgo_date').val();
			dataJson.seq_no = $('#seq_no').val();
			dataJson.part_cd = $('#part_cd').val();
			dataJson.part_rev_no = $('#part_rev_no').val();
			dataJson.trace_key = $('#trace_key').val();
			dataJson.standard_yn = $("input[name='standard_yn']:checked").val();
			dataJson.packing_status = $("input[name='packing_status']:checked").val();
			dataJson.visual_inspection = $("input[name='visual_inspection']:checked").val();
			dataJson.car_clean = $("input[name='car_clean']:checked").val();
			dataJson.docs_yn = $("input[name='docs_yn']:checked").val();
			dataJson.unsuit_action = $("input[name='unsuit_action']:checked").val();
			dataJson.check_yn = $("input[name='check_yn']:checked").val();
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S070200E112");
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
					heneSwal.success('입고검사 대장 원부재료 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(toDate);
	         	} else {
					heneSwal.error('입고검사 대장 원부재료 수정에 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			입고일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="ipgo_date" class="form-control">
			
		</td>
	</tr>
   	<tr>
 		<td>
			원부재료명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="part_nm" readonly placeholder="click here"/>
  			<input type="hidden" class="form-control" id="part_cd" readonly/>
  			<input type="hidden" class="form-control" id="part_rev_no" readonly/>
  			<input type="hidden" class="form-control" id="trace_key" readonly/>
  			<input type="hidden" class="form-control" id="seq_no" readonly/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			규격적부
  		</td>
  		<td>
  			<input type="radio" name="standard_yn" id="standard_yn_y" value="적합" checked/>적합 &nbsp;
  			<input type="radio" name="standard_yn" id="standard_yn_n" value="부적합"/>부적합
  		</td>
  	</tr>
  	<tr>
		<td>
			포장상태
		</td>
	    <td>
			<input type="radio" name="packing_status" id="packing_status_y" value="적합" checked/>적합 &nbsp;
  			<input type="radio" name="packing_status" id="packing_status_n" value="부적합"/>부적합
		</td>
	</tr>
	<tr>
		<td>
			육안검사
		</td>
	    <td>
			<input type="radio" name="visual_inspection" id="visual_inspection_y" value="양호" checked/>양호 &nbsp;
  			<input type="radio" name="visual_inspection" id="visual_inspection_n" value="불량"/>불량
		</td>
	</tr>
	<tr>
		<td>
			차량청결상태
		</td>
	    <td>
			<input type="radio" name="car_clean" id="car_clean_y" value="양호" checked/>양호 &nbsp;
  			<input type="radio" name="car_clean" id="car_clean_n" value="불량"/>불량
		</td>
	</tr>
	<tr>
		<td>
			시험성적서 구비유무
		</td>
	    <td>
			<input type="radio" name="docs_yn" id="docs_yn_y" value="유" checked/>유 &nbsp;
  			<input type="radio" name="docs_yn" id="docs_yn_n" value="무"/>무
		</td>
	</tr>
	<tr>
		<td>
			부적합품 조치사항
		</td>
	    <td>
			<input type="radio" name="unsuit_action" id="unsuit_action_recall" value="반품" checked/>반품 &nbsp;
  			<input type="radio" name="unsuit_action" id="unsuit_action_disposal" value="폐기"/>폐기 &nbsp;
  			<input type="radio" name="unsuit_action" id="unsuit_action_none" value=""/>조치사항 없음
		</td>
	</tr>
	<tr>
		<td>
			확인
		</td>
	    <td>
			<input type="radio" name="check_yn" id="check_yn_y" value="O" checked/>O &nbsp;&nbsp;&nbsp;
  			<input type="radio" name="check_yn" id="check_yn_n" value="X"/>X
		</td>
	</tr>
</table>