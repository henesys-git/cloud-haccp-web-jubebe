/*! setdate.js
*
*/


function setStyle(id) {
	$('#' + id).css({
		"background": "#fff",
		"cursor": "pointer",
		"padding": "5px 10px",
		"border": "1px solid #ccc",
		"width": "100%"
	});
}

function SetRangeDate(divId, inputId, adjustDate) {
	setStyle(divId);
	
	this.start = moment().subtract(adjustDate, 'days');
	this.end = moment();
	
	this.getStartDate = function() {
		var dates = this.rangedate[0].value;
    	var startDate = dates.split(" - ")[0];
    	return startDate;
	};
	
	this.getEndDate = function() {
		var dates = this.rangedate[0].value;
    	var endDate = dates.split(" - ")[1];
    	return endDate;
	};
	
	this.rangedate = $('#' + inputId).daterangepicker({
	    startDate: moment().subtract(adjustDate, 'days'),
	    endDate: moment(),
	    ranges: {
	       '오늘': [moment(), moment()],
	       '어제': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	       '지난 7일간': [moment().subtract(6, 'days'), moment()],
	       '지난 30일간': [moment().subtract(29, 'days'), moment()],
	       '이번 달': [moment().startOf('month'), moment().endOf('month')],
	       '지난 달': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	    },
	    "locale": {
	        "format": "YYYY-MM-DD",
	        "separator": " - ",
	        "applyLabel": "적용",
	        "cancelLabel": "닫기",
	        "fromLabel": "From",
	        "toLabel": "To",
	        "customRangeLabel": "Custom",
	        "weekLabel": "주",
	        "daysOfWeek": [
	            "일",
	            "월",
	            "화",
	            "수",
	            "목",
	            "금",
	            "토"
	        ],
	        "monthNames": [
	            "1월",
	            "2월",
	            "3월",
	            "4월",
	            "5월",
	            "6월",
	            "7월",
	            "8월",
	            "9월",
	            "10월",
	            "11월",
	            "12월"
	        ]
	    }	
	});
}

function SetSingleDate(divId, inputId, adjustDate) {
	
	// adjustDate 값 적용해서 초기 날짜 설정
	// 적용 안하면 오늘 날짜로 설정
	var adjustDate = parseInt(adjustDate);
	var defaultDate = new Date();
	defaultDate.setDate(defaultDate.getDate() + adjustDate);
	
	$("#" + inputId).daterangepicker({
	    "singleDatePicker": true,
	    "autoApply": true,
	    "locale": {
	        "format": "YYYY-MM-DD",
	        "separator": " - ",
	        "applyLabel": "적용",
	        "cancelLabel": "닫기",
	        "fromLabel": "From",
	        "toLabel": "To",
	        "customRangeLabel": "Custom",
	        "weekLabel": "주",
	        "daysOfWeek": [
	            "일",
	            "월",
	            "화",
	            "수",
	            "목",
	            "금",
	            "토"
	        ],
	        "monthNames": [
	            "1월",
	            "2월",
	            "3월",
	            "4월",
	            "5월",
	            "6월",
	            "7월",
	            "8월",
	            "9월",
	            "10월",
	            "11월",
	            "12월"
	        ],
	        "firstDay": 1
	    },
	    "startDate": defaultDate
	});
}

/*
	initDate : "" -> 오늘 날짜를 기본 날짜로
			   empty -> 처음에 input box에 빈값으로 시작
               '20xx-xx-xx' -> 기본 날짜를 명시함
	selector : dom element
	adjustDate : 기본 날짜 기준으로 +/- 날짜 조정 
				 +30: 기본날짜+30일이 기본날짜가 됨
				 -30: 기본날짜-30일이 기본날짜가 됨
*/
function SetSingleDate2(initDate, selector, adjustDate) {
	var booleanValue = true; console.log("setSingleDate");
	
	if(initDate == "") {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date();
		defaultDate.setDate(defaultDate.getDate() + adjustDate);		
	} else if(initDate == 'empty') {
		booleanValue = false;
	} else {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date(initDate);
		defaultDate.setDate(defaultDate.getDate() + adjustDate);
	}
	
	$(selector).daterangepicker({
	    "singleDatePicker": true,
	    "autoApply": true,
		"autoUpdateInput": booleanValue,
	    "locale": {
	        "format": "YYYY-MM-DD",
	        "separator": " - ",
	        "applyLabel": "적용",
	        "cancelLabel": "닫기",
	        "fromLabel": "From",
	        "toLabel": "To",
	        "customRangeLabel": "Custom",
	        "weekLabel": "주",
	        "daysOfWeek": [
	            "일",
	            "월",
	            "화",
	            "수",
	            "목",
	            "금",
	            "토"
	        ],
	        "monthNames": [
	            "1월",
	            "2월",
	            "3월",
	            "4월",
	            "5월",
	            "6월",
	            "7월",
	            "8월",
	            "9월",
	            "10월",
	            "11월",
	            "12월"
	        ],
	        "firstDay": 1
	    },
	    "startDate": defaultDate
	});
}

//SetSingleDate 사용시 시간까지 필요할 떄

