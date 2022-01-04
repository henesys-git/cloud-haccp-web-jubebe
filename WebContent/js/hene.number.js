/**
 * 숫자 처리 관련 기능 모음
 */

function convertPlusToMinus(num) {
	num = (num > 0) ? num * -1 : false;
	return num;
}

function convertMinusToPlus(num) {
	num = (num < 0) ? num * -1 : false;
	return num;
}

// 기능 :3자리 수마다 콤마 추가
function addComma(num) {
	if(typeof num === 'undefined') {
		return '';
	}

	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function removeComma(num) {
	if(typeof num === 'undefined') {
		console.error(num + 'is undefined');
		return '';
	}
	
	if(typeof num === 'string' || num instanceof String) {
		return parseFloat(num.replace(/,/g, ''));	
	} else {
		console.error(num + 'is not string');
		return '';
	}

}

//숫자에 지정된 자리수 만큼 0을 붙여준다.
function numpad(num, width) {
  num = num + '';
  return num.length >= width ? num : new Array(width - num.length + 1).join('0') + num;
}
