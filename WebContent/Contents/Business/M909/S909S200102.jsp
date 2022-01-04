<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_STANDARD_DATE = "", GV_WORKER_COUNT ="", GV_WORKING_DAY_COUNT ="",
		   GV_WORKING_COST_HOUR ="", GV_WORKING_COST_DAY = "", GV_WORKING_COST_MONTH = "",
		   GV_DURATION_TIME_ALL ="", GV_WORKING_COST_ALL_REAL ="", GV_INDIRECT_COST ="",
		   GV_PROD_COST_ALL ="", GV_BIGO ="", GV_WORKING_REV_NO ="", GV_STANDARD_YEARMONTH;
	
	if(request.getParameter("standard_yearmonth")== null)
		GV_STANDARD_YEARMONTH="";
	else
		GV_STANDARD_YEARMONTH = request.getParameter("standard_yearmonth");
	
	if(request.getParameter("standard_date")== null)
		GV_STANDARD_DATE="";
	else
		GV_STANDARD_DATE = request.getParameter("standard_date");
	
	if(request.getParameter("worker_count")== null)
		GV_WORKER_COUNT="";
	else
		GV_WORKER_COUNT = request.getParameter("worker_count");
	
	if(request.getParameter("working_day_count")== null)
		GV_WORKING_DAY_COUNT="";
	else
		GV_WORKING_DAY_COUNT = request.getParameter("working_day_count");
	
	if(request.getParameter("working_cost_hour")== null)
		GV_WORKING_COST_HOUR="";
	else
		GV_WORKING_COST_HOUR = request.getParameter("working_cost_hour");
	
	if(request.getParameter("working_cost_day")== null)
		GV_WORKING_COST_DAY="";
	else
		GV_WORKING_COST_DAY = request.getParameter("working_cost_day");
	
	if(request.getParameter("working_cost_month")== null)
		GV_WORKING_COST_MONTH="";
	else
		GV_WORKING_COST_MONTH = request.getParameter("working_cost_month");
	
	if(request.getParameter("duration_time_all")== null)
		GV_DURATION_TIME_ALL="";
	else
		GV_DURATION_TIME_ALL = request.getParameter("duration_time_all");
	
	if(request.getParameter("working_cost_all_real")== null)
		GV_WORKING_COST_ALL_REAL="";
	else
		GV_WORKING_COST_ALL_REAL = request.getParameter("working_cost_all_real");
	
	if(request.getParameter("indirect_cost")== null)
		GV_INDIRECT_COST="";
	else
		GV_INDIRECT_COST = request.getParameter("indirect_cost");
	
	if(request.getParameter("prod_cost_all")== null)
		GV_PROD_COST_ALL="";
	else
		GV_PROD_COST_ALL = request.getParameter("prod_cost_all");
	
	if(request.getParameter("bigo")== null)
		GV_BIGO="";
	else
		GV_BIGO = request.getParameter("bigo");
	
	if(request.getParameter("working_rev_no")== null)
		GV_WORKING_REV_NO="";
	else
		GV_WORKING_REV_NO = request.getParameter("working_rev_no");
	
	DoyosaeTableModel TableModel;


%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S130100E101 = {
			PID: "M909S200100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S200100E102",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
    console.log('1');
    
    $(document).ready(function () {

		new SetSingleDate2("", "#txt_Standard_Date", 0);
        
        
        $('#txt_Standard_Yearmonth').val('<%=GV_STANDARD_YEARMONTH%>');
        $('#txt_Working_Rev_No').val('<%=GV_WORKING_REV_NO%>');
        $('#txt_Worker_Count').val('<%=GV_WORKER_COUNT%>');
        $('#txt_Working_Day_Count').val('<%=GV_WORKING_DAY_COUNT%>');
        $('#txt_Working_Cost_All_Real').val('<%=GV_WORKING_COST_ALL_REAL%>');
        $('#txt_Indirect_Cost').val('<%=GV_INDIRECT_COST%>');
        $('#txt_Prod_Cost_All').val('<%=GV_PROD_COST_ALL%>');
        $('#txt_Bigo').val('<%=GV_BIGO%>');
        
        $('#txt_Standard_Yearmonth').attr('disabled', true);
	    
    });
    
    
	function SetRecvData(){
		DataPars(M909S130100E101,GV_RECV_DATA);
 		if(M909S130100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List();
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
			dataJson.StandardDate = "<%=GV_STANDARD_DATE%>" ;
			dataJson.WorkerCount= $('#txt_Worker_Count').val();
			dataJson.WorkingDayCount= $('#txt_Working_Day_Count').val();
			dataJson.WorkingCost = $('#txt_Working_Cost_All_Real').val();
			dataJson.IndirectCost = $('#txt_Indirect_Cost').val();
			dataJson.ProdCost = $('#txt_Prod_Cost_All').val();
			dataJson.Bigo = $('#txt_Bigo').val();
			dataJson.WorkingRevNo = $('#txt_Working_Rev_No').val();
			dataJson.user_id = "<%=loginID%>";
//    	    console.log(params);

		var chekrtn = confirm("수정하시겠습니까?"); 
		
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
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success("정보 수정에 성공했습니다.");
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	} else {
	        		heneSwal.error("정보 수정에 실패했습니다, 다시 시도해주세요");
	        	}
	         },
	         error: function (xhr, option, error) {
	        	 heneSwal.error("정보 수정에 실패했습니다, 다시 시도해주세요");
	         }
	     });		
	}
	
    
    


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


   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
   		

        <tr style="height: 40px">
            <td style="font-weight:900;">기준일자</td>
            <td></td>
            <td >
            	<input type="text" class="form-control" id="txt_Standard_Yearmonth" style="width: 200px; float:left"  />
            	<input type="hidden" class="form-control" id="txt_Working_Rev_No" style="width: 120px" />
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">총 노무인원</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Worker_Count" style="width: 200px; float:left"  />
				
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
