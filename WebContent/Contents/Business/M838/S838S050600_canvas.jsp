<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
제조설비 점검표 canvas (S838S050600_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CHECK_DATE="" ;

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);

	TableModel = new DoyosaeTableModel("M838S050600E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	String CheckDate="", Checker="", StandardGuide="",
			IncongDate="", IncongPlace="", IncongNote="",
			IncongAction="",IncongConfirm="";
	if(RowCount>0) {
		CheckDate=TableModel.getValueAt(0, 0).toString().trim() ;
		Checker=TableModel.getValueAt(0, 1).toString().trim() ;
		StandardGuide=TableModel.getValueAt(0, 4).toString().trim() ;
		IncongDate=TableModel.getValueAt(0, 9).toString().trim() ;
		IncongPlace=TableModel.getValueAt(0, 10).toString().trim() ;
		IncongNote=TableModel.getValueAt(0, 11).toString().trim() ;
		IncongAction=TableModel.getValueAt(0, 12).toString().trim() ;
		IncongConfirm=TableModel.getValueAt(0, 13).toString().trim() ;
	}
	
	// 표1에 들어갈 데이터 -> 자바스크립트 배열로 가공
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," ); // 설비명(check_gubun_mid)
		DataArray.append( "'" + TableModel.getValueAt(i, 6).toString().trim() + "'" + "," ); // 세부부위(check_gubun_sm)
		DataArray.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'" + "," ); // 점검항목(check_note)
		DataArray.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "" ); // 점검결과(check_value)
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");

	
%>

