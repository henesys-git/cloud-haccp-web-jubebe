<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	주문별 생산공정현황
	 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();


	String GV_ORDER_NO = "", GV_LOTNO = "", GV_PROD_CD="", GV_PROD_CD_REV="";
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
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", GV_FROMDATE);
	jArray.put( "todate", GV_TODATE);
	
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "proc_exec_no", "");
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M101S030100E834", jArray);
	int RowCount = TableModel.getRowCount();

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	makeGridData = new MakeGridData(TableModel);

	makeGridData.htmlTable_ID = "TableS101S030830";
	String[] HyperLink = {""};
	makeGridData.HyperLink = HyperLink;
	makeGridData.Check_Box = "false";
	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow}, {"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	makeGridData.RightButton = RightButton;
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
//     		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 2, "asc" ]],
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
<%-- 				<%if(history_yn.equals("Y")){ %> --%>
// 					'targets': [0],
<%-- 				<%} else{%> --%>
// 					'targets': [0,1],
<%-- 				<%}%> --%>
				'targets': [0,1,2,3,4,7,9,17,21,22],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			},
			{
// 	       		'targets': [11],
	       		'targets': [23],
	       		'createdCell':  function (td) {
      				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
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
		$(obj).attr("class", "bg-success");
    }  
</script>


	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
<!-- 			 <th style='width:0px; display: none;'>member_key</th> -->
<%-- 		<%if(history_yn.equals("Y")){ %> --%>
<!-- 		     <th>이력번호</th> -->
<%-- 		<%} else{%> --%>
<!-- 		     <th style='width:0px; display: none;'>이력번호</th> -->
<%-- 		<%}%> --%>
<!-- 		     <th>주문번호</th> -->
<!-- 		     <th>LOT NO</th> -->
<!-- 		     <th>prod_cd</th> -->
<!-- 		     <th style='width:0px; display: none;'>prod_rev</th> -->
<!-- 		     <th>제품명</th>		      -->
<!-- 		     <th>cust_cd</th> -->
<!-- 		     <th>고객사 명</th> -->
<!-- 		     <th style='width:0px; display: none;'>cust_cd_rev</th> -->
<!-- 		     <th>공정시작일시</th> -->
<!-- 		     <th>공정완료일시</th>		      -->
<!-- 		     <th>공정소요시간</th>		      -->
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		     
		    <th style='width:0px; display: none;'>order_no</th>
			<th style='width:0px; display: none;'>lotno</th>
			<th style='width:0px; display: none;'>proc_exec_no</th>
			<th style='width:0px; display: none;'>proc_plan_no</th>
			<th style='width:0px; display: none;'>proc_info_no</th>
			<th>공정순서</th>
			<th>공정코드</th>
			<th style='width:0px; display: none;'>proc_cd_rev</th>
			<th>공정명</th>
			<th style='width:0px; display: none;'>rout_dt</th>
			<th>공정시작일</th>
			<th>공정완료일</th>
			<th>계획 투입공수</th>
			<th>실 투입공수</th>
			<th>실 투입인원</th>
			<th>공정지연여부</th>
			<th>지연시간</th>
			<th style='width:0px; display: none;'>delay_reason_cd</th>
			<th>지연사유</th>
			<th>비고</th>
			<th>작업자</th>
<!-- 		<th>공정완료 제품개수</th> -->
			<th style='width:0px; display: none;'>제품코드</th>
			<th style='width:0px; display: none;'>제품코드rev</th>
			<!-- 	버튼자리	 -->
			<th style='width:0px; display: none;'></th>
		     		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>