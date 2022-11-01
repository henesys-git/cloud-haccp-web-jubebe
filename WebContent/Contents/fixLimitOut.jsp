<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sensorKey = "";
	String createTime = "";
	String date = "";
	String processCode = "";

	if(request.getParameter("sensorKey") != null) {
		sensorKey = request.getParameter("sensorKey").toString();
	}

	if(request.getParameter("createTime") != null) {
		createTime = request.getParameter("createTime").toString();
	}
	
	if(request.getParameter("date") != null) {
		date = request.getParameter("date").toString();
	}
	
	if(request.getParameter("processCode") != null) {
		processCode = request.getParameter("processCode").toString();
	}
%>

<div id="improvementActionModal" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action1" value="제품폐기" checked>
				  <label class="form-check-label" for="exampleRadios1">
				    제품폐기
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action2" value="장비수리">
				  <label class="form-check-label" for="action2">
				    장비수리
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action3" value="제상">
				  <label class="form-check-label" for="action3">
				    제상
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action4" value="검수후 재포장">
				  <label class="form-check-label" for="action4">
				    검수후 재포장
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action-custom" value="직접입력">
				  <label class="form-check-label" for="action-custom">
				    직접입력
				  </label>
				  <input type="text" id="other-action-input">
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
	
	$('#improvementActionModal').modal('show');
	
	$('#closeBtn').click(function() {
		$('#improvementActionModal').modal('hide');
	});
	
	// 직업입력에 입력 시 자동 체크
	$("#other-action-input").keyup(function() {
		$("#action-custom").prop("checked", true);
  	});
	
	$('#saveBtn').off().on('click', function() {
		
		let improvementAction = $("input[name='action']:checked").val();
		
		if(improvementAction === "직접입력") {
			improvementAction = $("#other-action-input").val();
		}
		
		$.ajax({
	    	type: "PUT",
	        url: "/ccp" + 
	        	 "?sensorKey=" + '<%=sensorKey%>' + 
	        	 "&createTime=" + '<%=createTime%>' + 
	        	 "&improvementAction=" + improvementAction +
	        	 "&date=" + '<%=date%>' + 
	        	 "&processCode=" + '<%=processCode%>',
			success: async function (resultIfFixed) {
	        	if(resultIfFixed == 'true') {
					$('#improvementActionModal').modal('hide');
					
					//TODO: CCP별로 JspPage 다르게 하는 코드. 임시처리한거라 예외처리랑 등등 더 해야됨
					if('<%=processCode%>' == 'PC30') {
						await ccpHeatingDataJspPage.fillSubTable();
						ccpHeatingDataJspPage.showSignBtn();
						ccpHeatingDataJspPage.changeMainTableValueIfAllFixed();
					} else if('<%=processCode%>' == 'PC10' || '<%=processCode%>' == 'PC15'){
						await ccpMetalDataJspPage.fillSubTable();
						ccpMetalDataJspPage.showSignBtn();
						ccpMetalDataJspPage.changeMainTableValueIfAllFixed();
					} else if('<%=processCode%>' == 'PC60') {
						cpTemperatureJSPPage.refreshTable();
					} else if('<%=processCode%>' == 'PC40' || '<%=processCode%>' == 'PC45') {
						await ccpCleaningJSPPage.fillSubTable();
						ccpCleaningJSPPage.showSignBtn();
						ccpCleaningJSPPage.changeMainTableValueIfAllFixed();
					} else {
						ccpBreakawayJSPPage.refreshTable();
					}
					
	        		alert('개선조치 완료 (서명 초기화)');
	         	} else {
	         		alert('개선조치 실패, 관리자 문의 필요');
	         	}
			}
		});
	});
	
});
</script>