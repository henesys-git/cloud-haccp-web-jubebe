﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
생산계획수정(S303S020102).jsp 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String selectedDate = "", planRevNo = "";

	if(request.getParameter("selectedDate") != null) {
		selectedDate = request.getParameter("selectedDate");
	}
	
	if(request.getParameter("planRevNo") != null) {
		planRevNo = request.getParameter("planRevNo");
	}
	
	// 현재고량 팝업 때 쓰여서 일단 놔둠
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");	
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<style>
	.card.card-info{
		height : 300px;
	}
</style>


<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<!-- Horizontal Form -->
				<div class="card card-info">
                    <div class="card-header">
	                    <h3 class="card-title">오전 생산계획</h3>
	                    <button type="button" class="btn btn-info btn-sm pt-0 pb-0 float-right" 
	                            onclick="moveDataToTempTableAndHideSome(t1, 'form1', [1,2])">
							추가
	                    </button>
                    </div>
                    <!-- /.card-header -->
                    <!-- form start -->
                    <form class="form-horizontal" id="form1">
	                    <div class="card-body">
	                        <div class="form-group row">
	                        	<label for="inputBox1" class="col-sm-4 col-form-label">제품명</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox1" readonly value="Click here">
		                            <input type="hidden" class="form-control" id="prodCode">
		                            <input type="hidden" class="form-control" id="prodRevNo">
		                        </div>
	                        </div>
	                        <div class="form-group row">
		                        <label for="prodGugyuk1" class="col-sm-4 col-form-label">규격</label>
		                        <div class="col-sm-8">
		                        	<input type="text" class="form-control" id="prodGugyuk1" readonly>
		                        </div>
	                        </div>
	                        <div class="form-group row">
		                        <div class="col-sm-4">현재고</div>
		                        <div class="col-sm-2" id="curStock"></div>
		                        <div class="col-sm-4">적정재고</div>
		                        <div class="col-sm-2" id="safeStock"></div>
	                        </div>
	                        <div class="form-group row">
		                        <label for="inputBox2" class="col-sm-4 col-form-label">계획수량</label>
		                        <div class="col-sm-8">
		                            <input type="number" class="form-control" id="inputBox2">
		                        </div>
	                        </div>
	                    </div>
	                    <!-- /.card-body -->
                    </form>
                </div>
                <!-- /.card -->
            </div>
            <!-- /.col -->
            <div class="col-md-6">
                <div class="card card-info">
                   <div class="card-header">
                        <h3 class="card-title">조회</h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body table-responsive">
                        <table class="table table-bordered" id="popupTable1">
                            <thead>
                                <tr>
                                    <td style="display:none">제품코드</td>
                                    <td style="display:none">제품 수정이력번호</td>
                                    <td>제품명</td>
                                    <td>규격</td>
                                    <td>계획수량</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <!-- /.card-body -->
                </div>
                <!-- /.card -->
            </div>
        </div>
        <!-- /.row -->
        
        <div class="row">
			<div class="col-md-6">
			<!-- Horizontal Form -->
				<div class="card card-info">
                    <div class="card-header">
	                    <h3 class="card-title">오후 생산계획</h3>
	                    <button type="button" class="btn btn-info btn-sm pt-0 pb-0 float-right" 
	                            onclick="moveDataToTempTableAndHideSome(t2, 'form2', [1,2])">
	                    	추가
	                    </button>
                    </div>
                    <!-- /.card-header -->
                    <!-- form start -->
                    <form class="form-horizontal" id="form2">
	                    <div class="card-body">
	                        <div class="form-group row">
	                        	<label for="inputBox3" class="col-sm-4 col-form-label">제품명</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox3" readonly value="Click here">
		                            <input type="hidden" class="form-control" id="prodCode2">
		                            <input type="hidden" class="form-control" id="prodRevNo2">
		                        </div>
	                        </div>
	                        <div class="form-group row">
	                        	<label for="prodGugyuk2" class="col-sm-4 col-form-label">규격</label>
		                        <div class="col-sm-8">
		                        	<input type="text" class="form-control" id="prodGugyuk2" readonly>
		                        </div>
	                        </div>
	                        <div class="form-group row">
		                        <div class="col-sm-4">현재고</div>
		                        <div class="col-sm-2" id="curStock2"></div>
		                        <div class="col-sm-4">적정재고</div>
		                        <div class="col-sm-2" id="safeStock2"></div>
	                        </div>
	                        <div class="form-group row">
		                        <label for="inputBox4" class="col-sm-4 col-form-label">계획수량</label>
		                        <div class="col-sm-8">
		                            <input type="number" class="form-control" id="inputBox4">
		                        </div>
	                        </div>
	                    </div>
	                    <!-- /.card-body -->
                    </form>
                </div>
                <!-- /.card -->
            </div>
            <!-- /.col -->
            <div class="col-md-6">
                <div class="card card-info">
                   <div class="card-header">
                        <h3 class="card-title">조회</h3>
                        <!-- <button type="button" class="btn btn-info float-right"
                        		onclick="removeData(t2)">
                            <i class="fas fa-minus"></i>
                        </button> -->
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body table-responsive">
                        <table class="table table-bordered" id="popupTable2">
                            <thead>
                                <tr>
                                    <td>제품명</td>
                                    <td style="display:none">제품코드</td>
                                    <td style="display:none">제품 수정이력번호</td>
                                    <td>규격</td>
                                    <td>계획수량</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <!-- /.card-body -->
                </div>
                <!-- /.card -->
            </div>
        </div>
        <!-- /.row -->
    </div><!-- /.container-fluid -->
