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
	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	
	String GV_RODER_NO="", GV_LOTNO="" ;

	if(request.getParameter("OrderNo")== null)
		GV_RODER_NO="";
	else
		GV_RODER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_RODER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M858S020100E114",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
        
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS858S020110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 450,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  		'columnDefs': [
   	  			{
					'targets': [0,5,7,8],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [11],
		   			'createdCell':  function (td) {
	//	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
						}
		   		}
			], 
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }

		});
    	
    	VBaechaNo="";
    });
    
    
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
      	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
  		
//   		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });
  		
  		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");
  		
  		VBaechaNo = td.eq(0).text().trim(); 
	     
  }
	
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th style='width:0px; display: none;'>배차번호</th>
		     <th>배차순서</th>
		     <th>배차시작일시</th>
		     <th>배차종료일시</th>
		     <th>차량번호</th>
		     <th style='width:0px; display: none;'>차량번호rev</th>
		     <th>차량명칭</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>lot번호</th>
		     <th>배송기사</th>
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