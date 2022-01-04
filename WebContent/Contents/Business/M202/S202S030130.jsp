<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String[] strColumnHead 	= {"창고","렉","선반","칸"};
	int[]   colOff 			= {1,1,1,1};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String param = "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M202S120100E224", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S030130";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
    $(document).ready(function () {
		vTableS202S030130 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
// 		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 3, "asc" ]],
// 		    keys: false,
		    info: false,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			var S202S030130_Row_index = vTableS202S030130.row( this ).index();
			
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S030130.row(this).nodes().to$().attr("class","hene-bg-color");
	
			$('#txt_store_no').val(vTableS202S030130.cell(S202S030130_Row_index, 0).data());	// machineno
			$('#txt_reakes_no').val(vTableS202S030130.cell(S202S030130_Row_index, 1).data());	// rakes
			$('#txt_plate_no').val(vTableS202S030130.cell(S202S030130_Row_index, 2).data());	// plate
			$('#txt_colm_no').val(vTableS202S030130.cell(S202S030130_Row_index, 3).data());		// colm
			
			$('#txt_post_stack').val('0');		// 새 창고를 선택하면 현재재고 0으로
			
			parent.$('#modalReport_nd').hide();
		} );
    });

</script>

    <%=zhtml%>  