</section>
<!-- /.content -->

<script type="text/javascript">
	var t1, t2;	// table 1~2
	var data;
	var checkval = true;
	
	$(document).ready(function () {
		
		var deleteBtn = " <button class='btn btn-info btn-sm' id='deleteRowBtn'> " +
						" 	<i class='fas fa-minus'></i> " +
						" </button>";
		
		setTimeout(function() { // setTimeout(){datatableId.removeAttr('width')} : 
								// datatable th/td 넓이 안 맞는 것 방지
		
	    	$('#datePlan').val('<%=selectedDate%>');
		    
	    	// 해당 생산계획의 기존 상세 정보를 가져온다
			$.ajax({
		        type: "GET",
		        url: '<%=Config.this_SERVER_path%>/Contents/CommonView/Plan/WeeklyPlanDataUpdate.jsp', 
		        data: { selectedDate : '<%=selectedDate%>', planRevNo : <%=planRevNo%> }, 
		        success: function (dataFromServer) {
		            data = dataFromServer;
					
		            var t1Opts = {
		    				scrollY : "12vh",
		        			lengthChange : false,
		    				paging : false,
		    				autoWidth : false,
		    				createdRow : "",
		        			columnDefs : [
		        				{
			        	       		'targets': [1, 2],
			        	       		'createdCell':  function (td) {
			        	          			$(td).attr('style', 'display: none;'); 
			        	       		}
		        	    		},
		        	    		{
		        	    			'targets': [5],
		        	    			'render': function(){
		        	    				console.log('hi');
		        	    				console.log(deleteBtn);
		        		  				return deleteBtn;
		        		  			}
		        	    		}
		        			],
		        	    	data : data.t1
		        	};
		        	
		            var t2Opts = {
		    				scrollY : "12vh",
		        			lengthChange : false,
		    				paging : false,
		    				autoWidth : false,
		    				createdRow : "",
		        			columnDefs : [
		        				{
			        	       		'targets': [1, 2],
			        	       		'createdCell':  function (td) {
			        	          			$(td).attr('style', 'display: none;'); 
			        	       		}
		        	    		},
		        	    		{
		        	    			'targets': [5],
		        	    			'render': function(){
		        	    				console.log('hi');
		        	    				console.log(deleteBtn);
		        		  				return deleteBtn;
		        		  			}
		        	    		}
		        			],
		        	    	data : data.t2
		        	};
		        	
		        	t1 = $('#popupTable1').removeAttr('width').DataTable(
		    			mergeOptions(heneMainTableOpts, t1Opts)
	    			);	// 오전생산계획조회
	    			t2 = $('#popupTable2').removeAttr('width').DataTable(
	    				mergeOptions(heneMainTableOpts, t2Opts)
	    			);	// 오후생산계획조회
		        
		        }
			});
			
		}, 300);
		
		// delete row on click minus button
	    $('#popupTable1 tbody').on('click', '#deleteRowBtn', function () {
	    	t1.row( $(this).parents('tr') ).remove().draw();
	    });
    	
	 	// delete row on click minus button
	    $('#popupTable2 tbody').on('click', '#deleteRowBtn', function () {
	    	t2.row( $(this).parents('tr') ).remove().draw();
	    });
	});
	
    // 제품명 input tag 클릭 시 제품 검색 팝업 생성
    $('#inputBox1').click(function() {
    	parent.pop_fn_ProductName_View(2, 1, '01');
    });
    
    $('#inputBox3').click(function() {
    	parent.pop_fn_ProductName_View(2, 2, '01');
    });
    
    // 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGugyuk, safeStock, curStock) {
    	
    	$('#inputBox1').val(prodName);
    	$('#prodCode').val(prodCode);
    	$('#prodRevNo').val(prodRevNo);
    	$('#safeStock').text(safeStock);
    	$('#curStock').text(curStock);
    	$('#prodGugyuk1').val(prodGugyuk);
    }
    
 	// 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code2(prodName, prodCode, prodRevNo, 
    							 prodGugyuk, safeStock, curStock) {
    	
    	$('#inputBox3').val(prodName);
    	$('#prodCode2').val(prodCode);
    	$('#prodRevNo2').val(prodRevNo);
    	$('#safeStock2').text(safeStock);
    	$('#curStock2').text(curStock);
    	$('#prodGugyuk2').val(prodGugyuk);
    }
 	
	function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
 	
    
    /*
     * 작성자 : 최현수
     * 역할 : 임시테이블로 데이터를 옮긴다
     */    
    function moveDataToTempTable(tableObj, formId) {
		
    	var formId = formId;
      	var prodNmVal = $('#inputBox1').val();
      	var prodCntVal = $('#inputBox2').val();
    	var prodNmVal2 = $('#inputBox3').val();
      	var prodCntVal2 = $('#inputBox4').val();
      	var tableLength = t1.page.info().recordsTotal;
      	var tableLength2 = t2.page.info().recordsTotal;  
      	
		if(formId == 'form1'){ //생산계획(EA) 추가 버튼 클릭했을 때
         	
         	for(var i = 0; i < tableLength; i++){
         	
         	var td1 = t1.cell(i, 2).data();
    		console.log(td1);
    		console.log(prodNmVal);

         	if(td1 == prodNmVal){ //같은 제품 정보를 추가하려고 했을 때 예외처리
         		
         		heneSwal.warning('각각 다른 제품을 등록하여 주세요.');
         		
         		$('#inputBox1').val('');
             	$('#prodCode').val('');
             	$('#prodRevNo').val('');
             	$('#curStock').text('');
             	$('#safeStock').text('');
         		
             	return false;
         	   }
         	  }
         	
         	if(prodNmVal == '') { //제품명이 선택되지 않았을 때 예외처리
         		heneSwal.warning('제품명을 선택하여 주세요.');	
         		return false;
         	    }
         
     		if(prodCntVal == 0 || prodCntVal == '' || Number.isInteger(parseFloat(prodCntVal)) == false) { //계획수량이 0이거나, 소수이거나, 입력하지 않았을 때 예외처리
         		heneSwal.warning('계획수량을 정확하게 입력하여 주세요.');	
         		return false;
         	    }
     		
          	}
		
		if(formId == 'form2'){ //생산계획(EA) 추가 버튼 클릭했을 때
         	
         	for(var i = 0; i < tableLength2; i++){
         	
         	var td1 = t2.cell(i, 2).data();
         	
         	if(td1 == prodNmVal2){ //같은 제품 정보를 추가하려고 했을 때 예외처리
         		
         		heneSwal.warning('각각 다른 제품을 등록하여 주세요.');
         		
         		$('#inputBox3').val('');
             	$('#prodCode2').val('');
             	$('#prodRevNo2').val('');
             	$('#curStock2').text('');
             	$('#safeStock2').text('');
         		
             	return false;
         	   }
         	  }
         	
         	if(prodNmVal2 == '') { //제품명이 선택되지 않았을 때 예외처리
         		heneSwal.warning('제품명을 선택하여 주세요.');	
         		return false;
         	    }
         
     		if(prodCntVal2 == 0 || prodCntVal2 == '' || Number.isInteger(parseFloat(prodCntVal2)) == false) { //계획수량이 0이거나, 소수이거나, 입력하지 않았을 때 예외처리
         		heneSwal.warning('계획수량을 정확하게 입력하여 주세요.');	
         		return false;
         	    }
     		
          	}
      	
      	
    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		
		dataArr.push(deleteBtn);
		
		tableObj.row.add(dataArr).draw();
		
		t1.columns.adjust();
		t2.columns.adjust();
		
    }
    
    /*
    * 작성자 : 최현수
    * 역할 : 임시테이블로 데이터를 옮기고 그 중 지정된 td 태그를 display:none 처리
    * 파라미터 : 해당 테이블, Form Tag ID, 감출 태그의 index 위치
    */
    function moveDataToTempTableAndHideSome(tableObj, formId, arrHide) {
    	
    	var formId = formId;
      	var prodNmVal = $('#inputBox1').val();
      	var prodCntVal = $('#inputBox2').val();
    	var prodNmVal2 = $('#inputBox3').val();
      	var prodCntVal2 = $('#inputBox4').val();
      	var tableLength = t1.page.info().recordsTotal;
      	var tableLength2 = t2.page.info().recordsTotal;  
    	
		if(formId == 'form1'){ //생산계획(EA) 추가 버튼 클릭했을 때
         	
         	for(var i = 0; i < tableLength; i++){
         	
         	var td1 = t1.cell(i, 0).data();
         
    		console.log(td1);
    		console.log(prodNmVal);

         	if(td1 == prodNmVal){ //같은 제품 정보를 추가하려고 했을 때 예외처리
         		
         		heneSwal.warning('각각 다른 제품을 등록하여 주세요.');
         		
         		$('#inputBox1').val('');
             	$('#prodCode').val('');
             	$('#prodRevNo').val('');
             	$('#curStock').text('');
             	$('#safeStock').text('');
         		
             	return false;
         	   }
         	  }
         	
         	if(prodNmVal == '') { //제품명이 선택되지 않았을 때 예외처리
         		heneSwal.warning('제품명을 선택하여 주세요.');	
         		return false;
         	    }
         
     		if(prodCntVal == 0 || prodCntVal == '' || Number.isInteger(parseFloat(prodCntVal)) == false) { //계획수량이 0이거나, 소수이거나, 입력하지 않았을 때 예외처리
         		heneSwal.warning('계획수량을 정확하게 입력하여 주세요.');	
         		return false;
         	    }
     		
          	}
		
		if(formId == 'form2'){ //생산계획(EA) 추가 버튼 클릭했을 때
         	
         	for(var i = 0; i < tableLength2; i++){
         	
         	var td1 = t2.cell(i, 0).data();
         	
         	if(td1 == prodNmVal2){ //같은 제품 정보를 추가하려고 했을 때 예외처리
         		
         		heneSwal.warning('각각 다른 제품을 등록하여 주세요.');
         		
         		$('#inputBox3').val('');
             	$('#prodCode2').val('');
             	$('#prodRevNo2').val('');
             	$('#curStock2').text('');
             	$('#safeStock2').text('');
         		
             	return false;
         	   }
         	  }
         	
         	if(prodNmVal == '') { //제품명이 선택되지 않았을 때 예외처리
         		heneSwal.warning('제품명을 선택하여 주세요.');	
         		return false;
         	    }
         
     		if(prodCntVal2 == 0 || prodCntVal2 == '' || Number.isInteger(parseFloat(prodCntVal2)) == false) { //계획수량이 0이거나, 소수이거나, 입력하지 않았을 때 예외처리
         		heneSwal.warning('계획수량을 정확하게 입력하여 주세요.');	
         		return false;
         	    }
     		
          	}
      	
      	
    	
    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		
		var rowNode = tableObj.row.add(dataArr).draw().node();
		
		function displayNone(position) {
			console.log('position : ' + position);
			var tdTag = $(rowNode)[0].childNodes[position];
			console.log('td : ' + tdTag);
			$(tdTag).css('display', 'none');
		}
		
		for(var i = 0; i < arrHide.length; i++) {
			displayNone(arrHide[i]);
		}
    }
    
    /*
     * 작성자 : 최현수
     * 역할 : 임시테이블로 옮겨진 데이터 Row를 삭제
     * 파라미터 : 해당 테이블
    */
	function removeData(tableObj) {
		 tableObj.row().remove().draw();
	}
    
	function insertDataIntoJsonObj(dataTable, jsonObj, keyName) {
		var obj2 = {};
		var colCnt = dataTable.columns().header().length;
		
		for(i = 0; i < colCnt; i++) {
			var key = String("col" + i);
			var value = String(this.data()[i]);
			obj2[key] = value;
		}
		
		jsonObj[keyName].push(obj2);
	};
	
	function SendTojsp(bomdata, pid){
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid },
	        success: function (html) {	
	        	if(html > -1) {
	        		heneSwal.success('계획 수정이 완료되었습니다');
	         		$('#modalForPlan').modal('hide');
	         		
	         		var date = new HeneDate();
	         		date.getFirstAndLastDaysOfWeek(new Date());
	         		parent.fn_MainInfo_List(date.monDate, date.satDate);
	         	} else {
	         		heneSwal.error('계획 수정 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
	
	/* 
	* 목적 : 테이블 1~2의 데이터를 json 타입으로 저장  후
	*	   SendTojsp의 파라미터로 넘겨줌
	*/
    function saveData() {
    	var jsonStr = '{"tHead":[],' +
    				  '	"tData1":[],' + 
		  		      '	"tData2":[]}';
    	
		var jObj = JSON.parse(jsonStr);
		
		// 날짜 데이터 tHead에 저장
		jObj['tHead'].push({'datePlan' : $('#datePlan').val()});
		// 계획수정이력번호 tHead에 저장
		jObj['tHead'].push({'planRevNo' : '<%=planRevNo%>'});
		
		// 테이블 별 데이터 tDataX에 각각 저장
		t1.rows().every(function() {
			insertDataIntoJsonObj.call(this, t1, jObj, 'tData1');
		});
		
		t2.rows().every(function() {
			insertDataIntoJsonObj.call(this, t2, jObj, 'tData2');
		});
		
		jsonStr = JSON.stringify(jObj);
		
		var planDate = $('#datePlan').val();
		var checkValue = t1.cell(0, 0).data();
		var checkValue2 = t2.cell(0, 0).data();
		
		if(planDate == '' || planDate == undefined){ //생산계획일자 선택 안하고 저장 누를때 예외처리
			heneSwal.warning('생산계획 일자를 선택해 주세요.');
			return false;	
		}
		
		if((checkValue == '' || checkValue == undefined) && (checkValue2 == '' || checkValue2 == undefined)){ //오전 생산계획 제품정보 1개 이상 추가 안하고 저장 누를 떄 예외처리
			heneSwal.warning('생산 계획을 수정할 제품 정보를 하나 이상 추가해 주세요.');
			return false;	
		}
		/* 
		if(checkValue2 == '' || checkValue2 == undefined){ //오후 생산계획 제품정보 1개 이상 추가 안하고 저장 누를 떄 예외처리
			heneSwal.warning('오후 생산 계획을 수정할 제품 정보를 하나 이상 추가해 주세요.');
			return false;	
		} */
		
		var check = confirm('해당 정보로 생산계획을 수정 하시겠습니까?');
		
		if(check){
	    	SendTojsp(jsonStr, "M303S020100E002");
		}
    }
   
</script>