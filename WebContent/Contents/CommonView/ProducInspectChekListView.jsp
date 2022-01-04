<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ include file="/strings.jsp" %>
<%
/* 
OrderProducInspectChekListView.jsp
 */
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;
// 	final int PageSize=15; 

	String[] strColumnHead 	= {"순번","제품코드", "제품명", "체크코드", "체크코드순번", "체크개정", "항목코드", "항목명", "항목순", 
								"항목개정", "표준지침", "문항내용", "표준값", "tag","항목유형","항목비고"} ; 
	int[] colOff 			= {1,0, 10, 1, 0, 0, 1, 0,0, 0,1,1,1,1,1,1};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='OrderProducInspectChekListViewEvent(this)' "};
	String[] TD_Style		= {""};  //strColumnHead의 수만큼
// 	String[] TD_Style		= {"text-align:center;","","","text-align:center;","text-align:center;","text-align:center;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_PROD_CD="", GV_REVISION_NO="";
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

// 	if(request.getParameter("RevisionNo")== null)
// 		GV_REVISION_NO="";
// 	else
// 		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param =   GV_PROD_CD + "|"  ;
		
    TableModel = new DoyosaeTableModel("M909S123100E114", strColumnHead, param);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableM909S123100E114";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:250px";
    String zhtml=makeTableHTML.getHTML();
%>
<script type="text/javascript">

    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	
    		scrollX: true,
    		scrollY: 300,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    	vBomInfoRowCount = "<%=RowCount%>";
    });
    
    function OrderProducInspectChekListViewEvent(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vBomCode	= td.eq(8).text().trim();
		vRevisionNo	= td.eq(9).text().trim();
		vBomListId 	= td.eq(0).text().trim();
		vBomInfoRowCount = "<%=""+RowCount%>";

		// 서브 메뉴를 보여준다.
		// fn_DetailInfo_List();
    }


</script>

<%=zhtml%>

<div id="UserList_pager" class="text-center">
</div>                 
