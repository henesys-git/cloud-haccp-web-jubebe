/**
 *
 */


function CheckList(divId, bodyCnt, entireRatio,
				   headRowCnt, headColCnt, headRowRatio,
				   headColRatio, footerRowCnt, footerColCnt,
				   footerRowRatio, footerColRatio, childBodies,
				   startX, startY) {
	
	this.initialize(divId);
	
	this.headCnt = 1;
	this.bodyCnt = bodyCnt;
	this.footerCnt = 1;
	this.rowCnt = this.headCnt + this.bodyCnt + this.footerCnt;
	this.entireRatio = entireRatio;
	
	this.head = {};
	this.bodies = {};
	this.footer = {};
	
	// 점검표 전체 관련 변수
	this.startX = startX;
	this.startY = startY;
	this.endX = this.canvas.width - this.startX;
	this.endY = this.canvas.height - this.startY;
	this.width = this.canvas.width - (this.startX * 2);
	this.height = this.canvas.height - (this.startY * 2);
	
	// 점검표 헤드 관련 변수
	this.headRowCnt = headRowCnt;
	this.headColCnt = headColCnt;
	this.headRowRatio = headRowRatio;
	this.headColRatio = headColRatio;
	
	// 점검표 바디 관련 변수
	this.childBodies = childBodies;
	
	// 점검표 푸터 관련 변수
	this.footerRowCnt = footerRowCnt;
	this.footerColCnt = footerColCnt;
	this.footerRowRatio = footerRowRatio;
	this.footerColRatio = footerColRatio;
	
	// 기본 값들을 보여줌 (테스트 목적)
	this.displayValues();
	
	// =============================
	// 여기서부터 기본적인 표를 만듬 
	// =============================
	
	// 페이지 전체를 감싸는 박스 (테스트 목적)
	this.drawBox(0, 0, this.canvas.width, this.canvas.height);
	
	// 점검표 전체를 감싸는 박스
	this.drawBox(this.startX, this.startY, 
				 this.width, this.height);

	// 점검표 헤드
	this.makeHead(this.startX, this.startY, 
				  this.width, this.height);
	this.makeRows(this.head, this.head.rowCnt);
	this.makeColumns(this.head, this.head.rowCnt, 
					 this.head.colCnt);
	
	// 점검표 inner bodies
	this.makeChildBodies(this.bodyCnt);
	this.makeRowsForBodies(this.bodies, this.bodyCnt);
	this.makeColumnsForBodies(this.bodies, this.bodyCnt);
};

CheckList.prototype.initialize = function(divId) {
	console.log('CHECKLIST INITIALIZING');

	this.canvas = document.getElementById(divId);
	this.ctx = this.canvas.getContext('2d');

	console.log("CHECKLIST INSTANTIATED");
}

CheckList.prototype.displayValues = function() {
	console.log('=== WIDTH & HEIGHT ===');
	
	console.log('캔버스 전체 넓이 : ' + this.canvas.width);
	console.log('캔버스 전체 높이 : ' + this.canvas.height);
	console.log('표 전체 넓이 : ' + this.width);
	console.log('표 전체 높이 : ' + this.height);
	console.log('표 시작 좌표 X : ' + this.startX);
	console.log('표 시작 좌표 Y : ' + this.startY);
	console.log('표 끝 좌표 X : ' + this.endX);
	console.log('표 끝 좌표 Y : ' + this.endY);

	console.log('=== WIDTH & HEIGHT ===');
}

CheckList.prototype.makeHead = function(sx, sy, width, height) {
	this.head.width = width;
	this.head.height = height * this.entireRatio[0];
	this.head.rowCnt = this.headRowCnt;
	this.head.colCnt = this.headColCnt;
	this.head.rowRatio = this.headRowRatio;
	this.head.colRatio = this.headColRatio;
	this.head.startX = sx;
	this.head.startY = sy;
	this.head.endX = this.head.startX + this.head.width;
	this.head.endY = this.head.startY + this.head.height;
}

