<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M909S160100E104", jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S160100";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">

    $(document).ready(function () {
//     	var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/;	// 특수문자
//     	var pattern= /'"\\r\f\b\t\n/gi;	// 특수문자
//     	for(var i=0; i<qUeryData.length; i++){
//     		for(var j=0; j<qUeryData[i]; j++){
//     			if(qUeryData[i][j].indexof(pattern) != -1){
//     				qUeryData[i][j].replaceall(pattern, "\"+pattern);
//     			}
//     		}
//     	}
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [4,9],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		/* for( var i = 0 ; i < 6 ; i++ )
		{
			console.log( "td.eq(" + i + ") : " + td.eq(i).text().trim() );
		} */
		
		console.log( "센서 번호 : " + td.eq(0).text().trim() );
		console.log( "센서 채널 번호 : " + td.eq(1).text().trim() );
		console.log( "CCP 번호 : " + td.eq(2).text().trim() );
		console.log( "CCP 명 : " + td.eq(3).text().trim() );
		console.log( "CCP 타입코드 : " + td.eq(4).text().trim() );
		console.log( "CCP 타입 : " + td.eq(5).text().trim() );
		console.log( "CCP 값 : " + td.eq(6).text().trim() );
		console.log( "CCP 여부 : " + td.eq(7).text().trim() );
		console.log( "데이터 수집방법 : " + td.eq(8).text().trim() );
		console.log( "멤버키 : " + td.eq(9).text().trim() );
		
		vCensorNo = td.eq(0).text().trim();
		vCCPNo = td.eq(2).text().trim();

		//fn_DetailInfo_List();
    }

</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>센서 번호</th>
		     <th>센서 채널 번호</th>
		     <th>CCP 번호</th>
		     <th>CCP 명</th>
		     <th style='width:0px; display: none;'>CCP 타입코드</th>
		     <th>CCP 타입</th>
		     <th>CCP 값</th>
		     <th>CCP 여부</th>
		     <th>데이터 수집방법</th>
		     <th style='width:0px; display: none;'>멤버키</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th>  -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>


<div id="UserList_pager" class="text-center">
</div>                 
