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
								{"on", "pop_fn_Balju_form(this)", "발주서"}
							  };

	String Fromdate="",Todate="",
		   custCode="", GV_PROCESS_STATUS="", 
		   GV_JSPPAGE;

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");

	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	////////////////////////////////////////////////////
	
	String param =  Fromdate + "|" + Todate + "|" ;
	
	JSONObject jArray = new JSONObject();

 	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("member_key", member_key);	
    TableModel = new DoyosaeTableModel("M202S050100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S010300";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script>
	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
    $(document).ready(function () {
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArry()%>,
   			columnDefs : [
   		    	{
   	    	    	'targets': [0,1,2,4,6,7,9,12],
   		   			'createdCell':  function (td) {
   		      			$(td).attr('style', 'display: none;'); 
   		   			}
   	    	    },
   	   			// 조회컬럼크기
  	    	    	{ width: '8%', targets: 0 },
  	                { width: '8%', targets: 1 },
  	                { width: '30%', targets: 2 },
  	                { width: '10%', targets: 3 },
  	                { width: '0%', targets: 4 },
  	                { width: '10%', targets: 5 },
  	                { width: '0%', targets: 6 },
  	                { width: '0%', targets: 7 },
  	                { width: '7%', targets: 8 },
  	                { width: '0%', targets: 9 },
  	                { width: '10%', targets: 10 },
  	                { width: '10%', targets: 11 },
  	                { width: '0%', targets: 12 },
  	                { width: '7%', targets: 13 }
			]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    });
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
	
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vOrderNo = td.eq(0).text().trim();
		vBalju_no = td.eq(1).text().trim();
		
		parent.DetailInfo_List.click();
	}
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>발주번호</th>
			<th style='width:0px; display: none;'>제목</th>
			<th>발주일</th>
			<th style='width:0px; display: none;'>cust_cd</th>
			<th>수신처</th>
			<th style='width:0px; display: none;'>cust_cd_rev</th>
			<th style='width:0px; display: none;'>cust_damdang</th>
			<th>전화번호</th>
			<th style='width:0px; display: none;'>fax_no</th>
			<th>원부자재납기일</th>
			<th>납품장소</th>
			<th style='width:0px; display: none;'>qa_ter_condtion</th>
			<th></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>