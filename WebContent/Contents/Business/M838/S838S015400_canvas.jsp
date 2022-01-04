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
조도 점검표 canvas (M838S015400_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	DoyosaeTableModel CountTableModel;

	String GV_WRITE_DATE = "", GV_WRITER = "", GV_APPROVAL = "", GV_CHECK_GUBUN="";
	
	if(request.getParameter("WriteDate")== null)
		GV_WRITE_DATE ="";
	else
		GV_WRITE_DATE = request.getParameter("WriteDate");
	
	if(request.getParameter("Writer")== null)
		GV_WRITER ="";
	else
		GV_WRITER = request.getParameter("Writer");
	
	if(request.getParameter("Approval")== null)
		GV_APPROVAL ="";
	else
		GV_APPROVAL = request.getParameter("Approval");
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN ="";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "write_date", GV_WRITE_DATE);
	jArray.put( "writer", GV_WRITER);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M838S015400E144", jArray);
    jArray.put( "check_gubun", GV_CHECK_GUBUN);
    jArray.put( "check_gubun_mid", "");
    CountTableModel = new DoyosaeTableModel("M838S015400E134", jArray);
    
 	int RowCount =TableModel.getRowCount();
	int CheckCount = CountTableModel.getRowCount();
	int GroupCount = RowCount/CheckCount;
	
	String WriteDate="", Writer="" ;
	if(RowCount>0) {
		WriteDate = TableModel.getValueAt(0, 6).toString().trim();
		Writer = TableModel.getValueAt(0, 7).toString().trim();
	}
	
	StringBuffer DataArray = new StringBuffer();
	StringBuffer CheckGubunMid = new StringBuffer();
	StringBuffer CheckGubunSm = new StringBuffer();
	DataArray.append("[");
	CheckGubunMid.append("[");
	CheckGubunSm.append("[");
	for(int i = 0; i < GroupCount; i++){
		DataArray.append("[");
		for(int j = 0; j < CheckCount; j++){
			int checkIndex = i*CheckCount + j;
			DataArray.append("'"+ TableModel.getValueAt(checkIndex, 5).toString().trim()  + "'"); // check_value
			if(i==0) {
				CheckGubunMid.append("'"+ TableModel.getValueAt(checkIndex, 2).toString().trim()  + "'");
				CheckGubunSm.append("'"+ TableModel.getValueAt(checkIndex, 3).toString().trim()  + "'");
			}
			if(j<CheckCount-1) {
				DataArray.append( ",");
				if(i==0) {
					CheckGubunMid.append( ",");
					CheckGubunSm.append( ",");
				}
			}
		}
		if(i==GroupCount-1) DataArray.append( "]");
		else DataArray.append( "],");
	}
	DataArray.append( "]");
	CheckGubunMid.append("]");
	CheckGubunSm.append("]");
			
%>

