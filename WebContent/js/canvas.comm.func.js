/* 
	Canvas 공통 함수
*/

// 박스 그리기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,테두리 컬러,선두께)
function ctx_Box(ctx, startX, startY, endX, endY, color, lineWidth) {
    ctx.lineWidth = lineWidth; // 선 굵기
    ctx.beginPath();
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, startY);
    ctx.lineTo(endX, endY);
    ctx.lineTo(startX, endY);
    ctx.lineTo(startX, startY);
    ctx.strokeStyle = color;    // 테두리 컬러
    ctx.stroke();               // 테두리 컬러 적용
}

// 선 그리기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,선 컬러,선두께)
function ctx_Line(ctx, startX, startY, endX, endY, color, lineWidth){
    ctx.lineWidth = lineWidth;  // 선 굵기
    ctx.beginPath();
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    ctx.strokeStyle = color;
    ctx.stroke();               //테두리
}

// 색 채우기(컨텍스트,왼쪽 위 시작좌표x&y,오른쪽 아래 종료좌표x&y,채울 색)
function ctx_fillColor(ctx, startX, startY, endX, endY, color){
    ctx.fillStyle = color; // 박스 내부 컬러
    ctx.fillRect(startX,startY,endX-startX,endY-startY); // 박스 내부 컬러 적용(시작좌표x,시작좌표y,영역 가로길이,영역 세로길이)
}

// 원 그리기(컨텍스트,원 중심 좌표x&y,반지름,선 컬러,선두께)
function ctx_circle(ctx, centerX, centerY, radius, color, lineWidth) {
    ctx.beginPath();
    ctx.arc(centerX, centerY, 20, 0, Math.PI*2, true);
    ctx.lineWidth = lineWidth;
    ctx.strokeStyle = color;
    ctx.stroke();
}

// 글자넣기 (컨텍스트,시작좌표x&y,입력할 글자,글자색,글자체&크기,수평정렬,수직정렬)
// baseline에는  alphabetic, bottom, hanging, ideographic, middle, top이 있습니다
// x += ctx.measureText(text).width;문자열 크키측정
function ctx_fillText(ctx, startX, StartY, text, color, font, textAlign, Baseline){ 
    ctx.fillStyle  = color;
    ctx.font = font;
    ctx.textAlign = textAlign;
    ctx.textBaseline = Baseline;
    ctx.fillText(text, startX, StartY);
}

// 글자에 밑줄넣기(컨텍스트, 기준좌표x&y, 입력할 글자, 밑줄 색, 글자와 밑줄 사이 간격)
function ctx_textUnderline(ctx, x, y, text, color, size, offset){
    var width = ctx.measureText(text).width;

    switch(ctx.textAlign) {
        case "center":
            x -= (width/2); 
			break;
        case "right":
            x -= width; 
			break;
    }

    y += size + offset ;
    switch(ctx.textBaseline) {
        case "top": break;
        case "middle":
            y -= (size/2); 
			break;
        case "bottom":
            y -= size ;
			break;
    }

	ctx.beginPath();
	ctx.strokeStyle = color;
	ctx.lineWidth = size * 0.05 ;
	ctx.moveTo(x,y);
	ctx.lineTo(x+width,y);
	ctx.stroke();
}

