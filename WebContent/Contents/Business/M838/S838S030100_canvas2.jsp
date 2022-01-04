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
설비이력카드 canvas (S838S003100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_SEOLBI_CD="", GV_REVISION_NO="" ;

	if(request.getParameter("seolbi_cd")== null)
		GV_SEOLBI_CD = "";
	else
		GV_SEOLBI_CD = request.getParameter("seolbi_cd");
	
	if(request.getParameter("revision_no")== null)
		GV_REVISION_NO = "";
	else
		GV_REVISION_NO = request.getParameter("revision_no");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "seolbi_cd", GV_SEOLBI_CD);
	jArray.put( "revision_no", GV_REVISION_NO);

	TableModel = new DoyosaeTableModel("M838S030100E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	String SeolbiNm="", SeolbiCd="", ModelNm="", Gugyuk="", SeolbiMaker="", DoipDate="",
			PowerType="", UseBuseo="", AsTelNo1="", AsTelNo2="", ImgFilename="", Bigo="";
	if(RowCount>0) {
		SeolbiNm 	= TableModel.getValueAt(0, 0).toString().trim() ;
		SeolbiCd 	= TableModel.getValueAt(0, 1).toString().trim() ;
		ModelNm 	= TableModel.getValueAt(0, 2).toString().trim() ;
		Gugyuk 		= TableModel.getValueAt(0, 3).toString().trim() ;
		SeolbiMaker = TableModel.getValueAt(0, 4).toString().trim() ;
		DoipDate 	= TableModel.getValueAt(0, 5).toString().trim() ;
		PowerType 	= TableModel.getValueAt(0, 6).toString().trim() ;
		UseBuseo 	= TableModel.getValueAt(0, 7).toString().trim() ;
		AsTelNo1 	= TableModel.getValueAt(0, 8).toString().trim() ;
		AsTelNo2 	= TableModel.getValueAt(0, 9).toString().trim() ;
		ImgFilename = TableModel.getValueAt(0, 10).toString().trim() ;
		Bigo 		= TableModel.getValueAt(0, 11).toString().trim() ;
	}
	
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
			DataArray.append("[");
			DataArray.append( "'" + (i+1) + "'" + "," ); // NO순번
			DataArray.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," ); // 수리일자
			DataArray.append( "'" + TableModel.getValueAt(i, 13).toString().trim() + "'" + "," ); // 고장내용
			DataArray.append( "'" + TableModel.getValueAt(i, 14).toString().trim() + "'" + "," ); // 수리내용
			DataArray.append( "''" ); // 확인
			if(i==RowCount-1) DataArray.append("]");
			else DataArray.append("],");
	}
	DataArray.append("]");

%>

