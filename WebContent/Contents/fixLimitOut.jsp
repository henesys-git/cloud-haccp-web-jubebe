<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sensorKey = "";
	String createTime = "";

	if(request.getParameter("sensorKey") != null) {
		sensorKey = request.getParameter("sensorKey").toString();
	}

	if(request.getParameter("createTime") != null) {
		createTime = request.getParameter("createTime").toString();
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
				  <input class="form-check-input" type="radio" name="action" id="action4" value="직접입력">
				  <label class="form-check-label" for="action4">
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
		$("#action4").prop("checked", true);
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
	        	 "&improvementAction=" + improvementAction,
			success: function (resultIfFixed) {
	        	if(resultIfFixed == 'true') {
					$('#improvementActionModal').modal('hide');
					ccpDataJspPage.fillSubTable();
	        		alert('저장 완료');
	         	} else {
	         		alert('저장 실패, 관리자 문의 필요');
	         	}
			}
		});
	});
	
});
</script>