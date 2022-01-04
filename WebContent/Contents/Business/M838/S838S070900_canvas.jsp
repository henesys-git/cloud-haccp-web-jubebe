<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
부적합품 관리대장 canvas (S838S070900_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_INCOG_DATE_START="", GV_INCOG_DATE_END="", GV_PAGE_START="" ;

	if(request.getParameter("check_date_start")== null)
		GV_INCOG_DATE_START = "";
	else
		GV_INCOG_DATE_START = request.getParameter("check_date_start");
	
	if(request.getParameter("check_date_end")== null)
		GV_INCOG_DATE_END = "";
	else
		GV_INCOG_DATE_END = request.getParameter("check_date_end");
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 17;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
// 	jArray.put( "check_date_start", GV_INCOG_DATE_START);
// 	jArray.put( "check_date_end", GV_INCOG_DATE_END);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * GV_PAGE_COUNT);

	TableModel = new DoyosaeTableModel("M838S070900E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	StringBuffer DataArray = new StringBuffer();
	StringBuffer DataArray2 = new StringBuffer();
	DataArray.append("[");
	DataArray2.append("[");
	for(int i=0; i<RowCount; i++) {
		// 품목/원산지
		String PartNmOrignCountry = TableModel.getValueAt(i, 0).toString().trim();
		if(!TableModel.getValueAt(i, 1).toString().trim().equals("")) // 원산지 값이 있을때
			PartNmOrignCountry += " / " + TableModel.getValueAt(i, 1).toString().trim();
		// 해동시작/종료일시
		java.util.Date tempDate ;
		tempDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").parse(TableModel.getValueAt(i, 2).toString().trim());
		String ThawStartDate = new SimpleDateFormat("MM / dd").format(tempDate);
		String ThawStartTime = new SimpleDateFormat("HH : mm").format(tempDate);
		tempDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").parse(TableModel.getValueAt(i, 3).toString().trim());
		String ThawEndDate = new SimpleDateFormat("MM / dd").format(tempDate);
		String ThawEndTime = new SimpleDateFormat("HH : mm").format(tempDate);
		
		DataArray.append("[");
		DataArray.append( "'" + PartNmOrignCountry 	+ "'" + "," ); // part_nm(/orign_country)
		DataArray.append( "'" + ThawStartDate 		+ "'" + "," ); // thaw_start_datetime(일)
		DataArray.append( "'" + ThawStartTime 		+ "'" + "," ); // thaw_start_datetime(시)
		DataArray.append( "'" + ThawEndDate 		+ "'" + "," ); // thaw_end_datetime(일)
		DataArray.append( "'" + ThawEndTime 		+ "'" + "," ); // thaw_end_datetime(시)
		DataArray.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," ); // temperature
		DataArray.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," ); // sign_matter
		DataArray.append( "'" + TableModel.getValueAt(i, 6).toString().trim() + "'" + "," ); // packing_shape
		DataArray.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'" + "," ); // 작성
		DataArray.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + ""  ); // 승인
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
		
		DataArray2.append("[");
		DataArray2.append( "'" + TableModel.getValueAt(i, 9).toString().trim()  + "'" + "," ); // incong_note
		DataArray2.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," ); // improve_note
		DataArray2.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" + ""  ); // bigo_note
		if(i==RowCount-1) DataArray2.append("]");
		else DataArray2.append("],");
	}
	DataArray.append("]");
	DataArray2.append("]");
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 40; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 40; // 표1의 1번째 행 높이
<%-- 	var DataGrid1_RowCount = <%=RowCount%>; // 표1의 행 개수 --%>
	var DataGrid1_RowCount = <%=GV_PAGE_COUNT%>; // 표1의 행 개수
	var DataGrid1_Width = 0 ; // document ready에서 표1칼럼너비 전부 합쳐서 구함
	var DataGrid1_HeightStart = HaedText_HeightEnd ;
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + DataGrid1_RowHeight1st*2
						 + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이( 표 시작위치 + (행개수 * 행높이) )
			
	// 표2 영역
	var Standard_RowHeight = 40; // 표1과 표2사이에 기준안내문 줄 높이
	var DataGrid2_RowHeight1st = 40; // 표2의 첫번째 행 높이
	var DataGrid2_RowHeight = 25; // 표2의 데이터 행 높이
	var DataGrid2_HeightStart = DataGrid1_HeightEnd+Standard_RowHeight*2 ; // 표2 시작위치(표1영역 끝 높이+기준안내문100)
	var DataGrid2_HeightEnd = DataGrid2_HeightStart + DataGrid2_RowHeight1st ; // 표2 끝나는 위치(시작위치 + 첫번째 행높이 + doc.ready에서 구하는 데이터줄수)
						 
    $(document).ready(function () {
    	// 표1의 칼럼너비 전부 합쳐서 표전체너비 구하기
    	for(i=0; i<DataGrid1.col_head_width.length; i++){
    		DataGrid1_Width += DataGrid1.col_head_width[i] ;
    	}
    	
    	//표1 열너비로 표2 열너비 설정
    	DataGrid2.col_head_width[0] = DataGrid1.col_head_width[0] 
    								+ DataGrid1.col_head_width[1]
    								+ DataGrid1.col_head_width[2];
    	DataGrid2.col_head_width[1] = DataGrid1.col_head_width[3]
    								+ DataGrid1.col_head_width[4] 
									+ DataGrid1.col_head_width[5]
									+ DataGrid1.col_head_width[6];
    	DataGrid2.col_head_width[2] = DataGrid1.col_head_width[7]
									+ DataGrid1.col_head_width[8]
									+ DataGrid1.col_head_width[9];
    	
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
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart, pointEX, pointEY);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'JDW-PP-05-B 해동육 관리대장' ;
			var middle_info = '해동육 점검일지' ;
			var bottom_info1 = ' ◆ 담당자 : 생산팀장' ;
			var bottom_info2 = ' ◆ 점검주기 : 작업 시작전' ;
			
			ctx_fillText(ctx, sx+5, sy-15, top_info, 'black', vTextStyle, 'start','middle');
			ctx_fillText(ctx, sx+(ex-sx)/2, sy+35, middle_info, 'black', 'bold 30px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+5, ey-25, bottom_info1, 'black', vTextStyle, 'start','middle');
			ctx_fillText(ctx, sx+(ex-sx)/2+5, ey-25, bottom_info2, 'black', vTextStyle, 'start','middle');
			
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head_1st:["품목/원산지","해동시작","해동시작","해동종료","해동종료","측정온도 (-10~0℃)","표시사항 (O,X)","제품포장상태 (O,X)","결재","결재"],
		col_head_2nd:["품목/원산지","일",	 "시",	 "일",	  "시",	  "측정온도 (-10~0℃)","표시사항 (O,X)","제품포장상태 (O,X)","작성","승인"],
		col_head_width:[160,80,80,80,80,80,80,100,100,100],
		col_data:<%=DataArray%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st*2, '#cccccc'); // 표 헤드 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y_center = sy + (DataGrid1_RowHeight1st + DataGrid1_RowHeight)/2 ;
			var col_head_y_1st = sy + DataGrid1_RowHeight1st ;
			var col_head_y_1st_center = col_head_y_1st - DataGrid1_RowHeight1st/2 ;
			var col_head_y_2nd = col_head_y_1st + DataGrid1_RowHeight1st ;
			var col_head_y_2nd_center = col_head_y_2nd - DataGrid1_RowHeight1st/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y_2nd, ex, col_head_y_2nd, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(this.col_head_1st[i]==this.col_head_2nd[i]) { // 세로칸 합치기
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
	 				ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, this.col_head_2nd[i],
						'black', vTextStyle, 'center','middle', this.col_head_width[i], DataGrid1_RowHeight1st/2);
	 				col_head_x_start = col_head_x;
				} else { // 세로칸 나누기
					ctx_Line(ctx, col_head_x-this.col_head_width[i], col_head_y_1st, col_head_x, col_head_y_1st, 'black', 1); // 가로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i], 'black', vTextStyle, 'center','middle');
					if(i==this.col_head_width.length-1) { // 마지막 열 => col_head_1st 무조건 뿌리고 세로선 안 그림
						var col_head_x_total_center = col_head_x_start + (col_head_x - col_head_x_start)/2 ;
						ctx_fillText(ctx, col_head_x_total_center, col_head_y_1st_center, this.col_head_1st[i], 'black', vTextStyle, 'center','middle');
					} else if(this.col_head_1st[i]==this.col_head_1st[i+1]) {
						ctx_Line(ctx, col_head_x, sy+DataGrid1_RowHeight1st, col_head_x, ey, 'black', 1); // 세로선
					} else {
						ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
						var col_head_x_total_center = col_head_x_start + (col_head_x - col_head_x_start)/2 ;
						ctx_fillText(ctx, col_head_x_total_center, col_head_y_1st_center, this.col_head_1st[i], 'black', vTextStyle, 'center','middle');
						col_head_x_start = col_head_x;
					}
				}
			}
			
			// 데이터
			var col_data_y = col_head_y_2nd ;
