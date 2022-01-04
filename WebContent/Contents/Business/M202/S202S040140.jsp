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

	String[] strColumnHead 	= { "주문번호","Lot번호","원부자재코드","원부자재코드rev","원부자재명",
								"조정수량","창고","렉","선반","칸",
								"창고 현위치","입출고전재고","입출고수","재고","안전재고",
								"대분류","part_gubun_b","중분류","part_gubun_m","유통기한",
								"이력번호"};
	int[]   colOff 			= { 0, 0, 1, 0, 1,
								1, 0, 0, 0, 0,
								1, 1, 0, 1, 0,
								0, 0, 0, 0, 0,
								0};
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="", GV_LOTNO="", GV_BALJUNO="";

	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("baljuNo")== null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("baljuNo");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "baljuNo", GV_BALJUNO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M202S040100E144", jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S040140";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {
		
		vTableS202S040120 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: false,
		    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
				'targets': [0,1,2,3,5,7,8,9,10,12,14,15,16,17,18,20],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
			{
				'targets': [21],
   				'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			}],
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
		
		$('#txt_hist_no').val(td.eq(20).text().trim());
		$('#txt_expiration_date').val(td.eq(19).text().trim());
		$('#txt_store_no').val(td.eq(6).text().trim());
		$('#txt_reakes_no').val(td.eq(7).text().trim());
		$('#txt_plate_no').val(td.eq(8).text().trim());
		$('#txt_colm_no').val(td.eq(9).text().trim());
		
		$('#txt_pre_amt').val(td.eq(11).text().trim());
		$('#txt_post_stack').val(td.eq(13).text().trim());
		
		$('#txt_part_cd').val(td.eq(2).text().trim());
		$('#txt_part_cd_rev').val(td.eq(3).text().trim());
		$('#txt_part_name').val(td.eq(4).text().trim());
		$('#txt_io_count').val(td.eq(5).text().trim());
		
		if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
		if($("#txt_post_stack").val()==""){$("#txt_post_stack").val(0);}   

    }        
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
		     	<th style='width:0px; display: none;'>주문번호</th>
				<th style='width:0px; display: none;'>Lot번호</th>
				<th style='width:0px; display: none;'>원부자재코드</th>
				<th style='width:0px; display: none;'>원부자재코드rev</th>
				<th>원부자재명</th>
				<th style='width:0px; display: none;'>출고수량</th>
				<th>창고</th>
				<th style='width:0px; display: none;'>렉</th>
				<th style='width:0px; display: none;'>선반</th>
				<th style='width:0px; display: none;'>칸</th>
				<th style='width:0px; display: none;'>창고 현위치</th>
				<th>입출고전재고</th>
				<th style='width:0px; display: none;'>입출고수</th>
				<th>재고</th>
				<th style='width:0px; display: none;'>안전재고</th>
				<th style='width:0px; display: none;'>대분류</th>
				<th style='width:0px; display: none;'>part_gubun_b</th>
				<th style='width:0px; display: none;'>중분류</th>
				<th style='width:0px; display: none;'>part_gubun_m</th>
				<th>유통기한</th>
				<th style='width:0px; display: none;'>이력번호</th>
			     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
			     <th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>