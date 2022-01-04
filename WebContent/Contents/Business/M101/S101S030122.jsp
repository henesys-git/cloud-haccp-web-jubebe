<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	String  GV_ORDERNO, GV_JSPPAGE="",GV_PRODUCT_NAME,GV_ORDERDETAIL,GV_CUSTNAME,GV_LOTNO;

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

// 	if(request.getParameter("projectname")== null)
// 		GV_PROJECTNAME="";
// 	else
// 		GV_PROJECTNAME = request.getParameter("projectname");
	
	if(request.getParameter("Product_name")== null)
		GV_PRODUCT_NAME="";
	else
		GV_PRODUCT_NAME = request.getParameter("Product_name");

	if(request.getParameter("custname")== null)
		GV_CUSTNAME ="";
	else
		GV_CUSTNAME = request.getParameter("custname");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO ="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strHeadHead	= {"Head"};
	String param =  GV_ORDERNO + "|" + GV_LOTNO + "|"  + member_key + "";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);	
    TableModel = new DoyosaeTableModel("M101S030100E999", strHeadHead, jArray);	//주문 부속정보 요약
 	int RowCount =TableModel.getRowCount();

%>
    
    <script type="text/javascript">
	
	var M101S030100E122 = "M101S030100E122";  	
    
    $(document).ready(function () {
    	
		<%if(TableModel.getRowCount()>0) {%>
			$('#txt_bom').val('<%=TableModel.getValueAt(0,1).toString()%>');
			$('#txt_doccount').val('<%=TableModel.getValueAt(0,2).toString()%>');
<%-- 			$('#txt_procscnt').val('<%=TableModel.getValueAt(0,3).toString()%>'); --%>
			$('#txt_checkcnt').val('<%=TableModel.getValueAt(0,3).toString()%>'); <%-- 원래 4임 --%>

			$('#txt_order_no').val('<%=GV_ORDERNO%>');
			$('#txt_custname').val('<%=GV_CUSTNAME%>');
			$('#txt_product_name').val('<%=GV_PRODUCT_NAME%>');
		<%}%>
		

    });
	
	function SaveOderInfo() {    
		var chekrtn = confirm("완료하시겠습니까?"); 		

		var jArray = new Array(); // JSON Array 선언
		var dataJson = new Object(); // jSON Object 선언
		if(chekrtn){
			if($('#txt_bom').val()<1) {
				alert("BOM을 등록하세요.");
				return false;
// 			} else if($('#txt_procscnt').val()<1) {
// 				alert("공정확인표를 등록하세요.");
// 				return false;
			} else if($('#txt_checkcnt').val()<1) {
				alert("제품검사 체크리스트를 등록하세요.");
				return false;
			} else{
	    		dataJson.jsp_page 		= '<%=GV_JSPPAGE%>'; 
	    		dataJson.user_id 		= '<%=loginID%>';
	    		dataJson.order_no		= '<%=GV_ORDERNO%>'; 
	    		dataJson.order_detail_seq= '<%=GV_ORDERDETAIL%>';
	    		dataJson.indGb 	= '0';
	    		dataJson.lotno 			= '<%=GV_LOTNO%>';
				dataJson.member_key 	= "<%=member_key%>";
				jArray.push(dataJson); // 데이터를 배열에 담는다
				
				var dataJsonMulti = new Object();
		 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

				var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
				SendTojsp(JSONparam, "M101S030100E122"); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
			}
		}
	}

	function SendTojsp(bomdata, pid){		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {
	        	 if(html>-1){
		        		parent.fn_MainInfo_List();
		        		 vOrderNo = "";  
		        		 vOrderDetailSeq = "";
		        		 vLotNo = "";
		        		DetailInfo_List.click();
		                parent.$("#ReportNote").children().remove();
		         		parent.$('#modalReport').hide();
		         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}  
   
    </script>
 		<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff;">
	            <td style="width: 25%; font-weight: 900; font-size:14px; text-align:left">주문번호</td>
	            <td style="width: 75%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_order_no" style="width: 100%; float:left"  readonly/>				
	           	</td>
	            
	        </tr>
	        <tr style="background-color: #fff;">
	            <td style=" font-weight: 900; font-size:14px; text-align:left">제품명</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_product_name" style=" float:left"  readonly />					
	           	</td>
	            
	        </tr>
	        <tr style="background-color: #fff;">	            
	            <td style="font-weight: 900; font-size:14px; text-align:left">고객사</td>
	            <td style="font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_custname" style=" float:left"  readonly />								
	           	</td>
	        </tr>
	
			<tr style="background-color: #fff;">
	            <td style=" font-weight: 900; font-size:14px; text-align:left">주문관련 문서</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left">
	            <input type="text"  id="txt_doccount" class="form-control" style="width: 50%;float:left" readonly />건</td>
	        </tr>
	
	        <tr style="background-color: #fff; ">
	            <td style=" font-weight: 900; font-size:14px; text-align:left">BOM </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left"> 
	            <input type="text"  id="txt_bom" class="form-control"  style="width: 50%;float:left"  readonly />건</td>
	        </tr>
	
<!-- 	        <tr style="background-color: #fff; "> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left">공정확인표 </td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left"> -->
<!-- 	            <input type="text"  id="txt_procscnt" class="form-control" style="width:50%;float:left" readonly/>건</td>            -->
<!-- 	        </tr> -->
	        <tr style="background-color: #fff; ">
	            <td style=" font-weight: 900; font-size:14px; text-align:left">제품검사 체크리스트 </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left">
	            <input type="text"  id="txt_checkcnt" class="form-control"  style="width: 50%;float:left" readonly/>건</td>      
	        </tr>
	        <tr style="height: 60px">
	            <td style="text-align:center" colspan="2">
	                <p>
	                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">처리완료</button>
	                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
	                </p>
	            </td>
	        </tr>
      	</table>
        