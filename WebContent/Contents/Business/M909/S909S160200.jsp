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

	String REV_CHECK = "", PID_FOR_REV_CHECK = "";

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);

	if (request.getParameter("total_rev_check") == null)
		REV_CHECK = "";
	else
		REV_CHECK = request.getParameter("total_rev_check");

	if(REV_CHECK.equals("true")) PID_FOR_REV_CHECK = "M909S160200E104";
	else if(REV_CHECK.equals("false")) PID_FOR_REV_CHECK = "M909S160200E105";
	
    TableModel = new DoyosaeTableModel(PID_FOR_REV_CHECK, jArray);	
 	int RowCount =TableModel.getRowCount();
    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S160200";
    
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
					'targets': [2,6,10],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		/* console.log( "CCP 번호 : " + td.eq(0).text().trim() );
		console.log( "CCP 이름 : " + td.eq(1).text().trim() );
		console.log( "CCP 타입 : " + td.eq(2).text().trim() );
		console.log( "코드 이름: " + td.eq(3).text().trim() );
		console.log( "최소값 : " + td.eq(4).text().trim() );
		console.log( "최대값 : " + td.eq(5).text().trim() );
		console.log( "표준값 : " + td.eq(6).text().trim() );
		console.log( "비고 : " + td.eq(7).text().trim() );
		console.log( "적용일자 : " + td.eq(8).text().trim() );
		console.log( "적용종료 : " + td.eq(9).text().trim() );
		console.log( "멤버키 : " + td.eq(10).text().trim() ); */

		vCCPNo = td.eq(0).text().trim();
		vSeqNo = td.eq(1).text().trim();
		vRevisionNo = td.eq(4).text().trim();
    }

</script>
	
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>CCP 번호</th>
			<th>CCP 이름</th>
			<th style='width:0px; display: none;'>CCP 타입</th>
			<th>코드이름</th>
			<th>최소값</th>
			<th>최대값</th>
			<th style='width:0px; display: none;'>표준값</th>
			<th>비고</th>
			<th>적용일자</th>
			<th>적용종료</th>
			<th style='width:0px; display: none;'>Member_key</th>
			<!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 			<th style='width:0px; display: none;'></th> -->
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>