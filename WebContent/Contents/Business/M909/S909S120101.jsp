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
	
    String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String  GV_PROCESS_GUBUN = "";
	String  GV_PROCESS_GUBUN_BIG = "";
	String  GV_PROCESS_GUBUN_MID = "";
	
	Vector optCode =  null;
    Vector optName =  null;
    
    Vector optBigCode =  null;
    Vector optBigName =  null;
    
    Vector optMidCode =  null;
    Vector optMidName =  null;
    
    String Process_Gubun_Code_Name = "";
	
	if(request.getParameter("Process_gubun") == null)
		GV_PROCESS_GUBUN = "";
	else
		GV_PROCESS_GUBUN = request.getParameter("Process_gubun");
	
	if(request.getParameter("Process_gubun_big") == null)
		GV_PROCESS_GUBUN_BIG = "";
	else
		GV_PROCESS_GUBUN_BIG = request.getParameter("Process_gubun_big");
	
	Vector Process_Gubun_Vector = CommonData.getProcess_gubun(member_key);
	Vector Process_Gubun_Big_Vector = CommonData.getProcess_gubun_big(GV_PROCESS_GUBUN,member_key);

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROCESS_GUBUN", GV_PROCESS_GUBUN);
	jArray.put( "PROCESS_GUBUN_BIG", GV_PROCESS_GUBUN_BIG);
	
    DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M909S120100E994");
    
    Vector max_process_seq = dbServletLink.doQuery(jArray, false);
    
	String max_process_seq_str = ((Vector)(max_process_seq.get(0))).get(0).toString();
    
    System.out.println("공정코드 시리얼넘버 : " + max_process_seq_str);
	
