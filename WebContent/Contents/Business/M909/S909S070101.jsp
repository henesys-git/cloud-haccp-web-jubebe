<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
	
    Vector CustomerCode = null;
   	Vector CustomerName = null;
   	Vector CustomerVector = CommonData.getCustomerGubun();
    
    Vector LocationCode = null;
	Vector LocationName = null;
	Vector LocationVector = CommonData.getDeliverLocation();
    
	String[] strColumnHead = {"", "", "", "" };
	
	String param = "|";
	
	
%>
        
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S070100E101 = {
			PID: "M909S070100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S070100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝
	
	var IO_STATUS;
	
	function SetRecvData(){
		DataPars(M909S070100E101, GV_RECV_DATA);
 		if(M909S070100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_BizNo').val().length < 10) {
			alert("사업자등록번호를 정확히 입력하세요.\n[예:123-12-12345]");
			return;
		}
		if ($('#txt_CustName').val().length < 1) {
			alert("고객사명을 입력하세요.");
			return;
		}
		if ($('#select_IoGubun').val() == 'CUSTOMER_GUBUN_BIG02' && $('#select_Location').val() == '') {
			alert("가맹점 지역을 선택하세요.");
			return;
		}

		var WebSockData="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
   			dataJson.cust_cd = $('#txt_CustCode').val();
			dataJson.BizNo = $('#txt_BizNo').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
			dataJson.CustName = $('#txt_CustName').val();
			dataJson.TelNo = $('#txt_TelNo').val();
			dataJson.Juso = $('#txt_Juso').val();
			dataJson.IoGubun = $("#select_IoGubun option:selected").val();
			dataJson.LocationNm = $("#select_Location option:selected").val();
			dataJson.Uptae = $('#txt_Uptae').val();
			dataJson.Jongmok = $('#txt_Jongmok').val();
			dataJson.BossName = $('#txt_BossName').val();
			dataJson.Log_refno = $('#txt_Log_refno').val(); //사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가
			
			dataJson.StartDate = $('#txt_StartDate').val();
		    dataJson.user_id = "<%=loginID%>";

			var chekrtn = confirm("등록하시겠습니까?"); 
			console.log(dataJson);
			if(chekrtn) {
   				SendTojsp(JSON.stringify(dataJson), SQL_Param.PID);
			}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
	        	if(html > -1) {
	        		heneSwal.success('고객사 정보 등록에 성공하였습니다.');
	            	$("#modalReport").modal('hide');
	        		parent.fn_MainInfo_List();
	         	}
	        	else{
	        	heneSwal.error('고객사 정보 등록에 실패하였습니다.');	
	        	}
	         }
	     });		
	}
    
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);
		
		$("#select_Location").prepend("<option value = ''>매출거래처 구분</option>"); 
    	$("#select_Location > option:eq(0)").prop("selected",true);
		
		var IO_STATUS = $('#select_IoGubun').val();
		
		if(IO_STATUS == 'CUSTOMER_GUBUN_BIG01'){
        	$("#select_Location > option:eq(0)").prop("selected",true);
	    	$('#select_Location').attr('disabled', true);	
	    }
	    else {
	    	$('#select_Location').attr('disabled', false);		
	    } 
		console.log($("#select_IoGubun").val());
		console.log($("#select_Location").val());
		
	    $("#select_IoGubun").on("change", function(){
	    	IO_STATUS = $(this).val();
	    	
	    	if(IO_STATUS == 'CUSTOMER_GUBUN_BIG01'){
	    	$("#select_Location > option:eq(0)").prop("selected",true);
	    	$('#select_Location').attr('disabled', true);	
	    	}
	    	else{
	    	$('#select_Location').attr('disabled', false);		
	    	} 
	    	
	    });
	    
	    // 하나 입력 시 동시에 입력되게 한다.
	    $("#txt_BizNo").keyup(function(){
	    	var txt = $("#txt_BizNo").val();
	    	txt.replace(/-/g, "");
	    	if(txt.length > 9){
	    		cust_cd_count();
	    	}
	    });
	    
	    // 마지막에 입력 시 입력되게 한다.
	    $("#txt_BizNo").change(function(){	    	
	    	var txt = $("#txt_BizNo").val();
	    	txt.replace(/-/g, "");	    	
	    	if(txt.length > 9){	    	
	    		cust_cd_count();
	    	}
	    });
    });

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  

    function cust_cd_count() {
    	var vCust_cd = $("#txt_BizNo").val();
    	vCust_cd = vCust_cd.replace(/-/g, "");
		$.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S070110.jsp", 
            data: "Cust_cd=" + vCust_cd,
            success: function (html) {
            	$("#txt_CustCode").parent().hide().html(html.trim()).fadeIn(100);
            }
        });	    
    }
    
</script>

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">고객사코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" value="사업자등록번호" id="txt_CustCode" style="width: 200px; float:left" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">고객사명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CustName" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">사업자등록번호</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_BizNo" style="width: 200px; float:left" />&nbsp;&nbsp;
            	(ex.[123-12-12345])
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">전화번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_TelNo" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">주소</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Juso" style="width: 400px; float:left"  />
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">거래처구분</td>
            <td></td>
            <td >
				<select class="form-control" id="select_IoGubun" style="width: 200px">
					<% CustomerCode = (Vector)CustomerVector.get(0);%>
					<% CustomerName = (Vector)CustomerVector.get(1);%>
					<% for(int i=0; i<CustomerName.size();i++){ %>
					<option value='<%=CustomerCode.get(i).toString()%>'>
					<%=CustomerName.get(i).toString()%>
					</option>
					<% } %>
				</select>
            </td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">가맹점 지역</td>
            <td></td>
            <td >
				<select class="form-control" id="select_Location" style="width: 200px">
					<% LocationCode = (Vector)LocationVector.get(1);%>
					<% LocationName = (Vector)LocationVector.get(2);%>
					<% for(int i=0; i<LocationName.size();i++){ %>
					<option value='<%=LocationCode.get(i).toString()%>'>
					<%=LocationName.get(i).toString()%>
					</option>
					<% } %>
				</select>
            </td>
        </tr>
        

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">업태</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Uptae" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">종목</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Jongmok" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">대표자명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_BossName" style="width: 200px; float:left"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
            	<input type="hidden" class="form-control" id="txt_Log_refno" style="width: 200px; float:left" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;"/>
           	</td>
        </tr>
    </table>