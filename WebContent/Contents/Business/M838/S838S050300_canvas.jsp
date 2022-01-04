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

	String GV_CHECK_DATE="", GV_CHECK_TIME="", GV_CUST_CD="", GV_CUST_CD_REV="" ;

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME = "";
	else
		GV_CHECK_TIME = request.getParameter("check_time");
	
	if(request.getParameter("cust_cd")== null)
		GV_CUST_CD = "";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("cust_cd_rev")== null)
		GV_CUST_CD_REV = "";
	else
		GV_CUST_CD_REV = request.getParameter("cust_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);
	jArray.put( "cust_cd", GV_CUST_CD);
	jArray.put( "cust_cd_rev", GV_CUST_CD_REV);

	TableModel = new DoyosaeTableModel("M838S050300E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 업소명,대표자,영업의종류,허가(신고)번호,소재지,전화번호,점검목적,점검일시,점검자소속,점검자직위,점검자성명
	String CustNm="", BossName="", Jongmok="", Bizno="", Address="", Telno="",
			CheckObject="", CheckDate="", CheckerDept="", CheckerTitle="", CheckerMain="" ;
	if(RowCount>0) {
		CustNm = TableModel.getValueAt(0, 25).toString().trim();
		BossName = TableModel.getValueAt(0, 26).toString().trim();
		Jongmok=TableModel.getValueAt(0, 27).toString().trim();
		Bizno=TableModel.getValueAt(0, 28).toString().trim();
		Address=TableModel.getValueAt(0, 29).toString().trim();
		Telno=TableModel.getValueAt(0, 30).toString().trim();
		CheckObject=TableModel.getValueAt(0, 24).toString().trim();
		CheckDate=TableModel.getValueAt(0, 0).toString().trim() 
				+ " " + TableModel.getValueAt(0, 1).toString().trim() ;
		CheckerDept=TableModel.getValueAt(0, 32).toString().trim();
		CheckerTitle=TableModel.getValueAt(0, 35).toString().trim();
		CheckerMain=TableModel.getValueAt(0, 13).toString().trim();
	}
	
	StringBuffer CheckNote = new StringBuffer();
	StringBuffer CheckValue = new StringBuffer();
	CheckNote.append("[");
	CheckValue.append("[");
	for(int i=0; i<RowCount; i++) {
		if(i==RowCount-1) {
			CheckNote.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" );
			CheckValue.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" );
		} else {
			CheckNote.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" + "," );
			CheckValue.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," );
		}
	}
	CheckNote.append("]");
	CheckValue.append("]");
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 100; // 헤드텍스트 영역 종료 높이
	var HeadText_MinWidth = 650;
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowCount = <%=RowCount%> + 9; // 표1의 행 개수(체크리스트행 개수 + 상단및하단 나머지행 개수)
	var DataGrid1_RowCount_Incong = 0 ; // 표1의 하단부분 줄수(이탈사항)
	var DataGrid1_RowCount_Improve = 0 // 표1의 하단부분 줄수(개선조치)
	var DataGrid1_RowCount_Uniqueness = 0 // 표1의 하단부분 줄수(특이사항)
	var DataGrid1_ColWidth1st = 150; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = 300; // 표1의 2번째 열 너비
	var DataGrid1_ColCheckWidth1st = 300; // 표1의 점검내용 부분 1번째 열 너비
	var DataGrid1_ColCheckWidth2nd = 600; // 표1의 점검내용 부분 2번째 열 너비
	var DataGrid1_Width = (DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd) * 2 ;
	var DataGrid1_Height = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이( 상단텍스트 끝 위치 + (행개수 * 행높이) )
			
    $(document).ready(function () {
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2; // 캔버스영역 높이
    	
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointEY);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HS-PP-04-C 출입ㆍ검사등기록부' ;
			var middle_info = '출입ㆍ검사등기록부' ;
			
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
// 			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			ctx_textUnderline(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 30, 5); // 중간 글자에 밑줄넣기
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:[ "업소명","대표자","영업의종류","허가(신고)번호","소 재 지","전화번호","점검목적","점검일시"],
		col_head_data:["<%=CustNm%>","<%=BossName%>","<%=Jongmok%>","<%=Bizno%>",
			"<%=Address%>","<%=Telno%>","<%=CheckObject%>","<%=CheckDate%>"],
		col_head_width:[ DataGrid1_ColWidth1st,DataGrid1_ColWidth2nd],
		col_check:["주요 점검내용","법 조항","세부내용 및 위반여부"],
		col_check_width:[ DataGrid1_ColCheckWidth1st,DataGrid1_ColCheckWidth2nd],
		col_check_note:<%=CheckNote%>,
		col_check_value:<%=CheckValue%>,
		col_foot:["점검자  소속","확 인 자","직위(직급)","성명","(서명/날인)"],
		col_foot_data:["<%=CheckerDept%>","<%=CheckerTitle%>","<%=CheckerMain%>"],
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_x_1st = sx + this.col_head_width[0]; // head의 1번째 x좌표
			var col_head_x_2nd = col_head_x_1st + this.col_head_width[1]; // head의 2번째 x좌표
			var col_head_x_3rd = col_head_x_2nd + this.col_head_width[0]; // head의 3번째 x좌표
			var col_head_y = sy ;
			var col_head_y_end = sy + this.col_head.length/2 * DataGrid1_RowHeight ;
			ctx_Line(ctx, col_head_x_1st, col_head_y, col_head_x_1st, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_head_x_2nd, col_head_y, col_head_x_2nd, col_head_y_end, 'black', 1); // 세로선
			ctx_Line(ctx, col_head_x_3rd, col_head_y, col_head_x_3rd, col_head_y_end, 'black', 1); // 세로선
			for(i=0; i<this.col_head.length/2; i++) {
				col_head_y += DataGrid1_RowHeight ;
				ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // head 가로선
				var col_head_y_center = col_head_y - (DataGrid1_RowHeight/2);
				ctx_fillText(ctx, col_head_x_1st-(this.col_head_width[0]/2), col_head_y_center, this.col_head[i*2], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, col_head_x_3rd-(this.col_head_width[0]/2), col_head_y_center, this.col_head[i*2+1], 'black', vTextStyleBold, 'center','middle');
				ctx_wrapText(ctx, col_head_x_1st+(this.col_head_width[1]/2), col_head_y_center, this.col_head_data[i*2],
						'black', vTextStyleBold, 'center','middle', this.col_head_width[1], DataGrid1_RowHeight/2);
				ctx_wrapText(ctx, col_head_x_3rd+(this.col_head_width[1]/2), col_head_y_center, this.col_head_data[i*2+1],
						'black', vTextStyleBold, 'center','middle', this.col_head_width[1], DataGrid1_RowHeight/2);
			}
			
			// 점검내용부분
			var col_check_y = col_head_y ;
			// 1번째행
			col_check_y += DataGrid1_RowHeight;
			var col_check_x_center = sx + (this.col_check_width[0] + this.col_check_width[1])/2 ;
			var col_check_y_1st_center = col_check_y - (DataGrid1_RowHeight/2) ;
			ctx_fillText(ctx, col_check_x_center, col_check_y_1st_center, this.col_check[0], 'black', vTextStyleBold, 'center','middle');
			ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1); // 가로선
			// 2번째행
			col_check_y += DataGrid1_RowHeight;
			var col_check_x_1st = sx + this.col_check_width[0] ;
			var col_check_x_1st_center = col_check_x_1st - (this.col_check_width[0]/2) ;
			var col_check_x_2nd_center = col_check_x_1st + (this.col_check_width[1]/2) ;
			var col_check_y_2nd_center = col_check_y - (DataGrid1_RowHeight/2) ;
			var col_check_y_end = col_check_y + this.col_check_note.length * DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_check_x_1st_center, col_check_y_2nd_center, this.col_check[1], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_check_x_2nd_center, col_check_y_2nd_center, this.col_check[2], 'black', vTextStyleBold, 'center','middle');
			ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1); // 가로선
			ctx_Line(ctx, col_check_x_1st, col_check_y - DataGrid1_RowHeight, col_check_x_1st, col_check_y_end, 'black', 1); // 세로선
			// 점검내용 for문
			for(i=0; i<this.col_check_note.length; i++) {
				col_check_y += DataGrid1_RowHeight;
				var col_check_y_center = col_check_y - (DataGrid1_RowHeight/2) ;
				ctx_fillText(ctx, sx + 5, col_check_y_center, this.col_check_note[i], 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, col_check_x_1st + 5, col_check_y_center, this.col_check_value[i], 'black', vTextStyleBold, 'left','middle');
				ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1); // 가로선
			}
			
