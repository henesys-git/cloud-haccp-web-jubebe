<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	$(document).ready(function () {
		let date = new SetRangeDate("dateParent", "dateRange", 7);
		let mainTable;
		
		async function getData() {
	    	var percentAsDefaultCcpType = "%25";

	    	var startDate = date.getStartDate();
    		var endDate = date.getEndDate();
	    	var ccpType = percentAsDefaultCcpType;
    		
	        var fetchedData = $.ajax({
			            type: "POST",
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
			            data: "startDate=" + startDate + 
			            	  "&endDate=" + endDate + 
			            	  "&ccpType=" + ccpType,
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedData;
	    };
	    
	    async function initTable() {
	    	var data = await getData();
	    	
		    var customOpts = {
					data : data,
					pageLength: 10,
					columns: [
						{ data: "sensorKey", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "sensorName", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "event", defaultContent: '' },
						{ data: "sensorValue", defaultContent: '' },
						{ data: "valueJudge", defaultContent: '' },
						{ data: "improvement", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
    	
    	$("#getDataBtn").click(async function() {
    		var newData = await getData();
    		mainTable.clear().rows.add(newData).draw();
    	});
    	
    	$("#insert-btn").click(async function() {
    		// read meta-data
    		let filePath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/checklist16_0.txt';
    		let response = await fetch(filePath);
		    let metaData = await response.text();
		    
		 	// parse meta-data
    		let parser = new DOMParser();
    		let xmlDoc = parser.parseFromString(metaData, "text/xml");
    		
			// set modal size
			let modalWidth = xmlDoc.getElementsByTagName("width")[0].innerHTML;
			let modalHeight = xmlDoc.getElementsByTagName("height")[0].innerHTML;
			
			
			document.getElementById('checklist-wrapper').style.width = modalWidth;
			document.getElementById('checklist-wrapper').style.height = modalHeight;
			
    		$("#myModal").modal("show");
    		
    		// read checklist image
    		var canvas = document.getElementById('myCanvas');
    		
    		let modalWidthWithoutPxKeyword = modalWidth.replace('px', '');
			let modalHeightWithoutPxKeyword = modalHeight.replace('px', '');
			
    		canvas.width = modalWidthWithoutPxKeyword;
    		canvas.height = modalHeightWithoutPxKeyword;
    		
			var ctx = canvas.getContext('2d');
    		
    		var bgImg = new Image();
			bgImg.src = '/checklist/' + heneBizNo + '/images/checklist16_0.jpg';
			
			bgImg.onload = function() {
				ctx.drawImage(bgImg, 0, 0);
			};
    		
    		// generate tags
    		var cellList = xmlDoc.getElementsByTagName("cells")[0].childNodes;
    		
			for(var i=0; i<cellList.length; i++) {
				var cell = cellList[i];
				makeTag(cell);
			};
    		
    		// save data to db
    		$('#save-btn').click(function() {
    			var head = {};
    			var checklistData = {};

    			let elements = document.getElementsByClassName('checklist-data');

				for(var i=0; i<elements.length; i++) {
					let element = elements[i];
					checklistData[element.id] = element.value;
				}
				
    			head.checklistId = 'checklist16';
    			head.revisionNo = '0';
				head.checklistData = checklistData;
				
				$.ajax({
					type: "POST",
			        url: heneServerPath + "/checklist",
			        data: "data=" + JSON.stringify(head),
			        success: function (result) {
			        	console.log(result);
			        }
				});
    		});
    	});
    	
    	$("#select-btn").click(function() {
    		let checklistId = 'checklist16';
    		let seqNo = '1';
    		
    		$.ajax({
				type: "GET",
		        url: heneServerPath + "/checklist"
		        	+ "?checklistId=" + checklistId
		        	+ "&seqNo=" + seqNo,
		        success: function (result) {
		        	console.log(result);
		        }
			});
    	});
    });
	
	function makeTag(cell) {
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		var startX = cell.childNodes[2].textContent;
		var startY = cell.childNodes[3].textContent;
		var width = cell.childNodes[4].textContent;
		var height = cell.childNodes[5].textContent;
		
		let tag;
		
		switch(type) {
			case "signature-writer":
				tag = document.createElement('button');
				tag.classList.add('signature-writer');
				tag.innerHTML = "서명";
				break;
			case "signature-approver":
				tag = document.createElement('button');
				tag.classList.add('signature-approver');
				tag.innerHTML = "서명";
				break;
			case "signature-checker":
				tag = document.createElement('button');
				tag.classList.add('signature-checker');
				tag.innerHTML = "서명";
				break;
			case "date":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				break;
			case "text":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				break;
			case "truefalse":
				tag = document.createElement('input');
				if(format === 'checkbox') {
					tag.type = 'checkbox';
				}
				
				tag.classList.add("checklist-data");
				break;
			case "textarea":
				tag = document.createElement('textarea');
				tag.classList.add("checklist-data");
				break;
		}
		
		tag.id = id;
		tag.style.position = 'absolute';
		tag.style.left = startX;
		tag.style.top = startY;
		tag.style.width = width;
		tag.style.height = height;
		
		document.getElementById("checklist-wrapper").appendChild(tag);
	}
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	CCP 데이터 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
			<button type="button" id="insert-btn" class="btn btn-outline-dark">
				점검표 등록
			</button>
			<button type="button" id="update-btn" class="btn btn-outline-success">
				점검표 수정
			</button>
			<button type="button" id="delete-btn" class="btn btn-outline-danger">
				점검표 삭제
			</button>
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
          		CCP 데이터 목록
          	</h3>
          	<div class="card-tools">
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default" id="getDataBtn">
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
					    <th>묶음값</th>
					    <th>생성시간</th>
					    <th>센서명</th>
					    <th>제품</th>
					    <th>이벤트</th>
					    <th>측정값</th>
					    <th>적/부</th>
					    <th>개선조치</th>
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

<div class="modal fade" id="myModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">점검표 등록</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      	<div id="checklist-wrapper" style="position:relative;">
			<canvas id="myCanvas"></canvas>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" id="save-btn" class="btn btn-primary">등록</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>