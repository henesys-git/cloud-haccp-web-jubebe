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
CCP모니터링 canvas (S838S015200_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	
	String GV_PAGE_START="" ,FROM="",TO="";
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
		else
		GV_PAGE_START = request.getParameter("page_start");
	
	if(request.getParameter("from")== null)
		FROM = "";
		else
		FROM = request.getParameter("from");
	
	if(request.getParameter("to")== null)
		TO = "";
		else
		TO = request.getParameter("to");
	
	
	
	int GV_PAGE_COUNT = 9; // 한페이지에 보여지는 날자 개수
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "from", FROM);
	jArray.put( "to", TO);

	if (Integer.parseInt(GV_PAGE_START) == 1)
		jArray.put("page_start", Integer.parseInt(GV_PAGE_START) - 1);
	else
		jArray.put("page_start", Integer.parseInt(GV_PAGE_START));
	
	DoyosaeTableModel TableModelE144 = new DoyosaeTableModel("M838S015200E144", jArray);
	int CheckCount = TableModelE144.getRowCount(); // 총 ROW
	
	int TOTAL_GV_PAGE_COUNT = GV_PAGE_COUNT; 
	jArray.put("page_end", TOTAL_GV_PAGE_COUNT);
	

	TableModel = new DoyosaeTableModel("M838S015200E145", jArray);
	int RowCount = TableModel.getRowCount(); // 페이징 단위 ROW
	int page_start;

	if (Integer.parseInt(GV_PAGE_START) == 1)
		page_start = Integer.parseInt(GV_PAGE_START) - 1;
	else
		page_start = Integer.parseInt(GV_PAGE_START);

%>

<script type="text/javascript">	


