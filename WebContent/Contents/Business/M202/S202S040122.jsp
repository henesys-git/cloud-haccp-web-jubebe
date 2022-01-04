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
	
	String[] strColumnHead 	= {"주문번호","제품명", "원부자재코드","원부자재명", "요청일자","불출희망일","요청수량", "요청자","불출"};
	int[] colOff 			= {1,1,1,1, 1,1,1,1,1};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	
 	String[] TR_Style		= {""," onclick='S202S020122Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDERNO="",GV_PART_CD="",GV_PART_CD_REV="";
// 	GV_IPGONO="",
	if(request.getParameter("part_cd")== null)
		GV_PART_CD = "";
	else
		GV_PART_CD = request.getParameter("part_cd");
	
	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV = "";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");

	
	
// 	if(request.getParameter("IpgoNo")== null)
// 		GV_IPGONO = "";
// 	else
// 		GV_IPGONO = request.getParameter("IpgoNo");  + GV_IPGONO +

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	
	
	
	/* if(GV_CALLER.equals("S202S030130")){
		RightButton[2][0] = "off";
	};
	 */
	String param = GV_ORDERNO + "|" + GV_PART_CD + "|";
	 
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "member_key", member_key);
	 
// 	TableHead.getValueAt(0,0).toString()
//     TableModel = new DoyosaeTableModel("M202S040100E164", strColumnHead, param);	//검수정보를 가져와야 함
    TableModel = new DoyosaeTableModel("M202S040100E164", strColumnHead, jArray);	//검수정보를 가져와야 함
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount 	= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS202S040122";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    zhtml = makeTableHTML.getHTML();
    
    
//  
%>
<script>
	var SQL_Param = {
			PID:  "M202S040100E122",
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
			+ '<%=GV_ORDERNO%>' 				+ "|"
			+ '<%=GV_PART_CD%>' 				+ "|" 
			+ '<%=member_key%>'	 				+ "|"
			+ '<%=Config.HEADTOKEN %>' 
			;

		
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
	        		parent.fn_MainInfo_List();
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
    
	function S202S030122Event(obj){
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

<%=zhtml%>
<p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
	        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
</p>
<div id="UserList_pager" class="text-center">

</div>              