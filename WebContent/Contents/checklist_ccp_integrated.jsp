<!-- 
	- CCP(가열공정, 금속검출공정, 크림공정 등) 전용 점검표 화면 페이지
	- 기존의 metaldetector.jsp, heating.jsp 등을 통합해서 이 jsp 파일 하나로 사용
	- MasterMainPage.jsp의 fn_SubMain에서 db에서 받은 메뉴명을 기준으로
	  공정코드(processCode)와 CCP 종류(ccpType)을 받아서 각 CCP별 필요한
	  점검표 이미지와 메타데이터를 가져옴
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String login_name = session.getAttribute("login_name").toString();
	String bizNo = session.getAttribute("bizNo").toString();
	
	String menuName = "";
	String processCode = "";// PC10, PC20, etc...
	String ccpType = "";	// heating, metaldetect, cream, etc..
	
	if(request.getParameter("processCode") != null) 
		processCode = request.getParameter("processCode");
	
	if(request.getParameter("ccpType") != null) 
		ccpType = request.getParameter("ccpType");
	
	if(request.getParameter("MenuTitle") != null) 
		menuName = request.getParameter("MenuTitle");
%>

<style>
	input[type="date"]::-webkit-inner-spin-button,
	input[type="date"]::-webkit-calendar-picker-indicator {
	   	color: rgba(0, 0, 0, 0);
	}
</style>

