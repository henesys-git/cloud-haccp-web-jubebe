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

	if(GV_REV_CHECK.equals("true")) GV_PID = "M909S070100E104";
	else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S070100E105";

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
    makeGridData.htmlTable_ID	= "tableS909S070100";
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
					'targets': [6,13,14,15,16,17,18,19],
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
		
		cust_cd	= "";
		vRevisionNo	= "";
		vLog_refno = "";
		vIoGb = "";
    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		cust_cd		= td.eq(0).text().trim();
		vRevisionNo	= td.eq(1).text().trim();
		vLog_refno	= td.eq(18).text().trim();//사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가
		vIoGb		= td.eq(6).text().trim();
		location_nm	= td.eq(19).text().trim();
		
		// 서브 메뉴를 보여준다.
// 		fn_DetailInfo_List();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>기관코드</th>
		     <th>개정번호</th>
		     <th>기관명</th>
		     <th>사업자등록번호</th>
		     <th>전화번호</th>
		     <th>주소</th>
		     <th style='width:0px; display: none;'>거래처구분코드</th>
		     <th>거래처구분</th>
		     <th>업태</th>
		     <th>종목</th>
		     <th>대표자명</th>
		     <th>적용시작일자</th>
		     <th>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>modify_date</th>
 		     <th style='width:0px; display: none;'>이력제사업장관리번호</th><!--사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가-->
 		     <th style='width:0px; display: none;'>가맹점지역구분코드</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
