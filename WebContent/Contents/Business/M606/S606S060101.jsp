<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<!DOCTYPE html>
<%
	EdmsDoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	String GV_JSPPAGE = "" ;
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	//A.regist_no, A.revision_no, A.document_no, B.document_name, B.gubun_code, A.document_no_rev, A.file_view_name, A.file_real_name,
	//external_doc_yn, external_doc_source ,destroy_reason_code, total_page gwanribon_yn, keep_yn, hold_yn, delok_yn, regist_reason_code,
	//destroy_yn, review_action_no, confirm_action_no, modify_reason, A.modify_user_id, A.modify_date
	
	
	int startPageNo = 1;
	String[] strColumnHead = {	"등록번호"    , "개정번호" , "문서번호"	, "문서명"	, "구분코드"	,"문서개정번호" , "파일명"	, "실파일명" , "외부문서여부" , 
								"외부문서출처" , "폐기코드" , "총페이지" , "관리본여부"	, "보관여부" 	, "홀딩여부" 	, "delok" 	, "등록사유"	,    "삭제여부" ,
								"내외구분"    , "채번일"	  ,	"등록자"  };
	int[] colOff =			 {  1		   , 	1	  , 	2	, 		9	,		0	,		 5	, 		1	,		   0,       0    ,
								0		   ,	0	  ,	1		,	1		,	1		,	0		,	0		,		0	,		  0  ,
								0          ,	0	  ,	0		};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style = {"", " onclick='S606S060101Event(this)'"};
	String[] TD_Style = {"align:center;font-weight: bold;"}; //strColumnHead의 수만큼 
	String[] HyperLink = {""}; //strColumnHead의 수만큼
	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow}, {"off", "fn_Doc_Reg()", rightbtnDocSave}, {"off", "file_real_name", rightbtnDocShow}};

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(GV_JSPPAGE+"|"+"DCPROCS"+"|");
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	String param = member_key + "|";
	TableModel = new EdmsDoyosaeTableModel("M606S060100E105", strColumnHead, param);
	int RowCount = TableModel.getRowCount();

	makeTableHTML = new MakeTableHTML(TableModel);
	makeTableHTML.colCount = strColumnHead.length;
	makeTableHTML.pageSize = RowCount;
	makeTableHTML.currentPageNum = startPageNo;
	makeTableHTML.htmlTable_ID = "TableS606S060101";
	makeTableHTML.colOff = colOff;
	makeTableHTML.TR_Style = TR_Style;
	makeTableHTML.TD_Style = TD_Style;
	makeTableHTML.HyperLink = HyperLink;
	makeTableHTML.user_id = loginID;
	makeTableHTML.Check_Box = "false";
	makeTableHTML.RightButton = RightButton;
	makeTableHTML.jsp_page = JSPpage;
	makeTableHTML.MAX_HEIGHT = "height:550px";
	zhtml = makeTableHTML.getHTML();
	
	Vector optCode =  null;
    Vector optName =  null;
    
	Vector DeptCode = (Vector) CommonData.getDistroyReasonAll(member_key);
