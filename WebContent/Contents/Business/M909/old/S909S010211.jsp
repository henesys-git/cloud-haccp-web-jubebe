<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.frame.database.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_REVISION_NO = "", GV_PROD_CD = "";
	
    if(request.getParameter("prod_cd") != null)
		GV_PROD_CD = request.getParameter("prod_cd");
    
    if(request.getParameter("Prod_Rev_No") != null)
		GV_REVISION_NO = request.getParameter("Prod_Rev_No");
%>
<style>

	.card.card-info{
		height : 300px;
	}

</style>
        
<script type="text/javascript">

	var blendRatioTable; // 배합율 입력 table
    
    $(document).ready(function () {
	    
    	setTimeout(function(){ // setTimeout(){datatableId.removeAttr('width')} : 
			   				   // datatable th/td 넓이 안 맞는 것 방지
    	
		    var customOpts = {
	    			scrollY : "12vh",
	    			lengthChange : false,
					paging : false,
					autoWidth : false
	    	}
	    
    		blendRatioTable = $('#popupTable1').removeAttr('width').DataTable(
    						mergeOptions(heneMainTableOpts, customOpts)
    					 );
	    
     	}, 300);
    });
    
 	// 원부재료/자재명 input tag 클릭 시 원부재료/자재명 검색 팝업 생성
    var partNameBox = $('#inputBox1');
    partNameBox.click(function() {
    	parent.pop_fn_PartList_View(1)
    });

 	// 원부재료/자재 검색 후 클릭한 데이터를 가져옴
	function SetpartName_code(partName, partCd, partRevNo, gyugeok, unitPrice) {
		
 		$('#inputBox1').val(partName);
		$('#inputBox2').val(partCd);
		$('#partRevNo').val(partRevNo);
		$('#partGyuGeok').val(gyugeok);
		$('#partUnitPrice').val(unitPrice);
	}

 	// 임시테이블로 데이터를 옮긴다.
	function moveDataToTempTable(tableObj, formId) {

    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		
		tableObj.row.add(dataArr).draw();
    }

 	// 임시테이블로 데이터를 옮기고 그 중 지정된 td 태그를 display:none 처리
	function moveDataToTempTableAndHideSome(tableObj, formId, arrHide) {
    	
    	var dataArr = [];
		
		$('#' + formId + ' input').each(function () {
    		var valueInInputTag = $(this).val();
			dataArr.push(valueInInputTag);
		});
		
		var rowNode = tableObj.row.add(dataArr).draw().node();

		function displayNone(position) {
			var tdTag = $(rowNode)[0].childNodes[position];
			$(tdTag).css('display', 'none');
		}
		
		arrHide.forEach(displayNone);
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
	
	function insertIntoDb(bomdata, pid) {
	    $.ajax({
	    	type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	        data:  {"bomdata" : bomdata , "pid" : pid},
	        success: function (html) {
	        	 if(html > -1) {
	        		heneSwal.success("배합정보가 등록되었습니다.");
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	 } else {
		         	heneSwal.error('배합 정보 등록에 실패했습니다, 다시 시도해주세요');
	        	 }
	        }
		});
	}
	
	// 테이블 데이터를 json 타입으로 저장
	function saveData() {
		var jsonStr = '{"tData1":[]}';
		
		var jObj = JSON.parse(jsonStr);
		
		blendRatioTable.rows().every(function(){
			insertDataIntoJsonObj.call(this, blendRatioTable, jObj, 'tData1');
		});
		
		jsonStr = JSON.stringify(jObj);
		
		var result = confirm("등록하시겠습니까?");
		
		if(result){
			insertIntoDb(jsonStr, "M909S010100E001");
		} else{
			return false;
		}
	}
</script>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
			<!-- Horizontal Form -->
				<div class="card card-info">
                    <div class="card-header">
	                    <h3 class="card-title">배합정보 등록</h3>
	                    <button type="button" class="btn btn-info float-right" 
	                            onclick="moveDataToTempTableAndHideSome(blendRatioTable, 'form1',[2,3,4,5,6])">
	                        <i class="fas fa-plus"></i>
	                    </button>
                    </div>
                    <!-- /.card-header -->
                    <!-- form start -->
                    <form class="form-horizontal" id="form1">
	                    <div class="card-body">
	                        <div class="form-group row">
	                        	<label for="inputBox1" class="col-sm-4 col-form-label">원부재료/자재명</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox1" readonly placeholder="click here">
		                        </div>
	                        </div>
	                        <div class="form-group row">
	                        	<label for="inputBox2" class="col-sm-4 col-form-label">원부재료/자재 코드</label>
		                        <div class="col-sm-8">
		                            <input type="text" class="form-control" id="inputBox2" readonly>
		                            <input type="hidden" class="form-control" id="partRevNo">
		                            <input type="hidden" class="form-control" id="partGyuGeok">
		                            <input type="hidden" class="form-control" id="partUnitPrice">
		                            <input type="hidden" class="form-control" id="prodCode" value="<%=GV_PROD_CD%>">
		                            <input type="hidden" class="form-control" id="prodRevNo" value="<%=GV_REVISION_NO%>">
		                        </div>
	                        </div>
	           				<div class="form-group row">
		                        <label for="inputBox3" class="col-sm-4 col-form-label">배합율</label>
		                        <div class="col-sm-8">
		                            <input type="number" class="form-control" id="inputBox3">
		                        </div>
	                        </div>
	                        <div>
	                    		<p style = "margin-left : 20px;">
	                    			배합비율 1당 = 100%로 적용됩니다.
	                    		</p>
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
                        <button type="button" class="btn btn-info float-right"
                        		onclick="removeData(blendRatioTable)">
                            <i class="fas fa-minus"></i>
                        </button>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <table class="table table-bordered" id="popupTable1">
                            <thead>
                                <tr>
                                    <td>원부재료/자재명</td>
                                    <td>원부재료/자재코드</td>
                                    <td style="display:none">원부재료/자재 수정이력번호</td>
                                    <td style="display:none">원부재료/자재 규격</td>
                                    <td style="display:none">단가</td>
                                    <td style="display:none">완제품코드</td>
                                    <td style="display:none">완제품수정이력번호</td>
                                    <td>배합율</td>
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