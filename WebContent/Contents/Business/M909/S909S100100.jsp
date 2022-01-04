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

	int startPageNo = 1;
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S100100E104", jArray);	

 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S100100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""};
 	makeGridData.HyperLink 	= HyperLink;    
%>

<script type="text/javascript">

    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,7],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				searching: true
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
		folder_menu_id	= "";
		menuName		= "";
		
		parent.$("#Main_contents2").children().remove();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		
		if(td.eq(3).text().trim()=="0") // menu_level == 0 일때, 4자리까지만(M101)
			folder_menu_id	= td.eq(1).text().trim().substring(0, 4);
		else if(td.eq(3).text().trim()=="1") // menu_level == 1 일때, 전부(M101S010000)
			folder_menu_id	= td.eq(1).text().trim();
		
		menuName= td.eq(2).text().trim();
		// 서브 메뉴를 보여준다.
		fn_DetailInfo_List();
    }
</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'></th>
		     <th>메뉴ID</th>
		     <th>메뉴명</th>
		     <th>메뉴레벨</th>
		     <th>정렬순서</th>
		     <th>삭제여부</th>
		     <th>상위메뉴</th>
		     <th style='width:0px; display: none;'>program_id</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>                 