// 			for(i=0; i<this.col_data.length; i++){
			for(i=0; i<DataGrid1_RowCount; i++){	
				col_data_y += DataGrid1_RowHeight ;
				// 데이터 텍스트
				if(i < this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid1_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2;
						if(j==5) { // 측정온도(단위넣기)
							ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyle, 'center','middle');
							ctx_fillText(ctx, col_data_x-5, col_data_y_center, '℃', 'black', vTextStyle, 'end','middle');
						} else if(j==6||j==7) { // 표시사항&제품포장상태(체크박스값O,X)
							var v_check_data = '';
							if(this.col_data[i][j]=='Y') v_check_data = 'O';
							else if(this.col_data[i][j]=='N') v_check_data = 'X';
		 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, v_check_data, 'black', vTextStyle, 'center','middle');
						} else {
//	 	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyle, 'center','middle');
							ctx_wrapText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j], DataGrid1_RowHeight/2);
						}
						
					}
				}
				if(i<DataGrid1_RowCount-1) // 마지막줄은 가로선X
					ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			}
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 정의
	var DataGrid2 = {
		col_head:["부적합사항","대책 및 조치사항","비고"],
		col_head_width:[0,0,0], // doc.ready에서 지정
		col_data:<%=DataArray2%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			// 표1과 표2 사이에 기준안내문
			var standard_info1 = " ◆ 관리기준 : 냉장실 온도(-2~5℃), 해동시간(48시간이내), 심부온도 -10~0℃ 이하(심부온도는 해동 종료 전에 측정)" ;
			var standard_info2 = " ◆ 점검방법 : 식별표시확인 및 심부온도측정, 제품포장상태 육안확인" ;
			ctx_fillText(ctx, sx+5, sy-Standard_RowHeight*3/2, standard_info1, 'black', vTextStyle, 'start','middle');
			ctx_fillText(ctx, sx+5, sy-Standard_RowHeight*1/2, standard_info2, 'black', vTextStyle, 'start','middle');
			ctx_Line(ctx, sx, sy-Standard_RowHeight*2, sx, sy, 'black', 1); // 세로선
			ctx_Line(ctx, ex, sy-Standard_RowHeight*2, ex, sy, 'black', 1); // 세로선
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
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
			for(i=0; i<this.col_data.length; i++){
				var col_data_x = sx ;
				for(j=0; j<this.col_data[i].length; j++){
					var col_data_lineCount = 0;
					if(this.col_data[i][j].length>0) {
						var lineCount = ctx_wrapText(ctx, col_data_x+5, col_data_y+5, (i+1)+'. '+this.col_data[i][j],
								'black', vTextStyle, 'start','top', this.col_head_width[j]-10, DataGrid2_RowHeight);
						if(lineCount>col_data_lineCount) col_data_lineCount = lineCount ;
					} else {
						ctx_wrapText(ctx, col_data_x+5, col_data_y+5, (i+1)+'. '+'-',
								'black', vTextStyle, 'start','top', this.col_head_width[j]-10, DataGrid2_RowHeight);
						if(lineCount>col_data_lineCount) col_data_lineCount = lineCount ;
					}
					col_data_x += this.col_head_width[j] ;
				}
				col_data_y += DataGrid2_RowHeight*col_data_lineCount ;
			}
			
		}, // drawGrid function end
		
		getLineCount: function(ctx) { // 표2의 줄수(부적합사항&시정 및 개선조치)
			ctx.font = vTextStyle;
			var incong_lineCount=0, improve_lineCount=0, bigo_lineCount=0 ;
			for(i=0; i<this.col_data.length; i++){
				if(this.col_data[i][0].length>0) // 부적합 줄 개수
					incong_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+this.col_data[i][0], this.col_head_width[0]-10);
				else
					incong_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+'-', this.col_head_width[0]-10);
				
				if(this.col_data[i][1].length>0) // 조치사항 줄 개수
					improve_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+this.col_data[i][1], this.col_head_width[1]-10);
				else
					improve_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+'-', this.col_head_width[1]-10);
				
				if(this.col_data[i][2].length>0) // 비고 줄 개수
					bigo_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+this.col_data[i][2], this.col_head_width[2]-10);
				else
					bigo_lineCount += ctx_wrapText_lineCount(ctx, (i+1)+'. '+'-', this.col_head_width[2]-10);
			}
			
			// 가장 큰 줄수를 저장
			var col_lineCount = 4; // 최소 줄수 : 4줄
			if(incong_lineCount > col_lineCount) col_lineCount = incong_lineCount;
			if(improve_lineCount > col_lineCount) col_lineCount = improve_lineCount;
			if(bigo_lineCount > col_lineCount) col_lineCount = bigo_lineCount;
			
			return col_lineCount ;
		}
	} ; // DataGrid2(표2) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070900_canvas.jsp"
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%>; // 이전페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070900_canvas.jsp"
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%>; // 다음페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
	<p style="text-align:center;" >
		<%if( Integer.parseInt(GV_PAGE_START) > 1 ) {%>
    	<button id="btn_Pre"  class="btn btn-info" onclick="fn_Pre_Page();">이전</button>
    	<%}%>
    	<%if( RowCount == GV_PAGE_COUNT ) {%>
        <button id="btn_Next"  class="btn btn-info"  onclick="fn_Next_Page();">다음</button>
        <%}%>
    </p>
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>