<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_PART_CD, GV_PART_REV_NO, GV_TRACE_KEY;
	
	if(request.getParameter("part_cd") == null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	if(request.getParameter("part_cd") == null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	if(request.getParameter("part_rev_no") == null)
		GV_PART_REV_NO="";
	else
		GV_PART_REV_NO = request.getParameter("part_rev_no");
	
	if(request.getParameter("trace_key") == null)
		GV_TRACE_KEY = "";
	else
		GV_TRACE_KEY = request.getParameter("trace_key");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("part_cd", GV_PART_CD);
	jArray.put("part_rev_no", GV_PART_REV_NO);
	jArray.put("trace_key", GV_TRACE_KEY);
	jArray.put("member_key", member_key);
			
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M353S010100E114", jArray);	//검수정보를 가져와야 함
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID	= "tableS353S010110";
%>
<script>
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
					{
				    	'targets': 5,
			   			'createdCell':  function (td) {
			      			$(td).attr('style', 'display: none;');
			   			}
				    },
					{
				    	'targets': 3,
	                    'render': function ( data, type, row ) {
	                    	if(row[5] == 1) {
	                    		return '<span style="color:blue">+ '+addComma(data)+'</span>';
	                    	} else if(row[5] == 2) {
	                    		return '<span style="color:red">- '+addComma(data)+'</span>';
	                    	} else {
	                    		return data;
	                    	}
	                    },
			  			'className' : "dt-body-right"
	                }
			    ]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
	});
    
	 function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>품목명</th>
			<th>일자</th>
			<th>시간</th>
			<th>입출고 수량</th>
			<th>비고</th>
			<th style="display:none; width:0px">구분</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>   
<div id="UserList_pager" class="text-center">
</div>              