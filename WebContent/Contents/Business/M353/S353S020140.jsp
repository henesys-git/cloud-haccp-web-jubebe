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
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String GV_PROC_PLAN_NO="", 
			GV_BOM_CD="", GV_BOM_CD_REV="";
	
	if(request.getParameter("proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");	
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD = "";
	else
		GV_BOM_CD = request.getParameter("bom_cd");
	
	if(request.getParameter("bom_cd_rev")== null)
		GV_BOM_CD_REV = "";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");

	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "bom_cd", GV_BOM_CD);
	jArray.put( "bom_cd_rev", GV_BOM_CD_REV);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S020100E145",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS353S020140";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
    
<script>
$(document).ready(function () {
	vTableS353S020140 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	
		scrollX: true,
		scrollY: 500,
	    scrollCollapse: true,
	    paging: false,
	    searching: false,
	    ordering: false,
	    order: [[ 0, "asc" ]],
	    info: false,
		data: <%=makeGridData.getDataArry()%>,
	    'createdRow': function(row) {	
      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
      		$(row).attr('role',"row");
  		},    
  		'columnDefs': [
  			{
	       		'targets': [0,2,3,16,17],
	       		'createdCell':  function (td) {
	          		$(td).attr('style', 'display: none;');
	       		}
       		},
       		{
       			'targets': [6,7,8,9,10,11,12,13,14,15],
           		'createdCell':  function (td, cellData, rowData, rowinx, col) {
           			$(td).text("");
           			$(td).append("<input type='text' style='width:100%;'value='"+cellData+"' readonly />");
           		}
       		}
		], 
	    language: { 
            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
         }
	});
	
	TableS353S020140_RowCount = vTableS353S020140.rows().count();
	if(TableS353S020140_RowCount>0){
		var v_production_date = vTableS353S020140.cell(0,16).data();
		if(v_production_date.length>0) {
			$('#txt_production_date').val(v_production_date);
		}
	} else {
		alert("삭제할 데이터가 없습니다");
		parent.$("#ReportNote").children().remove();
 		parent.$('#modalReport').hide();
	}
});


function <%=makeGridData.htmlTable_ID%>Event(obj){
	tr = $(obj);
	td = tr.children();
	trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
	
	$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
	$(obj).attr("class", "hene-bg-color");

}


</script>

	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>sys_bom_id</th>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th style='width:0px; display: none;'>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th>사용량(g)</th>
		     <th style='width:5%;'>1계량</th>
		     <th style='width:5%;'>2계량</th>
		     <th style='width:5%;'>3계량</th>
		     <th style='width:5%;'>4계량</th>
		     <th style='width:5%;'>5계량</th>
		     <th style='width:5%;'>6계량</th>
		     <th style='width:5%;'>7계량</th>
		     <th style='width:5%;'>8계량</th>
		     <th style='width:5%;'>9계량</th>
		     <th style='width:5%;'>10계량</th>
		     <th style='width:0px; display: none;'>제조일자</th>
		     <th style='width:0px; display: none;'>버튼</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>



