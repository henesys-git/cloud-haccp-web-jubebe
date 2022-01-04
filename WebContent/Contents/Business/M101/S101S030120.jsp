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
	final int PageSize=15; 

	String[] strColumnHead 	= {"주문번호","문서번호","문서명", "실파일명","파일명","등록번호", "개정번호", "총페이지 수"};
	int[] colOff 			= {10, 1, 24, 0, 10, 8,  8, 0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S030120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", "주문문서"}};

	String GV_ORDER_NO="",GV_JSPPAGE="",GV_ORDERDETAILNO,GV_PRODUCT_NAME,GV_PROD_CD;

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");


	String param = GV_ORDER_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S030100E124", strColumnHead, jArray);
	
 	int RowCount =TableModel.getRowCount();	
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 OrderTableModel
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S030120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
//     out.println(makeTableHTML.getHTML());	
%>
<script type="text/javascript">
    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	
    		scrollX: true,
//     		scrollY: 180,
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

    function S101S030120Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$('#txt_CustName').val(td.eq(3).text().trim());
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 
		
        vOrderNo	= td.eq(6).text().trim();
		vCustCode 	= td.eq(7).text().trim(); 
		vBomNo 	= td.eq(7).text().trim(); 
		
//         fn_DetailInfo_List();
        
    }
</script>
<%=zhtml%>