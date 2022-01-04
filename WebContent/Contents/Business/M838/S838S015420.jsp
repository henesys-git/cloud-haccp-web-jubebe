<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_CHECK_GUBUN="",GV_CHECK_GUBUN_MID="" ;
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	if(request.getParameter("check_gubun_mid")== null)
		GV_CHECK_GUBUN_MID = "";
	else
		GV_CHECK_GUBUN_MID = request.getParameter("check_gubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	jArray.put( "check_gubun_mid", GV_CHECK_GUBUN_MID);

	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S015400E134", jArray);
	int RowCount =TableModel.getRowCount();
%>
 
    <script type="text/javascript">
	
	$(document).ready(function () {
		
		vTableMetalCheck=$('#metal_check_table').DataTable({    
    		scrollX: true,
    		scrollY: 400,
//   	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
//     	    order: [[ 0, "asc" ]],
    	    keys: false,
    	    info: true,
	  		columnDefs: [
	  			{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:60%;'); 
		       		}
				},
				{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:40%;'); 
		       		}
				}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }		    	  	
		});	
		
		TableMetalCheck_info = vTableMetalCheck.page.info();
		TableMetalCheck_RowCount = TableMetalCheck_info.recordsTotal;
	});
	

    </script>
</head>
<body>


   <table class="table" style="width: 100%; margin: 0 auto; align:left" id="metal_check_table">
		<thead>
        <tr style="vertical-align: middle">
            <th style="width: 60%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">점검항목</th>
            <th style="width: 40%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과</th>
        </tr>		    	
		</thead>
		<tbody id="metal_check_tbody">
	<%
	for (int i=0; i<RowCount; i++){  
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 18).toString().trim();
		if(TableModel.getValueAt(i, 20).toString().trim().length()>0) {
			GV_CHECK_NOTE += "-" + TableModel.getValueAt(i, 20).toString().trim();
			if(TableModel.getValueAt(i, 5).toString().trim().length()>0)
				GV_CHECK_NOTE += "-" + TableModel.getValueAt(i, 5).toString().trim() ;
		}
	%>	 
        <tr style="background-color: #fff; height: 40px">
            <td>
            	<%=GV_CHECK_NOTE%>
            	<input type="hidden" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 2).toString().trim()%>'></input>	
				<input type="hidden" id="txt_checklist_rev" readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>	
				<input type="hidden" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 11).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_check_gubun" readonly value='<%=TableModel.getValueAt(i, 0).toString().trim()%>'></input>	
				<input type="hidden" id="txt_code_name" readonly value='<%=TableModel.getValueAt(i, 1).toString().trim()%>'></input>	
				<input type="hidden" id="txt_double_check_yn" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>		
				<input type="hidden" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 13).toString().trim()%>'></input>
				<input type="hidden" id="txt_start_date" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>	
				<input type="hidden" id="txt_duration_date" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>
            	<input type="hidden" id="txt_check_gubun_mid"  readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
				<input type="hidden" id="txt_check_gubun_sm"  readonly value='<%=TableModel.getValueAt(i, 19).toString().trim()%>'></input>
            	<input type="hidden" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>
				<input type="hidden" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>
            </td>
            <td >
            	<%if(TableModel.getValueAt(i,12).toString().trim().equals("text")){ %>
            		<%if(i==0 && TableModel.getValueAt(i, 18).toString().trim().equals("품명")){%>
					<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>" class="form-control" id="txt_prod_nm" 
						style="float:left; width:70%; vertical-align:middle;" ></input>
					<button type="button" onclick="parent.pop_fn_ProductName_View(1,'ALL')" id="btn_SearchCust" class="btn btn-info" 
						style="float:left; width:30%;">검색</button>
					<input type="hidden" class="form-control" id="txt_prod_cd" />
					<input type="hidden" class="form-control" id="txt_prod_cd_rev" />
					<%} else {%>
					<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>" class="form-control" id="txt_check_value" 
						style="width:100%; vertical-align:middle;" ></input>	
					<%}%>
				<%} else if(TableModel.getValueAt(i,12).toString().trim().equals("checkbox")){ %>
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>" class="" id="txt_check_value" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" checked>
						<%=TableModel.getValueAt(i, 7).toString().trim()%>
				</input>
				<%} %>
            </td>
        </tr>
	<%} %>
		</tbody>
    </table>
</body>
</html>