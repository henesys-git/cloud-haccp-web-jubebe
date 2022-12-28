<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	var dataJspPage = {};
	var mainTable;
	
	$(document).ready(function () {
		
		let mainTableSelectedRow;
		
	    async function initTable() {
	    	var results = new ProductionResult();
	    	var resultsList = await results.getProductionResults();
		    var customOpts = {
					data : resultsList,
					pageLength: 10,
					columns: [
						{ data: "planNo", defaultContent: '' },
						{ data: "workLineNo", defaultContent: '' },
						{ data: "planCountAllocated", defaultContent: '' },
						{ data: "workDate", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "workStartTime", defaultContent: '' },
						{ data: "workFinishTime", defaultContent: '' },
						{ data: "packingCount", defaultContent: '' },
						{ data: "workerCount", defaultContent: '' },
						{ data: "rawMaterialDeductYn", defaultContent: '' },
						{ data: "workStatus", defaultContent: '' },
						{ data: "ipgoYn", defaultContent: '' },
						{ data: "productId", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
					  			targets: [0,1,2,8,9,10,12],
					  			createdCell:  function (td) {
				          			$(td).attr('style', 'width:0px; display: none;'); 
				       			}
				  		},
				  		{
				  			targets: [11],
				  			render: function(td, cellData, rowData, row, col){
				  				console.log(cellData);
				  				if (rowData.ipgoYn == 'N') {
				  					return "<button type='button' class='btn btn-success' id='btn_ipgo' onclick='prod_ipgo(this);'>입고</button>";
				  				}
				  				else {
				  					return "입고완료";
				  				}
				  			}
				  		}
				    ]
			}
					
			mainTable = $('#resultTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function refreshMainTable() {
	    	var results = new ProductionResult();
	    	var resultsList = await results.getProductionResults();
	    	
    		mainTable.clear().rows.add(resultsList).draw();
    		
		}
	     
		initTable();
		
    });
	
	//점검표 알람 정보 수정
	function prod_ipgo(obj) {
		
    	var rowIdx = $(obj).closest("tr").index();
		var row = mainTable.rows(rowIdx).data();
		var planNo = row[0].planNo;
		var productId = row[0].productId;
			
		$.ajax({
            type: "POST",
            url: heneServerPath + '/Contents/mes/mes_product_stock_manage.jsp',
            data: {
            	productId: row[0].productId,
            	productName: row[0].productName,
            	ipgoOnly: "Y"
            },
            success: function (html) {
                $("#modalWrapper").html(html);
            }
        });
		
	}
	
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	생산실적 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
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
          		생산실적 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="resultTable" style="width:100%">
				<thead>
					<tr>
						<th style="display:none; width:0px;">생산계획번호</th>
						<th style="display:none; width:0px;">작업라인번호</th>
						<th style="display:none; width:0px;">할당계획수량</th>
						<th>작업일자</th>
						<th>제품명</th>
					    <th>작업시작시간</th>
					    <th>작업종료시간</th>
					    <th>포장수량</th>
					    <th style="display:none; width:0px;">작업인원</th>
					    <th style="display:none; width:0px;">원자재차감여부</th>
					    <th style="display:none; width:0px;">작업상태</th>
					    <th>입고여부</th>
					    <th style="display:none; width:0px;">제품아이디</th>
					</tr>
				</thead>
				<tbody id="resultTableBody">		
				</tbody>
			</table>
          </div>
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->

 <div id="modalWrapper"></div>