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
	
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_CUST_CD = "", 
		   GV_REVISION_NO = "", 
		   GV_IO_GB = "";
	
	if(request.getParameter("cust_cd") != null)
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");
	
	if(request.getParameter("IoGb") != null)
		GV_IO_GB = request.getParameter("IoGb");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("CUST_CD", GV_CUST_CD);
	jArray.put("REVISION_NO", GV_REVISION_NO);
	jArray.put("IO_GB", GV_IO_GB);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S070100E204", strColumnHead, jArray);
		
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
%>
 
        
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S070100E103 = {
			PID: "M909S070100E103",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""],
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S070100E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";
	
	var IO_STATUS;
	
	function SetRecvData(){
		if (confirm("삭제하시겠습니까?") != true) {
			return;
		}
				
		DataPars(M909S070100E103, GV_RECV_DATA);
 		if(M909S070100E103.retnValue > 0)
 			alert('삭제 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {

   		var dataJson = new Object();
   			dataJson.member_key = "<%=member_key%>";
   			dataJson.cust_cd = "<%=GV_CUST_CD%>";
			dataJson.BizNo = $('#txt_BizNo').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
	    	dataJson.IoGubun = $("#select_IoGubun option:selected").val();
		
	    var checkrtn = confirm("삭제하시겠습니까?");
	    
	    if(checkrtn) {
	   		SendTojsp(JSON.stringify(dataJson), "M909S070100E103");
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
	        		$("#modalReport").modal('hide');
		        	parent.fn_MainInfo_List();
		        	heneSwal.successTimer("삭제 완료되었습니다");
	         	} else {
		        	heneSwal.errorTimer("삭제 실패했습니다");
				}
			}
		});		
	}
    
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);
		
        var today = new Date();
        var fromday = new Date("<%=targetCustVector.get(11).toString()%>");

        $("#select_IoGubun").val("<%=GV_IO_GB%>");
        
	    $("#select_IoGubun").on("change", function(){
	    	IO_STATUS = $(this).val();
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
            <td></td>
            <td><input type="text" class="form-control" id="txt_CustCode" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(0).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">고객사명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CustName" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(2).toString()%>" readonly/>
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
               		value="<%=targetCustVector.get(4).toString()%>"  readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">주소</td>
            <td></td>
            <td><input type="text" class="form-control" id="txt_Juso" style="width: 400px; float:left" 
               		value="<%=targetCustVector.get(5).toString()%>"  readonly/>
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">거래처구분</td>
            <td></td>
            <td>
            	<select class="form-control" id="select_IoGubun" style="width: 200px" disabled>
					<option value='CUSTOMER_GUBUN_BIG02' <%=targetCustVector.get(6).toString().equals("매출거래처") ? "selected" : "" %> >매출거래처</option>
					<option value='CUSTOMER_GUBUN_BIG01' <%=targetCustVector.get(6).toString().equals("매입거래처") ? "selected" : "" %> >매입거래처</option>
				</select>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">업태</td>
            <td></td>
            <td><input type="text" class="form-control" id="txt_Uptae" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(7).toString()%>"  readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">종목</td>
            <td></td>
            <td><input type="text" class="form-control" id="txt_Jongmok" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(8).toString()%>"  readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">대표자명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_BossName" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(9).toString()%>"  readonly/>
           	</td>
        </tr>

		<tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">사업장관리번호(이력제)</td>
            <td></td>
            <td><input type="text" class="form-control" id="txt_Log_refno" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(10).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(1).toString()%>" readonly />
            	<input type="hidden" class="form-control" id="txt_Log_refno" style="width: 200px; float:left" 
               		value="<%=targetCustVector.get(10).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td></td>
            <td>
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" readonly
                	style="width: 220px; border: solid 1px #cccccc;"/>
           	</td>
        </tr>
    </table>