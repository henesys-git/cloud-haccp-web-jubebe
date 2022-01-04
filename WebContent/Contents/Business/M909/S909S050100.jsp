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

	String GV_REV_CHECK = "", GV_PID = "" ;
	
	if (request.getParameter("total_rev_check") == null)
		GV_REV_CHECK = "";
	else
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) GV_PID = "M909S050100E104";
	else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S050100E105";
	

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel(GV_PID, jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "tableS909S050100";
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
					'targets': [18,19,20,21,22,23],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				scrollX : true,
				pageLength : 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
		seolbi_cd	= "";
		vRevisionNo	= "";
    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		seolbi_cd	= td.eq(0).text().trim();
		vRevisionNo	= td.eq(15).text().trim();
		
		<%-- var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050104.jsp?seolbi_cd=" + seolbi_cd + "&RevisionNo=" + vRevisionNo; --%>
		//pop_fn_popUpScr(modalContentUrl, "설비정보 상세 조회", '630px', '1350px');
		
		// 서브 메뉴를 보여준다.
// 		fn_DetailInfo_List();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>설비코드</th>
		     <th>설비명칭</th>
		     <th>도입일자</th>
		     <th>규격</th>
		     <th>제조사</th>
		     <th>기기번호</th>
		     <th>담당부서</th>
		     <th>사용담당자</th>
 		     <th>책임담당자</th>
 		     <th>교정담당자</th>
		     <th>유효일자</th>
		     <th>교정주기</th>
		     <th>교정일자</th>
		     <th>비고</th>
		     <th>이미지파일명</th>
		     <th>개정번호</th>
		     <th>적용시작일자</th>
 		     <th>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>설비구분</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
