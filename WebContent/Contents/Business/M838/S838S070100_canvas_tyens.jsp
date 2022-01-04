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
회수관리대장 canvas (S838S090100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	
	String GV_CHECK_DATE_START="",GV_CHECK_DATE_END="",GV_CHECK_GUBUN = "",
	GV_PAGE_START="", GV_IPGO_DATE="" ;
	
	if(request.getParameter("check_gubun")== null)
	GV_CHECK_GUBUN = "";
	else
	GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	if(request.getParameter("page_start")== null)
	GV_PAGE_START = "";
	else
	GV_PAGE_START = request.getParameter("page_start");
	
	if(request.getParameter("ipgo_date")== null)
	GV_IPGO_DATE = "";
	else
	GV_IPGO_DATE = request.getParameter("ipgo_date");
	
	int GV_PAGE_COUNT = 9;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	jArray.put( "ipgo_date", GV_IPGO_DATE);
	
	if (Integer.parseInt(GV_PAGE_START) == 1)
		jArray.put("page_start", Integer.parseInt(GV_PAGE_START) - 1);
	else
		jArray.put("page_start", Integer.parseInt(GV_PAGE_START));

	//구분, 점검항목
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S070100E134", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(13)

	int TOTAL_GV_PAGE_COUNT = GV_PAGE_COUNT * CheckCount; // 체크문항 개수 * 행
	jArray.put("page_end", TOTAL_GV_PAGE_COUNT);

	TableModel = new DoyosaeTableModel("M838S070100E144", jArray);
	int RowCount = TableModel.getRowCount();

	// 	상단 입고 날짜 
	String ipgo_date = GV_IPGO_DATE.replace("-", "");

	int ipgo_date_YEAR = Integer.parseInt(ipgo_date.substring(0, 4));
	int ipgo_date_MONTH = Integer.parseInt(ipgo_date.substring(4, 6));
	int ipgo_date_DAY = Integer.parseInt(ipgo_date.substring(6, 8));

	// 결과 값, 일자, 부적합, 개선조치사항
	int CheckRow = RowCount / CheckCount;
	StringBuffer DATA_LIST_1 = new StringBuffer(); // 표1에 들어갈 데이터
	DATA_LIST_1.append("[");
	if (RowCount >= CheckCount) {
		for (int i = 0; i < CheckRow; i++) {
			// 표1 데이터
			StringBuffer data_sub = new StringBuffer();
			data_sub.append("[");
			data_sub.append("'" + TableModel.getValueAt(i * CheckCount, 3).toString().trim() + "',"); // 품목명
			data_sub.append("'" + TableModel.getValueAt(i * CheckCount, 5).toString().trim() + "',"); // 수량
			for (int j = 0; j < CheckCount; j++) {
				int CheckIndex = i * CheckCount + j;
				System.out.print("CheckIndex : " + CheckIndex);
				data_sub.append("'" + TableModel.getValueAt(CheckIndex, 12).toString().trim() + "',"); // 결과값
			}
			data_sub.append("'" + TableModel.getValueAt(i * CheckCount, 16).toString().trim() + "'"); // 부적합 조치 사항
			if (i == CheckRow - 1) {
				data_sub.append("]");
			} else {
				data_sub.append("],");
			}
			DATA_LIST_1.append(data_sub);
		}
	}
	DATA_LIST_1.append("]");

	int page_start;

	if (Integer.parseInt(GV_PAGE_START) == 1)
		page_start = Integer.parseInt(GV_PAGE_START) - 1;
	else
		page_start = Integer.parseInt(GV_PAGE_START);
	
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart+120; // 헤드텍스트 영역 종료 높이
	var HeadText_MinWidth = 650;
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var vTextCheckBold = 'bold 16px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 50;
	var DataGrid1_RowCount = 9; // 표1의 행 개수(체크리스트행 개수 + 상단및하단 나머지행 개수)
	var DataGrid1_colCount = 9; // 표1의 행 개수(체크리스트행 개수 + 상단및하단 나머지행 개수)
	var DataGrid1_RowCount_Approve = 1 ; // 표1의 하단부분 줄수(결재)
	var DataGrid1_Approve_Height = 100; // 표1의 하단부분1 높이(결재)
	var DataGrid1_Uniqueness_Height = 200; // 표1의 하단부분2 높이(특이사항)
	var DataGrid1_Width = 1250;
	var DataGrid1_HeightStart = 30+HaedText_HeightEnd;
	var DataGrid1_Height = DataGrid1_HeightStart + DataGrid1_RowHeight1st
						 + (DataGrid1_RowCount * DataGrid1_RowHeight) + (DataGrid1_Uniqueness_Height); // 표1 높이( 표 시작위치 + (행개수 * 행높이) )

    $(document).ready(function () {
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2-100; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding-30; // 끝좌표y
    	    	    	    	
		// 그리기
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
 		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid1_Height-230);
		
		// 기입내용이 20개 넘어갔을경우 
		// 페이지 수
    	var pageNum = parseInt(<%=RowCount%>/8)+1; 	
		  
    });	
    
	// 글자넣기 (컨텍스트,시작좌표x&y,입력할 글자,글자색,글자체&크기,수평정렬,수직정렬)
 	// 상단 텍스트 정의
	var HeadText = {		
		drawText(ctx, sx, sy, ex, ey) {
// 			var top_info = 'HS-PP-08-A 회수관리대장';
			var middle_info = '입고검사일지' ;
			var ipgo_date = '입고날짜 : ' + parseInt(<%=ipgo_date_YEAR%>) + '년 '
							+ parseInt(<%=ipgo_date_MONTH%>) + '월 ' + parseInt(<%=ipgo_date_DAY%>) + '일';
			var headContentBox = HeadText_HeightStart;
			var vHeadTextStyleBold = 'bold 15px 맑은고딕';
			var vHeadSignData = (sx+ex)/7*5;
			var vHeadSignDivide = (ex - vHeadSignData-30)/3;
			
			ctx_fillColor(ctx, sx, sy-10, ex-headContentBox-322, ey, '#edf1ff'); // 상단 구분명 배경(회색)
			ctx_fillColor(ctx, sx, sy*4, ex-headContentBox+30, ey+50, '#e3e3e3'); // 상단 구분명 배경(회색)
			
// 			ctx_fillText(ctx, sx, sy, top_info, 'black', '18px 맑은고딕', 'start','top');
			ctx_Line(ctx, sx, headContentBox, ex, headContentBox, 'black', 1); // head 가로선
			ctx_Line(ctx, sx, headContentBox, sx, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, ex, headContentBox, ex, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData, headContentBox, (sx+ex)/7*5, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30, headContentBox, (sx+ex)/7*5+30, ey, 'black', 1); // head 세로선	
			ctx_Line(ctx, vHeadSignData+30+vHeadSignDivide, headContentBox, vHeadSignData+30+vHeadSignDivide, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30+vHeadSignDivide*2, headContentBox, vHeadSignData+30+vHeadSignDivide*2, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30, headContentBox+30, ex, headContentBox+30, 'black', 1); // head 가로선
			ctx_fillText(ctx, (sx+ex)/8*3, (ey+HeadText_HeightStart)/2.5 , middle_info, 'black', 'bold 28px 맑은고딕', 'center','top');
			ctx_fillText(ctx, (sx+ex)/45*1, (ey+HeadText_HeightStart)/1.5 , ipgo_date, 'black', 'bold 20px 맑은고딕', 'left','top');
			ctx_fillText(ctx, (sx+ex)/7*5+15, headContentBox+25, "결", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+15, headContentBox+90, "재", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+80, headContentBox+10, "담당자", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+80, headContentBox+50, "", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+10, "확인자", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+50, "", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+75, "", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+10, "책임자", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+50, "", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+75, "", 'black', vHeadTextStyleBold, 'center','top');
		} // HeadText.drawText function end
	}
	
 	// 표1 정의
	var DataGrid1 = {
		col_head:["품명","수량","성적서","유통기한","차량온도","차량상태","파렛트","외포장재","내포장재","성상","이물혼입","표시사항","적합","부적합 시 조치 내용","부적합 시 조치사항 : "],
		col_head_detail:["구비여부","항목적합"],	
		col_recall_reason_content:["O","X","-"],	
		col_data:<%=DATA_LIST_1.toString()%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_x_divide = (ex+20)/18;	// 분할선
			var col_head_result = (ex-(20+col_head_x_divide*8))/8;
			var col_head_y_end = sy+DataGrid1_RowHeight1st*(DataGrid1_RowCount+1);
			var col_head_y_loc = sy+DataGrid1_RowHeight1st/2+12;
			var info_data = '적합 : O, 부적합 : X, 해당없음 : -';
			var info_data2 = '※ 전란액 상차 전 온도확인(0~5℃) 후 상차 요청';
			var info_data3 = '※ 냉동떡 상차 전 온도확인(-18℃ 이하) 후 상차 요청';
			
			// 줄 긋기
			ctx_Line(ctx, 20+col_head_x_divide*3, sy+DataGrid1_RowHeight1st-25, 45+col_head_x_divide*4.7, sy+DataGrid1_RowHeight1st-25, 'black', 1); // 중간 가로선
			
			
			
			var col_result_divide = 10+col_head_x_divide*0.5+col_head_result;
			var xplus = 4.58;
			
			ctx_Line(ctx, col_result_divide*1.3, sy, col_result_divide*1.3, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_result_divide*1.8, sy, col_result_divide*1.8, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_head_x_divide*4.28, sy+DataGrid1_RowHeight1st-25, col_head_x_divide*4.28, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_result_divide*2.95, sy, col_result_divide*2.95, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_result_divide*4.05, sy, col_result_divide*4.05, col_head_y_end, 'black', 1); // 세로선

			// 부적합 시 조치사항 칸
			ctx_Line(ctx, col_result_divide*3.5, sy+501, col_result_divide*3.5, col_head_y_end*1.09, 'black', 1.5); // 세로선1
			ctx_Line(ctx, 1260, sy+501, 1260, col_head_y_end*1.09, 'black', 1.5); // 세로선2
			ctx_Line(ctx, 381+col_head_x_divide, sy+DataGrid1_RowHeight1st*11.2, 1190+col_head_x_divide, sy+DataGrid1_RowHeight1st*11.2, 'black', 1.5); // 중간 가로선
			
			
			for(i=0; i<DataGrid1_RowCount; i++){
				
				ctx_Line(ctx, col_result_divide*xplus, sy, col_result_divide*xplus, col_head_y_end, 'black', 1); // 세로선				
				xplus += 0.54;
			} 
			
			for(i=0; i<DataGrid1_colCount; i++){
				ctx_Line(ctx, sx, sy+DataGrid1_RowHeight1st*(i+1), ex, sy+DataGrid1_RowHeight1st*(i+1), 'black', 1); // 가로선
			} 
			
			// 헤드텍스트 입력
			ctx_fillText(ctx, 30+col_head_x_divide*2*0.15+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[0], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*1.02+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[1], 'black', vTextStyleBold, 'center','middle');
			
			ctx_fillText(ctx, 50+col_head_x_divide*2*1.55+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2-13, this.col_head[2], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 40+col_head_x_divide*2*1.35+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[0], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 15+col_head_x_divide*2*2.05+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[1], 'black', vTextStyleBold, 'center','middle');
			
			ctx_fillText(ctx, 30+col_head_x_divide*2*2.7+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[3], 'black', vTextStyleBold, 'center','middle');
			
			ctx_fillText(ctx, 20+col_head_x_divide*2*3.548+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[4], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*4.025+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[5], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*4.51+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[6], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*5.013+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[7], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*5.502+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[8], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*5.987+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[9], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*6.478+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[10], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*6.975+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[11], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*7.46+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[12], 'black', vTextStyleBold, 'center','middle');
			ctx_wrapText(ctx, 20+col_head_x_divide*2*8.09+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[13], 'black', vTextStyleBold, 'center', 'middle', 85, 17)
			ctx_fillText(ctx, 20+col_head_x_divide*2*3.35+col_head_x_divide/2, sy*4.23, this.col_head[14], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+5, ey+15, info_data, 'black', vTextStyleBold, 'start','middle');
			ctx_fillText(ctx, sx+5, ey+60, info_data2, 'red', vTextStyleBold, 'start','middle');
			ctx_fillText(ctx, sx+5, ey+80, info_data3, 'red', vTextStyleBold, 'start','middle');
			// 한줄에 지정된 글자수 넘어가면 줄바꿈(컨텍스트, 기준좌표x&y, 입력할 글자, 글자색, 글자체&크기, 수평정렬, 수직정렬, 한줄 최대 너비, 줄바꿈 높이)
			
			
			// 데이터 입력 
			
			
			for(i=0; i<this.col_data.length; i++){
				ctx_wrapText(ctx, 30+col_head_x_divide*2*0+col_head_x_divide*0.85, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][0], 'black', vTextStyle, 'center','middle', 150, 17);  // 품명
				ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*2.67, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][1], 'black', vTextStyle, 'center','middle', 100, 17); // 수량
				
				// 성적서 구비여부
				if(this.col_data[i][2] == 'Y'){
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*3.63, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[0], 'black', vTextStyle, 'center','middle', 100, 17);
				} else if (this.col_data[i][2] == 'N'){
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*3.63, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[1], 'black', vTextStyle, 'center','middle', 100, 17);
				} else {
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*3.63, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][2], 'black', vTextStyle, 'center','middle', 100, 17);
				}
				
				// 성적서 항목적합
				if(this.col_data[i][3] == 'Y'){
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*4.68, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[0], 'black', vTextStyle, 'center','middle', 100, 17);
				} else if (this.col_data[i][3] == 'N'){
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*4.68, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[1], 'black', vTextStyle, 'center','middle', 100, 17);
				} else {
					ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*4.68, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][3], 'black', vTextStyle, 'center','middle', 100, 17);
				}
				
				ctx_wrapText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*6.22, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][4], 'black', vTextStyle, 'center','middle', 100, 17); // 유통기한 
				
				var j;
				var count2 = 9;
				var count = 7.7;
				var ii = 5;
				
