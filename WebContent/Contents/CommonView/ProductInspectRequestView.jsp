<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"수입검사요청번호","주문번호", "주문상세번호", "발주번호","검수번호","입고일","인계일","원부자재업체명","cust_cd"};	
	int[]   colOff 			= {10, 0, 25,  20, 10, 10, 10, 10,0};
	String[] TR_Style		= {""," onclick='ImportInspectRequestViewEvent(this)' "};
	String[] TD_Style		= {"","","","","","","","",""};  //strColumnHead의 수만큼 ImportInspectRequestView.jsp
	String[] HyperLink		= {"","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String SEARCH_GIJONG_CODE="", GV_CALLER="",SEARCH_SIZE_CODE="",SEARCH_MYUNSU_CODE="",SEARCH_FOLDING_CODE="",SEARCH_OPTION_CODE="";
	String GV_ORDER_NO="",GV_IMPORT_INSPECT_REQ_NO="";
	
	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	String param = "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M404S010100E124", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableImportInspectRequestView";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
%>
 
<script>
// document.body.onload = function () { window.print();}
	var txt_CustName;
	var caller="";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";	    	    
// 		scrollY: 600,
	    scrollCollapse: true,
	    autoWidth: true,
	    processing: true,
	    paging: true,
	    searching: true,
	    ordering: true,
	    order: [[ 0, "desc" ]],
	    info: true
	    });
		
	});
	
	function ImportInspectRequestViewEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");	
		
		var order_no 				= td.eq(1).text().trim();
		var order_detail_seq 		= td.eq(2).text().trim(); 
		var balju_no 				= td.eq(3).text().trim(); 
		var balju_inspect_no 		= td.eq(4).text().trim(); 
		var import_inspect_req_no 	= td.eq(0).text().trim();
		var ipgoDate 				= td.eq(5).text().trim(); 
		var ingaeDate 				= td.eq(6).text().trim();
		var CustName 				= td.eq(7).text().trim(); 
		var Custcode 				= td.eq(8).text().trim();
		var parm ={
					order_no:order_no,
					order_detail_seq:order_detail_seq, 
					balju_no:balju_no,
					balju_inspect_no:balju_inspect_no,
					import_inspect_req_no:import_inspect_req_no,ipgoDate:ipgoDate,ingaeDate:ingaeDate,CustName:CustName,Custcode:Custcode};

		if(caller=="0"){ //일반 화면에서 부를 때
	 		$("#txt_order_no", parent.document).val(order_no);
	 		$("#txt_order_detail_seq", parent.document).val(order_detail_seq);
	 		$("#txt_balju_no", parent.document).val(balju_no);
	 		$("#txt_balju_inspect_no", parent.document).val(balju_inspect_no);
	 		$("#txt_import_inspect_req_no", parent.document).val(import_inspect_req_no);
	 		$("#txt_CustName", parent.document).val(CustName);
	 		$("#txt_cust_code", parent.document).val(Custcode);
		}
		else if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetIpmtInspectReq(parm);
		}

		parent.$('#modalReport_nd').hide();
// 		window.close();
	}
	

	
</script>	
<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div> 