CheckList.prototype.makeChildBodies = function(count) {
	var tempY;
	
	for(var i = 0; i < count; i++) {
		var childName = "body" + i;
		
		this.bodies[childName] = new Object();
		this.bodies[childName].width = this.width;
		this.bodies[childName].height = this.height * this.entireRatio[i + 1];
		
		this.bodies[childName].rowCnt = this.childBodies[childName].rowCnt;
		this.bodies[childName].colCnt = this.childBodies[childName].colCnt;
		this.bodies[childName].rowRatio = this.childBodies[childName].rowRatio;
		this.bodies[childName].colRatio = this.childBodies[childName].colRatio;
		
		this.bodies[childName].startX = this.startX;
		this.bodies[childName].endX = this.endX;
		
		if(i === 0) {
			this.bodies[childName].startY = this.head.endY;
			
		} else {
			this.bodies[childName].startY = tempY;
		}
		
		this.bodies[childName].endY = this.bodies[childName].startY 
								   + this.bodies[childName].height;
		
		tempY = this.bodies[childName].endY;
	}
}

CheckList.prototype.makeRows = function(type, rowCnt) {
	var initStartX = type.startX;
	var initStartY = type.startY;
	var initWidth = type.width;
	var initHeight = type.height;
	
	for(var i = 0; i < rowCnt; i++) {
		var key = "row" + i;
		var value = new Object();
		type[key] = value;
		
		value.startX = initStartX;	
		value.startY = initStartY;
		
		value.width = initWidth;
		value.height = initHeight * type.rowRatio[i];
		
		value.endX = value.startX + value.width;
		value.middleX = value.startX + (value.width / 2);
		value.endY = value.startY + value.height;
		value.middleY = value.startY + (value.height / 2);
		
		this.drawLine(value.startX, value.endY, 
					  value.endX, value.endY);

		// for next loop
		initStartY = value.endY;
	}
}

// type: head, body, footer
// rowCnt: 해당 타입의 row 개수
CheckList.prototype.makeRows = function(type, rowCnt) {
	var initStartX = type.startX;
	var initStartY = type.startY;
	var initWidth = type.width;
	var initHeight = type.height;
	
	for(var i = 0; i < rowCnt; i++) {
		var key = "row" + i;
		var value = new Object();
		type[key] = value;
		
		value.startX = initStartX;	
		value.startY = initStartY;
		
		value.width = initWidth;
		value.height = initHeight * type.rowRatio[i];
		
		value.endX = value.startX + value.width;
		value.middleX = value.startX + (value.width / 2);
		value.endY = value.startY + value.height;
		value.middleY = value.startY + (value.height / 2);
		
		this.drawLine(value.startX, value.endY, value.endX, value.endY);

		// for next loop
		initStartY = value.endY;
	}
}

CheckList.prototype.makeRowsForBodies = function(type, bodyCnt) {
	for(var i = 0; i < bodyCnt; i++) {
		var body = "body" + i;
		var rowCnt = type[body].rowCnt;
		
		var initStartX = type[body].startX;
		var initStartY = type[body].startY;
		var initWidth = type[body].width;
		var initHeight = type[body].height;
		
		for(var j = 0; j < rowCnt; j++) {
			var key = "row" + j;
			var value = new Object();
			type[body][key] = value;
			
			value.startX = initStartX;	
			value.startY = initStartY;
			
			value.width = initWidth;
			value.height = initHeight * type[body].rowRatio[j];
			
			value.endX = value.startX + value.width;
			value.middleX = value.startX + (value.width / 2);
			value.endY = value.startY + value.height;
			value.middleY = value.startY + (value.height / 2);
			
			this.drawLine(value.startX, value.endY, 
						  value.endX, value.endY);
	
			// for next loop
			initStartY = value.endY;
		}
	}
}

CheckList.prototype.makeColumns = function(type, rowCnt, colCnt) {
	for(var i = 0; i < rowCnt; i++) {
		var row = "row" + i;
		var initStartX = type[row].startX;
		var initStartY = type[row].startY;
		var initWidth = type[row].width;
		var initHeight = type[row].height;
		
		for(var j = 0; j < colCnt; j++) {
			var key = "col" + j;
			var value = new Object();
			
			type[row][key] = value;
			
			value.startX = initStartX;
			value.startY = initStartY;

			value.width = initWidth * type.colRatio[j];
			value.height = initHeight;
			
			value.endX = value.startX + value.width;
			value.middleX = value.startX + (value.width / 2);
			value.endY = value.startY + value.height;
			value.middleY = value.startY + (value.height / 2);
			
			this.drawLine(value.endX, value.startY, 
						  value.endX, value.endY);

			// for next loop
			initStartX = value.endX;
		}
	}
}

