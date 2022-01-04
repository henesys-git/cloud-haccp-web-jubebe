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
차량운행일지 canvas (S838S060100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModelE174,TableModelE184;

	String GV_VHCL_NO="", GV_VHCL_NO_REV="", GV_SERVICE_DATE="" ;

	if(request.getParameter("vhcl_no")== null)
		GV_VHCL_NO="";
	else
		GV_VHCL_NO = request.getParameter("vhcl_no");	
	
	if(request.getParameter("vhcl_no_rev")== null)
		GV_VHCL_NO_REV="";
	else
		GV_VHCL_NO_REV = request.getParameter("vhcl_no_rev");
	
	if(request.getParameter("service_date")== null)
		GV_SERVICE_DATE="";
	else
		GV_SERVICE_DATE = request.getParameter("service_date");
	 
	String service_date = GV_SERVICE_DATE.substring(0,7); // yy-mm만 가져오기
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
// 	jArray.put( "vhcl_no", GV_VHCL_NO);
// 	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV);
	jArray.put( "service_date", service_date);
	
	TableModelE184 = new DoyosaeTableModel("M838S060100E184", jArray); // 운행실적
	int RowCountE184 =TableModelE184.getRowCount();
	
	String VehicleNm="", Driver="", ServiceDate="";
	String IncongNote="", ImproveNote="", ImproveNoteCheck="", Uniqueness="";
	String Writor="", WriteDate="", Reviewer="", ReviewDate="", Approval="", ApproveDate="";
	
	StringBuffer DataArrayE184 = new StringBuffer();
	DataArrayE184.append("[");
	for(int i=0; i<RowCountE184; i++) {
		DataArrayE184.append("[");
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 0).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 1).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 2).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 3).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 4).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 5).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 6).toString().trim() + "'" + "," ); 
		DataArrayE184.append( "'" + TableModelE184.getValueAt(i, 7).toString().trim() + "'" + "" );
		if(i==RowCountE184-1) DataArrayE184.append("]");
		else DataArrayE184.append("],");
	}
	DataArrayE184.append("]");
	
%>