%>
<script type="text/javascript">

    var M606S060100E101 = {
			PID:  "M606S060100E101",
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	var SQL_Param = {
			excute: "queryProcess",
			stream: "N",
			param: ""
	};

    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		//scrollY: 300,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 3, "desc" ]],
    	    info: true,
    	    columnDefs: [
//     	    	 {	"등록번호0"    , "개정번호1"  , "문서번호2"	 , "문서명3"	  , "구분코드4"  ,"문서개정번호5" , "파일명6"   , "실제 파일명7" , "외부문서여부8" , 
//					"외부문서출처9" , "폐기코드10" , "총페이지11" , "관리본여부12" , "보관여부13" , "홀딩여부14" , "delok15" , "등록사유16"	,    "삭제여부17",
//					"내외구분18"   , "채번일19"	,	"등록자20" };
//				{  1		   , 	1	    , 	2	    , 		9	  ,		 5	   ,	5      , 		1  ,	0	    ,       0     ,
//					0		   ,	0	    ,	1		,	1	      ,	1	  	   ,	0	   ,	0	   ,		0	,		  0   ,
//					0          ,	0	    ,	0		};
                { width: '9%',	targets: 0 },
                { width: '7%', 	targets: 1 },
                { width: '7%',	targets: 2 },
                { width: '9%', 	targets: 3 },
                { width: '0%', targets: 4 },
                { width: '8%', targets: 5 },
                { width: '28%', targets: 6 },
                { width: '0%', 	targets: 7 },
                { width: '0%', 	targets: 8 },
                { width: '0%', 	targets: 9 },
                { width: '0%', targets: 10 },
                { width: '7%', 	targets: 11 },
                { width: '7%',  targets: 12 },
                { width: '7%',  targets: 13 },
                { width: '0%', 	targets: 14 },
                { width: '0%', 	targets: 15 },
                { width: '0%', targets: 16 },
                { width: '0%',  targets: 17 },
                { width: '0%', targets: 18 },
                { width: '0%', targets: 19 },
                { width: '0%', targets: 20 }
                ],
		});
    });
    <%--
    function fn_right_btn_view(fileName, obj,view_revision){
    	/* 
    	{"on", "file_view_name", "문서View"} 인경우 이 함수를 반드시 사용한다.
    	 */
    	var tr = $(obj).parent().parent();
		var td = tr.children();

		//{"등록번호","개정번호","문서번호", "문서명", "구분코드", "파일명", "검토번호","승인번호"} ;	
		var regist_no 		= td.eq(0).text().trim();
		var regist_no_rev 	= td.eq(1).text().trim();
		var document_no 	= td.eq(1).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';

		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);
    }
    --%>
    
    function S606S060101Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success right_btn

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		//{	"등록번호0"    , "개정번호1" , "문서번호2"	, "문서명3"	, "구분코드4"	,"문서개정번호5" , "파일명6"	, "실제 파일명7" , "외부문서여부8" , 
		//	"외부문서출처9" , "폐기코드10" , "총페이지11" , "관리본여부12"	, "보관여부13" 	, "홀딩여부14" 	, "delok15" 	, "등록사유16"	,    "삭제여부17" ,
		//	"내외구분18"    };
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		$("#txt_regist_no").val(td.eq(0).text().trim());
		$("#txt_docment_no").val(td.eq(2).text().trim());
		$("#txt_docment_name").val(td.eq(3).text().trim());
		$("#txt_file_view_name").val(td.eq(6).text().trim());
		
		$("#txt_regist_no_rev").val(td.eq(1).text().trim());
		$("#txt_document_no_rev").val(td.eq(5).text().trim());
		$("#txt_file_view_name").val(td.eq(6).text().trim());
		$("#txt_file_real_name").val(td.eq(7).text().trim());
		$("#txt_external_doc_yn").val(td.eq(8).text().trim());
		$("#txt_external_doc_souce").val(td.eq(9).text().trim());
		//$("#txt_destroy_reason_code").val(td.eq(10).text().trim());
		$("#txt_total_page").val(td.eq(11).text().trim());
		$("#txt_gwanribon").val(td.eq(12).text().trim());
		$("#txt_keep_yn").val(td.eq(13).text().trim());
		$("#txt_hole_yn").val(td.eq(14).text().trim());
		$("#txt_delok_yn").val(td.eq(15).text().trim());
		$("#txt_regist_reason_code").val(td.eq(16).text().trim());
		$("#txt_destroy_yn").val(td.eq(17).text().trim());
		$("#txt_reg_gubun").val(td.eq(18).text().trim());
	
	}
    
    function deleteInfo() {
    	
    	if (confirm("정말 폐기 하시겠습니까?")!=true) {
			return;
		}
    	
    		var parmBody= "" ;
    			
    		   parmBody += '<%=GV_JSPPAGE%>'								+	"|"
    					+ '<%=loginID%>' 					 				+	"|"
    					+ '<%=GV_GET_NUM_PREFIX%>'			 				+	"|"
    					+ $("#txt_regist_no").val()		 					+	"|"
    		   			+ $("#txt_regist_no_rev").val()		 				+	"|"
    		   			+ $("#txt_docment_no").val()	 					+	 "|"
    		   			+ $("#txt_document_no_rev").val()					+	"|"
    		   			+ $("#txt_file_view_name").val()					+	"|"
    		   			+ $("#txt_file_real_name").val()					+	"|"
    		   			+ $("#txt_external_doc_yn").val()					+	"|"
    		   			+ $("#txt_external_doc_souce").val()				+ 	"|"
    		   			+ $("#select_Destroy_code option:selected").val()	+	"|"
    		   			+ $("#txt_total_page").val()		 				+	"|"
    		   			+ $("#txt_gwanribon").val()							+	"|"
    		   			+ $("#txt_keep_yn").val()							+	"|"
    		   			+ $("#txt_hole_yn").val()							+	"|"
    		   			+ $("#txt_delok_yn").val()							+	"|"
    		   			+ $("#txt_regist_reason_code").val()				+	"|"
    		   			+ $("#txt_destroy_yn").val()						+	"|"
    		   			+ $("#txt_reg_gubun").val()							+	"|"
    		   			+ '<%=member_key%>'					 				+	"|"
    					;
    		    	    
    			SendTojsp(urlencode(parmBody), M606S060100E101.PID);
    			}
    	    
    		function SendTojsp(bomdata, pid){
    			//alert(bomdata);
    		    $.ajax({
    		         type: "POST",
    		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp",
    						data : "bomdata=" + bomdata + "&pid=" + pid,
    						beforeSend : function() {
    							//alert(bomdata);
    						},
    						success : function(html) {
    							if (html > -1) {
    								
    								alert("폐기 등록 완료.");
    								
    								parent.fn_MainInfo_List();
    		                 		parent.$("#ReportNote").children().remove();
    		                 		$('#modalReport').modal('hide');
    							}
    						},
    						error : function(xhr, option, error) {
    						}
    					});
    		}
    		
    </script>
    
    <input type="hidden" class="form-control" id="txt_regist_no_rev" name="regist_no_rev"  readonly/>
    <input type="hidden" class="form-control" id="txt_document_no_rev" name="document_no_rev"  readonly/>
    <input type="hidden" class="form-control" id="txt_file_real_name" name="file_real_name"  readonly/>
    <input type="hidden" class="form-control" id="txt_external_doc_yn" name="external_doc_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_external_doc_souce" name="external_doc_souce"  readonly/>
    <input type="hidden" class="form-control" id="txt_destroy_reason_code" name="destroy_reason_code"  readonly/>
    <input type="hidden" class="form-control" id="txt_total_page" name="total_page"  readonly/>
    <input type="hidden" class="form-control" id="txt_gwanribon" name="gwanribon"  readonly/>
    <input type="hidden" class="form-control" id="txt_keep_yn" name="keep_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_hole_yn" name="hole_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_delok_yn" name="dekok_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_regist_reason_code" name="regist_reason_code"  readonly/>
    <input type="hidden" class="form-control" id="txt_destroy_yn" name="destroy_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_reg_gubun" name="reg_gubun"  readonly/>
    
    
