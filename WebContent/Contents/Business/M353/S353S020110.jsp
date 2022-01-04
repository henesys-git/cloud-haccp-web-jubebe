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
	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

	String  GV_PROC_PLAN_NO="",
			GV_BOM_CD="", GV_BOM_CD_REV="";

	if(request.getParameter("proc_plan_no") == null)
		GV_PROC_PLAN_NO="";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if(request.getParameter("bom_cd") == null)
		GV_BOM_CD = "";
	else
		GV_BOM_CD = request.getParameter("bom_cd");
	
	if(request.getParameter("bom_cd_rev") == null)
		GV_BOM_CD_REV = "";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put("proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put("bom_cd", GV_BOM_CD);
	jArray.put("bom_cd_rev", GV_BOM_CD_REV);
	jArray.put("member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S020100E114",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
        
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID = "tableS353S020110";
    
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink = HyperLink;
%>

<script>
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	var exportDate = new Date(); 
    	
    	var vColumnDefs = [{
			'targets': [0,1,3,4],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
		}];
    	
    	var vButtons = [
            {
                extend: 'excelHtml5',
                title: "계량관리 " + exportDate, //+ exportDate.format("yyyyMMdd_hhmmss"),
				exportOptions: {
		            columns: [2,5,6,7,8,9,10,11,12,13,14,15]			 
		    	},
                messageTop: null
            }
        ];
    	
    	henesysSubTableOptions.data = <%=makeGridData.getDataArry()%>;
		henesysSubTableOptions.columnDefs = vColumnDefs;
		henesysSubTableOptions.buttons = vButtons;
		henesysSubTableOptions.dom = 'Bfrtip';
    	
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysSubTableOptions);
    });
    
    
    function clickSubMenu(obj) {
      	var tr = $(obj);
  		var td = tr.children();
  		
  		var trNum = $(obj).closest('tr').prevAll().length; //현재 클릭한 TR의 순서 return
  		
  		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
  		
  		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
  	}    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th style='width:0px; display: none;'>원부재자코드</th>
			<th style='width:0px; display: none;'>배합(BOM)명</th>
			<th>원부자재명</th>
			<th style='width:0px; display: none;'>비고</th>
			<th style='width:0px; display: none;'>BOM코드</th>
			<th>사용량</th>
			<th>1계량</th>
			<th>2계량</th>
			<th>3계량</th>
			<th>4계량</th>
			<th>5계량</th>
			<th>6계량</th>
			<th>7계량</th>
			<th>8계량</th>
			<th>9계량</th>
			<th>10계량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body"></tbody>
</table>

<div id="UserList_pager" class="text-center"></div>              