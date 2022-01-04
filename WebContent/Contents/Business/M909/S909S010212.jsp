<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.frame.database.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_PROD_CD="", GV_PROD_NM="", GV_PROD_REV_NO = "";
    String GV_BOM_REV_NO = "";
    
    if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
    
    if(request.getParameter("prod_rev_no")== null)
		GV_PROD_REV_NO="";
	else
		GV_PROD_REV_NO = request.getParameter("prod_rev_no");
    
    if(request.getParameter("bom_rev_no")== null)
		GV_BOM_REV_NO="";
	else
		GV_BOM_REV_NO = request.getParameter("bom_rev_no");
    
    if(request.getParameter("prod_nm")== null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
    
    JSONObject jArray = new JSONObject();
	jArray.put("prod_cd", GV_PROD_CD);
    
    DoyosaeTableModel table = new DoyosaeTableModel("M909S010100E004", jArray);
    int row = table.getRowCount();
    VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<style>

	.card.card-info{
		height : 250px;
	}

</style>
 
<script type="text/javascript">
	var ratioTable; // 배합비율 입력 table
	var bomRevData;
    $(document).ready(function () {

    	setTimeout(function(){ // setTimeout(){datatableId.removeAttr('width')} : 
			   				   // datatable th/td 넓이 안 맞는 것 방지
		
	    var customOpts = {
    			scrollY : "12vh",
    			lengthChange : false,
				paging : false,
				autoWidth : false,
				createdRow : "",
    			columnDefs : [{
    	       		'targets': [1,2,3,4,5],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}]
				
    	}
	    
    	ratioTable = $('#popupTable1').removeAttr('width').DataTable
    	(mergeOptions(heneMainTableOpts, customOpts));
	    
	    intiBomData(ratioTable, [1,2,3,4,5]);
	    
      },300);
    	
    });
	
    var deleteBtn = " <button class='btn btn-info btn-sm' id='deleteRowBtn'> " +
	" 	<i class='fas fa-minus'></i> " +
	" </button>";
	
	// delete row on click minus button
    $('#popupTable1 tbody').on('click', '#deleteRowBtn', function () {
    	ratioTable.row( $(this).parents('tr') ).remove().draw();
    });
    
 	// 원부재료/자재명 input tag 클릭 시 원부재료/자재명 검색 팝업 생성
    var partNameBox = $('#inputBox1');
    partNameBox.click(function() {
    	<%-- parent.pop_fn_BomUpdateDelete_View("<%=GV_PROD_NM%>") --%>
    	parent.pop_fn_PartList_View(1)
    });

 	// 원부재료/자재 검색 후 클릭한 데이터를 가져옴 -old
	function SetBomInfo(part_name, part_cd, part_revision_no, prod_cd, prod_revision_no, bom_revision_no, blending_ratio, prod_name){

	 	$('#inputBox1').val(part_name);
		$('#inputBox2').val(part_cd);
		$('#partRevNo').val(part_revision_no);
		$('#prodCode').val(prod_cd);
		$('#prodRevNo').val(prod_revision_no);
		$('#bomRevNo').val(bom_revision_no);
		$('#inputBox3').val(blending_ratio);
		
	}
 	
	// 원부재료/자재 검색 후 클릭한 데이터를 가져옴
	function SetpartName_code(txt_part_name, txt_part_cd, txt_part_revision_no, txt_gyugeok){
		
 		$('#inputBox1').val(txt_part_name);
		$('#inputBox2').val(txt_part_cd);
		$('#partRevNo').val(txt_part_revision_no);
		$('#partGyuGeok').val(txt_gyugeok);
		//$('#partUnitPrice').val(txt_unit_price);
	}
 	

 	// 임시테이블로 데이터를 옮긴다.
	function moveDataToTempTable(tableObj, formId) {

    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		dataArr.push(deleteBtn);
		
		tableObj.row.add(dataArr).draw();
		
		ratioTable.columns.adjust();
    }
	
 	function intiBomData(tableObj, arrHide){
 		
 		<%for(int i = 0; i < row; i++){%>
 		
 		var dataArr = [];	
 			dataArr.push('<%=table.getValueAt(i, 0)%>');
 			dataArr.push('<%=table.getValueAt(i, 1)%>');
 			dataArr.push('<%=table.getValueAt(i, 2)%>');
 			dataArr.push('<%=table.getValueAt(i, 3)%>');
 			dataArr.push('<%=table.getValueAt(i, 4)%>');
 			dataArr.push('<%=table.getValueAt(i, 5)%>');
 			dataArr.push('<%=table.getValueAt(i, 6)%>');
 			dataArr.push(deleteBtn);
 		
 		console.log(dataArr);
 		
 		var rowNode = tableObj.row.add(dataArr).draw().node();
 		
 		function displayNone(position) {
			var tdTag = $(rowNode)[0].childNodes[position];
			$(tdTag).css('display', 'none');
		}
 			arrHide.forEach(displayNone);
		
 		<%}%>
 		
 		ratioTable.columns.adjust();
 		
 	}
 	
 	// 임시테이블로 데이터를 옮기고 그 중 지정된 td 태그를 display:none 처리
	function moveDataToTempTableAndHideSome(tableObj, formId, arrHide) {
    	
		var formId = formId;
    	var partNmVal = $('#inputBox1').val();
    	var partRatioVal = $('#inputBox3').val();
    	var tableLength = ratioTable.page.info().recordsTotal;
    	
    if(formId == 'form1'){ //배합정보 수정 추가 버튼 클릭했을 때
    	
    	for(var i = 0; i < tableLength; i++){
    	
    	var td1 = ratioTable.cell(i, 0).data();
    	
    	if(td1 == partNmVal){ //같은 원부자재 정보를 추가하려고 했을 때 예외처리
    		
    		heneSwal.warning('각각 다른 원부자재를 등록하여 주세요.');
    		
    		$('#inputBox1').val('');
    		$('#inputBox2').val('');
        	$('#partRevNo').val('');
        	$('#partGyuGeok').val('');
        	$('#prodCode').val('');
        	$('#prodRevNo').val('');
    		
        	return false;
    	   }
    	  }
    	
    	if(partNmVal == '') { //원부자재명이 선택되지 않았을 때 예외처리
    		heneSwal.warning('원부재료/자재명을 선택하여 주세요.');	
    		return false;
    	    }
    
    
		if(partRatioVal == 0 || partRatioVal == '' || partRatioVal > 1) { //배합비율이 0 ~ 1 사이의 값이 아니거나, 입력하지 않았을 때 예외처리
    		heneSwal.warning('배합비율을 0 ~ 1 사이의 값으로 정확하게 입력하여 주세요.');	
    		return false;
    	    }
		
     	}
 		
    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		
		dataArr.push(deleteBtn);
		
		var rowNode = tableObj.row.add(dataArr).draw().node();
		console.log(rowNode);
		function displayNone(position) {
			var tdTag = $(rowNode)[0].childNodes[position];
			$(tdTag).css('display', 'none');
		}
		
		arrHide.forEach(displayNone);
		
		ratioTable.columns.adjust();
    }

	// 임시테이블로 옮겨진 데이터 Row를 삭제
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
	        data:  {"bomdata" : bomdata , "pid" : pid},
	        success: function (html) {
	        	 if(html > -1) {
	        		heneSwal.success("배합정보가 수정되었습니다.");
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else {
		         		heneSwal.error('배합 정보 수정에 실패했습니다, 다시 시도해주세요');
	         }
	        },
	        error : function(xhr, option, error){
	        	
	        }
	     });
	}
	
	// 테이블 데이터를 json 타입으로 저장
	function saveData(){
		var jsonStr = '{"tData1":[]}';
		
		var jObj = JSON.parse(jsonStr);
		
		ratioTable.rows().every(function(){
			insertDataIntoJsonObj.call(this, ratioTable, jObj, 'tData1');
		});
		
		jsonStr = JSON.stringify(jObj);
		
		var checkValue = ratioTable.cell(0, 0).data();
		var tableLength = ratioTable.page.info().recordsTotal;
		var sumRatio = new Number();
		
		if(checkValue == '' || checkValue == undefined){ //원부자재 정보 1개 이상 추가 안하고 저장 누를 떄 예외처리
			heneSwal.warning('배합정보를 수정할 원부자재 정보를 하나 이상 추가해 주세요.');
			return false;	
		}
		
		for(var i = 0; i < tableLength; i++){
	    	var partRatio = ratioTable.cell(i, 6).data();
			sumRatio += parseFloat(partRatio);	    	
	   	}
		console.log(sumRatio);
		
		if(sumRatio != 1){
			heneSwal.warning('배합비율의 총합은 1이 되어야 합니다.');
			return false;
		}
		console.log(jsonStr);
		
		var result = confirm("수정하시겠습니까?");
		
		if(result){
			SendTojsp(jsonStr, "M909S010100E002");
		} else{
			
		}
		
	}
	

    </script>