<script type="text/javascript">	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 100; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowCount = 18 ; // 표1의 행 개수(체크리스트행 개수)
	var DataGrid1_HeightStart = HaedText_HeightEnd ; // 표1 시작위치 , 전체 보고서의 높이 위치를 조정된다
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 끝나는 위치
	// 표2 영역
	var DataGrid2_RowHeight = 25; // 표2의 행 높이
	var DataGrid2_RowCount = (12+1)*2 ; // 표2의 행 개수(체크리스트행 개수)
	var DataGrid2_Width = 0 ; // doc.ready에서 표2의 각 열너비를 더해서 계산
	var DataGrid2_HeightStart = DataGrid1_HeightEnd ; // 표2 시작위치(표1 끝나는 위치 + 25)
	var DataGrid2_HeightEnd = DataGrid2_HeightStart + (DataGrid2_RowCount * DataGrid2_RowHeight); // 표2 끝나는 위치
	
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid2.col_head_width.length; i++)
    		DataGrid2_Width += DataGrid2.col_head_width[i];
    	
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid2_Width + CanvasPadding*2; // 캔버스영역 너비
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
 	    HeadText.drawText(ctx, pointSX,  pointSY + HeadText_HeightStart,  pointEX, pointSY + HaedText_HeightEnd);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart, pointEX, pointSY + DataGrid2_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
   		drawText(ctx, sx, sy, ex, ey) {
   			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
   			var blank_tab = '    '; // 4칸 공백
   			var middle_info1 = '중요관리점(CCP-3P) 점검표-1' ;
   			var middle_info2 = '[금속검출공정]' ;
   			var approval_box_width = 200; //결재박스 너비(30 + 80 + 80)
   			// 헤드텍스트
   			ctx_fillText(ctx, sx+(ex-sx-approval_box_width)/2, sy+(ey-sy)/4,
   					middle_info1, 'black', 'bold 30px 맑은고딕', 'center','middle');
   			ctx_fillText(ctx, sx+(ex-sx-approval_box_width)/2, ey-(ey-sy)/4,
   					middle_info2, 'black', 'bold 30px 맑은고딕', 'center','middle');
   			// 결재 박스
   			ctx_Line(ctx, ex-approval_box_width-30, sy, ex-approval_box_width-30, ey, 'black', 1); // 세로선
   			ctx_fillText(ctx, ex-approval_box_width-15, sy+(ey-sy)/3, '결', 'black', vTextStyle, 'center','middle');
   			ctx_fillText(ctx, ex-approval_box_width-15, ey-(ey-sy)/3, '재', 'black', vTextStyle, 'center','middle');
   			
   			ctx_Line(ctx, ex-approval_box_width, sy, ex-approval_box_width, ey, 'black', 1); // 세로선
   			ctx_Line(ctx, ex-approval_box_width/2, sy, ex-approval_box_width/2, ey, 'black', 1); // 세로선
   			ctx_Line(ctx, ex-approval_box_width, sy+30, ex, sy+30, 'black', 1); // 가로선
   			ctx_fillText(ctx, ex-approval_box_width*3/4, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
   			ctx_fillText(ctx, ex-approval_box_width*1/4, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
   		} // HeadText.drawText function end
    };
 	
	// 표1 정의
	var DataGrid1 = {
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var col_head_width = DataGrid2_Width/2;
			var col_head_width1 = 150;
			var col_head_width2 = DataGrid2_Width - 150;
			var col_x_1st = sx + col_head_width1;
			var col_x_2nd = sx + col_head_width;
			var col_y = sy;
			// 1번째줄 작성일자,점검자
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_Line(ctx, col_x_1st, sy, col_x_1st, ey, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_1st-col_head_width1/2, col_y-DataGrid1_RowHeight/2, "작성일자", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, "<%=WriteDate%>", 'black', vTextStyle, 'left','middle');
			ctx_Line(ctx, col_x_2nd, sy, col_x_2nd, sy+DataGrid1_RowHeight, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_2nd+80, sy, col_x_2nd+80, sy+DataGrid1_RowHeight, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_2nd+40, col_y-DataGrid1_RowHeight/2, "점검자", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd+85, col_y-DataGrid1_RowHeight/2, "<%=Writer%>", 'black', vTextStyle, 'left','middle');
			// 2번째줄 한계기준
			col_y += DataGrid1_RowHeight*2 ;
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_1st-col_head_width1/2, col_y-DataGrid1_RowHeight, "한계기준", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight*3/2, 
					"○ 금속검출기AC - 과자(PP),빵,떡(PET+종이) : 금속이물(Fe 1.5mm, SUS 2.0mm 이상)불검출", 
					'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight*1/2, 
					"○ 금속검출기B - 과자(PET) : 금속이물(Fe 2.0mm, SUS 3.0mm 이상)불검출", 
					'black', vTextStyle, 'left','middle');
			// 3번째줄 주기
			col_y += DataGrid1_RowHeight*3 ;
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_Line(ctx, col_x_1st, col_y-DataGrid1_RowHeight, ex, col_y-DataGrid1_RowHeight, 'black', 1); // 가로선
			ctx_Line(ctx, col_x_2nd, col_y-DataGrid1_RowHeight*3, col_x_2nd, col_y, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_1st-col_head_width1/2, col_y-DataGrid1_RowHeight*3/2, "주기", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd-(col_x_2nd-col_x_1st)/2, col_y-DataGrid1_RowHeight*2, 
					"금속검출기 정상작동 여부 확인", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd-(col_x_2nd-col_x_1st)/2, col_y-DataGrid1_RowHeight/2, 
					"금속검출기에 의한 공정품 확인", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd+(ex-col_x_2nd)/2, col_y-DataGrid1_RowHeight*2, 
					"금속검출기 정상작동 여부 확인", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd+(ex-col_x_2nd)/2, col_y-DataGrid1_RowHeight/2, 
					"작업 중 상시", 'black', vTextStyleBold, 'center','middle');
			// 4번째줄 방법
			ctx_fillText(ctx, col_x_1st-col_head_width1/2, col_y+DataGrid1_RowHeight*6, "방법", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"■ 모니터링 장소 : 내포장실 내, 금속검출기 앞", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"■ 금속검출기 감도, 특성의", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight*5 ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"  ① 표준시편만 각각 ~~의 좌,중,우 위치에 통과", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"  ② 금속이물이 없는 것으로 확인된 공정품 통과", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"  ③ 표준시편의 공정품은 ㅇㅇ 통과", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"   - 공정품의 위 좌,중,우 외격 및 공정품 아래 좌,중,우 외격에 각각 시편을 놓고 통과", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"■ 모니터링 완료 후, 사용한 금속시편들의 ~~ 확보", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st+5, col_y-DataGrid1_RowHeight/2, 
					"   - 시편의 표면을 ~~ 시편 보관함에 넣는다.", 'black', vTextStyle, 'left','middle');
			// 4번째줄 안에 표
			col_y -= DataGrid1_RowHeight*10 ;
			ctx_Box(ctx, col_x_1st+10, col_y, ex-10, col_y+DataGrid1_RowHeight*4, 'black', 1); // 표 전체 틀(사각형)
			ctx_Line(ctx, col_x_1st+10+140, col_y, col_x_1st+10+140, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_1st+10+200, col_y, col_x_1st+10+200, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_1st+10+260, col_y, col_x_1st+10+260, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_1st+10+420, col_y, col_x_1st+10+420, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, ex-10-240, col_y, ex-10-240, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, ex-10-100, col_y, ex-10-100, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			ctx_Line(ctx, ex-10-50, col_y, ex-10-50, col_y+DataGrid1_RowHeight*4, 'black', 1); // 세로선
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_1st+10, col_y, ex-10, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_1st+10+70, col_y-DataGrid1_RowHeight/2, "", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, col_x_1st+10+170, col_y-DataGrid1_RowHeight/2, "감도", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, col_x_1st+10+230, col_y-DataGrid1_RowHeight/2, "득성치", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, col_x_1st+10+340, col_y-DataGrid1_RowHeight/2, "품목", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, (ex+col_x_1st)/2+90, col_y-DataGrid1_RowHeight/2, "재질", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-10-170, col_y-DataGrid1_RowHeight/2, "중량", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-10-75, col_y-DataGrid1_RowHeight/2, "Fe", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-10-25, col_y-DataGrid1_RowHeight/2, "SUS", 'black', vTextStyle, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_1st+10+140, col_y, ex-10-240, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_1st+10+5, col_y-DataGrid1_RowHeight/2, "금속검출기 A,C", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+145, col_y-DataGrid1_RowHeight/2, "75", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+205, col_y-DataGrid1_RowHeight/2, "D", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+265, col_y-DataGrid1_RowHeight/2, "", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+425, col_y-DataGrid1_RowHeight/2, "PP", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-235, col_y-DataGrid1_RowHeight/2, "50g~1500g", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-95, col_y-DataGrid1_RowHeight/2, "1.5", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-45, col_y-DataGrid1_RowHeight/2, "2.0", 'black', vTextStyle, 'left','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_1st+10, col_y, ex-10, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_1st+10+145, col_y-DataGrid1_RowHeight/2, "54", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+205, col_y-DataGrid1_RowHeight/2, "D", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+265, col_y-DataGrid1_RowHeight/2, "", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+425, col_y-DataGrid1_RowHeight/2, "PEF", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+5, col_y+DataGrid1_RowHeight/2, "금속검출기 B", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+145, col_y+DataGrid1_RowHeight/2, "5", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+205, col_y+DataGrid1_RowHeight/2, "D", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+265, col_y+DataGrid1_RowHeight/2, "", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, col_x_1st+10+425, col_y+DataGrid1_RowHeight/2, "PEF", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-235, col_y+DataGrid1_RowHeight/2, "250g~1500g", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-95, col_y+DataGrid1_RowHeight/2, "2.0", 'black', vTextStyle, 'left','middle');
			ctx_fillText(ctx, ex-10-45, col_y+DataGrid1_RowHeight/2, "3.0", 'black', vTextStyle, 'left','middle');
			
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
 	
	// 표2 정의
	var DataGrid2 = {
		col_head_1st:<%=CheckGubunMid%>,
		col_head_2nd:<%=CheckGubunSm%>,
		col_head_width:[200,100,35,35,35,35,35,35,60,60,35,35,35,35,35,35,80,100],
		col_data:<%=DataArray%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			// 헤드
			var col_head_y_center = sy + (DataGrid2_RowHeight + DataGrid2_RowHeight)/2 ;
			var col_head_y_1st = sy + DataGrid2_RowHeight ;
			var col_head_y_1st_center = col_head_y_1st - DataGrid2_RowHeight/2 ;
			var col_head_y_2nd = col_head_y_1st + DataGrid2_RowHeight ;
			var col_head_y_2nd_center = col_head_y_2nd - DataGrid2_RowHeight/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y_2nd, ex, col_head_y_2nd, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i==0||i==1||i==8) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, this.col_head_1st[i], 
							'black', vTextStyleBold, 'center','middle', this.col_head_width[i], DataGrid2_RowHeight);
					col_head_x_start = col_head_x;
				} else if(i==4||i==7) {
					ctx_Line(ctx, col_head_x-this.col_head_width[i], col_head_y_1st,
							col_head_x, col_head_y_1st, 'black', 1); // 가로선
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					var col_head_x_total_center = col_head_x_start + (col_head_x - col_head_x_start)/2 ;
					ctx_fillText(ctx, col_head_x_total_center, col_head_y_1st_center, this.col_head_1st[i], 'black', vTextStyleBold, 'center','middle');
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i], 'black', vTextStyleBold, 'center','middle');
					col_head_x_start = col_head_x;
				} else if(i==9) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, '시편 위치', 
							'black', vTextStyleBold, 'center','middle', this.col_head_width[i], DataGrid2_RowHeight);
					col_head_x_start = col_head_x;
				} else if(i==10||i==11||i==13||i==14) {
					ctx_Line(ctx, col_head_x-this.col_head_width[i], col_head_y_1st,
							col_head_x, col_head_y_1st, 'black', 1); // 가로선
					ctx_Line(ctx, col_head_x, col_head_y_1st, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i+(i-10)], 'black', vTextStyleBold, 'center','middle');
				} else if(i==12||i==15) {
					ctx_Line(ctx, col_head_x-this.col_head_width[i], col_head_y_1st,
							col_head_x, col_head_y_1st, 'black', 1); // 가로선
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					var col_head_x_total_center = col_head_x_start + (col_head_x - col_head_x_start)/2 ;
					ctx_fillText(ctx, col_head_x_total_center, col_head_y_1st_center, this.col_head_1st[i+(i-10)], 'black', vTextStyleBold, 'center','middle');
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i+(i-10)], 'black', vTextStyleBold, 'center','middle');
					col_head_x_start = col_head_x;
				} else if(i==16) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_wrapText(ctx, col_head_x_center, col_head_y_center, this.col_head_1st[21], 
							'black', vTextStyleBold, 'center','middle', this.col_head_width[i], DataGrid2_RowHeight);
					col_head_x_start = col_head_x;
				} else if(i==17) {
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, '서명', 'black', vTextStyleBold, 'center','middle');
				} else {
					ctx_Line(ctx, col_head_x-this.col_head_width[i], col_head_y_1st,
							col_head_x, col_head_y_1st, 'black', 1); // 가로선
					ctx_Line(ctx, col_head_x, col_head_y_1st, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i], 'black', vTextStyleBold, 'center','middle');
				}
			}
			
			
			// 데이터
			var col_data_y = sy + DataGrid2_RowHeight*2  ;
			for(i=0; i<DataGrid2_RowCount-1; i++){
// 			for(i=0; i<this.col_data.length; i++){
				if(i<this.col_data.length) {
					var col_data_y_center = col_data_y + DataGrid2_RowHeight ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
						if(j<9) {
							if(this.col_data[i][j]=='Y') var result_data = 'O';
							else if(this.col_data[i][j]=='N') var result_data = 'X';
							else var result_data = this.col_data[i][j];
							ctx_wrapText(ctx, col_data_x_center, col_data_y_center, result_data,
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-10, DataGrid2_RowHeight);
						} else if(j==9)  {
							ctx_fillText(ctx, col_data_x_center, col_data_y_center-DataGrid2_RowHeight/2, '상', 'black', vTextStyle, 'center','middle');
							ctx_fillText(ctx, col_data_x_center, col_data_y_center+DataGrid2_RowHeight/2, '하', 'black', vTextStyle, 'center','middle');
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y+DataGrid2_RowHeight, 
									col_data_x, col_data_y+DataGrid2_RowHeight, 'black', 1); // 가로선
						} else if(j>9 && j<16) {
							if(this.col_data[i][j+j-11]=='Y') var result_data1 = 'O';
							else if(this.col_data[i][j+j-11]=='N') var result_data1 = 'X';
							else var result_data1 = this.col_data[i][j+j-11];
							if(this.col_data[i][j+j-10]=='Y') var result_data2 = 'O';
							else if(this.col_data[i][j+j-10]=='N') var result_data2 = 'X';
							else var result_dataw = this.col_data[i][j+j-10];
							ctx_fillText(ctx, col_data_x_center, col_data_y_center-DataGrid2_RowHeight/2,
									result_data1, 'black', vTextStyle, 'center','middle');
							ctx_fillText(ctx, col_data_x_center, col_data_y_center+DataGrid2_RowHeight/2,
									result_data2, 'black', vTextStyle, 'center','middle');
							ctx_Line(ctx, col_data_x-this.col_head_width[j], col_data_y+DataGrid2_RowHeight, 
									col_data_x, col_data_y+DataGrid2_RowHeight, 'black', 1); // 가로선
						} else if(j==16) {
							if(this.col_data[i][21]=='Y') var result_data = '적합';
							else if(this.col_data[i][21]=='N') var result_data = '부적합';
							else var result_data = this.col_data[i][21];
							ctx_fillText(ctx, col_data_x_center, col_data_y_center,
									result_data, 'black', vTextStyle, 'center','middle');
						}
					} // j for end
				}
				col_data_y += DataGrid2_RowHeight*2 ;
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			} // i for end
		} // drawGrid function end
	} ; // DataGrid2(표2) 정의  end

</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>