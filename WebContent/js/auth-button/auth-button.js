/**
 * 사용자 권한별 버튼 관리
 * - GRCD00X : DB에 저장된 사용자 그룹별 코드
 * - userGroupCode : DB에서 가져온 로그인 한 사용자의 그룹 코드
 */

// 관리자
if (userGroupCode == "GRCD001") {
	// display buttons for admin, manager, user
	$(".btn-admin").show();
	$(".btn-manager").show();
	$(".btn-user").show();
}

// 일반 사용자
if (userGroupCode == "GRCD002") {
	// display buttons for normal user
	$(".btn-user").show();
	
	// 점검표 승인자 서명 불가
	$(".btn-checklist-approve").prop("disabled", true);
	// 점검표 확인자 서명 불가
	$(".btn-checklist-check").prop("disabled", true);
	// 점검표 점검자 서명 불가
	$(".btn-checklist-confirm").prop("disabled", true);
	
	// 건강검진관리대장 상반기 품질관리팀장 서명불가
	$(".btn-checklist-first-pic").prop("disabled", true);
	// 건강검진관리대장 상반기 HACCP팀장 서명불가
	$(".btn-checklist-first-manager").prop("disabled", true);
	// 건강검진관리대장 하반기 품질관리팀장 서명불가
	$(".btn-checklist-second-pic").prop("disabled", true);
	// 건강검진관리대장 하반기 품질관리팀장 서명불가
	$(".btn-checklist-second-manager").prop("disabled", true);
	
}

//그 외의 사용자
if(userGroupCode == "GRCD003" || userGroupCode == "GRCD009" || userGroupCode == "GRCD010"){
	// 카톡 알람 활성화 기능 사용불가
	$("#customSwitch1").attr("disabled", true);
}