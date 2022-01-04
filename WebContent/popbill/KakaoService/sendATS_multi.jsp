<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- HENESYS -->
<%@ page language="java" import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@page import="org.json.simple.JSONObject"%>
<!-- HENESYS END -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!--     <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> -->
<!--     <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/> -->
<!--     <title>팝빌 SDK jsp Example.</title> -->

<!-- 	 favicon.ico 404에러 방지 -->
		 <link rel="shortcut icon" href="#">
</head>

<%@ include file="common.jsp" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.popbill.api.kakao.KakaoReceiver" %>
<%@page import="com.popbill.api.PopbillException" %>
<%@page import="com.popbill.api.kakao.KakaoButton" %>

<%
	DoyosaeTableModel TableModel, TableModel2;
	MakeGridData makeGridData;
// 	String loginID = session.getAttribute("login_id").toString();
// 	String member_key = session.getAttribute("member_key").toString();
	
// 	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
// 		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
// 	}
	
	String GV_PID="", GV_PARM="";
	
	if(request.getParameter("pid") != null)
		GV_PID = request.getParameter("pid");	
	
	if(request.getParameter("bomdata") != null)
		GV_PARM = request.getParameter("bomdata");
	
	JSONObject jArray = new JSONObject();
// 	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M000S100000E992", jArray);
	
	TableModel2 = new DoyosaeTableModel("M909S080100E404", jArray);
	
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(TableModel2.getVector());
	
	int RowCount = TableModel.getRowCount();
	int RowCount2 = TableModel2.getRowCount();
	int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
	
	Vector targetVector = (Vector)(TableModel.getVector().get(0));
	
	String censor_name = "", censor_value = "", min_value = "", max_value = "", ex_censor_value= "", hp_no = "";
	
	
%>

<%
    /*
     * [대량전송] 알림톡 전송을 요청합니다.
     * 사전에 승인된 템플릿의 내용과 알림톡 전송내용(content)이 다를 경우 전송실패 처리됩니다.
     * - https://docs.popbill.com/kakao/java/api#SendATS_multi
     */
    
    // 팝빌회원 사업자번호
    String testCorpNum = "2048603879";

    // 알림톡 템플릿코드
    // 승인된 알림톡 템플릿 코드는 ListATStemplate API, GetATSTemplateMgtURL API, 또는 팝빌사이트에서 확인 가능합니다.
    String templateCode = "021070000031";

    String content = "";
    
  	//발신번호 (팝빌에 등록된 발신번호만 이용가능)
//  String senderNum = "01079007349"; 
	String senderNum = "01055035027"; 
//	String senderNum = "01027347703";

    // 대체문자 유형 [공백-미전송, C-알림톡내용, A-대체문자내용]
    String altSendType = "C";

    KakaoReceiver[] receivers = new KakaoReceiver[RowCount2]; //알림톡 받을 인원수만큼
    
 	// 예약일시 (작성형식 : yyyyMMddHHmmss)
    String sndDT = "";

    // 전송요청번호
    // 파트너가 전송 건에 대해 관리번호를 구성하여 관리하는 경우 사용.
    // 1~36자리로 구성. 영문, 숫자, 하이픈(-), 언더바(_)를 조합하여 팝빌 회원별로 중복되지 않도록 할당.
    String requestNum = "";

    // 팝빌회원 아이디
    String testUserID = "ckbaengi";
     

    // 접수번호
    String receiptNum = null;

    // 알림톡 버튼정보를 템플릿 신청시 기재한 버튼정보와 동일하게 전송하는 경우 null 처리.
    KakaoButton[] btns = null;
 	// 알림톡 버튼 URL에 #{템플릿변수}를 기재한경우 템플릿변수 영역을 변경하여 버튼정보 구성
    // KakaoButton[] btns = new KakaoButton[1];
    //
    // KakaoButton button = new KakaoButton();
    // button.setN("버튼명"); // 버튼명
    // button.setT("WL"); // 버튼타입
    // button.setU1("https://www.popbill.com"); // 버튼링크1
    // button.setU2("http://test.popbill.com"); // 버튼링크2
    // btns[0] = button;
    // 알림톡 내용 (최대 1000자)
    
    for(int i=0; i<TableModel.getRowCount(); i++) {
   		censor_name = TableModel.getValueAt(i,0).toString().trim();
   		censor_value = TableModel.getValueAt(i,1).toString().trim();
   		//.substring(0, TableModel.getValueAt(i,1).toString().trim().indexOf("."));
   		min_value = TableModel.getValueAt(i,2).toString().trim();
   		max_value = TableModel.getValueAt(i,3).toString().trim();
   		ex_censor_value = TableModel.getValueAt(i, 4).toString().trim();
   		
   		//censor_value가 min_value보다 작으면 1 크면 -1 동일하면 0 
   		String re = String.valueOf(Float.valueOf(min_value).compareTo(Float.valueOf(censor_value)));
   		//두 번째 시간 최대값
   		String ex = String.valueOf(Float.valueOf(min_value).compareTo(Float.valueOf(ex_censor_value)));
   		
   		//한계기준이탈시 re만 사용, 한계기준 두 번 연속 이탈시 ex까지 사용
   		if(re.equals("1") && ex.equals("1")){
   			content = "기준온도 이탈이 발생했습니다.\n";
		    content += "작업장명 : "+censor_name+"\n";
		    content += "한계기준 : "+min_value+"°C ~ "+max_value+"°C\n";
		    content += "센서데이터 : "+censor_value+"°C";
		    
		    System.out.println(content);
	    }
	    // 1회 최대 전송 1,000건 전송 가능
   		for(int j = 0; j <TableModel2.getRowCount(); j++){
   	    	
   			hp_no = TableModel2.getValueAt(j,1).toString().trim().replace("-", ""); 
   			  
   			if(re.equals("1") && ex.equals("1")){
   			        KakaoReceiver message = new KakaoReceiver();
   			        message.setReceiverNum(hp_no);
   			        message.setReceiverName("수신자명" + i);
   			        message.setMessage(content);
   			        message.setAltMessage("대체문자 내용" + i);
   			        receivers[j] = message;
   	    	}
   			
   		}
    	
    	try {
        		censor_name = TableModel.getValueAt(i,0).toString().trim();
        		censor_value = TableModel.getValueAt(i,1).toString().trim();
        		//.substring(0, TableModel.getValueAt(i,1).toString().trim().indexOf("."));
        		min_value = TableModel.getValueAt(i,2).toString().trim();
        		max_value = TableModel.getValueAt(i,3).toString().trim();
        		ex_censor_value = TableModel.getValueAt(i,4).toString().trim();
        		
        		if(re.equals("1") && ex.equals("1")){
    					receiptNum = kakaoService.sendATS(testCorpNum, templateCode, senderNum, altSendType,
    					          receivers, sndDT, testUserID, requestNum, btns);
        		}
        } catch (PopbillException pe) {
            //적절한 오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
            //예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
            throw pe;
        }

    }
%>
<body>
<div id="content">
    <p class="heading1">Response</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>알림톡 전송</legend>
        <ul>
            <li>접수번호 : <%=receiptNum%></li>
        </ul>
    </fieldset>
</div>
</body>
</html>