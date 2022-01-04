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
일일위생 점검일지 canvas (S838S050100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CHECK_DURATION="",GV_PAGE_START="" ;

	if(request.getParameter("check_duration")== null)
		GV_CHECK_DURATION = "";
	else
		GV_CHECK_DURATION = request.getParameter("check_duration");

	// 구분, 점검항목
	String GV_CHECK_GUBUN = "";
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");

	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 6;

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);

	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S050100E134", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(28)

	jArray.put( "check_duration", GV_CHECK_DURATION);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * CheckCount * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * CheckCount * GV_PAGE_COUNT);
	
	TableModel = new DoyosaeTableModel("M838S050100E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 점검일자(기간), 점검자(정), 점검자(부)
	String CheckDuration = "", WritorMain = "", WritorSecond = "" ;
	if(RowCount>0) {
		CheckDuration = TableModel.getValueAt(0, 0).toString().trim();
		WritorMain = TableModel.getValueAt(0, 15).toString().trim();
		WritorSecond = TableModel.getValueAt(0, 16).toString().trim();
	}
	
	StringBuffer CheckGubunMid = new StringBuffer();
	StringBuffer CheckGubunSm = new StringBuffer();
	StringBuffer CheckNote = new StringBuffer();
	
	CheckGubunMid.append("[");
	CheckGubunSm.append("[");
	CheckNote.append("[");
	if(RowCount>=CheckCount) {
		for(int i=0; i<CheckCount; i++) {
			if(i==CheckCount-1) {
				CheckGubunMid.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" );
				CheckGubunSm.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" );
				CheckNote.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" );
			} else {
				CheckGubunMid.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," );
				CheckGubunSm.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," );
				CheckNote.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," );
			}
		}
	}
	CheckGubunMid.append("]");
	CheckGubunSm.append("]");
	CheckNote.append("]");
	
	// 결과 값, 일자, 부적합이탈사항, 개선조치사항
	int CheckRow = RowCount / CheckCount ;
	StringBuffer CheckValue = new StringBuffer();
	StringBuffer CheckDate = new StringBuffer();
	StringBuffer CheckTime = new StringBuffer();
	StringBuffer IncongNote = new StringBuffer();
	StringBuffer ImproveNote = new StringBuffer();
	
	CheckValue.append("[");
	CheckDate.append("[");
	CheckTime.append("[");
	IncongNote.append("[");
	ImproveNote.append("[");
	if(RowCount>=CheckCount) {
		for(int i=0; i<CheckRow; i++) {
			CheckValue.append("[");
			for(int j=0; j<CheckCount; j++) {
				int CheckIndex = i * CheckCount +j;
				if(j==CheckCount-1) {
					CheckValue.append( "'" + TableModel.getValueAt(CheckIndex, 13).toString().trim() + "'" );
				} else {
					CheckValue.append( "'" + TableModel.getValueAt(CheckIndex, 13).toString().trim() + "'" + "," );
				}
			}
			if(i==CheckRow-1) {
				CheckValue.append("]");
				CheckDate.append( "'" + TableModel.getValueAt(i*CheckCount, 1).toString().trim() + "'" );
				CheckTime.append( "'" + TableModel.getValueAt(i*CheckCount, 2).toString().trim() + "'" );
				IncongNote.append( "'" + TableModel.getValueAt(i*CheckCount, 17).toString().trim() + "'" );
				ImproveNote.append( "'" + TableModel.getValueAt(i*CheckCount, 18).toString().trim() + "'" );
			} else {
				CheckValue.append("],");
				CheckDate.append( "'" + TableModel.getValueAt(i*CheckCount, 1).toString().trim() + "'" + "," );
				CheckTime.append( "'" + TableModel.getValueAt(i*CheckCount, 2).toString().trim() + "'" + "," );
				IncongNote.append( "'" + TableModel.getValueAt(i*CheckCount, 17).toString().trim() + "'" + "," );
				ImproveNote.append( "'" + TableModel.getValueAt(i*CheckCount, 18).toString().trim() + "'" + "," );
			}
		}
	}
	CheckValue.append("]");
	CheckDate.append("]");
	CheckTime.append("]");
	IncongNote.append("]");
	ImproveNote.append("]");

// 	System.out.println(CheckGubunMid + "\n" + CheckGubunSm + "\n" + CheckNote);

%>

<script type="text/javascript">	
	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 50; // 표1의 1번째 행 높이
	var DataGrid1_RowCount = <%=CheckCount%>; // 표1의 행 개수(체크문항 개수)
	var DataGrid1_RowCount_Extra = 4; // 표1의 늘릴 행개수(헤드부분, 안내문, 두줄짜리 등등...)
	var DataGrid1_RowCount_IncongImprove = 0 ; // 표1의 하단부분 줄수(부적합/이탈사항 또는 개선조치사항)
	
	var DataGrid1_ColWidth = 50; // 표1의 열 너비
	var DataGrid1_ColWidth1st = DataGrid1_ColWidth-40; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = DataGrid1_ColWidth+40; // 표1의 2번째 열 너비
<%-- 	var DataGrid1_DataCount = <%=CheckRow%>; // 표1의 열 개수 --%>
	var DataGrid1_DataCount = <%=GV_PAGE_COUNT%>; // 표1의 열 개수
	var DataGrid1_HeightStart = HaedText_HeightEnd ; // 표1 시작위치(헤드텍스트영역 끝 높이)
	var DataGrid1_HeightEnd = DataGrid1_HeightStart   // 표1 끝나는 위치(시작위치 + 행개수 * 행높이)
							+ (DataGrid1_RowCount + DataGrid1_RowCount_Extra) * DataGrid1_RowHeight	;
			
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	var DataGrid1_RowCount_Incong = DataGrid1.getIncongLineCount(ctx_temp) ; // 표1의 하단부분 줄수(부적합/이탈사항)
    	var DataGrid1_RowCount_Improve = DataGrid1.getImproveLineCount(ctx_temp) ; // 표1의 하단부분 줄수(개선조치사항)
    	if(DataGrid1_RowCount_Incong > DataGrid1_RowCount_Improve)
    		DataGrid1_RowCount_IncongImprove = DataGrid1_RowCount_Incong;
    	else
    		DataGrid1_RowCount_IncongImprove = DataGrid1_RowCount_Improve;
    	DataGrid1_HeightEnd += DataGrid1_RowCount_IncongImprove * DataGrid1_RowHeight + 100 ;
		DataGrid1.col_incongimprove_note_height = DataGrid1_RowHeight * DataGrid1_RowCount_IncongImprove ; //개선조치사항 높이(이부분에 세로선 안 그음)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1.col_head_width[0] + DataGrid1.col_head_width[1] 
    					+ DataGrid1.col_head_width[2] + DataGrid1.col_head_width[3] 
    					+ DataGrid1_ColWidth * DataGrid1_DataCount + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
		
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
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HS-PP-04-A 일일위생점검일지' ;
			var middle_info = '일일위생 점검일지' ;
			var bottom_info1 = '◆ 점검주기 : 1회/일 이상';
			// 점검일자(기간) 데이터 쓰기
			if('<%=CheckDuration%>'.length > 0) {
				var check_duration = '<%=CheckDuration%>'.split('~') ;
				var check_duration_start = check_duration[0].split("-");
				var check_duration_end = check_duration[1].split("-");
				var bottom_info3 = '◆ 작성일 : '+ check_duration_start[0] + '년 '
									+ check_duration_start[1] + '월 ' + check_duration_start[2] + '일 ~ '
									+ check_duration_end[1] + '월 ' + check_duration_end[2] + '일';
			} else {
				var bottom_info3 = '◆ 작성일 : '+ blank_tab + blank_tab + '년'
									+ blank_tab + ' 월' + blank_tab + ' 일   ~  '
									+ blank_tab + ' 월' + blank_tab + ' 일';
			}
			if('<%=WritorMain%>'.length > 0) var writor_main = '<%=WritorMain%>' ;
			else var writor_main = blank_tab + blank_tab + blank_tab ;
			if('<%=WritorSecond%>'.length > 0) var writor_second = '<%=WritorSecond%>' ;
			else var writor_second = blank_tab + blank_tab + blank_tab ;
			var bottom_info4 = '◆ 담당팀 : 품질관리팀  (정)'+ writor_main +' / (부)'+ writor_second ;
			
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2, sy+20, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			ctx_fillText(ctx, sx+4, ey-30, bottom_info1, 'black', 'bold 15px 맑은고딕', 'start','bottom');	
			ctx_fillText(ctx, ex-10, ey-30, bottom_info3, 'black', 'bold 15px 맑은고딕', 'end','bottom');	
// 			ctx_fillText(ctx, sx+4, ey-5, '', 'black', 'bold 15px 맑은고딕', 'start','bottom');	
			ctx_fillText(ctx, ex-10, ey-5, bottom_info4, 'black', 'bold 15px 맑은고딕', 'end','bottom');	
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:[ "","구    분","점    검    항    목","일자","월","화","수","목","금","토" ],
		col_head_width:[ 30,30,600,60,DataGrid1_ColWidth,DataGrid1_ColWidth,DataGrid1_ColWidth,DataGrid1_ColWidth,DataGrid1_ColWidth,DataGrid1_ColWidth],
		col_check_gubun_mid:<%=CheckGubunMid%>,
		col_check_gubun_sm:<%=CheckGubunSm%>,
		col_check_note:<%=CheckNote%>,
		col_etc:["","평가","부적합 /특이사항","결재","점검","승인","개선조치사항"],
		col_incong_note:<%=IncongNote%>,
		col_improve_note:<%=ImproveNote%>,
		col_check_value:<%=CheckValue%>, 
		col_check_date:<%=CheckDate%>,
		col_check_time:<%=CheckTime%>,
		col_approval_width:30, // '결재' 텍스트 들어가는 칸 너비
		col_improve_width:60, // '개선조치사항' 텍스트 들어가는 칸 너비
		col_incongimprove_note_height: DataGrid1_RowHeight * DataGrid1_RowCount_IncongImprove , //개선조치사항 높이(이부분에 세로선 안 그음)
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드부분
			
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = col_head_y-(DataGrid1_RowHeight1st/2);
			var col_head_x = sx; // head의 x좌표
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 2); // head 가로선(굵게)
			for(i=0; i<this.col_head.length; i++) {
				col_head_x += this.col_head_width[i];
				var col_head_x_center = col_head_x-(this.col_head_width[i]/2);
				
				if(i==this.col_head.length-1) {
// 					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==0) {
					ctx_Line(ctx, col_head_x, col_head_y , col_head_x, ey, 'black', 1); // 세로선
				} else if(i==1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center-(this.col_head_width[i-1]/2), col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==2) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, col_head_y, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==3) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey-this.col_incongimprove_note_height, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else {
// 					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
// 					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				}
			}
			
			// 점검항목부분
			var col_check_y = col_head_y ;
			var col_check_y_1st_top = col_check_y ;
			var col_check_y_2nd_top = col_check_y ;
			var col_check_x_1st = sx + this.col_head_width[0] ; 
			var col_check_x_2nd = col_check_x_1st + this.col_head_width[1] ;
			var col_check_x_1st_center = col_check_x_1st - (this.col_head_width[0]/2);
			var col_check_x_2nd_center = col_check_x_2nd - (this.col_head_width[1]/2);
			for(i=0; i<this.col_check_note.length; i++) {
				col_check_y += DataGrid1_RowHeight ;
				var col_check_y_center = col_check_y - DataGrid1_RowHeight/2 ;
				var col_check_y_1st_center = col_check_y_1st_top + (col_check_y - col_check_y_1st_top)/2;
				var col_check_y_2nd_center = col_check_y_2nd_top + (col_check_y - col_check_y_2nd_top)/2;
				
				if(i == this.col_check_note.length-1) { // 마지막 행 : 다음꺼와 비교없이 무조건 데이터 뿌림
					ctx_fillColor(ctx, sx+1, col_check_y_1st_top+1, 
							sx + this.col_head_width[0] + this.col_head_width[1]-1, col_check_y + DataGrid1_RowHeight - 1, '#ffffff'); // 좌측 구분명 배경(흰색)
					col_check_y += DataGrid1_RowHeight ;
					col_check_y_center += DataGrid1_RowHeight/2 ;
					col_check_y_1st_center += DataGrid1_RowHeight/2 ;
					ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1);
					ctx_wrapText(ctx, sx + (this.col_head_width[0] + this.col_head_width[1])/2, col_check_y_1st_center, this.col_check_gubun_mid[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[0] + this.col_head_width[1], DataGrid1_RowHeight);
		 			// 점검항목
		 			ctx_wrapText(ctx, col_check_x_2nd+10, col_check_y_center, this.col_check_note[i],
							'black', vTextStyle, 'left','middle', this.col_head_width[2]+this.col_head_width[3]-10, DataGrid1_RowHeight);
				} else if(i == 3) {	// 작업전 개인위생 4번. 문장이 길어서.
					col_check_y += DataGrid1_RowHeight ;
					col_check_y_center += DataGrid1_RowHeight/2 ;
					col_check_y_2nd_center += DataGrid1_RowHeight/2
					ctx_Line(ctx, col_check_x_1st, col_check_y, ex, col_check_y, 'black', 1);
					ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[1]-10, DataGrid1_RowHeight);
					col_check_y_2nd_top = col_check_y;
					// 점검항목
					ctx_wrapText(ctx, col_check_x_2nd+10, col_check_y_center, this.col_check_note[i],
							'black', vTextStyle, 'left','middle', this.col_head_width[2]+this.col_head_width[3]-10, DataGrid1_RowHeight);
				} else {
					if(this.col_check_gubun_mid[i]==this.col_check_gubun_mid[i+1]) { // 구분 대분류가 다음꺼와 같으면 : 넘어감
						if(this.col_check_gubun_sm[i]==this.col_check_gubun_sm[i+1]) { // 구분 중분류가 다음꺼와 같으면 : 넘어감
							ctx_Line(ctx, col_check_x_2nd, col_check_y, ex, col_check_y, 'black', 1);
						} else { // 구분 중분류가 다음꺼와 다르면 : 중분류 텍스트 뿌려줌
							ctx_Line(ctx, col_check_x_1st, col_check_y, ex, col_check_y, 'black', 1);
							ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
									'black', vTextStyleBold, 'center','middle', this.col_head_width[1]-10, DataGrid1_RowHeight);
							col_check_y_2nd_top = col_check_y;
						}
					} else { // 구분 대분류가 다음꺼와 다르면 : 대분류&중분류(마지막) 텍스트 뿌려줌
						ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1);
						ctx_wrapText(ctx, col_check_x_1st_center, col_check_y_1st_center, this.col_check_gubun_mid[i],
								'black', vTextStyleBold, 'center','middle', this.col_head_width[0]-10, DataGrid1_RowHeight);
						ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
								'black', vTextStyleBold, 'center','middle', this.col_head_width[1]-10, DataGrid1_RowHeight);
						col_check_y_1st_top = col_check_y;
						col_check_y_2nd_top = col_check_y;
					}
					// 점검항목
					ctx_wrapText(ctx, col_check_x_2nd+10, col_check_y_center, this.col_check_note[i],
							'black', vTextStyle, 'left','middle', this.col_head_width[2]+this.col_head_width[3], DataGrid1_RowHeight);
				}
			}
			
			// 점검항목 결과 부분
			var col_check_value_x = sx + this.col_head_width[0] + this.col_head_width[1] + this.col_head_width[2] + this.col_head_width[3];
