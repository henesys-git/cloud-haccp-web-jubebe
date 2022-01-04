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
외부인 출입기록부 canvas (S838S050400_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_EXTNL_IN_DATE_START="", GV_EXTNL_IN_DATE_END="",GV_PAGE_START="" ;

// 	if(request.getParameter("extnl_in_date_start")== null)
// 		GV_EXTNL_IN_DATE_START = "";
// 	else
// 		GV_EXTNL_IN_DATE_START = request.getParameter("extnl_in_date_start");
	
// 	if(request.getParameter("extnl_in_date_end")== null)
// 		GV_EXTNL_IN_DATE_END = "";
// 	else
// 		GV_EXTNL_IN_DATE_END = request.getParameter("extnl_in_date_end");
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 26;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
// 	jArray.put( "extnl_in_date_start", GV_EXTNL_IN_DATE_START);
// 	jArray.put( "extnl_in_date_end", GV_EXTNL_IN_DATE_END);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * GV_PAGE_COUNT);

	TableModel = new DoyosaeTableModel("M838S050400E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "," ); // extnl_in_date
		DataArray.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," ); // extnl_in_object
		DataArray.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'" + "," ); // extnl_in_conpany
		DataArray.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" + "," ); // extnl_in_title
		DataArray.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "" ); // extnl_in_cust_name
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 100; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 25; // 표1의 1번째 행 높이
<%-- 	var DataGrid1_RowCount = <%=RowCount%> + 1; // 표1의 행 개수(체크리스트행 개수 + 나머지행(헤드) 개수) --%>
	var DataGrid1_RowCount = <%=GV_PAGE_COUNT%> + 1; // 표1의 행 개수(체크리스트행 개수 + 나머지행(헤드) 개수)
	var DataGrid1_Width = 0 ; // document ready에서 표1칼럼너비 전부 합쳐서 구함
	var DataGrid1_Height = HaedText_HeightEnd + DataGrid1_RowHeight1st 
						 + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이( 상단텍스트 끝 위치 + (행개수 * 행높이) )
			
    $(document).ready(function () {
    	// 표1의 칼럼너비 전부 합쳐서 표전체너비 구하기
    	for(i=0; i<DataGrid1.col_head_width.length; i++){
    		DataGrid1_Width += DataGrid1.col_head_width[i] ;
    	}
    	
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
			var top_info = 'HS-PP-04-D 외부인 출입기록부' ;
			var middle_info = '외부인 출입 기록부' ;
			
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
// 			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			ctx_textUnderline(ctx, (sx+ex)/2, sy+30, middle_info, 'black', 30, 5); // 중간 글자에 밑줄넣기
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head_1st:["일  시","방문, 점검 목적","방문자","방문자","방문자","방문자","결재","결재"],
		col_head_2nd:["일  시","방문, 점검 목적","소속","직위(직급)","성명","서명(날인)","품질 팀장","승인"],
		col_head_width:[120,400,80,80,80,80,80,80],
		col_data:<%=DataArray%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st + DataGrid1_RowHeight, '#cccccc'); // 표 헤드 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y_center = sy + (DataGrid1_RowHeight1st + DataGrid1_RowHeight)/2 ;
			var col_head_y_1st = sy + DataGrid1_RowHeight1st ;
			var col_head_y_1st_center = col_head_y_1st - DataGrid1_RowHeight1st/2 ;
			var col_head_y_2nd = col_head_y_1st + DataGrid1_RowHeight ;
			var col_head_y_2nd_center = col_head_y_2nd - DataGrid1_RowHeight/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y_2nd, ex, col_head_y_2nd, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i==0) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head_1st[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==1) {
					ctx_Line(ctx, col_head_x, col_head_y_1st, ex, col_head_y_1st, 'black', 1); // 가로선
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head_1st[i], 'black', vTextStyleBold, 'center','middle');
					col_head_x_start = col_head_x;
				} else if(i==5 || i==this.col_head_width.length-1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
					var col_head_x_total_center = col_head_x_start + (col_head_x - col_head_x_start)/2 ;
					ctx_fillText(ctx, col_head_x_total_center, col_head_y_1st_center, this.col_head_1st[i], 'black', vTextStyleBold, 'center','middle');
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i], 'black', vTextStyleBold, 'center','middle');
					col_head_x_start = col_head_x;
				} else {
					ctx_Line(ctx, col_head_x, col_head_y_1st, col_head_x, ey, 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_2nd_center, this.col_head_2nd[i], 'black', vTextStyleBold, 'center','middle');
				}
			}
			var col_data_y = sy + DataGrid1_RowHeight1st + DataGrid1_RowHeight ;
			for(i=0; i<DataGrid1_RowCount-2; i++){
				col_data_y += DataGrid1_RowHeight ;
				
			}
			
			// 데이터
			col_data_y = sy + DataGrid1_RowHeight1st + DataGrid1_RowHeight ;
// 			for(i=0; i<this.col_data.length; i++){
			for(i=0; i<DataGrid1_RowCount-1; i++){
				col_data_y += DataGrid1_RowHeight ;
				if(i<this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid1_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2
//	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyleBold, 'center','middle');
						ctx_wrapText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
								'black', vTextStyleBold, 'center','middle', this.col_head_width[j], DataGrid1_RowHeight/2);
					}
				}
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			}
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050400_canvas.jsp" 
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%> // 이전페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050400_canvas.jsp" 
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%> // 다음페이지	
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