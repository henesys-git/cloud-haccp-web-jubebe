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

	
	String Fromdate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE; 
	
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	String param =  Fromdate + "|" + GV_JSPPAGE + "|"  + custCode + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S016100E104",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS353S016100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
//  	System.out.println("2121 makeGridData.getDataArry() : " + makeGridData.getDataArry());
%>

<script type="text/javascript">

    $(document).ready(function () {

    	var v<%=makeGridData.htmlTable_ID%> = $('#<%=makeGridData.htmlTable_ID%>').DataTable({		
    		scrollX: true,
    		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    lengthMenu: [[10,15], ["10줄","15줄"]],
    	    searching: true,
    	    ordering: true,
    	    order: [[ 11, "desc" ]],
    	    info: false,
<%-- 			data: <%=makeGridData.getDataArry()%>, --%>
			
			processing: true,
    		serverSide: true,
    		ajax: {
    			 type: "POST",
    			 url: '<%=Config.this_SERVER_path%>/Contents/JSON/M353/J353S016100.jsp',
    			 data:{ 
    				 Fromdate:"<%=Fromdate%>"
    			 }			
    		},
    		columns: [
                { "data": "종류1" },
                { "data": "종류2" },
                { "data": "제품명" },
                { "data": "구분" },
                { "data": "단가" },
                { "data": "전일재고" },
                { "data": "입고" },
                { "data": "출고" },
                { "data": "현재고" },
                { "data": "현재고금액" },
                { "data": "total" },
                { "data": "part_cd" }
            ],

		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [10,11],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			}
// 			,{
// 	       		'targets': [24],
// 	       		'createdCell':  function (td) {
//           			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
//        			}
// 	       	}
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
		
// 		vSeolbiCd	= td.eq(0).text().trim();
// 		vRevisionNo	= td.eq(15).text().trim();
		
// 		fn_DetailInfo_List();
    }

</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th></th>
			 <th>종류</th>
		     <th>제품명</th>
		     <th>구분</th>
		     <th>단가</th>
		     <th>전일재고</th>
		     <th>입고</th>
		     <th>출고</th>
		     <th>현재고</th>
		     <th>현재고금액</th>
		     <th style='width:0px; display: none;'>total</th>
		     <th style='width:0px; display: none;'>part_cd</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
	
<div id="UserList_pager" class="text-center">
</div>                 
