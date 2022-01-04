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
	
	int startPageNo = 1;
/* =========================복사하여 수정 할 부분=================================================  */   

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
		
// 	String param =  Fromdate + "|" + Todate + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
// 	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M707S020200E214", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS707S020210";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
 	
 	System.out.println("1212 click 날짜 : " + Fromdate );
%>
<script type="text/javascript">

    $(document).ready(function () {
    	var v<%=makeGridData.htmlTable_ID%> = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: true,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
// 			, 
// 	  		/* =========================복사하여 수정 할 부분===========================================  */  
	  		'columnDefs': [{
	       		'targets': [1,2,3,4],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			  }],
// 			  {
// 	       		'targets': [10],
// 	       		'createdCell':  function (td) {
//           			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
//        			}
// 	       	  }
	  		/* =========================복사하여 수정 할 부분====끝=====================================  */  
			
// 			],    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		$("#checkboxAll").click(function(){ 			//만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#checkboxAll").prop("checked")) { 	//해당화면에 전체 checkbox들을 체크해준다 
				$("input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우 
			} else {  
				$("input[type=checkbox]").prop("checked",false); 
			} 
		})
		
    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>주문번호</th>
		     <th style='width:0px; display: none;'>lotno</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th style='width:0px; display: none;'>package_no</th>
		     <th>날짜</th>
		     <th>포장 무게</th>
		     <th>포장 수량</th>
		     <th>불량</th>
		     <th>검사번호</th>
		     <th>불량율</th>
		    
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
<!-- 		     <th style='width:0px; display: none;'></th>  -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
