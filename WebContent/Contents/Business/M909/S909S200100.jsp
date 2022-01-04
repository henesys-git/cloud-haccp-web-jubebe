<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String memberKey = session.getAttribute("member_key").toString();	
	String fromDate = "", toDate ="";

	if(request.getParameter("From") != null)
		fromDate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		toDate = request.getParameter("To");
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromDate", fromDate);
	jArray.put("toDate", toDate);


    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S200100E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S200100";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,14],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				},
	   			{
		  			'targets': [4,5,6,8,9,10,11,12],
		  			'render': function(data){
		  				return addComma(data);
		  			}
		  		}],
				order : [[ 0, "desc" ]]
				
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').removeAttr('width').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
	});
	    
   	function clickMainMenu(obj) {
   		console.log('clicked main manu');
   		
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vStandard_yearmonth				= td.eq(0).text().trim();
		vStandard_date					= td.eq(1).text().trim();
		vWorker_count 					= td.eq(2).text().trim();
	 	vWorking_day_count 				= td.eq(3).text().trim();
	 	vWorking_cost_hour 				= td.eq(4).text().trim();
	 	vWorking_cost_day 				= td.eq(5).text().trim();
	 	vWorking_cost_month				= td.eq(6).text().trim();
	 	vDuration_time_all				= td.eq(7).text().trim();
	 	vWorking_cost_all 				= td.eq(8).text().trim();
	 	vWorking_cost_all_real 			= td.eq(9).text().trim();
	 	vDirect_cost					= td.eq(10).text().trim();
	 	vIndirect_cost					= td.eq(11).text().trim();
	 	vProd_cost_all					= td.eq(12).text().trim();
	 	vBigo							= td.eq(13).text().trim();
	 	vWorking_rev_no					= td.eq(14).text().trim();
	 	
	 	fn_DetailInfo_List();
	 	
    }
	
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>기준연월</th>
			<th style='width:0px; display: none;'>기준일자</th>
			<th>총노무인원</th>
			<th>월 근무일수</th>
			<th>인당 인건비(시간)</th>
			<th>인당 인건비(일 평균)</th>
			<th>인당 인건비(월 평균)</th>
			<th>소요시간 총계</th>
			<th>노무비 총계</th>
			<th>실 노무비 총계</th>
			<th>간접비</th>
			<th>직접비</th>
			<th>제조경비 총계</th>
			<th>비고</th>
			<th style='width:0px; display: none;'>노무정보 수정이력번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>