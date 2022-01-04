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
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
	final int PageSize=15; 

    String zhtml="";
    String[] strColumnHead 	= {"업체","제품명","주문명", "LOT No", "납품일자","고객사PO번호","프로젝트수량","LOT수량","완납수량", "잔여수량","현황","비고", // 0~11
			"order_no","order_detail_seq","order_date","cust_cd","cust_rev","product_serial_no","prod_cd","LOT 수량","order_status"};
	int[] colOff 			= {1, 1, 1, 1, 1, 1,  0,  1, 1,1,1,1,
			0,0,0,0,0,0,0,1,0};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S040100Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
// 챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"OFF", "file_view_name", "문서View"}};

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="" ,jspPageName="";

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
	custCode="";
		else
	custCode = request.getParameter("custcode");

	if(request.getParameter("jspPageName")== null)
		jspPageName="";
	else
		jspPageName = request.getParameter("jspPageName");
	
	String param =  Fromdate + "|" + Todate + "|" + custCode + "|" + jspPageName + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", jspPageName);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel("M101S040100E104", strColumnHead, jArray);	
    
 	int RowCount =TableModel.getRowCount();


    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S040100";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page	= jspPageName;	
	
//     if(RowCount>0){
    	zhtml = makeTableHTML.getHTML();
//     }
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
    	
    	fn_Clear_varv();
    });
    
    function S101S040100Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$('#txt_CustName').val(td.eq(0).text().trim());
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

        vOrderNo	= td.eq(12).text().trim(); 
		vOrderDetailSeq = td.eq(13).text().trim();
	 	vOrderDate 	= td.eq(14).text().trim();
		vCustCode 	= td.eq(15).text().trim(); 
		vCustName   = td.eq(0).text().trim(); 
		vStatus  	= td.eq(20).text().trim();  
		vLotNo 		= td.eq(3).text().trim();

		DetailInfo_List.click();
        
    }
    
    function fn_Clear_varv(){
		vOrderNo 			= "";
		vProd_serial_no	= "";
		vOrderDetailSeq 		= "";
		vOrder_cnt 			= "";
		vCustCode 			= "";
//			vGIJONG_CODE 		= "";
// 		$('#txt_custcode').val("");
    }

</script>

<%=zhtml%>

				                 
