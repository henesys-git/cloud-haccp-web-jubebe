<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
// 	DoyosaeTableModel TableModel;
// 	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
// 	int startPageNo = 1;
// 	final int PageSize=15; 

// 	String[] strColumnHead 	= {"고객사","제품명","PO번호", "제품구분", "원부자재공급","주문일","lot번호","lot수량","자재출고일", "rohs","특이사항","납기일",
// 			"bom_version", "주문번호","현상태","비고","product_serial_no","product_serial_no_end","A.cust_cd","A.cust_rev","A.prod_cd","A.prod_rev","Q.order_status"};	
// 	int[] colOff 			= {1		, 1		, 1			, 1		  , 1			 , 1	  ,  1		,  1	   , 1    		, 1	     , 1	   , 1	  , 
// 			 1		, 0		   ,1		  , 0	 , 0	    , 0		     , 0	   , 0		  , 0	    , 0			  , 0};	
// 	String[] TR_Style		= {""," onclick='S101S030800Event(this)' "};
// 	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
// 	String[] HyperLink		= {""}; 
	
	
// 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="";

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
		
	String param =  Fromdate + "|" + Todate + "|" + custCode + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "member_key", member_key);	
//     TableModel = new DoyosaeTableModel("M101S030100E804", strColumnHead, param);	
//  	int RowCount =TableModel.getRowCount();


//  	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
//  	String JSPpage = jspPageName.GetJSP_FileName();
 	
//     makeTableHTML= new MakeTableHTML(TableModel);
//     makeTableHTML.colCount		= strColumnHead.length;
//     makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
//     makeTableHTML.currentPageNum= startPageNo;
//     makeTableHTML.htmlTable_ID	= "TableS101S030800";
//     makeTableHTML.colOff		= colOff;
//     makeTableHTML.TR_Style 		= TR_Style;
//     makeTableHTML.TD_Style 		= TD_Style; 
//     makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
//     makeTableHTML.Check_Box 	= "false";
//     makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
// //     makeTableHTML.MAX_HEIGHT	= "height:550px";
//     String zhtml=makeTableHTML.getHTML();
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	var exportDate = new Date();
        
    	var printCounter = 0;
<%--     	$('#<%=makeTableHTML.htmlTable_ID%>').append('<caption style="caption-side: bottom">' + vexeclBottom + '</caption>'); --%>
    	 
    	$('#TableS101S030800').DataTable({
    		scrollX: true,
    	    scrollY: 500,
    	    scrollCollapse: true,
    	    ordering: true,
    	    order: [[ 13, "desc" ]],
    	    lengthMenu: [[10,15,-1], [10,15,"All"]],
    	    keys: true,
    	    info: true,
    	    paging: true,
    	    searching: true,
   		    processing: true,
			serverSide: true,ajax: {
				 type: "POST",
				 url: '<%=Config.this_SERVER_path%>/Contents/JSON/M101/J101S030800.jsp',
				 data:{ 
					 fromdate:"<%=Fromdate%>", 
					 todate:"<%=Todate%>",
					 "sSearch": function ( d ) {
						 return $("#TableS101S030800_filter input").serialize();
					 }
				 }
			},
			columns: [
                { "data": "고객사" },
                { "data": "제품명" },
                { "data": "PO번호" },
                { "data": "제품구분" },
                { "data": "원부자재공급" },
                { "data": "주문일" },
                { "data": "lot번호" },
                { "data": "lot수량" },
                { "data": "자재출고일" },
                { "data": "rohs" },
                { "data": "특이사항" },
                { "data": "납기일" },
                { "data": "bom_version" },
                { "data": "주문번호" },
                { "data": "현상태" },
                { "data": "비고" },
                { "data": "product_serial_no" },
                { "data": "product_serial_no_end" },
                { "data": "cust_cd" },
                { "data": "cust_rev" },
                { "data": "prod_cd" },
                { "data": "prod_rev" },
                { "data": "order_status" }                		     
            ],
		    'createdRow': function(row) {	
	      		$(row).attr('id',"TableS101S030800_rowID");
	      		$(row).attr('onclick',"S101S030800Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [10,13,16,17,18,19,20,21,22],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],  
    	            
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
		})
    });
    
    function S101S030800Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
		$(TableS101S030800_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");		

		vOrderNo		= td.eq(13).text().trim();
		vLotNo			= td.eq(6).text().trim();
		vProduct_Gubun	= td.eq(3).text().trim();
		vPart_Source	= td.eq(4).text().trim();
		vRoHS			= td.eq(9).text().trim();
		vProdCd			= td.eq(20).text().trim();
		vProdRev		= td.eq(21).text().trim();
		
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030804.jsp?OrderNo=" + vOrderNo 
				+ "&lotno=" + vLotNo + "&Product_Gubun=" + vProduct_Gubun + "&Part_Source=" + vPart_Source + "&RoHS=" + vRoHS
				+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev;
		pop_fn_popUpScr(modalContentUrl, "수주대장 상세 조회", '850px', '1400px');
    }
    
</script>
<table class='table table-bordered nowrap table-hover' id="TableS101S030800" style="width: 100%">
		<thead>
		<tr>
		     <th>고객사</th>
		     <th>제품명</th>
		     <th>PO번호</th>
		     <th>구분</th>
		     <th>원부자재공급</th>
		     <th>주문일</th>
		     <th>lot번호</th>
		     <th>lot수량</th>
		     <th>자재출고일</th>
		     <th>rohs</th>
		     <th style='width:0px; display: none;'>특이사항</th>
		     <th>납기일</th>
		     <th>bom_version</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th>현상태</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>product_serial_no</th>
		     <th style='width:0px; display: none;'>product_serial_no_end</th>
		     <th style='width:0px; display: none;'>cust_cd</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_rev</th>
		     <th style='width:0px; display: none;'>order_status</th>
		</tr>
		</thead>
		<tbody id="tableView_body">		
		</tbody>
	</table>