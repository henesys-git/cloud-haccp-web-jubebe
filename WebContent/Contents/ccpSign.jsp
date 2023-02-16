<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sensorKey = "";
	String createTime = "";
	String date = "";
	String date2 = "";
	String processCode = "";
	String limitOutParam = "";

	if(request.getParameter("sensorKey") != null) {
		sensorKey = request.getParameter("sensorKey").toString();
	}

	if(request.getParameter("createTime") != null) {
		createTime = request.getParameter("createTime").toString();
	}
	
	if(request.getParameter("date") != null) {
		date = request.getParameter("date").toString();
	}
	
	if(request.getParameter("date2") != null) {
		date2 = request.getParameter("date2").toString();
	}
	
	if(request.getParameter("processCode") != null) {
		processCode = request.getParameter("processCode").toString();
	}
	
	if(request.getParameter("limitOutParam") != null) {
		limitOutParam = request.getParameter("limitOutParam").toString();
	}
%>

<div id="ccpSignModal" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="form-check">
				  <label class="form-check-label" for="sign-type">
				   CCP 서명 종류
				  </label>
				  <select class = "form-control" id = "sign-type">
				  	<option value = "CHECK">확인자</option>
				  	<option value = "APPRV">승인자</option>
				  </select>
				 
				</div>
     		</div>
     		<div class="modal-footer">
				<button class="btn btn-primary" id="saveBtn">
					저장
				</button>
				<button class="btn btn-light" id="closeBtn">
					닫기
				</button>
     		</div>
	   	</div>
	</div>
</div>

<script>
$(document).ready(function () {
	
	$('#ccpSignModal').modal('show');
	
	$('#closeBtn').click(function() {
		$('#ccpSignModal').modal('hide');
	});
	
	$('#saveBtn').off().on('click', function() {
		
		let signType = $("#sign-type option:selected").val();
		
		var signUserName = await ccpSign.sign(selectedDate, processCode, signType);
		
		$.ajax({
	    	type: "PUT",
	        url: "/ccp" + 
	        	 "?method=notAll" + 
	        	 "&date=" + '<%=date%>' + 
	        	 "&processCode=" + '<%=processCode%>' + 
	        	 "&signType=" + signType,
			success: async function (resultIfFixed) {
	        	if(resultIfFixed == 'true') {
					$('#ccpSignModal').modal('hide');
					
					ccpBreakawayJSPPage.refreshTable();
					
	        		alert('서명 완료');
	         	} else {
	         		alert('서명 실패, 관리자 문의 필요');
	         	}
			}
		});
	});
	
});
</script>