CheckList.prototype.makeColumnsForBodies = function(type, bodyCnt) {
	for(var i = 0; i < bodyCnt; i++) {
		var body = "body" + i;
		var rowCnt = type[body].rowCnt;
		var colCnt = type[body].colCnt;
		
		for(var j = 0; j < rowCnt; j++) {
			var row = "row" + j;
			var initStartX = type[body][row].startX;
			var initStartY = type[body][row].startY;
			var initWidth = type[body][row].width;
			var initHeight = type[body][row].height;
			
			for(var k = 0; k < colCnt; k++) {
				var key = "col" + k;
				var value = new Object();
				
				type[body][row][key] = value;
				
				value.startX = initStartX;
				value.startY = initStartY;
	
				value.width = initWidth * type[body].colRatio[k];
				value.height = initHeight;
				
				value.endX = value.startX + value.width;
				value.middleX = value.startX + (value.width / 2);
				value.endY = value.startY + value.height;
				value.middleY = value.startY + (value.height / 2);
				
				this.drawLine(value.endX, value.startY, 
							  value.endX, value.endY);
	
				// for next loop
				initStartX = value.endX;
			}
		}
	}
}

// ====================================================
// 위에는 초기 세팅을 위한 함수들
// 아래에서부터는 상세 설정을 위한 함수들
// ====================================================


/**
 * @param type - head or bodies.body or footer
 * @param source - source row
 * @param target - target row
 * @param column - column position to select cells
 */
CheckList.prototype.mergeCellsVertical = function(type, source, target, column) {
	// type(head,body,footer)이 다르면 에러 처리하기
	
	var sourceRow = type[source];
	var targetRow = type[target];
	
	var sourceCell = sourceRow[column];
	var targetCell = targetRow[column];
	
	// merge
	let allCells = this.betweenCellsIncl(source, target);
	
	var heightSum = 0;	// sum height
	for(var i = 0; i < allCells.length; i++) {
		var row = allCells[i];
		var cell = type[row][column];
		heightSum += cell.height;
	}
	
	sourceCell.height = heightSum;
	sourceCell.endY = targetCell.endY;
	sourceCell.middleY = sourceCell.startY +
					     (sourceCell.height / 2);
	
	// redraw
	this.clearBox(sourceCell.startX, sourceCell.startY, 
				  sourceCell.width, sourceCell.height);
	this.drawBox(sourceCell.startX, sourceCell.startY, 
				 sourceCell.width, sourceCell.height);
	
	// delete merged cells
	let mergedCells = this.betweenCellsInclLast(source, target);
	for(var i = 0; i < mergedCells.length; i++) {
		var row = mergedCells[i];
		this.deleteCell(type, row, column);
	}
}

CheckList.prototype.mergeCellsHorizon = function(type, row, source, target) {
	// type(head,body,footer)이 다르면 에러 처리하기
	
	var sourceCell = type[row][source];
	var targetCell = type[row][target];
	
	// merge
	let allCells = this.betweenCellsIncl(source, target);
	
	var widthSum = 0;	// sum height
	for(var i = 0; i < allCells.length; i++) {
		var column = allCells[i];
		var cell = type[row][column];
		widthSum += cell.width;
	}
	
	sourceCell.width = widthSum;
	sourceCell.endX = targetCell.endX;
	sourceCell.middleX = sourceCell.startX 
					     + (sourceCell.width / 2);
	
	// redraw
	this.clearBox(sourceCell.startX, sourceCell.startY, 
				  sourceCell.width, sourceCell.height);
	this.drawBox(sourceCell.startX, sourceCell.startY, 
				 sourceCell.width, sourceCell.height);
	
	// delete merged cells
	let mergedCells = this.betweenCellsInclLast(source, target);
	for(var i = 0; i < mergedCells.length; i++) {
		var column = mergedCells[i];
		this.deleteCell(type, row, column);
	}
}

CheckList.prototype.fillText = function(type, row, col, text, color, 
										font, textAlign, baseline) { 
	console.log('=== fillText() 실행 ===');
	console.log('row : ' + row + " / col : " + col);
	
	if(typeof(row) == "number") {	// row type이 숫자일때(x 시작좌표, y 시작좌표 ...)
	
		var middleX = row;	// x 좌표
		var middleY = col;	// y 좌표 그대로 fillText
	
	} else {						// row type이 문자열일때(row0, col0 ...)
	
	    // 글자 입력할 셀 지정
		var row = type[row];	
		var col = row[col];
				
		var middleX = col.middleX;
		var middleY = col.middleY;
	
	}
	this.ctx.fillStyle = color;
    this.ctx.font = font;
    this.ctx.textAlign = textAlign;
    this.ctx.textBaseline = baseline;
    this.ctx.fillText(text, middleX, middleY);

	console.log('작성된 글자:' + text + '\n' +
				'작성된 위치:' + 'X:' + middleX + ' Y:' + middleY);
	console.log('=== fillText() 종료 ===');
}

