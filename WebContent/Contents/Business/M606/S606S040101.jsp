<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
/* 
문서배포등록(S606S040101).jsp
*/
	EdmsDoyosaeTableModel TableModel; 
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	String GV_JSPPAGE = "" ; 
	
	int startPageNo = 1;
	String[] strColumnHead 	= { "구분코드", "문서번호", "문서명","파일명", "배포번호", 
								"등록번호", "개정번호", "dist_date", "due_date", "dist_target",
								"dept_cd", "document_no_rev", "file_real_name"} ;	
	int[]   colOff 			= { 0      , 1       , 1      , 2   ,  0 	, 
								1       , 1      ,  0,  0,  0,
								0,  0,   0};
	String[] TR_Style		= {""," onclick='S606S040101Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼 
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"on", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};
	
	if (request.getParameter("jspPage") == null)
		GV_JSPPAGE = "";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(GV_JSPPAGE+"|"+"DCPROCS"+"|");
	
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	
	TableModel = new EdmsDoyosaeTableModel("M606S040100E105", strColumnHead, jArray); 
	int RowCount =TableModel.getRowCount();
	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS606S040101";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style;
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    makeTableHTML.MAX_HEIGHT	= "height:550px";
    zhtml = makeTableHTML.getHTML();
    
    Vector optCode =  null;
    Vector optName =  null;
    
	Vector DeptCode = (Vector) CommonData.getDeptCodeAll(member_key);
%>

<script type="text/javascript">
	
    $(document).ready(function () {
    	
    	//초기 화면 실행시 버그 방지용
    	vGubun_code ="";///
    	///////////////////
    	
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 400,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 1, "desc" ]],
    	    info: true,
    	    columnDefs: [
//     	    	{"구분코드", "문서번호", "문서명","파일명", "등록번호", "개정번호"} ;	
                { width: '0%',	targets: 0 },
                { width: '10%', 	targets: 1 },
                { width: '10%',	targets: 2 },
                { width: '55%', targets: 3 },
                { width: '10%', targets: 4 },
                { width: '5%', targets: 5 },
                { width: '10%', targets: 6 },
                ],
		});
    	
    	$("#txt_due_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });   	

        var fromday = new Date();
        var today = new Date();
        
        fromday.setDate(today.getDate() +30);
    });	
    
    var vGubun_code ="";
    var vDocument_no = "";
    var vDocument_name = "";
    var vFile_view_name = "";
    var vRegist_no = "";
    var vRevision_no = "";
    
    var vDist_date = "";
    var vDue_date = "";
    var vDist_target = "";
    var vDept_cd = "";
    
    function S606S040101Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		// {"구분코드", "문서번호", "문서이름","파일명", "등록번호", "개정번호"} ;	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vGubun_code		= td.eq(0).text().trim();
		vDocument_no	= td.eq(1).text().trim();
		vDocument_name	= td.eq(2).text().trim();
		vFile_view_name = td.eq(3).text().trim();
		vRegist_no		= td.eq(5).text().trim();
		vRevision_no	= td.eq(6).text().trim();
		
		$("#txt_docment_no").val(vDocument_no);
		$("#txt_docment_name").val(vDocument_name);
		$("#txt_file_name").val(vFile_view_name);
	}
    
	function SavedistInfo() {
        
    	if(vGubun_code.length < 1){
    		alert("문서를 선택하여 주세요.");
    		return;
    	}
    	if($("#txt_due_date").val() == ""){
    		alert("배포유효기간을 선택하여 주세요.");
    		return;
    	}
		
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;
		
		var parmBody= "" ;
		
	    parmBody +=  '<%=GV_JSPPAGE%>'			 						+	"|"
					+ '<%=loginID%>' 			 						+	"|"
					+ '<%=GV_GET_NUM_PREFIX%>'	 						+	"|"
					+ vGubun_code				 						+	"|"	//구분코드
	    			+ vDocument_no		 		 						+	"|" //문서번호
	    			+ vFile_view_name	 	 	 						+ 	"|" //파일 이름
	    			+ vRegist_no		 	 	 						+	"|" //등록번호
	    			+ vRevision_no				 						+	"|" //개정번호
	    			+ $("#txt_due_date").val()	 						+	"|"	//유효기간
					+ $("#txt_dist_target").val()						+	"|" //배포대상 (주로 협력사 측으로)
					+ $("#select_DeptCode option:selected").val()		+	"|"	//배포한 부서
					+ '<%=member_key%>' 			 					+	"|"
					;
					
		SendTojsp(urlencode(parmBody), "M606S040100E101");
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp",
					data : "bomdata=" + bomdata + "&pid=" + pid,
					success : function(html) {
						if (html > -1) {
	                 		$('#modalReport').modal('hide');
							parent.fn_MainInfo_List();
							heneSwal.success("등록 되었습니다");
						} else {
							heneSwal.error("등록 실패했습니다, 다시 시도해주세요")
						}
					}
				});
	}
</script>
	<table class="table table-bordered" style="width: 100%; margin: 0 ; align:center">
	
		<tr style="vertical-align: middle; background-color: #f4f4f4">
			<td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">문서번호</td>
	        <td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">문서명</td>
	        <td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">파일명</td>
	        <td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">배포유효기간</td>
	        <td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">배포대상</td>
	        <td style="font-weight: 900; font-size:14px;  text-align:center; vertical-align: middle">배포부서</td>
		</tr>
		
		<tr style="vertical-align: middle;  clear:both" >
		
			<td style="text-align:center; vertical-align: middle ;margin: 0">
	        	<input type="text" class="form-control" id="txt_docment_no" readonly></input>
			</td>
			<td style="text-align:center;vertical-align: middle ;margin: 0 ">
				<input type="text" class="form-control" id="txt_docment_name" readonly></input>
           	</td>
        	<td style="text-align:center; vertical-align: middle ;margin: 0 ">
				<input type="text" class="form-control" id="txt_file_name" readonly></input>
			</td>
			<td style="text-align:center; vertical-align: middle ;margin: 0 ">
                <input type="text" data-date-format="yyyy-mm-dd" id="txt_due_date" class="form-control" style=" border: solid 1px #cccccc;" readonly="readonly"/>
            </td>
	        <td style="text-align:center; vertical-align: middle ;margin: 0 ">
				<input type="text" class="form-control" id="txt_dist_target"></input>
			</td>
			<td style="text-align:center; vertical-align: middle; ;margin: 0">
	            <select class="form-control" id="select_DeptCode">
	            <%	optCode =  (Vector)DeptCode.get(0);%>
	            <%	optName =  (Vector)DeptCode.get(1);%>
	               <%for(int i=0; i<optName.size();i++){ %>
	               <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
	               <%} %>
	               </select>
	        </td>
	    </tr>
	</table>
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_Request_body" style="width:40%; float:left"></div>
		<div id="space_between_table" style="width:0.5%; float:left" >
			<label style="width:100%;"></label>
		</div>
		<div id="inspect_result_body" style="width:59.5%; float:left"></div>
	</div>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SavedistInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="$('#modalReport').modal('hide');">취소</button>
        </p>
	</div>
	
	<%=zhtml%>
	