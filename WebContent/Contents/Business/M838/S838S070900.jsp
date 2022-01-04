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
	
/* =========================복사하여 수정 할 부분=================================================  */   

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
	
    TableModel = new DoyosaeTableModel("M838S070900E104", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS838S070900";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
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
    	    order: [[ 0, "desc" ]], // 부적합 발생일자 역순
    	    info: true,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		}, 
	  		/* =========================복사하여 수정 할 부분===========================================  */   
	  		'columnDefs': [{
	       		'targets': [1,2,10,11,13,14,15,16,17],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [21],
	       		'createdCell':  function (td) {
//           			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}
	  		/* =========================복사하여 수정 할 부분====끝=====================================  */  
			
			],    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    	vCheckDateTime = "";
    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vCheckDateTime = td.eq(0).text().trim();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>점검일시</th>
		     <th style='width:0px; display: none;'>품목코드</th>
		     <th style='width:0px; display: none;'>품목코드rev</th>
		     <th>품목</th>
		     <th>원산지</th>
		     <th>해동시작일시</th>
		     <th>해동종료일시</th>
		     <th>측정온도</th>
		     <th>표시사항</th>
		     <th>제품포장상태</th>
		     <th style='width:0px; display: none;'>작성자id</th>
		     <th style='width:0px; display: none;'>작성자id_rev</th>
		     <th>작성자</th>
		     <th style='width:0px; display: none;'>작성일</th>
		     <th style='width:0px; display: none;'>승인자id</th>
		     <th style='width:0px; display: none;'>승인자id_rev</th>
		     <th style='width:0px; display: none;'>승인자</th>
		     <th style='width:0px; display: none;'>승인일</th>
		     <th>부적합사항</th>
		     <th>대책 및 조치사항</th>
		     <th>비고</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
<!-- 		     <th style='width:0px; display: none;'></th>  -->
			 <th></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
