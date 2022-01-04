<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	JSONObject jArray = new JSONObject();

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020500E104", jArray);

	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S020500";
%>

<script type="text/javascript">
    $(document).ready(function () {
    	var htmlTable_ID = "tableS303S020500";
		
    	var obj = new Object();
    	obj.pid = "M303S020500E104";
    	
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			pageLength : 10,
   			columnDefs : [
   				{
	   				'targets': [1,2,3,5,6,9,12],
	   	   			'createdCell':  function(td) {
	   	      			$(td).attr('style', 'display:none'); 
	   	   			}
	   			},
	   			{
	   				'targets': [11],
	   	   			'createdCell':  function(td) {
	   	      			$(td).html('<span class="badge badge-secondary">확인중</span>');
	   	   			}
	   			},
	   			{
		  			'targets': [7],
		  			'render': function(data){
		  				return addComma(data);
		  			}
		  		}
   			],
   			initComplete : function() {
   				
   				setInterval(function () {
   					var ttlRow = table.data().length;
   					
   					for(var i = 0; i < ttlRow; i++) {
   						var curRow = table.row(i).data();
						
   						var endTime = curRow[10];
   						endTime = new Date(endTime);
   						
   						var curTime = new Date().getTime();
   						if(endTime - curTime < 0) {
   							table.cell(i, 11).data('<span class="badge badge-success">완료</span>').draw();
   						} else {
   							table.cell(i, 11).data('<span class="badge badge-danger">미완료</span>').draw();
   						}
   					}
   				}, 1000*10);
   			}
    	}
    	
    	var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
		
		fn_Clear_varv();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		manufacturing_date= td.eq(0).text().trim();
		request_rev_no= td.eq(1).text().trim();
		prod_plan_date= td.eq(2).text().trim();
		plan_rev_no= td.eq(3).text().trim();
		product_nm= td.eq(4).text().trim();
		prod_cd= td.eq(5).text().trim();
		prod_rev_no= td.eq(6).text().trim();
		prod_count_on_shelf= td.eq(7).text().trim();
		start_time_freeze= td.eq(8).text().trim();
//		proper_freeze_time= td.eq(9).text().trim();
//		finish_time_freeze= td.eq(9).text().trim(); ?
		inout_status= td.eq(10).text().trim();
		note= td.eq(11).text().trim();
		barcode= td.eq(12).text().trim();
    }

	function fn_Clear_varv() {
		manufacturing_date = "";
		request_rev_no = "";
		prod_plan_date = "";
		plan_rev_no = "";
		product_nm = "";
		prod_cd = "";
		prod_rev_no = "";
		prod_count_on_shelf = "";
		start_time_freeze = "";
//		proper_freeze_time = "";
//		finish_time_freeze = "";
		inout_status = "";
		note = "";
		barcode = "";
	}

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			 <th>제조년월일</th>
		     <th style='width:0px; display:none'>생산작업요정서 수정이력번호</th>
		     <th style='width:0px; display:none'>생산계획일자</th>
		     <th style='width:0px; display:none'>생산계획 수정이력번호</th>
			 <th>바코드명</th>
		     <th style='width:0px; display:none'>완제품코드</th>
		     <th style='width:0px; display:none'>완제품 수정이력번호</th>
		     <th>제품수량(EA)</th>
		     <th>시작시간</th>
		     <th style='width:0px; display:none'>냉동시간</th>
		     <th>예상종료시간</th>
		     <th>상태</th>
		     <th style='width:0px; display:none'>불출여부</th>
		     <th>비고</th>
		     <th>바코드</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>      
