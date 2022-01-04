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

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	String Fromdate="",Todate="";

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S020100E104",  jArray);	
 	int RowCount = TableModel.getRowCount();
    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID = "tableS353S020100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink = {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink = HyperLink;
%>

<script type="text/javascript">
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var vColumnDefs = [{
    		'targets': [0,1,2,7,9],
       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); 
       		}
		}];
    	
    	henesysMainTableOptions.data = <%=makeGridData.getDataArry()%>;
		henesysMainTableOptions.columnDefs = vColumnDefs;
    	
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysMainTableOptions);
    	
    	fn_Clear_varv();
    });
    
    function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		vOrderNo	= td.eq(1).text().trim();
		vLotno	= td.eq(2).text().trim();
		vCustNm	= td.eq(5).text().trim();
		vProductNm	= td.eq(8).text().trim();
		vBomCd	= td.eq(10).text().trim();
		vBomCdRev	= td.eq(11).text().trim();
		vBomName	= td.eq(12).text().trim();
		
		vProc_plan_no 		= td.eq(0).text().trim();
		vProd_cd 			= td.eq(1).text().trim();
		vProd_cd_rev 		= td.eq(2).text().trim();
		vProduct_nm 		= td.eq(3).text().trim();
		vMix_recipe_cnt 	= td.eq(4).text().trim();
		
		fn_DetailInfo_List();
    }
    
    function fn_Clear_varv() {
		vProc_plan_no 		= "";
		vProd_cd 			= "";
		vProd_cd_rev 		= "";
		vProduct_nm 		= "";
		vMix_recipe_cnt 	= "";
		vExpiration_date	= "";
		vStart_dt 			= "";
		vEnd_dt				= "";
		vProduction_status 	= "";
		vCode_name 			= "";
	}

</script>
	
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
	<tr>
	     <th style='width:0px; display: none;'>생산계획no</th>
	     <th style='width:0px; display: none;'>제품코드</th>
	     <th style='width:0px; display: none;'>제품코드rev</th>
	     <th>제품명</th>
	     <th>배합수량</th>
	     <th>생산시작예정일시</th>
	     <th>생산완료예정일시</th>
	     <th style='width:0px; display: none;'>production_status</th>
	     <th>생산상태</th>
	     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
	     <th style='width:0px; display: none;'></th> 
	</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center"></div>