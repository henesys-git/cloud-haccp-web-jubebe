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
	
	String GV_CHECK_GUBUN;	

	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN="";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");	
	String param =   GV_CHECK_GUBUN + "|"  ;
		
	String GV_REV_CHECK = "", GV_PID = "" ;
	
	if (request.getParameter("total_rev_check") == null)
		GV_REV_CHECK = "";
	else
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) GV_PID = "M909S030100E104";
	else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S030100E105";
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("CHECK_GUBUN", GV_CHECK_GUBUN);
	
    TableModel = new DoyosaeTableModel(GV_PID, jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S030100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,2,4,6,17,18,19,20,21,22],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				scrollX : true,
				pageLength : 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
        
    	vCheckGubun 	= "";
    	vCheckGubunMid	= "";
    	vCheckGubunSm	= "";
		vCheckListCd 	= "";
		vCheckListSeq 	= "";
		vRevisionNo 	= "";
		
		vItemCd 	= "";
		vItemSeq	= "";
	 	vItemRevNo	= "";
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		vCheckGubun = td.eq(0).text().trim();
		
		vCheckGubunMid = td.eq(2).text().trim();
		vCheckGubunSm = td.eq(4).text().trim();
		
		vCheckListCd = td.eq(6).text().trim();
		vCheckListSeq = td.eq(8).text().trim();
		vRevisionNo = td.eq(7).text().trim();
		
		vItemCd = td.eq(13).text().trim();
		vItemSeq	= td.eq(14).text().trim();
	 	vItemRevNo	= td.eq(15).text().trim();
    }


</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>구분</th>
		     <th>구분명</th>
   		     <th>중분류명</th>
		     <th style='width:0px; display: none;'>CG.chk_lst_gb_mid</th>
		     <th style='width:0px; display: none;'>CG.chk_lst_gb_sm</th>
		     <th style='width:0px; display: none;'>체크문항코드</th>
		     <th>소분류명</th>
		     <th>문항Rev</th>
		     <th>문항순번</th>
		     <th>문항내용</th>
		     <th>표준절차</th>
		     <th>표준값</th>
		     <th>Double Check 여부</th>
		     <th>항목코드</th>
		     <th>항목일련번호</th>
		     <th>항목rev</th>
		     <th>적용일자</th>
		     <th style='width:0px; display: none;'>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>                 
