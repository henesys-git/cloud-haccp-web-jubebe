<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel, TableHead;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="", GV_LOTNO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);

//     TableModel = new DoyosaeTableModel("M202S030100E114", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S020100E165", jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();

    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S020165";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {
    	vTableS202S020165 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 4, "asc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
   			// 조회컬럼크기
			{
	   			'targets': [0,1,2,3,4,7,9,17,19,22,31,32,33,34,35,37],
   				'createdCell':  function (td) {
					$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			}],
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    });
    
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
	}
    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
				<th style='width:0px; display: none;'>API사용자아이디</th>
				<th style='width:0px; display: none;'>API사용자서비스키</th>
				<th style='width:0px; display: none;'>호출유형</th>
				<th style='width:0px; display: none;'>업무유형</th>
				<th style='width:0px; display: none;'>멤버키</th>
				<th>순번</th>
				<th>사업장의 관리번호</th>
				<th style='width:0px; display: none;'>parttype</th>
				<th>지육/정육구분</th>
				<th style='width:0px; display: none;'>반품여부</th> 
				<th>반품여부</th>
				<th>반입일자</th>
				<th>반출처사업자등록번호</th>
				<th>반출처상호</th>
				<th>반출처대표자명</th>
				<th>반출처연락처</th>
				<th>반출처주소</th>
				<th style='width:0px; display: none;'>반출처 유형 </th>
				<th>반출처 유형 </th>
				<th style='width:0px; display: none;'>매입구분</th>
				<th>매입구분</th>
				<th>총중량</th>
				<th style='width:0px; display: none;'>이력/묶음구분명</th>
				<th>이력/묶음구분명</th>
				<th>묶음번호</th>
				<th>이력번호</th>
				<th>도체번호</th>
				<th>부위코드</th>
				<th>부위명</th>
				<th>중량</th>
				<th>등급</th>
				<th style='width:0px; display: none;'>전송시간</th>
				<th style='width:0px; display: none;'>전송여부</th>
				<th style='width:0px; display: none;'>에러여부</th>
				<th style='width:0px; display: none;'>에러내용</th>
				<th style='width:0px; display: none;'>revision_no</th>
				<th>생성일자</th>
				<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              