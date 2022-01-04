<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;
// 	final int PageSize=15; 

	String[] strColumnHead 	= {"공정코드", "공정명", "체크코드", "체크코드순번", "체크개정", "항목코드", "항목명", "항목순", 
								"항목개정", "표준지침", "문항내용", "표준값", "tag","항목유형","항목비고"} ; 
	int[] colOff 			= {0, 10, 1, 0, 0, 1, 0,0, 0,1,1,1,1,1,1};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S909S122110Event(this)' "};
	String[] TD_Style		= {""};  //strColumnHead의 수만큼
// 	String[] TD_Style		= {"text-align:center;","","","text-align:center;","text-align:center;","text-align:center;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_PROC_CD="", GV_REVISION_NO="";
	
	if(request.getParameter("proc_cd")== null)
		GV_PROC_CD="";
	else
		GV_PROC_CD = request.getParameter("proc_cd");

	if(request.getParameter("proc_cd_rev")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("proc_cd_rev");

	String param =   GV_PROC_CD + "|"  + GV_REVISION_NO  + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROC_CD", GV_PROC_CD);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	
// 	System.out.println("String param==" + param);
    TableModel = new DoyosaeTableModel("M909S122100E114", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS909S122110";
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
    		scrollY: 250,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    info: false,
    	    select : true,
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             },
             'drawCallback' :function() {
 	       		for(i=0; i<<%=RowCount%>; i++) {      			       			
 	       			$('input[id=text1]').eq(i).prop("readonly",true);
 	       			$('input[id=checkbox1]').eq(i).prop("disabled",true);
 	       		}
           	}
		});
    	
    	vBomInfoRowCount = "<%=RowCount%>";
    	
    	checklist_cd = "";
    });
    
    function S909S122110Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		proc_cd 		= td.eq(0).text().trim();
		checklist_cd 	=td.eq(2).text().trim();
		check_note 		= td.eq(10).text().trim();
		checklist_seq 	= td.eq(3).text().trim();
		standard_guide	= td.eq(9).text().trim();
		standard_value	= td.eq(11).text().trim();
		item_desc		= td.eq(6).text().trim();
		item_type		= td.eq(13).text().trim();
		item_bigo		= td.eq(14).text().trim();
		// 서브 메뉴를 보여준다.
		// fn_DetailInfo_List();
    }


</script>

<%=zhtml%>

<div id="UserList_pager" class="text-center">
</div>                 
