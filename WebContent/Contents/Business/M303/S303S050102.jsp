<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
생산실적관리, 생산실적 수정 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String manufacturingDate = "", requestRevNo = "", prodPlanDate = "",
		   planRevNo = "", prodCd = "", prodRevNo = "",
		   prodName = "", planAmount = "", expirationDate  = "",
		   prodJournalNote = "", planStorageMapper = "";
	
	String realAmount = "";
		   
	if(request.getParameter("manufacturingDate") != null) {
		manufacturingDate = request.getParameter("manufacturingDate").toString();
	}
	
	if(request.getParameter("requestRevNo") != null) {
		requestRevNo = request.getParameter("requestRevNo").toString();
	}
	
	if(request.getParameter("prodPlanDate") != null) {
		prodPlanDate = request.getParameter("prodPlanDate").toString();
	}
	
	if(request.getParameter("planRevNo") != null) {
		planRevNo = request.getParameter("planRevNo").toString();
	}
	
	if(request.getParameter("prodCd") != null) {
		prodCd = request.getParameter("prodCd").toString();
	}
	
	if(request.getParameter("prodRevNo") != null) {
		prodRevNo = request.getParameter("prodRevNo").toString();
	}
	
	if(request.getParameter("prodName") != null) {
		prodName = request.getParameter("prodName").toString();
	}
	
	if(request.getParameter("planAmount") != null) {
		planAmount = request.getParameter("planAmount").toString();
	}

	if(request.getParameter("realAmount") != null) {
		realAmount = request.getParameter("realAmount").toString();
	}
	
	if(request.getParameter("expirationDate") != null) {
		expirationDate = request.getParameter("expirationDate").toString();
	}
	
	if(request.getParameter("prodJournalNote") != null) {
		prodJournalNote = request.getParameter("prodJournalNote").toString();
	}
	
	if(request.getParameter("planStorageMapper") != null) {
		planStorageMapper = request.getParameter("planStorageMapper").toString();
	}
%>

<div>
	<table class="table" style="width: 100%">
		<tr>
			<td>제품명</td>
			<td>
				<input type="text" class="form-control" id="prodName" 
					   value="<%=prodName%>" readonly>
	       	</td>
		<tr>
			<td>제조년월일</td>
			<td>
				<input type="text" class="form-control" id="manufacturingDate" 
					   value="<%=manufacturingDate%>" readonly>
	       	</td>
	    </tr>
		<tr>
			<td>유통기한</td>
			<td>
				<input type="text" class="form-control" id="expirationDate" 
					   value="<%=expirationDate%>" readonly>
	       	</td>
	    </tr>
		<tr>
			<td>
	        	계획생산량
			</td>
	        <td>
            	<div class="input-group">
		        	<input type="number" id="planAmount" class="form-control" readonly value="<%=planAmount%>">
			      	<div class="input-group-append">
			        	<span class="input-group-text">EA</span>
			      	</div>
			    </div>
           	</td>
	    </tr>
		<tr>
			<td>
	        	실제생산량
			</td>
	        <td>
            	<div class="input-group">
		        	<input type="number" id="realAmount" class="form-control" readonly value="<%=realAmount%>">
			      	<div class="input-group-append">
			        	<span class="input-group-text">EA</span>
			      	</div>
			    </div>
           	</td>
	    </tr>
	    <tr>
			<td>
	        	실제생산량(수정)
			</td>
	        <td>
            	<div class="input-group">
		        	<input type="number" id="modifyAmount" class="form-control" placeholder="변경 수량을 입력해주세요">
			      	<div class="input-group-append">
			        	<span class="input-group-text">EA</span>
			      	</div>
			    </div>
           	</td>
	    </tr>
		<tr>
			<td>
	        	생산일지 비고
			</td>
	        <td>
	        	<input type="text" id="prodJournalNote" class="form-control" value="<%=prodJournalNote%>">
	        </td>
	    </tr>
	</table>
</div>

<script>

    $(document).ready(function () {
		$('#modifyAmount').focus();
		
		var plan_amount = '<%=planAmount%>';
		var real_amount = '<%=realAmount%>';
		
		var amount1 = plan_amount.replace(",", "");
		var amount2 = real_amount.replace(",", "");
		
		$('#planAmount').val(amount1);
		$('#realAmount').val(amount2);
		
    });
	
	function SaveOderInfo() {

		if($("#modifyAmount").val() == '') { 
			heneSwal.warning("수정할 생산량을 입력해주세요");
			return false;
		}
		
		var jsonData = new Object();
		
		jsonData.manufacturingDate = $('#manufacturingDate').val();
		jsonData.requestRevNo = '<%=requestRevNo%>';
		jsonData.prodPlanDate = '<%=prodPlanDate%>';
		jsonData.planRevNo = '<%=planRevNo%>';
		jsonData.prodCd = '<%=prodCd%>';
		jsonData.prodRevNo = '<%=prodRevNo%>';
		jsonData.expirationDate = $('#expirationDate').val();
		jsonData.realAmount = $('#realAmount').val();
		jsonData.modifyAmount = $('#modifyAmount').val();
		jsonData.prodJournalNote = $('#prodJournalNote').val();
		jsonData.planStorageMapper = '<%=planStorageMapper%>';
		jsonData.userId = '<%=loginID%>';
		jsonData.userRevNo = '0'; // needtocheck, 나중에 수정해야됨 max값으로
		
		var jsonStr = JSON.stringify(jsonData);

		var confirmVal = confirm("수정하시겠습니까?"); 
		
		if(confirmVal) {
			SendTojsp(jsonStr, "M303S050100E112");
		}
	}
    
	function SendTojsp(bomdata, pid) {		
		
		$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data: {"bomdata": bomdata, "pid": pid},
			beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
			},
			success: function (rcvData) {
				if(rcvData > -1) {
					heneSwal.success('생산실적 수정이 완료되었습니다');
					$('#modalReport').modal('hide');
			     	fn_MainInfo_List(startDate, endDate);
			    } else {
			     	heneSwal.error('생산실적 수정 실패했습니다. 다시 시도해주세요.');
			     	return false;
			    }
			}
		});
	}
</script>