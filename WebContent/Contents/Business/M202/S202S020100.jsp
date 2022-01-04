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

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", "입고문서"}};;

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;

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
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M202S020100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton = RightButton;
    makeGridData.htmlTable_ID = "tableS202S020100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script>
	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;

    $(document).ready(function () {
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [{
    	       		'targets': [3,4,8,9,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}],
    	    	order : [[13, "desc"]]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    	
    	
    	fn_Clear_varv();
    });
    
    function fn_Clear_varv(){
		vOrderNo = "";
		vOrderDetailSeq = "";
	}
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;	//현재 클릭한 TR의 순서 return .bg-success

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });
	
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vOrderNo = td.eq(13).text().trim(); 
		vBalju_no = td.eq(18).text().trim(); 
	 	vOrderDetailSeq = ""; //td.eq(13).text().trim();
	 	vLotNo = td.eq(3).text().trim();
		
	 	DetailInfo_List.click();
	}
   
    function fn_doc_registeration(){
         var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/FileUpload/com_Fileupload.jsp";
         modalFramePopup.setTitle("파일 업로드");
         modalFramePopup.show(modalContentUrl, "700px", "1400px");
         return false;
    }    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
	<tr>
		<th>고객사</th>
		<th>제품명</th>
		<th>PO번호</th>
		<th style='width:0px; display: none;'>product_gubun</th>
		<th style='width:0px; display: none;'>part_source</th>
		<th>주문일</th>
		<th>lot번호</th>
		<th>lot수량</th>
		<th style='width:0px; display: none;'>자재출고일</th>
		<th style='width:0px; display: none;'>rohs</th>
		<th>특이사항</th>
		<th>납기일</th>
		<th style='width:0px; display: none;'>bom_ver</th>
		<th style='width:0px; display: none;'>order_no</th>
		<th style='width:0px; display: none;'>현상태명</th>
		<th style='width:0px; display: none;'>bigo</th>
		<th style='width:0px; display: none;'>product_serial_no</th>
		<th style='width:0px; display: none;'>product_serial_no_end</th>
		<th style='width:0px; display: none;'>cust_cd</th>
		<th style='width:0px; display: none;'>cust_rev</th>
		<th style='width:0px; display: none;'>prod_cd</th>
		<th style='width:0px; display: none;'>prod_rev</th>
		<th style='width:0px; display: none;'>order_status</th>
		<th style='width:0px; display: none;'>제품구분네임</th>
		<th style='width:0px; display: none;'>원부자재공급방법</th>	
		<th style='width:0px; display: none;'>rohs</th>		
		<th>발주번호</th>
		<th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>              