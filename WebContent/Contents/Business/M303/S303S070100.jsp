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
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE="";

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	//String param =  Fromdate + "|" + Todate + "|" + custCode + "|" + GV_JSPPAGE + "|" + member_key + "|";
	JSONObject jArray = new JSONObject();
 	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M303S070100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS303S070100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs =  [{
	    	'targets': [3,4,8,9,12,13,15,16,17,18,19,20,21,22,23],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
	    },
	    {
   			'targets': [25],
				'createdCell':  function (td) {
				//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
			}
			}
	    ];
		
		henesysMainTableOptions.data = <%=makeGridData.getDataArry()%>;
		henesysMainTableOptions.columnDefs = vColumnDefs;
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysMainTableOptions);
    	
    	<%-- 
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    	    scrollY: 180,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 13, "desc" ],[ 6, "asc" ]],
    	    keys: true,
    	    info: true,   
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [3,4,8,9,12,13,15,16,17,18,19,20,21,22,23],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
    	    {
	   			'targets': [25],
   				'createdCell':  function (td) {
					//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	}); 
    	--%>
    	
    	fn_Clear_varv();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
        vOrderNo 	= td.eq(13).text().trim(); 
		vLotNo 		= td.eq(6).text().trim();
		
		DetailInfo_List.click();
    }
    
    function fn_Clear_varv(){
		vOrderNo 	= "";
		vLotNo 		= "";
    }

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>고객사</th>
			<th>제품명</th>
			<th>PO번호</th>
			<th style='width:0px; display: none;'>제품구분</th>
			<th style='width:0px; display: none;'>원부자재공급방법</th>
			<th>주문일</th>
			<th>lot번호</th>
			<th>lot수량</th>
			<th style='width:0px; display: none;'>자재출고일</th>
			<th style='width:0px; display: none;'>rohs</th>
			<th>특이사항</th>
			<th>납기일</th>
			<th style='width:0px; display: none;'>bom_ver</th>
			<th style='width:0px; display: none;'>order_no</th>
			<th>현상태명</th>
			<th style='width:0px; display: none;'>비고</th>
			<th style='width:0px; display: none;'>일련번호</th>
			<th style='width:0px; display: none;'>일련번호끝</th>
			<th style='width:0px; display: none;'>cust_cd</th>
			<th style='width:0px; display: none;'>cust_rev</th>
			<th style='width:0px; display: none;'>prod_cd</th>
			<th style='width:0px; display: none;'>prod_cd_rev</th>
			<th style='width:0px; display: none;'>order_status</th>
			<th style='width:0px; display: none;'>공정상태(코드)</th>
			<th>공정상태</th>
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		