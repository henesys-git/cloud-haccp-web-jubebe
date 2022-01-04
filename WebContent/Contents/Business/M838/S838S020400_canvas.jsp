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
폐기물 관리대장 canvas (S838S020400_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();	
	DoyosaeTableModel TableModel;

	String GV_CHECK_DURATION="",GV_PAGE_START="" ;

	if(request.getParameter("check_duration")== null)
		GV_CHECK_DURATION = "";
	else
		GV_CHECK_DURATION = request.getParameter("check_duration");
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 6;

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_duration", GV_CHECK_DURATION);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * GV_PAGE_COUNT);
	TableModel = new DoyosaeTableModel("M838S020400E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 점검일자(기간), 점검자(정), 점검자(부)
	String CheckDuration = "", WritorMain = "", WritorSecond = "" ;
	if(RowCount>0) {
		CheckDuration = TableModel.getValueAt(0, 0).toString().trim();
		WritorMain = TableModel.getValueAt(0, 14).toString().trim();
// 		WritorSecond = TableModel.getValueAt(0, 12).toString().trim();
	}
	
	StringBuffer CheckDate = new StringBuffer();
	StringBuffer CheckDay = new StringBuffer();
	StringBuffer WasteSubject = new StringBuffer();
	StringBuffer WasteUsage = new StringBuffer();
	StringBuffer CustNm = new StringBuffer();
	StringBuffer WasteCollector = new StringBuffer();
	StringBuffer WasteWeight = new StringBuffer();
	StringBuffer IncongNote = new StringBuffer();
	StringBuffer ImproveNote = new StringBuffer();
	StringBuffer Uniqueness = new StringBuffer();
	
	CheckDate.append("[");
	CheckDay.append("[");
	WasteSubject.append("[");
	WasteUsage.append("[");
	CustNm.append("[");
	WasteCollector.append("[");
	WasteWeight.append("[");
	IncongNote.append("[");
	ImproveNote.append("[");
	Uniqueness.append("[");
	for(int i=0; i<RowCount; i++) {
		if(i==RowCount-1) {
			CheckDate.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" );
			CheckDay.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" );
			WasteSubject.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" );
			WasteUsage.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" );
			CustNm.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" );
			WasteCollector.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" );
			WasteWeight.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" );
			IncongNote.append( "'" + TableModel.getValueAt(i, 17).toString().trim() + "'" );
			ImproveNote.append( "'" + TableModel.getValueAt(i, 18).toString().trim() + "'" );
			Uniqueness.append( "'" + TableModel.getValueAt(i, 19).toString().trim() + "'" );
		} else {
			CheckDate.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," );
			CheckDay.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" + "," );
			WasteSubject.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," );
			WasteUsage.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," );
			CustNm.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "," );
			WasteCollector.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," );
			WasteWeight.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," );
			IncongNote.append( "'" + TableModel.getValueAt(i, 17).toString().trim() + "'" + "," );
			ImproveNote.append( "'" + TableModel.getValueAt(i, 18).toString().trim() + "'" + "," );
			Uniqueness.append( "'" + TableModel.getValueAt(i, 19).toString().trim() + "'" + "," );
		}
	}
	CheckDate.append("]");
	CheckDay.append("]");
	WasteSubject.append("]");
	WasteUsage.append("]");
	CustNm.append("]");
	WasteCollector.append("]");
	WasteWeight.append("]");
	IncongNote.append("]");
	ImproveNote.append("]");
	Uniqueness.append("]");
	
%>

<script type="text/javascript">	
	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	var HeadText_MinWidth = 650;
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 75; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 100; // 표1의 1번째 행 높이
	var DataGrid1_RowHeightEtc = 25; // 표1의 하단 택스트 줄바꿈 높이
	var DataGrid1_RowCount = 7; // 표1의 행 개수
	var DataGrid1_RowCount_Incong = 0 ; // 표1의 하단부분 줄수(이탈사항)
	var DataGrid1_RowCount_Improve = 0 // 표1의 하단부분 줄수(개선조치)
	var DataGrid1_RowCount_Uniqueness = 0 // 표1의 하단부분 줄수(특이사항)
	var DataGrid1_ColWidth = 140; // 표1의 열 너비
	var DataGrid1_ColWidth1st = 140; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = 120; // 표1의 2번째 열 너비
<%-- 	var DataGrid1_DataCount = <%=RowCount%>; // 표1의 열 개수 --%>
	var DataGrid1_DataCount = <%=GV_PAGE_COUNT%>; // 표1의 열 개수
	var DataGrid1_Width = DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
						+ DataGrid1_ColWidth * DataGrid1_DataCount;
	var DataGrid1_Height = HaedText_HeightEnd   // 표1 높이( 상단텍스트 끝 위치 + 1번째행높이 + (행개수 * 행높이) )
						 + DataGrid1_RowHeight1st + (DataGrid1_RowCount * DataGrid1_RowHeight);
			
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	DataGrid1_RowCount_Incong = DataGrid1.getIncongLineCount(ctx_temp) ; // 표1의 하단부분 줄수(부적합/이탈사항)
    	DataGrid1_RowCount_Improve = DataGrid1.getImproveLineCount(ctx_temp) ; // 표1의 하단부분 줄수(개선조치사항)
    	DataGrid1_RowCount_Uniqueness = DataGrid1.getUniquenessLineCount(ctx_temp) ; // 표1의 하단부분 줄수(개선조치사항)
    	DataGrid1_Height += (DataGrid1_RowCount_Incong + DataGrid1_RowCount_Improve + DataGrid1_RowCount_Uniqueness) * DataGrid1_RowHeightEtc ;
    	DataGrid1.col_incong_note_height = DataGrid1_RowHeightEtc * DataGrid1_RowCount_Incong ; //이탈사항 높이
    	DataGrid1.col_improve_note_height = DataGrid1_RowHeightEtc * DataGrid1_RowCount_Improve ; //개선조치 높이
    	DataGrid1.col_uniqueness_height = DataGrid1_RowHeightEtc * DataGrid1_RowCount_Uniqueness ; //특이사항 높이
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2; // 캔버스영역 높이
    	
    	// 표부분이 상단텍스트영역 최소 너비보다 작을경우
    	if(CanvasWidth < HeadText_MinWidth) CanvasWidth = HeadText_MinWidth;
    	
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, 
				DataGrid1_Width + CanvasPadding, pointSY + DataGrid1_Height);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HS-PP-01-D 폐기물 관리대장' ;
			var middle_info = '폐기물 관리대장' ;
			if('<%=CheckDuration%>'.length > 0) {
				var check_duration = '<%=CheckDuration%>'.split('~') ;
				var check_duration_start = check_duration[0].split("-");
				var check_duration_end = check_duration[1].split("-");
				var bottom_info1 = '◆점검일자 : ' + check_duration_start[0] + '년 '
				 				 + check_duration_start[1] + '월 ' + check_duration_start[2] + '일  ~ ' 
				 				 + check_duration_end[1] + '월 ' + check_duration_end[2] + '일' ;
			} else {
				var bottom_info1 = '◆점검일자 : ' + blank_tab + blank_tab + ' 년'
				 				 + blank_tab + ' 월' + blank_tab + ' 일 ~ ' 
				 				 + blank_tab + ' 월' + blank_tab + ' 일' ;
			}
			var bottom_info2 = '◆점검자 : 생산팀 (정)<%=WritorMain%> / (부)<%=WritorSecond%>';
			
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
// 			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2, sy+20, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			ctx_fillText(ctx, ex-350, ey-60, bottom_info1, 'black', 'bold 15px 맑은고딕', 'start','bottom');	
			ctx_fillText(ctx, sx+10, ey-60, '◆ 점검주기 : 발생 시', 'black', 'bold 15px 맑은고딕', 'start','bottom');	
			ctx_fillText(ctx, ex-350, ey-35, bottom_info2, 'black', 'bold 15px 맑은고딕', 'start','bottom');	
			ctx_fillText(ctx, sx+10, ey-35, '◆ 범    례 : 양호  O / 불량 X', 'black', 'bold 15px 맑은고딕', 'start','bottom');
			ctx_fillText(ctx, sx+10, ey-10, '◆ 당사 폐기물 계약업체에 폐기수거내역 및 수거량을 기재', 'black', 'bold 15px 맑은고딕', 'start','bottom');
			
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:[ "","점검내역"],
		col_head_width:[ DataGrid1_ColWidth1st,DataGrid1_ColWidth2nd],
		col_check_gubun_mid:["폐기물 내역","폐기물 내역","폐기물 내역","폐기물 내역","폐기물 내역","결재","결재"],
		col_check_gubun_sm:["품목","용도","수거업체","수거자","수거량(kg)","작성","승인"],
		col_etc:["이탈사항","개선조치","특이사항"],
		col_check_date:<%=CheckDate%>,
		col_check_day:<%=CheckDay%>,
		col_waste_subject:<%=WasteSubject%>,
		col_waste_usage:<%=WasteUsage%>,
		col_cust_nm:<%=CustNm%>,
		col_waste_collector:<%=WasteCollector%>,
		col_waste_weight:<%=WasteWeight%>,
		col_incong_note:<%=IncongNote%>,
		col_improve_note:<%=ImproveNote%>,
		col_uniqueness:<%=Uniqueness%>,
		col_incong_note_height: DataGrid1_RowHeightEtc * DataGrid1_RowCount_Incong , //부적합이탈사항 높이 - document ready에서 재정의
		col_improve_note_height: DataGrid1_RowHeightEtc * DataGrid1_RowCount_Improve , //개선조치사항 높이(이부분에 세로선 안 그음) - document ready에서 재정의
		col_uniqueness_height: DataGrid1_RowHeightEtc * DataGrid1_RowCount_Uniqueness , //개선조치사항 높이(이부분에 세로선 안 그음) - document ready에서 재정의
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx + this.col_head_width[0], sy, ex, sy + DataGrid1_RowHeight1st/2, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_fillColor(ctx, sx, sy, sx + this.col_head_width[0], ey, '#cccccc'); // 좌측 구분명 배경(회색)
			ctx_fillColor(ctx, sx, sy + DataGrid1_RowHeight1st/2, sx + this.col_head_width[0] + this.col_head_width[1], 
					sy + (this.col_check_gubun_mid.length * DataGrid1_RowHeight) + DataGrid1_RowHeight1st, '#cccccc'); // 좌측 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = col_head_y-(DataGrid1_RowHeight1st/2);
			var col_head_x = sx; // head의 x좌표
			ctx_Line(ctx, sx + this.col_head_width[0] + this.col_head_width[1], col_head_y - DataGrid1_RowHeight1st/2, 
					ex, col_head_y - DataGrid1_RowHeight1st/2, 'black', 1); // head 요일/날짜 구분 가로선
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // head 가로선
			for(i=0; i<this.col_head.length; i++) {
				col_head_x += this.col_head_width[i];
				var col_head_x_center = col_head_x-(this.col_head_width[i]/2);
				
				if(i==0) {
					ctx_Line(ctx, col_head_x, col_head_y , col_head_x, ey, 'black', 1); // 세로선
				} else if(i==1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, 
							sy + DataGrid1_RowHeight1st + this.col_check_gubun_mid.length * DataGrid1_RowHeight, 'black', 2); // 세로선
					ctx_fillText(ctx, col_head_x_center-(this.col_head_width[i-1]/2), col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
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
			for(i=0; i<this.col_check_gubun_mid.length; i++) {
				col_check_y += DataGrid1_RowHeight ;
				var col_check_y_center = col_check_y - DataGrid1_RowHeight/2 ;
				var col_check_y_1st_center = col_check_y_1st_top + (col_check_y - col_check_y_1st_top)/2;
				var col_check_y_2nd_center = col_check_y_2nd_top + (col_check_y - col_check_y_2nd_top)/2;
				
				if(i == this.col_check_gubun_mid.length-1) { // 마지막 행 : 다음꺼와 비교없이 무조건 데이터 뿌림
					ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 2);
					ctx_wrapText(ctx, col_check_x_1st_center, col_check_y_1st_center, this.col_check_gubun_mid[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[0]-10, DataGrid1_RowHeight);
		 			ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[1], DataGrid1_RowHeight);
				} else if(i == 4) { // 폐기물내역 마지막부분
					ctx_Line(ctx, sx, col_check_y-2, ex, col_check_y-2, 'black', 1); // 이중선
					ctx_Line(ctx, sx, col_check_y+2, ex, col_check_y+2, 'black', 1); // 이중선
					ctx_wrapText(ctx, col_check_x_1st_center, col_check_y_1st_center, this.col_check_gubun_mid[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[0]-10, DataGrid1_RowHeight);
					ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
							'black', vTextStyleBold, 'center','middle', this.col_head_width[1], DataGrid1_RowHeight);
					col_check_y_1st_top = col_check_y;
					col_check_y_2nd_top = col_check_y;
				} else {
					if(this.col_check_gubun_sm[i]==this.col_check_gubun_sm[i+1]) { // 구분 중분류가 다음꺼와 같으면 : 넘어감
						ctx_Line(ctx, col_check_x_2nd, col_check_y, ex, col_check_y, 'black', 1);
					} else { // 구분 중분류가 다음꺼와 다르면 : 중분류 텍스트 뿌려줌
						ctx_Line(ctx, col_check_x_1st, col_check_y, ex, col_check_y, 'black', 1);
						ctx_wrapText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check_gubun_sm[i],
								'black', vTextStyleBold, 'center','middle', this.col_head_width[1], DataGrid1_RowHeight);
						col_check_y_2nd_top = col_check_y;
					}
				}
			}
			
			// 점검항목 결과 부분
			var col_check_value_x = sx + this.col_head_width[0] + this.col_head_width[1];
			
