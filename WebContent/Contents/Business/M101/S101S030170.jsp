<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
공정확인표등록 하단의의 공정선택하는 화면
 */
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= {"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};
	int[]   colOff 			= { 1,2,1,1,0,0,0,7,8,8,1};
// 	String[] TR_Style		= {""," onclick='S101S030170Event(this)' "};
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO, GV_ORDER_DETAIL_SEQ,GV_LOTNO;
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");

	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	String param = GV_ORDER_NO + "|"  + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M101S030100E174", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030170";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vTableS101S030170 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 330,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ],[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S101S030170Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [4,5,6],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			},
			{
	       		'targets': [7],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:25%;'); 
	       		}
			}
			],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }	  	
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS101S030170_Row_Index = vTableS101S030170.row( this ).index();
			
			$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			$(this).attr("class", "hene-bg-color");

			$('#txt_checklist_seq').val( vTableS101S030170.cell( TableS101S030170_Row_Index, 0 ).data( ));
			$('#txt_proc_cd').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 1 ).data() );
			$('#txt_process_name').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 2 ).data( ) );
			$('#txt_dept_gubun').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 3 ).data( ) );
			$('#txt_proc_rev').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 4 ).data( ) );
			$('#txt_checklist_cd').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 5 ).data( ) );
			$('#txt_checklist_cd_rev').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 6 ).data( ) );
			$('#txt_standard_guide').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 7 ).data( ) );
			$('#txt_tools').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 8 ).data( ) );
			$('#txt_check_note').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 9 ).data( ) );
			$('#txt_standard_value').val(vTableS101S030170.cell( TableS101S030170_Row_Index, 10 ).data( ) );			
			$('#btn_plus').html("수정");
			
			
		} );

        TableS101S030170_info = vTableS101S030170.page.info();
     	TableS101S030170_Row_Count = TableS101S030170_info.recordsTotal;
		
     	if(Rowcount > 0){
<%-- 			$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color"); --%>
<%-- 			$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "hene-bg-color"); --%>
		}
	});


    
    function S101S030170Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 

// 		$('#txt_proc_cd').val(td.eq(0).text().trim());
// 		$('#txt_process_name').val(td.eq(1).text().trim());
// 		$('#txt_checklist_cd').val(td.eq(2).text().trim());
// 		$('#txt_check_note').val(td.eq(3).text().trim());
// 		$('#txt_standard_guide').val(td.eq(4).text().trim());
// 		$('#txt_standard_value').val(td.eq(5).text().trim());
// 		$('#item_type').val(td.eq(6).text().trim());
// 		$('#item_desc').val(td.eq(7).text().trim());
		
// 		$('#item_bigo').val(td.eq(8).text().trim());
// 		$('#checklist_cd_rev').val(td.eq(9).text().trim());
// 		$('#checklist_seq').val(td.eq(10).text().trim());
// 		$('#proc_cd_rev').val(td.eq(11).text().trim());
// 		$('#revision_no').val(td.eq(12).text().trim());

    }        
</script>

    <%=zhtml%>       

	