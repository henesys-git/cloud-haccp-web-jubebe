<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_CALLER="";

	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
    
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S060100E164", jArray);
 	int RowCount =TableModel.getRowCount();
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S060160";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>

 
<script>
	var caller="";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
//     		scrollY: 600,
    	    scrollCollapse: true,
    	    autoWidth: true,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 4, "desc" ]],
    	    info: true,  
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
				{
		   			'targets': [2,3,8],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	    });
	});
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
				
		var txt_vehicle_nm = td.eq(0).text().trim();
		var txt_vehicle_cd = td.eq(1).text().trim(); 
		var txt_vehicle_cd_rev = td.eq(2).text().trim(); 
		var txt_transport_dt = td.eq(3).text().trim(); 

		if(caller=="0"){
	 		$("#txt_vhcl_nm", parent.document).val(txt_vehicle_nm);
	 		$("#txt_vhcl_no", parent.document).val(txt_vehicle_cd);
	 		$("#txt_vhcl_no_rev", parent.document).val(txt_vehicle_cd_rev);
	 		$("#txt_service_date", parent.document).val(txt_transport_dt);
		}
		else if(caller==1){
 			parent.SetVehicle_code(txt_vehicle_nm, txt_vehicle_cd, txt_vehicle_cd_rev, txt_transport_dt);
		}
		
		parent.$('#modalReport_nd').hide();
	}
	
</script>	

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>차량명</th>
		     <th>차량번호</th>
		     <th style='width:0px; display: none;'>차량번호rev</th>
		     <th style='width:0px; display: none;'>운행일자</th>
		     <th>운행시작일시</th>
		     <th>운행종료일시</th>
		     <th>운전자</th>
		     <th>비고</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
<!-- 		     <th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div> 
