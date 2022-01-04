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
S838S015412.jsp
CCP-4P 측정일지 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", check_time ="", 
		ccp_date = "", prod_cd ="", prod_nm ="", revision_no ="", note_unusual = "",
		fe_only = "", sus_only = "", prod_only = "", fe_with_prod = "", sus_with_prod="",
		person_signer = "", person_sign_id = "", result = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	if(request.getParameter("check_time") != null)
		check_time = request.getParameter("check_time");
	
	if(request.getParameter("prod_cd") != null)
		prod_cd = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_nm") != null)
		prod_nm = request.getParameter("prod_nm");
	
	if(request.getParameter("revision_no") != null)
		revision_no = request.getParameter("revision_no");
	
	if(request.getParameter("note_unusual") != null)
		note_unusual = request.getParameter("note_unusual");
	
	if(request.getParameter("fe_only") != null)
		fe_only = request.getParameter("fe_only");
	
	if(request.getParameter("sus_only") != null)
		sus_only = request.getParameter("sus_only");
	
	if(request.getParameter("prod_only") != null)
		prod_only = request.getParameter("prod_only");
	
	if(request.getParameter("fe_with_prod") != null)
		fe_with_prod = request.getParameter("fe_with_prod");
	
	if(request.getParameter("sus_with_prod") != null)
		sus_with_prod = request.getParameter("sus_with_prod");
	
	if(request.getParameter("result") != null)
		result = request.getParameter("result");
	
	if(request.getParameter("person_signer") != null)
		person_signer = request.getParameter("person_signer");
	
	if(request.getParameter("person_sign_id") != null)
		person_sign_id = request.getParameter("person_sign_id");
	
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var fe_only = '<%=fe_only%>';
    	var fe_only1 = fe_only.substr(0,1);
    	var fe_only2 = fe_only.substr(1,1);
    	var fe_only3 = fe_only.substr(2,1);
    	
    	var sus_only = '<%=sus_only%>';
    	var sus_only1 = sus_only.substr(0,1);
    	var sus_only2 = sus_only.substr(1,1);
    	var sus_only3 = sus_only.substr(2,1);
    	
    	var prod_only = '<%=prod_only%>';
    	var prod_only1 = prod_only.substr(0,1);
    	var prod_only2 = prod_only.substr(1,1);
    	var prod_only3 = prod_only.substr(2,1);
    	
    	var fe_with_prod = '<%=fe_with_prod%>';
    	var fe_with_prod1 = fe_with_prod.substr(0,1);
    	var fe_with_prod2 = fe_with_prod.substr(1,1);
    	var fe_with_prod3 = fe_with_prod.substr(2,1);
    	var fe_with_prod4 = fe_with_prod.substr(3,1);
    	var fe_with_prod5 = fe_with_prod.substr(4,1);
    	
    	var sus_with_prod = '<%=sus_with_prod%>';
    	var sus_with_prod1 = sus_with_prod.substr(0,1);
    	var sus_with_prod2 = sus_with_prod.substr(1,1);
    	var sus_with_prod3 = sus_with_prod.substr(2,1);
    	var sus_with_prod4 = sus_with_prod.substr(3,1);
    	var sus_with_prod5 = sus_with_prod.substr(4,1);
    	
		new SetSingleDate2("", "#date_visit", 0);
		
		$('#check_time').val('<%=check_time%>');
		$('#ccp_date').val('<%=ccp_date%>');
		$('#prod_cd').val('<%=prod_cd%>');
		$('#prod_nm').val('<%=prod_nm%>');
		$('#revision_no').val('<%=revision_no%>');
		
		$('#fe_only').val('<%=fe_only%>');
		$('#sus_only').val('<%=sus_only%>');
		$('#prod_only').val('<%=prod_only%>');
		$('#fe_with_prod').val('<%=fe_with_prod%>');
		$('#sus_with_prod').val('<%=sus_with_prod%>');
		$('#result').val('<%=result%>');
		
		$('#note_unusual').val('<%=note_unusual%>');
		
		//fe_only radio value
		if(fe_only1 == 'O'){
			document.getElementById('fe_only_1_y').checked="on" }
		else{
			document.getElementById('fe_only_1_n').checked="on" }
		
		if(fe_only2 == 'O'){
			document.getElementById('fe_only_2_y').checked="on" }
		else{
			document.getElementById('fe_only_2_n').checked="on" }
		
		if(fe_only3 == 'O'){
			document.getElementById('fe_only_3_y').checked="on" }
		else{
			document.getElementById('fe_only_3_n').checked="on" }
		
		//sus_only radio value
		if(sus_only1 == 'O'){
			document.getElementById('sus_only_1_y').checked="on" }
		else{
			document.getElementById('sus_only_1_n').checked="on" }
		
		if(sus_only2 == 'O'){
			document.getElementById('sus_only_2_y').checked="on" }
		else{
			document.getElementById('sus_only_2_n').checked="on" }
		
		if(sus_only3 == 'O'){
			document.getElementById('sus_only_3_y').checked="on" }
		else{
			document.getElementById('sus_only_3_n').checked="on" }
		
		//prod_only radio value
		if(prod_only1 == 'O'){
			document.getElementById('prod_only_1_y').checked="on" }
		else{
			document.getElementById('prod_only_1_n').checked="on" }
		
		if(prod_only2 == 'O'){
			document.getElementById('prod_only_2_y').checked="on" }
		else{
			document.getElementById('prod_only_2_n').checked="on" }
		
		if(prod_only3 == 'O'){
			document.getElementById('prod_only_3_y').checked="on" }
		else{
			document.getElementById('prod_only_3_n').checked="on" }
		
		//fe_with_prod radio value
		if(fe_with_prod1 == 'O'){
			document.getElementById('fe_with_prod_1_y').checked="on" }
		else{
			document.getElementById('fe_with_prod_1_n').checked="on" }
		
		if(fe_with_prod2 == 'O'){
			document.getElementById('fe_with_prod_2_y').checked="on" }
		else{
			document.getElementById('fe_with_prod_2_n').checked="on" }
		
		if(fe_with_prod3 == 'O'){
			document.getElementById('fe_with_prod_3_y').checked="on" }
		else{
			document.getElementById('fe_with_prod_3_n').checked="on" }
		
		if(fe_with_prod4 == 'O'){
			document.getElementById('fe_with_prod_4_y').checked="on" }
		else{
			document.getElementById('fe_with_prod_4_n').checked="on" }
		
		if(fe_with_prod5 == 'O'){
			document.getElementById('fe_with_prod_5_y').checked="on" }
		else{
			document.getElementById('fe_with_prod_5_n').checked="on" }
		
		//sus_with_prod radio value
		if(sus_with_prod1 == 'O'){
			document.getElementById('sus_with_prod_1_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_1_n').checked="on" }
		
		if(sus_with_prod2 == 'O'){
			document.getElementById('sus_with_prod_2_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_2_n').checked="on" }
		
		if(sus_with_prod3 == 'O'){
			document.getElementById('sus_with_prod_3_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_3_n').checked="on" }
		
		if(sus_with_prod4 == 'O'){
			document.getElementById('sus_with_prod_4_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_4_n').checked="on" }
		
		if(sus_with_prod5 == 'O'){
			document.getElementById('sus_with_prod_5_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_5_n').checked="on" }
		
		if(sus_with_prod5 == 'O'){
			document.getElementById('sus_with_prod_5_y').checked="on" }
		else{
			document.getElementById('sus_with_prod_5_n').checked="on" }
		
		//result radio value
		if('<%=result%>' == 'O'){
			document.getElementById('result_y').checked="on" }
		else{
			document.getElementById('result_n').checked="on" }
		
    });
    
    // 제품명 input tag 클릭 시 제품 검색 팝업 생성
    $('#prod_nm').click(function() {
    	parent.pop_fn_ProductName_View(2,'01')
    });
    
 
    // 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGyugyuk, safeStock, curStock) {
    	
    	$('#prod_nm').val(prodName);
    	$('#prod_cd').val(prodCode);
    	$('#revision_no').val(prodRevNo);
    }
	
    function SaveOderInfo() {
    	
        var dataJson = new Object();
        
									
        dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		dataJson.check_time = $('#check_time').val();
		dataJson.prod_cd = $('#prod_cd').val();
		dataJson.revision_no = $('#revision_no').val();
		dataJson.fe_only_1 = $("input[name='fe_only_1']:checked").val();
		dataJson.fe_only_2 = $("input[name='fe_only_2']:checked").val();
		dataJson.fe_only_3 = $("input[name='fe_only_3']:checked").val();
		dataJson.sus_only_1 = $("input[name='sus_only_1']:checked").val();
		dataJson.sus_only_2 = $("input[name='sus_only_2']:checked").val();
		dataJson.sus_only_3 = $("input[name='sus_only_3']:checked").val();
		dataJson.prod_only_1 = $("input[name='prod_only_1']:checked").val();
		dataJson.prod_only_2 = $("input[name='prod_only_2']:checked").val();
		dataJson.prod_only_3 = $("input[name='prod_only_3']:checked").val();
		dataJson.fe_with_prod_1 = $("input[name='fe_with_prod_1']:checked").val();
		dataJson.fe_with_prod_2 = $("input[name='fe_with_prod_2']:checked").val();
		dataJson.fe_with_prod_3 = $("input[name='fe_with_prod_3']:checked").val();
		dataJson.fe_with_prod_4 = $("input[name='fe_with_prod_4']:checked").val();
		dataJson.fe_with_prod_5 = $("input[name='fe_with_prod_5']:checked").val();
		dataJson.sus_with_prod_1 = $("input[name='sus_with_prod_1']:checked").val();
		dataJson.sus_with_prod_2 = $("input[name='sus_with_prod_2']:checked").val();
		dataJson.sus_with_prod_3 = $("input[name='sus_with_prod_3']:checked").val();
		dataJson.sus_with_prod_4 = $("input[name='sus_with_prod_4']:checked").val();
		dataJson.sus_with_prod_5 = $("input[name='sus_with_prod_5']:checked").val();
		dataJson.result = $("input[name='result']:checked").val();
		dataJson.ccp_date = '<%=ccp_date%>;'
		dataJson.note_unusual = $('#note_unusual').val();
		
    	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S015400E112");
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
				heneSwal.success('측정일지 수정이 완료되었습니다');

				$('#modalReport').modal('hide');
        		parent.fn_MainInfo_List(startDate, endDate);
         	} else {
				heneSwal.error('측정일지 수정 실패했습니다, 다시 시도해주세요');	         		
         	}
         }
     });
}
</script>

