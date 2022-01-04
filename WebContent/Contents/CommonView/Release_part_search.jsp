<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
// 	MakeTableHTML makeTableHTML;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 

	String GV_PART_CD,GV_PART_CD_REV;
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M202S120100E194", jArray);
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();
    
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableRelease_part_search";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

 
<script>
	$(document).ready(function () {

		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_part_search_table.jsp", 
            data: "part_cd=" + '<%=GV_PART_CD%>',
            beforeSend: function () {
                $("#Release_part_search_table_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#Release_part_search_table_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
		
		<%if (RowCount>0){%>
			$('#txt_machineno').val('<%=TableModel.getValueAt(0,0).toString().trim()%>');
			$('#txt_part_cd').val('<%=TableModel.getValueAt(0,1).toString().trim()%>');
			$('#txt_part_cd_rev').val('<%=TableModel.getValueAt(0,2).toString().trim()%>');
			$('#txt_part_nm').val('<%=TableModel.getValueAt(0,3).toString().trim()%>');
			$('#txt_rakes').val('<%=TableModel.getValueAt(0,4).toString().trim()%>');
			$('#txt_plate').val('<%=TableModel.getValueAt(0,5).toString().trim()%>');
			$('#txt_colm').val('<%=TableModel.getValueAt(0,6).toString().trim()%>');
			$('#txt_pre_amt').val('<%=TableModel.getValueAt(0,7).toString().trim()%>');
			
			$('#txt_post_amt').val('<%=TableModel.getValueAt(0,8).toString().trim()%>');
			$('#txt_io_amt').val('<%=TableModel.getValueAt(0,9).toString().trim()%>');
			$('#txt_part_loc').val('<%=TableModel.getValueAt(0,10).toString().trim()%>');
			$('#txt_warehousing_date').val('<%=TableModel.getValueAt(0,11).toString().trim()%>');
			$('#txt_expiration_date').val('<%=TableModel.getValueAt(0,12).toString().trim()%>');
			$('#txt_bigo').val('<%=TableModel.getValueAt(0,13).toString().trim()%>');
			$('#txt_member_key').val('<%=TableModel.getValueAt(0,14).toString().trim()%>');
		<%}%>

    	$("#txt_part_cd_serch").keyup(function(key) { 
    		//한글입력 방지
    		var objTarget = key.srcElement || key.target;
    		if(objTarget.type == 'text') {
    			var value = objTarget.value;
    			if(/[ㄱ-ㅎㅏ-ㅡ가-핳]/.test(value)) {
    				alert("한글입력은 불가능합니다."+"\n"+"한/영 키를 눌러서 영문입력으로 전환하세요.");
					// objTarget.value = objTarget.value.replace(/[ㄱ-ㅎㅏ-ㅡ가-핳]/g,'');
					$('#txt_part_cd_serch').val(""); // 입력에러났을경우 빈칸으로 (중복입력방지)
    				return false;
    			}
    		}
    		
	    	$.ajax({
		         type: "POST",
		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_part_search_table.jsp", 
		         data:  "part_cd=" + $(this).val(),
		         beforeSend: function () {		         
		         },
		         
		         success: function (html) {
		        	 html = html.trim();
		        	if(html.length > 0) {
		        		$("#Release_part_search_table_tbody").hide().html(html).fadeIn(100);
			     		
			     		$('#txt_part_cd_serch').val(""); // 바코드 입력후 빈칸으로 (중복입력방지)
		        	} else {
		        		//맞는원부자재이 없을경우
// 		        		alert("바코드에 해당하는 원부자재이 없습니다.");
//	 		        	$("#txt_part_name", parent.document).val("");
//	 		     		$("#txt_part_cd_rev", parent.document).val("");
//	 		     		$("#txt_part_cd", parent.document).val("");
// 	 		        	$('#txt_part_cd_serch').val(""); // 바코드 입력후 빈칸으로 (중복입력방지)
		        	}
		         },
		         error: function (xhr, option, error) {
		        	 
		         }
		     });
	    });
    	
    	$('#txt_part_cd_serch').focus();
    });	

	function part_cd_serch(){

    	$.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_part_search_table.jsp", 
	         data:  "part_cd=" + $("#txt_part_cd_serch").val(),
	         beforeSend: function () {		         
	         },
	         
	         success: function (html) {	
	        	 alert(html);
	         },
	         error: function (xhr, option, error) {

	         }
	     });
	}
	
	function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price) { //원부자재검색 2차팝업창에서 행 클릭했을때
// 		$("#txt_part_cd").val(txt_part_cd);
// 		$("#txt_part_cd_rev").val(txt_part_revision_no);
// 		$("#txt_part_name").val(txt_part_name);
		$("#txt_part_cd_serch").val(txt_part_cd);
		$("#txt_part_cd_serch").keyup();
	}

	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");


		parent.$('#modalReport_nd').hide();
// 		window.close();
	}

	
</script>	

	<table class="table table-striped " style="width: 100%; margin: 0 ; align:left">	
		<tr>
			<td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">원부자재코드</td>
      		<td style="width: 19.5%;  font-weight: 900; font-size:14px; text-align:lef;">
				<input type="hidden" 	class="form-control" id="txt_machineno"></input>
				<input type="hidden" 		class="form-control" id="txt_part_cd" readonly/>
				<input type="hidden" 	class="form-control" id="txt_part_cd_rev"></input>
				
				<input type="text" 	 class="form-control" id="txt_part_cd_serch" style="width: 65%; float: left;"></input>
				
				<button id="btn_Save"  class="btn btn-info"  onclick="pop_fn_PartList_View(1)" style="width: 35%;float: left">원부자재검색</button>
			</td>
        	<td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">원부자재명</td>
      		<td style="width: 19.5%; font-weight: 900; font-size:14px; text-align:left;">
				<input type="text" 	class="form-control" id="txt_part_nm" readonly></input>
				<input type="hidden" 	class="form-control" id="txt_rakes" />
				<input type="hidden" 	class="form-control" id="txt_plate" />
				<input type="hidden" 	class="form-control" id="txt_colm" />
				<input type="hidden" 	class="form-control" id="txt_pre_amt" />
				<input type="hidden" 	class="form-control" id="txt_post_amt" />
				<input type="hidden" 	class="form-control" id="txt_io_amt" />
     		</td>

      		<td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">원부자재위치</td>
      		<td style="width: 19.5%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" 	class="form-control" id="txt_part_loc" readonly></input>
     		</td>
		</tr>      
    	<tr>
      		<td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">입고일자</td>
      		<td style="width: 19.5%; font-weight: 900; font-size:14px; text-align:left;">
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_warehousing_date" class="form-control" readonly/>
           	</td>
           	<td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">유통기한</td>
      		<td style="width: 19.5%; font-weight: 900; font-size:14px; text-align:left;">
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_expiration_date" class="form-control" readonly/>
				<input type="hidden" 	class="form-control" id="txt_bigo" />
				<input type="hidden" 	class="form-control" id="txt_member_key" />
           	</td>
 		</tr> 
	</table>
	<table  class='table table-bordered nowrap table-hover' id="Release_part_search_table_tbody" style="width: 100%">
 		<tbody id="Release_part_search_table_tbody">		
		</tbody>
	</table>

<div id="UserList_pager" class="text-center">

	<button id="btn_Canc"  class="btn btn-info" style="width: 100px">닫기</button>
</div> 