///// 왼쪽 상단 정렬 fill_Text (paddingX, paddingY == 이동하고싶은 길이)
CheckList.prototype.fillText_left = function(type, row, col, text, color, font, paddingX, paddingY){	
	
	console.log('=== fillText_left() 실행 ===');										
	
	
    // 글자 입력할 셀 지정
	var row = type[row];	
	var col = row[col];
			
	var startX = col.startX + paddingX;
	var startY = col.startY + paddingY;
	

	this.ctx.fillStyle = color;
    this.ctx.font = font;
    this.ctx.textAlign = "left";
    this.ctx.textBaseline = "top";
    this.ctx.fillText(text, startX, startY);

	console.log('작성된 글자:' + text + '\n' +
				'작성된 위치:' + 'X:' + startX + ' Y:' + startY);
	console.log('=== fillText_left() 종료 ===');
											
}

///// 오른쪽 상단 정렬 fill_Text (paddingX, paddingY == 이동하고싶은 길이)
CheckList.prototype.fillText_right = function(type, row, col, text, color, font, paddingX, paddingY){	
	
	console.log('=== fillText_right() 실행 ===');										
	
	
    // 글자 입력할 셀 지정
	var row = type[row];	
	var col = row[col];
			
	var startX = col.endX - paddingX;
	var startY = col.startY + paddingY;
	

	this.ctx.fillStyle = color;
    this.ctx.font = font;
    this.ctx.textAlign = "right";
    this.ctx.textBaseline = "top";
    this.ctx.fillText(text, startX, startY);

	console.log('작성된 글자:' + text + '\n' +
				'작성된 위치:' + 'X:' + startX + ' Y:' + startY);
	console.log('=== fillText_right() 종료 ===');
											
}

/// canvas.comm.func.js 內  ctx_wrapText 수정 (줄바꿈) ---> startX, Y 로 잡아서 왼쪽 상단 고정해야함 (0329)) left top
CheckList.prototype.wrapText_XY = function(checklist, type, row, col, text, color, 
										font, textAlign, baseline, line_width, line_height, paddingX, paddingY) {		// checklistBuilder, bodytype, row, col, ... , 줄(line)당 글자수, 줄(line) 수  										
	 
	console.log('=== wrapText_XY() 실행 ===');

	 var lineArray = new Array();
     var line = '';
     var paragraphs = text.split('\n');
     for (var i = 0; i < paragraphs.length; i++) {
          var words = paragraphs[i].split(''); // 한글자씩 배열로 저장
         for (var n = 0; n < words.length; n++) {
             var testLine = line + words[n] ;
             var testWidth = testLine.length;	// this.ctx.measureText(testLine).width;
             if (testWidth > line_width && n > 0) {
                 lineArray.push(line);
                 line = words[n] ;
             } else {
                 line = testLine;
             }
         }
         lineArray.push(line);
         line = '';
     }

	if(paddingX == "" || paddingX == null){
		
		paddingX = 15;
		paddingY = 10;
	}

  	 // 글자 입력할 셀 지정  - fillText 수정
	 var middleX = type[row][col].startX + paddingX;	//	type[row][col].middleX
	 var middleY = type[row][col].startY + paddingY;	//	type[row][col].middleY
  /*    
     if(baseline == 'middle') {
     	 middleY -= (line_height * (lineArray.length - 1) / 2) ; // 수직 중간 맞춤을 위한 y좌표 조정
	 }
*/
	 if(lineArray.length > line_height){
		
		lineArray.length = line_height; 
		
		// 지정 줄 수를 넘어갈때 마지막 문자열 ... 처리
		var str = lineArray[lineArray.length-1];
		
		str = str.replace(/.{2}$/, "...");
		
		lineArray[lineArray.length-1] = str;
		
	}

     for(var i = 0; i < lineArray.length; i++) {
    	 checklist.fillText(type, middleX, middleY, lineArray[i], color, font, textAlign, baseline);
    	 
    	 middleY += 15;

     }
    						
     return lineArray.length; // 라인 수 리턴	

	 console.log('=== wrapText_XY() 종료 ===');										
}


