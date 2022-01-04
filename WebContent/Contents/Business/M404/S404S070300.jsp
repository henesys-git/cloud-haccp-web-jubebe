<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	


	String Fromdate="",Todate="",Custcode ="", GV_PROCESS_STATUS="",GV_INSPECT_GUBUN="",GV_JSPPAGE=""; 

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

	if(request.getParameter("Custcode")== null)
		Custcode="";
	else
		Custcode = request.getParameter("Custcode");	
	
	if(request.getParameter("Process_status")== null)
		GV_PROCESS_STATUS="";
	else
		GV_PROCESS_STATUS = request.getParameter("Process_status");	
	
	if(request.getParameter("InspectGubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("InspectGubun");	
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	String param = Fromdate	+ "|" + Todate	+ "|" + GV_INSPECT_GUBUN + "|" +  GV_JSPPAGE + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "inspect_gubun", GV_INSPECT_GUBUN);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M404S070100E304", jArray);	
 	int RowCount =TableModel.getRowCount();	
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S070300";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    

%>
<script>

$(document).ready(function () {
	var vColumnDefs;
	if("<%=GV_TABLET_NY%>"=="Tablet") { // tablet화면에서 부를때
		vColumnDefs = [{
   			// 제외할 컬럼 숫자 적기(0부터)
			'targets': [1,3,4,5,10,11,13,14,15,17,18,19,20],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
		},
		{
   			// 조회컬럼크기
			'targets': [0,2,6,7,8,9,12,16],
   			'createdCell':  function (td) {
//   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   		}
		];
	} else { // 일반화면에서 부를때
		vColumnDefs = [{
			'targets': [1,3,4,5,10,11,13,14,15,17,18,19,20],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
		},
		{
   			'targets': [0,2,6,7,8,9,12,16],
   			'createdCell':  function (td) {
//   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   		}
		];
	}		
	<%-- $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({ --%>
	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
		scrollX: true,
		scrollY: 450,
	    scrollCollapse: true,
	    paging: false,
	    searching: false,
	    ordering: false,
	    order: [[ 2, "asc" ]],
	    info: false,
	    data: <%=makeGridData.getDataArry()%>,
	    	'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': vColumnDefs, 
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
  		$(obj).attr("class", "hene-bg-color");
  		
  		vOrderNo 			= td.eq(0).text().trim(); 
	 	vLotNo				= td.eq(1).text().trim(); 
	 	vproc_cd 			= td.eq(4).text().trim();
	 	vproc_cd_rev 		= td.eq(5).text().trim();
	 	vgubun_code_name	= td.eq(7).text().trim();
	 	vprod_cd 			= td.eq(11).text().trim();
	 	vprod_cd_rev 		= td.eq(13).text().trim();
	 	product_nm			= td.eq(12).text().trim();
	 	process_nm 			= td.eq(6).text().trim();
	 	proc_info_no		= td.eq(3).text().trim();
	 	inspect_result_dt	= td.eq(9).text().trim();
// 	 	vLotNo				= td.eq(14).text().trim();
	 	project_name		= td.eq(17).text().trim();
	 	lot_count			= td.eq(18).text().trim(); 
	 	product_serial_no	= td.eq(19).text().trim();
	 	vInspectGubun		= td.eq(20).text().trim();
	 	inspect_no			= td.eq(2).text().trim();

	 	vgubun_code 		= td.eq(20).text().trim();
	 	
	 	
	 	vInspectGubun = "";
	 	 
        fn_DetailInfo_List();
	     
  	   
  }

	    
    
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th>검사번호</th>
		     <th style='width:0px; display: none;'>공정정보번호</th>
		     <th style='width:0px; display: none;'>공정코드</th>
		     
		     <th style='width:0px; display: none;'>proc_cd_rev</th>
		     <th>공정명</th>
		     <th>검사구분</th>
		     <th>검사일</th>
		     <th>검사희망일</th>
		     
		     <th style='width:0px; display: none;'>순번</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th>제품명</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th style='width:0px; display: none;'>주문수량</th>
		     
		     <th style='width:0px; display: none;'>납품일</th>
		     <th>특이사항</th>
		     <th style='width:0px; display: none;'>프로젝트명</th>
		     <th style='width:0px; display: none;'>lot_count</th>
		     <th style='width:0px; display: none;'>product_serial_no</th>

		     
		     <th style='width:0px; display: none;'>gubun_code</th>
	     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		     
		<% } else { %>
			<th>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th>검사번호</th>
		     <th style='width:0px; display: none;'>공정정보번호</th>
		     <th style='width:0px; display: none;'>공정코드</th>
		     
		     <th style='width:0px; display: none;'>proc_cd_rev</th>
		     <th>공정명</th>
		     <th>검사구분</th>
		     <th>검사일</th>
		     <th>검사희망일</th>
		     
		     <th style='width:0px; display: none;'>순번</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th>제품명</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th style='width:0px; display: none;'>주문수량</th>
		     
		     <th style='width:0px; display: none;'>납품일</th>
		     <th>특이사항</th>
		     <th style='width:0px; display: none;'>프로젝트명</th>
		     <th style='width:0px; display: none;'>lot_count</th>
		     <th style='width:0px; display: none;'>product_serial_no</th>

		     
		     <th style='width:0px; display: none;'>gubun_code</th>

		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		<% } %>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              