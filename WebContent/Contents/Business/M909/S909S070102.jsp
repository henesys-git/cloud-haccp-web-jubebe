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
	
	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);
	
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_CUST_CD="", GV_REVISION_NO="", GV_IO_GB="", GV_LOCATION_NM = "";
	
	if(request.getParameter("cust_cd")== null)
		GV_CUST_CD="";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");
	
	if(request.getParameter("IoGb")== null)
		GV_IO_GB="";
	else
		GV_IO_GB = request.getParameter("IoGb");
	
	if(request.getParameter("location_nm")== null)
		GV_LOCATION_NM="";
	else
		GV_LOCATION_NM = request.getParameter("location_nm");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "CUST_CD", GV_CUST_CD);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	jArray.put( "IO_GB", GV_IO_GB);
	
	TableModel = new DoyosaeTableModel("M909S070100E204", strColumnHead, jArray);
	int ColCount =TableModel.getColumnCount();
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
		
	// 데이터를 가져온다.
	Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
	
	// 개정번호를 만든다.
	String revisionNumberStr = "";
	int revisionNoInt = 0;
	try {
		revisionNoInt = Integer.parseInt( targetCustVector.get(1).toString().trim() );
	} catch (Exception e) {
		revisionNoInt = 0;
	}
	revisionNoInt = revisionNoInt + 1;
	revisionNumberStr = "" + revisionNoInt;
	
	Vector CustomerCode = null;
   	Vector CustomerName = null;
   	Vector CustomerVector = CommonData.getCustomerGubun();
    
    Vector LocationCode = null;
	Vector LocationName = null;
	Vector LocationVector = CommonData.getDeliverLocation();
		
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S070100E102 = {
			PID: "M909S070100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S070100E102",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	
	var IO_STATUS;
	
	function SetRecvData(){
		DataPars(M909S070100E102, GV_RECV_DATA);
 		if(M909S070100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_BizNo').val().length < 10) {
			alert("기관코드(사업자번호)를 정확히 입력하세요.\n[예:123-12-12345]");
			return;
		}
		if ($('#txt_CustName').val().length < 1) {
			alert("기관명을 입력하세요.");
			return;
		}

		var WebSockData="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
   			dataJson.cust_cd = "<%=GV_CUST_CD%>";
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
			dataJson.StartDate = $('#txt_StartDate').val();
		    dataJson.user_id = "<%=loginID%>";
		    dataJson.Log_refno = $('#txt_Log_refno').val(); //사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가
		   	dataJson.RevisionNo_Target = "<%=targetCustVector.get(1).toString() %>";

			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
   				SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
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
	        		heneSwal.success('고객사 정보 수정에 성공하였습니다.');
	        		$("#modalReport").modal('hide');
		        	parent.fn_MainInfo_List();
	         	}
	        	else{
	        		heneSwal.error('고객사 정보 수정에 실패하였습니다.');	
	        	}
	         }
	     });		
	}
    
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);
    	
        var today = new Date();
        var fromday = new Date("<%=targetCustVector.get(11).toString()%>");
		
        console.log('<%=GV_LOCATION_NM%>');
        
        $("#select_Location").prepend("<option value = ''>매출거래처 구분</option>"); 
    	$("#select_Location > option:eq(0)").prop("selected",true);
        
        $("#select_IoGubun").val('<%=GV_IO_GB%>').prop("selected", true);
        $("#select_Location").val('<%=GV_LOCATION_NM%>').prop("selected", true);
        
        var IO_STATUS = $('#select_IoGubun').val();
        
		if(IO_STATUS == 'CUSTOMER_GUBUN_BIG01'){
			$("#select_Location > option:eq(0)").prop("selected",true);
	    	$('#select_Location').attr('disabled', true);	
	    }
	    else {
	    	$('#select_Location').attr('disabled', false);		
	    } 
        
	    $("#select_IoGubun").on("change", function(){
	    	IO_STATUS = $(this).val();
	    	
	    	if(IO_STATUS == 'CUSTOMER_GUBUN_BIG01') {
	    	$("#select_Location > option:eq(0)").prop("selected",true);
		    $('#select_Location').attr('disabled', true);	
		    }
		    else {
		    $('#select_Location').attr('disabled', false);		
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

</script>
    
    
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">      
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">고객사코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CustCode" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(0).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">고객사명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CustName" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(2).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">사업자등록번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_BizNo" style="width: 200px; float:left"
               		value="<%=targetCustVector.get(3).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">전화번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_TelNo" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(4).toString()%>"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">주소</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Juso" style="width: 400px; float:left" 
               		value="<%=targetCustVector.get(5).toString()%>"  />
           	</td>
        </tr>
        
        <%-- <tr style="height: 40px">
            <td style="font-weight:900;">거래처구분</td>
            <td></td>
            <td >
            	<select class="form-control" id="select_IoGubun" style="width: 120px">
					<option value='O' <%=targetCustVector.get(6).toString().equals("매출거래처") ? "selected" : "" %> >매출거래처</option>
					<option value='I' <%=targetCustVector.get(6).toString().equals("매입거래처") ? "selected" : "" %> >매입거래처</option>
				</select>
            </td>
        </tr> --%>
        
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
            <td ><input type="text" class="form-control" id="txt_Uptae" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(7).toString()%>"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">종목</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Jongmok" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(8).toString()%>"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">대표자명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_BossName" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(9).toString()%>"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" 
            		value="<%=revisionNumberStr%>" readonly />
            	<input type="hidden" class="form-control" id="txt_Log_refno" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(10).toString()%>"  />
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