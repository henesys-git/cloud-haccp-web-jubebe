<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
DoyosaeTableModel TableModel, TableHead;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	MakeTableHTML makeTableHTML;
	String zhtml = "";
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"주문번호","주문상세번호","불출번호","불출일자","불출일련번호",
								"불출시간","불출담당자","원부자재코드","파트코드개정번호",
								"창고번호","렉번호","선반번호","칸번호","불출전재고량",
								"불출수량","불출후재고량","구분","비고","용도"};
	int[]   colOff 			= {0,0,0,0,1,
							   0,0,1,0,
							   1,1,1,1,1,
							   1,1,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사;//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
		
	
 	String[] TR_Style		= {""," onclick='S202S020110Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
String GV_ORDER_NO="",GV_CHULGO_NO="",GV_PART_CD="",GV_SEQ_NO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");	
	
	if(request.getParameter("ChulNo")== null)
		GV_CHULGO_NO="";
	else
		GV_CHULGO_NO = request.getParameter("ChulNo");
	
	if(request.getParameter("PartCd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("PartCd");
	
	if(request.getParameter("SeqNo")== null)
		GV_SEQ_NO="";
	else
		GV_SEQ_NO = request.getParameter("SeqNo");
	/* if(GV_CALLER.equals("S202S040130")){
		RightButton[2][0] = "off";
	};
	 */
	String param = GV_ORDER_NO + "|" + GV_PART_CD + "|" + GV_CHULGO_NO + "|" + GV_SEQ_NO + "|";
	 
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "chulgo_no", GV_CHULGO_NO);
	jArray.put( "seq_no", GV_SEQ_NO);
	jArray.put( "member_key", member_key);
	 
// 	TableHead.getValueAt(0,0).toString()
//     TableModel = new DoyosaeTableModel("M202S040100E164", strColumnHead, param);	//검수정보를 가져와야 함
    TableModel = new DoyosaeTableModel("M202S040100E164", strColumnHead, jArray);	//검수정보를 가져와야 함
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount 	= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS202S040103";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    zhtml = makeTableHTML.getHTML();
    
    TableModel.getValueAt(0,7).toString().trim();
    TableModel.getValueAt(0,8).toString().trim();
    TableModel.getValueAt(0,9).toString().trim();
    TableModel.getValueAt(0,10).toString().trim();
    TableModel.getValueAt(0,11).toString().trim();
    TableModel.getValueAt(0,12).toString().trim();
    TableModel.getValueAt(0,13).toString().trim();
    TableModel.getValueAt(0,14).toString().trim();
    TableModel.getValueAt(0,15).toString().trim();
//  
%>
<script>
	var SQL_Param = {
			PID:  "M202S040100E103",
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  


    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 1, "asc" ]],
    	    info: false
		});
    });
    
    function SaveOderInfo() {        
		var WebSockData="";
		
		var parmHead= "" 
			+ '<%=GV_ORDER_NO%>' 	+ "|"
			+ '<%=GV_CHULGO_NO%>' 	+ "|"
			+ '<%=GV_PART_CD%>' 	+ "|"
			+ '<%=GV_SEQ_NO%>' 		+ "|"
			+ '<%=TableModel.getValueAt(0,7).toString().trim()%>' + "|"	//4 원부자재코드
	    	+ '<%=TableModel.getValueAt(0,8).toString().trim()%>' + "|"	//5 원부자재개정번호
	    	+ '<%=TableModel.getValueAt(0,9).toString().trim()%>' + "|"	//6 창고번호
	    	+ '<%=TableModel.getValueAt(0,10).toString().trim()%>' + "|"	//7 렉번호
	    	+ '<%=TableModel.getValueAt(0,11).toString().trim()%>' + "|"	//8 선반번호
	    	+ '<%=TableModel.getValueAt(0,12).toString().trim()%>' + "|"	//9 칸번호
	    	+ '<%=TableModel.getValueAt(0,13).toString().trim()%>' + "|"	//0 입고 전 재고량
	    	+ '<%=TableModel.getValueAt(0,14).toString().trim()%>' + "|"	//1 입출고 수량
 	    	+ '<%=TableModel.getValueAt(0,15).toString().trim()%>'+ "|"	//2 입고 후 재고량
			+ '<%=member_key%>'+ "|"	
			+ "<%=Config.HEADTOKEN %>" 	
			;

// 		var parmBody= "" 
// 	   		+ vTableS202S040103.cell(0 , 7).data() + "|"	//0 원부자재코드\
// 	    	+ vTableS202S040103.cell(0 , 8).data() + "|"	//1 원부자재개정번호
// 	    	+ vTableS202S040103.cell(0 , 9).data() + "|"	//2 창고번호
// 	    	+ vTableS202S040103.cell(0 , 10).data() + "|"	//3 렉번호
// 	    	+ vTableS202S040103.cell(0 , 11).data() + "|"	//4 선반번호
// 	    	+ vTableS202S040103.cell(0 , 12).data() + "|"	//5 칸번호
// 	    	+ vTableS202S040103.cell(0 , 13).data() + "|"	//6 입고 전 재고량
// 	    	+ vTableS202S040103.cell(0 , 14).data() + "|"	//7 입고 후 재고량
//  	    	+ vTableS202S040103.cell(0 , 15).data() + "|"	//8 입출고 수량
<%-- 			+ '<%=Config.DATATOKEN %>' 	; --%>
	    
// 			alert(parmHead);
		SQL_Param.params = parmHead;
		//E101
		SendTojsp(urlencode(SQL_Param.params), SQL_Param.PID);
		//E111
		/* SendTojsp(SQL_Param.params, M202S020100E101.UPID);
		 */
	}
    
function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
// 	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         		//SendToStorage(SQL_Param.params, SQL_Param.UPID);
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
    
	function S202S020110Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
// 		vOrderNo 			= td.eq(1).text().trim();
// 		vProd_serial_no	= td.eq(4).text().trim();
// 		vOrderDetailSeq 		= td.eq(11).text().trim();
// 		vOrder_cnt 			= td.eq(17).text().trim();
// 		vCustCode 			= td.eq(12).text().trim();

	}

    
</script>
<p style="text-align:center;">
        	<button id="btn_Save1"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
	        <button id="btn_Canc1"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
		</p>
<%=zhtml%>

<div id="UserList_pager" class="text-center">
		
</div>              