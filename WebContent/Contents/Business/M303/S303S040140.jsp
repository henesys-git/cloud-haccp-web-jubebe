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
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 

// 	String[] strColumnHead 	= { "주문번호",
// // 								"order_detail_seq",
// 								"lotno",	
// 								"파트코드","part_cd_rev","원부자재명","bom 수량","창고재고 수량","남은 수량" };
// 	int[] colOff 			= { 1, 0, 1, 0, 1, 1, 1, 1 };	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_part_request_Insert(this)", "원부자재불출요청"}};
	
	String GV_ORDER_NO="", GV_CALLER="",GV_LOTNO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
// 	if(GV_CALLER.equals("S303S040101")) { //입력에서 부를경우 원부자재불출요청 버튼 on
// 		RightButton[2][0] = "on";
// 	}
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M303S040100E144", jArray);	
    int RowCount =TableModel.getRowCount();	
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS303S040140";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {  
    	vTableS303S040140 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    	    scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 1, "asc" ]],
    	    info: false,  
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [
    	    	{
	    	    	'targets': [1,3],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
	    	    },
				{
		   			'targets': [8],
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

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");

// 		OrderDetailData.OrderNo = vOrderNo;
// 		OrderDetailData.Gijong 			= td.eq(1).text().trim();;
// 		OrderDetailData.ProductModel 	= td.eq(2).text().trim();

    }  
    

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>주문번호</th>
			<th style='width:0px; display: none;'>lotno</th>
			<th>원부자재코드</th>
			<th style='width:0px; display: none;'>part_cd_rev</th>
			<th>원부자재명</th>
			<th>bom 수량</th>
			<th>창고재고 수량</th>
			<th>남은 수량</th>
			<!-- 버튼자리 -->
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>   

<div id="UserList_pager" class="text-center">
</div>
