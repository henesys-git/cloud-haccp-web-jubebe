<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;
	
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
	String GV_BOM_CODE="", GV_REVISION_NO="", GV_PROD_CD="" ,GV_CALLER="", GV_PROD_NM="";
	String GV_BALJUNO="", GV_TRACE_KEY;
	
	if(request.getParameter("caller") == null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("BomCode") == null)
		GV_BOM_CODE="";
	else
		GV_BOM_CODE = request.getParameter("BomCode");
	
	if(request.getParameter("prod_cd") == null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_nm") == null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
	
	if(request.getParameter("BaljuNo") == null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	if(request.getParameter("TraceKey") == null)
		GV_TRACE_KEY = "";
	else
		GV_TRACE_KEY = request.getParameter("TraceKey");

	String param =   GV_BOM_CODE + "|" + GV_PROD_CD + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("BaljuNo", GV_BALJUNO);
	jArray.put("TraceKey", GV_TRACE_KEY);
		
    TableModel = new DoyosaeTableModel("M202S010100E020", jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
 	makeGridData.htmlTable_ID 	= "tableOrderedPartView";
 	
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">
    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
   			data : <%=makeGridData.getDataArry()%>,
   			columnDefs : [{
   	       		'targets': [4,5,6],
   	       		'createdCell': function (td) {
   	          			$(td).attr('style', 'display: none;');
   	       		}
   	    	}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').removeAttr('width').DataTable(
    		mergeOptions(henePopupTableOpts, customOpts)
    	);
		
    	}, 400);
		
		
    	vPart_cd = "";
			
		});
        

		
    
    function clickPopupMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;	// 현재 클릭한 TR의 순서 return
		
		$(PopupMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		
		var part_name 			= td.eq(0).text().trim();
		var gyugeok				= td.eq(1).text().trim();
		var part_cnt			= td.eq(2).text().trim();
		var unit_price			= td.eq(3).text().trim();
		var part_cd				= td.eq(4).text().trim();
		var part_rev_no			= td.eq(5).text().trim();
		var balju_rev_no		= td.eq(6).text().trim();
		
		
		parent.SetPartInfo(part_name, gyugeok, part_cnt, unit_price, part_cd, part_rev_no, balju_rev_no);
		
		parent.$('#modalReport2').modal('hide');
		parent.$('#modalReport_nd').hide();
		
    }
    
</script>

<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
        <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle">발주서 내 원부자재 목록</i>
          	</h3>
        </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>원부자재명</th>
			<th>규격</th>
			<th>수량</th>
			<th>단가</th>
			<th style='width:0px; display: none;'>원부자재코드</th>
			<th style='width:0px; display: none;'>원부자재수정이력번호</th>
			<th style='width:0px; display: none;'>발주서수정이력번호</th>
			
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
			</table>
         </div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->