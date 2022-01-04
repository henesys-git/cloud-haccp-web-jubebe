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
	
	String Fromdate="",Todate="",custCode="";

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
		
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("custcode", custCode);
	jArray.put("member_key", member_key);	
    TableModel = new DoyosaeTableModel("M101S040100E804", jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "pop_fn_Trading_List(this)", "상세"}};
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	
 	makeGridData= new MakeGridData(TableModel);
	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS101S040800";
 	makeGridData.Check_Box 	= "false";
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [{
    					'targets': [3,4,6,8,9,10,12,13],
    		   			'createdCell':  function (td) {
    		      			$(td).attr('style', 'display: none;'); 
    		   			}
    			}]
    	};
    	
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
	}
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			 <th>출하번호</th>
			 <th>주문번호</th>
		     <th>포장단위</th>
		     <th style='width:0px; display:none;'>prod_cd</th>
		     <th style='width:0px; display:none;'>prod_rev</th>
		     <th>납품처</th>
		     <th style='width:0px; display:none;'>고객사번호</th>
		     <th>납품일자</th>
		     <th style='width:0px; display:none;'>납품담당자</th>
		     <th style='width:0px; display:none;'>출하비고</th>
		     <th style='width:0px; display:none;'>출하seq구분번호</th>
		     <th>제품명</th>
		     <th style='width:0px; display:none;'>주문명</th>
		     <th style='width:0px; display:none;'>고객사PO번호</th>
		     <!--	버튼자리	-->
			 <th></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>