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
	
	String year = "", prod_cd ="";
	
	if(request.getParameter("year") != null) {
		year = request.getParameter("year");
	}
	
	if(request.getParameter("prod_cd") == null)
		prod_cd = "";
	else
		prod_cd = request.getParameter("prod_cd");
	
	JSONObject jArray = new JSONObject();
	jArray.put("year", year);
	jArray.put("prod_cd", prod_cd);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S010300E104", jArray);	

	MakeGridData makeGridData= new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS858S010300";
	    
	makeGridData.Check_Box 	= "false";
	String[] HyperLink		= {""};
	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">

var select_data = "";
var select_month = "";

	$(document).ready(function () {
		
		setTimeout(function(){
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;

		var customOpts = {
		data : <%=makeGridData.getDataArray()%>,
		
		columnDefs : [
		   {
      		'targets': [1,2,3,4,5,6,7,8,9,10,11,12,13],
      		'createdCell':  function (td, cellData, rowData, row ,col) {
      			
      		},
  			'render': function(data){
  				return addComma(data);
  			},
  			'className' : "dt-body-right"
		   }
   		  ],
 		  "select":{
   			  style : 'single',
   			  items : 'cell',
   			  selector : 'td:not(:first-child)',
	    	}
   		  
		}
		
		
		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
		mergeOptions(heneMainTableOpts, customOpts)
	   );
	
		table.on('click', 'td', function(){
			var cell = table.cell(this);
			var rowIdx = table.cell(this).index().row;
			var colIdx = table.cell(this).index().column;
			
			select_data = cell.data();
			
			month = colIdx;
			year = '<%=year%>';
			
			 if ($(this).index() == 0 ) { // 구분 칼럼 클릭 이벤트 방지
	             return;
	         }
			 if ($(this).index() == 13 ) { // 합계 칼럼 클릭 이벤트 방지
	             return;
	         }
			
			fn_DetailInfo_List(year, month);
			
			});
		
		
		}, 200);
	});
	
		
		
	 function clickMainMenu(obj){
		
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		gubun					= td.eq(0).text().trim();
		month1 					= td.eq(1).text().trim();
		month2 					= td.eq(2).text().trim();
		month3 					= td.eq(3).text().trim();
		month4 					= td.eq(4).text().trim();
		month5 					= td.eq(5).text().trim();
		month6 					= td.eq(6).text().trim();
		month7 					= td.eq(7).text().trim();
		month8 					= td.eq(8).text().trim();
		month9 					= td.eq(9).text().trim();
		month10 				= td.eq(10).text().trim();
		month11					= td.eq(11).text().trim();
		month12					= td.eq(12).text().trim();
		total					= td.eq(13).text().trim();
		
		//fn_DetailInfo_List();
		
		} 
	
</script>
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>구분</th>
			<th>1월</th>
			<th>2월</th>
			<th>3월</th>
			<th>4월</th>
			<th>5월</th>
			<th>6월</th>
			<th>7월</th>
			<th>8월</th>
			<th>9월</th>
			<th>10월</th>
			<th>11월</th>
			<th>12월</th>
			<th>합계</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
	<!-- <th>연월</th>
			<th style='width:0px; display: none;'>제품코드</th> 
			<th>제품명</th>
			<th>총생산량</th>
			<th>총출고량</th> -->