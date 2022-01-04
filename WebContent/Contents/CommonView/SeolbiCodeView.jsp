<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!-- <!DOCTYPE html> -->
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head > -->
<%
/* 
SeolbiCodeView.jsp
 */
	
	String GV_CALLER="";
	
	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");

    String loginID = session.getAttribute("login_id").toString();
    String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	int startPageNo = 1;

	JSONObject jArray = new JSONObject();
	
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S050100E194", jArray);
    //int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableSeolbiCodeView";
    
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
    	    data: <%=makeGridData.getDataArry()%>,
    	    order: [[ 0, "asc" ]],
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");	      		
    	    },
	  		'columnDefs': [
				{
		   			'targets': [7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],
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

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
		
		var txt_seolbi_cd 	= td.eq(0).text().trim();
		var txt_seolbi_rev = td.eq(15).text().trim();
		var txt_seolbi_nm 	= td.eq(1).text().trim(); 

// 		if(caller==0){ //일반 화면에서 부를 때
// 			$('#txt_process_cd').val(txt_seolbi_cd);
// 			$('#txt_process_rev').val(txt_seolbi_rev);
// 			$('#txt_process_name').val(txt_seolbi_nm);
// 		}
// 		else
		if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm);
		}
		parent.$('#modalReport_nd').hide();
	}
	

	
</script>	

	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>설비코드</th>
		     <th>설비명칭</th>
		     <th>도입일자</th>
		     <th>규격</th>
		     <th>제조사</th>
		     <th>기기번호</th>
		     <th>담당부서</th>
		     <th style='width:0px; display: none;'>사용담당자</th>
		     <th style='width:0px; display: none;'>책임담당자</th>
		     <th style='width:0px; display: none;'>교정담당자</th>
		     
		     <th style='width:0px; display: none;'>유효일자</th>
		     <th style='width:0px; display: none;'>교정주기</th>
		     <th style='width:0px; display: none;'>교정일자</th>
		     <th style='width:0px; display: none;'>비고</th>
		     <th style='width:0px; display: none;'>이미지파일명</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th style='width:0px; display: none;'>적용시작일자</th>
		     <th style='width:0px; display: none;'>적용종료일자</th>
		     
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>설비구분</th>
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