<script type="text/javascript">	
	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowCount = 2 ; // 표1의 행 개수(체크리스트행 개수)
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid1_HeightEnd = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 끝나는 위치
	// 표2 영역
	var DataGrid2_RowHeight = 25; // 표2의 행 높이
	var DataGrid2_RowCount = <%=RowCount%>+2 ; // 표2의 행 개수(체크리스트행 개수)
	var DataGrid2_HeightStart = DataGrid1_HeightEnd+25 ; // 표2 시작위치(표1 끝나는 위치 + 25)
	var DataGrid2_HeightEnd = DataGrid2_HeightStart + (DataGrid2_RowCount * DataGrid2_RowHeight); // 표2 끝나는 위치
	// 표3 영역
	var DataGrid3_RowHeight = 25; // 표3의 데이터 행 높이
	var DataGrid3_HeightStart = DataGrid2_HeightEnd+25 ; // 표3 시작위치(표1 끝나는 위치 + 25)
	var DataGrid3_HeightEnd = DataGrid3_HeightStart + DataGrid3_RowHeight*2; // 표3 끝나는 위치
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++)
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
    	// 표3 높이 계산(라인 수)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	var DataGrid3_LineCount = DataGrid3.getLineCount(ctx_temp) ; // 표2 데이터부분 줄수배열(부적합,개선조치)
    	DataGrid3_HeightEnd += DataGrid3_LineCount * DataGrid3_RowHeight ;
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid3_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y
    	
		// 그리기
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid1_HeightEnd);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart, pointEX, pointSY + DataGrid2_HeightEnd);
		DataGrid3.drawGrid(ctx, pointSX, pointSY + DataGrid3_HeightStart, pointEX, pointEY);
		
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var middle_info1 = '위생관리 기준서' ;
			var middle_info2 = '제조시설·설비점검표' ;
			var approval_box_width = 200; //결재박스 너비(30 + 80 + 80)
			// 헤드텍스트
			ctx_fillText(ctx, sx+approval_box_width+(ex-sx-approval_box_width*2)/2, sy+(ey-sy)/4,
					middle_info1, 'black', 'bold 30px 맑은고딕', 'center','middle');
			ctx_Line(ctx, sx+approval_box_width, sy+(ey-sy)/2,
					ex-approval_box_width, sy+(ey-sy)/2, 'black', 1); // 가로선
			ctx_fillText(ctx, sx+approval_box_width+(ex-sx-approval_box_width*2)/2, ey-(ey-sy)/4,
					middle_info2, 'black', '30px 맑은고딕', 'center','middle');
			// 왼쪽로고
			ctx_Line(ctx, sx+approval_box_width, sy, sx+approval_box_width, ey, 'black', 1); // 세로선
			// 결재 박스
			ctx_Line(ctx, ex-approval_box_width, sy, ex-approval_box_width, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width/2, sy, ex-approval_box_width/2, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-approval_box_width*3/4, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*1/4, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["점검일자","<%=CheckDate%>","점검주기","1회/월","점검자","<%=Checker%>","범례","<%=StandardGuide%>"],
		col_head_width:[100,150,100,150,100,150,100,150],
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Line(ctx, sx, sy, sx, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex, sy, ex, ey, 'black', 1); // 세로선
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight ;
			var col_head_y_center = col_head_y + (DataGrid1_RowHeight)/2 ;
			var col_head_x = sx;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i<this.col_head_width.length-1) // 마지막엔 세로선 그릴필요X
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, ey, 'black', 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyle, 'center','middle');
			}
			col_head_y += DataGrid1_RowHeight;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
 	
	// 표2 정의
	var DataGrid2 = {
		col_head:["설비명","세부부위","점검항목","점검결과"],
		col_head_width:[200,200,450,150],
		col_data:<%=DataArray%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			// 헤드
			var col_head_y = sy + DataGrid2_RowHeight ;
			var col_head_y_center = col_head_y + DataGrid2_RowHeight/2 ;
			var col_head_x = sx;
			
			var total_info = '기존 제조시설·설비';
			ctx_fillText(ctx, sx+(ex-sx)/2, col_head_y-DataGrid2_RowHeight/2, 
					total_info,	'black', vTextStyle, 'center','middle');
			
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i<this.col_head_width.length-1) // 마지막엔 세로선 그릴필요X
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, ey, 'black', 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center,
						this.col_head[i], 'black', vTextStyle, 'center','middle');
			}
			col_head_y += DataGrid2_RowHeight;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			// 데이터
			var col_data_y = col_head_y ;
			var col_data_y_1st_top = col_head_y; // 1번째 열 합치기 기준 y좌표
			var col_data_y_2nd_top = col_head_y; // 2번째 열 합치기 기준 y좌표
			for(i=0; i<this.col_data.length; i++){
				col_data_y += DataGrid2_RowHeight ;
				var col_data_y_center = col_data_y - DataGrid2_RowHeight/2 ;
				var col_data_x = sx ;
				for(j=0; j<this.col_data[i].length; j++){
					col_data_x += this.col_head_width[j] ;
					var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
					if(j==0) { // 설비명(같은데이터 열합치기, 줄바꿈)
						if(i<this.col_data.length-1 && this.col_data[i][j]==this.col_data[i+1][j]) {
							// 아무것도 안함
						} else {
							var col_data_y_1st_center = col_data_y - (col_data_y-col_data_y_1st_top)/2;
							ctx_wrapText(ctx, col_data_x_center, col_data_y_1st_center, this.col_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-10, DataGrid2_RowHeight);
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
							col_data_y_1st_top = col_data_y ; // 열 합치기 기준 y좌표 갱신
						}
					} else if(j==1) { // 세부부위(같은데이터 열합치기,줄바꿈)
						if(i<this.col_data.length-1 && this.col_data[i][j]==this.col_data[i+1][j] && this.col_data[i][j]!='') {
							// 아무것도 안함
						} else {
							var col_data_y_2nd_center = col_data_y - (col_data_y-col_data_y_2nd_top)/2;
							ctx_wrapText_space(ctx, col_data_x_center, col_data_y_2nd_center, this.col_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-10, DataGrid2_RowHeight);
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
							col_data_y_2nd_top = col_data_y ; // 열 합치기 기준 y좌표 갱신
						}
					} else if(j==2) { // 점검항목(좌측정렬)
						ctx_fillText(ctx, col_data_x-this.col_head_width[j]+5, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'start','middle');
						ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
					} else if(j==3) { // 예방법 실행여부&점검결과(O,X)
						var check_result = '';
						if(this.col_data[i][j]=='Y') check_result = 'O';
						else if(this.col_data[i][j]=='N') check_result = 'X';
	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, check_result, 'black', vTextStyle, 'center','middle');
	 					ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
					} 
				} // j for end
			} // i for end
		} // drawGrid function end
	} ; // DataGrid2(표2) 정의  end
	
	// 표3 정의
	var DataGrid3 = {
		col_head:["발생일자","발생장소","발생내용","조치내용","확인"],
		col_head_width:[200,200,250,250,100],
		col_data:["<%=IncongDate%>","<%=IncongPlace%>","<%=IncongNote%>","<%=IncongAction%>","<%=IncongConfirm%>"],
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표3 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid3_RowHeight ;
			var col_head_y_center = sy + (DataGrid3_RowHeight)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선(이중선)
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i<this.col_head_width.length-1) // 마지막엔 세로선 그릴필요X
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyle, 'center','middle');
			}
			
			// 데이터
			var col_data_y = col_head_y ;
			var col_data_x = sx ;
			for(i=0; i<this.col_data.length; i++){
				ctx_wrapText(ctx, col_data_x+5, col_data_y+5, this.col_data[i],
						'black', vTextStyle, 'start','top', this.col_head_width[i]-10, DataGrid3_RowHeight);
				col_data_x += this.col_head_width[i] ;
			}
			
		}, // drawGrid function end
		
		getLineCount: function(ctx) { // 표3의 줄수(부적합사항&시정 및 개선조치)
			ctx.font = vTextStyle;
			var col_lineCount = 6; // 최소 줄수 : 6줄
			var lineCount = new Array();
			for(i=0; i<this.col_data.length; i++) {
				lineCount[i] = ctx_wrapText_lineCount(ctx, this.col_data[i], this.col_head_width[i]-10); // 칼럼 줄 개수
			}
			lineCount[this.col_data.length] = col_lineCount; //최소줄수(기준)
			// 가장 큰 줄수를 리턴
			var max_lineCount = Math.max.apply(null, lineCount); // 배열에서 최대값 구하는 함수
			return max_lineCount ;
		}
	} ; // DataGrid3(표3) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>