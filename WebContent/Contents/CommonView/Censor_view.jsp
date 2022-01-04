<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	/* String MEMBER_KEY = "";

	if(request.getParameter("member_key") == null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key"); */
    
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S170100E104", jArray);
 	int RowCount =TableModel.getRowCount();
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableCustomView";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>

<script>
	$(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
//     		scrollY: 600,
    	    scrollCollapse: true,
    	    autoWidth: true,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: true,  
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [3,7],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [8],
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

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");

		/* for( var i = 0 ; i < 7 ; i++ )
		{
			console.log( "td.eq(" + i + ") : " + td.eq(i).text().trim() );
		} */
		
		console.log( "센서 번호 : " + td.eq(0).text().trim() );
		console.log( "센서 채널 번호 : " + td.eq(1).text().trim() );
		console.log( "센서 이름 : " + td.eq(2).text().trim() );
		console.log( "센서 데이터 유형 코드 : " + td.eq(3).text().trim() );
		console.log( "센서 데이터 유형 : " + td.eq(4).text().trim() );
		console.log( "센서 데이터 수집주기 : " + td.eq(5).text().trim() );
		console.log( "센서 위치 : " + td.eq(6).text().trim() );
		console.log( "멤버키 : " + td.eq(7).text().trim() );
		
		vCensorNo = td.eq(0).text().trim();

		var cNumber = td.eq(0).text().trim();
		var cNno 	= td.eq(1).text().trim();
		var cName	= td.eq(2).text().trim();

		parent.SetCensorInfo(cNumber, cName,cNno);
		parent.$('#modalReport_nd').hide();
	}
	
</script>	

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>센서 번호</th>
		     <th>센서 채널 번호</th>
		     <th>센서 이름</th>
		     <th style='width:0px; display: none;'>센서 데이터 유형코드</th>
		     <th>센서 데이터 유형</th>
		     <th>데이터 수집주기</th>
		     <th>센서 위치</th>
			<th style='width:0px; display: none;'>Member_key</th>
			<!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
			<th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div> 
