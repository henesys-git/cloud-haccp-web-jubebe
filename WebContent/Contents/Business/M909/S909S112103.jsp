<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";

	String[] strColumnHead = {"storage_no", "rake_no", "plate_no", "col_no", "config_process"} ;

	String GV_STORAGE_NO="";

	String GV_TODAY = Common.getSystemTime("date");

	if(request.getParameter("storage_no")== null)
		GV_STORAGE_NO="";
	else
		GV_STORAGE_NO = request.getParameter("storage_no");

	String param = GV_STORAGE_NO + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "STORAGE_NO", GV_STORAGE_NO);
	
    TableModel = new DoyosaeTableModel("M909S112100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
		
%>
 
        
    <script type="text/javascript">
	
	function SaveOderInfo() {
		if ($('#txt_storage_no').val().length < 1) {
			alert("창고번호를 입력하세요.");
			return;
		}
		
		var delete_check = confirm("Rev(개정번호) 상관없이 해당 창고번호를 삭제합니다."+"\n"+"삭제하시겠습니까?");
		if(delete_check) {
	   		var dataJson = new Object(); // jSON Object 선언 
	   			dataJson.member_key = "<%=member_key%>";
				dataJson.storage_no = $('#txt_storage_no').val();
				dataJson.rake_no = $('#txt_rake_no').val();
				dataJson.plate_no = $('#txt_plate_no').val();
				dataJson.col_no = $('#txt_col_no').val();

			var chekrtn = confirm("삭제하시겠습니까?"); 
			
			if(chekrtn){
				
// 				SendTojsp(urlencode(params),"M909S112100E103");
				SendTojsp(JSON.stringify(dataJson), "M909S112100E103"); // 보내는 데이터묶음 하나일때 => Object하나만
			}
		}
	}
	
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
    
    $(document).ready(function () {

        $("#txt_StartDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });        

        var today = new Date();
        var fromday = new Date();
        <%--         var fromday = new Date("<%=targetCustVector.get(6).toString()%>"); --%>
        //fromday.setDate(today.getDate());
        
//        $('#txt_StartDate').datepicker('update', fromday);
    });

    </script>

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; height: 40px">
            <td>창고번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_storage_no" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(0).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>렉수/창고당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_rake_no" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(1).toString()%>" readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>선반수/렉당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_plate_no" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(2).toString()%>" readonly/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>칸수/선반당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_col_no" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(3).toString()%>" readonly/>
           	</td>
        </tr>
        
        

        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