function SetSingleDate3(initDate, selector, adjustDate) { 
	var booleanValue = true;
	
	if(initDate == "") {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date();
		defaultDate.setDate(defaultDate.getDate() + adjustDate);		
	} else if(initDate == 'empty') {
		booleanValue = false;
	} else {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date(initDate);
		defaultDate.setDate(defaultDate.getDate() + adjustDate);
	}
	
	$(selector).daterangepicker({
	    "singleDatePicker": true,
	    "autoApply": true,
		"autoUpdateInput": booleanValue,
	    "locale": {
	        "format": "YYYY-MM-DD h:mm:ss",
	        "separator": " - ",
	        "applyLabel": "적용",
	        "cancelLabel": "닫기",
	        "fromLabel": "From",
	        "toLabel": "To",
	        "customRangeLabel": "Custom",
	        "weekLabel": "주",
	        "daysOfWeek": [
	            "일",
	            "월",
	            "화",
	            "수",
	            "목",
	            "금",
	            "토"
	        ],
	        "monthNames": [
	            "1월",
	            "2월",
	            "3월",
	            "4월",
	            "5월",
	            "6월",
	            "7월",
	            "8월",
	            "9월",
	            "10월",
	            "11월",
	            "12월"
	        ],
	        "firstDay": 1
	    },
	    "startDate": defaultDate
	});
}



function SetYearMonth(initDate, selector, adjustDate) {
	var booleanValue = true;
	
	if(initDate == "") {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date();
		defaultDate.setDate(defaultDate.getDate() + adjustDate);		
	} else if(initDate == 'empty') {
		booleanValue = false;
	} else {
		var adjustDate = parseInt(adjustDate);
		var defaultDate = new Date(initDate);
		defaultDate.setDate(defaultDate.getDate() + adjustDate);
	}
	
	$(selector).daterangepicker({
	    "singleDatePicker": true,
	    "autoApply": true,
		"autoUpdateInput": booleanValue,
	    "locale": {
	        "format": "YYYY-MM",
	        "separator": " - ",
	        "applyLabel": "적용",
	        "cancelLabel": "닫기",
	        "fromLabel": "From",
	        "toLabel": "To",
	        "customRangeLabel": "Custom",
	        "weekLabel": "주",
	        "daysOfWeek": [
	            "일",
	            "월",
	            "화",
	            "수",
	            "목",
	            "금",
	            "토"
	        ],
	        "monthNames": [
	            "1월",
	            "2월",
	            "3월",
	            "4월",
	            "5월",
	            "6월",
	            "7월",
	            "8월",
	            "9월",
	            "10월",
	            "11월",
	            "12월"
	        ],
	        "firstDay": 1
	    },
	    "startDate": defaultDate
	});
}

function HeneDate() {
	
	// 선택한 날짜에 해당하는 주의 월요일, 토요일 날짜를 가져온다
	this.getFirstAndLastDaysOfWeek = function (date) {
	
		var curr = new Date(date);
	    var startDate = new Date(curr.setDate(curr.getDate() - curr.getDay() + 1));
	    var endDate = new Date(curr.setDate(curr.getDate() - curr.getDay() + 6));
	    
	    this.monDate = startDate.getFullYear() + "-" + (startDate.getMonth()+1) + "-" + startDate.getDate();
	    this.satDate = endDate.getFullYear() + "-" + (endDate.getMonth()+1) + "-" + endDate.getDate();
	}
	
	this.getToday = function() {
		var today = new Date();
		var dd = String(today.getDate()).padStart(2, '0');
		var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = today.getFullYear();
		
		today = yyyy + '-' + mm + '-' + dd;
		
		return today;
	}
	
	this.getTodayNoHyphen = function() {
		var today = new Date();
		var dd = String(today.getDate()).padStart(2, '0');
		var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = today.getFullYear();
		
		today = yyyy + mm + dd;
		
		return today;
	}
	
	this.getDateTime = function() {
        var now     = new Date(); 
        var year    = now.getFullYear();
        var month   = now.getMonth()+1; 
        var day     = now.getDate();
        var hour    = now.getHours();
        var minute  = now.getMinutes();
        var second  = now.getSeconds(); 
        if(month.toString().length == 1) {
            month = '0'+month;
        }
        if(day.toString().length == 1) {
            day = '0'+day;
        }   
        if(hour.toString().length == 1) {
            hour = '0'+hour;
        }
        if(minute.toString().length == 1) {
            minute = '0'+minute;
        }
        if(second.toString().length == 1) {
            second = '0'+second;
        }   
        var dateTime = year+'/'+month+'/'+day+' '+hour+':'+minute+':'+second;
        return dateTime;
    }
	
	this.getTodayYearMonth = function() {
		var today = new Date();
		var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = today.getFullYear();
		
		today = yyyy + '-' + mm;
		
		return today;
	}
	
	// org: 기존 날짜(string)
	// num: 더할 날짜
	this.addDate = function(org, num) {
		var num = parseInt(num);
		
		var date = new Date(org);
		var tempDate = date.setDate(date.getDate() + num);
		
		var addedDate = new Date(tempDate);

		var dd = String(addedDate.getDate()).padStart(2, '0');
		var mm = String(addedDate.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = addedDate.getFullYear();
		
		var formattedDate = yyyy + '-' + mm + '-' + dd;
		
		return formattedDate;
	}
	
	// org: 기존 날짜(string)
	// num: 뺄 날짜
	this.minusDate = function(org, num) {
		var num = parseInt(num);
		
		var date = new Date(org);
		var tempDate = date.setDate(date.getDate() - num);
		
		var addedDate = new Date(tempDate);

		var dd = String(addedDate.getDate()).padStart(2, '0');
		var mm = String(addedDate.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = addedDate.getFullYear();
		
		var formattedDate = yyyy + '-' + mm + '-' + dd;
		
		return formattedDate;
	}
}
