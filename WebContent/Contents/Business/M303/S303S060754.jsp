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

	String GV_ORDERNO="", GV_LOTNO="";

	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M303S060700E554", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_work_start(this)", "생산시작"},{"off", "fn_work_complete(this)", "공정완료"}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "TableS303S060754";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script>
	$(document).ready(function () {
		var vColumnDefs;
		vColumnDefs = [{
			'targets': [0],
			'createdCell':  function (td) {
	  			$(td).attr('style', 'display: none;'); 
			}
		},
		{
			'targets': [1],
			'createdCell':  function (td) {
	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
			}
		}];
		
		vTableS303S060754 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: false,
    		scrollY: 0,
    	    scrollCollapse: false,
    	    paging: false,
   		    processing: false,
    	    searching: false,
    	    ordering: false,
    	    order: [[ 0, "desc" ],[ 0, "asc" ]],
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
    	
    	fn_Clear_varv(); // 행클릭시 지정된 전역변수 초기화
	});

	function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vDefect_cnt 	= td.eq(0).text().trim();

    }
	
	function fn_Clear_varv(){
		vDefect_cnt = "";  

	}

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 0%">
		<thead>
		<tr>

		     <th style='width:0px; display: none;'>불량수량</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>

		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>
