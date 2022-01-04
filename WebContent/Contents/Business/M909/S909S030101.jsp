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
	 
	// 아이템코드 목록 (tbm_check_item.item_cd)의 GROUP BY item_cd 
    // M909S030100E304에서 쿼리한다.
    Vector optCodeCode =  null;
    Vector optCodeDesc =  null;
    Vector optCodeBigo =  null;
    Vector optCodeSeq =  null;
    Vector optCodeRev =  null;
    
    Vector checkItemCodeVector = CommonData.getCheckItemCodeList(member_key);
    
	Vector optCode =  null;
    Vector optName =  null;
  	//대분류코드 e038
    Vector check_gubunVector = CommonData.getChecklistGubun_Code(member_key);

  	
	String[] strColumnHead = {"", "", "", "", "", "" };
	
	String GV_CHECK_GUBUN_CODE="",GV_CHECK_GUBUN_NAME="";

	if(request.getParameter("CheckGubunCode")== null)
		GV_CHECK_GUBUN_CODE="";
	else
		GV_CHECK_GUBUN_CODE = request.getParameter("CheckGubunCode");
	
	if(request.getParameter("CheckGubunName")== null)
		GV_CHECK_GUBUN_NAME="";
	else
		GV_CHECK_GUBUN_NAME = request.getParameter("CheckGubunName");
		
%>

<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S030100E101 = {
			PID: "M909S030100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S030100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	



    var docGubunCode = "";
    var JOB_GUBUN = "";
    
	function SetRecvData(){
		DataPars(M909S030100E101, GV_RECV_DATA);
 		if(M909S030100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#select_CheckGubun_Mid').val().length < 1) {
			alert("중분류코드를 선택하세요.");
			return;
		}
		/* if ($('#select_CheckGubun_Sm').val().length < 1) {
			alert("소분류코드를 선택하세요.");
			return;
		} */
		if ($('#txt_MunhangCode').val().length < 1) {
			alert("문항코드를 입력하세요.");
			return;
		}
		if ($('#txt_MunhangNote').val().length < 1) {
			alert("문항내용을 입력하세요.");
			return;
		}
		
		// 체크항목 분할변수
		var totItemInfo = $("#select_ItemCode").val();
		var arrayItemInfo = totItemInfo.split('|');
		var partItemCode = arrayItemInfo[0];
		var partItemSeq = arrayItemInfo[1];
		var partItemRevNo = arrayItemInfo[2];
		
		// Double Check 여부
		var doubleCheckYN = "N";
		if($('#txt_DoubleCheckYN').prop("checked")) doubleCheckYN = "Y";
		else doubleCheckYN = "N";
		
		var WebSockData="";
		var dataJson = new Object(); // jSON Object 선언
			dataJson.member_key = "<%=member_key%>";
			dataJson.CheckGubun = $('#select_CheckGubun').val(); //구분코드
			dataJson.CheckGubunMid 	= $('#select_CheckGubun_Mid').val(); //중분류코드
			dataJson.CheckGubunSm 	= $('#select_CheckGubun_Sm').val(); //소분류코드
			
			dataJson.MunhangCode = $('#txt_MunhangCode').val(); //체크문항코드
			dataJson.MunhangSeq = $('#txt_MunhangSeq').val(); //문항일련번호
			
			dataJson.MunhangNote = $('#txt_MunhangNote').val(); //문항내용
			dataJson.StandardProc = $('#txt_StandardProc').val(); //표준절차
			dataJson.StandardValue = $('#txt_StandardValue').val(); //표준설정값
			dataJson.RevisionNo = $('#txt_RevisionNo').val(); //개정번호
			dataJson.partItemCode = partItemCode; //항목코드
			dataJson.partItemSeq = partItemSeq; //항목일련번호
			dataJson.partItemRevNo = partItemRevNo; //항목개정번호
			dataJson.StartDate = $('#txt_StartDate').val(); //적용시작일자
			dataJson.user_id = "<%=loginID%>";
			dataJson.doubleCheckYN = doubleCheckYN;
			
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				SendTojsp(JSON.stringify(dataJson), "M909S030100E101");
			}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html > -1) {
	        		heneSwal.success('등록에 성공하였습니다.');
	        		parent.$("#select_check_gubun").val( $("#select_CheckGubun").val() ); // 등록완료 후 메인화면 구분을 등록한 구분으로 바꿔주기
	        	   	parent.fn_MainInfo_List();
	        	   	$('#modalReport').modal('hide'); 
	         	}
	        	 else{
	        		heneSwal.error('등록에 실패하였습니다. 다시 시도해 주세요.');
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {

		new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $("#select_CheckGubun").val("<%=GV_CHECK_GUBUN_CODE%>");
        
        $("#select_ItemCode option:eq(0)").prop("selected", true);
        
        fn_Select_CheckGubun();
        
    });

    function fn_CommonPopupModal(sUrl, name, w, h) {	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }
    
	// 선택시
    function fn_Select_CheckGubun() {

    	var select_checkgubun = $("#select_CheckGubun option:selected").val().trim();
    	
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030104.jsp",
            data: "select_CheckGubun="+ select_checkgubun ,
            beforeSend: function () {
                $("#select_CheckGubun_Mid_td").children().remove();
            },
            success: function (html) {
                $("#select_CheckGubun_Mid_td").hide().html(html).fadeIn(100);
                fn_Select_CheckGubun_Mid();
            },
            error: function (xhr, option, error) {

            }
    	});
    }
	
	//코드등록_중분류
	function check_code_mid(obj,gubun) {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030111.jsp?check_code=" + "<%=GV_CHECK_GUBUN_CODE%>" + "&check_name=" + "<%=GV_CHECK_GUBUN_NAME%>";
		
		var footer = "";
    	var title = gubun + "코드등록";
    	var heneModal = new HenesysModal2(modalContentUrl, 'auto', title, footer);
    	heneModal.open_modal();
    	
		//pop_fn_popUpScr_nd(modalContentUrl, gubun+"코드등록(S909S030111)", '50%', "40%");
	}
	
	//코드등록_소분류
	function check_code_sm(obj,gubun) {
		
		vCheck_code_mid = $('#select_CheckGubun_Mid_td option:selected').val(); // 벡터 값 가져오는 방법
		vCheck_name_mid = $('#select_CheckGubun_Mid_td option:selected').text(); // 벡터 텍스트 가져오는 방법
		
		if(vCheck_code_mid == undefined){
			alert("먼저 중분류를 등록하여 주세요.");
			return false;
		}
		
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030121.jsp?check_code=" + "<%=GV_CHECK_GUBUN_CODE%>" 
				+ "&check_name=" + "<%=GV_CHECK_GUBUN_NAME%>"
				+ "&check_code_mid=" + vCheck_code_mid
				+ "&check_name_mid=" + vCheck_name_mid
				;		
		
		var footer = "";
		var title = gubun + "코드등록";
		var heneModal = new HenesysModal2(modalContentUrl, 'auto', title, footer);
		heneModal.open_modal();
		
		//pop_fn_popUpScr_nd(modalContentUrl, gubun+"코드등록(S909S030121)", '50%', "40%");
	}

    