// 			for(i=0; i<this.col_check_value.length; i++) {
			for(i=0; i<DataGrid1_DataCount; i++) {
				col_check_value_x += DataGrid1_ColWidth;
				
				// 데이터 텍스트
				if(i < this.col_check_value.length) {
					var check_date = new Date(this.col_check_date[i]);
					var check_date_index = check_date.getDay()+3; // getDay:요일 가져오기(일요일0~토요일6)
// 					col_check_value_x += this.col_head_width[check_date_index];
					var col_check_value_x_center = col_check_value_x-(this.col_head_width[check_date_index]/2);
					var col_check_value_y_center = sy + DataGrid1_RowHeight1st - DataGrid1_RowHeight/2 ;
					var col_check_value_y_1st_center = sy + DataGrid1_RowHeight1st/2 ;
					// 요일 표시
					ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_1st_center, this.col_head[check_date_index], 'black', vTextStyleBold, 'center','middle');
					// 결과 표시
					for(j=0; j<this.col_check_value[i].length; j++) {
						col_check_value_y_center += DataGrid1_RowHeight ;
						var check_value = '';
						if(this.col_check_value[i][j]=='Y') {
							check_value = 'O';
						} else if(this.col_check_value[i][j]=='N') {
							check_value = 'X';
						} 
						if(j==3 || j==27) { // 두줄 높이
							col_check_value_y_center += DataGrid1_RowHeight ;
							ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_center-DataGrid1_RowHeight/2, check_value, 'black', vTextStyleBold, 'center','middle');
						} else {
							ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_center, check_value, 'black', vTextStyleBold, 'center','middle');
						}
					}
				}
				// 세로선 긋기
				if(i<this.col_head.length-1) 
					ctx_Line(ctx, col_check_value_x, sy, col_check_value_x, ey-this.col_incongimprove_note_height, 'black', 1); // 세로선
			}
			
			// 하단 기타 부분(부적합/이탈사항, 개선조치 사항)
			var col_etc_y = col_check_y ;
			ctx_fillColor(ctx, sx+1, col_etc_y+1, sx + this.col_head_width[0] + this.col_head_width[1]-1, ey-1, '#ffffff'); // 좌측 구분명 배경(흰색)
			var col_etc_x_center = sx + (this.col_head_width[0] + this.col_head_width[1])/2 ;
			var col_etc_y_1st_center = col_etc_y + 100/2 ;
			var col_etc_y_2nd_center = col_etc_y + 100 + this.col_incongimprove_note_height/2 ;
			ctx_Line(ctx, sx, col_etc_y + 100, ex, col_etc_y + 100, 'black', 1);
			ctx_wrapText(ctx, col_etc_x_center, col_etc_y_1st_center, this.col_etc[1],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[0] + this.col_head_width[1], DataGrid1_RowHeight);
			ctx_wrapText(ctx, col_etc_x_center, col_etc_y_2nd_center, this.col_etc[2],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[0] + this.col_head_width[1], DataGrid1_RowHeight);
			
			
			// 평가사항(appraisal) 데이터 쓰기
			var col_etc_x = sx + this.col_head_width[0] + this.col_head_width[1] ;
			var col_etc_x_1st_width = this.col_head_width[2] - this.col_approval_width ;
			var col_incong_y = col_etc_y ;
			
			var appraisal_note1 = '1. 평가 기준';
			var appraisal_note2 = '가. 양호(O) : 전반적으로 위생관리가 완전하게 준수된 상태';
			var appraisal_note3 = '나. 불량(X) : 위생관리가 준수되지 않는 상태 - 즉시 개선조치(재청소,소독,교육 등)';
			var appraisal_note4 = '2. 평가결과 부적합(불량)의 경우 종사자에 대한 위생교육과 현장에서 개선조치';

			var lineNum1 = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 5, appraisal_note1,
					'black', vTextStyleBold, 'left','top', col_etc_x_1st_width-10, DataGrid1_RowHeight);
			var lineNum2 = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 25, appraisal_note2,
					'black', vTextStyleBold, 'left','top', col_etc_x_1st_width-10, DataGrid1_RowHeight);
			var lineNum3 = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 45, appraisal_note3,
					'black', vTextStyleBold, 'left','top', col_etc_x_1st_width-10, DataGrid1_RowHeight);
			var lineNum4 = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 65, appraisal_note4,
					'black', vTextStyleBold, 'left','top', col_etc_x_1st_width-10, DataGrid1_RowHeight);			
			
			// 부적합/이탈사항 데이터 쓰기
			var col_etc_x_2nd_width = (ex - sx - 2*(this.col_head_width[0] + this.col_head_width[1]))/2 ;
			var col_incong_y = col_etc_y + 100 ;
			for(i=0; i<this.col_incong_note.length; i++) {
				if(this.col_incong_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var incong_note = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_incong_note[i];
					var lineNum = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 5, incong_note,
						'black', vTextStyleBold, 'left','top', col_etc_x_2nd_width-10, DataGrid1_RowHeight);
					col_incong_y += (lineNum) * DataGrid1_RowHeight;
				}
			}
			
			// 개선조치사항 데이터 쓰기
			var col_etc_x_3rd_width = (ex - sx - 2*(this.col_head_width[0] + this.col_head_width[1]))/2 ;
			var col_improve_y = col_etc_y + 100 ;
			for(i=0; i<this.col_improve_note.length; i++) {
				if(this.col_improve_note[i].length > 0) { // 개선조치사항이 있을때만
					var improve_note = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_improve_note[i];
					var lineNum = ctx_wrapText(ctx, col_etc_x+col_etc_x_2nd_width+this.col_head_width[0] + this.col_head_width[1]+10,
							col_improve_y + 5, improve_note,'black', vTextStyleBold, 'left','top', col_etc_x_3rd_width-10, DataGrid1_RowHeight);
					col_improve_y += (lineNum) * DataGrid1_RowHeight;
				}
			}

			// 하단 결재 부분
			var col_approval_x_start = sx + this.col_head_width[0] + this.col_head_width[1] + this.col_head_width[2] ;
			var col_approval_x_end = col_approval_x_start + this.col_head_width[3] ;
			var col_approval_x_1st_center = col_approval_x_start - this.col_approval_width/2 ;
			var col_approval_x_2nd_center = col_approval_x_end - this.col_head_width[3]/2 ;
			var col_approval_y_start = col_etc_y ;
			var col_approval_y_end = col_approval_y_start + 100 ;
			var col_approval_y_center = col_etc_y + 50 ;
			var col_approval_y_1st_center = col_approval_y_start + 25 ;
			var col_approval_y_2nd_center = col_approval_y_start + 75 ;
			ctx_fillColor(ctx, col_approval_x_start-this.col_approval_width, col_approval_y_start+1, col_approval_x_end-1, col_approval_y_end-1, '#ffffff'); // 좌측 구분명 배경(흰색)
			ctx_Line(ctx, col_approval_x_start-this.col_approval_width, col_etc_y, col_approval_x_start-this.col_approval_width, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_start, col_etc_y, col_approval_x_start, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_start, col_approval_y_center, ex, col_approval_y_center, 'black', 1);
			ctx_wrapText(ctx, col_approval_x_1st_center, col_approval_y_center, this.col_etc[3],
					'black', vTextStyleBold, 'center','middle', this.col_approval_width-5, DataGrid1_RowHeight);
			ctx_wrapText(ctx, col_approval_x_2nd_center, col_approval_y_1st_center, this.col_etc[4],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[3], DataGrid1_RowHeight);
			ctx_wrapText(ctx, col_approval_x_2nd_center, col_approval_y_2nd_center, this.col_etc[5],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[3], DataGrid1_RowHeight);
			  
			// 개선조치사항 부분
			var col_improve_x_start = col_etc_x + col_etc_x_2nd_width ;
			var col_improve_x_end = col_improve_x_start + this.col_head_width[0] + this.col_head_width[1];
			var col_improve_y_start = col_approval_y_end ;
			var col_improve_y_end = col_improve_y_start + this.col_incongimprove_note_height ;
			var col_improve_y_center = col_etc_y + this.col_incongimprove_note_height/2 ;
			
