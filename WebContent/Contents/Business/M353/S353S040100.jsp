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
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S040100E104",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS353S040100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [{
       		'targets': [0,3,4,6,7,9,13,14],
       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); 
       		}
		}
		];
		
		henesysMainTableOptions.data = <%=makeGridData.getDataArry()%>;
		henesysMainTableOptions.columnDefs = vColumnDefs;
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysMainTableOptions);
    	
    	<%-- 
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [0,3,4,6,7,9,13,14],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			}
			], 
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		}); 
		--%>
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vOrderNo	= td.eq(1).text().trim();
		vLotno	= td.eq(2).text().trim();
		vBomCd	= td.eq(10).text().trim();
		vBomCdRev	= td.eq(11).text().trim();
		vBomName	= td.eq(12).text().trim();
		
		fn_DetailInfo_List();
    }

</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>member_key</th>
		     <th>주문번호</th>
		     <th>lot_no</th>
		     <th style='width:0px; display: none;'>cust_cd</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th>고객사 이름</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_rev</th>
		     <th>제품이름</th>
		     <th style='width:0px; display: none;'>revision_no</th>
		     <th>배합(BOM)코드</th>
		     <th>bom_cd_rev</th>
		     <th>BOM이름</th>
		     <th style='width:0px; display: none;'>last_no</th>
		     <th style='width:0px; display: none;'>sys_bom_id</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>


<div id="UserList_pager" class="text-center">
</div>                 
