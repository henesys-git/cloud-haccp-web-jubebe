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

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE="";

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
	
	String param =  Fromdate + "|" + Todate + "|" + custCode + "|" + GV_JSPPAGE + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "cust_cd", custCode);
	jArray.put( "jsp_page", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M303S060700E104", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_work_start(this)", "생산시작"},{"off", "fn_work_complete(this)", "공정완료"}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS303S060700";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script>
	$(document).ready(function () {
	 	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>; 
		var vColumnDefs;
			vColumnDefs = [{
	   			'targets': [3,4,8,9,12,13,14,15,16,17,18,19,20,21,22,24,25,26,27],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
			},
			{
	   			'targets': [29],
	   			'createdCell':  function (td) {
	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
	   		},
	   			 {
	   			'targets': [3,4,8,9,12,13,14,15,16,17,18,19,20,21,22,24,25,26,27,28],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
			},
			{
	   			'targets': [30],
	   			'createdCell':  function (td) {
	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
	   		} 
	   		
			];
			
		henesysMainTableOptions.data = <%=makeGridData.getDataArry()%>;
		henesysMainTableOptions.columnDefs = vColumnDefs;
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysMainTableOptions); 
		
    	<%--  $('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: true,
   		    processing: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 13, "desc" ],[ 6, "asc" ]],
    	    info: true,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
		   			'targets': [3,4,8,9,12,13,14,15,16,17,18,19,20,21,22,24,25,26,27,28],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [30],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],    
          	language: { 
              url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
           	}
		});  --%>
    	
    	fn_Clear_varv(); // 행클릭시 지정된 전역변수 초기화
	});

	function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
	     vOrderNo 	= td.eq(13).text().trim();
	     vOrderDetailSeq = td.eq(24).text().trim();
	     
	     vLotNo 	= td.eq(6).text().trim();
	     vLotCount	= td.eq(7).text().trim();
		 vOrderDate = td.eq(5).text().trim();
		 vCustCode 	= td.eq(18).text().trim();
		 vCustRev 	= td.eq(19).text().trim();
		 vCustName  = td.eq(0).text().trim(); 
		 vStatus  	= td.eq(22).text().trim();  
		 vProdCd 	= td.eq(20).text().trim();
		 vProdRev 	= td.eq(21).text().trim();
		 vProdNm	= td.eq(1).text().trim();
		 vDeliveryDate 		 = td.eq(11).text().trim();
		 vProductSerialNo	 = td.eq(16).text().trim();
		 vProductSerialNoEnd = td.eq(17).text().trim();
		 vExpirationDate 	 = td.eq(23).text().trim();
		 
		 
	 	 parent.DetailInfo_List.click();
    }
	
	function fn_Clear_varv(){
		vOrderNo = "";  
		vOrderDetailSeq="";
		vLotNo = "";
		vLotCount = "";
		vOrderDate = "";
		vCustCode = "";
		vCustRev = "";
		vCustName = "";
		vStatus = "";
		vProdCd = "";
		vProdRev = "";
		vProdNm = "";
		vDeliveryDate = "";
		vProductSerialNo = "";
		vProductSerialNoEnd = "";
		vExpirationDate = "";
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
		     <th>포장단위</th>
		     <th>주문수량</th>
		     <th style='width:0px; display: none;'>자재출고일</th>
		     <th style='width:0px; display: none;'>rohs</th>
		     
		     <th>특이사항</th>
		     <th>납기일</th>
		     <th style='width:0px; display: none;'>bom_ver</th>
		     <th style='width:0px; display: none;'>order_no</th>
		     <th style='width:0px; display: none;'>현상태명</th>
		     
		     <th style='width:0px; display: none;'>비고</th>
		     <th style='width:0px; display: none;'>일련번호</th>
		     <th style='width:0px; display: none;'>일련번호끝</th>
		     <th style='width:0px; display: none;'>cust_cd</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th style='width:0px; display: none;'>order_status</th>
		     <th>유통기한</th>
		     <th style='width:0px; display: none;'>order_detail_seq</th>
		     <th style='width:0px; display: none;'>제품구분네임</th>
		     <th style='width:0px; display: none;'>원부자재공급방법</th>
		     
		     <th style='width:0px; display: none;'>rohs</th>
		     <th style='width:0px; display: none;'>공정상태(코드)</th>
		     <th>공정상태</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>
