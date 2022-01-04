<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/>
    <title>팝빌 SDK jsp Example.</title>
</head>
<body>
<div id="content">
    <p class="heading1">팝빌 현금영수증 SDK jsp Example.</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>현금영수증 발행</legend>
        <ul>
            <li><a href="popbill/CashbillService/checkMgtKeyInUse.jsp">checkMgtKeyInUse</a> - 문서번호 확인</li>
            <li><a href="popbill/CashbillService/registIssue.jsp">registIssue</a> - 즉시발행</li>
            <li><a href="popbill/CashbillService/register.jsp">register</a> - 임시저장</li>
            <li><a href="popbill/CashbillService/update.jsp">update</a> - 수정</li>
            <li><a href="popbill/CashbillService/issue.jsp">issue</a> - 발행</li>
            <li><a href="popbill/CashbillService/cancelIssue.jsp">cancelIssue</a> - 발행취소</li>
            <li><a href="popbill/CashbillService/delete.jsp">delete</a> - 삭제</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>취소현금영수증 발행</legend>
        <ul>
            <li><a href="popbill/CashbillService/revokeRegistIssue.jsp">revokeRegistIssue</a> - 즉시발행</li>
            <li><a href="popbill/CashbillService/revokeRegistIssue_part.jsp">revokeRegistIssue_part</a> - 부분) 즉시발행</li>
            <li><a href="popbill/CashbillService/revokeRegister.jsp">revokeRegister</a> - 임시저장</li>
            <li><a href="popbill/CashbillService/revokeRegister_part.jsp">revokeRegister_part</a> - 부분) 임시저장</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>현금영수증 정보확인</legend>
        <ul>
            <li><a href="popbill/CashbillService/getInfo.jsp">getInfo</a> - 상태확인</li>
            <li><a href="popbill/CashbillService/getInfos.jsp">getInfos</a> - 상태 대량 확인</li>
            <li><a href="popbill/CashbillService/getDetailInfo.jsp">getDetailInfo</a> - 상세정보 확인</li>
            <li><a href="popbill/CashbillService/search.jsp">search</a> - 목록 조회</li>
            <li><a href="popbill/CashbillService/getLogs.jsp">getLogs</a> - 상태 변경이력 확인</li>
            <li><a href="popbill/CashbillService/getURL.jsp">getURL</a> - 현금영수증 문서함 관련 URL</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>현금영수증 보기/인쇄</legend>
        <ul>
            <li><a href="popbill/CashbillService/getPopUpURL.jsp">getPopUpURL</a> - 현금영수증 보기 URL</li>
            <li><a href="popbill/CashbillService/getPrintURL.jsp">getPrintURL</a> - 현금영수증 인쇄 URL</li>
            <li><a href="popbill/CashbillService/getMassPrintURL.jsp">getMassPrintURL</a> - 현금영수증 대량 인쇄 URL</li>
            <li><a href="popbill/CashbillService/getMailURL.jsp">getMailURL</a> - 현금영수증 메일링크 URL</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>부가기능</legend>
        <ul>
            <li><a href="popbill/CashbillService/getAccessURL.jsp">getAccessURL</a> - 팝빌 로그인 URL</li>
            <li><a href="popbill/CashbillService/sendEmail.jsp">sendEmail</a> - 메일 전송</li>
            <li><a href="popbill/CashbillService/sendSMS.jsp">sendSMS</a> - 문자 전송</li>
            <li><a href="popbill/CashbillService/sendFAX.jsp">sendFAX</a> - 팩스 전송</li>
            <li><a href="popbill/CashbillService/listEmailConfig.jsp">listEmailConfig</a> - 현금영수증 알림메일 전송목록 조회</li>
            <li><a href="popbill/CashbillService/updateEmailConfig.jsp">updateEmailConfig</a> - 현금영수증 알림메일 전송설정 수정</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>포인트관리</legend>
        <ul>
            <li><a href="popbill/CashbillService/getBalance.jsp">getBalance</a> - 연동회원 잔여포인트 확인</li>
            <li><a href="popbill/CashbillService/getChargeURL.jsp">getChargeURL</a> - 연동회원 포인트충전 URL</li>
            <li><a href="popbill/CashbillService/getPartnerBalance.jsp">getPartnerBalance</a> - 파트너 잔여포인트 확인</li>
            <li><a href="popbill/CashbillService/getPartnerURL.jsp">getPartnerURL</a> - 파트너 포인트충전 URL</li>
            <li><a href="popbill/CashbillService/getUnitCost.jsp">getUnitCost</a> - 발행 단가 확인</li>
            <li><a href="popbill/CashbillService/getChargeInfo.jsp">getChargeInfo</a> - 과금정보 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>회원정보</legend>
        <ul>
            <li><a href="popbill/CashbillService/checkIsMember.jsp">checkIsMember</a> - 연동회원 가입여부 확인</li>
            <li><a href="popbill/CashbillService/checkID.jsp">checkID</a> - 아이디 중복 확인</li>
            <li><a href="popbill/CashbillService/joinMember.jsp">joinMember</a> - 연동회원 신규가입</li>
            <li><a href="popbill/CashbillService/getCorpInfo.jsp">getCorpInfo</a> - 회사정보 확인</li>
            <li><a href="popbill/CashbillService/updateCorpInfo.jsp">updateCorpInfo</a> - 회사정보 수정</li>
            <li><a href="popbill/CashbillService/registContact.jsp">registContact</a> - 담당자 등록</li>
            <li><a href="popbill/CashbillService/listContact.jsp">listContact</a> - 담당자 목록 확인</li>
            <li><a href="popbill/CashbillService/updateContact.jsp">updateContact</a> - 담당자 정보 수정</li>
        </ul>
    </fieldset>
</div>
</body>
</html>
