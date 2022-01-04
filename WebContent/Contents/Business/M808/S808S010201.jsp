<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="mes.subserver.MetalDetector"%>
<%
/* 	
금속검출 센서 데이터 추출 화면
*/	
	String loginID = session.getAttribute("login_id").toString();

    Vector censorList = CommonData.getMetalList();
    Vector censor_no = (Vector)censorList.get(0), censor_name = (Vector)censorList.get(1); 
    Vector prodList = CommonData.getProdList();
    Vector prod_cd = (Vector)prodList.get(0), prod_nm = (Vector)prodList.get(1);
%>

<style>
input[type=radio] {
    width: 30px;
    height: 30px;
}

.btns {
	text-align: center;
	margin : 20px 0;
}
</style>

<div class="container">
	<div class="main">
		<div class="row">
			<!-- <div class="col-sm-2 font-weight-bold">
				테스트 여부
			</div>
			<div class="col-sm-4">
				<div class="row">
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="isTest" id="isTest1" value="T" checked>
						<label class="form-check-label" for="isTest1">테스트</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="isTest" id="isTest2" value="R">
						<label class="form-check-label" for="isTest2">운영</label>
					</div>
				</div>
			</div> -->
			<div class="col-sm-2 font-weight-bold">
				금속검출기 ID
			</div>
			<div class="col-sm-4">
				<select class="form-control" id="metalDetector">
					<% for(int i = 0; i < censor_no.size(); i++){ %>
						<option value = "<%= censor_no.get(i) %>"><%= censor_name.get(i) %></option>
					<% } %>
				</select>
			</div>
		</div>

		<div class="row mt-3">
			<div class="col-sm-2 font-weight-bold">
				작업 상태
			</div>
			<div class="col-sm-4">
				<div class="row">
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="workStatus" id="workStatus1" value="BEFORE" checked>
						<label class="form-check-label" for="workStatus1">작업전</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="workStatus" id="workStatus2" value="ING">
						<label class="form-check-label" for="workStatus2">작업중</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="workStatus" id="workStatus3" value="AFTER">
						<label class="form-check-label" for="workStatus3">작업후</label>
					</div>
				</div>
			</div>
			<div class="col-sm-2 font-weight-bold">
				제품
			</div>
			<div class="col-sm-4">
				<select class="form-control" id="prod">
					<option value = "">제품 선택</option>
					<% for(int i = 0; i < prod_cd.size(); i++){ %>
						<option value = "<%= prod_cd.get(i) %>"><%= prod_nm.get(i) %></option>
					<% } %>
				</select>
			</div>
		</div>
		<div class="row mt-3">
			<div class="col-sm-2 font-weight-bold">
				시편 종류
			</div>
			<div class="col-sm-10">
				<div class="row">
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testType" id="testType1" value="Fe" checked>
						<label class="form-check-label" for="testType1">Fe</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testType" id="testType2" value="SUS">
						<label class="form-check-label" for="testType2">SUS</label>
					</div>
<!-- 				<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testType" id="testType3" value="PROD">
						<label class="form-check-label" for="testType3">제품</label>
					</div> -->
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testType" id="testType4" value="Fe_PROD">
						<label class="form-check-label" for="testType4">제품+Fe</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testType" id="testType5" value="SUS_PROD">
						<label class="form-check-label" for="testType5">제품+SUS</label>
					</div>
				</div>
			</div>
		</div>
		<div class="row mt-3">
			<div class="col-sm-2 font-weight-bold">
				시편 위치
			</div>
			<div class="col-sm-10">
				<div class="row">
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testPos" id="testPos1" value="L" checked>
						<label class="form-check-label" for="testPos1">왼쪽</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testPos" id="testPos2" value="C">
						<label class="form-check-label" for="testPos2">중앙</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testPos" id="testPos3" value="R">
						<label class="form-check-label" for="testPos3">오른쪽</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testPos" id="testPos4" value="U">
						<label class="form-check-label" for="testPos4">위</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="testPos" id="testPos5" value="D">
						<label class="form-check-label" for="testPos5">아래</label>
					</div>
				</div>
			</div>
		</div>