// 			// 하단 점검자확인자 부분
			for(i=0; i<3; i++) {
				col_check_y += DataGrid1_RowHeight;
				var col_check_y_center = col_check_y - (DataGrid1_RowHeight/2) ;
				if(i==2)
					ctx_fillText(ctx, sx + 5, col_check_y_center, this.col_foot[1], 'black', vTextStyleBold, 'left','middle');
				else
					ctx_fillText(ctx, sx + 5, col_check_y_center, this.col_foot[0], 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx + 250, col_check_y_center, this.col_foot[2], 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx + 500, col_check_y_center, this.col_foot[3], 'black', vTextStyleBold, 'left','middle');
				ctx_fillText(ctx, sx + 700, col_check_y_center, this.col_foot[4], 'black', vTextStyleBold, 'left','middle');
				ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1); // 가로선
				// 점검자확인자 데이터 쓰기
				if(i==0) {
					ctx_fillText(ctx, sx + 110, col_check_y_center, this.col_foot_data[0], 'black', vTextStyleBold, 'left','middle');
					ctx_fillText(ctx, sx + 340, col_check_y_center, this.col_foot_data[1], 'black', vTextStyleBold, 'left','middle');
					ctx_fillText(ctx, sx + 550, col_check_y_center, this.col_foot_data[2], 'black', vTextStyleBold, 'left','middle');
				}
			}

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