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
	
	String GV_CHECK_DATE="",GV_CHECK_TIME="",GV_CUST_CD="",GV_CUST_CD_REV="" ;

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");	
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME="";
	else
		GV_CHECK_TIME = request.getParameter("check_time");
	
	if(request.getParameter("cust_cd")== null)
		GV_CUST_CD="";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("cust_cd_rev")== null)
		GV_CUST_CD_REV="";
	else
		GV_CUST_CD_REV = request.getParameter("cust_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);
	jArray.put( "cust_cd", GV_CUST_CD);
	jArray.put( "cust_cd_rev", GV_CUST_CD_REV);
	
    TableModel = new DoyosaeTableModel("M838S050300E114", jArray);
 	int RowCount =TableModel.getRowCount();

    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S050310";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 7, "asc" ]], // checklist_seq 순으로 정렬
    	    keys: true,
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [0,1,2,3,4,5,6,7,8,9,10,13,14],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [15],
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
		     <th style='width:0px; display: none;'>점검일자</th>
		     <th style='width:0px; display: none;'>점검시간</th>
		     <th style='width:0px; display: none;'>업소명코드</th>
		     <th style='width:0px; display: none;'>업소명코드rev</th>
		     <th style='width:0px; display: none;'>업소명</th>
		     
		     <th style='width:0px; display: none;'>체크문항코드</th>
		     <th style='width:0px; display: none;'>체크문항rev</th>
		     <th style='width:0px; display: none;'>체크문항seq</th>
		     <th style='width:0px; display: none;'>체크아이템코드</th>
		     <th style='width:0px; display: none;'>체크아이템seq</th>
		     <th style='width:0px; display: none;'>체크아이템rev</th>
		     <th>점검항목</th>
		     <th>결과 값</th>
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

    