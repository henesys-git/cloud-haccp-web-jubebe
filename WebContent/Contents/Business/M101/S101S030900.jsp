<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
//  EdmsDoyosaeTableModel
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
	final int PageSize=15; 
    
	String[] strColumnHead 	= {"고객사","제품명","PO번호", "제품구분", "원부자재공급방법","주문일","lot번호","lot수량","자재출고일", "rohs", "특이사항","납기일",// 0 ~ 11
			"bom_ver","order_no","현상태명","비고","일련번호","일련번호끝","cust_cd","cust_rev","prod_cd","prod_cd_rev","order_status","project_name","제품구분네임","원부자재공급방법","rohs"}; // 12 ~26
	int[] colOff 			= {1	, 1	, 1		, 0	  , 0	 , 1	 ,  1	,  1   , 1  , 0    , 1	  , 1  , 
			1	, 0	   ,1	, 0	 , 0	  , 0	     , 0	  , 0	 , 0   , 0	  , 0, 0,1,1,1};	
	String[] TR_Style		= {""," onclick='S101S030900Event(this)' "};
// 	String[] TR_Style		= {""};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
// 챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS=""; // , GV_JSPPAGE

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
	
// 	if(request.getParameter("JSPpage")== null)
// 		GV_JSPPAGE="";
// 	else
// 		GV_JSPPAGE = request.getParameter("JSPpage");
		
	String param =  Fromdate + "|" + Todate + "|" + custCode + "|" ; // + GV_JSPPAGE + "|"
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S030100E904", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();


	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S030900";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id		= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page	= JSPpage;
    
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
    	    order: [[ 12, "desc" ]],
    	    keys: true,
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	});
        
		$("#checkboxAll").click(function(){ 			//만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#checkboxAll").prop("checked")) { 	//해당화면에 전체 checkbox들을 체크해준다 
				$("input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우 
			} else {  
				$("input[type=checkbox]").prop("checked",false); 
			} 
		});
		
		fn_Clear_varv();
    });
    
    function S101S030900Event(obj){
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
		
		vCustName   	= td.eq(0).text().trim();
	 	vProduct_name 	= td.eq(1).text().trim(); 
// 		vProject_name 	= td.eq(2).text().trim(); 
		vProduct_Gubun 	= td.eq(3).text().trim();
		vPart_Source	= td.eq(4).text().trim();
	 	vOrderDate 		= td.eq(5).text().trim();
	 	vLotNo			= td.eq(6).text().trim();
		vlot_count		= td.eq(7).text().trim();
		vRohs  			= td.eq(8).text().trim();
		vDeliveryDate 	= td.eq(11).text().trim();
        vOrderNo		= td.eq(13).text().trim(); 
// 		vOrderDetailSeq = td.eq(13).text().trim();
		vProd_serial_no	= td.eq(16).text().trim();
		vProductSerialNoEnd	= td.eq(17).text().trim();
		vCustCode 		= td.eq(18).text().trim();
		vCustRev 		= td.eq(19).text().trim();
		vProd_cd 		= td.eq(20).text().trim();
		vProdRev 		= td.eq(21).text().trim();
		vStatus  		= td.eq(22).text().trim(); 
		vProject_name	= td.eq(23).text().trim();

// 	 	DetailInfo_List.click();

        
    }
    
    function fn_Clear_varv(){
    	vCustName = "";
    	vProduct_name = ""; 
    	vProject_name = "";
    	vLotno = "";
    	vOrderNo = "";
    	vOrderDetailSeq = ""; 
    	vOrderDate = "";
    	vCustCode = "";
    	vProd_serial_no = "";
    	vProd_cd = "";
    	vlot_count = "";
	}

</script>
<!-- <div style="overflow:auto;"> -->
<!-- <div style="overflow:auto; width:800px;height:600px;" class="container"> -->
<%=zhtml%>
<!-- </div> -->