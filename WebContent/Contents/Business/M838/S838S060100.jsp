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
	
    TableModel = new DoyosaeTableModel("M838S060100E104", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS838S060100";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	vVhclNo = "";
    	vVhclNoRev = "";
    	vVhclNm = "";
    	vServiceDate = "";
    });
    /* ==================service=======복사하여 수정 할 부분===========================================  */  
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vVhclNo = td.eq(2).text().trim();
		vVhclNoRev = td.eq(1).text().trim();
		vVhclNm = td.eq(1).text().trim();
		vServiceDate = td.eq(0).text().trim();
		
		DetailInfo_List.click();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>운행일자</th>
<!-- 		     <th style='width:0px; display: none;'>vehicle_cd_rev</th> -->
		     <th>차량이름</th>
		     <th>차량번호</th>
		     <th>출발지</th>
		     <th>도착지</th>
		     <th>총주행거리</th>
		     <th>운행거리</th>
		     <th>특이사항</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
<!-- 		     <th></th>  -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
