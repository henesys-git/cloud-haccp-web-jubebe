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
				  <input class="form-check-input" type="radio" name="action" id="action1" value="FA01" checked>
				  <label class="form-check-label" for="exampleRadios1">
				    제품폐기
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action2" value="FA02">
				  <label class="form-check-label" for="action2">
				    장비수리
				  </label>
				</div>
				<div class="form-check">
				  <input class="form-check-input" type="radio" name="action" id="action3" value="FA03">
				  <label class="form-check-label" for="action3">
				    제상
				  </label>
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
	let row = 
	
	$('#improvementActionModal').modal('show');
	
	$('#closeBtn').click(function() {
		console.log('close btn');
		$('#improvementActionModal').modal('hide');
	});
	
	$('#saveBtn').off().on('click', function() {
		
		let improvementCode = $("input[name='action']:checked").val();
		alert(improvementCode);
		return false;
		
		$.ajax({
	    	type: "PUT",
	        dataType: "json",
	        url: "/ccp", 
	        data: {
		        "param" : JSON.stringify(objToDb), 
	        	"pid" : "SPC.SPC000200",
	        	"fid" : "savePlanInstruction"
	       	},
			success: function (data) {
	        	if(data > 0) {
					$('#settingModal').modal('hide');
	        		parent.fn_MainInfo_List();
	        		alert('저장 완료');
	         	} else {
	         		alert('저장 실패, 관리자 문의 필요');
	         	}
			}
		});
	});
	
});
</script>