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
조도 점검표 canvas (S838S010300_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_HANDOVER_NAME="", GV_HANDOVER_REV="", GV_ACCEPTOR="", GV_ACCEPTOR_REV="", GV_ACCEPTOR_CAUSE="";
	String GV_PID = "M838S010300E114";
	
	if(request.getParameter("Handover_name")== null)
		GV_HANDOVER_NAME="";
	else
		GV_HANDOVER_NAME = request.getParameter("Handover_name");

	if(request.getParameter("Handover_rev")== null)
		GV_HANDOVER_REV="";
	else
		GV_HANDOVER_REV = request.getParameter("Handover_rev");
	
	if(request.getParameter("Acceptor")== null)
		GV_ACCEPTOR="";
	else
		GV_ACCEPTOR = request.getParameter("Acceptor");
	
	if(request.getParameter("Acceptor_rev")== null)
		GV_ACCEPTOR_REV="";
	else
		GV_ACCEPTOR_REV = request.getParameter("Acceptor_rev");
	
	if(request.getParameter("Accept_cause")== null)
		GV_ACCEPTOR_CAUSE="";
	else
		GV_ACCEPTOR_CAUSE = request.getParameter("Accept_cause");

	JSONObject jArray = new JSONObject();
	jArray.put( "handover_name", GV_HANDOVER_NAME);
	jArray.put( "handover_rev", GV_HANDOVER_REV);
	jArray.put( "acceptor", GV_ACCEPTOR);
	jArray.put( "acceptor_rev", GV_ACCEPTOR_REV);
	jArray.put( "accept_cause", GV_ACCEPTOR_CAUSE);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel(GV_PID, jArray);	
	int RowCount =TableModel.getRowCount();
	
	

	String handover_name       = "";
	String handover_rev        = "";
	String handover_date       = "";
	String handover_dept       = "";
	String handover_position   = ""; 
	String accept_period_start = ""; 
	String accept_period_end   = ""; 
	String accept_cause        = "";
	String accept_contents     = ""; 
	String acceptor            = "";
	String acceptor_rev        = "";
	String accept_date         = "";
	String acceptor_dept       = "";
	String acceptor_position   = ""; 
	String writor              = "";
	String writor_rev          = "";
	String write_date          = "";
	String approval            = "";
	String approval_rev        = "";
	String approve_date        = "";
	
	if(RowCount>0) {
		handover_name       = TableModel.getValueAt(0, 0).toString().trim();
		handover_rev        = TableModel.getValueAt(0, 1).toString().trim();
		handover_date       = TableModel.getValueAt(0, 2).toString().trim();
		handover_dept       = TableModel.getValueAt(0, 3).toString().trim();
		handover_position   = TableModel.getValueAt(0, 4).toString().trim();
		accept_period_start = TableModel.getValueAt(0, 5).toString().trim();
		accept_period_end   = TableModel.getValueAt(0, 6).toString().trim(); 
		accept_cause        = TableModel.getValueAt(0, 7).toString().trim();
		accept_contents     = TableModel.getValueAt(0, 8).toString().trim();; 
		acceptor            = TableModel.getValueAt(0, 9).toString().trim();;
		acceptor_rev        = TableModel.getValueAt(0, 10).toString().trim();
		accept_date         = TableModel.getValueAt(0, 11).toString().trim();
		acceptor_dept       = TableModel.getValueAt(0, 12).toString().trim();
		acceptor_position   = TableModel.getValueAt(0, 13).toString().trim(); 
		writor              = TableModel.getValueAt(0, 14).toString().trim();;
		writor_rev          = TableModel.getValueAt(0, 15).toString().trim();;
		write_date          = TableModel.getValueAt(0, 16).toString().trim();;
		approval            = TableModel.getValueAt(0, 17).toString().trim();;
		approval_rev        = TableModel.getValueAt(0, 18).toString().trim();;
		approve_date        = TableModel.getValueAt(0, 19).toString().trim();;
 
	}

%>

<script type="text/javascript">	
	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 18px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 승인자
	var CheckText_HeightStart = HaedText_HeightEnd +10 ;
	var CheckText_HeightEnd = CheckText_HeightStart + 40; // 점검관련사항 영역 종료 높이
	
	// 인계자
	var HeadoverText_HeightStart = CheckText_HeightEnd;
	var HeadoverText_HeightEnd = HeadoverText_HeightStart + 120; // 점검관련사항 영역 종료 높이
	
	// 표1 영역
	var DataGrid1_HeightStart = HeadoverText_HeightEnd +10; // 표1 시작위치(헤드텍스트영역 끝 높이)
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + 800;
	
	// 인계자
	var AcceptorText_HeightStart = DataGrid1_HeightEnd +10;
	var AcceptorText_HeightEnd = AcceptorText_HeightStart + 120; // 점검관련사항 영역 종료 높이
	
			
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1.col_head_width[0]; // 캔버스영역 너비
    	var CanvasHeight = AcceptorText_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
		
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
	    CheckText.drawText(ctx, pointSX, pointSY + CheckText_HeightStart, pointEX, pointSY + CheckText_HeightEnd);
	    HeadoverText.drawText(ctx, pointSX, pointSY + HeadoverText_HeightStart, pointEX, pointSY + HeadoverText_HeightEnd);
 		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
 		AcceptorText.drawText(ctx, pointSX, pointSY + AcceptorText_HeightStart, pointEX, pointSY + AcceptorText_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'CS-HA-F 인수인계서' ;
			var middle_info = '인수인계서' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2-80, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');

			var col_approval_x_start = 2*(ex/3)+ex/7;
			var col_approval_x_end = col_approval_x_start;
			var col_approval_y_start = sy + 15;
			var col_approval_y_end = ey;
			var col_approval_x_1st_center = col_approval_x_start + (ex - col_approval_x_start)/2;
			var col_approval_x_2nd_center = col_approval_x_1st_center;
			var col_approval_y_1st_center = sy + 15;
			var col_approval_y_2nd_center = ey;
			
			ctx_Line(ctx, col_approval_x_start, col_approval_y_start, col_approval_x_end, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_1st_center, col_approval_y_1st_center, col_approval_x_2nd_center, col_approval_y_2nd_center, 'black', 1);
			var col_approval_x_1st_upper = col_approval_x_start;
			var col_approval_x_2nd_upper = ex;
			var col_approval_y_1st_upper = ey/4+40;
			var col_approval_y_2nd_upper = col_approval_y_1st_upper;
			ctx_Line(ctx, col_approval_x_1st_upper, col_approval_y_1st_upper, col_approval_x_2nd_upper, col_approval_y_2nd_upper, 'black', 1);
			var col_approval_x_1st_down = col_approval_x_start;
			var col_approval_x_2nd_down = ex;
			var col_approval_y_1st_down = ey*0.75+15;
			var col_approval_y_2nd_down = col_approval_y_1st_down;
			ctx_Line(ctx, col_approval_x_1st_down, col_approval_y_1st_down, col_approval_x_2nd_down, col_approval_y_2nd_down, 'black', 1);
			ctx_fillText(ctx, col_approval_x_start +37, col_approval_y_start +6, "작 성", 'black', 'bold 18px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +37, col_approval_y_1st_center +6, "승 인", 'black', 'bold 18px 맑은고딕', 'center','top');

			// 작성, 승인 서명
			ctx_fillText(ctx, col_approval_x_1st_upper +37, col_approval_y_1st_upper +20, "<%=writor%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +37, col_approval_y_1st_upper +20, "<%=approval%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			
			// write_approval, haccp_approval
			var write_duration = '<%=write_date%>'.split('-');
			var write_date = write_duration[1] +"/"+ write_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_down +5, write_date, 'black', 'bold 18px 맑은고딕', 'center','top');
			var approval_duration = '<%=approve_date%>'.split('-');
			var approval_date = approval_duration[1] +"/"+ approval_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_down +5, approval_date, 'blue', 'bold 18px 맑은고딕', 'center','top');

		} // HeadText.drawText function end
	} ;

	// 점검관련사항 정의
	var CheckText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백

			var check_date = '승 인 일';
			var check_duration = '<%=approve_date%>'.split('-');			
			var check_date_note = blank_tab + check_duration[0] + '년 ' + check_duration[1] + '월 ' + check_duration[2] + '일 ';
			var approval 	= '승 인 자';
			var approval_note = '<%=approval%>';
			var cut = ex/6;
			var text_hgt = sy-(CheckText_HeightStart - CheckText_HeightEnd)/2;
			
			ctx_Line(ctx, cut, sy, cut, ey, 'black', 1);
			ctx_Line(ctx, (ex-cut)/2+cut, sy, (ex-cut)/2+cut, ey, 'black', 1);
			ctx_Line(ctx, (ex-cut)/2+2*cut, sy, (ex-cut)/2+2*cut, ey, 'black', 1);
			ctx_fillText(ctx, cut/2, text_hgt , check_date, 'black', 'bold 18px 맑은고딕', 'center','middle');			
			ctx_fillText(ctx, cut/2 + cut, text_hgt, check_date_note, 'black', '18px 맑은고딕', 'start','middle');							
			ctx_fillText(ctx, (ex-cut)/2+cut + 40, text_hgt, approval, 'black', 'bold 18px 맑은고딕', 'start','middle');	
			ctx_fillText(ctx, 2*(ex/3)+ex/7+5, text_hgt, approval_note, 'black', '18px 맑은고딕', 'start','middle');
		}		
		
	}
	
	var HeadoverText = {
			drawText(ctx, sx, sy, ex, ey) {
				ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
				var blank_tab = '    '; // 4칸 공백
				var dept = '부     서';
				var response = '직     위';				
				var check_duration = '<%=approve_date%>'.split('-');			
				var check_date_note = blank_tab + check_duration[0] + '년 ' + check_duration[1] + '월 ' + check_duration[2] + '일 ';
				var handover = '인 계 자';
				var handover_date =  '<%=handover_date%>'.split('-');		
				var handover_date_note = blank_tab + handover_date[0] + '  년   ' + handover_date[1] + '  월   ' + handover_date[2] + '  일   ';
				var cut = ex/6;
				var text_hgt = sy-(CheckText_HeightStart - CheckText_HeightEnd)/2;
/* 				
				ctx_Line(ctx, sx, sy, sx, ey, 'red', 3);
				ctx_Line(ctx, ex, sy, ex, ey, 'red', 3);
				ctx_Line(ctx, sx, sy, ex, sy, 'red', 3);
				ctx_Line(ctx, sx, ey, ex, ey, 'red', 3);
 */				
				ctx_Line(ctx, cut, sy, cut, ey, 'black', 1);
				ctx_Line(ctx, cut, sy+40, ex, sy+40, 'black', 1);
				ctx_Line(ctx, cut*2, sy, cut*2, sy+40, 'black', 1);
				ctx_Line(ctx, (ex-cut)/2+cut, sy, (ex-cut)/2+cut, sy+40, 'black', 1);
				ctx_Line(ctx, (ex-cut)/2+2*cut, sy, (ex-cut)/2+2*cut, sy+40, 'black', 1);
				ctx_fillText(ctx, cut/2, sy+60, handover, 'black', 'bold 18px 맑은고딕', 'center','middle');			
				ctx_fillText(ctx, cut+40, text_hgt, dept, 'black', 'bold 18px 맑은고딕', 'start','middle');	
				ctx_fillText(ctx, (ex-cut)/2+cut + 40, text_hgt, response, 'black', 'bold 18px 맑은고딕', 'start','middle');	
				
				ctx_fillText(ctx, cut*2.5, text_hgt+40, '본인의 업무에 대하여 아래와 같이 인계함.', 'black', 'bold 16px 맑은고딕', 'start','middle');
				ctx_fillText(ctx, cut*3+20, text_hgt+60, handover_date_note, 'black', 'bold 16px 맑은고딕', 'start','middle');
				ctx_fillText(ctx, cut*4.5, text_hgt+80, '<%=handover_name%>' + '   (서 명)', 'black', 'bold 16px 맑은고딕', 'start','middle');
			}		
			
		}
	
	// 표1 정의
	var DataGrid1 = {		
		col_head_width:[900],		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기			
			var blank_tab = '    '; // 4칸 공백
			var period = '<%=accept_period_start%>' + '  ~  ' +  '<%=accept_period_end%>';

			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)	
			ctx_Line(ctx, sx, sy+40, ex, sy+40, 'black', 1);
			ctx_fillText(ctx, ex/2, sy+20, '인'+ blank_tab + '수'+ blank_tab + '내'+ blank_tab + '용', 'black', 'bold 18px 맑은고딕', 'center','middle');
 			ctx_fillText(ctx, sx+50, sy+70, '기 간 : ', 'black', vTextStyle, 'center','middle');
 			ctx_fillText(ctx, sx+80, sy+70, period, 'black', vTextStyle, 'left','middle');
 			ctx_fillText(ctx, sx+50, sy+110, '사 유 : ', 'black', vTextStyle, 'center','middle');
 			ctx_fillText(ctx, sx+50, sy+250, '내 용 : ', 'black', vTextStyle, 'center','middle');
			
 			var cause = '<%=accept_cause%>';
			var causeArray = cause.split("<br/>");			
			for(var i = 0; i < causeArray.length; i++){
				console.log(cause.length);
				if(causeArray.length < 1){
					ctx_fillText(ctx, sx+80, sy+103+(i*30), causeArray[i], 'black', vTextStyle, 'left','top');
				} else{
					if(causeArray[i].length < 80){
						ctx_fillText(ctx, sx+80, sy+103+(i*30), causeArray[i], 'black', vTextStyle, 'left','top');
					} else {
						ctx_wrapText(ctx, sx+80, sy+103+(i*30), causeArray[i], 'black', vTextStyle, 'left','top', 750, 30);
					}
				}
				
			}
			var contents = '<%=accept_contents%>';
			var contentsArray = contents.split("<br/>");
			for(var i = 0; i < contentsArray.length; i++){
				if(contentsArray.length < 1){
					ctx_fillText(ctx, sx+80, sy+243+(i*30), contentsArray[i], 'black', vTextStyle, 'left','top');
				} else{
					if(contentsArray[i].length < 80){
						ctx_fillText(ctx, sx+80, sy+243+(i*30), contentsArray[i], 'black', vTextStyle, 'left','top');
					} else {
						ctx_wrapText(ctx, sx+80, sy+243+(i*30), contentsArray[i], 'black', vTextStyle, 'left','top', 750, 30);
					}
					
				}
			}
		}	
	} ;
 	// 하단 인수자정보 정의
	var AcceptorText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var acceptor = '인 수 자';
			var dept = '부     서';
			var position = '직     위';		
			var accept_date =  '<%=accept_date%>'.split('-');		
			var accept_date_note = blank_tab + accept_date[0] + '  년   ' + accept_date[1] + '  월   ' + accept_date[2] + '  일   ';
			var acceptor_dept =  '<%=acceptor_dept%>';
			var acceptor_position =  '<%=acceptor_position%>';
			var cut = ex/6;
			var text_hgt = sy-(AcceptorText_HeightStart - AcceptorText_HeightEnd)/2;
			
			ctx_Line(ctx, cut, sy, cut, ey, 'black', 1);
			ctx_Line(ctx, cut, sy+40, ex, sy+40, 'black', 1);
			ctx_Line(ctx, cut*2, sy, cut*2, sy+40, 'black', 1);
			ctx_Line(ctx, (ex-cut)/2+cut, sy, (ex-cut)/2+cut, sy+40, 'black', 1);
			ctx_Line(ctx, (ex-cut)/2+2*cut, sy, (ex-cut)/2+2*cut, sy+40, 'black', 1);
			
			ctx_fillText(ctx, cut/2, sy+60, acceptor, 'black', 'bold 18px 맑은고딕', 'center','middle');			
			ctx_fillText(ctx, cut+40, text_hgt-40, dept, 'black', 'bold 18px 맑은고딕', 'start','middle');
			ctx_fillText(ctx, cut*2.5, text_hgt-40, acceptor_dept, 'black', 'bold 18px 맑은고딕', 'start','middle');	
			ctx_fillText(ctx, (ex-cut)/2+cut + 40, text_hgt-40, position, 'black', 'bold 18px 맑은고딕', 'start','middle');
			ctx_fillText(ctx, (ex-cut)/2+(cut*2.5), text_hgt-40, acceptor_position, 'black', 'bold 18px 맑은고딕', 'start','middle');
			ctx_fillText(ctx, cut*2.5, text_hgt, '본인의 업무에 대하여 아래와 같이 인수함.', 'black', 'bold 16px 맑은고딕', 'start','middle');
			ctx_fillText(ctx, cut*3+20, text_hgt+20, accept_date_note, 'black', 'bold 16px 맑은고딕', 'start','middle');
			ctx_fillText(ctx, cut*4.5, text_hgt+40, '<%=acceptor%>' + '   (서 명)', 'black', 'bold 16px 맑은고딕', 'start','middle');
					
		}	
	}; // DataGrid1(표1) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>