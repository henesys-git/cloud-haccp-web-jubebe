<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel, TableHead;

	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"주문번호","출고번호","번호","출고일자","출고시간","출고담당자","제품코드","제품코드개정번호","창고번호","렉번호","선반번호","칸번호","출고전재고량","출고수량","출고후재고",
			"구분","비고","주문상세번호"};
	int[]   colOff 			= {0,0,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
	
	
 	String[] TR_Style		= {""," onclick='S858S060110Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="",GV_IPGONO="",GV_PROD_CD="",GV_PROD_CD_REV="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");	
	
	
	
	if(request.getParameter("vIpgoNo")== null)
		GV_IPGONO="";
	else
		GV_IPGONO = request.getParameter("vIpgoNo");	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	/* if(GV_CALLER.equals("S858S060130")){
		RightButton[2][0] = "off";
	};
	 */
	String param = GV_ORDER_NO + "|" + GV_PROD_CD + "|"+ GV_PROD_CD_REV + "|";
	 
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	 
	 
// 	TableHead.getValueAt(0,0).toString()
    TableModel = new DoyosaeTableModel("M858S060100E214", strColumnHead, jArray);	//검수정보를 가져와야 함
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount 	= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS858S060200";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
    
    
//  
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
    	    order: [[ 1, "asc" ]],
    	    info: false,
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    });
    
	function S858S060110Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		/* $($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    }); */

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
	  		vOrderNo 			= td.eq(0).text().trim();
	  		vIpgoNo				= td.eq(1).text().trim();
	  		vPartCd				= td.eq(6).text().trim();
	  		vPartCdRev			= td.eq(7).text().trim();
// 		vOrderDetailSeq 		= td.eq(11).text().trim();
// 		vOrder_cnt 			= td.eq(17).text().trim();
// 		vCustCode 			= td.eq(12).text().trim();

	}

    
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              