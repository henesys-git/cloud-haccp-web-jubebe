<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
    
	String GV_CUSTOM_GUBUN = "", GV_CALLER = "";

	if(request.getParameter("Custom_gubun") == null)
		GV_CUSTOM_GUBUN = "";
	else
		GV_CUSTOM_GUBUN = request.getParameter("Custom_gubun");
	
	if(request.getParameter("caller") == null)
		GV_CALLER = "0";
	else
		GV_CALLER = request.getParameter("caller");	
    
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("CUST_NM", "");
	jArray.put("Custom_gubun", GV_CUSTOM_GUBUN);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S070100E114", jArray);
 	int RowCount = TableModel.getRowCount();
    
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {
    							{"off", "fn_Chart_View", rightbtnChartShow},
    							{"off", "fn_Doc_Reg()", rightbtnDocSave},
    							{"off", "file_real_name", rightbtnDocShow}
    						  };
 	makeGridData.RightButton = RightButton;
 	
    makeGridData.htmlTable_ID = "tableCustomView";
    
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""};
 	makeGridData.HyperLink = HyperLink;
%>
 
<script>
	var caller = "";
	
	$(document).ready(function () {
		
		caller = "<%=GV_CALLER%>";
    	
		setTimeout(function(){  // setTimeout(){.removeAttr('width')} : 
								// datatable th/td 넓이 안 맞는 것 방지
		
		// order: [[ 0, "desc" ]],
		$('#<%=makeGridData.htmlTable_ID%>').removeAttr('width').DataTable({	    
    		scrollX: true,
    	    scrollCollapse: true,
    	    autoWidth: true,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: true,  
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
				{
		   			'targets': [2],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;');
					}
		   		}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
		  });
		}, 300);
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
				
		var txt_custname = td.eq(0).text().trim();
		var txt_custcode = td.eq(1).text().trim(); 
		var txt_cust_rev = td.eq(2).text().trim(); 

		if(caller == "0") {
	 		$("#txt_CustName", parent.document).val(txt_custname);
	 		$("#txt_cust_code", parent.document).val(txt_custcode);
	 		$("#txt_cust_rev", parent.document).val(txt_cust_rev);
		} else if(caller == 1) {
 			parent.SetCustName_code(txt_custname, txt_custcode, txt_cust_rev);
		} else if(caller == 2) { //20190627 진욱 추가 (고객사 대표이름,종목,사업자번호,주소,전화번호)
			var txt_boss_name	= td.eq(7).text().trim();
			var txt_jongmok 	= td.eq(4).text().trim(); 
			var txt_bizno 	= td.eq(6).text().trim();
			var txt_address = td.eq(5).text().trim();
			var txt_telno 	= td.eq(8).text().trim();
			var txt_refno 	= td.eq(9).text().trim();//사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가
		
 			parent.SetCustName_code(txt_custname, txt_custcode, txt_cust_rev, 
 									txt_boss_name, txt_jongmok, txt_bizno, 
 									txt_address, txt_telno, txt_refno);
		}
		
		parent.$('#modalReport2').modal('hide');
		parent.$('#modalReport_nd').hide();	// modalReport2로 완전히 다 교체한 후에는 삭제할 예정
	}
	
</script>	

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>고객사상호</th>
		     <th>고객사번호</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th>업태</th>
		     <th>종목</th>
		     <th>주소</th>
		     <th>사업자등록번호</th>
		     <th>대표자성명</th>
		     <th>전화번호</th>
		     <th>사업장관리번호(이력제)</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center"></div> 