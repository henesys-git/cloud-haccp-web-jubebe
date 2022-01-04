<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", "입고문서"}
							  };

	String Fromdate = "", Todate = "", custCode = "", GV_JSPPAGE = "";

	if(request.getParameter("From") != null)
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode") != null)
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage") != null)
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("custcode", custCode);
	jArray.put("jsppage", GV_JSPPAGE);
	jArray.put("member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M202S030100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	 
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S030100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>발주번호</th>
			<th>발주일자</th>
			<th>발주납기일자</th>
			<th>품목명</th>
			<th>발주량</th>
			<th>발주상태</th>
			<th style="display:none">원부재료 코드</th>
			<th style="display:none">원부재료 수정이력번호</th>
			<th style="display:none">발주 수정이력번호</th>
			<th style="display:none">이력추적번호</th>
			<th style="display:none">입고검사완료여부</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>

<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		    	
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [6,7,8,9,10],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
		    },
   			{
	  			'targets': [4],
	  			'render': function(data){
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
	  		}],
			pageLength : 10,
			order : [[1,"desc"]]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    });
    
	function clickMainMenu(obj) {
		console.log('clicked');
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;
		console.log(td);
		vBaljuNo	 = td.eq(0).text().trim();
		vBaljuStatus = td.eq(5).text().trim();
		vPartCd 	 = td.eq(6).text();
		vPartRevNo 	 = td.eq(7).text();
		vBaljuRevNo  = td.eq(8).text().trim();
		vTraceKey	 = td.eq(9).text().trim();
		vPartNm		 = td.eq(3).text().trim();
		vBaljuAmt	 = td.eq(4).text().trim();
		vDocRegistYn = td.eq(10).text().trim();
		
		if(vDocRegistYn == "Y" || vBaljuStatus == "대기"){
	    	$("#haccp_insert").attr("disabled", true);
	    } else if(vDocRegistYn == "N") {
	    	$("#haccp_insert").attr("disabled", false);
	    }
	}
</script>