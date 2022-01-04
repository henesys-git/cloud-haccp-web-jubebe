<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String  GV_JSPPAGE="",GV_ORDER_NO="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_CD_REV="" ;

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else 
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	
	int startPageNo = 1;
	
	String[] strColumnHead 	= { "order_no","Lot No.","proc_plan_no","start_dt(head)","end_dt(head)",
								"production_status","공정정보번호", "공정순서","공정코드","proc_cd_rev",
								"공정명","계획공수","계획인력","prod_procesing_status","제품공정상태",
								"시작예정일","완료예정일" };
	int[] colOff 			= { 0, 1, 0, 0, 0, 
								0, 0, 1, 1, 0, 
								1, 1, 1, 0, 1, 
								1, 1 };
	String[] TR_Style		= {""," onclick='S303S050122TrEvent(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "pop_fn_work_result_Insert(this,1)", "실적등록"},{"off", "fn_work_complete(this)", "현 공정완료"}};
	
	String param =  GV_ORDER_NO + "|" + GV_LOTNO + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M303S050100E164", strColumnHead, jArray);
	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS303S050122";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:250px";
    String zhtml=makeTableHTML.getHTML();
    
    
			
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S050100E122 = {
			PID:  "M303S050100E122", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S050100E122", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

	var vTableS303S050122;
	
    $(document).ready(function () {
    	vTableS303S050122 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 3, "asc" ],[ 9, "asc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
        
    	$("#txt_order_no").val(vTableS303S050122.cell(0,0).data());
    	$("#txt_lotno").val(vTableS303S050122.cell(0,1).data());
    	$("#txt_proc_plan_no").val(vTableS303S050122.cell(0,2).data());
    	$("#txt_start_dt").val(vTableS303S050122.cell(0,3).data());
    	$("#txt_end_dt").val(vTableS303S050122.cell(0,4).data());
    	$("#txt_production_status").val(vTableS303S050122.cell(0,5).data());
	});
    
    function S303S050122TrEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
	}
	
    function SaveOderInfo() {        
		var chekrtn = confirm("완료하시겠습니까?"); 
		if(chekrtn){
			var rowCount = vTableS303S050122.rows().count();
			var STUS103_count=0;
			for(i=0;i<rowCount;i++) {
				if(vTableS303S050122.cell(i,13).data().trim()=="STUS103") STUS103_count++;
			}
			if(STUS103_count < rowCount){
				alert("모든공정이 생산완료 상태일 때만 등록할수 있습니다." + "\n"
						+ "공정개수 : " + rowCount + ", 생산완료 : " + STUS103_count);
				return;
			} else if(STUS103_count == rowCount){
				var parmHead= '<%=Config.HEADTOKEN %>' ;
				parmHead += '<%=GV_JSPPAGE%>'			+ "|"
					 	 + '<%=loginID%>'				+ "|"	
				 		 + '<%=GV_ORDER_NO%>'			+ "|"
<%-- 				 		 + '<%=GV_ORDER_DETAIL_SEQ%>'	+ "|"	//주문상세번호 --%>
				 		 + '0'							+ "|"	//주문상세번호
				  		 + '0' 							+ "|" 	//indGB
				  		 + $("#txt_order_no").val()			+ "|" 	//order_no
				  		 + '<%=GV_LOTNO%>'					+ "|"	//lotno
				  		 + $("#txt_proc_plan_no").val()		+ "|" 	//proc_plan_no
				  		 + '<%=member_key%>' + "|"	
				  		;
				parmHead += '<%=Config.DATATOKEN %>' 	;

				SQL_Param.param = parmHead ;
				
				SendTojsp(urlencode(SQL_Param.param), SQL_Param.PID);
			}
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		// 초기화
	 				vOrderNo = "";
					vOrderDetailSeq = ""; 
					parent.fn_MainInfo_List();
					$("#SubInfo_List_contents").html("");
					// 팝업창닫기
					parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    </script>
   
	<div style="width:100%; clear:both;">
		<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
			<tr style="background-color: #fff;">
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">주문번호</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_order_no" readonly/>
				</td>
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">공정계획번호</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_proc_plan_no" readonly/>
				</td>
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">Lot No</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lotno" readonly/>
				</td>
			</tr>
			<tr style="background-color: #fff;">
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">총 공정시작예정일</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_start_dt" readonly/>
				</td>
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">총 공정완료예정일</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_end_dt" readonly/>
				</td>
				<td style="width: 13.33%; font-weight: 900; font-size:14px; text-align:left">제품상태</td>
				<td style="width: 20%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_production_status" readonly/>
				</td>
			</tr>
		</table>
    </div>
	<%=zhtml%>
	<div style="width:100%; clear:both;">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">등록완료</button>
            <button id="btn_Canc1"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	