</script>

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
		<tr style=" height: 40px; font-weight:900;">
	        <td style="font-weight:900;">체크항목유형</td>
	        <td></td>
	        <td>
				<select class="form-control" id="select_CheckGubun" 
						style="width: 200px; font-weight: 900; font-size:14px; text-align:left" 
						onchange="fn_Select_CheckGubun()" disabled="disabled">
					<%optCode =  (Vector)check_gubunVector.get(0);%>
					<%optName =  (Vector)check_gubunVector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					<%} %>
				</select>
	        </td>
		</tr>
        <tr style=" height: 40px; font-weight:900;">
	        <td style="font-weight:900;">중분류</td>
	        <td></td>
	        <td id ="select_CheckGubun_Mid_td"  style="width: 25%; font-weight: 900; font-size:14px; text-align:left" >
	        <select style="width: 200px; float: left;"><option>----------</option></select>
	        </td>
	        <td><button id="GUBUN_M"  class="btn btn-info" style="width: 100px" onclick="check_code_mid(this,'중분류');">등록</button></td>
	</tr>
       <tr style=" height: 40px; font-weight:900;">
		        <td style="font-weight:900;">소분류</td>
		        <td></td>
		        <td id ="select_CheckGubun_Sm_td"  style="width: 25%; font-weight: 900; font-size:14px; text-align:left"  >
		        <select style="width: 200px; float: left;"><option>----------</option></select>
		        </td>
		        <td><button id="GUBUN_S"  class="btn btn-info" style="width: 100px" onclick="check_code_sm(this,'소분류');">등록</button></td>
		</tr>

        <tr style="font-weight:900; background-color: #fff; height: 40px; display:none;">
            <td style="font-weight:900;">체크문항코드</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangCode" style="width: 200px; float:left" readonly
            		value="자동채번"/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; font-weight:900; height: 40px">
            <td style="font-weight:900;">문항내용</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangNote" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="font-weight:900; background-color: #fff; height: 40px; display:none;">
            <td style="font-weight:900;">문항일련번호</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangSeq" style="width: 200px; float:left" readonly
            		value="자동채번" />
           	</td>
        </tr>

        <tr style=" height: 40px; font-weight:900;">
            <td style="font-weight:900;">표준절차</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_StandardProc" style="width: 200px; float:left"  />
           	</td>
           	<td><input type="checkbox" id="txt_DoubleCheckYN" style="margin-left:5px; float:left;" >Double Check 여부</input></td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px; font-weight:900;">
            <td style="font-weight:900;">표준설정값</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_StandardValue" style="width: 200px; float:left"  />
           	</td>
        </tr>

		<!-- item_cd||'['||item_desc||' : '||item_bigo||']'||'.'||item_seq||'.'||revision_no -->
        <tr style="height: 40px; font-weight:900;">
            <td style="font-weight:900;">항목코드</td>
            <td></td>
            <td >
            	<select class="form-control" id="select_ItemCode" style="width: 200px">
	            	<%	optCodeCode =  (Vector)checkItemCodeVector.get(0);%>
	            	<%	optCodeDesc =  (Vector)checkItemCodeVector.get(1);%>
	                <%	optCodeBigo =  (Vector)checkItemCodeVector.get(2);%>
	                <%	optCodeSeq =  (Vector)checkItemCodeVector.get(3);%>
	                <%	optCodeRev =  (Vector)checkItemCodeVector.get(4);%>
	                <%for(int i=0; i<optCodeCode.size();i++){ %>
						<option value='<%=optCodeCode.get(i).toString()%>|<%=optCodeSeq.get(i).toString()%>|<%=optCodeRev.get(i).toString()%>' >
							<%=optCodeDesc.get(i).toString()%> : <%=optCodeBigo.get(i).toString()%>
						</option>
					<%} %>
				</select>
            </td>
        </tr>


        <tr style="background-color: #fff; height: 40px; display:none; font-weight:900;">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px; font-weight:900;">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;">
           	</td>
        </tr>
    </table>