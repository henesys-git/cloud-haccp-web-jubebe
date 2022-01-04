<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ include file="/strings.jsp" %>
<%
/* 
공정확인표 select_data_with_doyosae.jsp
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_STRCOLUMNHEAD="",GV_COLOFF="", GV_PROD_CD="", GV_PID="",GV_PARAM="";
	
	if(request.getParameter("strColumnHead")== null)
		GV_STRCOLUMNHEAD="";
	else
		GV_STRCOLUMNHEAD = request.getParameter("strColumnHead");
	
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

	String[] strColumnHead 	= Common.split(GV_STRCOLUMNHEAD, "|", true);
	String[] strcolOff		= Common.split(GV_COLOFF, "|", true);
// 	proc_cd, 공정명,	A.checklist_seq,		B.checklist_cd,	B.check_note,	B.standard_guide,	B.standard_value,	C.item_type,	C.item_desc,	C.item_bigo,	A.checklist_cd_rev,A.revision_no
// 	String[] strColumnHead 	= {"공정번호","공정명","순번","관련부서", "체크코드","관리항목","작업표준" ,"표준값", "항목유형","항목명" ,"비고","checklist_cd_rev","A.proc_cd_rev","revision_no"};
	int[]   colOff = new int[strcolOff.length];
	for(int i=0;i<strcolOff.length;i++){
		System.out.println("strcolOff[i] ==="+strcolOff[i]);
		
 		colOff[i] = Integer.parseInt(strcolOff[i]);
	}
	String[] TR_Style		= {""," onclick='" + GV_PID + "Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
		
    TableModel = new DoyosaeTableModel(GV_PID, strColumnHead, GV_PARAM);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= GV_PID;
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
		    order: [[ 0, "asc" ],[ 1, "asc" ],[ 2, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('role',"row");
	  		},
// 	  		'columnDefs': [{
// 	       		'targets': [5,12,13,14],
// 	       		'createdCell':  function (td) {
// 	          			$(td).attr('style', 'width:0px; display: none;'); 
// 	       		}
// 			}],
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

	