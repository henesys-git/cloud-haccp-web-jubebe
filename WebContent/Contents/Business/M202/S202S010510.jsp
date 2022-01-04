<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;

	/* String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  }; */

	String GV_PARTNO = "";

	if(request.getParameter("PartNo")== null)
		GV_PARTNO = "";
	else
		GV_PARTNO = request.getParameter("PartNo");	
	
	String param = GV_PARTNO + "|" + member_key;
	
	JSONObject jArray = new JSONObject();
	jArray.put("PartNo", GV_PARTNO);
	jArray.put("member_key", member_key);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M202S010100E010", jArray);

    makeGridData= new MakeGridData(TableModel);
 	//makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S010510";
    
 	/* makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""};
 	makeGridData.HyperLink 	= HyperLink; */
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	       		'targets': [0,2,7,12,13,14],
   	       		'createdCell': function (td) {
   	          		$(td).attr('style', 'display: none;'); 
   	       		}
   	    	},
   			{
	  			'targets': [9],
	  			'render': function(data){
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
	  		}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    });
    
	function clickSubMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$($("input[id='checkbox1']")[trNum]).prop("checked", function() {
	        return !$(this).prop('checked');
	    });
	
		/* $(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color"); */
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th style='width:0px; display: none;'>대분류코드</th>
			<th>대분류</th>
			<th style='width:0px; display: none;'>중분류코드</th>
			<th>중분류</th>
			<th>품목코드</th>
			<th>원부자재명</th>
			<th>규격</th>
			<th style='width:0px; display: none;'>원부재료 수정이력번호</th>
			<th>최초입고일자</th>
			<th>현재재고</th><!-- <th>새로 입/출고된 재고</th> -->
			<th>유통기한</th>
			<th>비고</th>
			<th style='width:0px; display: none;'>part_level</th>
			<th style='width:0px; display: none;'>part_type</th>
			<th style='width:0px; display: none;'>단가</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>