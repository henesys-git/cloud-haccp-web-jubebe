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

	String GV_PROCESS_GUBUN = "", 
		   GV_PROCESS_GUBUN_BIG = "", 
		   GV_REV_CHECK = "", 
		   GV_PID = "";

	if(request.getParameter("Process_gubun") != null)
		GV_PROCESS_GUBUN = request.getParameter("Process_gubun");

	if(request.getParameter("Process_gubun_big") != null)
		GV_PROCESS_GUBUN_BIG = request.getParameter("Process_gubun_big");
	
	if (request.getParameter("total_rev_check") != null)
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) {
		GV_PID = "M909S120100E104";
	} else if(GV_REV_CHECK.equals("false")) {
		GV_PID = "M909S120100E105";
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("PROCESS_GUBUN", GV_PROCESS_GUBUN);
	jArray.put("PROCESS_GUBUN_BIG", GV_PROCESS_GUBUN_BIG);

	DoyosaeTableModel TableModel = new DoyosaeTableModel(GV_PID, jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S120100";
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	var dData = <%=makeGridData.getDataArray()%>;
    	var regExp = /\\/gi;
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,2],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				pageLength: 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 목록 갱신 될 때 마다 초기화
    	vProcCd		= "";
	 	vRevisionNo = "";
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		console.log( "공정구분 : " + td.eq(0).text().trim() );
		console.log( "공정구분명 : " + td.eq(1).text().trim() );
		console.log( "대분류코드 : " + td.eq(2).text().trim() );
		console.log( "대분류코드명 : " + td.eq(3).text().trim() );
		console.log( "공정코드 : " + td.eq(4).text().trim() );
		console.log( "공정개정번호 : " + td.eq(5).text().trim() );
		console.log( "공정명 : " + td.eq(6).text().trim() );
		console.log( "작업순서 : " + td.eq(7).text().trim() );
		console.log( "공정순번 : " + td.eq(8).text().trim() );
		console.log( "생산공정 여부 : " + td.eq(9).text().trim() );
		console.log( "포장공정 여부 : " + td.eq(10).text().trim() );
		console.log( "비고 : " + td.eq(11).text().trim() );
		console.log( "적용일자 : " + td.eq(12).text().trim() );
		console.log( "적용종료 : " + td.eq(13).text().trim() );
		
		vProcCd		= td.eq(4).text().trim();
	 	vRevisionNo = td.eq(5).text().trim();
    }
</script>


<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>공정구분</th>
		     <th>공정구분명</th>
		     <th style='width:0px; display: none;'>대분류코드</th>
		     <th>대분류코드명</th>
		     <th>공정코드</th>
		     <th>공정개정번호</th>
		     <th>공정명</th>
		     <th>작업순서</th>
		     <th>공정순번</th>
		     <th>생산공정 여부</th>
		     <th>포장공정 여부</th>
		     <th>비고</th>
		     <th>적용일자</th>
		     <th>적용종료</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>                 