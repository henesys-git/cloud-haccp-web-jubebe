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
	
	String[] strColumnHead = {	"구분명"    , "문서이름" 	, "폐기번호"	, "등록번호"	, "개정번호"	,"문서번호"	, "문서개정번호", "파일명" 	, "실제 파일명" , 
								"외부문서여부" , "외부문서출처" , "폐기사유" 	, "총페이지"	, "관리본여부" 	, "보관여부" 	, "홀딩여부" 	, "delok"	,    "등록사유" ,  
								"폐기여부"	   , "내외구분"	,"구분코드"    };
	int[] colOff =			 {  1		   , 		  1 , 		2	, 		9	,		 0	,		 5	, 		0	,		   1,       0    ,
								0		   ,	0	    ,	0		,	1		,	0		,	0		,	0		,		0	,		  0  ,
								0 	 	   ,	 0      ,0			};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S606S060800Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼 
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};

	String GV_DOCGUBUN="" , GV_JSPPAGE="";

	if(request.getParameter("DocGubun")== null)
		GV_DOCGUBUN="";
	else
		GV_DOCGUBUN = request.getParameter("DocGubun");
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	String param = GV_DOCGUBUN + "|" +  member_key + "|"   ;
    TableModel = new EdmsDoyosaeTableModel("M606S060100E804", strColumnHead, param);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS606S060800";
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
    
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollX: true,
    		//scrollY: 300,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 3, "desc" ]],
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    	 $("#select_DocGubunCode").on("change", function(){
 	    	vDocGubun = $(this).val();
 	    	//alert(vDocGubun);
 	        //fn_CheckBox_Chaned();
 	    });
    	
    });
    
    function fn_right_btn_view(fileName, obj,view_revision){
    	/*
    	{"on", "file_view_name", "문서View"} 인경우 이 함수를 반드시 사용한다.
    	 */
    	var tr = $(obj).parent().parent();
		var td = tr.children();
		//{	"구분명"    , "문서이름" 	, "폐기번호"	, "등록번호"	, "개정번호"	,"문서번호"	, "문서개정번호", "파일명" 	, "실제 파일명" , 
		//"외부문서여부" , "외부문서출처" , "폐기사유" 	, "총페이지"	, "관리본여부" 	, "보관여부" 	, "홀딩여부" 	, "delok"	,    "등록사유" ,  
		//"폐기여부"	   , "내외구분"	,"구분코드"    };
		
		var regist_no 		= td.eq(3).text().trim();
		var regist_no_rev 	= td.eq(4).text().trim();
		var document_no 	= td.eq(5).text().trim();
		var document_no_rev 	= td.eq(6).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';

		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);
    }
    
    //등록문서정보
    function fn_MainInfo_List() {
	
        if(vDocGubun=="ALL")
        	vDocGubun="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060800.jsp",
            data: "DocGubun=" + vDocGubun + "&jspPageName=" + "<%=JSPpage%>" ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

        
	function S606S060800Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		//{	"구분명0"    , "문서이름1" 	, "파기번호2"	, "등록번호3"	, "개정번호4"	,"문서번호5"	, "문서개정번호6", "파일명7" 	, "실제 파일명8" , 
		//	"외부문서여부9" , "외부문서출처10" , "폐기사유11" 	, "총페이지12"	, "관리본여부13" 	, "보관여부14" 	, "홀딩여부15" 	, "delok16"	,    "등록사유17" ,  
		//	"폐기여부18"	   , "구분코드19"  };
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		//탭 화면 주석처리
       //fn_DetailInfo_List();
	}

</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              