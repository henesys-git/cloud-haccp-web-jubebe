<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;

		
%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S130100E101 = {
			PID: "M909S200100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S200100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
	function SetRecvData(){
		DataPars(M909S130100E101,GV_RECV_DATA);
 		if(M909S130100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List(toDate);
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_Worker_Count').val() == '') {
			alert("노무인원을 입력하세요.");
			return;
		}
		if ($('#txt_Working_Cost').val() == '') {
			alert("노무비 총계를 입력하세요.");
			return;
		}
		if ($('#txt_Working_Day_Count').val() == '') {
			alert("월 근무시간을 입력하세요.");
			return;
		}
		if ($('#txt_Indirect_Cost').val() == '') {
			alert("간접비를 입력하세요.");
			return;
		}
		if ($('#txt_Prod_Cost').val() == '') {
			alert("제조경비 총계를 입력하세요.");
			return;
		}

		var WebSockData="";
		
		var dataJson = new Object(); // jSON Object 선언 
			dataJson.member_key = "<%=member_key%>";
			dataJson.StandardDate = $('#txt_Standard_Date').val();
			dataJson.WorkerCount= $('#txt_Worker_Count').val();
			dataJson.WorkingDayCount= $('#txt_Working_Day_Count').val();
			dataJson.WorkingCost = $('#txt_Working_Cost_All_Real').val();
			dataJson.IndirectCost = $('#txt_Indirect_Cost').val();
			dataJson.ProdCost = $('#txt_Prod_Cost_All').val();
			dataJson.Bigo = $('#txt_Bigo').val();
			dataJson.user_id = "<%=loginID%>";

		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){

			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
// 			SendTojsp(urlencode(params),SQL_Param.PID);
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {

	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success("정보 등록에 성공했습니다.");
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}else {
	        		heneSwal.error("정보 등록에 실패했습니다, 다시 시도해주세요");
	        	}
	         },
	         error: function (xhr, option, error) {
	        	 heneSwal.error("정보 등록에 실패했습니다, 다시 시도해주세요");
	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	new SetSingleDate2("", "#txt_Standard_Date", 0);

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        

        
//        $("#select_status option:eq(1)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

	    $("#select_DocGubunCode").on("change", function(){
	    	docGubunCode = $(this).val();
	    });
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetDocName_code(name, code){
		$('#txt_DocName').val(name);
		$('#txt_DocCode').val(code);
    }
    

    </script>
</head>
<body>

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
   		

        <tr style="height: 40px">
            <td style="font-weight:900;">기준일자</td>
            <td></td>
            <td >
            	<input type="text" class="form-control" id="txt_Standard_Date" style="width: 200px; float:left"  />
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">총 노무인원</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Worker_Count" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>
        
         <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">월 근무일수</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Working_Day_Count" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">실 노무비 총계</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Working_Cost_All_Real" style="width: 200px; float:left"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">간접비</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Indirect_Cost"  style="width: 200px; float:left"/>
           	</td>
        </tr>
        
         <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">제조경비 총계</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Prod_Cost_All" style="width: 200px; float:left" />
           	</td>
        </tr>
        
        
        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_Bigo"  style="cols:40;rows:4;resize: none;" ></textarea></td>
        </tr>
        
    </table>
<!-- </form>     -->
</body>
</html>