<div class="container">
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		통과시간
	  	</div>
	  	<div class="col-4">
		  	<input type="time" id="check_time" class="form-control">
	  	</div>
	</div>
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		제품명
	  	</div>
	  	<div class="col-4">
		  	<input type="text"	 id="prod_nm" class="form-control" readonly>
		  	<input type="hidden" id="prod_cd" class="form-control">
		  	<input type="hidden" id="revision_no" class="form-control">
	  	</div>
	</div>
	
	
		<div class="row">
			<div class="col-2 border" id="fe_only">Fe만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_only_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_1_y" value="O" checked name="fe_only_1">
					  <label class="form-check-label" for="type01_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_1_n" value="X" name="fe_only_1">
					  <label class="form-check-label" for="fe_only_1_n">X</label>
					</div>
		      	</div>
			  	<div class="row border">
			      	<div class="col-7 border" id="fe_only_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_2_y" value="O" checked name="fe_only_2">
					  <label class="form-check-label" for="fe_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_2_n" value="X" name="fe_only_2">
					  <label class="form-check-label" for="fe_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_only_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_3_y" value="O" checked name="fe_only_3">
					  <label class="form-check-label" for="fe_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_3_n" value="X" name="fe_only_3">
					  <label class="form-check-label" for="fe_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
	
	
		<div class="row">
			<div class="col-2 border" id="sus_only">SUS만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_1">
			      	좌
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_1_y" value="O" checked name="sus_only_1">
					  <label class="form-check-label" for="sus_only_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_1_n" value="X" name="sus_only_1">
					  <label class="form-check-label" for="sus_only_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_2">
			      	중
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_2_y" value="O" checked name="sus_only_2">
					  <label class="form-check-label" for="sus_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_2_n" value="X" name="sus_only_2">
					  <label class="form-check-label" for="sus_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_3">
			      	우
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_3_y" value="O" checked name="sus_only_3">
					  <label class="form-check-label" for="sus_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_3_n" value="X" name="sus_only_3">
					  <label class="form-check-label" for="sus_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
	
	
	
		<div class="row">
			<div class="col-2 border" id="prod_only">제품만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_1_y" value="O" checked name="prod_only_1">
					  <label class="form-check-label" for="prod_only_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_1_n" value="X" name="prod_only_1">
					  <label class="form-check-label" for="prod_only_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_2_y" value="O" checked name="prod_only_2">
					  <label class="form-check-label" for="prod_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_2_n" value="X" name="prod_only_2">
					  <label class="form-check-label" for="prod_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_3_y" value="O" checked name="prod_only_3">
					  <label class="form-check-label" for="prod_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_3_n" value="X" name="prod_only_3">
					  <label class="form-check-label" for="prod_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-2 border" id="fe_with_prod">Fe+제품 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_1_y" value="O" checked name="fe_with_prod_1">
					  <label class="form-check-label" for="fe_with_prod_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_1_n" value="X" name="fe_with_prod_1">
					  <label class="form-check-label" for="fe_with_prod_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_2_y" value="O" checked name="fe_with_prod_2">
					  <label class="form-check-label" for="fe_with_prod_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_2_n" value="X" name="fe_with_prod_2">
					  <label class="form-check-label" for="fe_with_prod_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_3_y" value="O" checked name="fe_with_prod_3">
					  <label class="form-check-label" for="fe_with_prod_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_3_n" value="X" name="fe_with_prod_3">
					  <label class="form-check-label" for="fe_with_prod_3_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_4">
			      	위	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_4_y" value="O" checked name="fe_with_prod_4">
					  <label class="form-check-label" for="fe_with_prod_4_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_4_n" value="X" name="fe_with_prod_4">
					  <label class="form-check-label" for="fe_with_prod_4_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_5">
			      	아래	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_5_y" value="O" checked name="fe_with_prod_5">
					  <label class="form-check-label" for="fe_with_prod_5_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_5_n" value="X" name="fe_with_prod_5">
					  <label class="form-check-label" for="fe_with_prod_5_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-2 border" id="sus_with_prod">SUS+제품 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_1_y" value="O" checked name="sus_with_prod_1">
					  <label class="form-check-label" for="sus_with_prod_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_1_n" value="X" name="sus_with_prod_1">
					  <label class="form-check-label" for="sus_with_prod_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_2_y" value="O" checked name="sus_with_prod_2">
					  <label class="form-check-label" for="sus_with_prod_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_2_n" value="X" name="sus_with_prod_2">
					  <label class="form-check-label" for="sus_with_prod_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_3_y" value="O" checked name="sus_with_prod_3">
					  <label class="form-check-label" for="sus_with_prod_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_3_n" value="X" name="sus_with_prod_3">
					  <label class="form-check-label" for="sus_with_prod_3_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_4">
			      	위	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_4_y" value="O" checked name="sus_with_prod_4">
					  <label class="form-check-label" for="sus_with_prod_4_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_4_n" value="X" name="sus_with_prod_4">
					  <label class="form-check-label" for="sus_with_prod_4_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_5">
			      	아래	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_5_y" value="O" checked name="sus_with_prod_5">
					  <label class="form-check-label" for="sus_with_prod_5_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_5_n" value="X" name="sus_with_prod_5">
					  <label class="form-check-label" for="sus_with_prod_5_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="col-6 border">
			<div class="row border">
				특이사항
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="note_unusual">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				판정
			</div>
		    <div class="row border">
		    <div class="col-2 border form-check form-check-inline">
		      <input class="form-input" type="radio" id="result_y" value="O" checked name="result">
		      <label class="form-check-label" for="result_y">O</label>
		      </div>
		    <div class="col-2 border form-check form-check-inline">
		      <input class="form-input" type="radio" id="result_n" value="X" name="result">
		      <label class="form-check-label" for="result_n">X</label>
		      </div>
			</div>
		</div>
	</div>
		
