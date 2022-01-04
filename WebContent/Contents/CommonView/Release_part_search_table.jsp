<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String zhtml = "";
	int startPageNo = 1;

	String GV_PART_CD,GV_PART_CD_REV;
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("part_cd", GV_PART_CD);
	jArray.put("member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M202S120100E194", jArray);
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();
    
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableRelease_part_search_table";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

 
<script>
	$(document).ready(function () {
		$('#<%=makeGridData.htmlTable_ID%>').DataTable({	    	
    		scrollX: true,
    	    scrollCollapse: true,
    	    autoWidth: true,
    	    processing: true,
    	    paging: true,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 12, "asc" ]],
    	    lengthChange: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
				{
		   			'targets': [0,1,2,4,5,6,7,9,14,15],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	});

	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");


		parent.$('#modalReport_nd').hide();
// 		window.close();

		$('#txt_store_no').val(td.eq(0).text().trim());
		$('#txt_rakes_no').val(td.eq(4).text().trim());
		$('#txt_plate_no').val(td.eq(5).text().trim());
		$('#txt_colm_no').val(td.eq(6).text().trim());
		$('#txt_pre_amt').val(td.eq(7).text().trim());
		$('#txt_post_stack').val(td.eq(8).text().trim());
		
		$('#txt_part_cd').val(td.eq(1).text().trim());
		$('#txt_part_cd_rev').val(td.eq(2).text().trim());
		$('#txt_part_name').val(td.eq(3).text().trim());
		
		$('#txt_expiration_date').val(td.eq(12).text().trim());
	}

	
</script>	
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
	<tr>
		<th style='width:0px; display: none;'>자동창고번호</th>
		<th style='width:0px; display: none;'>원부자재코드</th>
		<th style='width:0px; display: none;'>원부자재개정번호</th>
		<th>원부자재명</th>
		<th style='width:0px; display: none;'>렉번호</th>
		<th style='width:0px; display: none;'>선반번호</th>
		<th style='width:0px; display: none;'>칸번호</th>
		<th style='width:0px; display: none;'>입출고전재고</th>
		<th>현재재고</th>
		<th style='width:0px; display: none;'>입출고수량</th>
		<th>창고적재위치</th>
		<th>입고날짜</th>
		<th>유통기한</th>
		<th>비고</th>
		<th style='width:0px; display: none;'>member_key</th>
	    <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
	    <th style='width:0px; display: none;'></th> 
	</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div> 
