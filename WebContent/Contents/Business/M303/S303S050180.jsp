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

	String[] strColumnHead 	= { "order_no","order_detail_seq","검사요청번호", "proc_info_no", "proc_cd",
								"proc_cd_rev","공정명","검사구분","요청일", "검사희망일",
								"req_seq","prod_cd","제품명","prod_cd_rev", "lot_no",
								"order_count","납품일","bigo","project_name","lot_count","시리얼번호" };
	int[] colOff 			= { 0, 0, 1, 0, 0,
								0, 1, 1, 1, 1,
								0, 0, 1, 0, 0,
								0, 1, 0, 0, 0, 1 };
	String[] TR_Style		= {""," onclick='S303S050180TrEvent(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_work_start(this)", "생산시작"}};

	String GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="",GV_PROC_CD="",GV_PROC_CD_REV="",GV_LOTNO="", GV_PRODUCT_SERIAL_NO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("proc_cd")== null)
		GV_PROC_CD = "";
	else
		GV_PROC_CD = request.getParameter("proc_cd");	
	
	if(request.getParameter("proc_cd_rev")== null)
		GV_PROC_CD_REV="";
	else
		GV_PROC_CD_REV = request.getParameter("proc_cd_rev");
	
	if(request.getParameter("lotno")== null) 
		GV_LOTNO="";
	else 
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("product_serial_no")== null) 
		GV_PRODUCT_SERIAL_NO="";
	else 
		GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
	
	String param = GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|"
			 	 + GV_PROC_CD + "|" + GV_PROC_CD_REV + "|" 
			 	 + GV_LOTNO + "|" + GV_PRODUCT_SERIAL_NO + "|" + member_key + "|" ;
		
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "proc_cd_rev", GV_PROC_CD_REV);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "product_serial_no", GV_PRODUCT_SERIAL_NO);
	jArray.put( "member_key", member_key);	
	
	TableModel = new DoyosaeTableModel("M303S050100E194", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS303S050180";
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
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	  
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 2, "asc" ],[ 4, "asc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	});

	function S303S050180TrEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-success");
	}

</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
