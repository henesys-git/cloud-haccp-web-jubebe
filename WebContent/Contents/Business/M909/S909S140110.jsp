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
	MakeTableHTML makeTableHTML;
	MakeGridData makeGridData;
	
	int startPageNo = 1;
/* =========================복사하여 수정 할 부분=================================================  */   

   String GV_CODE_CD = "", GV_REV_CHECK = "", GV_PID = "";
   if(request.getParameter("CodeGroupGubun")== null )
      GV_CODE_CD = "";
   else
      GV_CODE_CD = request.getParameter("CodeGroupGubun");
   
   if (request.getParameter("total_rev_check") == null)
      GV_REV_CHECK = "";
   else
      GV_REV_CHECK = request.getParameter("total_rev_check");

   if(GV_REV_CHECK.equals("true")) GV_PID = "M909S140100E196";
   else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S140100E197";
   
   JSONObject jArray = new JSONObject();
   jArray.put( "member_key", member_key);
   jArray.put( "CODE_CD", GV_CODE_CD);
	
    TableModel = new DoyosaeTableModel(GV_PID, jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "tableS909S140110";
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
					'targets': [7,8,9,10,11,12],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
		
    	//fn_MainInfo_List(); 
   		vDetailCodeValue = "";
   		vDetailRevisionNo = "";
    });
    
    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
	    //alert(vCodeGroupGubun + "." + vCodeValue + "." + vRevisionNo);
	    vDetailCodeValue   = td.eq(1).text().trim();
	    vDetailRevisionNo   = td.eq(3).text().trim();
	    vBigo   = td.eq(4).text().trim();
    }

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>공통코드그룹</th>
		     <th>공통코드</th>
		     <th>공통코드명</th>
		     <th>개정번호</th>
		     <th>비고</th>
		     <th>적용시작일자</th>
		     <th>적용종료일자</th>
		     <th style='width:0px; display: none;'>생성자</th>
		     <th style='width:0px; display: none;'>정렬순서</th>
		     <th style='width:0px; display: none;'>생성일자</th>
		     <th style='width:0px; display: none;'>수정자</th>
		     <th style='width:0px; display: none;'>수정사유</th>
		     <th style='width:0px; display: none;'>수정일자</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
