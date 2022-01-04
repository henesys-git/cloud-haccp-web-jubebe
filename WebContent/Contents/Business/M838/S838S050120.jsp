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
	
	String GV_CHECK_DURATION="",GV_CHECK_DATE="",GV_CHECK_TIME="" ;

	if(request.getParameter("check_duration")== null)
		GV_CHECK_DURATION = "";
	else
		GV_CHECK_DURATION = request.getParameter("check_duration");
	
	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");	
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME="";
	else
		GV_CHECK_TIME = request.getParameter("check_time");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_duration", GV_CHECK_DURATION);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);
	
    TableModel = new DoyosaeTableModel("M838S050100E124", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S050120";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 8, "asc" ]], // checklist_seq 순으로 정렬
    	    keys: true,
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [0,1,2,3,4,6,8,9,10,11,12,13, 16,17,18,19,20,21,22],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [23],
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
         
    }

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>점검기간</th>
		     <th style='width:0px; display: none;'>점검일자</th>
		     <th style='width:0px; display: none;'>점검시간</th>
		     <th style='width:0px; display: none;'>체크구분</th>
		     <th style='width:0px; display: none;'>구분 중분류 코드</th>
		     <th>구분 중분류</th>
		     <th style='width:0px; display: none;'>구분 소분류 코드</th>
		     <th>구분 소분류</th>
		     <th style='width:0px; display: none;'>체크문항코드</th>
		     <th style='width:0px; display: none;'>체크문항rev</th>
		     <th style='width:0px; display: none;'>체크문항seq</th>
		     <th style='width:0px; display: none;'>체크아이템코드</th>
		     <th style='width:0px; display: none;'>체크아이템seq</th>
		     <th style='width:0px; display: none;'>체크아이템rev</th>
		     <th>점검항목</th>
		     <th>결과 값</th>
		     <th style='width:0px; display: none;'>검사일</th>
		     <th style='width:0px; display: none;'>점검자(정)</th>
		     <th style='width:0px; display: none;'>승인</th>
		     <th style='width:0px; display: none;'>부적합사항</th>
		     <th style='width:0px; display: none;'>개선사항</th>
		     <th style='width:0px; display: none;'>기준사항</th>
		     <th style='width:0px; display: none;'>기준값</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
<!-- 		     <th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
<!--  <div style="width:100%;clear:both"> -->
    	<p style="text-align:center;">
        	<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    	</p>
<!--  </div> -->
</div>   
    