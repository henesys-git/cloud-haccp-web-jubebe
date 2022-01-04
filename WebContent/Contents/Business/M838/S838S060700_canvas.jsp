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
	원재료 매입업체 위반사항 점검표 canvas (S838S060700_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CHECK_DATE = "" ;

	if(request.getParameter("check_date") == null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);

	TableModel = new DoyosaeTableModel("M838S060700E104", jArray);
	int RowCount =TableModel.getRowCount();
	
	//String PartName = "", CompanyName = "", CompanyAddress = "", CheckValue = "";
	
	// 표1에 들어갈 데이터 -> 자바스크립트 배열로 가공
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," ); // 설비명(check_gubun_mid)
		DataArray.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" + "," ); // 세부부위(check_gubun_sm)
		DataArray.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," ); // 점검항목(check_note)
		DataArray.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "" ); // 점검결과(check_value)
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");

	String[] Check_Date_for_Canvas_Array = TableModel.getValueAt(0, 6).toString().split("-");
	String Check_Date_for_Canvas = Check_Date_for_Canvas_Array[0] + "년 "
									+ Check_Date_for_Canvas_Array[1] + "월 "
									+ Check_Date_for_Canvas_Array[2] + "일";
	
%>

<script type="text/javascript">	
	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 60; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowHeight_Big = 35; // 표1의 행 높이 ( 큰 사이즈 )
	var DataGrid1_RowCount = <%=RowCount%>; // 표 1의 원재료 행 수
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid1_HeightEnd = HaedText_HeightEnd + ((DataGrid1_RowHeight_Big * 2) * DataGrid1_RowCount + DataGrid1_RowHeight * 2); // 표1 끝나는 위치
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++)
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
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
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid1_HeightEnd);
		
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			//ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var middle_info = '원재료 매입업체 위반사항 점검표' ;
			// 헤드텍스트
			ctx_fillText(ctx, (sx+ex)/2, sy+(ey-sy)/4,
					middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["제품명","제조원","주소","위반사항"],
		col_head_width:[155,155,350,350],
		col_head_width_sum:[155,310,660,1010],
		col_data:<%=DataArray%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			//ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight ;
			var col_head_y_center = col_head_y + DataGrid1_RowHeight/2 ;
			var col_head_x = sx;
			
			var date_info = "<%=Check_Date_for_Canvas%>";
			
			ctx_fillText(ctx, sx+(ex-sx)/2, col_head_y-DataGrid1_RowHeight/2, 
					date_info,	'black', vTextStyle, 'center','middle');
			
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			ctx_Line(ctx, sx, col_head_y, sx, ey, 'black', 1); // 세로선
			
			for( i = 0 ; i < this.col_head_width.length ; i++ )
			{
				col_head_x += this.col_head_width[i];
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				
				if( i < this.col_head_width.length ) // 마지막엔 세로선 그릴필요X
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, ey, 'black', 1); // 세로선
					
				ctx_fillText(ctx, col_head_x_center, col_head_y_center,
						this.col_head[i], 'black', vTextStyleBold, 'center','middle');
			}
			
			col_head_y += DataGrid1_RowHeight;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			
			// 데이터
			var col_data_y = col_head_y ;
			var col_data_y_1st_top = col_head_y; // 1번째 열 합치기 기준 y좌표
			var col_data_y_2nd_top = col_head_y; // 2번째 열 합치기 기준 y좌표
			
			for( i = 0 ; i < this.col_data.length ; i++ )
			{
				col_data_y += DataGrid1_RowHeight_Big * 2 ;
				var col_data_y_center = col_data_y - DataGrid1_RowHeight_Big ;
				var col_data_x = sx ;
				
				for( j = 0 ; j < this.col_data[i].length ; j++ )
				{
					col_data_x += this.col_head_width[j] ;
					var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
					
					if( j == 0 ) // 제품명
					{
						ctx_fillText(ctx, col_data_x-this.col_head_width[j]/2, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'center','middle');
					}
					else if( j == 1 ) // 제조원
					{
						ctx_fillText(ctx, col_data_x-this.col_head_width[j]/2, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'center','middle');
					}
					else if( j == 2 ) // 주소
					{
						/* ctx_fillText(ctx, col_data_x-this.col_head_width[j]/2, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'center','middle'); */
						
						ctx_wrapText(ctx, col_data_x-this.col_head_width[j]/2, col_data_y_center,
								this.col_data[i][j], 'black', vTextStyle, 'center','middle',
								this.col_head_width_sum[2] - this.col_head_width_sum[1],25);
					}
					else if( j == 3 ) // 위반사항
					{
						ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
								'black', vTextStyle, 'center','middle');
					}
					
					ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
				} // j for end
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