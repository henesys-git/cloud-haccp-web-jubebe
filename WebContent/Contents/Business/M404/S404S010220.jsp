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
	
	String GV_ORDER_NO="",GV_IMPORT_INSPECT_REQ_NO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	
	String param = GV_ORDER_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "member_key", member_key);
	
// 	수입검사신청서 조회
    TableModel = new DoyosaeTableModel("M404S010100E124", jArray);	

 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S010220";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
 	
    
    //int ColCount =TableModel.getColumnCount()+1;
//     out.println(makeTableHTML.getHTML());
%>
<script>
   
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,9,10,11,12],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    
		
    	fn_Clear_varv();
    });
    	
   	function <%=makeGridData.htmlTable_ID%>Event(obj){
         	var tr = $(obj);
     		var td = tr.children();
     		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
     		     		
     		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
     		$(obj).attr("class", "hene-bg-color");
     		
     	    
      } 	
    
	function S404S010220Event(obj){
		var tr = $(obj);
		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

	}

    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th style='width:0px; display: none;'>발주번호</th>
		     <th>순번</th>
		     <th>자료번호</th>
		     
		     <th>자료이름</th>
		     <th>원부자재번호</th>
		     <th>파트코드</th>
		     <th>요청수</th>
		     <th style='width:0px; display: none;'>오류수</th>
		     <th style='width:0px; display: none;'>합격여부</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     
		     <th style='width:0px; display: none;'>검사여부</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		     
		<% } else { %>
			 <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th style='width:0px; display: none;'>발주번호</th>
		     <th>순번</th>
		     <th>자료번호</th>
		     
		     <th>자료이름</th>
		     <th>원부자재번호</th>
		     <th>파트코드</th>
		     <th>요청수</th>
		     <th style='width:0px; display: none;'>오류수</th>
		     <th style='width:0px; display: none;'>합격여부</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     
		     <th style='width:0px; display: none;'>검사여부</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		<% } %>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              