</head>
<body>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
			<!-- Horizontal Form -->
				<div class="card card-info">
                    <div class="card-header">
	                    <h3 class="card-title">배합정보 수정</h3>
	                    <button type="button" class="btn btn-info btn-sm pt-0 pb-0 float-right" 
	                            onclick="moveDataToTempTableAndHideSome(ratioTable, 'form1',[1,2,3,4,5])">
	                       	추가
	                    </button>
                    </div>
                    <!-- /.card-header -->
                    <!-- form start -->
                    <form class="form-horizontal" id="form1">
	                    <div class="card-body">
	                        <div class="form-group row">
	                        	<label for="inputBox1" class="col-sm-4 col-form-label">원부재료/자재명</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox1" readonly placeholder="click here"/>
		                            
		                        </div>
	                        </div>
	                        <div class="form-group row">
	                        	<label for="inputBox2" class="col-sm-4 col-form-label">원부재료/자재 코드</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox2" readonly/>
		                            <input type="hidden" class="form-control" id="partRevNo" />
		                            <input type="hidden" class="form-control" id="prodCode" value = "<%=GV_PROD_CD%>"/>
		                            <input type="hidden" class="form-control" id="prodRevNo" value = "<%=GV_PROD_REV_NO%>"/>
		                            <input type="hidden" class="form-control" id="bomRevNo" value = "<%=table.getValueAt(0, 5)%>"/>
		                        </div>
	                        </div>
	           					<div class="form-group row">
		                        <label for="inputBox3" class="col-sm-4 col-form-label">배합비율</label>
		                        <div class="col-sm-8">
		                            <input type="number" class="form-control" id="inputBox3" min="0">
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
                        		onclick="removeData(ratioTable)">
                            <i class="fas fa-minus"></i>
                        </button> -->
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <table class="table table-bordered" id="popupTable1">
                            <thead>
                                <tr>
                                    <td>원부재료/자재명</td>
                                    <td style="display:none">원부재료/자재코드</td>
                                    <td style="display:none"></td>
                                    <td style="display:none"></td>
                                    <td style="display:none"></td>
                                    <td style="display:none"></td>
                                    <td>배합비율</td>
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
       </div>
       <!-- container-fluid -->
       </section>