<!-- 		<div class="row mt-3">
			<div class="col-sm-2 font-weight-bold">
				결과
			</div>
			<div class="col-sm-10">
				<div class="row">
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="resultCheck" id="resultCheck1" value="O" checked>
						<label class="form-check-label" for="resultCheck1">합격</label>
					</div>
					<div class="form-check form-check-inline col">
						<input class="form-check-input" type="radio" name="resultCheck" id="resultCheck2" value="X">
						<label class="form-check-label" for="resultCheck2">불합격</label>
					</div>
				</div>
			</div>
		</div> -->
	</div>
	<div class="btns">
		<button id="startBtn" class="btn btn-info btn-lg">점검 시작</button>
		<button id="restartBtn" class="btn btn-info btn-lg">초기화</button>
		<button id="resultBtn" class="btn btn-info btn-lg">결과 확인</button>
	</div>
	<div class="sub">
		<table class='table table-bordered nowrap' id="resultTable" style="width: 100%">
			<thead id="tableHead">
				<tr>
					<th>시편 종류</th>
					<th>시편 위치</th>
					<th>결과</th>
					<th style = "width:0px;display:none;">결과</th>	
				</tr>
			</thead>
			<tbody id="tableBody">
			</tbody>
		</table>
	</div>
</div>

<script type="text/javascript">
    
    $(document).ready(function () {
		var orgValFromMetalDetector;	// 금속검출기에서 가져오는 검출 횟수 
		var startTime;
		var workStatus;
		var workStatusKo;
		var metalDetectorName;
		var metalDetectorId;
		var prodName;
		var prodCd;
		var tableOrderNum = 0;	// row.add 추가 -> 정렬
		
		$('#restartBtn').hide();
		disableBtns_Type();
		
		var customOpts = {
				columnDefs : [
					{
						'targets': [3],
			   			'createdCell':  function (td) {
			      			$(td).attr('style', 'display:none');
			   			}
					}
				],
				ordering: true,
				order : [[3, "desc"]],
				paging : true,
				createdRow : "",
				pageLength: 5,
				lengthMenu: [ 5, 10, 15, 20 ],
				lengthChange: true
		}
		
		var table = $('#resultTable').DataTable(
				mergeOptions(henePopupTableOpts, customOpts)
		);
		
		// th 고정
		setTimeout(function(){table.columns.adjust().draw();},100);
		
		$('#sendServerBtn').click(function() {
			
			if($(".sub .dataTables_empty").is(":visible")){
				heneSwal.warningTimer('테스트 결과가 없습니다.');
				return false;
			}
			
       		var dataJson = {};

    		dataJson.isTest = "T";
    		dataJson.dateTime = startTime;
       		dataJson.metalDetectorId = metalDetectorId;		
       		dataJson.prodName = prodName;
       		dataJson.userId = '<%=loginID%>';

       		var arr = [];
       		
       		table.rows().every(function(rowIdx, tableLoop, rowLoop) {
       			var obj = {};
       			var rowNode = this.node();
       			var inputs = $(rowNode).find('input');
       			
       			obj["type"+rowIdx] = $(inputs).eq(0).attr('value');
				obj["position"+rowIdx] = $(inputs).eq(1).attr('value');
				obj["result"+rowIdx] = $(inputs).eq(2).attr('value');
				
				arr.push(obj);
       		});
       		
       		dataJson.row = arr;
       		//dataJson.body = arr;

    		var jsonParam = JSON.stringify(dataJson);
    		
    		sendResultToServer(jsonParam);
    	});
        
		function sendResultToServer(data) {
    	    $.ajax({
    	    	type: "POST",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:data, pid:"M808S010200E111"},
				success: function (rcvData) {
					if(rcvData > -1) {
    					heneSwal.successTimer('등록 완료');
    					changeMode("operation");
    					parent.fn_MainInfo_List(startDate, endDate, metalName);
    					$('#modalReport').modal('hide');
    	        	} else {
    					heneSwal.errorTimer('등록 실패');
    	        	}
		         }
    	    });
    	}
		
		function changeMode(mode) {
    	    $.ajax({
    	    	type: "GET",
		        url: "<%=Config.this_SERVER_path%>/ccp/metal-detector/status", 
		        data: "mode=" + mode,
				dataType: "text",
		        success: function (rcvData) {
					if(rcvData === "06") {
						if(mode === "test") {
							getValFromMetalDetector(assignNewVal);
						}						
						
						return true;
					} else {
						return false;
					}
		        },
		        error: function() {
		        	return false;
		        }
    	    });
    	}
		
    	function disableBtns() {
    		$('#startBtn').hide();
    		$('#metalDetector').prop('disabled', true);
    		$('input[name=workStatus]').prop('disabled', true);
    		$('#prod').prop('disabled', true);
    	}
    	
    	function enableBtns() {
    		$('#startBtn').show();
    		$('#metalDetector').prop('disabled', false);
    		$('input[name=workStatus]').prop('disabled', false);
    		$('#prod').prop('disabled', false);
    		$('input[name=testPos][value=L]').prop('checked', true);
    		$('input[name=testType][value=Fe]').prop('checked', true);
    		$('input[name=resultCheck][value=O]').prop('checked', true);
    	}

	 	//작업 상태 (작업전,작업후) 선택시 시편 종류(제품, 제품+Fe, 제품+SUS) 비활성화
    	function disableBtns_Type() {
     		
    		for(let i = 1; i <= 5; i++){
    			 if(i <= 3){
    				$("#testPos"+i).removeAttr("disabled"); 
    		    	$("#testType"+i).removeAttr("disabled"); 
    			 } else {
    				$("#testType"+i).attr("disabled", "disabled");  
    		    	$("#testPos"+i).attr("disabled", "disabled");
    			 }
    		 }
    		
    		$('input[name=testPos][value=L]').prop('checked', true);
     		$('input[name=testType][value=Fe]').prop('checked', true);
     		$("#prod").val("");
     		$("#prod").attr("disabled", "disabled");  
    	}
    	
    	//작업 상태 (작업중) 선택시 시편 종류(제품, 제품+Fe, 제품+SUS) 활성화
	 	function enableBtns_Type() {
    		
	 		for(let i = 1; i <= 5; i++){
	   			 if(i > 3){ 
	   				$("#testPos"+i).removeAttr("disabled"); 
	   		    	$("#testType"+i).removeAttr("disabled"); 
	   			 } else {
	   				$("#testType"+i).attr("disabled", "disabled");  
	   		    	$("#testPos"+i).attr("disabled", "disabled");
	   			 }
	   		 }
	 		
	 		$('input[name=testPos][value=U]').prop('checked', true);
     		$('input[name=testType][value="Fe_PROD"]').prop('checked', true);
     		$("#prod").removeAttr("disabled"); 
    	}
    	
    	$('#startBtn').click(function() {
    		var heneDate = new HeneDate();
    		startTime = heneDate.getDateTime();
    		
    		workStatus = $('input[name="workStatus"]:checked').val();
    		workStatusKo = $('input[name="workStatus"]:checked').siblings("label").text();
    		metalDetectorId = $('#metalDetector option:selected').val();
    		metalDetectorName = $('#metalDetector option:selected').text();
    		prodCd = $('#prod option:selected').val();
    		
    		if(workStatusKo.trim() == "작업중"){	// 작업중일땐 제품명이 작업중이 아닐땐 작업상태가 들어감
    			prodName = $('#prod option:selected').text();	
    			if(prodCd == "" || prodCd == null){
    				heneSwal.warningTimer('작업중엔 제품명을 선택해주세요.');
    				return false;
    			}
    		} else {
    			prodName = workStatusKo;
    		}
    		
    		disableBtns();
    		$('#restartBtn').show();
    		
    		let changed = changeMode("test");
    		/* if(changed) {
	    		getValFromMetalDetector(assignNewVal);
    		} */
       	});
    	
    	$('#restartBtn').click(function() {
    		var confirmed = confirm('재시작 하시겠습니까?\n' +
    								'확인을 누르시면 현재 입력 된 내용은 사라집니다');
    		
    		if(confirmed) {
	    		enableBtns();
	    		table.rows().remove().draw();
				$('#restartBtn').hide();
	    		changeMode("operation");
	    		
	    		heneSwal.successTimer('초기화 완료');
    		}
    	});
    	
    	function addResultToTable(testType, testPos, checkRslt) {
    		console.log('addResultToTable start');
    		
    		var dupCheck = duplicateCheck(testType, testPos);
			if(!dupCheck) { return false; }
			
    		var rowNode = table.row.add([
			        		" <input type='text' class='form-control' name='type' value='"+testType+"' readonly> ",
			        		" <input type='text' class='form-control' name='position' value='"+testPos+"' readonly> ",
			        		" <input type='text' class='form-control' name='result' value='"+checkRslt+"'readonly> ",
			        		tableOrderNum	// 테이블 정렬을 위한 컬럼
				          ]).draw(false).node();
    		    		
    		tableOrderNum += 1;
    		
     		switch(testPos) {
     			case "L":
     				$(rowNode).find('input[name=position]').val("좌");
     				break;
     			case "C":
     				$(rowNode).find('input[name=position]').val("중");
     				break;
     			case "R":
     				$(rowNode).find('input[name=position]').val("우");
     				break;
     			case "U":
     				$(rowNode).find('input[name=position]').val("위");
     				break;
     			case "D":
     				$(rowNode).find('input[name=position]').val("아래");
     				break;
     			default:
     				$(rowNode).find('input[name=position]').val("");
     		}
     		
     		switch(checkRslt) {
	 			case "O":
	 				$(rowNode).find('input[name=result]').val("합격");
	 				$(rowNode).find('input[name=result]').css("background-color", "#4287f5");
	 				break;
	 			case "X":
	 				$(rowNode).find('input[name=result]').val("불합격");
	 				$(rowNode).find('input[name=result]').css("background-color", "#f54242");
	 				break;
	 			default:
	 				$(rowNode).find('input[name=result]').val("");
	 		}
     		
    	}
    	
    	$('#resultBtn').click(function() {
    		    		
    		if($("#startBtn").is(":visible")){
    			heneSwal.warningTimer("점검 시작 먼저 클릭해주세요.");
    			return false;
    		}
    		
    		getValFromMetalDetector(function(val) {
    			compareValues(val, function(ifBeep, val) {
    				judgeResult(ifBeep, addResultToTable);
    				assignNewVal(val);
    				
    				// 다음 위치로 라디오 버튼 이동
    	    		var inputs = $('input[name=testPos]:not(:disabled)');
    				var types = $('input[name=testType]:not(:disabled)');
    	    	    
    				$(inputs).each(function(idx) {
    	    	    	var checked = $(this).is(':checked');
    	    	        if(checked) {
    	    	        	if((inputs.length-1) == idx){ 	// 시편위치 마지막 버튼일때 종류 바뀜
    	        	        	$(types[1]).prop('checked', true);
    	            	        $(inputs[0]).prop('checked', true);
    	        	        }
    	    	        	$(inputs[idx+1]).prop('checked', true);
    	    	            return false;
    	    	        } 
    	    	        
    	    	    });
    			});
    		});
    	    
    	    $(inputs).each(function(idx) {
    	    	var checked = $(this).is(':checked');
    	        if(checked) {
    	        	if((inputs.length-1) == idx){ 	// 시편위치 마지막 버튼일때 종류 바뀜
        	        	$(types[1]).prop('checked', true);
            	        $(inputs[0]).prop('checked', true);
        	        }
    	        	$(inputs[idx+1]).prop('checked', true);
    	            return false;
    	        } 
    	        
    	    });
    	    
    	    changeMode("operation");
    	});
    	        
    	$('#closeBtn').click(function() {
        	var confirmed = confirm('확인을 누르면 창이 닫힙니다');
        	
        	if(confirmed) {
	        	$('#modalReport').modal('hide');
	        	changeMode("operation");
        	}
        	
        });
    	
     	//시편 종류 선택에 따라서 시편 위치 radio button 활성화 변경    	
    	$('input[name=testType]').click(function(){
    	
	    	var testType =  $('input[name="testType"]:checked').val();
	    	
	    	if(testType == "Fe" || testType == "SUS") {	// || testType == "PROD"
	    		$('input[name=testPos][value=L]').prop('checked', true);
	    	} else if(testType == "Fe_PROD" || testType == "SUS_PROD") {
	    		$('input[name=testPos][value=U]').prop('checked', true);	
	        }
    	
    	}); 
    	
    	//작업상태 선택에 따라서 시편 종류 radio button 활성화 변경    	
    	$('input[name=workStatus]').click(function(){
    	
    		var workStatus =  $('input[name="workStatus"]:checked').val();
	    	
	    	if(workStatus == "BEFORE" || workStatus == "AFTER") {
	    		disableBtns_Type();
	    	} else if(workStatus == "ING") {
	       		enableBtns_Type();	
	        }
	    	
		});
    	
    	// 시편종류와 시편위치의 중복이 되게 결과확인을 할 경우
    	function duplicateCheck(testType, testPos) {
    		
    		var flag = true;
    		
			$("#tableBody tr").each(function() {
     			
     			var rowType = $(this).children("td").eq(0).children("input").val();
     			var rowPosition = $(this).children("td").eq(1).children("input").val();
     			
     			switch (rowPosition) {
				case '좌':
					rowPosition = "L";
					break;
				case '중':
					rowPosition = "C";
					break;
				case '우':
					rowPosition = "R";
					break;
				case '위':
					rowPosition = "U";
					break;
				case '아래':
					rowPosition = "D";
					break;
				}

     			if(testType == rowType && testPos == rowPosition){		
     				heneSwal.warningTimer('이미 결과확인이 완료된 항목입니다.');
     				flag = false;
     				return false;
     			}
     			
     		});
			
			return flag;
    	}
    	
    	function getValFromMetalDetector(cb) {
    		$.ajax({
    			type: "POST",
                url: "<%=Config.this_SERVER_path%>/ccp/metal-detector/count",
                data: "mode=test",
				dataType: "text",
                success: function (rtnVal) {
    				console.log("금속검출기로부터 받은 값:" + rtnVal);

    				if(rtnVal == -999) {
    					heneSwal.warning('금속검출기 네트워크 연결 상태를 확인해 주세요');
    					console.error("socket connection failed");
    					return false;
    				} else {
    					cb(rtnVal);
    				}
    	      	}
    	    });
    	}
    	
    	function assignNewVal(newVal) {
    		console.log("금속검출기 기존 값:" + orgValFromMetalDetector);
    		
    		orgValFromMetalDetector = newVal;
    		
    		console.log("새로 받은 값으로 대체 완료");
    	}
    	
    	function compareValues(newVal, cb) {
    		let ifBeep = false;
    		
    		if(newVal > orgValFromMetalDetector) {
    			ifBeep = true;
    		} else {
    			ifBeep = false;
    		}
    		
    		cb(ifBeep, newVal);
    	}
    	
    	function judgeResult(ifBeep, cb) {
    		console.log('judgeResult start');
    		
    		var testType = $('input[name="testType"]:checked').val();
    		var testPos = $('input[name="testPos"]:checked').val();
    		var checkRslt;
    		
    		if(testType == "PROD") {
    			if(ifBeep) {
    				checkRslt = "X";
    			} else {
    				checkRslt = "O";
    			}
    		} else {
    			if(ifBeep){
    				checkRslt = "O";
    			} else {
    				checkRslt = "X";
    			}
    		}
    		
    		cb(testType, testPos, checkRslt);
    	}
    });
</script>