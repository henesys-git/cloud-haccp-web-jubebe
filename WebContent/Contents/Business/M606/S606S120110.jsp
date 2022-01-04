<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	EdmsDoyosaeTableModel TableModel;
// 	DBServletLink dbLink = new DBServletLink();
// 	PagerEntity pagerEntity = new PagerEntity();
// 	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML;String loginID = session.getAttribute("login_id").toString();
	
	int startPageNo = 1;
	
	String[] strColumnHead 	= {"문서코드", "문서명", "문서구분코드", "구분명", "파일명","등록번호","변경번호", "실파일명"  ,"외부문서", "등록사유", "파기사유","총페이지", "관리본여부","보관여부","보존여부","document_no_rev"} ;	
	int[]   colOff 			= {0         , 9      , 0              , 8         , 8       , 5        , 5        , 0           , 0        , 5         , 0         , 5       , 5          , 0        , 0  ,0    };//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S606S040100Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼 
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)"}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "file_real_name", "문서"}};

	String GV_REGNO="" , GV_REVISIONNO=""; 
			
	if(request.getParameter("RegNo")== null) 
		GV_REGNO="";
	else
		GV_REGNO = request.getParameter("RegNo");
	
	if(request.getParameter("RevisionNo")== null)
		GV_REVISIONNO="";
	else
		GV_REVISIONNO = request.getParameter("RevisionNo");

	String param = GV_REGNO + "|" +  GV_REVISIONNO + "|"   ;
    TableModel = new EdmsDoyosaeTableModel("M606S040100E114", strColumnHead, param);	
 	int ColCount =TableModel.getColumnCount();
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= ColCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS606S040110";
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
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

// 		{"문서코드", "문서명", "문서구분코드", "구분명", "파일명","등록번호","변경번호", "실파일명"  ,"외부문서", "등록사유", "파기사유","총페이지", "관리본여부","보관여부","보존여부"} ;	
		var regist_no 		= td.eq(5).text().trim();
		var regist_no_rev 	= td.eq(6).text().trim();
		var document_no 	= td.eq(0).text().trim();
		var document_no_rev 	= td.eq(15).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';

		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);	
    }   
  
    function S606S040110Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");

// 		OrderDetailData.OrderNo = vOrderNo;
// 		OrderDetailData.Gijong 			= td.eq(1).text().trim();;
// 		OrderDetailData.ProductModel 	= td.eq(2).text().trim();

    }  

</script>

<%=zhtml%>