CheckList.prototype.drawBox = function(sx, sy, width, height) {
	console.log('drawing box');
	this.ctx.beginPath();
	this.ctx.lineWidth = "1";
	this.ctx.strokeStyle = "black";
	this.ctx.rect(sx, sy, width, height);
	this.ctx.stroke();
}

CheckList.prototype.drawLine = function(sx, sy, ex, ey) {
	console.log('drawing line');
	this.ctx.beginPath();
	this.ctx.moveTo(sx, sy);
	this.ctx.lineTo(ex, ey);
	this.ctx.stroke();
}

CheckList.prototype.clearBox = function(sx, sy, width, height) {
	console.log('clearing box');
	this.ctx.clearRect(sx, sy, width, height);
}

CheckList.prototype.fillCharVertical = function(type, row, col, text, 
												color, font, textAlign) {
	console.log('=== fillCharVertical() 실행 ===');
	console.log('작성할 글자:' + text);
    
	// 글자 입력할 셀 지정
	var row = type[row];
	var col = row[col];
	
	// 해당 셀의 값들을 가져옴
	var width = col.width;
	var height = col.height;
	var middleX = col.middleX;
	var middleY = col.middleY;
	var lineArray = new Array();
    var line = '';
	
	// 파라미터로 받아온 문자열 관련 설정
	var words = text.split('');
	var textMetrix = this.ctx.measureText(words[0]);
	let fontHeight = textMetrix.fontBoundingBoxAscent 
				   + textMetrix.fontBoundingBoxDescent;
	var len = words.length;
	var middleIdx = Math.ceil(len / 2);
	
	// 입력할 텍스트 관련 설정
	this.ctx.fillStyle = color;
    this.ctx.font = font;
    this.ctx.textAlign = textAlign;

	if(len % 2 === 0) {	// 문자의 개수가 짝수일 경우
		for(var i = 0; i < len; i++) {
			// 각 문자를 위치할 y값을 구한다
			// middleY + char height x (middle index - length + current index)
			var y = middleY + fontHeight * (middleIdx - len + i);
			
			// 글자를 입력한다
			this.ctx.textBaseline = "bottom";
			this.ctx.fillText(words[i], middleX, y);

			console.log('작성된 글자:' + words[i] + '\n' +
						'작성된 위치:' + 'X:' + middleX + ' Y:' + y);
		}
	} else { // 문자의 개수가 홀수일 경우
		for(var i = 0; i < len; i++) {
			// 각 문자를 위치할 y값을 구한다
			// middleY + char height x (middle index - length + current index)
			var y = middleY + (fontHeight * (middleIdx - len + i));
			
			// 글자를 입력한다
		    this.ctx.textBaseline = "middle";
			this.ctx.fillText(words[i], middleX, y);
			
			console.log('작성된 글자:' + words[i] + '\n' +
						'작성된 위치:' + 'X:' + middleX + ' Y:' + y);
		}
	}
	
	console.log('=== fillCharVertical() 종료 ===');
}

// 시작셀과 마지막셀은 제외하고 그 사이의 셀들을 구한다
CheckList.prototype.betweenCellsExcl = function(start, end) {
	var type = start.slice(0, -1);
	var start = parseInt(start.slice(-1));
	var end = parseInt(end.slice(-1));
	
	if(start > end) {
		console.error('start cell cannot be bigger than end cell');
	}
	
	// 중간값들이 없으면 종료
	if(end - start === 1) {
		return false;
	}
	
	var betweenCells = [];
	
	while(start < end - 1) {
		start++;
		betweenCells.push(type + start);
	}
	
	return betweenCells;
}

// 시작셀과 마지막셀을 포함해서 그 사이의 셀들을 구한다
CheckList.prototype.betweenCellsIncl = function(start, end) {
	
	var slen = start.length;
	var elen = end.length;
	
	var type = start.slice(0, -1);
	var startNum = parseInt(start.slice(-1));
	var endNum = parseInt(end.slice(-1));
	
	if(slen > 4){
		type = start.slice(0, -2);
		startNum = parseInt(start.slice(-2));
	}
	
	if(elen > 4){
		endNum = parseInt(end.slice(-2));
	}
	
	if(startNum > endNum) {
		console.error('start cell cannot be bigger than end cell');
	}
	
	var betweenCells = [];
	
	while(startNum <= endNum) {
		betweenCells.push(type + startNum);
		startNum++;
	}
	
	return betweenCells;
}

