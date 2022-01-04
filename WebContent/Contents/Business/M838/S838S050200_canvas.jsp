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
출입검사등기록부 canvas (S838S050300_canvas.jsp)
*/	
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();
DoyosaeTableModel TableModel;

String GV_EXM_YEAR="", GV_QUAT1="", GV_QUAT2="", GV_QUAT3="", GV_QUAT4="", GV_WRITOR_NAME ;

if(request.getParameter("healthExmYear")== null)
	GV_EXM_YEAR = "";
else
	GV_EXM_YEAR = request.getParameter("healthExmYear");
if(request.getParameter("quat1")== null)
	GV_QUAT1 = "";
else
	GV_QUAT1 = request.getParameter("quat1");
if(request.getParameter("quat2")== null)
	GV_QUAT2 = "";
else
	GV_QUAT2 = request.getParameter("quat2");
if(request.getParameter("quat3")== null)
	GV_QUAT3 = "";
else
	GV_QUAT3 = request.getParameter("quat3");
if(request.getParameter("quat4")== null)
	GV_QUAT4 = "";
else
	GV_QUAT4 = request.getParameter("quat4");
if(request.getParameter("writorName")== null)
	GV_WRITOR_NAME = "";
else
	GV_WRITOR_NAME = request.getParameter("writorName");	

JSONObject jArray = new JSONObject();
jArray.put( "member_key", member_key);
jArray.put( "healthExmYear", GV_EXM_YEAR);
jArray.put( "quat1", GV_QUAT1);
jArray.put( "quat2", GV_QUAT2);
jArray.put( "quat3", GV_QUAT3);
jArray.put( "quat4", GV_QUAT4);
jArray.put( "writorName", GV_WRITOR_NAME);

TableModel = new DoyosaeTableModel("M838S050200E114", jArray);
int RowCount =TableModel.getRowCount();

// NO, 성명, 검진일, 차기검진일, 분기별 확인, 비고, 결재, 확인일, 점검, 승인, 특이사항
String ExmNo="", Quat1="", Quat2="", Quat3="", Quat4="", 
		CheckDate="", ApprovalDate="", WriteDate="", CheckName="", ApprovalName="", Uniqueness="";

if(RowCount>0) {
	ExmNo = "0";
	Quat1 = TableModel.getValueAt(0, 3).toString().trim();
	Quat2 = TableModel.getValueAt(0, 4).toString().trim();
	Quat3 = TableModel.getValueAt(0, 5).toString().trim();
	Quat4 = TableModel.getValueAt(0, 6).toString().trim();

	WriteDate = TableModel.getValueAt(0, 15).toString().trim();
	CheckDate = TableModel.getValueAt(0, 7).toString().trim();
	CheckName = TableModel.getValueAt(0, 10).toString().trim();
	ApprovalDate = TableModel.getValueAt(0, 11).toString().trim();
	ApprovalName = TableModel.getValueAt(0, 14).toString().trim();
	Uniqueness = TableModel.getValueAt(0, 19).toString().trim();
}

