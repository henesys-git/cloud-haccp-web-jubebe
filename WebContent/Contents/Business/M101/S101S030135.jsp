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
S101S030135.jsp 
S101S030160.jsp : 공정확인표(하단 TAB에서 POP UP으로 뜸)의 목록
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_ORDER_NO="", GV_PROD_CD="", GV_LOTNO;
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;

	String[] strColumnHead 	= {"inspect_gubun","검사구분명", "주문번호", "체크번호","주문명", "일련번호","Lot번호",  "Lot수량",
			"품번", "품명", "체크문항코드",	"작업표준", "체크문항내용","표준값", "체크항목유형", "비고",
			"prod_cd_rev", "checklist_seq", "checklist_cd_rev", "item_cd", "item_desc", "item_seq", "item_cd_rev"};
	int[] colOff 	=  {0,1,1, 0,0, 0, 0, 0, 
			 1, 1,  1, 1, 1, 1, 1, 1, 
			0, 0, 0, 0, 0, 0,0};
	String[] TR_Style		= {""," onclick='S101S030135Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);		
    TableModel = new DoyosaeTableModel("M101S030100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030135";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page	= JSPpage;
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
		    lengthMenu: [[8], [8]],
		    searching: true,
		    ordering: true,
		    order: [[ 3, "asc" ],[ 10, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [0,3,4,5,6,7,16,17,18,19,20,21,22],
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

	});

</script>
    <%=zhtml%>       

	