// 				// 차량온도 ~ 적합
				for(j=0; j<count2; j++) {
// 					alert("count : " + count + " / ii : " + ii + " / i : " + i + " / j : " + j);
					if(this.col_data[i][ii] == 'Y'){
						ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*count, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[0], 'black', vTextStyle, 'center','middle');
					} else if(this.col_data[i][ii] == 'N'){
						ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*count, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason_content[1], 'black', vTextStyle, 'center','middle');
					} else {
						ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*count, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][ii], 'black', vTextStyle, 'center','middle');
					}
					
					if(j == 2) { count += 0.9; }
					else { count += 1; } 
					ii += 1;
				}
				
				ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide*16.8, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_data[i][14], 'black', vTextStyle, 'center','middle', 100, 17); //부적합시 조치 내용
				ctx_wrapText(ctx, 20+col_head_x_divide*2*3.35+col_head_x_divide/2*3.05, sy*4.23, this.col_data[0][15], 'black', vTextStyle, 'left','middle', 100, 17); //부적합시 조치 사항
			}
		} // drawGrid function end
	}; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas_tyens.jsp"
			 				 + "?check_gubun=" + "<%=GV_CHECK_GUBUN%>"
							 + "&page_start=" + "<%=(Integer.parseInt(GV_PAGE_START)-TOTAL_GV_PAGE_COUNT)%>" // 이전페이지
							 + "&ipgo_date=" + "<%=GV_IPGO_DATE%>";
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1500px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas_tyens.jsp"
							 + "?check_gubun=" + "<%=GV_CHECK_GUBUN%>"
							 + "&page_start=" + "<%=(TOTAL_GV_PAGE_COUNT+page_start)%>" // 다음페이지	
							 + "&ipgo_date=" + "<%=GV_IPGO_DATE%>";
							 
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1500px');
	}

</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
	<p style="text-align:center;" >
		<%if( Integer.parseInt(GV_PAGE_START) > 1 ) {%>
    	<button id="btn_Pre"  class="btn btn-info" onclick="fn_Pre_Page();">이전</button>
    	<%}%>
    	<%if( RowCount == TOTAL_GV_PAGE_COUNT ) {%>
        <button id="btn_Next"  class="btn btn-info"  onclick="fn_Next_Page();">다음</button>
        <%}%>
    </p>	
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>