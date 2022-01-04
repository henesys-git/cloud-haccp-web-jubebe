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

	String GV_CHECK_DATE="",GV_CHECK_GUBUN = "";

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
		else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);

	TableModel = new DoyosaeTableModel("M838S015250E144", jArray);
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
	
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S015250E134", jArray);
	DoyosaeTableModel TableModelE154 = new DoyosaeTableModel("M838S015250E154", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(18)
	int CheckCount2 = TableModelE154.getRowCount(); // 체크문항 개수(18)
	
	// 검증 내용 배열
	StringBuffer DataArray_check_note = new StringBuffer();
	DataArray_check_note.append("[");
	for(int i=0; i<CheckCount; i++) {
		DataArray_check_note.append("[");
		DataArray_check_note.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'"); // working_process(check_gubun_mid)
		if(i==RowCount) DataArray_check_note.append("]");
		else DataArray_check_note.append("],");
	}
	DataArray_check_note.append("]");
	
	// 날짜
	StringBuffer DataArray_date = new StringBuffer();
	DataArray_date.append("[");
	for(int i=0; i<CheckCount2; i++) {
		DataArray_date.append("[");
		DataArray_date.append( "'" + TableModelE154.getValueAt(i, 1).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
		DataArray_date.append( "'" + TableModelE154.getValueAt(i, 2).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
		DataArray_date.append( "'" + TableModelE154.getValueAt(i, 3).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
		DataArray_date.append( "'" + TableModelE154.getValueAt(i, 4).toString().trim() + "'" ); // working_process(check_gubun_mid)
		if(i==CheckCount2-1) DataArray_date.append("]");
		else DataArray_date.append("],");
	}
	DataArray_date.append("]");
	
	// 값
	StringBuffer DataArray_data = new StringBuffer();
	DataArray_data.append("[");
	for(int i=0; i<CheckCount; i++) {
		DataArray_data.append("[");
		DataArray_data.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'"); // working_process(check_gubun_mid)
		if(i==CheckCount-1) DataArray_data.append("]");
		else DataArray_data.append("],");
	}
	DataArray_data.append("]");
	
	
	// 점검일자&점검자
	StringBuffer DataArray_head_data = new StringBuffer();
	DataArray_head_data.append("[");
	DataArray_head_data.append( "'" + TableModel.getValueAt(0, 0).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
	DataArray_head_data.append( "'" + TableModel.getValueAt(0, 1).toString().trim() + "'" + "" ); // working_process(check_gubun_mid)
	DataArray_head_data.append("]");

	// 표2 데이터
	StringBuffer DataArray_DataGrid2 = new StringBuffer();
	DataArray_DataGrid2.append("[");
	DataArray_DataGrid2.append( "'" + TableModel.getValueAt(0, 10).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
	DataArray_DataGrid2.append( "'" + TableModel.getValueAt(0, 11).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
	DataArray_DataGrid2.append( "'" + TableModel.getValueAt(0, 13).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
	DataArray_DataGrid2.append( "'" + TableModel.getValueAt(0, 14).toString().trim() + "'" + "" ); // working_process(check_gubun_mid)
	DataArray_DataGrid2.append("]");

	System.out.println("DataArray_head_data : " + DataArray_head_data);	// 날짜 값
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyle2 = '16px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var vCheckTextStyle = '30px 맑은고딕';
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

    	// 표2 높이 계산(라인 수)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
//     	var DataGrid2_LineCount = DataGrid2.getLineCount(ctx_temp) ; // 표2 데이터부분 줄수배열(부적합,개선조치)
//     	DataGrid2_HeightEnd += DataGrid2_LineCount * DataGrid2_RowHeight ;
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2-150; // 캔버스영역 너비
    	var CanvasHeight = DataGrid2_HeightEnd + CanvasPadding*2+750; // 캔버스영역 높이
    	
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid1_HeightEnd+470);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart+450, pointEX, pointEY-60);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var middle_info = '중요관리점(CCP) 검증점검표' ;
			var approval_box_width = 190; //결재박스 너비(30 + 80 + 80)
			var headContentBox = HeadText_HeightStart+30;
						
			ctx_fillColor(ctx, sx, sy+20, ex-approval_box_width, sy+headContentBox+50, '#dce8f5');
			ctx_fillColor(ctx, sx, sy+headContentBox+50, ex-900, sy+headContentBox+90, '#dce8f5');
			ctx_fillColor(ctx, sx+240, sy+headContentBox+50, ex-650, sy+headContentBox+90, '#dce8f5');
			ctx_fillColor(ctx, sx+710, sy+headContentBox+50, ex-190, sy+headContentBox+90, '#dce8f5');
			// 헤드텍스트
// 			ctx_fillText(ctx, sx, sy, top_info, 'black', vTextStyle, 'start','top');
			ctx_Line(ctx, sx, headContentBox, ex, headContentBox, 'black', 2); // head 가로선
			ctx_Line(ctx, sx, headContentBox, sx, ey, 'black', 2); // head 세로선
			ctx_Line(ctx, ex, headContentBox, ex, ey, 'black', 2); 
			
			
			ctx_fillText(ctx, (sx+ex-approval_box_width)/2, sy+55, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			// 결재 박스 선
			ctx_Box(ctx, ex-approval_box_width, sy+20, ex, ey-40, 'black', 2); // 표 전체 틀(사각형)
// 			ctx_Line(ctx, ex-approval_box_width+30, sy+20, ex-approval_box_width+30, ey-40, 'black', 2); // 세로선
			ctx_Line(ctx, ex-approval_box_width/2, sy+20, ex-approval_box_width/2, ey-40, 'black', 2); // 세로선
			ctx_Line(ctx, ex-approval_box_width, sy+50, ex, sy+50, 'black', 2); // 가로선
			
			// 결제 텍스트
			ctx_fillText(ctx, ex-(approval_box_width/2)*1.52, sy+35, '작    성', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width/4, sy+35, '승    인', 'black', vTextStyleBold, 'center','middle');
			
			// 점검 주기&일자&점검자 선
			ctx_Box(ctx, sx, sy+110, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			ctx_Line(ctx, sx*13, sy+110, sx*13, ey, 'black', 2); // 세로선
			ctx_Line(ctx, sx*25, sy+110, sx*25, ey, 'black', 2); // 세로선
			ctx_Line(ctx, sx*38, sy+110, sx*38, ey, 'black', 2); // 세로선
			ctx_Line(ctx, sx*72, sy+110, sx*72, ey, 'black', 2); // 세로선
			ctx_Line(ctx, sx*84, sy+110, sx*84, ey, 'black', 2); // 세로선
			
			// 점검 주기&일자&점검자 텍스트
			ctx_fillText(ctx, sx*7, sy+130,  '점검주기', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx*31.5, sy+130, '점검일자', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx*77.8, sy+130, '점 검 자', 'black', vTextStyleBold, 'center','middle');
			
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["공정","검증 내용","기록"],
		col_head2:["예","아니오"],
		col_head3:["오븐가열 공정 CCP-1B","양갱가열 공정 CCP-2B","금속검출 공정 CCP-3P"],
		col_head_width:[120,710,340],
		check_note : <%=DataArray_check_note%>,	// 검증내용 list
		head_data : <%=DataArray_head_data%>,	// 점검 주기,일자,점검자 값
		date_data : <%=DataArray_date%>, 		// 행동 관찰, 인터뷰 날짜 값
		data_data : <%=DataArray_data%>, 		// 기록 데이터
		
<%-- 		col_data:<%=DataArray%>, --%>
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st-10, '#dce8f5'); // 상단 구분명 배경(회색)
			ctx_fillColor(ctx, sx, sy, sx+120, ey, '#dce8f5'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid1_RowHeight1st)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			
			ctx_Line(ctx, sx, col_head_y-10, ex, col_head_y-10, 'black', 2); // 가로선(이중선)
			ctx_Line(ctx, sx+830, col_head_y-45, ex, col_head_y-45, 'black', 2); // 가로선(이중선)
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				
				if(i == 0) 		{ ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 2); } // 세로선  
				if(i == 1) { ctx_Line(ctx, col_head_x, sy, col_head_x, ey/5+20, 'black', 2); 
// 							 alert("col_head_x += this.col_head_width[i] : " + (col_head_x + this.col_head_width[i]) + " / col_head_x : " + col_head_x + " / this.col_head_width[i]" + this.col_head_width[i])
							 }
				if(i == 2) { ctx_wrapText_space(ctx, col_head_x_center-75, col_head_y_center-20, this.col_head[i],
								       				'black', vTextStyleBold, 'center','middle', this.col_head_width[i]-10, DataGrid1_RowHeight1st/3); } 
				else 	  		{ ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center-5, this.col_head[i],
						     		 			    'black', vTextStyleBold, 'center','middle', this.col_head_width[i]-10, DataGrid1_RowHeight1st/3); }
			}
			
			ctx_Line(ctx, sx+925, col_head_y-45, sx+925, col_head_y+50, 'black', 2); // 기록용 예/아니요 세로선
			ctx_fillText(ctx, col_head_x_center-120, col_head_y_center+10, this.col_head2[0], 'black', vTextStyleBold, 'center','middle'); // 기록용 예
			ctx_fillText(ctx, col_head_x_center-26, col_head_y_center+10, this.col_head2[1], 'black', vTextStyleBold, 'center','middle');	   // 기록용 아니오

			ctx_fillText(ctx, sx*7+120, sy-20, '월1회', 'black', vTextStyle, 'center','middle'); 					   // 점검주기
			ctx_fillText(ctx, sx*31.5+240, sy-20, this.head_data[0], 'black', vTextStyle, 'center','middle');	   // 점검일자
			ctx_fillText(ctx, sx*77.8+160, sy-20, this.head_data[1], 'black', vTextStyle, 'center','middle');	   // 점검자
			
			
			// 데이터 그리기
			var col_data_y = col_head_y ;
			var col_data_y_1st_top = col_head_y; // 1번째 열 합치기 기준 y좌표 
			var col_data_y_2nd_top = col_head_y; // 2번째 열 합치기 기준 y좌표
			var col_data_y_3rd_top = col_head_y; // 3번째 열 합치기 기준 y좌표
			
			// 큰 1번째칸 세로줄
			ctx_Line(ctx, col_head_x-340, sy+65, col_head_x-340, sy+230, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+65, col_head_x-245, sy+230, 'black', 2);
			
			ctx_Line(ctx, col_head_x-340, sy+275, col_head_x-340, sy+330, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+275, col_head_x-245, sy+330, 'black', 2);
			
			// 큰 2번째칸 세로줄
			ctx_Line(ctx, col_head_x-340, sy+375, col_head_x-340, sy+540, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+375, col_head_x-245, sy+540, 'black', 2);
			
			ctx_Line(ctx, col_head_x-340, sy+585, col_head_x-340, sy+640, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+585, col_head_x-245, sy+640, 'black', 2);
			
			// 큰 2번째칸 세로줄
			ctx_Line(ctx, col_head_x-340, sy+685, col_head_x-340, sy+850, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+685, col_head_x-245, sy+850, 'black', 2);
			
			ctx_Line(ctx, col_head_x-340, sy+895, col_head_x-340, sy+950, 'black', 2);
			ctx_Line(ctx, col_head_x-245, sy+895, col_head_x-245, sy+950, 'black', 2);
			
			var plus = 55; 		// 가로선2 간격 
			var plus_p = 300;	// 가로선1 간격
			var count = 18;	    // 가로선2 수 
			
			// 데이터 가로선 그리기 
			for(var j=0; j<2; j++) {
				ctx_Line(ctx, sx, col_data_y+plus_p, ex, col_data_y+plus_p, 'black', 2); // 큰 가로선 (3분할)
				plus_p += 310;
			}
			
			for(i=0; i<count-6; i++){													   // 작은 가로선 (1칸당 --> 5줄)
				if(i == 2 || i == 3 || i == 6 ||i == 7 || i == 10 || i == 11) { 
					ctx_Line(ctx, sx+120, (col_data_y+plus), ex, (col_data_y+plus), 'black', 2);
					plus += 45;
				}
				if (i == 0) {
					plus = 45;
					ctx_Line(ctx, sx+120, (col_data_y+plus), ex, (col_data_y+plus), 'black', 2);
					plus += 55;
				}
				else {
					ctx_Line(ctx, sx+120, (col_data_y+plus), ex, (col_data_y+plus), 'black', 2); 
					plus += 55;
				}
			}
			
			var box_plus1 = 82;
			var box_plus2 = 102;
			var gap = 53;
			
			for(i=0; i<12; i++) {
				// 예 네모 박스
				ctx_Line(ctx, col_head_x-302, sy+box_plus1, col_head_x-302, sy+box_plus2, 'black', 2); // 세로1
				ctx_Line(ctx, col_head_x-282, sy+box_plus1, col_head_x-282, sy+box_plus2, 'black', 2); // 세로2
					
				ctx_Line(ctx, col_head_x-302, sy+box_plus1, col_head_x-282, sy+box_plus1, 'black', 2); // 가로1
				ctx_Line(ctx, col_head_x-302, sy+box_plus2, col_head_x-282, sy+box_plus2, 'black', 2); // 가로1
				
				// 아니오 네모 박스
				ctx_Line(ctx, col_head_x-207, sy+box_plus1, col_head_x-207, sy+box_plus2, 'black', 2); // 세로1
				ctx_Line(ctx, col_head_x-187, sy+box_plus1, col_head_x-187, sy+box_plus2, 'black', 2); // 세로2
				
				ctx_Line(ctx, col_head_x-207, sy+box_plus1, col_head_x-187, sy+box_plus1, 'black', 2); // 가로1
				ctx_Line(ctx, col_head_x-207, sy+box_plus2, col_head_x-187, sy+box_plus2, 'black', 2); // 가로1
				
				if(i == 2 || i == 10) { gap = 54+48; } 
				else if (i == 3 || i == 7) { gap = 54+42; }
				else if (i == 6) { gap = 54+46; }
				else { gap = 56; }
				
				box_plus1 += gap;
				box_plus2 += gap;
			}
			
			ctx_wrapText(ctx, sx+60, col_data_y+157, this.col_head3[0], 'black', vTextStyleBold, 'center', 'middle', 100, 17);
			ctx_wrapText(ctx, sx+60, col_data_y+450, this.col_head3[1], 'black', vTextStyleBold, 'center', 'middle', 100, 17);
			ctx_wrapText(ctx, sx+60, col_data_y+760, this.col_head3[2], 'black', vTextStyleBold, 'center', 'middle', 100, 17);
			
			plus = 20;
			
			// 검증 내용 list
			for(i=0; i<this.check_note.length; i++) {
				ctx_wrapText(ctx, sx+130, col_data_y+plus, this.check_note[i][0], 
						  'black', vTextStyle2, 'left', 'middle', 700, 17)
				
				if(i==0  ) { plus += 52; }
				else if(i==1 || i == 6 || i==7 || i==12 || i==13) { plus += 55; }
				else if(i==2) { plus = 177; }
				else plus += 50;
			}
			
			// 모니터링 행동 관찰, 인터뷰 데이터
			plus = 177;
			for(i=0; i <6; i++) {
				ctx_fillText(ctx, sx+380, col_data_y+plus, '월', 'black', vTextStyleBold, 'center','middle'); // 날짜
	 			ctx_fillText(ctx, sx+450, col_data_y+plus, '일', 'black', vTextStyleBold, 'center','middle'); // 날짜
	 			ctx_fillText(ctx, sx+520, col_data_y+plus, '시', 'black', vTextStyleBold, 'center','middle'); // 날짜
	 			ctx_fillText(ctx, sx+590, col_data_y+plus, '분', 'black', vTextStyleBold, 'center','middle'); // 날짜
	 			
	 			ctx_fillText(ctx, sx+350, col_data_y+plus, this.date_data[i][0], 'black', vTextStyleBold, 'center','middle'); // 날짜 값
				ctx_fillText(ctx, sx+430, col_data_y+plus, this.date_data[i][1], 'black', vTextStyleBold, 'center','middle'); // 날짜 값
				ctx_fillText(ctx, sx+500, col_data_y+plus, this.date_data[i][2], 'black', vTextStyleBold, 'center','middle'); // 날짜 값
				ctx_fillText(ctx, sx+570, col_data_y+plus, this.date_data[i][3], 'black', vTextStyleBold, 'center','middle'); // 날짜 값
			
				if(i == 1 || i == 3) { plus += 210; }
				
				else { plus += 100; }		
			}
			
			ctx_fillText(ctx, sx+280, col_data_y+177, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜
			ctx_fillText(ctx, sx+310, col_data_y+277, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜

			ctx_fillText(ctx, sx+280, col_data_y+487, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜
			ctx_fillText(ctx, sx+310, col_data_y+587, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜
			
			ctx_fillText(ctx, sx+280, col_data_y+797, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜
			ctx_fillText(ctx, sx+310, col_data_y+897, ':', 'black', vTextStyleBold, 'center','middle'); // 날짜
			
			// 체크박스 데이터 
			plus = 15;
			for(i=0; i<this.data_data.length-1; i++){
// 				alert(i + "번째 plus : " + plus);
				if(this.data_data[i] == 'Y') { ctx_fillText(ctx, sx+880, col_data_y+plus, '✓', 'black', vCheckTextStyle, 'center','middle'); } // 기록용 예 
				else { ctx_fillText(ctx, sx+975, col_data_y+plus, '✓', 'black', vCheckTextStyle, 'center','middle'); } // 기록용 아니오
				if(i==2 || i==4 || i==9 || i==11 || i==13 ) { 
						if(i==4) {plus += (45+52);} 
						else if(i==9) {plus += (45+51);}
						else if(i==11 || i==13) {plus += 56;}
						else { plus += (45+56);} 
						i += 1; 
				}
				else if(i==8 || i==15) {plus += (45+56);}
				else {plus += 56;}
			}
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 정의
	var DataGrid2 = {
		col_head:["한계기준 이탈내용","개선조치 및 결과","조치자", "확인"],
		col_head_width:[385,385,130,130], // doc.ready에서 지정
		col_data:["<%=DeviationsSubject%>","<%=Improvement%>","<%=TotalBigo%>"],
		Data_DataGrid2 :<%=DataArray_DataGrid2%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid2_RowHeight1st, '#dce8f5'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid2_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid2_RowHeight1st)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 2); // 가로선(이중선)
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				
				// 마지막엔 세로선 그릴필요X
				if(i<this.col_head_width.length-1) { ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 2); }   // 세로선
				
				if(i == 3) { ctx_fillText(ctx, col_head_x_center-5, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');}
				else { ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle'); }
			}
			
			// 데이터
			
// 			ctx_wrapText(ctx, sx+60, col_data_y+157, this.col_head3[0], 'black', vTextStyleBold, 'left', 'middle', 100, 17);
			ctx_wrapText(ctx, sx+10, sy+70, this.Data_DataGrid2[0], 'black', vTextStyle2, 'left', 'middle', 100, 17); // 날짜
			ctx_wrapText(ctx, sx+10+385, sy+70, this.Data_DataGrid2[1], 'black', vTextStyle2, 'left', 'middle', 100, 17); // 날짜
			ctx_wrapText(ctx, sx+10+385+395, sy+70, this.Data_DataGrid2[2], 'black', vTextStyle2, 'left', 'middle', 100, 17); // 날짜
			ctx_wrapText(ctx, sx+10+385+395+135, sy+70, this.Data_DataGrid2[3], 'black', vTextStyle2, 'left', 'middle', 100, 17); // 날짜
			
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