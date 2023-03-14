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
	
	$('#saveBtn').off().on('click', async function() {
		
		let signType = $("#sign-type option:selected").val();
		
		var ccpSign = new CCPSign();
		var signUserName = await ccpSign.sign('<%=date%>', '<%=processCode%>', signType);
		
		if(signUserName) {
			$('#ccpSignModal').modal('hide');
			alert('서명 완료되었습니다');
			
			var signInfo = await ccpSign.get('<%=date%>', '<%=processCode%>');
			
			var signText = "";
			
			for(var i = 0; i < signInfo.length; i++) {
				if(signInfo[i].signType == 'CHECK') {
					signText = signText + "확인자 :" + signInfo[i].userName;
				}
				
				else if(signInfo[i].signType == 'APPRV') {
					signText = signText + "승인자 :" + signInfo[i].userName;
				}
			} 
			
			//확인자, 승인자 모두 서명시 서명버튼 숨김 처리
			if(signInfo.length == 2) {
				$("#ccp-sign-btn").hide();
				$("#ccp-sign-text").text(signText);
			}
			else {
				$("#ccp-sign-btn").show();
				$("#ccp-sign-text").text(signText);
			}
			
			//TODO: CCP별로 JspPage 다르게 하는 코드. 임시처리한거라 예외처리랑 등등 더 해야됨
			if('<%=processCode%>' == 'PC30') {
				//await ccpHeatingDataJspPage.fillSubTable();
			} else if('<%=processCode%>' == 'PC10' || '<%=processCode%>' == 'PC15'){
				//await ccpMetalDataJspPage.fillSubTable();
				//ccpMetalDataJspPage.refreshTable();
			} else if('<%=processCode%>' == 'PC60') {
				cpTemperatureJSPPage.refreshTable();
			} else if('<%=processCode%>' == 'PC40' || '<%=processCode%>' == 'PC45') {
				await ccpCleaningJSPPage.fillSubTable();
			} else {
				ccpBreakawayJSPPage.refreshTable();
			}
			
		} else {
			alert('서명 실패, 관리자에게 문의해주세요');
		}
		
	});
	
});
</script>