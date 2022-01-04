/**
 * 서버 쪽 혹은 클라이언트 쪽 데이터를 처리하는 함수 모음
 */

/*
설명: 폼 태그 안의 데이터를 json 형식으로 변환 후 리턴
@param: form tag의 id (ex. '#formId')
@param type: string
*/
function getFormDataJson(formId) {
    var unindexed_array = $(formId).serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });

    return indexed_array;
}

/*
needtocheck (에러가 떠서 일단 방치)
배열의 값을 폼 태그 안의 인풋 태그에 순서대로 입력한다
formTagId - type: String
data - type: Array
*/
function setValueInputTag(formTagId, data) {
	/*var inputs = '"' + formTagId + " :input" + '"';*/
	var inputs = formTagId + " :input";
	inputs = inputs.toString();
	
	if(!Array.isArray(data)) {
		console.error('parameter type should be array');
	}
	
	var inputList = new Array();
	$(inputs).each(function(){
		inputList.push($(this));
	});
	
	data.forEach(function(val, idx, arr) {
		inputList[idx].val(val);
	});
}

/*무슨 용도인지?*/
function DataPars(query, data) {
	var table;
	var pid;
	var retnValu;
	var tmpData

	 query.totalcnt = data.substring(0,data.indexOf('\t'));
	 data = data.replace(query.totalcnt + "\t","");
	 
	 pid =  data.substring(0,data.indexOf('\t'));
	 data = data.replace(pid + "\t","");
	 
	 query.retnValue = data.substring(0,data.indexOf('\t'));
	 data = data.replace(query.retnValue + "\t","");
	 
	 query.colcnt  = data.substring(0,data.indexOf('\t'));
	 data = data.replace(query.colcnt + "\t","");
	 
	 tmpData = data.split("\t");

	 var resData = new Array( new Array(query.colcnt), new Array(tmpData.length));

	 resData[0] = query.colname;
	 var max = tmpData.length-1;
	 var row = 1;
	 var col = 0;
	 var tmpresData=[];
//	 console.log("max=" + max);
	 for(var i=0; i < max; i++){
		 tmpresData[col] = tmpData[i];
		 console.log(tmpresData);
		 col++;
		if (col > query.colcnt-1){
			resData[row] = tmpresData;
			tmpresData = [];
		 	col = 0;
		 	row++;
		 }
	 }
	 query.data = resData;
 }