<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	// 	DoyosaeTableModel TableModel;
	EdmsDoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	int startPageNo = 1;
	
	String[] strColumnHead = {	"구분명"    , "문서이름" 	, "폐기번호"	, "등록번호"	, "개정번호"	,"문서번호"	, "문서개정번호", "파일명" 	, "실파일명" , 
								"외부문서여부" , "외부문서출처" , "폐기사유" 	, "총페이지"	, "관리본여부" 	, "보관여부" 	, "홀딩여부" 	, "delok"	,    "등록사유" ,  
								"폐기여부"	   , "내외구분"	,"구분코드"    };
	int[] colOff =			 {  1		   , 		  1 , 		2	, 		9	,		 1	,		 5	, 		0	,		   1,       0    ,
								0		   ,	0	    ,	0		,	1		,	0		,	0		,	0		,		0	,		  0  ,
								0 	 	   ,	 0      ,0			};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S606S060100Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼 
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "file_view_name", rightbtnDocRevise},
								{"off", "file_real_name", rightbtnDocShow}
							  };

	String GV_DOCGUBUN="", GV_JSPPAGE="";

	if(request.getParameter("DocGubun") != null)
		GV_DOCGUBUN = request.getParameter("DocGubun");

	if(request.getParameter("jspPage") != null)
		GV_JSPPAGE = request.getParameter("jspPage");

	String param = GV_DOCGUBUN + "|" +  member_key;
    TableModel = new EdmsDoyosaeTableModel("M606S060100E104", strColumnHead, param);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS606S060100";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style;
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    makeTableHTML.jsp_page	= JSPpage;
    makeTableHTML.MAX_HEIGHT	= "height:550px";
    zhtml = makeTableHTML.getHTML();
    
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollX: true,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 3, "desc" ]],
    	    info: true,
    	    "dom": '<"top"i>rt<"bottom"flp><"clear">',
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    	 $("#select_DocGubunCode").on("change", function(){
 	    	vDocGubun = $(this).val();
 	    });
    });

	function S606S060100Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vReg_gubun				= td.eq(19).text().trim();
		vDestroy_no 			= td.eq(2).text().trim();
		vRegNo 					= td.eq(3).text().trim();
		vRegNo_rev				= td.eq(4).text().trim();
		vDocNo					= td.eq(5).text().trim();
		vDocNo_rev				= td.eq(6).text().trim();
		vFile_name				= td.eq(7).text().trim();
	}

</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              