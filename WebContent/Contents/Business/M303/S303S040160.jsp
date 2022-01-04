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
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_part_request_Insert(this)", "원부자재불출요청"}};
	
	String GV_ORDER_NO="", GV_CALLER="", GV_LOTNO="",
			GV_PROD_CD="", GV_PROD_CD_REV="", GV_JOB_ORDER_NO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("job_order_no")== null)
		GV_JOB_ORDER_NO="";
	else
		GV_JOB_ORDER_NO = request.getParameter("job_order_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "job_order_no", GV_JOB_ORDER_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M303S040100E164", jArray);	
    int RowCount =TableModel.getRowCount();	
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS303S040160";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {  
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
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
	    	    	'targets': [1,2,3,5,6],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
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
			<th style='width:0px; display: none;'>제품코드</th>
			<th style='width:0px; display: none;'>제품코드_rev</th>
			<th>제품명</th>
			<th style='width:0px; display: none;'>작업자id</th>
			<th style='width:0px; display: none;'>작업자id_rev</th>
			<th>작업자</th>
			<th>작업자 시급</th>
			<th>투입시간</th>
			<th>총 임금</th>
			<th>비고</th>
			<!-- 버튼자리 -->
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>   

<div id="UserList_pager" class="text-center">
</div>
