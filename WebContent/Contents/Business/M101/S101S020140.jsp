<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
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
	
	param =GV_PROD_CD + "|" + GV_PROD_CD_REV + "|";	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel("M101S020100E144", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S020140";
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
		var columnDefs = [
        		{
    	       		'targets': [0,1,2,3,5,6,8,11,13],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0%; display: none;'); 
    	          			$(td).parent().attr('id', 'TableS101S020140_rowID'); 
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
    	
		
		vTableS101S020140 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    
			scrollX: true,
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
		
		TableS101S020140_RowCount = vTableS101S020140.rows().count();
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S101S020140_Row_index = vTableS101S020140.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS101S020140.row(this).nodes().to$().attr("class","hene-bg-color");
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS101S020140.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
	});
	
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