// 			ctx_fillColor(ctx, col_improve_x_start-this.col_improve_width, col_improve_y_start+1, col_improve_x_end-1, col_improve_y_end-1, '#ffffff'); // 좌측 구분명 배경(흰색)
			ctx_Line(ctx, col_improve_x_start, col_improve_y_start, col_improve_x_start, col_improve_y_end, 'black', 1);
			ctx_Line(ctx, col_improve_x_start+this.col_improve_width, col_improve_y_start, 
					col_improve_x_start+this.col_improve_width, col_improve_y_end, 'black', 1);
			ctx_wrapText(ctx, col_improve_x_start+30, col_improve_y_center+100, this.col_etc[6],
					'black', vTextStyleBold, 'center','middle', this.col_improve_width-5, DataGrid1_RowHeight);
			
		}, // drawGrid function end
		
		getIncongLineCount: function(ctx) { // 표1의 하단부분 줄수(부적합/이탈사항, 개선조치사항)
			ctx.font = vTextStyleBold;
		
			var col_incong_width = ( DataGrid1.col_head_width[0] + DataGrid1.col_head_width[1] 
									 + DataGrid1.col_head_width[2] + DataGrid1.col_head_width[3] 
									 + DataGrid1_ColWidth * DataGrid1_DataCount
									 - 2*(this.col_head_width[0] + this.col_head_width[1]) )/2 ;
			
			var col_incong_lineCount = 0;
		
			for(i=0; i<this.col_incong_note.length; i++) {
				if(this.col_incong_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var incong_note = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_incong_note[i];
					col_incong_lineCount += ctx_wrapText_lineCount(ctx, incong_note, col_incong_width-10);
				}
			}
			
			if(col_incong_lineCount < 4) col_incong_lineCount = 4; // 부적합/이탈사항 최소 4줄
			
			return col_incong_lineCount ;
		},
		
		getImproveLineCount: function(ctx) { // 표1의 하단부분 줄수(부적합/이탈사항, 개선조치사항)
			ctx.font = vTextStyleBold;
		
			var col_improve_width = ( DataGrid1.col_head_width[0] + DataGrid1.col_head_width[1] 
									 + DataGrid1.col_head_width[2] + DataGrid1.col_head_width[3] 
									 + DataGrid1_ColWidth * DataGrid1_DataCount
									 - 2*(this.col_head_width[0] + this.col_head_width[1]) )/2 ;
			
			var col_improve_lineCount = 0;
		
			for(i=0; i<this.col_improve_note.length; i++) {
				if(this.col_improve_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var improve_note = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_improve_note[i];
					col_improve_lineCount += ctx_wrapText_lineCount(ctx, improve_note, col_improve_width-10);
				}
			}
			
			if(col_improve_lineCount < 4) col_improve_lineCount = 4; // 개선조치사항 최소 4줄

			return col_improve_lineCount ;
		}
		
	} ; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050100_canvas.jsp" 
							 + "?check_duration=" + "<%=GV_CHECK_DURATION%>"
							 + "&check_gubun=" + "<%=GV_CHECK_GUBUN%>" 
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%> ;// 이전페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050100_canvas.jsp"
							 + "?check_duration=" + "<%=GV_CHECK_DURATION%>"
							 + "&check_gubun=" + "<%=GV_CHECK_GUBUN%>" 
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%> ;// 다음페이지
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
    	<%if( RowCount == CheckCount * GV_PAGE_COUNT ) {%>
        <button id="btn_Next"  class="btn btn-info"  onclick="fn_Next_Page();">다음</button>
        <%}%>
    </p>	
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>