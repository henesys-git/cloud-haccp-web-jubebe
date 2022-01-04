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
	
	String GV_VHCL_NO="",GV_VHCL_NO_REV="",GV_SERVICE_DATE="" ;

	if(request.getParameter("vhcl_no")== null)
		GV_VHCL_NO="";
	else
		GV_VHCL_NO = request.getParameter("vhcl_no");	
	
	if(request.getParameter("vhcl_no_rev")== null)
		GV_VHCL_NO_REV="";
	else
		GV_VHCL_NO_REV = request.getParameter("vhcl_no_rev");
	
	if(request.getParameter("service_date")== null)
		GV_SERVICE_DATE="";
	else
		GV_SERVICE_DATE = request.getParameter("service_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "vhcl_no", GV_VHCL_NO);
	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV);
	jArray.put( "service_date", GV_SERVICE_DATE);
	
    TableModel = new DoyosaeTableModel("M838S060100E114", jArray);
 	int RowCount =TableModel.getRowCount();

    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S060110";
    
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
					'targets': [0,1,3, 5,6,7,8,9,10,11,12],
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
		     <th style='width:0px; display: none;'>구분</th>
		     <th style='width:0px; display: none;'>구분 중분류 코드</th>
		     <th>구분 중분류</th>
		     <th style='width:0px; display: none;'>구분 소분류 코드</th>
		     <th>구분 소분류</th>
		     <th style='width:0px; display: none;'>체크문항코드</th>
		     <th style='width:0px; display: none;'>체크문항rev</th>
		     <th style='width:0px; display: none;'>체크문항seq</th>
		     <th style='width:0px; display: none;'>체크아이템코드</th>
		     <th style='width:0px; display: none;'>체크아이템seq</th>
		     <th style='width:0px; display: none;'>체크아이템rev</th>
		     <th style='width:0px; display: none;'>기준사항</th>
		     <th style='width:0px; display: none;'>기준값</th>
		     <th>점검항목</th>
		     <th>결과 값</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th>  -->
<!-- 		     <th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

    