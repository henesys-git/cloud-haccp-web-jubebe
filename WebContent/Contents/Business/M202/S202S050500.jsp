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
//	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim()); 
// 	final int PageSize=15; 
/* 	
	String[] strColumnHead 	= {"주문번호","order_detail_seq", "발주번호", "cust_cd","원부자재업체", "part_cd","원부자재명", "통과","표준값","측정값","part_cd_rev","cust_cd_rev", "daty"};
	int[] colOff 			= {1,0,1,0,1,0, 1,1,1,1,0,0,0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S202S050500Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {" "}; //strColumnHead의 수만큼
*/
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_Balju_form_button(this)", "발주서"}};;


	String Fromdate="",Todate="",custCode="", cust_cd_rev="", GV_JSPPAGE;

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
	
	if(request.getParameter("cust_cd_rev")== null)
		cust_cd_rev="0";
	else
		cust_cd_rev = request.getParameter("cust_cd_rev");

	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	////////////////////////////////////////////////////
	
	String param =  Fromdate + "|" + Todate + "|" +custCode  + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "custcode_rev", cust_cd_rev);
	jArray.put( "member_key", member_key);	
	
    TableModel = new DoyosaeTableModel("M202S050100E504", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();

 
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S050500";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;

%>
<script>
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
		var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [{
    	       		'targets': [0,1,2,3,5,8],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    });
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
	
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vOrderNo 	= td.eq(0).text().trim();
		vBalju_No	= td.eq(1).text().trim();
		
		parent.DetailInfo_List.click();
		
	}
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
				<th style='width:0px; display: none;'>주문번호</th>
				<th style='width:0px; display: none;'>발주번호</th>
				<th style='width:0px; display: none;'>발주명</th>
				<th style='width:0px; display: none;'>업체코드</th>
				<th>수신인</th>
				<th style='width:0px; display: none;'>업체코드리비전</th>
				<th>발주일</th>
				<th>납기일</th>
				<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              