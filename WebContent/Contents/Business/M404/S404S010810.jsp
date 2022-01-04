<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

// 	String Fromdate="",Todate="",custCode="", GV_JSPPAGE;
	
	
// 	if(request.getParameter("From")== null)
// 		Fromdate="";
// 	else
// 		Fromdate = request.getParameter("From");
	
// 	if(request.getParameter("To")== null)
// 		Todate="";
// 	else
// 		Todate = request.getParameter("To");	
	
// 	if(request.getParameter("custcode")== null)
// 		custCode="";
// 	else
// 		custCode = request.getParameter("custcode");
	
// 	if(request.getParameter("JSPpage")== null)
// 		GV_JSPPAGE="";
// 	else
// 		GV_JSPPAGE = request.getParameter("JSPpage");

	String GV_BALJU_NO="";
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	
	JSONObject jArray = new JSONObject();
// 	jArray.put( "fromdate", Fromdate);
// 	jArray.put( "todate", Todate);
// 	jArray.put( "custcode", custCode);
// 	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "BaljuNo", GV_BALJU_NO);
	jArray.put( "member_key", member_key);
	
// 	수입검사신청서 조회
    TableModel = new DoyosaeTableModel("M404S010100E814", jArray);	

 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S010810";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
 	System.out.println("2121 GV_BALJU_NO : " + GV_BALJU_NO);
%>
<script>
    
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27,28,29,30,31,32,33,34],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    });
    
    function clickSubMenu(obj){
      	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
  		
  		$(SubMenu_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");

  }

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr> 
		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th>발주번호</th> 
		     <th>점검일자</th> 
		     <th>점검시간</th>
		     <th>입고일자</th>
		     <th style='width:0px; display: none;'>입고시간</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>고객사코드개정번호</th>
		     <th style='width:0px; display: none;'>원부자재코드</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>원부자 명</th>
		     <th style='width:0px; display: none;'>원부자재규격</th>
		     <th style='width:0px; display: none;'>제품수량</th>
		     <th style='width:0px; display: none;'>검사구분</th>
		     <th style='width:0px; display: none;'>검사구분중분류</th>
		     <th style='width:0px; display: none;'>검사구분소분류</th>
		     <th style='width:0px; display: none;'>checklist_cd</th>
		     <th style='width:0px; display: none;'>cheklist_cd_rev</th>
		     <th style='width:0px; display: none;'>checklist_seq</th>
		     <th style='width:0px; display: none;'>item_cd</th>
		     <th style='width:0px; display: none;'>item_seq</th>
		     <th style='width:0px; display: none;'>item_cd_rev</th>
		     <th>표준지침</th>
		     <th>표준값</th>
		     <th>검사내용</th>
		     <th style='width:0px; display: none;'>check_value</th>
		     <th style='width:0px; display: none;'>부적합내용</th>
		     <th style='width:0px; display: none;'>개선조치내용</th>
		     <th style='width:0px; display: none;'>작성일자</th>
		     <th style='width:0px; display: none;'>작성자_정</th>
		     <th style='width:0px; display: none;'>writor_main_rev</th>
		     <th style='width:0px; display: none;'>작성자_부</th>
		     <th style='width:0px; display: none;'>writor_second_rev</th>
		     <th style='width:0px; display: none;'>작성승인자</th>
		     <th style='width:0px; display: none;'>HACCP승인자</th>
		     <th style='width:0px; display: none;'>member_key</th> 
		     <th>검사수량</th>
		     <th>불량수량</th>
		     <th>합격여부</th>
		      
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		     
		     <% } else { %>
		     <th>빌주번호</th> 
		     <th>점검일자</th> 
		     <th>점검시간</th>
		     <th>입고일자</th>
		     <th style='width:0px; display: none;'>입고시간</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>고객사코드개정번호</th>
		     <th style='width:0px; display: none;'>원부자재코드</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>원부자 명</th>
		     <th style='width:0px; display: none;'>원부자재규격</th>
		     <th style='width:0px; display: none;'>제품수량</th>
		     <th style='width:0px; display: none;'>검사구분</th>
		     <th style='width:0px; display: none;'>검사구분중분류</th>
		     <th style='width:0px; display: none;'>검사구분소분류</th>
		     <th style='width:0px; display: none;'>checklist_cd</th>
		     <th style='width:0px; display: none;'>cheklist_cd_rev</th>
		     <th style='width:0px; display: none;'>checklist_seq</th>
		     <th style='width:0px; display: none;'>item_cd</th>
		     <th style='width:0px; display: none;'>item_seq</th>
		     <th style='width:0px; display: none;'>item_cd_rev</th>
		     <th>표준지침</th>
		     <th>표준값</th>
		     <th>검사내용</th>
		     <th style='width:0px; display: none;'>check_value</th>
		     <th style='width:0px; display: none;'>부적합내용</th>
		     <th style='width:0px; display: none;'>개선조치내용</th>
		     <th style='width:0px; display: none;'>작성일자</th>
		     <th style='width:0px; display: none;'>작성자_정</th>
		     <th style='width:0px; display: none;'>writor_main_rev</th>
		     <th style='width:0px; display: none;'>작성자_부</th>
		     <th style='width:0px; display: none;'>writor_second_rev</th>
		     <th style='width:0px; display: none;'>작성승인자</th>
		     <th style='width:0px; display: none;'>HACCP승인자</th>
		     <th style='width:0px; display: none;'>member_key</th> 
		     <th>검사수량</th>
		     <th>불량수량</th>
		     <th>합격여부</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		<% } %>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>              