// 			for(i=0; i<this.col_check_date.length; i++) {
			for(i=0; i<DataGrid1_DataCount; i++) {
				col_check_value_x += DataGrid1_ColWidth;
				var col_check_value_x_center = col_check_value_x-(DataGrid1_ColWidth/2);
				var col_check_value_y_center = sy + DataGrid1_RowHeight1st - DataGrid1_RowHeight/2 ;
				// 세로선 긋기
				if(i<DataGrid1_DataCount-1) 
					ctx_Line(ctx, col_check_value_x, sy, col_check_value_x, 
							sy + DataGrid1_RowHeight1st + this.col_check_gubun_mid.length * DataGrid1_RowHeight, 'black', 1); // 세로선
				// 데이터 텍스트 넣기
				if(i<this.col_check_date.length) {
					// 날짜 표시
					var check_date_split = this.col_check_date[i].split("-");
					var check_date = check_date_split[1] + " / " + check_date_split[2];
					ctx_fillText(ctx, col_check_value_x_center, sy + DataGrid1_RowHeight1st/4, 
							this.col_check_day[i] + " 요일", 'black', vTextStyleBold, 'center','middle');
					ctx_fillText(ctx, col_check_value_x_center, sy + DataGrid1_RowHeight1st*3/4, check_date, 'black', vTextStyleBold, 'center','middle');
					// 결과 표시
					ctx_wrapText(ctx, col_check_value_x_center, col_check_value_y_center += DataGrid1_RowHeight, 
							this.col_waste_subject[i], 'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth, DataGrid1_RowHeight/2);
					ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_center += DataGrid1_RowHeight, 
							this.col_waste_usage[i], 'black', vTextStyleBold, 'center','middle');
					ctx_wrapText(ctx, col_check_value_x_center, col_check_value_y_center += DataGrid1_RowHeight, 
							this.col_cust_nm[i], 'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth, DataGrid1_RowHeight/2);
					ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_center += DataGrid1_RowHeight, 
							this.col_waste_collector[i], 'black', vTextStyleBold, 'center','middle');
					ctx_fillText(ctx, col_check_value_x_center, col_check_value_y_center += DataGrid1_RowHeight, 
							this.col_waste_weight[i], 'black', vTextStyleBold, 'center','middle');
				}
			}
			
			// 하단 기타 부분(부적합/이탈사항, 개선조치 사항)
			var col_etc_x = sx + this.col_head_width[0] ;
			var col_etc_x_center = sx + this.col_head_width[0]/2 ;
			var col_etc_x_width = ex - sx - this.col_head_width[0] ;
			var col_etc_y = col_check_y ;
			var col_incong_y = col_etc_y ;
			var col_improve_y = col_incong_y + this.col_incong_note_height ;
			var col_uniqueness_y = col_improve_y + this.col_improve_note_height ;
			var col_incong_y_center = col_incong_y + this.col_incong_note_height/2 ;
			var col_improve_y_center = col_improve_y + this.col_improve_note_height/2 ;
			var col_uniqueness_y_center = col_uniqueness_y + this.col_uniqueness_height/2 ;
			ctx_Line(ctx, sx, col_improve_y, ex, col_improve_y, 'black', 1);
			ctx_Line(ctx, sx, col_uniqueness_y, ex, col_uniqueness_y, 'black', 1);
			ctx_wrapText(ctx, col_etc_x_center, col_incong_y_center, this.col_etc[0],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[0], DataGrid1_RowHeightEtc);
			ctx_wrapText(ctx, col_etc_x_center, col_improve_y_center, this.col_etc[1],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[0], DataGrid1_RowHeightEtc);
			ctx_wrapText(ctx, col_etc_x_center, col_uniqueness_y_center, this.col_etc[2],
					'black', vTextStyleBold, 'center','middle', this.col_head_width[0], DataGrid1_RowHeightEtc);
			for(i=0; i<this.col_incong_note.length; i++) { // 부적합/이탈사항 데이터 쓰기
				if(this.col_incong_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var incong_note = this.col_check_date[i] + " - " + this.col_incong_note[i];
					var lineNum = ctx_wrapText(ctx, col_etc_x+10, col_incong_y + 5, incong_note,
						'black', vTextStyleBold, 'left','top', col_etc_x_width-10, DataGrid1_RowHeightEtc);
					col_incong_y += (lineNum) * DataGrid1_RowHeightEtc;
				}
			}
			for(i=0; i<this.col_improve_note.length; i++) { // 개선조치사항 데이터 쓰기
				if(this.col_improve_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var improve_note = this.col_check_date[i] + " - " + this.col_improve_note[i];
					var lineNum = ctx_wrapText(ctx, col_etc_x+10, col_improve_y + 5, improve_note,
						'black', vTextStyleBold, 'left','top', col_etc_x_width-10, DataGrid1_RowHeightEtc);
					col_improve_y += (lineNum) * DataGrid1_RowHeightEtc;
				}
			}
			for(i=0; i<this.col_uniqueness.length; i++) { // 개선조치사항 데이터 쓰기
				if(this.col_improve_note[i].length > 0) { // 부적합이탈사항이 있을때만
					var uniqueness = this.col_check_date[i] + " - " + this.col_uniqueness[i];
					var lineNum = ctx_wrapText(ctx, col_etc_x+10, col_uniqueness_y + 5, uniqueness,
						'black', vTextStyleBold, 'left','top', col_etc_x_width-10, DataGrid1_RowHeightEtc);
					col_uniqueness_y += (lineNum) * DataGrid1_RowHeightEtc;
				}
			}
			
		}, // drawGrid function end
		
		getIncongLineCount: function(ctx) { // 표1의 하단부분 줄수(이탈사항)
			ctx.font = vTextStyleBold;
			var col_incong_width = this.col_head_width[1] + DataGrid1_ColWidth * DataGrid1_DataCount ;
			var col_incong_lineCount = 0;
			for(i=0; i<this.col_incong_note.length; i++) {
				if(this.col_incong_note[i].length > 0) { // 이탈사항 있을때만
					var incong_note = this.col_check_date[i] + " - " + this.col_incong_note[i];
					col_incong_lineCount += ctx_wrapText_lineCount(ctx, incong_note, col_incong_width-10);
				}
			}
			if(col_incong_lineCount < 4) col_incong_lineCount = 4; // 이탈사항 최소 4줄
			return col_incong_lineCount ;
		},
		getImproveLineCount: function(ctx) { // 표1의 하단부분 줄수(개선조치)
			ctx.font = vTextStyleBold;
			var col_improve_width = this.col_head_width[1] + DataGrid1_ColWidth * DataGrid1_DataCount ;
			var col_improve_lineCount = 0;
			for(i=0; i<this.col_improve_note.length; i++) {
				if(this.col_improve_note[i].length > 0) { // 개선조치 있을때만
					var improve_note = this.col_check_date[i] + " - " + this.col_improve_note[i];
					col_improve_lineCount += ctx_wrapText_lineCount(ctx, improve_note, col_improve_width-10);
				}
			}
			if(col_improve_lineCount < 4) col_improve_lineCount = 4; // 개선조치 최소 4줄
			return col_improve_lineCount ;
		},
		getUniquenessLineCount: function(ctx) { // 표1의 하단부분 줄수(특이사항)
			ctx.font = vTextStyleBold;
			var col_uniqueness_width = this.col_head_width[1] + DataGrid1_ColWidth * DataGrid1_DataCount ;
			var col_uniqueness_lineCount = 0;
			for(i=0; i<this.col_uniqueness.length; i++) {
				if(this.col_uniqueness[i].length > 0) { // 특이사항 있을때만
					var uniqueness = this.col_check_date[i] + " - " + this.col_uniqueness[i];
					col_uniqueness_lineCount += ctx_wrapText_lineCount(ctx, uniqueness, col_uniqueness_width-10);
				}
			}
			if(col_uniqueness_lineCount < 4) col_uniqueness_lineCount = 4; // 특이사항 최소 4줄
			return col_uniqueness_lineCount ;
		}
		
	} ; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020400_canvas.jsp"
							 + "?check_duration=" + "<%=GV_CHECK_DURATION%>"
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%>; // 이전페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020400_canvas.jsp"
							 + "?check_duration=" + "<%=GV_CHECK_DURATION%>"
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%>; // 다음페이지	
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
    