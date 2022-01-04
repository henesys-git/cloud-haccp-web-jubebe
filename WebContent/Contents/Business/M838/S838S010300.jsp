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
	
    TableModel = new EdmsDoyosaeTableModel("M838S010300E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS838S010300";
    
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
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 16, "asc" ]],
    	    info: true,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  	
   	  		'columnDefs': [{
   				'targets': [1,2,3,4,7,8,10,11,12,13,15,17,18,19,20],
   	   			'createdCell':  function (td) {
   	      			$(td).attr('style', 'display: none;'); 
   	   			}
   			},
    			{
    	   			'targets': [21],
    	   			'createdCell':  function (td) {
   	   				$(td).attr('style', 'width:10%'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
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
		var trNum = $(obj).closest('tr').prevAll().length;
		
   		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
   		$(obj).attr("class", "hene-bg-color");

   		vHandover_name       = td.eq(0).text().trim();
   		vHandover_rev        = td.eq(1).text().trim();
   		vHandover_date       = td.eq(2).text().trim();
   		vHandover_dept       = td.eq(3).text().trim();
   		vHandover_position   = td.eq(4).text().trim();
   		vAccept_period_start = td.eq(5).text().trim();
   		vAccept_period_end   = td.eq(6).text().trim();
   		vAccept_cause        = td.eq(7).text().trim();
   		vAccept_contents     = td.eq(8).text().trim();
   		vAcceptor            = td.eq(9).text().trim();
   		vAcceptor_rev        = td.eq(10).text().trim();
   		vAccept_date         = td.eq(11).text().trim();
   		vAcceptor_dept       = td.eq(12).text().trim();
   		vAcceptor_position   = td.eq(13).text().trim();
   		vWritor              = td.eq(14).text().trim();
   		vWritor_rev          = td.eq(15).text().trim();
   		vWrite_date          = td.eq(16).text().trim();
   		vApproval            = td.eq(17).text().trim();
   		vApproval_rev        = td.eq(18).text().trim();
   		vApprove_date        = td.eq(19).text().trim();   		
	}
	function fn_Clear_varv(){
   		vHandover_name       = "";
   		vHandover_rev        = "";
   		vHandover_date       = "";
   		vHandover_dept       = "";
   		vHandover_position   = "";
   		vAccept_period_start = "";
   		vAccept_period_end   = "";
   		vAccept_cause        = "";
   		vAccept_contents     = "";
   		vAcceptor            = "";
   		vAcceptor_rev        = "";
   		vAccept_date         = "";
   		vAcceptor_dept       = "";
   		vAcceptor_position   = "";
   		vWritor              = "";
   		vWritor_rev          = "";
   		vWrite_date          = "";
   		vApproval            = "";
   		vApproval_rev        = "";
   		vApprove_date        = "";
	}  
</script>
  	 	
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>인계자</th>
		     <th style='width:0px; display: none;'>인계자rev</th>
		     <th style='width:0px; display: none;'>인계일</th>
		     <th style='width:0px; display: none;'>인계자부서</th>
		     <th style='width:0px; display: none;'>인계자직위</th>
		     <th>인수시작일</th>
		     <th>인수종료일</th>
		     <th style='width:0px; display: none;'>인수사유</th>
		     <th style='width:0px; display: none;'>인수내용</th>
		     <th>인수자</th>
		     <th style='width:0px; display: none;'>인수자rev</th>
		     <th style='width:0px; display: none;'>인수일</th>
		     <th style='width:0px; display: none;'>인수자부서</th>
		     <th style='width:0px; display: none;'>인수자직위</th>
		     <th>작성자</th>
		     <th style='width:0px; display: none;'>작성자rev</th>
		     <th>작성일</th>
		     <th style='width:0px; display: none;'>승인자</th>
		     <th style='width:0px; display: none;'>승인자rev</th>
		     <th style='width:0px; display: none;'>승인일</th>	
		     <th style='width:0px; display: none;'>맴버키</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th></th>		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              