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
설비이력카드 canvas (S838S015200_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CENSOR_NO="", GV_IMPROVE_TYPE="", GV_WRITE_DATE="" ;

	if(request.getParameter("censor_no")== null)
		GV_CENSOR_NO = "";
	else
		GV_CENSOR_NO = request.getParameter("censor_no");
	
	if(request.getParameter("improve_type")== null)
		GV_IMPROVE_TYPE = "";
	else
		GV_IMPROVE_TYPE = request.getParameter("improve_type");
	
	if(request.getParameter("write_date")== null)
		GV_WRITE_DATE = "";
	else
		GV_WRITE_DATE = request.getParameter("write_date");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "censor_no", GV_CENSOR_NO);
	jArray.put( "improve_type", GV_IMPROVE_TYPE);
	jArray.put( "write_date", GV_WRITE_DATE);

	TableModel = new DoyosaeTableModel("M838S015300E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	String WriteDate="", Writor="", ImproveType="", CcpName="",
			ImproveProgram="", ImproveHaccpPlan="", ImprovePreventPlan="",
			ImproveProductHandle="", ImproveBefore="", ImproveAfter="" ;
	
	if(RowCount>0) {
		WriteDate 	= TableModel.getValueAt(0, 13).toString().trim() ;
		Writor 		= TableModel.getValueAt(0, 12).toString().trim() ;
		ImproveType = TableModel.getValueAt(0, 3).toString().trim() ;
		CcpName 	= TableModel.getValueAt(0, 1).toString().trim() ;
		ImproveProgram 		= TableModel.getValueAt(0, 4).toString().trim() ;
		ImproveHaccpPlan 	= TableModel.getValueAt(0, 5).toString().trim() ;
		ImprovePreventPlan 	= TableModel.getValueAt(0, 6).toString().trim() ;
		ImproveProductHandle= TableModel.getValueAt(0, 7).toString().trim() ;
		ImproveBefore 		= TableModel.getValueAt(0, 8).toString().trim() ;
		ImproveAfter 		= TableModel.getValueAt(0, 9).toString().trim() ;
	}
	
%>

<script type="text/javascript">	
	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 표1 영역
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowCount = 25 ; // 표1의 행 개수
	var DataGrid1_Width = 900;
	var DataGrid1_HeightEnd = 30 + (DataGrid1_RowCount * DataGrid1_RowHeight);
			
    $(document).ready(function () {
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY+20, pointEX, pointEY);
    });	
    
	// 표1
	var DataGrid1 = {
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)

			// 헤드텍스트
			var col_y = sy;
			var blank_tab = '    '; // 4칸 공백
			var col_head_height = 100;
			var approval_box_width = 300; //결재박스 너비(50 + 125*2)
			var top_info = 'HS-HA-C' ;
			var middle_info = '개선조치요구서' ;
			col_y += col_head_height;
			ctx_fillText(ctx, sx+5, sy-20, top_info, 'black', vTextStyle, 'start','top');
			ctx_fillText(ctx, sx+(ex-sx-approval_box_width)/2, col_y-col_head_height/2, 
					middle_info, 'black', 'bold 40px 맑은고딕', 'center','middle');
			// 결재 박스
			ctx_Line(ctx, ex-approval_box_width, sy, ex-approval_box_width, col_y, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width+50, sy, ex-approval_box_width+50, col_y, 'black', 1); // 세로선
			ctx_Line(ctx, ex-(approval_box_width-50)/2, sy, ex-(approval_box_width-50)/2, col_y, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width+50, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-approval_box_width+25, sy+30, '기록', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width+25, col_y-30, '확인', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-50)*3/4, sy+15, '품질관리팀장', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-50)/4, sy+15, 'HACCP팀장', 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			
			// 데이터
			var col_x_width1 = DataGrid1_Width*1/6;
			var col_x_width2 = DataGrid1_Width*2/6;
			var col_x_width3 = DataGrid1_Width*5/6;
			var col_x_1st = sx + col_x_width1;
			var col_x_2nd = col_x_1st + col_x_width2;
			var col_x_3rd = col_x_2nd + col_x_width1;
			// 1번째줄 작성일자,작성자
			col_y += DataGrid1_RowHeight ;
			ctx_fillColor(ctx, sx+1, col_y-DataGrid1_RowHeight+1, sx+col_x_width1, col_y, '#dddddd'); // 배경 회색
			ctx_fillColor(ctx, col_x_2nd+1, col_y-DataGrid1_RowHeight+1, col_x_2nd+col_x_width1, col_y, '#dddddd'); // 배경 회색
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_1st-col_x_width1/2, col_y-DataGrid1_RowHeight/2, "작성일자", 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, col_x_1st, col_y-DataGrid1_RowHeight, col_x_1st, col_y, 'black', 1); // 세로선
			var temp_date = new Date("<%=WriteDate%>");
			var v_write_date = temp_date.getFullYear() + "년 "
							 + ("0" + (temp_date.getMonth() + 1)).slice(-2) + "월 "
							 + ("0" + temp_date.getDate()).slice(-2) + "일"
			ctx_fillText(ctx, col_x_2nd-col_x_width2/2, col_y-DataGrid1_RowHeight/2, v_write_date, 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, col_x_2nd, col_y-DataGrid1_RowHeight, col_x_2nd, col_y, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_3rd-col_x_width1/2, col_y-DataGrid1_RowHeight/2, "작성자", 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, col_x_3rd, col_y-DataGrid1_RowHeight, col_x_3rd, col_y, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_3rd+col_x_width2/2, col_y-DataGrid1_RowHeight/2, "<%=Writor%>", 'black', vTextStyle, 'center','middle');
			// 2번째줄 개선조치분야
			col_y += DataGrid1_RowHeight ;
			ctx_fillColor(ctx, sx+1, col_y-DataGrid1_RowHeight+1, sx+col_x_width1, col_y, '#dddddd'); // 배경 회색
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			if("<%=ImproveType%>"=="선행요건프로그램")
				var v_improve_type = "■ 선행요건프로그램"+blank_tab+blank_tab+"□ HACCP계획";
			else if("<%=ImproveType%>"=="HACCP계획")
				var v_improve_type = "□ 선행요건프로그램"+blank_tab+blank_tab+"■ HACCP계획"; 
			ctx_fillText(ctx, col_x_1st-col_x_width1/2, col_y-DataGrid1_RowHeight/2, "개선조치 분야", 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, col_x_1st, col_y-DataGrid1_RowHeight, col_x_1st, col_y, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_1st+col_x_width3/2, col_y-DataGrid1_RowHeight/2, v_improve_type, 
					'black', 'bold 25px 맑은고딕', 'center','middle');
			// 3번째줄
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, sx+5, col_y-DataGrid1_RowHeight/2, "이탈사항 : <%=CcpName%>", 'black', vTextStyle, 'start','middle');
			// 4~7번째줄
			var col_improve_head = ["□ 선행요건프로그램","□ HACCP계획","□ 재발방지 대책 수립계획","□ 영향받은 제품의 적절한 처리"];
			var col_improve_data = ["<%=ImproveProgram%>","<%=ImproveHaccpPlan%>","<%=ImprovePreventPlan%>","<%=ImproveProductHandle%>"];
			for(i=0; i<4; i++) {
				ctx_fillText(ctx, sx+5, col_y+5, col_improve_head[i], 'black', vTextStyle, 'start','top');
				ctx_wrapText(ctx, sx+5, col_y+DataGrid1_RowHeight/2+5, col_improve_data[i], 
						'black', vTextStyle, 'start','top', DataGrid1_Width-10, DataGrid1_RowHeight/2);
				col_y += DataGrid1_RowHeight*3 ;
				ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			}
			// 마지막줄
			ctx_Line(ctx, col_x_2nd, col_y, col_x_2nd, ey, 'black', 1); // 세로선
			ctx_fillText(ctx, sx+5, col_y+5, "□ 개선 전", 'black', vTextStyle, 'start','top');
			ctx_wrapText(ctx, sx+5, col_y+DataGrid1_RowHeight/2+5, "<%=ImproveBefore%>", 
					'black', vTextStyle, 'start','top', DataGrid1_Width-10, DataGrid1_RowHeight/2);
			ctx_fillText(ctx, col_x_2nd+5, col_y+5, "□ 개선 후", 'black', vTextStyle, 'start','top');
			ctx_wrapText(ctx, col_x_2nd+5, col_y+DataGrid1_RowHeight/2+5, "<%=ImproveAfter%>", 
					'black', vTextStyle, 'start','top', DataGrid1_Width-10, DataGrid1_RowHeight/2);
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>