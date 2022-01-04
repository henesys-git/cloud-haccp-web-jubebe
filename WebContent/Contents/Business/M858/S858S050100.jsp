<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	String Fromdate="",Todate="";
	
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");		
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M858S010100E304",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS858S050100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">

    $(document).ready(function () {
//     	var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/;	// 특수문자
//     	var pattern= /'"\\r\f\b\t\n/gi;	// 특수문자
//     	for(var i=0; i<qUeryData.length; i++){
//     		for(var j=0; j<qUeryData[i]; j++){
//     			if(qUeryData[i][j].indexof(pattern) != -1){
//     				qUeryData[i][j].replaceall(pattern, "\"+pattern);
//     			}
//     		}
//     	}
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 400,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 14, "desc" ]],
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,

		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [3,4,5,6,7,8,9,10,16,17,18,19,20,21],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [22],
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
		$(obj).attr("class", "hene-bg-color");
		
		
// 		fn_DetailInfo_List();
    }

</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>대분류</th>
		     <th>중분류</th>
		     <th>제품명</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>Lot번호</th>
		     <th style='width:0px; display: none;'>출하번호</th>
		     <th style='width:0px; display: none;'>chulha_seq</th>
		     
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>product_serial_no</th>
		     <th style='width:0px; display: none;'>product_serial_no_end</th>		     
		     <th>출하수량</th>
		     <th>출하단위</th>
		     <th>출하단가</th>
		     <th>출하일시</th>
		     <th>출하담당자</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th style='width:0px; display: none;'>제품코드개정번호</th>
		     <th style='width:0px; display: none;'>검토번호</th>		     
		     <th style='width:0px; display: none;'>승인번호</th>
		     <th style='width:0px; display: none;'>order_detail_seq</th>
		     <th style='width:0px; display: none;'>A.member_key</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>


<div id="UserList_pager" class="text-center">
</div>                 