StringBuffer HealthExmName = new StringBuffer();
StringBuffer HealthExmDate = new StringBuffer();
StringBuffer HealthExmNextDate = new StringBuffer();
StringBuffer Bigo = new StringBuffer();
HealthExmName.append("[");
HealthExmDate.append("[");
HealthExmNextDate.append("[");
Bigo.append("[");
for(int i=0; i<RowCount; i++) {
	if(i==RowCount-1) {
		HealthExmName.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" );
		HealthExmDate.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" );
		HealthExmNextDate.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'" );
		Bigo.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" );
	} else {
		HealthExmName.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "," );
		HealthExmDate.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," );
		HealthExmNextDate.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'" + "," );
		Bigo.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" + "," );
	}
}
HealthExmName.append("]");
HealthExmDate.append("]");
HealthExmNextDate.append("]");
Bigo.append("]");
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart+80; // 헤드텍스트 영역 종료 높이
	var HeadText_MinWidth = 650;
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var vTextCheckBold = 'bold 16px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	
	var DataGrid1_RowCount = 20; // 표1의 행 개수(체크리스트행 개수 + 상단및하단 나머지행 개수)
	var DataGrid1_RowCount_Approve = 1 ; // 표1의 하단부분 줄수(결재)
	var DataGrid1_Approve_Height = 120; // 표1의 하단부분1 높이(결재)
	var DataGrid1_Uniqueness_Height = 80; // 표1의 하단부분2 높이(특이사항)
	var DataGrid1_Width = 900;
	var DataGrid1_Height = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight)+ DataGrid1_Approve_Height + DataGrid1_Uniqueness_Height; // 표1 높이( 상단텍스트 끝 위치 + (행개수 * 행높이) )
	

	
    $(document).ready(function () {
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2+30; // 캔버스영역 높이
    	
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointEY);
		
		// 기입내용이 20개 넘어갔을경우 
		// 페이지 수
    	var pageNum = parseInt(<%=RowCount%>/20)+1; 	
		  
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var top_info = 'HS-PP-04-B 건강관리대장' ;
			var middle_info = '건강진단 관리대장' ;			
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 'bold 32px 맑은고딕', 'center','top');
			ctx_textUnderline(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 30, 5); // 중간 글자에 밑줄넣기
		} // HeadText.drawText function end
	} ;
	
 	// 표1 정의
	var DataGrid1 = {
		col_head:[ "NO","성명","검진일","차기검진일","분기별 확인","1/4","2/4","3/4","4/4","비고"],
		col_head_data:["<%=Quat1%>","<%=Quat2%>","<%=Quat3%>","<%=Quat4%>"],
		col_bigo:<%=Bigo%>,
		col_exm_name:<%=HealthExmName%>,
		col_exm_date:<%=HealthExmDate%>,
		col_exm_next_date:<%=HealthExmNextDate%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_x_divide = (ex-40)/8;	// 분할선
			var col_head_x_1st = sx + 40; // head의 1번째 x좌표
			var col_head_x_2nd = col_head_x_1st + col_head_x_divide; // head의 2번째 x좌표
			var col_head_x_3rd = col_head_x_2nd + col_head_x_divide; // head의 3번째 x좌표
			var col_head_x_4th = col_head_x_3rd + col_head_x_divide; // head의 4번째 x좌표
			var col_head_x_5th = col_head_x_4th + col_head_x_divide; // head의 5번째 x좌표
			var col_head_x_6th = col_head_x_5th + col_head_x_divide; // head의 6번째 x좌표
			var col_head_x_7th = col_head_x_6th + col_head_x_divide; // head의 7번째 x좌표
			var col_head_x_8th = col_head_x_7th + col_head_x_divide; // head의 8번째 x좌표
			var col_head_x_9th = col_head_x_8th + col_head_x_divide; // head의 9번째 x좌표
			var col_head_y = sy + 50;
			var col_head_y_end = ey-(DataGrid1_Approve_Height + DataGrid1_Uniqueness_Height);
			
			// DataGrid1 선 및 헤드컬럼명 쓰기
			ctx_fillColor(ctx, col_head_x_3rd, col_head_y+(DataGrid1_RowHeight*19), col_head_x_4th, col_head_y+(DataGrid1_RowHeight*19)+120, '#cccccc'); 
			ctx_Line(ctx, col_head_x_1st, sy, col_head_x_1st, col_head_y_end, 'black', 1); // 세로선			
			ctx_Line(ctx, col_head_x_2nd, sy, col_head_x_2nd, col_head_y_end, 'black', 1); // 세로선			
			ctx_Line(ctx, col_head_x_3rd, sy, col_head_x_3rd, col_head_y_end+DataGrid1_Approve_Height+DataGrid1_Uniqueness_Height, 'black', 1); // 세로선			
			ctx_Line(ctx, col_head_x_4th, sy, col_head_x_4th, col_head_y_end+DataGrid1_Approve_Height, 'black', 1); // 세로선		
			ctx_Line(ctx, col_head_x_5th, sy+25, col_head_x_5th, col_head_y_end+DataGrid1_Approve_Height, 'black', 1); // 세로선			
			ctx_Line(ctx, col_head_x_6th, sy+25, col_head_x_6th, col_head_y_end+DataGrid1_Approve_Height, 'black', 1); // 세로선			
			ctx_Line(ctx, col_head_x_7th, sy+25, col_head_x_7th, col_head_y_end+DataGrid1_Approve_Height, 'black', 1); // 세로선
			ctx_Line(ctx, col_head_x_8th, sy, col_head_x_8th, col_head_y_end+DataGrid1_Approve_Height, 'black', 1); // 세로선
			ctx_Line(ctx, col_head_x_4th, col_head_y-25, col_head_x_8th, col_head_y-25, 'black', 1); // 세로선
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // head 가로선						
			ctx_fillText(ctx, col_head_x_1st-30, col_head_y-25, this.col_head[0], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, col_head_x_1st+col_head_x_divide/2, col_head_y-25, this.col_head[1], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_2nd+col_head_x_divide/2, col_head_y-25, this.col_head[2], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_3rd+col_head_x_divide/2, col_head_y-25, this.col_head[3], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_6th, col_head_y-35, this.col_head[4], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_4th+col_head_x_divide/2, col_head_y-10, this.col_head[5], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_5th+col_head_x_divide/2, col_head_y-10, this.col_head[6], 'black', vTextStyleBold, 'center','middle');					
			ctx_fillText(ctx, col_head_x_6th+col_head_x_divide/2, col_head_y-10, this.col_head[7], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_7th+col_head_x_divide/2, col_head_y-10, this.col_head[8], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_8th+col_head_x_divide/2-5, col_head_y-25, this.col_head[9], 'black', vTextStyleBold, 'center','middle');
			
			ctx_fillText(ctx, sx, ey+5, '- 검진일 기준 1년이내 보건증 재발급해야함', 'black', '15px 맑은고딕', 'start','top');
			for(i=1; i<20; i++){
				ctx_Line(ctx, sx, col_head_y+(DataGrid1_RowHeight*i), ex, col_head_y+(DataGrid1_RowHeight*i), 'black', 1); // 가로선
			}
			for(i=0; i<'<%=RowCount%>'; i++){
				//ctx_Line(ctx, sx, col_head_y+(DataGrid1_RowHeight*i)+25, ex, col_head_y+(DataGrid1_RowHeight*i)+25, 'black', 1); // 세로선
				ctx_fillText(ctx, sx+15, col_head_y+(DataGrid1_RowHeight*i)+25, i+1, 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, col_head_x_2nd/2+20, col_head_y+(DataGrid1_RowHeight*i)+25, this.col_exm_name[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*2, col_head_y+(DataGrid1_RowHeight*i)+25, this.col_exm_date[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*3, col_head_y+(DataGrid1_RowHeight*i)+25, this.col_exm_next_date[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*4, col_head_y+(DataGrid1_RowHeight*i)+25, '□ 확인', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*5, col_head_y+(DataGrid1_RowHeight*i)+25, '□ 확인', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*6, col_head_y+(DataGrid1_RowHeight*i)+25, '□ 확인', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_divide*7, col_head_y+(DataGrid1_RowHeight*i)+25, '□ 확인', 'black', vTextStyleBold, 'center','middle');

				if(this.col_head_data[0] == 'Y'){
					ctx_fillText(ctx, col_head_x_divide*4-17, col_head_y+(DataGrid1_RowHeight*i)+25, '✓', 'black', vTextCheckBold, 'center','middle');					
				}
				if(this.col_head_data[1] == 'Y'){
					ctx_fillText(ctx, col_head_x_divide*5-17, col_head_y+(DataGrid1_RowHeight*i)+25, '✓', 'black', vTextCheckBold, 'center','middle');					
				}
				if(this.col_head_data[2] == 'Y'){
					ctx_fillText(ctx, col_head_x_divide*6-17, col_head_y+(DataGrid1_RowHeight*i)+25, '✓', 'black', vTextCheckBold, 'center','middle');					
				}
				if(this.col_head_data[3] == 'Y'){
					ctx_fillText(ctx, col_head_x_divide*7-17, col_head_y+(DataGrid1_RowHeight*i)+25, '✓', 'black', vTextCheckBold, 'center','middle');					
				}
				ctx_fillText(ctx, col_head_x_divide*8-10, col_head_y+(DataGrid1_RowHeight*i)+25, this.col_bigo[i], 'black', vTextStyleBold, 'center','middle');
			}	
			
			// 결재, 승인부 정보
			ctx_Line(ctx, sx, col_head_y+(DataGrid1_RowHeight*19)+DataGrid1_Approve_Height, ex, col_head_y+(DataGrid1_RowHeight*19)+DataGrid1_Approve_Height, 'black', 1); // 가로선
			ctx_Line(ctx, col_head_x_3rd, col_head_y+(DataGrid1_RowHeight*19)+40, ex, col_head_y+(DataGrid1_RowHeight*19)+40, 'black', 1); // 가로선
			ctx_Line(ctx, col_head_x_3rd, col_head_y+(DataGrid1_RowHeight*19)+80, ex, col_head_y+(DataGrid1_RowHeight*19)+80, 'black', 1); // 가로선					
			ctx_fillText(ctx, col_head_x_2nd, col_head_y+(DataGrid1_RowHeight*19)+30, '결    재', 'black', vTextStyleBold, 'right','middle');
			ctx_fillText(ctx, col_head_x_1st, col_head_y+(DataGrid1_RowHeight*19)+60, '점검팀 : ', 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, col_head_x_2nd-45, col_head_y+(DataGrid1_RowHeight*19)+60, '<%=CheckName%>', 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, col_head_x_1st, col_head_y+(DataGrid1_RowHeight*19)+90, '승인자 : ', 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, col_head_x_2nd-45, col_head_y+(DataGrid1_RowHeight*19)+90, '<%=ApprovalName%>', 'black', vTextStyleBold, 'left','middle');		
			ctx_fillText(ctx, col_head_x_4th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+20, '확  인', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_4th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+60, '점  검', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_4th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+100, '승  인', 'black', vTextStyleBold, 'center','middle');
			if(this.col_head_data[0] == 'Y'){
				ctx_fillText(ctx, col_head_x_5th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+20, '<%=WriteDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_5th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+60, '<%=CheckDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_5th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+100, '<%=ApprovalDate%>', 'black', vTextStyleBold, 'center','middle');				
			}
			if(this.col_head_data[1] == 'Y'){
				ctx_fillText(ctx, col_head_x_6th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+20, '<%=WriteDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_6th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+60, '<%=CheckDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_6th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+100, '<%=ApprovalDate%>', 'black', vTextStyleBold, 'center','middle');				
			}
			if(this.col_head_data[2] == 'Y'){
				ctx_fillText(ctx, col_head_x_7th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+20, '<%=WriteDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_7th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+60, '<%=CheckDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_7th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+100, '<%=ApprovalDate%>', 'black', vTextStyleBold, 'center','middle');;					
			}
			if(this.col_head_data[3] == 'Y'){
				ctx_fillText(ctx, col_head_x_8th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+20, '<%=WriteDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_8th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+60, '<%=CheckDate%>', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_8th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+100, '<%=ApprovalDate%>', 'black', vTextStyleBold, 'center','middle');				
			}
			ctx_fillText(ctx, col_head_x_2nd, col_head_y+(DataGrid1_RowHeight*19)+40+DataGrid1_Approve_Height, '특이사항', 'black', vTextStyleBold, 'right','middle');
			ctx_fillText(ctx, col_head_x_4th-col_head_x_divide/2, col_head_y+(DataGrid1_RowHeight*19)+140, '<%=Uniqueness%>', 'black', vTextStyleBold, 'center','middle');
		} // drawGrid function end
	}; // DataGrid1(표1) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>