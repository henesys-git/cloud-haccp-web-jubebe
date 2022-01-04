<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML;
	
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String[] strColumnHead 	= { "prod_doc_no","revision_no","prod_cd","prod_cd_rev","제품명",
								"document_no","document_rev","문서명","reg_gubun","문서구분",
								"등록번호","regist_no_rev","파일명","file_real_name" };
	int[] colOff 			= { 0, 0, 0, 0, 1, 
								0, 0, 1, 0,	1, 
								1, 0, 1, 0 };	
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};

	String GV_PROD_CD="", GV_PROD_CD_REV="", GV_CALLER="";
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	if(GV_CALLER.equals("S909S065102") || GV_CALLER.equals("S909S065103") || GV_CALLER.equals("S909S065122")) {
		RightButton[2][0] = "off"; // 수정&삭제시 행삭제버튼 off
	}

	param =GV_PROD_CD + "|" + GV_PROD_CD_REV + "|";	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROD_CD", GV_PROD_CD);
	jArray.put( "PROD_CD_REV", GV_PROD_CD_REV);

	TableModel = new DoyosaeTableModel("M909S065100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS909S065130";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();
%>

    
<script>
	$(document).ready(function () {
		var columnDefs;
    	if("<%=GV_CALLER%>"=="S909S065101") { 
    		columnDefs = [
        		{
    	       		'targets': [0,1,2,3,5,6,8,11,13],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0%; display: none;'); 
    	          			$(td).parent().attr('id', 'TableS909S065130_rowID'); 
    	       		}
           		},
           		{ 
    	       		'targets': [9],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:8%;'); 
    	       		}
    	    	},
    	    	{ 
    	       		'targets': [4,7,10],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:15%;'); 
    	       		}
    	    	},
    	    	{ 
    	       		'targets': [12],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:40%; word-break:break-all;'); 
    	       		}
    	    	},
           		{
    	       		'targets': [14],
    	       		'createdCell':  function (td) {
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
    	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
    	       		}
    			}
           	];
    	} 
		
		vTableS909S065130 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: true,
    	    'columnDefs': columnDefs,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS909S065130_RowCount = vTableS909S065130.rows().count();
		
		if("<%=GV_CALLER%>"=="S909S065101") { 
			for(var i=0; i<TableS909S065130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS909S065130_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}
		}

		if("<%=GV_CALLER%>"=="S909S065102" || "<%=GV_CALLER%>"=="S909S065103" || "<%=GV_CALLER%>"=="S909S065122") {
// 			if(TableS909S065130_RowCount<1) {
// 				alert("해당 제품의 문서등록건이 없습니다."+"\n"+"제품문서등록을 먼저 해주세요.");
// 				parent.$("#ReportNote").children().remove();
// 	     		parent.$('#modalReport').hide();
// 			}
		}
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S909S065130_Row_index = vTableS909S065130.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS909S065130.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
<%-- 	 	if("<%=GV_CALLER%>"=="S909S065101") { --%>
// 	 			clear_input();
// 	 		}
	 		
			$('#txt_prod_doc_no').val(vTableS909S065130.cell(S909S065130_Row_index, 0).data());
	 		$('#txt_revision_no').val(vTableS909S065130.cell(S909S065130_Row_index, 1).data());
			$('#txt_gubun_code_name').val(vTableS909S065130.cell(S909S065130_Row_index, 9).data());
			$('#txt_reg_gubun').val(vTableS909S065130.cell(S909S065130_Row_index, 8).data());
			$('#txt_regist_no').val(vTableS909S065130.cell(S909S065130_Row_index, 10).data());
			$('#txt_regist_no_rev').val(vTableS909S065130.cell(S909S065130_Row_index, 11).data());
			$('#txt_file_view_name').val(vTableS909S065130.cell(S909S065130_Row_index, 12).data());
			$('#txt_file_real_name').val(vTableS909S065130.cell(S909S065130_Row_index, 13).data());
			$('#txt_document_name').val(vTableS909S065130.cell(S909S065130_Row_index, 7).data());
			$('#txt_document_no').val(vTableS909S065130.cell(S909S065130_Row_index, 5).data());
			$('#txt_document_no_rev').val(vTableS909S065130.cell(S909S065130_Row_index, 6).data());
			
			if("<%=GV_CALLER%>"=="S909S065101") { 
				$('#btn_plus').html("수정");
				S909S065120_Row_index = -1;
				vTableS909S065120.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS909S065130.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
	});
	
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
