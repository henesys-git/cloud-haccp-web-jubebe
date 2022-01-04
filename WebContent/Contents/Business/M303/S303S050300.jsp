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
		
// 	final int PageSize=15; 

	String[] strColumnHead 	= {"업체","제품명","주문명", "LOT No", "납품일자","고객사PO번호","프로젝트수량","주문수량","완납수량", "잔여수량","현황","비고",
			"주문번호","order_detail_seq","order_date","cust_cd","cust_rev","product_serial_no","prod_cd","lot_count","order_status"};
	int[] colOff 			= {1, 1, 1, 0, 1, 0, 0, 0, 0,0,0,0,
			1,0,0,0,0,0,0,0,0,0};
	
	String[] TR_Style		= {""," onclick='S303S050100TrEvent(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE="";

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
	
	if(GV_JSPPAGE.equals("M303S050300.jsp")||GV_JSPPAGE.equals("M303S050400.jsp")){
		colOff[3] = 1; colOff[5] = 1; colOff[6] = 1; 
		colOff[7] = 1; colOff[10] = 1; colOff[11] = 1;   
	}
	
	String param =  Fromdate + "|" + Todate + "|" + custCode + "|" + GV_JSPPAGE + "|" + member_key + "|";
	JSONObject jArray = new JSONObject();
	jArray.put( "login_id", loginID);
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "cust_cd", custCode);
	jArray.put( "jsp_page", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
		
	TableModel = new DoyosaeTableModel("M303S050100E304", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS303S050300";
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
		var vColumnDefs;
		
		if("<%=GV_JSPPAGE%>"=="M303S050100.jsp") {
			vColumnDefs =  [
	            { width: '20%', targets: 0 },
	            { width: '30%', targets: 1 },
	            { width: '20%', targets: 2 },
	            { width: '10%', targets: 3 },
	            { width: '20%', targets: 4 }
	        ];
		}
		
		
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollY: '300px',
    		scrollX:        true,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
    	    order: [[ 12, "desc" ]],
    	    info: false,
    	    columnDefs: vColumnDefs,
    	    fixedColumns:   {
                leftColumns: 0
            },         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }

		});
    	
    	//행클릭시 지정된 전역변수 초기화
    	vOrderNo = "";
	    vOrderDetailSeq = ""; 
	});

	function S303S050100TrEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

	     vOrderNo			= td.eq(12).text().trim();
	     vOrderDetailSeq	= td.eq(13).text().trim(); 
	     vLotNo				= td.eq(3).text().trim();
	     
	     
	     parent.DetailInfo_List.click();
	}

</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
