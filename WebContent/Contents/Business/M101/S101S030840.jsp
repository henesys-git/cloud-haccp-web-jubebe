<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	출하검사현황
	 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();

	String GV_ORDER_NO = "", GV_LOTNO = "";

	if (request.getParameter("OrderNo") == null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	jArray.put( "inspect_gubun", prcStatusCheck.GV_PROCESS_NUMBER_GUBUN);//SHIPMENT
	TableModel = new DoyosaeTableModel("M101S030100E844", jArray);
	int RowCount = TableModel.getRowCount();

	makeGridData = new MakeGridData(TableModel);

	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow}, {"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	makeGridData.RightButton = RightButton;
	makeGridData.htmlTable_ID = "TableS101S030840";

	makeGridData.Check_Box = "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	makeGridData.HyperLink = HyperLink;
%>

<script type="text/javascript">
	$(document).ready(function () {
		console.log(<%=makeGridData.getDataArry()%>);
		$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
//     		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,
			
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
				<%if(history_yn.equals("Y")){ %>
					'targets': [3,4,7,10,11],
				<%} else{%>
					'targets': [0,3,4,7,10,11],
				<%}%>
	       		
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
		       		}
				}
		  		,
				{
		       		'targets': [12],
		       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
		       		}
				}
	  		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

	});

   	function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
   		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
   		$(obj).attr("class", "hene-bg-color");

   	//상세내역을 2차 팝업을 위한 데이터		
<%--     	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030845.jsp" --%>
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070210.jsp"
    	+ "?hist_no="				+ td.eq(0).text().trim() 
		+ "&OrderNo=" 				+ td.eq(1).text().trim()
		+ "&lotno=" 				+ td.eq(2).text().trim()
		+ "&product_serial_no=" 	+ td.eq(3).text().trim()
		+ "&product_serial_no_end="	+ td.eq(4).text().trim()
//     	+ "&inspect_no=" 			+ td.eq(5).text().trim()
// 		+ "&prodnm=" 				+ td.eq(6).text().trim()
// 		+ "&prod_cd_rev=" 			+ td.eq(7).text().trim()
// 		+ "&inspect_result_date=" 	+ td.eq(9).text().trim()
		+ "&InspectGubun=" 			+ td.eq(10).text().trim()
// 		+ "&prod_cd=" 				+ td.eq(11).text().trim()
    	pop_fn_popUpScr_nd(modalContentUrl, "주문제품 출하검사 상세", '650px', '1060px');


	}
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<%if(history_yn.equals("Y")){ %>
			     <th>이력번호</th>
			<%} else{%>
			     <th style='width:0px; display: none;'>이력번호</th>
			<%}%>
			 <th>주문번호</th>
		     <th>LOT NO</th>
		     <th style='width:0px; display: none;'>시리얼번호 시작</th>
		     <th style='width:0px; display: none;'>시리얼번호 끝</th>
		     <th>검사번호</th>
		     <th>제품명</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th>검사구분</th>
		     <th>검사일</th>
		     <th style='width:0px; display: none;'>inspect_gubun</th>
		     <th style='width:0px; display: none;'>prod_cd</th>		     		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>