<script src="<%=Config.this_SERVER_path%>/js/checklist.modal.js"></script>
<script type="text/javascript">
    
    var mainTable;
    var formClassificationCriteria;
    
	$(document).ready(async function () {
		
		var date = new SetRangeDate("dateParent", "dateRange", 7);
    	var startDate = date.start.format('YYYY-MM-DD');
       	var endDate = date.end.format('YYYY-MM-DD');
		
		async function getHeadDataList(startDate, endDate, formClassificationCriteria) {
			var fetchedList = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ccptestvm"
		            	+ "?method=" + 'head'
		            	+ "&startDate=" + startDate
		            	+ "&endDate=" + endDate
		            	+ "&processCode=<%=processCode%>"
		            	+ "&formClassificationCriteria=" + formClassificationCriteria,
	            success: function (result) {
	            	return result;
	            }
			});
	    
	    	return fetchedList;
	    };
	    
	    async function initTable() {

	    	var clInfo = new ChecklistInfo();
	    	formClassificationCriteria = await clInfo.getFormClassificationCriteria("<%=ccpType%>");
	    	
	    	if(!formClassificationCriteria) {
	    		console.error('점검표 분류 기준 DB 테이블 정보 등록 필요');
	    		return false;
	    	}
	    	
	    	var list = await getHeadDataList(startDate, endDate, formClassificationCriteria);

	    	//서명 칼럼 index 들어갈 배열
	    	var columnDefsKeys = new Array();
	    	//html 고정th명(점검표아이디, 일련번호, 양식수정이력번호)
	    	var fixedTh = new Array();
			//db로부터 받아온 칼럼명
			var fixedColumn = new Array();
			// 하단 datatable 고정영역 columns 변수 array로 만들기  (점검표아이디, 일련번호, 양식수정이력번호) 
			var columnKeys = []

			if(formClassificationCriteria === '센서별제품그룹별') {
				fixedTh[0] = "날짜";
				fixedTh[1] = "센서아이디";
				fixedTh[2] = "센서명";
				fixedTh[3] = "제품분류아이디";
				fixedTh[4] = "제품분류명";
				
				fixedColumn[0] = "createDate";
				fixedColumn[1] = "sensorId";
				fixedColumn[2] = "sensorName";
				fixedColumn[3] = "parentId";
				fixedColumn[4] = "parentName";

				columnKeys = [
	   				{data: fixedColumn[0] , defaultContent : '' }, 
	   			  	{data: fixedColumn[1] , defaultContent : '' },
	   			  	{data: fixedColumn[2] , defaultContent : '' },
	   			  	{data: fixedColumn[3] , defaultContent : '' },
	   			  	{data: fixedColumn[4] , defaultContent : '' }
	   			];
			}
			else if(formClassificationCriteria === '제품그룹별') {
				fixedTh[0] = "날짜";
				fixedTh[1] = "제품분류아이디";
				fixedTh[2] = "제품분류명";
				
				fixedColumn[0] = "createDate";
				fixedColumn[1] = "parentId";
				fixedColumn[2] = "parentName";
				
				columnKeys = [
	   				{data: fixedColumn[0] , defaultContent : '' }, 
	   			  	{data: fixedColumn[1] , defaultContent : '' },
	   			  	{data: fixedColumn[2] , defaultContent : '' }
	   			];
			}
			else if(formClassificationCriteria === '센서별') {
				fixedTh[0] = "날짜";
				fixedTh[1] = "센서아이디";
				fixedTh[2] = "센서명";
				
				fixedColumn[0] = "createDate";
				fixedColumn[1] = "sensorId";
				fixedColumn[2] = "sensorName";
				
				columnKeys = [
	   				{data: fixedColumn[0] , defaultContent : '' }, 
	   			  	{data: fixedColumn[1] , defaultContent : '' },
	   			  	{data: fixedColumn[2] , defaultContent : '' }
	   			];
			}
			
			// 고정영역 html th 태그 만들기(점검표아이디, 일련번호, 양식수정이력번호)
	    	for(var a = 0; a < fixedTh.length; a++) {
				$("#ccpDataTable thead tr").append("<th>"+fixedTh[a]+"</th>");
	    	}
	    	
			//columns : 상단에서 정의된 columnKeys 사용
			//columnDefs - targets : 서명버튼 정의될 칼럼 index로 columnDefsKeys 사용
			//서명 칼럼에 데이터가 없으면 서명버튼을 칼럼명에 맞게 생성한다. 
		    var customOpts = {
				data : list,
				pageLength: 10,
				columns : columnKeys
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    };
	    
		await initTable();
		
    	$("#select-btn").off().click(function() {
    		let selectedRows = mainTable.rows('.selected').data();
			let selectedRow = selectedRows[0];
			
    		if(selectedRows.length > 1) {
    			alert('하나만 선택해주세요.');
    			return false;
    		}

    		if(!selectedRow) {
				alert('정보를 조회할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let createDate = selectedRow.createDate;
			let parentId = '';
			let sensorId = '';
			
    		if(formClassificationCriteria === '센서별제품그룹별') {
    			parentId = selectedRow.parentId;
	    		sensorId = selectedRow.sensorId;
    		}
    		else if(formClassificationCriteria === '제품그룹별') {
    			parentId = selectedRow.parentId;
    		}
    		else if(formClassificationCriteria === '센서별') {
	    		sensorId = selectedRow.sensorId;
    		}
    		
    		var modal = new ChecklistSelectModalCCP(createDate, formClassificationCriteria, sensorId, parentId);
    		modal.openModal();
    	});
    	
    	$('#checklist-select-btn-close').off().click(function() {
    		var children = $('#checklist-select-wrapper').children();
    		
    		for(let i=1; i<children.length; i++) {
    			children[i].remove();
    		}
    		
    		$('#checklist-select-modal').modal('hide');
    	});
    	
    	async function refreshMainTable() {
           	var startDate = date.getStartDate();
           	var endDate = date.getEndDate();
    		var list = await getHeadDataList(startDate, endDate, formClassificationCriteria);
    		mainTable.clear().rows.add(list).draw();
    	}
    	
    	$('#dateRange').change(function() {
    		refreshMainTable();
        });
    });
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	<%=menuName%>
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
			<button type="button" id="select-btn" class="btn btn-outline-dark">
				점검표 조회
			</button>
      	</div>
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->

<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle"></i>
          		<%=menuName%> 목록
          	</h3>
          	<div class="card-tools">
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default">
          	  	    <i class="fas fa-search"></i>
          	  	  </button>
          	  	</div>
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					</tr>
				</thead>
				<tbody id="ccpDataTableBody">		
				</tbody>
			</table>
          </div> 
        </div>
      </div>
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->