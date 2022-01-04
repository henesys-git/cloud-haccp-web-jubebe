<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	EdmsDoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
		
	String GV_DOCGUBUN="", GV_JSPPAGE="", GV_DOC_NO="";

	if(request.getParameter("DocGubun") != null)
		GV_DOCGUBUN = request.getParameter("DocGubun");
	
	if(request.getParameter("DocNo") != null)
		GV_DOC_NO = request.getParameter("DocNo");
	
	if(request.getParameter("jspPage") != null)
		GV_JSPPAGE = request.getParameter("jspPage");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("document_no", GV_DOC_NO);
 	jArray.put("gubun_code", GV_DOCGUBUN);
	
    TableModel = new EdmsDoyosaeTableModel("M838S010100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);

	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Del(this)", "버튼"},
								{"off", "file_view_name", rightbtnDocRevise},
								{"on", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS838S010100";
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""};
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArry()%>,
				columnDefs : [{
					'targets': [0,1,2,3,8,9,11,12,13,14,15,18],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				pageLength: 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    });

    function fn_right_btn_view(fileName, view_revision) {
    	var url = "<%=Config.this_SERVER_path%>/docDisplay?filePath=" + fileName;
    	window.open(url);
    }
       
   	function clickMainMenu(obj){
       	var tr = $(obj);
   		var td = tr.children();
   		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
   		
   		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
   		
   		$(MainMenu_rowID).attr("class", "");
   		$(obj).attr("class", "hene-bg-color");
		
		vDocGubun = td.eq(3).text().trim();
		vDocNo = td.eq(1).text().trim();
		vStatus  	= td.eq(10).text().trim();
		
		vRegistNo = td.eq(6).text().trim();
		vRevisionNo = td.eq(7).text().trim();
		vDocumentNo = td.eq(1).text().trim();
		vFileViewName = td.eq(5).text().trim();

	}
    
</script>
  	 	
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			 <th style='width:0px; display: none;'>내외부구분</th>
		     <th style='width:0px; display: none;'>문서코드</th>
		     <th style='width:0px; display: none;'>문서명</th>
		     <th style='width:0px; display: none;'>문서구분코드</th>
		     <th>문서구분</th>
		     
		     <th>파일명</th>
		     <th>등록번호</th>
		     <th>개정번호</th>
		     <th style='width:0px; display: none;'>실파일명</th>
		     <th style='width:0px; display: none;'>외부문서</th>
		     
		     <th>등록사유</th>
		     <th style='width:0px; display: none;'>파기사유</th>
		     <th style='width:0px; display: none;'>총페이지</th>
		     <th style='width:0px; display: none;'>관리본여부</th>
		     <th style='width:0px; display: none;'>보관여부</th>
		     
		     <th style='width:0px; display: none;'>보존여부</th>
		     <th>등록일자</th>
		     <th>등록자</th>
		     <th style='width:0px; display: none;'>document_no_rev</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th></th>		      
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              