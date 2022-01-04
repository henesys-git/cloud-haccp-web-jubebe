<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
기술문서목록
 */
	EdmsDoyosaeTableModel TableModel;


	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 

	String[] strColumnHead 	= {"주문번호","문서번호","문서명","등록번호","등록Rev", "파일명", "file_real_name","document_no_rev"};
	int[] colOff 			= { 0, 1, 1, 1,1,1,0,0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S020120Event(this)' "};
	String[] TD_Style		= {"","","","text-align:center;","text-align:center;","","","","",""};  //strColumnHead의 수만큼
	String[] HyperLink		= {"","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"on", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};

	String GV_ORDERNO="", GV_CUSTCODE="", GV_ORDER_DETAIL_SEQ="", GV_LOTNO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	

	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");

	String param =  GV_ORDERNO + "|"  + GV_ORDER_DETAIL_SEQ + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lot_no", GV_LOTNO);
	
	
    TableModel = new EdmsDoyosaeTableModel("M101S020100E124", strColumnHead, jArray);		
 	int ColCount =TableModel.getColumnCount();
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= ColCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S020120";
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id		= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page		= JSPpage;
    String zhtml=makeTableHTML.getHTML();
//     out.println(makeTableHTML.getHTML());
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
    	    order: [[ 0, "desc" ]],
    	    info: false,
//     		String[] strColumnHead 	= {"주문번호","문서번호","문서명","등록번호","등록Rev", "파일명", "file_real_name","document_no_rev"};
//     		int[] colOff 			= { 0, 1, 1, 1,1,1,0,0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
    	    columnDefs: [
                { width: ' 0%',	targets: 0 },
                { width: '10%', targets: 1 },
                { width: '15%',	targets: 2 },
                { width: '20%', targets: 3 },
                { width: ' 8%', targets: 4 },
                { width: '35%', targets: 5 },
                { width: ' 0%', targets: 6 },
                { width: ' 0%', targets: 7 },
                { width: ' 6%', targets: 8 },
                { width: ' 6%', targets: 9 }
                ],         
                language: { 
                    url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
                 }
    	});      	
    });

    function fn_right_btn_view(fileName, obj,view_revision){
    	/* 
    	{"on", "file_view_name", "문서View"} 인경우 이 함수를 반드시 사용한다.
    	 */
    	var tr = $(obj).parent().parent();
		var td = tr.children();

// 		{"주문번호","문서번호","문서명","등록번호","등록Rev", "파일명", "file_real_name"};
		var regist_no 		= td.eq(3).text().trim();
		var regist_no_rev 	= td.eq(4).text().trim();
		var document_no 	= td.eq(1).text().trim();
		var document_no_rev = td.eq(7).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';
		vOrderNo 			= td.eq(0).text().trim();

//      fn_pdf_View(regist_no, regist_no_rev, document_no, fileName, jsp_page, user_id) {
		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);	
    }
    
    function S101S020120Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
    }  
 

</script>

<%=zhtml%>
