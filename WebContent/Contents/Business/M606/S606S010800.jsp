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
	String zhtml = "";
	
	int startPageNo = 1;
// 	final int PageSize=15; 
	String[] strColumnHead 	= {"문서코드", "문서명", "구분코드", "구분명", "파일명","등록번호","Rev","실파일명","외부문서", "등록사유", "파기사유","총페이지", "관리본","보관","보존","등록일", "등록자","document_no_rev"} ;	
	int[]   colOff 			= {0      , 9     , 0       , 8     , 8     , 5      , 5     , 0      , 5     , 5       , 0      , 0    , 5      , 5  , 0   , 0    , 5, 0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S606S010800Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼 
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)"}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"on", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};

	String GV_DOCGUBUN="" , GV_JSPPAGRNAME=""; 

	if(request.getParameter("DocGubun")== null) 
		GV_DOCGUBUN="";
	else
		GV_DOCGUBUN = request.getParameter("DocGubun");
	if(request.getParameter("jspPageName")== null)
		GV_JSPPAGRNAME="";
	else
		GV_JSPPAGRNAME = request.getParameter("jspPageName");

	String param = GV_DOCGUBUN + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	
    TableModel = new EdmsDoyosaeTableModel("M606S010100E804", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS606S010800";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    makeTableHTML.MAX_HEIGHT	= "height:550px";
    zhtml = makeTableHTML.getHTML();
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollX: true,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 5, "desc" ]],
    	    info: true,
    	    columnDefs: [
// {"문서코드", "문서명", "구분코드", "구분명", "파일명","등록번호","Rev","실파일명","외부문서", "등록사유", "파기사유","총페이지", "관리본","보관","보존","등록일", "등록자","document_no_rev"} ;
// {0       , 9      , 0        , 8      , 8      ,  5     , 5     , 0       , 5     , 5       , 0       , 5      , 5      , 5    , 0    , 0     , 5};
            { width: '0%',	targets: 0 },
            { width: '8%', targets: 1 },
            { width: '0%',	targets: 2 },
            { width: '8%', 	targets: 3 },
            { width: '22%', targets: 4 },
            { width: '11%',  targets: 5 },
            { width: '3%',  targets: 6 },
            { width: '0%', 	targets: 7 },
            { width: '6%', 	targets: 8 },
            { width: '6%',  targets:  9 },
            { width: '0%',  targets: 10 },
            { width: '0%', 	targets: 11 },
            { width: '6%',  targets: 12 },
            { width: '6%',  targets: 13 },
            { width: '0%', 	targets: 14 },
            { width: '0%', 	targets: 15 },
            { width: '6%',  targets: 16 },
            { width: '6%',  targets: 17 },
            { width: '6%',  targets: 18 },
            { width: '6%',  targets: 19 }
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

// 		{"문서코드", "문서명", "구분코드", "구분명", "파일명","등록번호","변경번호", "실파일명"  ,"외부문서", "등록사유", "파기사유","총페이지", "관리본","보관","보존","등록일", "등록자","document_no_rev"} ;	
		var regist_no 		= td.eq(5).text().trim();
		var regist_no_rev 	= td.eq(6).text().trim();
		var document_no 	= td.eq(0).text().trim();
		var document_no_rev = td.eq(17).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';

		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);	
    }   
    
	function S606S010800Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		vDocNo = td.eq(1).text().trim(); 
	}
	
    function fn_Clear_varv(){
    	vDocNo = "";
    }
    
    
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              