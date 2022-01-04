<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/>
    <title>팝빌 SDK jsp Example.</title>
</head>
<body>
<div id="content">
    <p class="heading1">팝빌 전자명세서 SDK jsp Example.</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>전자명세서 발행</legend>
        <ul>
            <li><a href="popbill/StatementService/checkMgtKeyInUse.jsp">checkMgtKeyInUse</a> - 문서번호 확인</li>
            <li><a href="popbill/StatementService/registIssue.jsp">registIssue</a> - 즉시 발행</li>
            <li><a href="popbill/StatementService/register.jsp">register</a> - 임시저장</li>
            <li><a href="popbill/StatementService/update.jsp">update</a> - 수정</li>
            <li><a href="popbill/StatementService/issue.jsp">issue</a> - 발행</li>
            <li><a href="popbill/StatementService/cancel.jsp">cancel</a> - 발행취소</li>
            <li><a href="popbill/StatementService/delete.jsp">delete</a> - 삭제</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>전자명세서 정보확인</legend>
        <ul>
            <li><a href="popbill/StatementService/getInfo.jsp">getInfo</a> - 상태 확인</li>
            <li><a href="popbill/StatementService/getInfos.jsp">getInfos</a> - 상태 대량 확인</li>
            <li><a href="popbill/StatementService/getDetailInfo.jsp">getDetailInfo</a> - 상세정보 확인</li>
            <li><a href="popbill/StatementService/search.jsp">search</a> - 목록 조회</li>
            <li><a href="popbill/StatementService/getLogs.jsp">getLogs</a> - 상태 변경이력 확인</li>
            <li><a href="popbill/StatementService/getURL.jsp">getURL</a> - 전자명세서 문서함 관련 URL</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>전자명세서 보기/인쇄</legend>
        <ul>
            <li><a href="popbill/StatementService/getPopUpURL.jsp">getPopUpURL</a> - 전자명세서 보기 URL</li>
            <li><a href="popbill/StatementService/getPrintURL.jsp">getPrintURL</a> - 전자명세서 인쇄 [공급자] URL</li>
            <li><a href="popbill/StatementService/getEPrintURL.jsp">getEPrintURL</a> - 전자명세서 인쇄 [공급받는자용] URL</li>
            <li><a href="popbill/StatementService/getMassPrintURL.jsp">getMassPrintURL</a> - 전자명세서 대량 인쇄 URL</li>
            <li><a href="popbill/StatementService/getMailURL.jsp">getMailURL</a> - 전자명세서 메일링크 URL</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>부가기능</legend>
        <ul>
            <li><a href="popbill/StatementService/getAccessURL.jsp">getAccessURL</a> - 팝빌 로그인 URL</li>
            <li><a href="popbill/StatementService/attachFile.jsp">attachFile</a> - 첨부파일 추가</li>
            <li><a href="popbill/StatementService/deleteFile.jsp">deleteFile</a> - 첨부파일 삭제</li>
            <li><a href="popbill/StatementService/getFiles.jsp">getFiles</a> - 첨부파일 목록 확인</li>
            <li><a href="popbill/StatementService/sendEmail.jsp">sendEmail</a> - 메일 전송</li>
            <li><a href="popbill/StatementService/sendSMS.jsp">sendSMS</a> - 문자 전송</li>
            <li><a href="popbill/StatementService/sendFAX.jsp">sendFAX</a> - 팩스 전송</li>
            <li><a href="popbill/StatementService/FAXSend.jsp">FAXSend</a> - 선팩스 전송</li>
            <li><a href="popbill/StatementService/attachStatement.jsp">attachStatement</a> - 전자명세서 첨부</li>
            <li><a href="popbill/StatementService/detachStatement.jsp">detachStatement</a> - 전자명세서 첨부해제</li>
            <li><a href="popbill/StatementService/listEmailConfig.jsp">listEmailConfig</a> - 전자명세서 알림메일 전송목록 조회</li>
            <li><a href="popbill/StatementService/updateEmailConfig.jsp">updateEmailConfig</a> - 전자명세서 알림메일 전송설정 수정</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>포인트관리</legend>
        <ul>
            <li><a href="popbill/StatementService/getBalance.jsp">getBalance</a> - 연동회원 잔여포인트 확인</li>
            <li><a href="popbill/StatementService/getChargeURL.jsp">getChargeURL</a> - 연동회원 포인트충전 URL</li>
            <li><a href="popbill/StatementService/getPartnerBalance.jsp">getPartnerBalance</a> - 파트너 잔여포인트 확인</li>
            <li><a href="popbill/StatementService/getPartnerURL.jsp">getPartnerURL</a> - 파트너 포인트충전 URL</li>
            <li><a href="popbill/StatementService/getUnitCost.jsp">getUnitCost</a> - 발행 단가 확인</li>
            <li><a href="popbill/StatementService/getChargeInfo.jsp">getChargeInfo</a> - 과금정보 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>회원정보</legend>
        <ul>
            <li><a href="popbill/StatementService/checkIsMember.jsp">checkIsMember</a> - 연동회원 가입여부 확인</li>
            <li><a href="popbill/StatementService/checkID.jsp">checkID</a> - 아이디 중복 확인</li>
            <li><a href="popbill/StatementService/joinMember.jsp">joinMember</a> - 연동회원 신규가입</li>
            <li><a href="popbill/StatementService/getCorpInfo.jsp">getCorpInfo</a> - 회사정보 확인</li>
            <li><a href="popbill/StatementService/updateCorpInfo.jsp">updateCorpInfo</a> - 회사정보 수정</li>
            <li><a href="popbill/StatementService/registContact.jsp">registContact</a> - 담당자 등록</li>
            <li><a href="popbill/StatementService/listContact.jsp">listContact</a> - 담당자 목록 확인</li>
            <li><a href="popbill/StatementService/updateContact.jsp">updateContact</a> - 담당자 정보 수정</li>
        </ul>
    </fieldset>
</div>
</body>
</html>
