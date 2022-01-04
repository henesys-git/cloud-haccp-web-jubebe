<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M909S160100E114",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
        
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS909S160110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 450,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
				$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
			'columnDefs': [{
       			'targets': [6],
       			'createdCell':  function (td) {
          				$(td).attr('style', 'display: none;'); 
       			}
			},
			{
       			'targets': [7],
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
  		$(obj).attr("class", "hene-bg-color");

  		/* for( var i = 0 ; i < 7 ; i++ )
		{
			console.log( "td.eq(" + i + ") : " + td.eq(i).text().trim() );
		} */
		
		console.log( "센서No : " + td.eq(0).text().trim() );
		console.log( "센서 채널 번호 : " + td.eq(1).text().trim() );
		console.log( "센서 이름 : " + td.eq(2).text().trim() );
		console.log( "센서 데이터 유형 : " + td.eq(3).text().trim() );
		console.log( "센서 데이터 수집주기 : " + td.eq(4).text().trim() );
		console.log( "센서 위치 : " + td.eq(5).text().trim() );
		console.log( "멤버키 : " + td.eq(6).text().trim() );
		
		vCensorNoOfRecord = td.eq(0).text().trim();
  }
    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
<%-- 		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th>메인코드</th>
		     <th>업무구분</th>
		     <th>기관명</th>
		     <th>수리내용</th>
		     <th>반출일</th>
		     
		     <th>완료일</th>
		     <th>담당자</th>
		     <th>비용</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>SEQ_NO</th>
		     
		     
		<% } else { %> --%>
		
			 <th>센서 번호</th>
		     <th>센서 채널 번호</th>
		     <th>센서 이름</th>
		     <th>센서 데이터유형</th>
		     <th>데이터수집주기</th>
		     <th>센서위치</th>
		     <th style='width:0px; display: none;'>멤버키</th>
		     <th></th>
		     
		     
<%-- 		<% } %> --%>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              