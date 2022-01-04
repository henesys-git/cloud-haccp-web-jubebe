<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	주문별 출하현황
	 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	
	String GV_ORDER_NO = "", GV_LOTNO = "";
	String  GV_FROMDATE="", GV_TODATE="";
	
	if(request.getParameter("Fromdate")== null)
		GV_FROMDATE="";
	else
		GV_FROMDATE = request.getParameter("Fromdate");
		
	if(request.getParameter("Todate")== null)
		GV_TODATE="";
	else
		GV_TODATE = request.getParameter("Todate");	

	if (request.getParameter("OrderNo") == null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", GV_FROMDATE);
	jArray.put( "todate", GV_TODATE);
	
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M101S030100E864", jArray);
	int RowCount = TableModel.getRowCount();

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	makeGridData = new MakeGridData(TableModel);

	makeGridData.htmlTable_ID = "TableS101S030860";
	String[] HyperLink = {""};
	makeGridData.HyperLink = HyperLink;
	makeGridData.Check_Box = "false";
	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow}, {"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "", "상세"}};
	makeGridData.RightButton = RightButton;
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	var trCol=-1;
	$(document).ready(function () {
		vTableS101S030860=$('#<%=makeGridData.htmlTable_ID%>').DataTable({
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
	       			'targets': [1,8,9,10,12,16,18,19,20,21,22,23],
				<%} else{%>
	       			'targets': [0,1,8,9,10,12,16,18,19,20,21,22,23],
				<%}%>
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		},
   				'click':function(td){
   					trCol= $(this).index();
   				},
			},
			{
	       		'targets': [24],
	       		'createdCell':  function (td) {
	       			$(td).attr('onclick',"pop_fn_Trading_List_nd(this)");
//       				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
   				},
   				'click':function(td){
   					trCol= $(this).index();
   				},
			}
	  		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
<%-- 		$('#<%=makeGridData.htmlTable_ID%>_body').on( 'click', 'td', function () { --%>
// // 			vTableS101S030860.cell( this ).index().columnVisible;
// 			trCol = $(this).index(this);
// // 			trCol=vTableS101S030860.cell( this ).index().row;
// 		});
	});

    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		console.log("makeGridData ==" + $(obj).children().closest("td").prevAll().length);
// 		console.log("makeGridData ==" + $(obj).children().closest("td").index());

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
//상세내역을 2차 팝업을 위한 데이터		
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030865.jsp"
    	+ "?hist_no="	+ td.eq(1).text().trim() 
    	+ "&custname=" 	+ td.eq(2).text().trim()
		+ "&prodnm=" 	+ td.eq(3).text().trim()
		+ "&orderno=" 	+ td.eq(4).text().trim()
		+ "&lotno=" 	+ td.eq(5).text().trim()
		+ "&lotcount=" 	+ td.eq(12).text().trim()
		+ "&productserialno=" 		+ td.eq(8).text().trim()
		+ "&productserialnoend=" 	+ td.eq(9).text().trim()
		+ "&orderdate=" 	+ td.eq(11).text().trim()
		+ "&deliverydate=" 	+ td.eq(16).text().trim()
		+ "&chulha_date=" 	+ td.eq(17).text().trim()
		+ "&chulha_no=" 	+ td.eq(6).text().trim()
		+ "&chulha_seq=" 	+ td.eq(7).text().trim()
		+ "&chulha_count=" 	+ td.eq(13).text().trim()
		+ "&chulha_unit=" 	+ td.eq(14).text().trim()
		+ "&chulha_price=" 	+ td.eq(15).text().trim()
		+ "&tugesahang=" 	+ td.eq(19).text().trim();
    	if(-1<trCol && trCol<24)
    		pop_fn_popUpScr_nd(modalContentUrl, "주문제품 출하현황 상세", '650px', '1060px');
  	    return;
    }  
    
	function pop_fn_Trading_List_nd(obj){

		vpopUpLevel = "2nd";
		
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040120_canvas.jsp"
    				+ "?OrderNo=" 	+ $(obj).parent().parent().find("td").eq(4).text().trim() 
    				+ "&ChulhaNo=" 	+ $(obj).parent().parent().find("td").eq(6).text().trim() 
    				+ "&LotNo=" 	+ $(obj).parent().parent().find("td").eq(5).text().trim()
    				+ "&prod_cd=" 	+ $(obj).parent().parent().find("td").eq(22).text().trim() 
    				+ "&prod_rev=" 	+ $(obj).parent().parent().find("td").eq(23).text().trim() 
    				+ "&popUpLevel=" + vpopUpLevel;
    	pop_fn_popUpScr_nd_2(url, "거래명세서 "+obj.innerText +"(S101S040120)", '800px', '1200px');
  	    return;
	}    
</script>


	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th style='width:0px; display: none;'>member_key</th>
			<%if(history_yn.equals("Y")){ %>
			     <th>이력번호</th>
			<%} else{%>
			     <th style='width:0px; display: none;'>이력번호</th>
			<%}%>
		     <th>고객사명</th>
		     <th>제품명</th>
		     <th>주문번호</th>
		     <th>LOT NO</th>
		     <th>출하번호</th>
		     <th>출하일련번호</th>		     
		     <th style='width:0px; display: none;'>제품일련번호(시)</th>	     
		     <th style='width:0px; display: none;'>제품일련번호(끝)</th>
		     <th style='width:0px; display: none;'>고객사PO번호</th>
		     <th>주문일자</th>
		     <th style='width:0px; display: none;'>LOT수량</th>
		     <th>출하수량</th>
		     <th>출하단위</th>		     
		     <th>출하단가</th>
		     <th style='width:0px; display: none;'>납품예정일자</th>
		     <th>출하일자</th>
		     <th style='width:0px; display: none;'>비고</th>
		     <th style='width:0px; display: none;'>특이사항</th>
		     <th style='width:0px; display: none;'>cust_cd</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_rev</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th></th>	
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>