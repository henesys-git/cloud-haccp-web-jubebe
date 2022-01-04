<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	MakeTableHTML makeTableHTML;
	String zhtml = "";
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	
// 	String[] strColumnHead = {"주문번호",  "주문상세번호","검사요청번호", "공정정보번호","공정코드","proc_cd_rev", "공정명", "검사구분","요청일", //0~8
// 			"검사희망일","순번", "초품코드",  "제품명", "prod_cd_rev", "주문수량","납품일","특이사항", "프로젝트명","lot_count","초품시리얼번호","gubun_code"}; //9~20
// 	int[]   colOff = {1, 0, 10, 0, 0, 0, 10, 10, 10, 
// 			10, 0, 0, 1, 0, 0,  0,1,0,0,1,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] strColumnHead 	= {"고객사","제품명","PO번호", "제품구분_code", "원부자재공급방법_code","주문일","lot번호","lot수량","자재출고일", "rohs_code", "특이사항","납기일",
			"bom_ver","order_no","현상태명","비고","일련번호","일련번호끝","cust_cd","cust_rev","prod_cd","prod_cd_rev","order_status","제품구분네임","원부자재공급방법","rohs"};
	int[] colOff 			= {1		, 1		, 1			, 0		  , 0			 , 1	  ,  1		,  1	   , 1    		, 0	     , 1	   , 1	  , 
			 1		, 0		   ,1		  , 0	 , 0	    , 0		     , 0	   , 0		  , 0	    , 0			  , 0, 1, 1, 1};	
	String[] TR_Style		= {""," onclick='S404S070100Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)"}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String Fromdate="",Todate="",Custcode ="", GV_PROCESS_STATUS="",GV_INSPECT_GUBUN="",GV_JSPPAGE=""; 

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

	if(request.getParameter("Custcode")== null)
		Custcode="";
	else
		Custcode = request.getParameter("Custcode");	
	
	if(request.getParameter("Process_status")== null)
		GV_PROCESS_STATUS="";
	else
		GV_PROCESS_STATUS = request.getParameter("Process_status");	
	
	if(request.getParameter("InspectGubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("InspectGubun");	
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	String param = Fromdate	+ "|" + Todate	+ "|" + Custcode + "|" +  GV_JSPPAGE + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", Custcode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M404S070100E104", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS404S070100";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    zhtml = makeTableHTML.getHTML();
    
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);
%>
<script>
    $(document).ready(function () {

    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	  
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 5, "desc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	fn_Clear_varv();
    });
    
	function S404S070100Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		
// 	 	vOrderNo 			= td.eq(0).text().trim(); 
// 	 	vLotNo				= td.eq(1).text().trim(); 
// 	 	vproc_cd 			= td.eq(4).text().trim();
// 	 	vproc_cd_rev 		= td.eq(5).text().trim();
// 	 	vgubun_code_name	= td.eq(7).text().trim();
// 	 	vprod_cd 			= td.eq(11).text().trim();
// 	 	vprod_cd_rev 		= td.eq(13).text().trim();
// 	 	product_nm			= td.eq(12).text().trim();
// 	 	process_nm 			= td.eq(6).text().trim();
// 	 	proc_info_no		= td.eq(3).text().trim();
// 	 	inspect_result_dt	= td.eq(9).text().trim();
// 	 	project_name		= td.eq(17).text().trim();
// 	 	lot_count			= td.eq(18).text().trim(); 
// 	 	product_serial_no	= td.eq(19).text().trim();
// 	 	vInspectGubun		= td.eq(20).text().trim();
// 	 	vinspect_req_no		= td.eq(2).text().trim();

// 	 	vgubun_code 		= td.eq(20).text().trim();

        vOrderNo	= td.eq(13).text().trim(); 
		vLotNo 		= td.eq(6).text().trim();
		vLotCount	= td.eq(7).text().trim();
	 	vOrderDate 	= td.eq(5).text().trim();
	 	
		vCustCode 	= td.eq(18).text().trim();
		vCustRev 	= td.eq(19).text().trim();
		vCustName   = td.eq(0).text().trim(); 
		vStatus  	= td.eq(22).text().trim();  
		
		vProdCd 	= td.eq(20).text().trim();
		vProdRev 	= td.eq(21).text().trim();
		vProdNm		= td.eq(1).text().trim();
		
		vDeliveryDate 		= td.eq(11).text().trim();
		vProductSerialNo	= td.eq(16).text().trim();
		vProductSerialNoEnd	= td.eq(17).text().trim();
		
		vProduct_Gubun 		= td.eq(3).text().trim();
		vPart_Source		= td.eq(4).text().trim();
		vRohs  				= td.eq(8).text().trim();
	 	
	 	
	 	
	 	 
        fn_DetailInfo_List();
//         fn_Sub_DetailInfo_List();
	}
	
	function fn_Clear_varv(){
		vOrderNo = "";  
		vLotNo = "";
	}
	    
    
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              