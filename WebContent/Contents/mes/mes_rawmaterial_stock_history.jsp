<!-- 
원부재료 이력 조회
 -->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%
	String rawmaterialStockNo = "";
	
	if(request.getParameter("rawmaterialStockNo") != null) {
		rawmaterialStockNo = request.getParameter("rawmaterialStockNo");
	}
%>

<style>
	.modal-content {
		width: 1000px;
	}
</style>

<!-- 메인 모달창 -->
<div class="modal fade" id="stockHistoryModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title"></h3>
      </div>
      <div class="modal-body">
		<!-- Main content -->
		<div class="content">
		  <div class="container-fluid">
		    <div class="row">
		      <div class="col-md-12">
		        <div class="card card-primary card-outline">
		          <div class="card-header row">
		       		<div class="col-md-12">
			          	<h3 class="card-title">
			          		<i class="fas fa-edit" id="InfoContentTitle"></i>
			          		원부재료 재고 이력
			          	</h3>
			        </div>
		          </div>
		           
		          <div class="card-body">
		          	<table class='table table-bordered nowrap table-hover' 
						   id="historyTable" style="width:100%;">
						<thead>
							<tr>
							    <th>재고번호</th>
							    <th>원부재료아이디</th>
							    <th>원부재료명</th>
							    <th>입출고시간</th>
							    <th>입출고수량</th>
							    <th>사용처</th>
							</tr>
						</thead>
						<tbody id="historyTableBody">
						</tbody>
					</table>
		          </div>
		          <div class="card-footer">
					<button class="btn" id="closeBtn" style="float: right;">
						닫기
					</button>
				  </div>
		         
		        </div>
		      </div>
		      <!-- /.col-md-6 -->
		    </div>
		    <!-- /.row -->
		  </div><!-- /.container-fluid -->
		</div>
		<!-- /.content -->
      </div>
    </div>
  </div>
</div>



<script>
	
	$(document).ready(async function () {
		let rawmaterialStorage = new RawmaterialStorage();
		let stocks = await rawmaterialStorage.getStock("<%=rawmaterialStockNo%>");
    	
		$('#stockHistoryModal').on('show.bs.modal', function () {
			let customOpts = {
				data : stocks,
				pageLength: 10,
				columns: [
					{ data: "rawmaterialStockNo", defaultContent: '' },
					{ data: "rawmaterialId", defaultContent: '' },
					{ data: "rawmaterialName", defaultContent: '' },
					{ data: "ioDatetime", defaultContent: '' },
					{ data: "ioAmt", defaultContent: '' },
					{ data: "whereToUse", defaultContent: '' }
		        ],
		        columnDefs : [
		   			{
			  			targets: [4],
			  			createdCell: function (td, cellData, rowData, row, col) {
			  				
			  		    	if ( rowData.ioAmt < 0 ) {
			  		        	$(td).css('color', 'red')
			  		      	} else {
			  		        	$(td).css('color', 'blue')
			  		      	}
			  		    }
		   			}
			    ]
			}
			
			setTimeout(function() { 
				$('#historyTable').DataTable(
					mergeOptions(heneMainTableOpts, customOpts)
				)
			}, 500);
		});
    	
    	$('#stockHistoryModal').modal('show');
		
		$('#closeBtn').click(function() {
			$('#stockHistoryModal').modal('hide');
		})
	});	// document.ready
</script>