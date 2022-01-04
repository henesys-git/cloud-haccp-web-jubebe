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
계측기 검교정 대장 canvas (S838S070800_canvas.jsp)
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

	TableModel = new DoyosaeTableModel("M838S070800E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	String CheckDate="", WriteDate="", ApprovalDate="",
			DeviationsSubject="", Improvement="", TotalBigo="";
	if(RowCount>0) {
		CheckDate=TableModel.getValueAt(0, 0).toString().trim() ;
		WriteDate=TableModel.getValueAt(0, 5).toString().trim() ;
		ApprovalDate=TableModel.getValueAt(0, 7).toString().trim() ;
		DeviationsSubject=TableModel.getValueAt(0, 1).toString().trim() ;
		Improvement=TableModel.getValueAt(0, 2).toString().trim() ;
		TotalBigo=TableModel.getValueAt(0, 3).toString().trim() ;
	}
	
	// 구분, 점검항목
// 	jArray.put( "member_key", member_key);
	String GV_CHECK_GUBUN = "";
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S070800E134", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(37)
	
	// 표1에 들어갈 데이터 -> 자바스크립트 배열로 가공
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<CheckCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
		DataArray.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," ); // inspection_point(check_gubun_sm)
		DataArray.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," ); // latent_foreign_possiblity(check_note)
		DataArray.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" + "," ); // measure(standard_guide)
		DataArray.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," ); // measure_yn
		DataArray.append( "'" + TableModel.getValueAt(i, 13).toString().trim() + "'" + "," ); // inspection_result
		DataArray.append( "'" + TableModel.getValueAt(i, 14).toString().trim() + "'" + "" ); // bigo
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");

	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight1st = 75;
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowCount = <%=CheckCount%> ; // 표1의 행 개수(체크리스트행 개수)
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid1_HeightEnd = HaedText_HeightEnd + DataGrid1_RowHeight1st 
							+ (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이( 상단텍스트 끝 위치 + (행개수 * 행높이) + 하단 기준안내문 공간)
							
	// 표2 영역
	var DataGrid2_RowHeight1st = 50; // 표2의 첫번째 행 높이
	var DataGrid2_RowHeight = 25; // 표2의 데이터 행 높이
	var DataGrid2_HeightStart = DataGrid1_HeightEnd+20 ; // 표2 시작위치(표1영역 끝 높이+20)
	var DataGrid2_HeightEnd = DataGrid2_HeightStart + DataGrid2_RowHeight1st ; // 표2 끝나는 위치(시작위치 + 첫번째 행높이 + doc.ready에서 구하는 데이터줄수)
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++)
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
    	//표1 열너비로 표2 열너비 설정
    	DataGrid2.col_head_width[0] = DataGrid1.col_head_width[0] 
    								+ DataGrid1.col_head_width[1]
    								+ DataGrid1.col_head_width[2];
    	DataGrid2.col_head_width[1] = DataGrid1.col_head_width[3];
    	DataGrid2.col_head_width[2] = DataGrid1.col_head_width[4] 
									+ DataGrid1.col_head_width[5]
									+ DataGrid1.col_head_width[6];
    	
    	// 표2 높이 계산(라인 수)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	var DataGrid2_LineCount = DataGrid2.getLineCount(ctx_temp) ; // 표2 데이터부분 줄수배열(부적합,개선조치)
    	DataGrid2_HeightEnd += DataGrid2_LineCount * DataGrid2_RowHeight ;
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid2_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y
    	
		// 그리기
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd-20);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid1_HeightEnd);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart, pointEX, pointEY);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HSC-PP-01-E 비금속성 이물관리' ;
			var middle_info = '비금속성 이물관리' ;
			var bottom_info1 = ' 점검일 : <%=CheckDate%>'  ;
			var bottom_info2 = ' * 1회/월 점검' ;
			var approval_box_width = 190; //결재박스 너비(30 + 80 + 80)
			// 헤드텍스트
			ctx_fillText(ctx, sx, sy, top_info, 'black', vTextStyle, 'start','top');
			ctx_fillText(ctx, (sx+ex-approval_box_width)/2, sy+30, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			ctx_fillText(ctx, sx, ey, bottom_info1, 'black', vTextStyleBold, 'start','bottom');
			ctx_fillText(ctx, ex-approval_box_width-20, ey, bottom_info2, 'black', vTextStyleBold, 'end','bottom');
			// 결재 박스
			ctx_Box(ctx, ex-approval_box_width, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			ctx_Line(ctx, ex-approval_box_width+30, sy, ex-approval_box_width+30, ey, 'black', 2); // 세로선
			ctx_Line(ctx, ex-(approval_box_width-30)/2, sy, ex-(approval_box_width-30)/2, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width+30, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_Line(ctx, ex-approval_box_width+30, ey-30, ex, ey-30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-approval_box_width+15, sy+30, '결', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width+15, ey-30, '재', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*3/4, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1/4, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
			var bottom_write = '/' ;
			var bottom_approval = '/' ;
			if('<%=WriteDate%>'.length>0) {
				var date = new Date('<%=WriteDate%>');
				bottom_write = ("0" + (date.getMonth() + 1)).slice(-2) + ' / ' + ("0" + date.getDate()).slice(-2) ;
			}
			if('<%=ApprovalDate%>'.length>0) {
				var date = new Date('<%=ApprovalDate%>');
				bottom_approval = ("0" + (date.getMonth() + 1)).slice(-2) + ' / ' + ("0" + date.getDate()).slice(-2) ;
			}
			ctx_fillText(ctx, ex-(approval_box_width-30)*3/4, ey-15, bottom_write, 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1/4, ey-15, bottom_approval, 'black', vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["작업공정","점검사항","잠재이물가능성","예방법","예방법 실행여부 (O,X)","점검결과 (O,X)","비고"],
		col_head_width:[100,100,230,440,100,100,100],
		col_data:<%=DataArray%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid1_RowHeight1st)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선(이중선)
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i<this.col_head_width.length-1) // 마지막엔 세로선 그릴필요X
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
// 				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, this.col_head[i],
						'black', vTextStyle, 'center','middle', this.col_head_width[i]-10, DataGrid1_RowHeight1st/3);
			}
			
			// 데이터
			var col_data_y = col_head_y ;
			var col_data_y_1st_top = col_head_y; // 1번째 열 합치기 기준 y좌표
			var col_data_y_2nd_top = col_head_y; // 2번째 열 합치기 기준 y좌표
			var col_data_y_3rd_top = col_head_y; // 3번째 열 합치기 기준 y좌표
			for(i=0; i<this.col_data.length; i++){
				col_data_y += DataGrid1_RowHeight ;
				var col_data_y_center = col_data_y - DataGrid1_RowHeight/2 ;
				var col_data_x = sx ;
				for(j=0; j<this.col_data[i].length; j++){
					col_data_x += this.col_head_width[j] ;
					var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
					if(j==0) { // 작업공정(같은데이터 열합치기, 줄바꿈)
						if(i<this.col_data.length-1 && this.col_data[i][j]==this.col_data[i+1][j]) {
							// 아무것도 안함
						} else {
							var col_data_y_1st_center = col_data_y - (col_data_y-col_data_y_1st_top)/2;
							ctx_wrapText(ctx, col_data_x_center, col_data_y_1st_center, this.col_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-10, DataGrid1_RowHeight);
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
							col_data_y_1st_top = col_data_y ; // 열 합치기 기준 y좌표 갱신
						}
					} else if(j==1) { // 점검사항(같은데이터 열합치기)
						if(i<this.col_data.length-1 && this.col_data[i][j]==this.col_data[i+1][j] && this.col_data[i][j]!='') {
							// 아무것도 안함
						} else {
							var col_data_y_2nd_center = col_data_y - (col_data_y-col_data_y_2nd_top)/2;
							ctx_fillText(ctx, col_data_x_center, col_data_y_2nd_center, 
									this.col_data[i][j], 'black', vTextStyle, 'center','middle');
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
							col_data_y_2nd_top = col_data_y ; // 열 합치기 기준 y좌표 갱신
						}
					} else if(j==2) { // 잠재이물가능성(같은데이터 열합치기, 좌측정렬)
						if(i<this.col_data.length-1 && this.col_data[i][j]==this.col_data[i+1][j] && this.col_data[i][j]!='') {
							// 아무것도 안함
						} else {
							var col_data_y_3rd_center = col_data_y - (col_data_y-col_data_y_3rd_top)/2;
							ctx_fillText(ctx, col_data_x-this.col_head_width[j]+5, col_data_y_3rd_center,
									this.col_data[i][j], 'black', vTextStyle, 'start','middle');
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
							col_data_y_3rd_top = col_data_y ; // 열 합치기 기준 y좌표 갱신
						}
					} else if(j==3) { // 예방법(좌측정렬)
						ctx_fillText(ctx, col_data_x-this.col_head_width[j]+5, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'start','middle');
						ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
					} else if(j==4||j==5) { // 예방법 실행여부&점검결과(O,X)
						var check_result = '';
						if(this.col_data[i][j]=='Y') check_result = 'O';
						else if(this.col_data[i][j]=='N') check_result = 'X';
	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, check_result, 'black', vTextStyle, 'center','middle');
	 					ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
					} else {
	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyle, 'center','middle');
	 					ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y, col_data_x, col_data_y, 'black', 1); // 가로선
					}
				}
			}
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 정의
	var DataGrid2 = {
		col_head:["점검 시 이탈사항","개선조치사항","비고"],
		col_head_width:[0,0,0], // doc.ready에서 지정
		col_data:["<%=DeviationsSubject%>","<%=Improvement%>","<%=TotalBigo%>"],
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid2_RowHeight1st, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid2_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid2_RowHeight1st)/2 ;
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
						'black', vTextStyle, 'start','top', this.col_head_width[i]-10, DataGrid2_RowHeight);
				col_data_x += this.col_head_width[i] ;
			}
			
		}, // drawGrid function end
		
		getLineCount: function(ctx) { // 표2의 줄수(부적합사항&시정 및 개선조치)
			ctx.font = vTextStyle;
			var col_lineCount = 4; // 최소 줄수 : 4줄
			var deviations_lineCount = ctx_wrapText_lineCount(ctx, this.col_data[0], this.col_head_width[0]-10); // 이탈사항 줄 개수
			var improvement_lineCount = ctx_wrapText_lineCount(ctx, this.col_data[1], this.col_head_width[1]-10); // 개선조치 줄 개수
			var bigo_lineCount = ctx_wrapText_lineCount(ctx, this.col_data[2], this.col_head_width[2]-10); // 비고 줄 개수
			
			// 가장 큰 줄수를 저장
			if(deviations_lineCount > col_lineCount) col_lineCount = deviations_lineCount;
			if(improvement_lineCount > col_lineCount) col_lineCount = improvement_lineCount;
			if(bigo_lineCount > col_lineCount) col_lineCount = bigo_lineCount;
			
			return col_lineCount ;
		}
	} ; // DataGrid2(표2) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>