<script type="text/javascript">	
	
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	// 표1 영역
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowCount = 21 ; // 표1의 행 개수
	var DataGrid1_HeightStart = HaedText_HeightEnd + 25
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + (DataGrid1_RowCount * DataGrid1_RowHeight);
	// 표2 영역
	var DataGrid2_RowHeight = 25; // 표2의 행 높이
	var DataGrid2_RowCount = 4 + 1 ; // 표2의 행 개수(측정데이터 개수+헤드)
	var DataGrid2_Width = 0 ; // doc.ready에서 표2의 각 열너비를 더해서 계산
	var DataGrid2_HeightEnd = DataGrid1_HeightEnd + (DataGrid2_RowCount * DataGrid2_RowHeight);
	// 표3 영역
	var DataGrid3_RowHeight = 25; // 표2의 행 높이
	var DataGrid3_RowCount =  8 + 1 ; // 표2의 행 개수(측정데이터 개수+헤드)
	var DataGrid3_HeightEnd = DataGrid2_HeightEnd + (DataGrid3_RowCount * DataGrid3_RowHeight);
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid2.col_head_width.length; i++) {
    		DataGrid2_Width += DataGrid2.col_head_width[i];
    	}
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid2_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid3_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightEnd, pointEX, pointSY + DataGrid2_HeightEnd);
		DataGrid3.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightEnd, pointEX, pointEY);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var middle_info = '설비이력카드' ;
			var logo_box_width = 100; //로고박스 너비
			var approval_box_width = 200; //결재박스 너비
			// 헤드텍스트
			ctx_fillText(ctx, sx+logo_box_width+(ex-sx-approval_box_width-logo_box_width)/2, sy+(ey-sy)/2,
					middle_info, 'black', 'bold 30px 맑은고딕', 'center','middle');
			// 왼쪽로고
			ctx_Line(ctx, sx+logo_box_width, sy, sx+logo_box_width, ey, 'black', 1); // 세로선
			// 결재 박스
			ctx_Line(ctx, ex-approval_box_width, sy, ex-approval_box_width, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width/2, sy, ex-approval_box_width/2, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width, sy+(ey-sy)/3, ex, sy+(ey-sy)/3, 'black', 1); // 가로선
			ctx_Line(ctx, ex-approval_box_width, sy+(ey-sy)*2/3, ex, sy+(ey-sy)*2/3, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-approval_box_width*3/4, sy+(ey-sy)*1/6, '페이지번호', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*3/4, sy+(ey-sy)*3/6, '제정일자', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*3/4, sy+(ey-sy)*5/6, '개정일자', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*1/4, sy+(ey-sy)*1/6, '1/1페이지', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*1/4, sy+(ey-sy)*3/6, '2011.03.10', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width*1/4, sy+(ey-sy)*5/6, '2016.07.01', 'black', vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 (설비정보)
	var DataGrid1 = {
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			var col_head_width = DataGrid2_Width/4;
			var col_x_1st = sx + col_head_width;
			var col_x_2nd = col_x_1st + col_head_width;
			var col_x_3rd = col_x_2nd + col_head_width;
			var col_y = sy;
			ctx_fillColor(ctx, sx, sy, col_x_1st, sy+DataGrid1_RowHeight*7, '#eeffdd'); // 배경 연두색
			ctx_fillColor(ctx, col_x_2nd, sy, col_x_3rd, sy+DataGrid1_RowHeight*7, '#eeffdd'); // 배경 연두색
			// 1번째줄 관리번호,구입년도
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st-col_head_width/2, col_y-DataGrid1_RowHeight/2, "관리번호", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "<%=SeolbiCd%>", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "구입년도", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_3rd+col_head_width/2, col_y-DataGrid1_RowHeight/2, "<%=DoipDate%>", 'black', vTextStyle, 'center','middle');
			// 2번째줄 설비명,구입가격
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			col_y += DataGrid1_RowHeight ;
			ctx_fillText(ctx, col_x_1st-col_head_width/2, col_y-DataGrid1_RowHeight/2, "설비명", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_2nd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "<%=SeolbiNm%>", 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "구입가격", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_x_3rd+col_head_width/2, col_y-DataGrid1_RowHeight/2, "", 'black', vTextStyle, 'center','middle');
			// 3번째줄 규격및모델,설비제원
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			col_y += DataGrid1_RowHeight*5 ;
			ctx_fillText(ctx, col_x_1st-col_head_width/2, col_y-DataGrid1_RowHeight*5/2, "규격 및 모델", 'black', vTextStyleBold, 'center','middle');
			ctx_wrapText_space(ctx, col_x_2nd-col_head_width/2, col_y-DataGrid1_RowHeight*5/2, "<%=Gugyuk%>",
					'black', vTextStyle, 'center', 'middle', col_head_width-10, DataGrid1_RowHeight);
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight*5/2, "설비제원", 'black', vTextStyleBold, 'center','middle');
			ctx_wrapText_space(ctx, col_x_3rd+col_head_width/2, col_y-DataGrid1_RowHeight*5/2, "",
					'black', vTextStyle, 'center','middle', col_head_width-10, DataGrid1_RowHeight);
			ctx_Line(ctx, col_x_1st, sy, col_x_1st, sy+DataGrid1_RowHeight*7, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_2nd, sy, col_x_2nd, sy+DataGrid1_RowHeight*7, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_3rd, sy, col_x_3rd, sy+DataGrid1_RowHeight*7, 'black', 1); // 세로선
			// 4번째줄 세부사항
			ctx_fillColor(ctx, sx, col_y, ex, col_y+DataGrid1_RowHeight, '#eeffdd'); // 배경 연두색
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			col_y += DataGrid1_RowHeight ;
			var blank_tab = '                ';
			var text_aaa = '세'+blank_tab+'부'+blank_tab+'사'+blank_tab+'항';
			ctx_fillText(ctx, col_x_2nd, col_y-DataGrid1_RowHeight/2, text_aaa, 'black', vTextStyleBold, 'center','middle');
			// 5번째줄 세부사항 내용(이미지,비고)
			ctx_Line(ctx, sx, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_Line(ctx, col_x_2nd, col_y, col_x_2nd, col_y+DataGrid1_RowHeight*7, 'black', 1); // 세로선
			col_y += DataGrid1_RowHeight*7 ;
			<%if(RowCount>0) {%> //설비 이미지 그리기(비동기)
			var SealImage = new Image();
			SealImage.addEventListener('load', function(){
				ctx.drawImage(SealImage, sx+5, sy+DataGrid1_RowHeight*8+5, col_head_width*2-10, DataGrid1_RowHeight*13-10);
			},false);
         	var imageFileName = "<%=ImgFilename%>";
 			if(imageFileName!=null && imageFileName!="") {
				SealImage.src= "<%=Config.this_SERVER_path%>/images/SULBI/"  + imageFileName + "?v=" + Math.random()
 			}
 			<%}%>
			// 5번째줄밑으로 구입및A/S
			ctx_fillColor(ctx, col_x_2nd, col_y, ex, col_y+DataGrid1_RowHeight, '#eeffdd'); // 배경 연두색
			ctx_Line(ctx, col_x_2nd, col_y, ex, col_y, 'black', 1); // 가로선
			col_y += DataGrid1_RowHeight ;
			ctx_fillColor(ctx, col_x_2nd, col_y, col_x_3rd, col_y+DataGrid1_RowHeight*5, '#eeffdd'); // 배경 연두색
			ctx_Line(ctx, col_x_2nd, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_Line(ctx, col_x_2nd, col_y-DataGrid1_RowHeight, 
					col_x_2nd, col_y+DataGrid1_RowHeight*5, 'black', 1); // 세로선
			ctx_Line(ctx, col_x_3rd, col_y, col_x_3rd, col_y+DataGrid1_RowHeight*5, 'black', 1); // 세로선
			ctx_fillText(ctx, col_x_3rd, col_y-DataGrid1_RowHeight/2, "구입 및 A/S", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_2nd, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "업체명", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_2nd, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "대표", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_2nd, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y-DataGrid1_RowHeight/2, "연락처", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			ctx_Line(ctx, col_x_3rd, col_y, ex, col_y, 'black', 1); // 가로선
			ctx_fillText(ctx, col_x_3rd-col_head_width/2, col_y, "비고", 'black', vTextStyleBold, 'center','middle');
			col_y += DataGrid1_RowHeight ;
			// 표 전체 틀(사각형)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2);
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 (데이터)
	var DataGrid2 = {
		col_head:["NO","년 월 일","설    치    장    소","확    인"],
		col_head_width:[50,150,500,100],
		col_data:[["1","<%=DoipDate%>","<%=UseBuseo%>",""]],
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy+DataGrid2_RowHeight, '#eeffdd'); // 배경 연두색
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			// 헤드
			var col_head_y = sy + DataGrid2_RowHeight ;
			var col_head_y_center = col_head_y - DataGrid2_RowHeight/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
			}
			
			// 데이터
			col_data_y = col_head_y;
			for(i=0; i<DataGrid2_RowCount-1; i++){
				col_data_y += DataGrid2_RowHeight ;
				if(i<this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid2_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2
// 	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyleBold, 'center','middle');
						ctx_wrapText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
								'black', vTextStyle, 'center','middle', this.col_head_width[j], DataGrid2_RowHeight);
					}
				}
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			}
		} // drawGrid function end
	} ; // DataGrid2(표2) 정의  end
	
	// 표3 (데이터)
	var DataGrid3 = {
		col_head:["NO","수리일자","고  장  내  용","수  리  내  용","확    인"],
		col_head_width:[50,150,200,300,100],
		col_data:<%=DataArray%>,
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표3 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy+DataGrid3_RowHeight, '#eeffdd'); // 배경 연두색
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			// 헤드
			var col_head_y = sy + DataGrid3_RowHeight ;
			var col_head_y_center = col_head_y - DataGrid3_RowHeight/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				ctx_Line(ctx, col_head_x, sy, col_head_x, ey, 'black', 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
			}
			
			// 데이터
			col_data_y = col_head_y ;
			for(i=0; i<DataGrid3_RowCount-1; i++){
				col_data_y += DataGrid3_RowHeight ;
				if(i<this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid3_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2
// 	 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyleBold, 'center','middle');
						ctx_wrapText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
								'black', vTextStyle, 'center','middle', this.col_head_width[j], DataGrid3_RowHeight);
					}
				}
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			}
		} // drawGrid function end
	} ; // DataGrid3(표3) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>