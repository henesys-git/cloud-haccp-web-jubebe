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
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "pop_fn_Balju_form(this)", "발주서"}};

	String GV_BALJU_REQ_DATE="",GV_LOTNO="";

	String GV_ORDERNO="", GV_CUSTCODE="", GV_PROCESS_STATUS="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");


	String param =  GV_ORDERNO + "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);	

	TableModel = new DoyosaeTableModel("M202S010100E114", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
 	
  	makeGridData.htmlTable_ID	= "tableS202S010110";

%>
<script>
$(document).ready(function () {  
	var vColumnDefs;
	vColumnDefs = [{
		'targets': [0,4,5,6,9,10,11,12],
		'createdCell':  function (td) {
  			$(td).attr('style', 'display: none;'); 
		}
	},
	{
		'targets': [14],
		'createdCell':  function (td) {
//   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
		}
	}];

	
	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
		scrollX: true,
	    scrollY: 180,
	    scrollCollapse: true,
	    paging: false,
	    searching: false,
	    ordering: false,
	    order: [[ 0, "desc" ]],
	    info: false,     
	    data: <%=makeGridData.getDataArry()%>,
    	'createdRow': function(row) {
      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
      		$(row).attr('role',"row");
  		},    
  		'columnDefs': vColumnDefs, 
        language: { 
            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
         }
  		
	});  
	
	
});

	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

	
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vBalju_no			= td.eq(1).text().trim();
		vBalju_text			= td.eq(2).text().trim();
		vBalju_send_date 	= td.eq(3).text().trim();
		vBalju_nabgi_date	= td.eq(7).text().trim();
		vNabpoom_location	= td.eq(8).text().trim();
		vQa_ter_condtion	= td.eq(9).text().trim();
		vLotNo				= td.eq(13).text().trim();
	}	
	
    function fn_Clear_varv(){
    	vBalju_no = "";  
    	vBalju_text = "";
    	vBalju_send_date = "";
    	vBalju_nabgi_date = "";
    	vNabpoom_location = "";
    	vQa_ter_condtion = "";
    	vLotNo = "";
	}
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th>발주번호</th>
		     <th>발주서명</th>
		     <th>발주일</th>
		     <th style='width:0px; display: none;'>수신인</th>
		     <th style='width:0px; display: none;'>전화번호</th>
		     <th style='width:0px; display: none;'>팩스번호</th>
		     <th>납기일</th>
		     <th>납품장소</th>
		     <th style='width:0px; display: none;'>품질조건</th>
		     <th style='width:0px; display: none;'>balju_status</th>
		     <th style='width:0px; display: none;'>review_no</th>
		     <th style='width:0px; display: none;'>confirm_no</th>
		     <th>LOTNO</th>
		     <th></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>