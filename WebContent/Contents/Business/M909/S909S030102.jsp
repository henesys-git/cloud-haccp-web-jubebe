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
    Vector check_gubunVector = CommonData.getChecklistGubun_CodeALL(member_key);
//    Vector optCodeSeq =  null;
//    Vector optCodeName =  null;
//    Vector optCodeRevNo =  null;
    // 특정 item_cd에 대한 SEQ의 값 
    // M909S030100E314에서 쿼리한다.
//    Vector checkItemCodeSeqVector = CommonData.getCheckItemSeq4Code("CHK-001");

	String[] strColumnHead = {"", "", "", "", "", "", "", "", "", "", "" };
	
	String GV_CHECKGUBUN_MID = "";
	String GV_CHECKGUBUN_SM = "";
	
	String GV_CHECKLIST_CD= "";
	String GV_CHECKLIST_SEQ= "";
	String GV_CHECKLIST_REVNO= "";
	String GV_ITEM_CD= "";
	String GV_ITEM_SEQ= "";
	String GV_ITEM_REVNO= "";
	String GV_CHECKGUBUN= "";

	if(request.getParameter("CheckGubunMid")== null)
		GV_CHECKGUBUN_MID="";
	else
		GV_CHECKGUBUN_MID = request.getParameter("CheckGubunMid");
	if(request.getParameter("CheckGubunSm")== null)
		GV_CHECKGUBUN_SM="";
	else
		GV_CHECKGUBUN_SM = request.getParameter("CheckGubunSm");


	if(request.getParameter("CheckListCd")== null)
		GV_CHECKLIST_CD="";
	else
		GV_CHECKLIST_CD = request.getParameter("CheckListCd");

	if(request.getParameter("CheckListSeq")== null)
		GV_CHECKLIST_SEQ="";
	else
		GV_CHECKLIST_SEQ = request.getParameter("CheckListSeq");

	if(request.getParameter("RevisionNo")== null)
		GV_CHECKLIST_REVNO="";
	else
		GV_CHECKLIST_REVNO = request.getParameter("RevisionNo");

	if(request.getParameter("ItemCd")== null)
		GV_ITEM_CD="";
	else
		GV_ITEM_CD = request.getParameter("ItemCd");

	if(request.getParameter("ItemSeq")== null)
		GV_ITEM_SEQ="";
	else
		GV_ITEM_SEQ = request.getParameter("ItemSeq");

	if(request.getParameter("ItemRevNo")== null)
		GV_ITEM_REVNO="";
	else
		GV_ITEM_REVNO = request.getParameter("ItemRevNo");
	
	if(request.getParameter("CheckGubun")== null)
		GV_CHECKGUBUN="";
	else
		GV_CHECKGUBUN = request.getParameter("CheckGubun");
	

	String param = GV_CHECKLIST_CD + "|" + GV_CHECKLIST_SEQ + "|" + GV_CHECKLIST_REVNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);

	jArray.put( "Check_Gubun", GV_CHECKGUBUN);
	jArray.put( "Check_Gubun_Mid", GV_CHECKGUBUN_MID);
	jArray.put( "Check_Gubun_Sm", GV_CHECKGUBUN_SM);
	jArray.put( "CHECKLIST_CD", GV_CHECKLIST_CD);
	jArray.put( "CHECKLIST_SEQ", GV_CHECKLIST_SEQ);
	jArray.put( "CHECKLIST_REVNO", GV_CHECKLIST_REVNO);
		
    TableModel = new DoyosaeTableModel("M909S030100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetVector = (Vector)(TableModel.getVector().get(0));

    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( targetVector.get(6).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
		
%>

<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S030100E102 = {
			PID: "M909S030100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S030100E102",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

// 체크항목 분할변수
    var docGubunCode = "";
    var JOB_GUBUN = "";
    
	function SetRecvData(){
		DataPars(M909S030100E102, GV_RECV_DATA);
 		if(M909S030100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
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
   			//dataJson.MunhangCode = $('#select_CheckGubun').val() + "-" + $('#select_CheckGubun_Mid').val() + "-" + $('#select_CheckGubun_Sm').val();
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
   			dataJson.RevisionNo_Target = "<%=targetVector.get(6).toString() %>";
   			
   			var chekrtn = confirm("수정하시겠습니까?"); 
   			
   			if(chekrtn){       
		    	SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터 묶음 하나일때 => Object하나만
   			}
   	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('수정에 성공하였습니다.');
	        		parent.$("#select_check_gubun").val( $("#select_CheckGubun").val() ); // 등록완료 후 메인화면 구분을 등록한 구분으로 바꿔주기
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide'); 
	         	}
	        	 else{
	        		 heneSwal.error('수정에 실패하였습니다. 다시 시도해주세요.');	 
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	// 특정 로우를 선택하고 들어오면... 그 문항코드를 뿌려준다...
    	$('#txt_MunhangCode').val("<%=GV_CHECKLIST_CD%>");

        new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date("<%=targetVector.get(10).toString()%>");
	    
		var double_check_yn = "<%=targetVector.get(17).toString()%>";
	    
	    if(double_check_yn == "Y") $("#txt_DoubleCheckYN").prop("checked",true);
	    else if(double_check_yn == "N") $("#txt_DoubleCheckYN").prop("checked",false);
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
        <tr style="height: 40px">
		        <td style="font-weight:900;">체크항목유형</td>
		        <td></td>
		        <td >
					<select class="form-control" id="select_CheckGubun"
							name="select_CheckGubun" style="width: 200px"
							onchange="select_CheckGubun" disabled="disabled">
						<%
							optCode = (Vector) check_gubunVector.get(0);
							optName = (Vector) check_gubunVector.get(1);
	
							for (int i = 0; i < optName.size(); i++) {
								if (optCode.get(i).equals(GV_CHECKGUBUN)) {
						%>
						<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%>
						</option>
						<%
								} else {
						%>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						<%
								}
							}
						%>
					</select>
		        </td>
		    </tr>

        <tr style="height: 40px">
		        <td style="font-weight:900;">중분류</td>
		        <td></td>
		        <td id ="select_CheckGubun_Mid_td" >
		        <select class="form-control" id="select_CheckGubun_Mid" style="width: 200px" onchange="fn_Select_CheckGubun_Mid()" disabled="disabled">
            		<option value='<%=targetVector.get(18).toString()%>'><%=targetVector.get(19).toString()%></option>
		        </select>
		        </td>
		</tr>
        <tr style="height: 40px">
		        <td style="font-weight:900;">소분류</td>
		        <td></td>
				<td id ="select_CheckGubun_Sm_td">
				<select class="form-control" id="select_CheckGubun_Sm" style="width: 200px" onchange="fn_Select_CheckGubun_Sm()" disabled="disabled"> 
            		<option value='<%=targetVector.get(20).toString()%>'><%=targetVector.get(21).toString()%></option>
            	</select>	
		        </td>
		</tr>
        
        <tr style="background-color: #fff; height: 40px; display:none;">
            <td style="font-weight:900;">체크문항코드</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangCode" style="width: 200px; float:left" 
            		value="<%=targetVector.get(1).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문항내용</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangNote" style="width: 200px; float:left" 
            		value="<%=targetVector.get(3).toString()%>"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px; display:none;">
            <td style="font-weight:900;">문항일련번호</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_MunhangSeq" style="width: 200px; float:left" 
            		value="<%=targetVector.get(2).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">표준절차</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_StandardProc" style="width: 200px; float:left" 
            		value="<%=targetVector.get(4).toString()%>"  />
            	<input type="checkbox" id="txt_DoubleCheckYN" style="margin-left:5px; float:left;" >Double Check 여부</input>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">표준설정값</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_StandardValue" style="width: 200px; float:left" 
            		value="<%=targetVector.get(5).toString()%>"  />
           	</td>
        </tr>

		<!-- item_cd||'['||item_desc||' : '||item_bigo||']'||'.'||item_seq||'.'||revision_no -->
        <tr style="height: 40px">
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
	                	<%if( optCodeCode.get(i).toString().equals(targetVector.get(5).toString())
	                		&& optCodeSeq.get(i).toString().equals(targetVector.get(6).toString()) ) { %>
						<option value='<%=optCodeCode.get(i).toString()%>|<%=optCodeSeq.get(i).toString()%>|<%=optCodeRev.get(i).toString()%>' selected="selected">
							<%=optCodeDesc.get(i).toString()%> : <%=optCodeBigo.get(i).toString()%>
						</option>
						<%} else { %>
						<option value='<%=optCodeCode.get(i).toString()%>|<%=optCodeSeq.get(i).toString()%>|<%=optCodeRev.get(i).toString()%>' >
							<%=optCodeDesc.get(i).toString()%> : <%=optCodeBigo.get(i).toString()%>
						</option>
						<%} %>
					<%} %>
				</select>
            </td>
        </tr>


        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" 
            		value="<%=revisionNumberStr%>" readonly />
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