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
	int startPageNo = 1;
	final int PageSize=15; 
	String[] strColumnHead 	= {"주문번호","제품번호","제품명","주문상세번호","시리얼번호", "주문수량", "LOT NO","Lot수량"};
	int[] colOff 			= { 1, 1, 1, 0,1,1,1,1};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S030110Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", "주문문서"}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_LOTNO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	String param =  GV_ORDERNO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M101S030100E114", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();

	String[] strHeadHead	= {"Head"};
	String paramHead =  GV_ORDERNO + "|" + GV_LOTNO + "|" ;
	
	JSONObject jArrayHead = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	
 	TableHead = new DoyosaeTableModel("M101S030100E999", strHeadHead, jArrayHead);//주문 부속정보 요약

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 OrderTableModel
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S030110";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:550px";
    String zhtml=makeTableHTML.getHTML();
%>
<script type="text/javascript">
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

		<%if(TableHead.getRowCount()>0) %>
			$("#Total_Info").html('<button type="button" class="btn btn-info" ><%=TableHead.getValueAt(0,0).toString()%></button>');
    });
    
    function S101S030110Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 
		
        vOrderNo		= td.eq(0).text().trim(); 
        vOrderDetailSeq	= td.eq(3).text().trim(); 
// 	 	vOrderDate 		= td.eq(2).text().trim();
// 	 	vLdelivDate		= td.eq(3).text().trim();
// 		vCustCode 		= td.eq(4).text().trim(); 
// 		vCustName   	= td.eq(5).text().trim(); 

	    vProd_cd		= td.eq(1).text().trim();
	 	vProduct_name 	= td.eq(2).text().trim();
//         fn_DetailInfo_List();
        
    }

</script>

<%=zhtml%>