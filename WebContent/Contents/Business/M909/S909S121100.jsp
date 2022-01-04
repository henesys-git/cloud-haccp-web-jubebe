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

	String  GV_PROCESS_GUBUN="", GV_REV_CHECK = "", GV_PROD_CHECK="", GV_PID = "", GV_PROCESS_GUBUN_BIG = "";
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;
	
	if(request.getParameter("Process_gubun")== null)
		GV_PROCESS_GUBUN="";
	else
		GV_PROCESS_GUBUN = request.getParameter("Process_gubun");
	
	if (request.getParameter("total_rev_check") == null)
		GV_REV_CHECK = "";
	else
		GV_REV_CHECK = request.getParameter("total_rev_check");
	
	if (request.getParameter("total_prod_cd") == null)
		GV_PROD_CHECK = "";
	else
		GV_PROD_CHECK = request.getParameter("total_prod_cd");
	
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
	
	if (request.getParameter("Process_gubun_big") == null)
		GV_PROCESS_GUBUN_BIG = "";
	else
		GV_PROCESS_GUBUN_BIG = request.getParameter("Process_gubun_big");
	
	if(GV_PROD_CHECK.equals("true")) {
		if(GV_REV_CHECK.equals("true")){
			GV_PID = "M909S121100E104";
		} else if(GV_REV_CHECK.equals("false")) {
			GV_PID = "M909S121100E105";	
		}
	} else if(GV_PROD_CHECK.equals("false")) {
		if(GV_REV_CHECK.equals("true")){
			GV_PID = "M909S121100E106";	
		} else if(GV_REV_CHECK.equals("false")) {
			GV_PID = "M909S121100E107";	
		}
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("PROCESS_GUBUN", GV_PROCESS_GUBUN);
	jArray.put("PROCESS_GUBUN_BIG", GV_PROCESS_GUBUN_BIG);
	jArray.put("custcode", custCode);
	jArray.put("todate", Todate);
	jArray.put("fromdate", Fromdate);
	jArray.put("jsppage", GV_JSPPAGE);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel(GV_PID, jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S121100";
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs: [{
				'targets': [7,8,9,10,11,12],
				'createdCell':  function (td) {
					$(td).attr('style', 'display: none;'); 
				}
			}]
		};
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
		fn_Clear_varv();
    });	
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		vProd_cd		= td.eq(0).text().trim();
		vRevision_no	= td.eq(1).text().trim();
		vProduct_nm		= td.eq(2).text().trim();
		vGugyuk	        = td.eq(3).text().trim();
		vOption_cd		= td.eq(4).text().trim();
		vStart_date		= td.eq(5).text().trim();
		vDuration_date	= td.eq(6).text().trim();
		vCreate_user_id	= td.eq(7).text().trim();
		vCreate_date	= td.eq(8).text().trim();
		vModify_user_id	= td.eq(9).text().trim();
		vModify_reason	= td.eq(10).text().trim();
		vModify_date	= td.eq(11).text().trim();	
		
   	    parent.DetailInfo_List.click();
    }

	function fn_Clear_varv(){
    	// 초기화
    	vProd_cd		= "";
   		vRevision_no	= "";
   		vProduct_nm		= "";
   		vGugyuk	        = "";
   		vOption_cd		= "";
   		vStart_date		= "";
   		vDuration_date	= "";
   		vCreate_user_id	= "";
   		vCreate_date	= "";
   		vModify_user_id	= "";
   		vModify_reason	= "";
   		vModify_date	= "";
	}

</script>


<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>제품코드</th>
		     <th>개정번호</th>
		     <th>제품명</th>
		     <th>규격</th>
		     <th>선택사양</th>
		     <th>적용시작일자</th>
		     <th>적용종료일자</th>
		     <th style='width:0px; display: none;'>생성자</th>
		     <th style='width:0px; display: none;'>생성일자</th>
		     <th style='width:0px; display: none;'>수정자</th>
		     <th style='width:0px; display: none;'>수정사유</th>
		     <th style='width:0px; display: none;'>수정일자</th>
			 <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>