<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
현장생산관리, 작업완료 모달창 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String manufacturingDate = "", requestRevNo = "", prodPlanDate = "",
		   planRevNo = "", prodCd = "", prodRevNo = "",
		   prodName = "", planAmount = "", expirationDate  = "", date = "";
	
	String realAmount = "", workTime = "", workStartTime = "", workEndTime = "";
		   
	manufacturingDate = request.getParameter("manufacturingDate").toString();
	requestRevNo = request.getParameter("requestRevNo").toString();
	prodPlanDate = request.getParameter("prodPlanDate").toString();
	planRevNo = request.getParameter("planRevNo").toString();
	prodCd = request.getParameter("prodCd").toString();
	prodRevNo = request.getParameter("prodRevNo").toString();
	prodName = request.getParameter("prodName").toString();
	planAmount = request.getParameter("planAmount").toString();
	expirationDate = request.getParameter("expirationDate").toString();
	workTime = request.getParameter("workTime").toString();
	
	if(request.getParameter("workStartTime") != null)
		workStartTime = request.getParameter("workStartTime");
	
	if(request.getParameter("workEndTime") != null)
		workEndTime = request.getParameter("workEndTime");
	
	String initIpgoTypeCode = "PROD_IPGO_TYPE001";
	Vector ipgoTypeCode = null;
    Vector ipgoTypeName = null;
    Vector ipgoTypeList = CommonData.getProdIpgoType();
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
	        	<input type="text" id="planAmount" class="form-control" readonly value="<%=planAmount%>">
	        </td>
	    </tr>
		<tr>
			<td>
	        	실제생산량
			</td>
	        <td>
	        	<input type="number" id="realAmount" class="form-control" value="<%=realAmount%>">
	        </td>
	    </tr>
	    <tr>
			<td>
				입고 타입
			</td>
		  	<td>
				<select class="form-control" id="ipgo_type">
		        	<% ipgoTypeCode = (Vector) ipgoTypeList.get(1);%>
		            <% ipgoTypeName = (Vector) ipgoTypeList.get(2);%>
		            <% for(int i = 0; i < ipgoTypeName.size(); i++) { %>
						<option value='<%=ipgoTypeCode.get(i).toString()%>' 
							<%=initIpgoTypeCode.equals(ipgoTypeCode.get(i).toString()) ? "selected" : "" %>>
							<%=ipgoTypeName.get(i).toString()%>
						</option>
					<%} %>
				</select>
			</td>
	  	</tr>
	    <tr>
			<td>
	        	생산일지 비고
			</td>
	        <td>
	        	<input type="text" id="prod_journal_note" class="form-control">
	        </td>
	    </tr>
	</table>
</div>

<script>

    $(document).ready(function () {
    });
	
	function SaveOderInfo() {

		if($("#realAmount").val() == '') { 
			heneSwal.warning("실제 생산량을 입력해주세요");
			return false;
		}
		
		var jsonData = new Object();
		
		jsonData.manufacturingDate = $('#manufacturingDate').val();
		jsonData.requestRevNo = '<%=requestRevNo%>';
		jsonData.prodPlanDate = '<%=prodPlanDate%>';
		jsonData.planRevNo = '<%=planRevNo%>';
		jsonData.prodCd = '<%=prodCd%>';
		jsonData.prodRevNo = '<%=prodRevNo%>';
		jsonData.ipgo_type = $('#ipgo_type').val();
		jsonData.expirationDate = $('#expirationDate').val();
		jsonData.prodJournalNote = $('#prod_journal_note').val();
		jsonData.realAmount = $('#realAmount').val();
		jsonData.userId = '<%=loginID%>';
		jsonData.userRevNo = '0';
		jsonData.workTime = '<%=workTime%>';
		jsonData.workStartTime = '<%=workStartTime%>';
		jsonData.workEndTime = '<%=workEndTime%>';
		
		var jsonStr = JSON.stringify(jsonData);

		var confirmVal = confirm("등록하시겠습니까?"); 
		
		if(confirmVal) {
			SendTojsp(jsonStr, "M303S020200E122");
		}
	}
    
	function SendTojsp(bomdata, pid) {		
		
		$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data: {"bomdata": bomdata, "pid": pid},
			success: function (rcvData) {
				if(rcvData > -1) {
					heneSwal.success('작업이 완료 상태로 변경되었습니다<br>' +
									 '배합일지 제출이 완료되어야 관리자 확인이 가능합니다');
					$('#modalReport').modal('hide');
			     	fn_MainInfo_List(selectedDate);
			    } else {
			     	heneSwal.error('작업상태 변경에 실패했습니다');
			     	return false;
			    }
			}
		});
	}
</script>