/**
 * 완제품 조회 관련 함수 모음
 */

/*
	모달창으로 완제품 재고 조회 (생산일자&품목별)
*/
function viewProductStorage(caller) {

	let url = heneServerPath + "/Contents/CommonView/ViewProductStorage.jsp"
			  + "?caller=" + caller;
	let footer = "";
	let title = "완제품 재고 조회";
	
	if(caller == 1) {
		let heneModal = new HenesysModal2(url, 'large', title, footer);
		heneModal.open_modal();
	} else if(caller == 2) {
		let heneModal = new HenesysModal3(url, 'large', title, footer);
		heneModal.open_modal();
	}
}

/*
	모달창으로 완제품 출하 목록 조회
*/
function viewProductChulhaList(chulhaDate, modalLevel) {
	let url = heneServerPath + "/Contents/CommonView/Product/ProdChulhaList.jsp"
			  + "?chulhaDate=" + chulhaDate + "&modalLevel=" + modalLevel;
	let footer = "";
	let title = "완제품 출하 목록 조회";
	
	let heneModal = new HenesysModal2(url, 'large', title, footer);
	heneModal.open_modal();
}