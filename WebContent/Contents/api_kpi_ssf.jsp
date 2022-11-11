<!-- 스마트공방 생산성본부(ssf) KPI 연계 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	$(document).ready(function () {
    	
		let mainTable;
		
		async function getData() {
	        var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ssf/ccpvm",
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
						{ data: "ssfKpiCertKey", defaultContent: '' },
						{ data: "ocrDttm", defaultContent: '' },
						{ data: "kpiFldCd", defaultContent: '' },
						{ data: "kpiDtlCd", defaultContent: '' },
						{ data: "kpiDtlNm", defaultContent: '' },
						{ data: "orgValue", defaultContent: '' },
						{ data: "targetValue", defaultContent: '' },
						{ data: "curValue", defaultContent: '' },
						{ data: "achrt", defaultContent: '' },
						{ data: "ssfSentYn", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
				  			targets: [0, 1],
				  			visible: false,
				  			searchable: false
				  		},
				  		{
				  			targets: 9,
				  			render: function(td, cellData, rowData, row, col) {
				  				let d = rowData;
				  				let achrt = 0;
				  				
				  				if(d.kpiFldCd === 'P') {	// 생산량
				  					achrt =  d.curValue / d.targetValue * 100;
				  				}
				  				else if(d.kpiFldCd === 'Q') {	// 불량률
				  					if(d.curValue == 0) {
				  						achrt = 100;
				  					} else {
					  					achrt =  d.targetValue / d.curValue * 100;
				  					}
				  				}
				  				
				  				return achrt.toFixed(2);
				  			}
				  		},
				  		{
				  			targets: 10,
				  			render: function(td, cellData, rowData, row, col){
				  				if(rowData.ssfSentYn === 'Y') {
				  					return '전송 완료';
				  				}
				  				else {
					  				return `<button class='btn btn-success send-btn'>전송</button>`;
				  				}
				  			}
				  		}
				    ]
			}
					
			mainTable = $('#ssfApiTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
		
		async function refreshMainTable() {
			var newData = await getData();

			mainTable.clear().rows.add(newData).draw();
			
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
    	
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(async function() {
    		refreshMainTable();
    		var selectedDate = date.getDate();
	    	var processCode = $("input[name='test-yn']:checked").val();
    	});
    	
    	// 생산성본부 전송
		$('#ssfApiTable').off().on('click', '.send-btn', function(e) {
			e.stopPropagation();
			

			let tr = $(this).parents('tr')[0];
			let row = mainTable.rows(tr).data()[0];
			let sensorKey = row.sensorKey;

			row.achrt = $(tr).find("td:eq(7)").text();
			row.trsDttm = new HeneDate().getDateTime().replace(/[^0-9]/g, '');
			row.ocrDttm = row.ocrDttm.replace(/[^0-9]/g, '').substring(0, 14);
			delete row.sensorKey;
			
			// FOR TEST
			row.kpiCertKey = '019b-eecc-6046-e28a';
			// END
			
			let obj = {};
			obj.KPILEVEL2 = [];
			obj.KPILEVEL2.push(row);
			
    		$.ajax({
                type: "GET",
                url: heneServerPath + '/ssf',
                data: { 
                	"data" : JSON.stringify(obj),
                	"sensorKe" : row.sensorKey  
                },
                success: function (rslt) {
                	console.log(rslt);
                	if(rslt.okMsg) {
                		refreshMainTable();
	                	alert(rslt.okMsg);
                	} else if(rslt.errMsg) {
	                	alert(rslt.errMsg);
                	} else {
                		alert('오류: 관리자에게 문의해주세요');
                	}
                }
            });
    	});
    	
    	$('#send-all-btn').click(async function() {
    		var selectedDate = date.getDate();
	    	
	    	//TODO: 일괄 전송 기능 구현
    	});
	    
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-7">
	        	<h1 class="m-0 text-dark">
	        		생산성본부 KPI 연계 시스템
	        	</h1>
	      	</div>
			<div class="col-md-1">
	   	  		<button type="submit" class="btn btn-success" id="getDataBtn">
	   	  	    	<i class="fas fa-search"></i>
	   	  	     	조회
	   	  	  	</button>
	   	  	</div>
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
          <div class="card-header row">
       		<div class="col-md-6">
	          	<h3 class="card-title">
	          		<i class="fas fa-edit" id="InfoContentTitle"></i>
	          		CCP 데이터 목록
	          	</h3>
	        </div>
	        <div class="col-md-6">
	        	<div class="float-right" id="send-all-btn-wrapper">
		          	<button class='btn btn-success' id="send-all-btn" disabled>
		          		<i class='fas fa-signature'></i>
		          		일괄 전송
		          	</button>
	        	</div>
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ssfApiTable" style="width:100%">
				<thead>
					<tr>
					    <th>센서키</th>
					    <th>인증키</th>
					    <th>발생일시</th>
					    <th>성과지표분야코드</th>
					    <th>세부성과지표코드</th>
					    <th>세부성과지표명</th>
					    <th>기존값</th>
					    <th>목표값</th>
					    <th>측정값</th>
					    <th>성취율(%)</th>
					    <th>전송여부</th>
					</tr>
				</thead>
				<tbody id="ssfApiTableBody">
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