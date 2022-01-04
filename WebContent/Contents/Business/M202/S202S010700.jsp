<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
//	MakeTableHTML makeTableHTML;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M202S010100E704", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    makeGridData= new MakeGridData(TableModel);
 	
	String RightButton[][]	= {{"off", "fn_work_start(this)", "생산시작"},{"off", "fn_work_complete(this)", "공정완료"}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS202S010700";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
%>
<script>
    $(document).ready(function () {
    	<%-- $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({ --%>
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 800,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 11, 'desc' ],[ 2, "asc" ]],
    	    info: true,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  		'columnDefs': [
				{
					// 제외할 컬럼 숫자 적기(0부터)
					'targets': [2,3,9,12],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
					'targets': [0,1,4,5,6,7,8,10,11],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'border:1px solid #cccccc;'); 
		   			}
				},
				{
		   			'targets': [13],
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
   		
    }
    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%; border: 1px solid #cccccc;">
		<thead>
		<tr>
			 <th style="border: 1px solid #cccccc;">대분류</th>
		     <th style="border: 1px solid #cccccc">중분류</th>
		     <th style='width:0px; display: none;'>part_cd</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th style="border: 1px solid #cccccc;">원재료명</th>
		     
		     <th style="border: 1px solid #cccccc;">규격</th>
		     <th style="border: 1px solid #cccccc;">현재재고</th>
		     <th style="border: 1px solid #cccccc;">생산 소요량</th>
		     <th style="border: 1px solid #cccccc;">포장 소요량</th>
		     <th style='width:0px; display: none;'>안전재고</th>
		     
		     <th style="border: 1px solid #cccccc;">생산,포장 후 예상재고</th>
		     <th style="border: 1px solid #cccccc;">필요량</th>
		     <th style='width:0px; display: none;'>필요량2(안전재고포함)</th>

		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>              