<%-- function fn_Next_Page() {
	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas_tyens.jsp"

						 
	pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1500px');
} --%>
	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 표0 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 130; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 30; // 표1의 행 높이
	var DataGrid1_RowCount = 9; // 표1의 가로선 개수
	var DataGrid1_Width = 0 ;
	var DataGrid1_HeightEnd = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight);
	// 표2 영역
	var DataGrid2_RowHeight = 70; // 표2의 행 높이
	var DataGrid2_RowCount = 3; // 표2의 가로선 개수
	var DataGrid2_HeightEnd = DataGrid1_HeightEnd + (DataGrid2_RowCount * DataGrid2_RowHeight);
	// 표3 영역
	var DataGrid3_RowHeight = 30; // 표3의 행 높이
	var DataGrid3_RowCount = 9; // 표3의 행 개수
	var DataGrid3_HeightStart = 90;
	var DataGrid3_HeightEnd = DataGrid2_HeightEnd + DataGrid3_HeightStart 
							  + (DataGrid3_RowCount * DataGrid3_RowHeight);
	// 표4 영역
	var DataGrid4_RowHeight = 170;
	var DataGrid4_HeightEnd = DataGrid3_HeightEnd + DataGrid4_RowHeight;
	// 표5 영역
	var DataGrid5_RowHeight = 130;
	var DataGrid5_HeightEnd = DataGrid4_HeightEnd + DataGrid5_RowHeight;
	
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++) {
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	}
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid5_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
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
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightEnd, pointEX, pointSY + DataGrid2_HeightEnd);
		DataGrid3.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightEnd, pointEX, pointSY + DataGrid3_HeightEnd);
		DataGrid4.drawGrid(ctx, pointSX, pointSY + DataGrid3_HeightEnd, pointEX, pointSY + DataGrid4_HeightEnd);
		DataGrid5.drawGrid(ctx, pointSX, pointSY + DataGrid4_HeightEnd, pointEX, pointEY);
    });	
    
 	// 표0 
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var top_info1 = '중요관리점(CCP-18) 모니터링일지';
			var top_info2 = '[오븐/가열공정] (파운드류)';
			
			var col_1stX = sx+100; var col_2ndX = sx+(ex-sx)/2;
			var col_3rdX = sx+(ex-sx)/2+100; var col_4thX = ex-300;
			var col_5thX = ex-250; var col_6thX = ex-125;
			
			var col_1stY = sy+30; var col_2ndY = sy+100;
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표0 전체 틀(사각형)
																			   // 표0 왼쪽부터
			ctx_Line(ctx, col_1stX, sy+100, col_1stX, ey, 'black', 1); 	   // 1st세로선(작성일자)
			ctx_Line(ctx, col_2ndX, sy+100, col_2ndX, ey, 'black', 1); 		   // 2nd세로선
			ctx_Line(ctx, col_3rdX, sy+100, col_3rdX, ey, 'black', 1); 		   // 3rd세로선
			ctx_Line(ctx, col_4thX, sy, col_4thX, sy+100, 'black', 1); 		   // 4th세로선
			ctx_Line(ctx, col_5thX, sy, col_5thX, sy+100, 'black', 1); 		   // 5th세로선
			ctx_Line(ctx, col_6thX, sy, col_6thX, sy+100, 'black', 1); 		   // 6th세로선
			
			ctx_Line(ctx, ex-250, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_Line(ctx, sx, sy+100, ex, sy+100, 'black', 1); 	 // 가로선
			
			ctx_fillText(ctx, sx+(ex-300-sx)/2, sy+30, top_info1, 'black', 'bold 30px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+(ex-300-sx)/2, sy+70, top_info2, 'black', 'bold 30px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+col_1stX/2, ey-(ey-col_2ndY)/2, '작성일자', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, col_2ndX+(col_3rdX-col_2ndX)/2, ey-(ey-col_2ndY)/2, '점검자', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, col_5thX-(col_5thX-col_4thX)/2, sy+35, '결', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, col_5thX-(col_5thX-col_4thX)/2, sy+65, '재', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, col_6thX-(col_6thX-col_5thX)/2, sy+(col_1stY-sy)/2, '작성', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, ex-(ex-col_6thX)/2, sy+(col_1stY-sy)/2, '승인', 'black', 'bold 15px 맑은고딕', 'center','middle');
	
			ctx_fillText(ctx, col_5thX-(col_5thX-col_4thX)/2+90, sy+65, '<%=TableModel.getValueAt(0, 13)%>', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, ex-(ex-col_6thX)/2, sy+(col_1stY-sy)/2+50, '<%=TableModel.getValueAt(0, 14)%>', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+col_1stX/2+250, ey-(ey-col_2ndY)/2, '<%=TableModel.getValueAt(0, 15)%>', 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, col_2ndX+(col_3rdX-col_2ndX)/2+250, ey-(ey-col_2ndY)/2, '<%=TableModel.getValueAt(0, 16)%>', 'black', 'bold 15px 맑은고딕', 'center','middle');
			
		} // HeadText.drawText function end
	} ;
	
	// 표1 (한계기준)
	var DataGrid1 = {
		col_head_width:[100,150,425,325],
		col_head_lv1:["한계기준","적용품목","가열온도(설정값) (단위: )","가열속도(컨베이어 속도설정값)"],
		pyo1_data : [
			["오븐에 구운 파운드","185+10","180+10","186+10","180+10","182+10","190+10","23.7+1.0 RPM","17분14초90초"],
			["초코파운드","186+10","199+10","195+10","199+10","199+10","199+10","24.6+1.0 RPM","17분02초90초"],
			["플레인파운드","185+10","199+10","195+10","199+10","199+10","199+10","24.0+1.0 RPM","17분05초90초"],
			["녹차파운드","185+10","178+10","185+10","178+10","180+10","185+10","24.0+1.0 RPM","17분05초90초"],
			["홍차파운드","185+10","178+10","185+10","178+10","180+10","185+10","24.0+1.0 RPM","17분05초90초"],
			["바나나파운드","185+10","189+10","180+10","180+10","180+10","203+10","24.0+1.0 RPM","17분05초90초"]
		],
		
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			var pyo1_x1 = sx + this.col_head_width[0];
			var pyo1_x2 = pyo1_x1 + this.col_head_width[1];
			var pyo1_x3 = pyo1_x2 + 475 // this.col_head_width[2];
			var pyo1_x4 = pyo1_x3 + this.col_head_width[3];
			
			var pyo1_x1_center = pyo1_x1 - (pyo1_x1-sx)/2;
			var pyo1_x2_center = pyo1_x2 - (pyo1_x2-pyo1_x1)/2;
			var pyo1_x3_center = pyo1_x3 - (pyo1_x3-pyo1_x2)/2;
			var pyo1_x4_center = ex - (ex-pyo1_x3)/2;
			
			var pyo1_y1 = sy+30;
			var pyo1_y2 = pyo1_y1 + 30;
			var pyo1_y3 = pyo1_y2 + 30;
			
			var pyo1_y1_center = pyo1_y1 - (pyo1_y1-sy)/2;
			var pyo1_y2_center = pyo1_y2 - (pyo1_y2-sy)/2;
			var pyo1_y3_center = pyo1_y3 - (pyo1_y3-sy)/2;
			var pyo1_y4_center = ey - (ey-sy)/2;
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표1 전체 틀(사각형)
			
			ctx_Line(ctx, pyo1_x1, sy, pyo1_x1, ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_x2, sy, pyo1_x2, ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_x3, sy, pyo1_x3, ey, 'black', 1); // 세로선
			
			ctx_Line(ctx, pyo1_x2, pyo1_y1, ex, pyo1_y1, 'black', 1); // 가로선
			ctx_Line(ctx, pyo1_x2, pyo1_y2, pyo1_x3, pyo1_y2, 'black', 1); // 가로선
			ctx_Line(ctx, pyo1_x1, pyo1_y3, ex, pyo1_y3, 'black', 1); // 가로선
			
			// 표1 헤드 제목
			ctx_fillText(ctx, pyo1_x1_center, pyo1_y4_center, this.col_head_lv1[0], 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_x2_center, pyo1_y3_center, this.col_head_lv1[1], 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_x3_center, pyo1_y1_center, this.col_head_lv1[2], 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_x4_center, pyo1_y1_center, this.col_head_lv1[3], 'black', vTextStyle, 'center','middle');
			
			// 입구,중앙,출구,상단,하단 LINE
			var pyo1_width_x3 = [pyo1_x2+(pyo1_x3-pyo1_x2)/6*1, pyo1_x2+(pyo1_x3-pyo1_x2)/6*2,
								 pyo1_x2+(pyo1_x3-pyo1_x2)/6*3, pyo1_x2+(pyo1_x3-pyo1_x2)/6*4,
								 pyo1_x2+(pyo1_x3-pyo1_x2)/6*5
								]
			ctx_Line(ctx, pyo1_width_x3[0], pyo1_y2, pyo1_width_x3[0], ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_width_x3[1], pyo1_y1, pyo1_width_x3[1], ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_width_x3[2], pyo1_y2, pyo1_width_x3[2], ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_width_x3[3], pyo1_y1, pyo1_width_x3[3], ey, 'black', 1); // 세로선
			ctx_Line(ctx, pyo1_width_x3[4], pyo1_y2, pyo1_width_x3[4], ey, 'black', 1); // 세로선
			
			// 입구,중앙,출구,상단,하단 TEXT
			var pyo1_y1y2_center = pyo1_y2-(pyo1_y2-pyo1_y1)/2;
			var pyo1_y2y3_center = pyo1_y3-(pyo1_y3-pyo1_y2)/2;
			
			ctx_fillText(ctx, pyo1_width_x3[1]-(pyo1_width_x3[1]-pyo1_x2)/2,          pyo1_y1y2_center, 
						'입구', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[3]-(pyo1_width_x3[3]-pyo1_width_x3[1])/2, pyo1_y1y2_center, 
						'중앙', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[4]-(pyo1_width_x3[2]-pyo1_width_x3[2])/2, pyo1_y1y2_center, 
						'출구', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[0]-(pyo1_width_x3[0]-pyo1_x2)/2, 		  pyo1_y2y3_center, 
						'상단', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[1]-(pyo1_width_x3[1]-pyo1_width_x3[0])/2, pyo1_y2y3_center, 
						'하단', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[2]-(pyo1_width_x3[2]-pyo1_width_x3[1])/2, pyo1_y2y3_center, 
						'상단', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[3]-(pyo1_width_x3[3]-pyo1_width_x3[2])/2, pyo1_y2y3_center, 
						'하단', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_width_x3[4]-(pyo1_width_x3[4]-pyo1_width_x3[3])/2, pyo1_y2y3_center, 
						'상단', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo1_x3-(pyo1_x3-pyo1_width_x3[4])/2, 			      pyo1_y2y3_center, 
						'하단', 'black', vTextStyle, 'center','middle');
			
			// 컨베이어 속도, 실가열시간 LINE & TEXT
			var pyo1_x3x4_center = ex-(ex-pyo1_x3)/2;
			var pyo1_y1y3_center = pyo1_y3-(pyo1_y3-pyo1_y1)/2;
			ctx_Line(ctx, pyo1_x3x4_center, pyo1_y1, pyo1_x3x4_center, ey, 'black', 1); // 세로선
			ctx_fillText(ctx, pyo1_x3+(pyo1_x3x4_center-pyo1_x3)/2, pyo1_y1y3_center, 
					'컨베이어 속도', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(ex-pyo1_x3x4_center)/2, pyo1_y1y3_center, 
					'실가열시간', 'black', vTextStyle, 'center','middle');
			
			// 한계기준 내부 데이터
			var pyo1_data_x_center = [pyo1_x1+(pyo1_x2-pyo1_x1)/2, 
									  pyo1_width_x3[0]-(pyo1_width_x3[0]-pyo1_x2)/2,
									  pyo1_width_x3[1]-(pyo1_width_x3[1]-pyo1_width_x3[0])/2,
									  pyo1_width_x3[2]-(pyo1_width_x3[2]-pyo1_width_x3[1])/2,
									  pyo1_width_x3[3]-(pyo1_width_x3[3]-pyo1_width_x3[2])/2,
									  pyo1_width_x3[4]-(pyo1_width_x3[4]-pyo1_width_x3[3])/2,
									  pyo1_x3-(pyo1_x3-pyo1_width_x3[4])/2,
									  pyo1_x3x4_center-(pyo1_x3x4_center-pyo1_x3)/2,
									  ex-(ex-pyo1_x3x4_center)/2
									 ];
			
			var pyo1_data_y_center = [pyo1_y3+(ey-pyo1_y3)/6*0.5, pyo1_y3+(ey-pyo1_y3)/6*1.5,
									  pyo1_y3+(ey-pyo1_y3)/6*2.5, pyo1_y3+(ey-pyo1_y3)/6*3.5,
									  pyo1_y3+(ey-pyo1_y3)/6*4.5, pyo1_y3+(ey-pyo1_y3)/6*5.5
									 ];
			
			
			for(i = 0; i < this.pyo1_data.length; i++) {
				for(j = 0; j < this.pyo1_data[i].length; j++) {
					ctx_fillText(ctx, pyo1_data_x_center[j], pyo1_data_y_center[i], 
								 this.pyo1_data[i][j], 'black', vTextStyle, 'center','middle');
				}
				pyo1_y3 += 30;
				ctx_Line(ctx, pyo1_x1, pyo1_y3, ex, pyo1_y3, 'black', 1);
			};
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 (주기 & 방법)
	var DataGrid2 = {
		drawGrid: function(ctx, sx, sy, ex, ey) {
			
			var pyo2_x1 = sx+100;
			var pyo2_x2 = ex-(ex-sx+100)/2;
			var pyo2_y1 = sy+(ey-sy)*0.15;
			var pyo2_y2 = sy+(ey-sy)*0.4;
			
			var pyo2_x1_center = pyo2_x1 - (pyo2_x1-sx)/2;
			var pyo2_x2_center = pyo2_x2 - (pyo2_x2-pyo2_x1)/2;
			var pyo2_x3_center = ex - (ex-pyo2_x2)/2;
			
			var pyo2_y1_center = pyo2_y1 - (pyo2_y1-sy)/2;	// 가열온도, 가열시간 y축
			var pyo2_y2_center = pyo2_y2 - (pyo2_y2-sy)/2;	// 주기 y축
			var pyo2_y3_center = ey - (ey-pyo2_y2)/2;		// 방법 y축
			
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표2 전체 틀(사각형)
			
			ctx_Line(ctx, pyo2_x1, sy, pyo2_x1, ey, 'black', 1); 			// 세로선
			ctx_Line(ctx, pyo2_x2, sy, pyo2_x2, pyo2_y2, 'black', 1);  		// 세로선
			ctx_Line(ctx, pyo2_x1, pyo2_y1, ex, pyo2_y1, 'black', 1); 		// 가로선
			ctx_Line(ctx, sx, pyo2_y2, ex, pyo2_y2, 'black', 1); 			// 가로선
			
			ctx_fillText(ctx, pyo2_x2_center, pyo2_y1_center, '가열온도', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x3_center, pyo2_y1_center, '가열시간(속도)', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x1_center, pyo2_y2_center, '주 기', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x1_center, pyo2_y3_center, '방 법', 'black', vTextStyle, 'center','middle');
			
			var pyo2_text1 = '작업시작 전, 작업중 2시간 마다,';
			var pyo2_text2 = '제품교체시마다, 작업완료후';
			var pyo2_text3 = '가열(오븐) 온도 : 터널오븐기 판넬 표시온도 육안 확인';
			var pyo2_text4 = '가열(오븐) 시간 : 터널오븐기 컨베이어 속도(rpm) 육안 확인';
			var pyo2_text5 = '오븐기 온도계는 연 1회 검.교정 실시 필요';
			var pyo2_text6 = '컨베이어 속도에 따른 가열시간은 반기 1회 검증 실시 필요';
			var pyo2_text7 = '범례 - O:적합, X:부적합';
			
			ctx_fillText(ctx, pyo2_x2_center, pyo2_y1+15, pyo2_text1, 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x2_center, pyo2_y1+35, pyo2_text2, 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x3_center, pyo2_y1+15, pyo2_text1, 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, pyo2_x3_center, pyo2_y1+35, pyo2_text2, 'black', vTextStyle, 'center','middle');
			
			ctx_fillText(ctx, pyo2_x1+10, pyo2_y2+25, pyo2_text3, 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, pyo2_x1+10, pyo2_y2+45, pyo2_text4, 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, pyo2_x1+10, pyo2_y2+65, pyo2_text5, 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, pyo2_x1+10, pyo2_y2+85, pyo2_text6, 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, pyo2_x1+10, pyo2_y2+105, pyo2_text7, 'black', vTextStyle, 'left','middle');
		}
	};
	
	// 표3 온도 측정표
	var DataGrid3 = {
		col_head:["품명","측정시각","상부","하부","상부","하부","상부","하부","가열속도(시간)","판 정","서명"],
		pyo3_width_x:[50*4.5,50*2,50,50,50,50,50,50,50*3.5,50*2,50*2],	// 전체 넓이: 1000 (표2에 따라)
		col_unit:["℃","O / X"], // 표1 양식에 들어갈 단위
		<%-- col_data:<%=DataArray%>, --%>
		col_data:[""],
		drawGrid: function(ctx, sx, sy, ex, ey) { 
			var pyo3_y1 = sy + DataGrid3_HeightStart*0.5;
			var pyo3_y2 = pyo3_y1 + DataGrid3_HeightStart*0.25;
			var pyo3_y3 = pyo3_y2 + DataGrid3_HeightStart*0.25;
			
			var pyo3_x = [
				sx+50*4.5, sx+50*6.5, sx+50*7.5, sx+50*8.5, sx+50*9.5, sx+50*10.5,
				sx+50*11.5, sx+50*12.5, sx+50*16, sx+50*18, sx+50*20
			]
			
			var pyo3_x_center = [
				pyo3_x[0]-(pyo3_x[0]-sx)/2, 	   pyo3_x[1]-(pyo3_x[1]-pyo3_x[0])/2,
				pyo3_x[2]-(pyo3_x[2]-pyo3_x[1])/2, pyo3_x[3]-(pyo3_x[3]-pyo3_x[2])/2,
				pyo3_x[4]-(pyo3_x[4]-pyo3_x[3])/2, pyo3_x[5]-(pyo3_x[5]-pyo3_x[4])/2,
				pyo3_x[6]-(pyo3_x[6]-pyo3_x[5])/2, pyo3_x[7]-(pyo3_x[7]-pyo3_x[6])/2,
				pyo3_x[8]-(pyo3_x[8]-pyo3_x[7])/2, pyo3_x[9]-(pyo3_x[9]-pyo3_x[8])/2,
				pyo3_x[10]-(pyo3_x[10]-pyo3_x[9])/2
			]
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 칼럼 타이틀
			for(i = 0; i < this.col_head.length; i++) {
				if(i > 1 && i < 8) {
					ctx_fillText(ctx, pyo3_x_center[i], pyo3_y2+(pyo3_y3-pyo3_y2)/2, this.col_head[i], 
							 'black', vTextStyleBold, 'center','middle');
					
				} else if(i==8) {
					ctx_wrapText(ctx, pyo3_x_center[i]-40, pyo3_y2+(pyo3_y3-pyo3_y2)/2-30, this.col_head[i], 
							 'black', vTextStyleBold, 'center','middle',60,30);
					ctx_wrapText(ctx, pyo3_x_center[i]+50, pyo3_y2+(pyo3_y3-pyo3_y2)/2-30, '품온(℃)', 
							 'black', vTextStyleBold, 'center','middle',30,30);
					ctx_Line(ctx, pyo3_x_center[i]+20, sy, pyo3_x_center[i]+20, ey, 'black', 1);
				}
				else{
					ctx_fillText(ctx, pyo3_x_center[i], sy+(pyo3_y3-sy)/2, this.col_head[i], 
								 'black', vTextStyleBold, 'center','middle');
				}
			}
			
			// RPM & O/X 입력
			var temp_y1 = pyo3_y3;
			<%for(int i=0; i<RowCount; i++) {%>
				temp_y1 += DataGrid3_RowHeight;
				ctx_fillText(ctx, pyo3_x_center[0]-60, temp_y1-15, "<%=TableModel.getValueAt(i, 0)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[1]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 2)%>",  
					 'black', vTextStyleBold, 'left','middle'); 
				ctx_fillText(ctx, pyo3_x_center[2]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 3)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[3]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 4)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[4]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 5)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[5]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 6)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[6]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 7)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[7]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 8)%>",  
					 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[8]-50, temp_y1-15, "<%=TableModel.getValueAt(i, 9).toString().replace("Hz", "")%> HZ",  
					 'black', vTextStyleBold, 'left','middle');
				
				ctx_fillText(ctx, pyo3_x_center[8]+50, temp_y1-15, "<%=TableModel.getValueAt(i, 10)%>", 
						 'black', vTextStyleBold, 'center','middle');
				
				ctx_fillText(ctx, pyo3_x_center[9], temp_y1-15, "<%=TableModel.getValueAt(i, 11)%>", 
						 'black', vTextStyleBold, 'center','middle');
				
				ctx_fillText(ctx, pyo3_x_center[10]-20, temp_y1-15, "<%=TableModel.getValueAt(i, 12)%>", 
						 'black', vTextStyleBold, 'left','middle');
			
			
			<%}%>
