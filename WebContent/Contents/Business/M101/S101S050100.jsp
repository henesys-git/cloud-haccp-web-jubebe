<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	EdmsDoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
	final int PageSize=15; 

	String[] strColumnHead 	= {"등록구분","주문번호","주문명", "제품명", "등록번호","문서코드","문서명","파일명",
			"prod_cd", "prod_rev","order_detail_seq","개정번호","document_no_rev","file_real_name"};
	int[] colOff 			= {0, 1, 1, 1, 1, 1, 1,  1,  0, 0,0,1,0,0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S050100Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {"", "fn_Search(this,docListTable)", "fn_Search(this,docListTable)", "fn_Search(this,docListTable)", "fn_Search(this,docListTable)", "fn_Search(this,docListTable)", 
			"fn_Search(this,docListTable)", "fn_Search(this,docListTable)"}; 
	
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"on", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="";

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

		
	String param =  Fromdate + "|" + Todate + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
	//data query를 위한 객체는 DoyosaeTableModel TableModel; 대신 반드시 EdmsDoyosaeTableModel TableModel;
    TableModel = new EdmsDoyosaeTableModel("M101S030100E504", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S050100";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id		= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page		= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:550px";
    String zhtml=makeTableHTML.getHTML();
%>
<script type="text/javascript">
	var docListTable="";
    $(document).ready(function () {
    	var exportDate = new Date();
        
    	var printCounter = 0;    	 
		docListTable = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
    	    scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    pagingType: "full_numbers",
    	    searching: true,
    	    ordering: true,
    	    order: [[ 1, "asc" ],[ 4, "asc" ]],
    	    keys: true,
    	    info: true,
//     	    dom: 'Bfrtip',
//             buttons: [
//                 {
//                     extend: 'excel',
//                     title: vexeclBottom+exportDate.format("yyyyMMdd_hhmmss"),
//                     messageTop: null,
// 					exportOptions: {
// 			            columns: [1,2,3,4,5,6,7,11]			 
// 			    	}
//                 },
//                 {
//                     extend: 'print',
//                     messageTop: function () {
//                         printCounter++;
     
//                         if ( printCounter === 1 ) {
//                             return 'This is the first time you have printed this document.';
//                         }
//                         else {
//                             return 'You have printed this document '+printCounter+' times';
//                         }
//                     },
//                     messageBottom: null,
// 					exportOptions: {
// 			            columns: [1,2,3,4,5,6,7,11]			 
// 			    	}
//                 }
//             ],			
            language: { 
            	url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
   	    });    

    });

    
    function fn_right_btn_view(fileName, obj,view_revision){
    	/* 
	String[] strColumnHead 	= {"등록구분","주문번호","주문명", "제품명", "등록번호","문서코드","문서명","파일명",
			"prod_cd", "prod_rev","order_detail_seq","regist_no_rev","document_no_rev"};
    	 */
    	var tr = $(obj).parent().parent();
		var td = tr.children();

		var regist_no 		= td.eq(4).text().trim();
		var regist_no_rev 	= td.eq(11).text().trim();
		var document_no 	= td.eq(5).text().trim();
		var document_no_rev = td.eq(12).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';
		vOrderNo 			= td.eq(1).text().trim();
		vOrderDetailSeq		= td.eq(10).text().trim();
		
		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);	
    }
      
    function S101S050100Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
    }
</script>

<%=zhtml%>

    