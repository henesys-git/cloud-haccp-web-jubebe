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
	

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_work_start(this)", "생산시작"}};

	String GV_PROC_PLAN_NO="", GV_PROD_CD="", GV_PROD_CD_REV="" ;

	if(request.getParameter("proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	//String param =  GV_ORDERNO + "|" + GV_LOTNO + "|"  + "|"  + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
		
	TableModel = new DoyosaeTableModel("M303S050100E145", jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
  	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
 	
  	makeGridData.htmlTable_ID	= "tableSM303S050145";
  
 	//makeGridData.Check_Box 	= "false";
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
    	    order: [[ 2, "asc" ]],
    	    info: false,         
    	    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
		   			'targets': [1,2,3],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [9],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],    
          	language: { 
              url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
           	}
		});
    	
    	vProc_exec_no = "";
	});

	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-success");

	     vProc_exec_no	= td.eq(0).text().trim();
	}
	
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th>부적합 발생일자</th>
			<th style='width:0px; display: none;'>proc_plan_no</th>
			<th style='width:0px; display: none;'>incog_prod_no</th>
			<th style='width:0px; display: none;'>incog_prod_rev</th>
			<th>제품명</th>
			<th>부적합사항</th>
			<th>부적합품 총중량(g)</th>
			<th>제조일자</th>
			<th>처리방법</th>
			<!-- 	버튼자리	 -->
			<th style='width:0px; display: none;'></th>
<!-- 			<th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
<div id="UserList_pager" class="text-center">
</div>
