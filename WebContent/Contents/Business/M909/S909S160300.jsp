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
	
	
	int startPageNo = 1;


	String  GV_PROCESS_GUBUN="", GV_REV_CHECK = "", GV_PID = "";

	if(request.getParameter("Process_gubun")== null)
		GV_PROCESS_GUBUN="";
	else
		GV_PROCESS_GUBUN = request.getParameter("Process_gubun");
	
	if (request.getParameter("total_rev_check") == null)
		GV_REV_CHECK = "";
	else
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) GV_PID = "M909S160300E104";
	else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S160300E105";
	
	String param =  GV_PROCESS_GUBUN + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "PROCESS_GUBUN", GV_PROCESS_GUBUN);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel(GV_PID,  jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();

    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S160300";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;

%>
<script type="text/javascript">

    $(document).ready(function () {
    	var dData = <%=makeGridData.getDataArry()%>;
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
   		    processing: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ],[ 1, "asc" ],[ 4, "asc" ]],

    	    info: true,
			data: dData,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		
	  		'columnDefs': [{
	       		'targets': [4,9,10,11,12,13],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [14],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}],               
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
		
		vProcCd		= td.eq(1).text().trim();
	 	vRevisionNo = td.eq(2).text().trim();
    }


</script>

	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>위해요소구분</th>
		     <th>위해요소코드</th>
		     <th>개정번호</th>
		     <th>위해요소명</th>
		     <th style='width:0px; display: none;'>작업순서</th>
		     <th>위해요소순번</th>
		     <th>비고</th>
		     <th>적용일자</th>
		     <th>적용종료</th>
		     <th style='width:0px; display: none;'>생성자</th>
		     <th style='width:0px; display: none;'>생성일자</th>
		     <th style='width:0px; display: none;'>수정자</th>
		     <th style='width:0px; display: none;'>수정사유</th>
		     <th style='width:0px; display: none;'>수정일자</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>                 
