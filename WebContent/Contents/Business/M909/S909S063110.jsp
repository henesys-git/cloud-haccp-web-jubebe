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

	String[] strColumnHead 	= { "part_cd", "part_cd_rev", "부자재명", "수량", "비고"  } ;

	int[] colOff 			= { 0,  0, 1, 1, 1 };
	String[] TR_Style		= {""," onclick='S909S063110Event(this)' "};
	String[] TD_Style		= {""};	//strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {
							   {"off", "fn_Chart_View", rightbtnChartShow},
							   {"off", "fn_Doc_Reg()", rightbtnDocSave},
							   {"off", "file_real_name", rightbtnDocShow}
							  };
	
	String GV_PROD_CD = "", GV_PROD_CD_REV = "";
	
	if(request.getParameter("prod_cd") == null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev") == null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");

	String param = GV_PROD_CD + "|" + GV_PROD_CD_REV + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("prod_cd", GV_PROD_CD);
	jArray.put("prod_cd_rev", GV_PROD_CD_REV);
		
    TableModel = new DoyosaeTableModel("M909S063100E114", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS909S063110";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
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
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
		});
    	
    	vPartCd = "";
    	vPartCdRev = "";
    });
    
    function S909S063110Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vPartCd = td.eq(0).text().trim();
		vPartCdRev = td.eq(1).text().trim();
    }
</script>

<%=zhtml%>

<div id="UserList_pager" class="text-center">
</div>