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
	
	String location_nm = "";
	
	if(request.getParameter("location_nm") != null)
		location_nm = request.getParameter("location_nm");

	JSONObject jArray = new JSONObject();
	jArray.put("location_nm", location_nm);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S115100E114", jArray);	
 	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS909S115110";
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	/* jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    	    "non-empty-string-asc": function (str1, str2) {
    	        if(str1 == "")
    	            return 1;
    	        if(str2 == "")
    	            return -1;
    	        return ((str1 < str2) ? -1 : ((str1 > str2) ? 1 : 0));
    	    },
    	 
    	    "non-empty-string-desc": function (str1, str2) {
    	        if(str1 == "")
    	            return 1;
    	        if(str2 == "")
    	            return -1;
    	        return ((str1 < str2) ? 1 : ((str1 > str2) ? -1 : 0));
    	    }
    	} ); */
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
					{
						'targets': [0,1],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					}
					
					/* ,
					{
						type: 'non-empty-string', 
						targets: 3	
					}  */
					
				],
				order : [[3, "asc"]]
				
				//pageLength : 10,
				//paging : true
				
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
		  mergeOptions(heneSubTableOpts, customOpts)
		);
		
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		cust_cd 		= td.eq(0).text().trim(); 
		cust_rev_no 	= td.eq(1).text().trim();
		cust_nm 		= td.eq(2).text().trim();
		deliver_index 	= td.eq(3).text().trim();
		start_date 		= td.eq(4).text().trim();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th>가맹점명</th>
		     <th>배송순번</th>
		     <th>적용시작일자</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>