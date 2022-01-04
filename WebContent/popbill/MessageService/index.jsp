<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/>
    <title>팝빌 SDK jsp Example.</title>
</head>
<body>
<div id="content">
    <p class="heading1">팝빌 문자 API SDK jsp Example.</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>발신번호 사전등록</legend>
        <ul>
            <li><a href="popbill/MessageService/getSenderNumberMgtURL.jsp">getSenderNumberMgtURL</a> - 발신번호 관리 팝업 URL</li>
            <li><a href="popbill/MessageService/getSenderNumberList.jsp">getSenderNumberList</a> - 발신번호 목록 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>문자 전송</legend>
        <ul>
            <li><a href="popbill/MessageService/sendSMS.jsp">sendSMS</a> - 단문 전송</li>
            <li><a href="popbill/MessageService/sendSMS_Multi.jsp">sendSMS</a> - 단문 전송 [대량]</li>
            <li><a href="popbill/MessageService/sendLMS.jsp">sendLMS</a> - 장문 전송</li>
            <li><a href="popbill/MessageService/sendLMS_Multi.jsp">sendLMS</a> - 장문 전송 [대량]</li>
            <li><a href="popbill/MessageService/sendMMS.jsp">sendMMS</a> - 포토 전송</li>
            <li><a href="popbill/MessageService/sendMMS_Multi.jsp">sendMMS</a> - 포토 전송 [대량]</li>
            <li><a href="popbill/MessageService/sendXMS.jsp">sendXMS</a> - 단문/장문 자동인식 전송</li>
            <li><a href="popbill/MessageService/sendXMS_Multi.jsp">sendXMS</a> - 단문/장문 자동인식 전송 [대량]</li>
            <li><a href="popbill/MessageService/getMessages.jsp">getMessages</a> - 전송내역 확인</li>
            <li><a href="popbill/MessageService/getMessagesRN.jsp">getMessagesRN</a> - 전송내역 확인 (요청번호 할당)</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>정보확인</legend>
        <ul>
            <li><a href="popbill/MessageService/cancelReserve.jsp">cancelReserve</a> - 예약전송 취소</li>
            <li><a href="popbill/MessageService/cancelReserveRN.jsp">cancelReserveRN</a> - 예약전송 취소 (요청번호 할당)</li>
            <li><a href="popbill/MessageService/search.jsp">search</a> - 전송내역 목록 조회</li>
            <li><a href="popbill/MessageService/getStates.jsp">getStates</a> - 문자메세지 전송요약정보 확인</li>
            <li><a href="popbill/MessageService/getSentListURL.jsp">getSentListURL</a> - 문자 전송내역 팝업 URL</li>
            <li><a href="popbill/MessageService/getAutoDenyList.jsp">getAutoDenyList</a> - 080 수신거부 목록 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>포인트 관리</legend>
        <ul>
            <li><a href="popbill/MessageService/getBalance.jsp">getBalance</a> - 연동회원 잔여포인트 확인</li>
            <li><a href="popbill/MessageService/getChargeURL.jsp">getChargeURL</a> - 연동회원 포인트충전 URL</li>
            <li><a href="popbill/MessageService/getPartnerBalance.jsp">getPartnerBalance</a> - 파트너 잔여포인트 확인</li>
            <li><a href="popbill/MessageService/getPartnerURL.jsp">getPartnerURL</a> - 파트너 포인트충전 URL</li>
            <li><a href="popbill/MessageService/getChargeInfo.jsp">getChargeInfo</a> - 과금정보 확인</li>
            <li><a href="popbill/MessageService/getUnitCost.jsp">getUnitCost</a> - 전송 단가 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>회원정보</legend>
        <ul>
            <li><a href="popbill/MessageService/checkIsMember.jsp">checkIsMember</a> - 연동회원 가입여부 확인</li>
            <li><a href="popbill/MessageService/checkID.jsp">checkID</a> - 아이디 중복 확인</li>
            <li><a href="popbill/MessageService/joinMember.jsp">joinMember</a> - 연동회원 신규가입</li>
            <li><a href="popbill/MessageService/getAccessURL.jsp">getAccessURL</a> - 팝빌 로그인 URL</li>
            <li><a href="popbill/MessageService/registContact.jsp">registContact</a> - 담당자 등록</li>
            <li><a href="popbill/MessageService/listContact.jsp">listContact</a> - 담당자 목록 확인</li>
            <li><a href="popbill/MessageService/updateContact.jsp">updateContact</a> - 담당자 정보 수정</li>
            <li><a href="popbill/MessageService/getCorpInfo.jsp">getCorpInfo</a> - 회사정보 확인</li>
            <li><a href="popbill/MessageService/updateCorpInfo.jsp">updateCorpInfo</a> - 회사정보 수정</li>
        </ul>
    </fieldset>
</div>
</body>
</html>
