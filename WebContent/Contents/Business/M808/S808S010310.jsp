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

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_ASNOS="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("AsNos")== null)
		GV_ASNOS="";
	else
		GV_ASNOS = request.getParameter("AsNos");
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	JSONObject jArray = new JSONObject();
	jArray.put( "ORDERNO", GV_ORDERNO);
	jArray.put( "ASNOS", GV_ASNOS);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M808S010300E114", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS808S010310";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
%>
<script type="text/javascript">

    $(document).ready(function () {
    	var v<%=makeGridData.htmlTable_ID%> = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 180,
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
	  		/* =========================복사하여 수정 할 부분===========================================  */   
	  		'columnDefs': [{
	       		'targets': [0,2,3,4,6],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [16],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}
	  		/* =========================복사하여 수정 할 부분====끝=====================================  */  
			
			],    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vAsNos			= td.eq(1).text().trim();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>	   
		     <th style='width:0px; display: none;'>AS요청번호</th>
		     <th>AS처리번호</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>Lot번호</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     
		     <th>요청내용</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th>제품명</th>
		     <th>요청업체</th>
		     <th>수리일자</th>
		     
		     <th>출고일자</th>
		     <th>제목</th>
		     <th>고장 탐색/검토</th>
		     <th>수리 내용</th>
		     <th>수리 후 검사</th>
		     <th>결과 및 기타사항</th>
		     
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