<table class="table table-bordered"
	style="width: 100%; margin: 0; align: center;">
	<tr style="vertical-align: middle; background-color: #f4f4f4;">
		<td
			style="font-weight: 900; font-size: 14px; text-align: center; vertical-align: middle">등록번호</td>
		<td
			style="font-weight: 900; font-size: 14px; text-align: center; vertical-align: middle">문서번호</td>
		<td
			style="font-weight: 900; font-size: 14px; text-align: center; vertical-align: middle">문서명</td>
		<td
			style="font-weight: 900; font-size: 14px; text-align: center; vertical-align: middle">파일명</td>
		<td
			style="font-weight: 900; font-size: 14px; text-align: center; vertical-align: middle">폐기사유</td>
	</tr>
	<tr style="vertical-align: middle">
	<td style="text-align: center; vertical-align: middle; margin: 0;">

			<input type="text" class="form-control" id="txt_regist_no"
			readonly></input>
		</td>
		<td style="text-align: center; vertical-align: middle; margin: 0;">

			<input type="text" class="form-control" id="txt_docment_no"
			readonly></input>
		</td>
		<td style="text-align: right; vertical-align: middle; margin: 0;">
			<input type="text" class="form-control" id="txt_docment_name"
			readonly></input>
		</td>
		<td style="text-align: center; vertical-align: middle; margin: 0;">
			<input type="text" class="form-control" id="txt_file_view_name"
			readonly></input>
		</td>
		<td style="text-align:center; vertical-align: middle; ;margin: 0">
	            <select class="form-control" id="select_Destroy_code">
	            <%	optCode =  (Vector)DeptCode.get(0);%>
	            <%	optName =  (Vector)DeptCode.get(1);%>
	               <%for(int i=0; i<optName.size();i++){ %>
	               <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
	               <%} %>
	               </select>
	        </td>
	</tr>
</table>

<div style="width: 100%; text-align: center; clear: both">
	<div id="inspect_Request_body" style="width: 40%; float: left"></div>
	<div id="space_between_table" style="width: 0.5%; float: left">
		<label style="width: 100%;"></label>
	</div>
	<div id="inspect_result_body" style="width: 59.5%; float: left"></div>
</div>

<div style="width: 100%; clear: both">
	<p style="text-align: center;">
		<button id="btn_Save" class="btn btn-info" onclick="deleteInfo();">폐기</button>
		<button id="btn_Canc" class="btn btn-info"
			onclick="$('#modalReport').modal('hide');">취소</button>
	</p>
</div>

<%=zhtml%>