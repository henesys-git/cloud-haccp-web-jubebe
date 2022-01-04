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
	
	int startPageNo = 1;

	String[] strColumnHead 	= { "reg_gubun","document_no","document_no_rev","문서명","gubun_code",
								"문서구분","파일명","file_real_name","등록번호","Rev(개정)",
								"external_doc_yn","등록사유","destroy_reason_code","total_page","gwanribon_yn",
								"keep_yn","hold_yn","등록일자","등록자" };
	int[] colOff 			= { 0, 0, 0, 1, 0, 
								1, 1, 0, 1,	0, 
								0, 0, 0, 0,	0, 
								0, 0, 0, 0 };
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_PROD_CD="", GV_PROD_CD_REV="" ;
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	String param =  GV_PROD_CD + "|" + GV_PROD_CD_REV  + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROD_CD", GV_PROD_CD);
	jArray.put( "PROD_CD_REV", GV_PROD_CD_REV);
		
    TableModel = new DoyosaeTableModel("M909S065100E124", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS909S065120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "true";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();
%>
    
<script>
	$(document).ready(function () {
		vTableS909S065120 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 9, "asc" ]],
    	    info: true, 
    	    'columnDefs': [
    	    	{ 
    	       		'targets': [1, 2, 3, 5, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0%; display: none;'); 
    	       		}
    	    	},
    	    	{ 
    	       		'targets': [0],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:5%;'); 
    	       		}
    	    	},
    	    	{ 
    	       		'targets': [4, 6, 9],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:15%;'); 
    	       		}
    	    	},
    	    	{ 
    	       		'targets': [7],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:50%; word-break:break-all;'); 
    	       		}
    	    	}
	        ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS909S065120_RowCount = vTableS909S065120.rows().count();
		
		for(var i=0; i<TableS909S065120_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
			var regist_no_120 = vTableS909S065120.cell( i, 9).data().trim();
			for(var j=0; j<TableS909S065130_RowCount; j++) {
				var regist_no_130 = vTableS909S065130.cell( j, 10).data().trim();
// 				alert("TableS909S065120_RowCount="+TableS909S065120_RowCount+"\n"+"regist_no_120="+regist_no_120+"\n"+"regist_no_130="+regist_no_130);
				if(regist_no_120==regist_no_130) {
// 					alert("regist_no="+regist_no_120+"\n"+"레코드제거");
					vTableS909S065120.row(i).remove();
					TableS909S065120_RowCount = vTableS909S065120.page.info().recordsTotal; //행제거하면 rowcount 다시계산
					i--; //행제거하면 index-1
				}
			}
 		}
		
    	$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
    		S909S065120_Row_index = vTableS909S065120.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS909S065120.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
// 	 		clear_input();

			vTableS909S065120.cell(S909S065120_Row_index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
		    });

	 		$('#txt_gubun_code_name').val(vTableS909S065120.cell(S909S065120_Row_index, 6).data());
			$('#txt_reg_gubun').val(vTableS909S065120.cell(S909S065120_Row_index, 1).data());
			$('#txt_regist_no').val(vTableS909S065120.cell(S909S065120_Row_index, 9).data());
			$('#txt_regist_no_rev').val(vTableS909S065120.cell(S909S065120_Row_index, 10).data());
			$('#txt_file_view_name').val(vTableS909S065120.cell(S909S065120_Row_index, 7).data());
			$('#txt_file_real_name').val(vTableS909S065120.cell(S909S065120_Row_index, 8).data());
			$('#txt_document_name').val(vTableS909S065120.cell(S909S065120_Row_index, 4).data());
			$('#txt_document_no').val(vTableS909S065120.cell(S909S065120_Row_index, 2).data());
			$('#txt_document_no_rev').val(vTableS909S065120.cell(S909S065120_Row_index, 3).data());
			
			$('#btn_plus').html("입력");
			S909S065130_Row_index = -1;
			vTableS909S065130.rows().nodes().to$().attr("class", "hene-bg-color_w");
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS909S065130.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
		$("#<%=makeTableHTML.htmlTable_ID%> input[id='checkbox1']").on("click",function(){
			if($(this).prop('checked'))
				$(this).prop("checked", false);
			else
				$(this).prop("checked", true);
    	});
		
		$("#<%=makeTableHTML.htmlTable_ID%>"+" "+"input[id='checkboxAll']").on("click", function(){
			var table_info = vTableS909S065120.page.info();
	        var table_rows = table_info.recordsTotal;
	    	for(var i=0;i<table_rows;i++){  
	    		vTableS909S065120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
	    	}
	    });  
	});

</script>

<%=zhtml%>

