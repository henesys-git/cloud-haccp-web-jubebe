
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

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");

	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	////////////////////////////////////////////////////
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);	
    TableModel = new DoyosaeTableModel("M202S020100E204", jArray);
 	int RowCount =TableModel.getRowCount();

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S020200";
    
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
    	    order: [[ 13, "desc" ]],
    	    keys: true,
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [1,2,3,4,5,6,8,9,10,12,13,14,15,16,17,18,19],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
   			// 조회컬럼크기
			{
	   			'targets': [21],
   				'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			}],
   			language: { 
   	            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
   	        }
    	});
        
		$("#checkboxAll").click(function(){ 			//만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#checkboxAll").prop("checked")) { 	//해당화면에 전체 checkbox들을 체크해준다 
				$("input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우 
			} else {  
				$("input[type=checkbox]").prop("checked",false); 
			} 
		});
		
		fn_Clear_varv();
    });
    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 
		vCust_cd = td.eq(8).text().trim();
		vCust_cd_rev = td.eq(9).text().trim();
        vOrderNo	= td.eq(2).text().trim(); 
		vLotNo 		= td.eq(3).text().trim();
		vBalju_no	= td.eq(4).text().trim();
		vLotCount	= td.eq(19).text().trim();
		vIpgo_date	= td.eq(20).text().trim();
		DetailInfo_List.click();
        
    }

	function fn_Clear_varv(){
		vCust_cd = "";
		vCust_cd_rev = "";
        vOrderNo	= ""; 
		vLotNo 		= "";
		vBalju_no	= "";
		vLotCount	= "";
		vIpgo_date	= "";
	}

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th>업체</th>
	     	<th style='width:0px; display: none;'>멤버키</th>
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>LOT NO</th>
			<th style='width:0px; display: none;'>발주번호</th>
			<th style='width:0px; display: none;'>발주명</th>
			<th style='width:0px; display: none;'>제품명</th>
			<th>발주일자</th>
			<th style='width:0px; display: none;'>고객코드</th>
			<th style='width:0px; display: none;'>고객코드개정번호</th>
			<th style='width:0px; display: none;'>고객사담당자명</th>
			<th>전화번호</th>
			<th style='width:0px; display: none;'>팩스번호</th>
			<th style='width:0px; display: none;'>발주납기일자</th>
			<th style='width:0px; display: none;'>납품장소</th>
			<th style='width:0px; display: none;'>품질조건내용</th>
			<th style='width:0px; display: none;'>발주처리상태</th>
			<th style='width:0px; display: none;'>검토번호</th>
			<th style='width:0px; display: none;'>승인번호</th>
			<th style='width:0px; display: none;'>주문상세번호</th>
			<th>입고일자</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