<script type="text/javascript">	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 40; // 표1의 행 높이
	var DataGrid1_RowCount = 28; // 표1의 행 개수
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산하려했으나 일단 1000으로 직접지정
	var DataGrid1_HeightEnd = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight);
			
    $(document).ready(function () {
    	// 표1의 전체너비
    	DataGrid1_Width = 1000;
    	
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
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, 
	    				  pointEX, pointSY + HaedText_HeightEnd);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, 
						   pointEX, pointSY + DataGrid1_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var top_info = '차량 운행 일지' ;
			var bottom_info1 = '1.5톤 냉동탑차 : 차량번호 89라 5077' ;
			var bottom_info2 = '3.5톤 윙바디 : 차량번호 88너 1237' ;
			
			ctx_Line(ctx, sx, ey-30, ex, ey-30, 'black', 1); // 가로선
			ctx_Line(ctx, sx, ey-60, ex, ey-60, 'black', 1); // 가로선
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드텍스트
			ctx_fillText(ctx, sx+(ex-sx)/2, sy+30, 
					top_info, 'black', 'bold 36px 맑은고딕', 'center','top');
			if('<%=VehicleNm%>'.length>0) bottom_info1 += '<%=VehicleNm%>';	/* 차량 */
			
			ctx_fillText(ctx, ex-10, ey-38, bottom_info1, 'black', vTextStyleBold, 'right','bottom');
			ctx_fillText(ctx, ex-10, ey-7,  bottom_info2, 'black', vTextStyleBold, 'right','bottom');
		} // HeadText.drawText function end
	} ;
	
	// 표1 (점검항목)
	var DataGrid1 = {
		col_head:["일시","차종","차량번호","출발","도착","주행후","운행km","(차량이상유무, 기타비용내역)","서명"],
		col_head_width:[100,200,300,400,500,600,700,900,1000], // 각 칼럼이 끝나는 부분의 x좌표
		col_data:<%=DataArrayE184%>,
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			// 표 전체 틀(사각형)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); 
			
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight ;				// '차량' text의 끝나는 y지점
			var col_head_y2 = col_head_y + DataGrid1_RowHeight ;	// '일시' text의 끝나는 y지점
			var col_data_y = col_head_y2 + DataGrid1_RowHeight-20;	// 데이터 값 뿌리기위한 y축 기준
			var col_head_y_center = sy + (DataGrid1_RowHeight)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			
			ctx_Line(ctx, sx+this.col_head_width[0], col_head_y, sx+700, col_head_y, 'black', 1); 	// 가로선
			ctx_Line(ctx, sx, col_head_y2, ex, col_head_y2, 'black', 1); // 가로선
			
			for(i = 0; i < this.col_head_width.length-1; i++) {	// 세로선
				if(i == 1 || i == 3 || i == 5) {
					sy = col_head_y;
				} else {
					sy = col_head_y - DataGrid1_RowHeight;
				}
				ctx_Line(ctx, sx + this.col_head_width[i], sy, 
						 sx + this.col_head_width[i], ey, 'black', 1);
			}
			
			// 데이터 값 표시
			for(i = 0; i < this.col_data.length; i++) { 
				for(j = 0; j < this.col_data[i].length; j++){
					if(j == 0) {
						col_head_x_center = sx+this.col_head_width[j]/2;
						col_head_x_limit = this.col_head_width[j]-sx;
					}  else {
						col_head_x_center = this.col_head_width[j]
											- (this.col_head_width[j]-this.col_head_width[j-1])/2 + 10;
						col_head_x_limit = this.col_head_width[j] - this.col_head_width[j-1];
					}
					ctx_wrapText_space(ctx, col_head_x_center, col_data_y, this.col_data[i][j],
					   		'black', vTextStyleBold, 'center','middle', col_head_x_limit, 15);
				}
				col_data_y += DataGrid1_RowHeight;	// y축 더하기
			}
			
			// 칼럼 타이틀 (차량,운행구간,주행거리 제외)
			for(j = 0; j < this.col_head.length; j++) {
				if(j == 0) {
					col_head_x_center = sx+this.col_head_width[j]/2;
					col_head_x_limit = this.col_head_width[j]-sx;
				} else {
					col_head_x_center = this.col_head_width[j]
										- (this.col_head_width[j]-this.col_head_width[j-1])/2 + 10;
					col_head_x_limit = this.col_head_width[j] - this.col_head_width[j-1];
				}
				if(j > 0 && j < 7) {
					col_head_y_center = col_head_y2 - (col_head_y2 - col_head_y)/2;
				} else {
					col_head_y_center = col_head_y2 - (col_head_y2 - sy)/2;
				}
				ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, this.col_head[j],
						   		'black', vTextStyleBold, 'center','middle', col_head_x_limit, 30);
			}
			
			// 칼럼 타이틀 (차량,운행구간,주행거리)
			ctx_fillText(ctx, sx+this.col_head_width[2]-(this.col_head_width[2]-this.col_head_width[0])/2, 
						 sy+(col_head_y-sy)/2, '차량', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+this.col_head_width[4]-(this.col_head_width[4]-this.col_head_width[2])/2, 
					 sy+(col_head_y-sy)/2, '운행 구간', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+this.col_head_width[6]-(this.col_head_width[6]-this.col_head_width[4])/2, 
					 sy+(col_head_y-sy)/2, '주행 거리', 'black', vTextStyleBold, 'center','middle');
			
			// 데이터 목록 가로선
			for(k = 0; k < DataGrid1_RowCount; k++) {
				col_head_y2 += DataGrid1_RowHeight;
				ctx_Line(ctx, sx, col_head_y2, ex, col_head_y2, 'black', 1); 	// 가로선
			}
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
</script>
    <div id="PrintAreaP" style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas"></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>