// 한줄에 지정된 글자수 넘어가면 줄바꿈(컨텍스트, 기준좌표x&y, 입력할 글자, 글자색, 글자체&크기, 수평정렬, 수직정렬, 한줄 최대 너비, 줄바꿈 높이)
function ctx_wrapText(context, x, y, text, color, font, textAlign, Baseline, line_width, line_height) {
    var lineArray = new Array();
    var line = '';
    var paragraphs = text.split('\n');
    for (var i = 0; i < paragraphs.length; i++) {
        var words = paragraphs[i].split(''); // 한글자씩 배열로 저장
        for (var n = 0; n < words.length; n++) {
            var testLine = line + words[n] ;
            var metrics = context.measureText(testLine);
            var testWidth = metrics.width;
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
    
    if(Baseline == 'middle') {
		y -= (line_height * (lineArray.length - 1) / 2) ; // 수직 중간 맞춤을 위한 y좌표 조정
	}
    
    for(var i = 0; i < lineArray.length; i++) {
        ctx_fillText(context, x, y, lineArray[i], color, font, textAlign,Baseline);
        y += line_height;
    }
    
    return lineArray.length; // 라인 수 리턴
}

// 한줄에 지정된 글자수 넘어가면 줄바꿈 - 공백(스페이스바,띄어쓰기)으로 줄 구분
function ctx_wrapText_space(context, x, y, text, color, font, textAlign, Baseline, line_width, line_height)
{
    var line = '';
    var lineArray = new Array();
    var paragraphs = text.split('\n');
    for (var i = 0; i < paragraphs.length; i++)
    {
        var words = paragraphs[i].split(' '); // space(공백) 단위로 잘라서 배열로 저장
        for (var n = 0; n < words.length; n++)
        {
            var testLine = line + words[n] + ' ';
            var metrics = context.measureText(testLine);
            var testWidth = metrics.width;
            if (testWidth > line_width && n > 0)
            {
                lineArray.push(line.substring(0, line.length-1));
                line = words[n] + ' ';
            }
            else
            {
                line = testLine;
            }
        }
        lineArray.push(line.substring(0, line.length-1));
        line = '';
    }
    
    if(Baseline=='middle') y -= (line_height * (lineArray.length - 1) / 2) ; // 수직 중간 맞춤을 위한 y좌표 조정
    
    for(var i = 0; i < lineArray.length; i++) {
        ctx_fillText(context, x, y, lineArray[i], color, font, textAlign,Baseline);
        y += line_height;
    }
}

// 지정된 폭에 택스트 넣을때 줄바꿈 몇번인지 계산(컨텍스트, 텍스트, 한줄 최대 너비)
function ctx_wrapText_lineCount(context, text, line_width)
{
    var lineArray = new Array();
    var line = '';
    var paragraphs = text.split('\n');
    for (var i = 0; i < paragraphs.length; i++)
    {
        var words = paragraphs[i].split(''); // 한글자씩 배열로 저장
        for (var n = 0; n < words.length; n++)
        {
            var testLine = line + words[n] ;
            var metrics = context.measureText(testLine);
            var testWidth = metrics.width;
            if (testWidth > line_width && n > 0)
            {
                lineArray.push(line);
                line = words[n] ;
            }
            else
            {
                line = testLine;
            }
        }
        lineArray.push(line);
        line = '';
    }
    
    var str='';
    for(var i = 0; i < lineArray.length; i++) {
        str += lineArray[i]+"\n"
    }
    
    return lineArray.length; // 라인 수 리턴
}

// 숫자 관련(세자리마다 콤마, 숫자를 한글로 표기)
var ctx_mony_to_hangle={
    arrNumberWord: 	["","일","이","삼","사","오","육","칠","팔","구"],
    arrDigitWord: 	["","십","백","천"],
    arrManWord:		["","만","억", "조"],
    numberWithCommas: function(x) { // 세자리마다 콤마
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    change_hangul_money: function(num) { // 숫자를 한글로 표기
        var num_value = num.toString();
		var num_length = num_value.length;
        
		if(isNaN(num_value) == true) {
			return;	
		}
		
        var han_value = "";
        var man_count = 0;      // 만단위 0이 아닌 금액 카운트.

        for(i=0; i < num_value.length; i++) {
			// 1단위의 문자로 표시.. (0은 제외)
            var strTextWord = this.arrNumberWord[num_value.charAt(i)];
            
			// 0이 아닌경우만, 십/백/천 표시
            if(strTextWord != ""){
                man_count++;
            	strTextWord += this.arrDigitWord[(num_length - (i+1)) % 4];
            }
            // 만단위마다 표시 (0인경우에도 만단위는 표시한다)
            if(man_count != 0 && (num_length - (i+1)) % 4 == 0) {
                man_count = 0;
            	strTextWord = strTextWord + this.arrManWord[(num_length - (i+1)) / 4];
            }
        	han_value += strTextWord;
        }
          
		return han_value;
    }
}

// 프린트 버튼 눌렀을때 -> 프린트 화면으로 넘어감
function print_area() {
    const dataUrl = document.getElementById('myCanvas').toDataURL();
    
	// for 거래명세표
    if(document.getElementById('PrintAreaP').childElementCount == 2) {	
        var cutLine = "<br><br><hr style='background-color: #fff; border-top: 2px dashed #8c8b8b;'>";
    	var dataUrl2 = document.getElementById('myCanvas').toDataURL();
    } else {
        cutLine = "";
        dataUrl2 = "";
    }
    
    let windowContent = '<!DOCTYPE html>';
    windowContent += '<html>';
    windowContent += '<head><title>Print canvas</title></head>';
    windowContent += '<body>';
    windowContent += '<img src="' + dataUrl + '">';
    windowContent += cutLine;
    windowContent += '<img src="' + dataUrl2 + '">';
    windowContent += '</body>';
    windowContent += '</html>';

    const printWin = window.open('', '', 'width=' + (screen.availWidth*0.8) + ', height=' + (screen.availHeight*0.95) + ', top=1, left=0');
    printWin.document.open();
    printWin.document.write(windowContent); 

    printWin.document.addEventListener('load', function() {
        printWin.focus();
        printWin.print();
        printWin.document.close();
        printWin.close();
    }, true);
}