/* 			for(i = 0; i < 9; i++) {
				temp_y1 += DataGrid3_RowHeight;
				// 데이터 넣기(원석)
				ctx_fillText(ctx, pyo3_x_center[0]-15, temp_y1-15, "207",  
						 'black', vTextStyleBold, 'left','middle');
						 
						 
						 
						 
				ctx_fillText(ctx, pyo3_x_center[8]+40, temp_y1-15, "RPM", 
						 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, pyo3_x_center[9], temp_y1-15, "O / X", 
						 'black', vTextStyleBold, 'center','middle');
			} */
			
			// 칼럼 타이틀 (가열온도,입구,중앙,출구)
			ctx_fillText(ctx, pyo3_x_center[5]-(pyo3_x_center[5]-pyo3_x_center[4])/2, 
						 sy+12, '가열(굽기)온도', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, pyo3_x_center[5]-(pyo3_x_center[5]-pyo3_x_center[4])/2, 
						 sy+32, '(판넬온도, 단위: ℃)', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, pyo3_x[3]-(pyo3_x[3]-pyo3_x[1])/2, pyo3_y2-(pyo3_y2-pyo3_y1)/2, '입구', 
					     'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, pyo3_x[5]-(pyo3_x[5]-pyo3_x[3])/2, pyo3_y2-(pyo3_y2-pyo3_y1)/2, '중앙', 
					     'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, pyo3_x[7]-(pyo3_x[7]-pyo3_x[5])/2, pyo3_y2-(pyo3_y2-pyo3_y1)/2, '출구', 
					     'black', vTextStyleBold, 'center','middle');
			
			// 데이터 입력 (for문에서 m의 길이, n의 길이 등 수정 필요!)