%>
        
    <script type="text/javascript">	

    var groupCodeGubun = "";
	
	function SaveOderInfo() {
		if ($('#txt_ProcName').val().length < 1) {
			heneSwal.warning("공정코드를 입력하세요.");
			return;
		}
		
		var proc_code_gb_mid_str = "";
		proc_code_gb_mid_split = ($('#txt_ProcCd').val()).split('-');
		
		console.log("proc_code_gb_mid_split[0] : " + proc_code_gb_mid_split[0]);
		console.log("proc_code_gb_mid_split[1] : " + proc_code_gb_mid_split[1]);
		console.log("proc_code_gb_mid_split[2] : " + proc_code_gb_mid_split[2]);
		console.log("member_key : " + "<%=member_key%>");
		
		var dataJson = new Object();
			dataJson.process_gubun = $('#txt_ProcessGubun').val();									// 공정구분
			dataJson.proc_code_gb_big = $('#txt_ProcessGubun_Big').val();							// 공정대분류코드
			dataJson.proc_cd = $('#txt_ProcCd').val();												// 공정코드
			dataJson.process_nm = $('#txt_ProcName').val();											// 공정코드명
			dataJson.product_process_yn = $('input[name = "product_process_yn"]:checked').val();	// 생산공정 적용여부
			dataJson.packing_process_yn = $('input[name = "packing_process_yn"]:checked').val();	// 포장공정 적용여부
			dataJson.RevisionNo = $('#txt_RevisionNo').val();										// 공정코드개정번호
			dataJson.start_date = $('#txt_StartDate').val();										// 적용시작일자
			dataJson.bigo = $('#txt_Bigo').val();													// 비고
			dataJson.user_id = "<%=loginID%>";														<%--생성담당자--%>
			dataJson.proc_code_gb_mid = proc_code_gb_mid_split[2];									// 중분류코드
			dataJson.member_key = "<%=member_key%>";												<%--멤버키--%>

		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){

			SendTojsp(JSON.stringify(dataJson), "M909S120100E101"); // 보내는 데이터묶음 하나일때 => Object하나만
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
	        		heneSwal.success('정보 등록에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('정보 등록에 실패하였습니다.'); 
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {
		var startDay = new Date();

        new SetSingleDate2("", "#txt_StartDate", 0);   
		
		$("#txt_ProcessGubun").attr("disabled",true);
		$("#txt_ProcessGubun_Big").attr("disabled",true);
		$("#txt_ProcessGubun").val("<%=GV_PROCESS_GUBUN%>");
		$("#txt_ProcessGubun_Big").val("<%=GV_PROCESS_GUBUN_BIG%>");
        
        fn_ProcessGubun_Select();
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  

    function fn_ProcessGubun_Select() {
    	var process_gubun = $("#txt_ProcessGubun").val().trim();
    	
    	if(process_gubun=="LCPROCS") $("#txt_ProcCd").val("L");
    	else if(process_gubun=="PDPROCS") $("#txt_ProcCd").val("P");
    	else if(process_gubun=="QAPROCS") $("#txt_ProcCd").val("R");
    }
    	
   	// 비고 내용 리셋은 한 번만...
   	$("#txt_Bigo").one( "click" , function(){ $("#txt_Bigo").val(""); } );
   	
   	// 바이트 수 체크하는 함수
   	function Byte_Check( text )
   	{
   		var codeByte = 0;
   		
   		for ( var i = 0 ; i < text.length ; i++ )
   		{
   			var oneChar = escape(text.charAt(i));

   			if ( oneChar.length == 1 )
   				codeByte++;
   			else if ( oneChar.indexOf("%u") != -1 )
   				codeByte += 2;
   			else if ( oneChar.indexOf("%") != -1 )
   				codeByte++;
   		}
   		
   		return codeByte;
   	}
   	
   	// 키 입력이 있을 경우 Byte_Check 함수를 이용해 바이트 수 제한 걸기
   	$("#txt_Bigo").keyup(function () {
   		var TEXT_MAX_SIZE = 200;
   		
   		var Bigo_Text = $("#txt_Bigo").val();
   		var Bigo_Text_Size = 0;
   		
   		Bigo_Text_Size = Byte_Check(Bigo_Text);
   		
   		if( Bigo_Text_Size > TEXT_MAX_SIZE )
   		{
   			heneSwal.warning("최대 " + TEXT_MAX_SIZE + " Byte 까지 입력 가능합니다.");
   			
   			$("#txt_Bigo").val(Bigo_Text.substring(0,Bigo_Text.length-1));
   		}
   	}); // 비고 글자 수 제한
   	
   	$("#txt_ProcName").keyup(function () {
   		var TEXT_MAX_SIZE = 20;
   		
   		var Process_Name_Text = $("#txt_ProcName").val();
   		var Process_Name_Text_Size = 0;
   		
   		Process_Name_Text_Size = Byte_Check(Process_Name_Text);
   		
   		if( Process_Name_Text_Size > TEXT_MAX_SIZE )
   		{
   			heneSwal.warning("최대 " + TEXT_MAX_SIZE + " Byte 까지 입력 가능합니다.");
   			
   			$("#txt_ProcName").val(Process_Name_Text.substring(0,Process_Name_Text.length-1));
   		}
   	}); // 공정코드명 글자 수 제한
</script>
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
   		
        <tr style="background-color: #fff; height: 40px">
            <td>공정구분</td>
            <td></td>
            <td>
				<select class="form-control" id="txt_ProcessGubun" style="width: 145px" onchange="fn_ProcessGubun_Select()">
					<%optCode =  (Vector)Process_Gubun_Vector.get(0);%>
					<%optName =  (Vector)Process_Gubun_Vector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						<%} %>
				</select>
           	</td>
            <td>공정대분류코드</td>
            <td> </td>
            <td>
				<select class="form-control" id="txt_ProcessGubun_Big" style="width: 145px" onchange="fn_ProcessGubun_Select()">
					<%optBigCode =  (Vector)Process_Gubun_Big_Vector.get(0);%>
					<%optBigName =  (Vector)Process_Gubun_Big_Vector.get(1);%>
					<%for(int i=0; i<optBigName.size();i++){ %>
						<option value='<%=optBigCode.get(i).toString()%>'><%=optBigName.get(i).toString()%></option>
						<%} %>
				</select>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>공정코드</td>
            <td> </td>
            <td>
           		<input type="text" class="form-control" id="txt_ProcCd" style="width: 145px; float:left" readonly
           				<%Process_Gubun_Code_Name = GV_PROCESS_GUBUN + "-" + GV_PROCESS_GUBUN_BIG + max_process_seq_str; %>
            			value = "<%=Process_Gubun_Code_Name%>"/>
				<!-- <p style="font-size: 12px; clear:both;">코드안의 영문을 지우면 심각한 시스템오류가 발생합니다.</p> -->
           	</td>
            <td>공정코드명</td>
            <td> </td>
            <td>
            	<input type="text" class="form-control" id="txt_ProcName" style="width: 145px; float:left"/>
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>생산공정 적용여부</td>
            <td></td>
            <!-- <td>
				<input type = "radio" class = "form-control" id = "txt_product_process_yn" style = "width: 145px"
						name = "y" value = "적용" onchange = "fn_ProcessGubun_Select()"/>적용
				<input type = "radio" class = "form-control" id = "txt_product_process_yn" style = "width: 145px"
						name = "n" value = "미적용" onchange = "fn_ProcessGubun_Select()"/>미적용
			</td> -->
			<td><input type = "radio" name = "product_process_yn" value="Y"/> 적용</td>
			<td><input type = "radio" name = "product_process_yn" value="N" checked/> 미적용</td>
           	<td colspan = "3"></td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>포장공정 적용여부</td>
            <td></td>
			<td><input type = "radio" name = "packing_process_yn" value="Y"/> 적용</td>
			<td><input type = "radio" name = "packing_process_yn" value="N" checked/> 미적용</td>
           	<td colspan = "3"></td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>공정코드개정번호</td>
            <td> </td>
            <td>
            	<input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 145px; float:left" readonly />
           	</td>
        	<td>적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" id="txt_StartDate" class="form-control" style="width: 145px; border: solid 1px #cccccc;"/>
            		
           	</td>
        </tr>
        
        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="7">비고</td>
        </tr>
        <tr>
            <td colspan="7">
            	<textarea class="form-control" id="txt_Bigo"
							style="cols:40;rows:4;resize: none;width: 100%;">최대 200 Byte 까지 입력 가능합니다.</textarea>
            </td>
        </tr>
    </table>