// 시작셀은 제외하고 마지막셀만 포함해서 그 사이의 셀들을 구한다
CheckList.prototype.betweenCellsInclLast = function(start, end) {
	
	var slen = start.length;
	var elen = end.length;
	
	var type = start.slice(0, -1);
	var startNum = parseInt(start.slice(-1));
	var endNum = parseInt(end.slice(-1));
	
	if(slen > 4){
		type = start.slice(0, -2);
		startNum = parseInt(start.slice(-2));
	}
	
	if(elen > 4){
		endNum = parseInt(end.slice(-2));
	}
	
	if(startNum > endNum) {
		console.error('start cell cannot be bigger than end cell');
	}
	
	var betweenCells = [];
	
	while(startNum < endNum) {
		betweenCells.push(type + (++startNum));
	}
	
	return betweenCells;
}

CheckList.prototype.deleteCell = function(type, row, column) {
	delete type[row][column];
}

// ==================================
// CheckList 상속받음 (배경 이미지 용)
// ==================================

function CheckListWithImage(divId, bodyCnt, entireRatio,
				   			headRowCnt, headColCnt, headRowRatio,
				   			headColRatio, footerRowCnt, footerColCnt,
				   			footerRowRatio, footerColRatio, childBodies,
							startX, startY) {
								
	CheckList.call(this, divId, bodyCnt, entireRatio,
				   headRowCnt, headColCnt, headRowRatio,
				   headColRatio, footerRowCnt, footerColCnt,
				   footerRowRatio, footerColRatio, childBodies,
				   startX, startY);
	
}

CheckListWithImage.prototype = Object.create(CheckList.prototype);
CheckListWithImage.prototype.constructor = CheckListWithImage;

CheckListWithImage.prototype.drawBackgroundImg = function(ctx, image) {
	ctx.drawImage(image, 0, 0);
}

// override
CheckListWithImage.prototype.drawLine = function() {
	// 배경 이미지가 있으니 아무 것도 하지 않는다
}

// override
CheckListWithImage.prototype.drawBox = function() {
	// 배경 이미지가 있으니 아무 것도 하지 않는다
}

// override
CheckListWithImage.prototype.clearBox = function() {
	// 배경 이미지가 있으니 아무 것도 하지 않는다
}

// ==================================
// CheckListWithImage 상속받음 (비율 테스트용)
// ==================================

function CheckListWithImageTest(divId, bodyCnt, entireRatio,
					   			headRowCnt, headColCnt, headRowRatio,
					   			headColRatio, footerRowCnt, footerColCnt,
					   			footerRowRatio, footerColRatio, childBodies,
								startX, startY) {
	
	CheckListWithImage.call(this, divId, bodyCnt, entireRatio,
						    headRowCnt, headColCnt, headRowRatio,
						    headColRatio, footerRowCnt, footerColCnt,
						    footerRowRatio, footerColRatio, childBodies,
						    startX, startY);
}

CheckListWithImageTest.prototype 
	= Object.create(CheckListWithImage.prototype);
CheckListWithImageTest.prototype.constructor = CheckListWithImageTest;

// override
CheckListWithImageTest.prototype.drawBackgroundImg = function(ctx, image) {
	// delay to load after merge cells process
	setTimeout(function() {
		ctx.globalAlpha = 0.5;
		ctx.drawImage(image, 0, 0);
		ctx.globalAlpha = 1.0;
	}, 500);
}

// override
CheckListWithImageTest.prototype.drawBox = function(sx, sy, width, height) {
	this.ctx.beginPath();
	this.ctx.lineWidth = "3";
	this.ctx.strokeStyle = "red";
	this.ctx.globalAlpha = 0.25;
	this.ctx.rect(sx, sy, width, height);
	this.ctx.stroke();
	this.ctx.globalAlpha = 1.0;
}

// override
CheckListWithImageTest.prototype.drawLine = function(sx, sy, ex, ey) {
	this.ctx.beginPath();
	this.ctx.moveTo(sx, sy);
	this.ctx.lineTo(ex, ey);
	this.ctx.strokeStyle = "red";
	this.ctx.globalAlpha = 0.5;
	this.ctx.stroke();
	this.ctx.globalAlpha = 1.0;

}

// override
CheckListWithImageTest.prototype.clearBox = function(sx, sy, width, height) {
	this.ctx.clearRect(sx, sy, width, height);
}