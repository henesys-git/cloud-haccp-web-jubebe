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
	
	String GV_FROMDATE="",GV_TODATE="" ;

	if(request.getParameter("From")== null)
		GV_FROMDATE = "";
	else
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		GV_TODATE="";
	else
		GV_TODATE = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "fromdate", GV_FROMDATE);
	jArray.put( "todate", GV_TODATE);
	
    TableModel = new DoyosaeTableModel("M838S050200E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S050200";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 450,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    keys: true,
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
		   			'targets': [6,7,10,11,14,15],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [17],
		   			'createdCell':  function (td) {
// 		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }

   	    });
        
    	fn_Clear_varv();
    });
    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
				
		vHealthExmYear 		= td.eq(0).text().trim();
		vQuat1 				= td.eq(1).text().trim();
		vQuat2 				= td.eq(2).text().trim();
		vQuat3 				= td.eq(3).text().trim();
		vQuat4 				= td.eq(4).text().trim();
		vCheckDate 			= td.eq(5).text().trim();
		vCheckId 			= td.eq(6).text().trim();
		vCheckNameRev 		= td.eq(7).text().trim();
		vCheckName 			= td.eq(8).text().trim();
		vApprovalDate 		= td.eq(9).text().trim();
		vApprovalId 		= td.eq(10).text().trim();
		vApprovalNameRev 	= td.eq(11).text().trim();
		vApprovalName 		= td.eq(12).text().trim();
		vWriteDate 			= td.eq(13).text().trim();
		vWritorId 			= td.eq(14).text().trim();
		vWritorNameRev 		= td.eq(15).text().trim();
		vWritorName 		= td.eq(16).text().trim();
    	
    }
	function fn_Clear_varv(){
		vHealthExmYear = "";
		vQuat1 = "";
		vQuat2 = ""; 
		vQuat3 = ""; 
		vQuat4 = ""; 
		vWritorId = "";
	}

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>검진년도</th>
		     <th>1/4분기</th>
		     <th>2/4분기</th>
		     <th>3/4분기</th>
		     <th>4/4분기</th>  
		     <th>점검일</th>
		     <th style='width:0px; display: none;'>점검자 아이디</th>
		     <th style='width:0px; display: none;'>점검자 아이디rev</th>
		     <th>점검자</th>
		     <th>승인일</th>
		     <th style='width:0px; display: none;'>승인자 아이디</th>
		     <th style='width:0px; display: none;'>승인자 아이디rev</th>
		     <th>승인자</th>	
		     <th>작성일</th>	     
		     <th style='width:0px; display: none;'>작성자 아이디</th>
		     <th style='width:0px; display: none;'>작성자 아이디rev</th>
		     <th>작성자</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th>  -->
		     <th></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>   
    