// 			var temp_y2 = pyo3_y3;
// 			for(m = 0; m < 1; m++) {
// 				for(n = 0; n < 9; n++){
// 					temp_y2 += DataGrid3_RowHeight;
// 					for(p = 0; p < this.col_data[m][n][p].length; p++) {
// 						if(p == 1) {	// 측정시간 분,초만 자르기
// 							this.col_data[m][n][p] = (this.col_data[m][n][p]).slice(11, 16);
// 						}
// 						ctx_fillText(ctx, pyo3_x_center[p], temp_y2-DataGrid3_RowHeight/2, this.col_data[m][n][p], 
// 						     	 	 'black', vTextStyleBold, 'center','middle');
// 					}
// 				}
// 			}
			
			ctx_Line(ctx, sx+50*6.5, pyo3_y1, sx+50*12.5, pyo3_y1, 'black', 1);	// 컬럼 내부 가로선
			ctx_Line(ctx, sx+50*6.5, pyo3_y2, sx+50*12.5, pyo3_y2, 'black', 1);	// 컬럼 내부 가로선
			
			for(i = 0; i < DataGrid3_RowCount; i++) {	// 데이터 가로선
				ctx_Line(ctx, sx, pyo3_y3, ex, pyo3_y3, 'black', 1);
				pyo3_y3 += DataGrid3_RowHeight;
			}
			
			for(j = 0; j < this.pyo3_width_x.length; j++) {	// 표3 전체 세로선
				sx += this.pyo3_width_x[j];
				if(j == 2 || j == 4 || j == 6) {	// 상부,하부
					ctx_Line(ctx, sx, pyo3_y2, sx, ey, 'black', 1);	
				} else if(j == 3 || j == 5) {
					ctx_Line(ctx, sx, pyo3_y1, sx, ey, 'black', 1);	
				} else {
					ctx_Line(ctx, sx, sy, sx, ey, 'black', 1);	
				}
			}
		} // drawGrid function end
	}; // DataGrid3(표3) 정의  end
	
	var DataGrid4 = {
			drawGrid: function(ctx, sx, sy, ex, ey) { 
				var pyo4_text1 = "·모니터링 담당자는 한계기준 이탈 시 즉시 공정을 중단하고 생산팀장에게 보고한다.";
				var pyo4_text2 = "·생산팀장은 아래사항에 대하여 업무지시를 하고 확인한다.";
				var pyo4_text3 = " - 가열온도 및 가열시간 미달 시 재가열을 실시하고 제품 검사 후 이상이 없을 시 다음 공정을 실시한다.";
				var pyo4_text4 = " - 기계고장 시 생산을 중단하고 수리 후 가열(오븐)공정을 계속한다.";
				var pyo4_text5 = " - 즉각적인 수리가 불가능할 경우 남은 반죽을 폐기한다.";
				var pyo4_text6 = "·공통: 개선조치 시, 문제발생 시 모니터링 담당자는 생산팀장에게 보고 후 조치하며," +
								 "개선 조치 내역을 CCP-18모니터링 ";
				var pyo4_text7 = "        일지에 기록한 후 HACCP팀장의 승인을 받는다.";
				
				ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
				
				ctx_Line(ctx, sx+100, sy, sx+100, ey, 'black', 1);	// 컬럼 내부 가로선
				ctx_fillText(ctx, sx+(sx+100-sx)/2, sy+(ey-sy)/2, '개선조치방법', 
					     'black', vTextStyleBold, 'center','middle');
				
				
				ctx_wrapText(ctx, sx+110, sy+10, pyo4_text1, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+30, pyo4_text2, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+50, pyo4_text3, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+70, pyo4_text4, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+90, pyo4_text5, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+110, pyo4_text6, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+110, sy+130, pyo4_text7, 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				
			}
	}
	
	var DataGrid5 = {
			pyo5_width_x : [1100*0.35, 1100*0.45, 1100*0.1, 1100*0.1],
			pyo5_column : ["한계기준 이탈내용","개선조치 및 결과","조 치 자","확 인"],
			
			drawGrid: function(ctx, sx, sy, ex, ey) {
				ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); 			// 표 전체 틀(사각형)
				ctx_Line(ctx, sx, sy+30, ex, sy+30, 'black', 1);	// 가로선
				
				// 세로줄
				ctx_Line(ctx, sx+350, sy, sx+350, ey, 'black', 1);
				ctx_Line(ctx, sx+800, sy, sx+800, ey, 'black', 1);
				ctx_Line(ctx, sx+910, sy, sx+910, ey, 'black', 1);
				ctx_Line(ctx, sx+1000, sy, sx+1000, ey, 'black', 1);
				
				// 컬럼명
				ctx_wrapText(ctx, sx+120, sy+10, this.pyo5_column[0], 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+510, sy+10, this.pyo5_column[1], 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+830, sy+10, this.pyo5_column[2], 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				ctx_wrapText(ctx, sx+930, sy+10, this.pyo5_column[3], 'black', vTextStyle, 'left','top', ex-sx-100, 30);
				
				ctx_fillText(ctx, sx+120, sy+50, "<%=TableModel.getValueAt(0, 17)%>", 
						 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx+510, sy+50, "<%=TableModel.getValueAt(0, 18)%>", 
						 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx+830, sy+50, "<%=TableModel.getValueAt(0, 19)%>", 
						 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx+930, sy+50, "<%=TableModel.getValueAt(0, 20)%>", 
						 'black', vTextStyleBold, 'left','middle');
			}
	}
				
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015200_canvas.jsp" 
								+ "?page_start=" + "<%=(Integer.parseInt(GV_PAGE_START)-TOTAL_GV_PAGE_COUNT)%>" // 이전페이지
								+ "&from=" +'<%=FROM%>'
								 + "&to=" +'<%=TO%>' 		
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015200_canvas.jsp" 
							 + "?page_start=" + <%=(TOTAL_GV_PAGE_COUNT+page_start)%>
							 + "&from=" +'<%=FROM%>'
							 + "&to=" +'<%=TO%>' 
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
    	<%if( RowCount == TOTAL_GV_PAGE_COUNT &&CheckCount > GV_PAGE_COUNT) {%>
        <button id="btn_Next"  class="btn btn-info"  onclick="fn_Next_Page();">다음</button>
        <%}%>
    </p>	
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="$('#modalReport').modal('hide');">닫기</button>
    </p>