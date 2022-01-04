<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

	String[] strColumnHead 	= { "주문번호","lotno","생산계획번호","공정정보번호","공정순서",
								"공정코드","공정명","계획공수","계획인력","자주검사", 
								"검사요청","시작예정일","완료예정일","proc_cd_rev","product_serial_no" };
	int[] colOff 			= { 1, 0, 0, 0, 1, 
								1, 1, 1, 1, 1, 
								0, 1, 1, 0, 0 };	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S303S050120TrEvent(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_work_start(this)", "생산시작"}};

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;
	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_LOTNO="", GV_PRODUCT_SERIAL_NO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("product_serial_no")== null)
		GV_PRODUCT_SERIAL_NO="";
	else
		GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
	
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
		
	String param =  GV_ORDERNO + "|"   + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" + GV_PRODUCT_SERIAL_NO + "|" + member_key + "|";
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "product_serial_no", GV_PRODUCT_SERIAL_NO);
	jArray.put( "member_key", member_key);	
	
	TableModel = new DoyosaeTableModel("M303S050100E124", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS303S050120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:250px";
    String zhtml=makeTableHTML.getHTML();
%>

    
<script>
	$(document).ready(function () {
		vTableS303S050120 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
    	    order: [[ 4, "asc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	});

	function S303S050120TrEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-success");

	     vOrderNo			= td.eq(0).text().trim();
// 	     vOrderDetailSeq	= td.eq(1).text().trim(); 

	}


</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
