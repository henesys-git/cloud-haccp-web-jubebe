<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	주문별 원부자재입출고현황
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
	
	TableModel = new DoyosaeTableModel("M101S030100E814", jArray);
	int RowCount = TableModel.getRowCount();

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	makeGridData = new MakeGridData(TableModel);

	makeGridData.htmlTable_ID = "TableS101S030810";
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
					'targets': [0,8],
				<%} else{%>
					'targets': [0,1,8],
				<%}%>
	       		
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			},
			{
	       		'targets': [12],
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
			 <th style='width:0px; display: none;'>member_key</th>
		<%if(history_yn.equals("Y")){ %>
		     <th>이력번호</th>
		<%} else{%>
		     <th style='width:0px; display: none;'>이력번호</th>
		<%}%>
		     <th>주문번호</th>
		     <th>LOT NO</th>
		     <th>입출고일자</th>
		     <th>입출고일련번호</th>		     
		     <th>원부자재코드</th>
		     <th>원부자재 명</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th>입고수량</th>
		     <th>출고수량</th>		     
		     <th>구분</th>		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>