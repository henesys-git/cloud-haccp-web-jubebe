<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S101S030180.jsp 
S101S030160.jsp(공정확인표(하단 TAB에서 POP UP으로 뜸))의 목록
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_ORDER_NO="",GV_COLOFF="", GV_PROD_CD="", GV_PID="",GV_PARAM="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("colOff")== null)
		GV_COLOFF="";
	else
		GV_COLOFF = request.getParameter("colOff");
	
	
	if(request.getParameter("pid")== null)
		GV_PID="";
	else
		GV_PID = request.getParameter("pid");
	
	
	if(request.getParameter("param")== null)
		GV_PARAM="";
	else
		GV_PARAM = request.getParameter("param");
 
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	
	String[] strColumnHead 	= {"order_check_no", "주문명", "일련번호", "품번", "품명", "LOT번호", "LOT수량",
			 "QAR", "사양승인원", "규격도면", "작업지도서", "프로그램 Rev", "공정번호", "공정명", "관련부서", "작업표준", 
			 "표준값", "공구", "관리항목", "체크항목유형", "비고","checklist_cd","checklist_seq"};
	int[] colOff 	=  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0};
	String[] TR_Style		= {""," onclick='S101S030180Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	String param= GV_ORDER_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S030100E164", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030180";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
%>

<script type="text/javascript">	
	var SELECT_ON_DATA_Row_Index;
	var vSELECT_ON_DATA;
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vSELECT_ON_DATA = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
// 		    scrollY: 380,
		    scrollCollapse: true,
		    paging: true,
		    lengthMenu: [[5,9,-1], [5,9,"All"]],
		    searching: true,
		    ordering: true,
		    order: [[ 0, "asc" ],[ 12, "asc" ],[ 2, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,3,4,5,6,7,8,9,10,11,21,22],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			SELECT_ON_DATA_Row_Index = vSELECT_ON_DATA
		        .row( this )
		        .index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		$($("input[id='checkbox1']")[SELECT_ON_DATA_Row_Index]).prop("checked", function(){
				if($(this).prop('checked'))
					$(this).attr("checked", false);
				else
					$(this).attr("checked", true);
		    });   
	 		
	 		vSELECT_ON_DATA
	        .row( this )
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color");
		} );
		
		$("input[id='checkboxAll']").on("click", function(){
			if($(this).prop('checked'))
				$("input[id='checkbox1']").attr("checked", true);
			else
				$("input[id='checkbox1']").attr("checked", false);
	    });   
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {

			vSELECT_ON_DATA
	        .row( this )
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );
		
		if(Rowcount > 0){
//         	$('#txt_lastseq').val(Rowcount);
		}
	});

</script>
    <%=zhtml%>       

	