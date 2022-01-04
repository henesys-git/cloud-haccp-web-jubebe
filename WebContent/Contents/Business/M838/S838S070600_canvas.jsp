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
월별 검사설비점검일지 canvas (S838S070700_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CORRECTION_YM="", GV_PAGE_START="" ;

	if(request.getParameter("Correction_Year")== null)
		GV_CORRECTION_YM="";
	else
		GV_CORRECTION_YM = request.getParameter("Correction_Year");	
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 10;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "Correction_year", GV_CORRECTION_YM);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * GV_PAGE_COUNT);
	
	System.out.println("1111111111111111111111111111111111111111 GV_CORRECTION_YM : " + GV_CORRECTION_YM);


	TableModel = new DoyosaeTableModel("M838S070600E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	String Correction_Year="", Writor="", WriteDate="", Approval="", ApproveDate="";
	if(RowCount>0) {
		Correction_Year=TableModel.getValueAt(0, 15).toString().trim() ;
		Writor=TableModel.getValueAt(0, 9).toString().trim() ;
		WriteDate=TableModel.getValueAt(0, 11).toString().trim() ;
		Approval=TableModel.getValueAt(0, 12).toString().trim() ;
		ApproveDate=TableModel.getValueAt(0, 14).toString().trim() ;
	}
	
	// 캔버스안에 넣어야할 값들을 배열형태로 집어넣음 
	
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + (i+1) + "'" + "," ); // No.
		DataArray.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "," ); // correction_manage_no
		DataArray.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'" + "," ); // correction_epuipment_name
		DataArray.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" + "," ); // correction_model
		DataArray.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," ); // correction_making_cop
		DataArray.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + " 개월" + "'" + "," ); // correction_period
		DataArray.append( "'" + TableModel.getValueAt(i, 6).toString().trim() + "'" + "," ); // correction_date
		DataArray.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'" + "," ); // correction_duedate
		DataArray.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "" ); // using_location
		if(i==RowCount-1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
<%-- 	var DataGrid1_RowCount = <%=RowCount%> + 1 ; // 표1의 행 개수(체크리스트행 개수+헤드) --%>
	var DataGrid1_RowCount = <%=GV_PAGE_COUNT%> + 1 ; // 표1의 행 개수(체크리스트행 개수+헤드)
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid1_Height = HaedText_HeightEnd + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이( 상단텍스트 끝 위치 + (행개수 * 행높이))
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++)
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2; // 캔버스영역 높이
    	    	   	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		
		// id의 'myCanvas' ready에서 변수형태로 지정함 --> canvas가 ctx에 변수로 지정됨
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
	var HeadText = { // --> 일종의 class
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var approval_box_width = 190; //결재박스 너비(30 + 80*2)
			// 헤드텍스트
			if('<%=GV_CORRECTION_YM%>'.length>0) {
				var middle_info = '(' 
						+ parseInt(<%=GV_CORRECTION_YM%>) 
						+ ')년 교정 계획서' ;
			} else {
				var middle_info = '( )년 교정 계획서' ;
			}
			
			// ▽▽▽▽▽ // MasterMainPage에서 1044번줄에 선언된 function을 사용 // ▽▽▽▽▽ //   
			
			// fillText는 글자를 그리는 것																		   
			ctx_fillText(ctx, (sx+ex-approval_box_width)/2, sy+30, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			ctx_textUnderline(ctx, (sx+ex-approval_box_width)/2, sy+30, middle_info, 'black', 30, 5); // 중간 글자에 밑줄넣기
			// 결재 박스
						ctx_Box(ctx, ex-approval_box_width, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			ctx_Line(ctx, ex-approval_box_width+30, sy, ex-approval_box_width+30, ey, 'black', 2); // 세로선
// 			ctx_Line(ctx, ex-(approval_box_width-30)*2/3, sy, ex-(approval_box_width-30)*2/3, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-(approval_box_width-30)*1/2, sy, ex-(approval_box_width-30)*1/2, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width+30, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_Line(ctx, ex-approval_box_width+30, ey-30, ex, ey-30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-approval_box_width+15, sy+30, '결', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width+15, ey-30, '재', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*4.5/6, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1.5/6, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
			var bottom_write = '/' ;
			var bottom_check = '/' ;
			var bottom_approval = '/' ;
			if('<%=WriteDate%>'.length>0) {
				var date = new Date('<%=WriteDate%>');
				bottom_write = ("0" + (date.getMonth() + 1)).slice(-2) + ' / ' + ("0" + date.getDate()).slice(-2) ;
			}
			if('<%=ApproveDate%>'.length>0) {
				var date = new Date('<%=ApproveDate%>');
				bottom_approval = ("0" + (date.getMonth() + 1)).slice(-2) + ' / ' + ("0" + date.getDate()).slice(-2) ;
			}
			ctx_fillText(ctx, ex-(approval_box_width-30)*4.5/6, ey-15, bottom_write, 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1.5/6, ey-15, bottom_approval, 'black', vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["No.","관리 번호","검사 설비명","모델/규격","제작 회사","교정 주기","교정일","교정 예정일","사용 장소"],
		col_head_width:[120,180,0,110,110,110,120,120,180],
// 		col_unit:["개월"], // 표1 양식에 들어갈 단위
		col_data:<%=DataArray%>,
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight ;   			// 한줄 높이
			var col_head_y_center = sy + (DataGrid1_RowHeight)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y-3, ex, col_head_y-3, 'black', 1); // 가로선(이중선)
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선(이중선)
			
			// col_head_width에 선언된 배열만큼의 크기대로 만들어지는 곳 
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i==this.col_head_width.length-1) { // 마지막엔 세로선 그릴필요X
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				}
				else if(i==2) { // 설비명 => 아무것도 안함(숨김)
					// 아무것도 안함(숨겨진 데이터)
				} else {
					ctx_Line(ctx, col_head_x, sy, col_head_x, sy + (DataGrid1_RowCount * DataGrid1_RowHeight), 'black', 1); // 세로선
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				}
				
			}
			
			// 데이터		
			var col_data_y = sy + DataGrid1_RowHeight ;
// 			for(i=0; i<this.col_data.length; i++){
			for(i=0; i<DataGrid1_RowCount-1; i++){
				col_data_y += DataGrid1_RowHeight ;
				// 데이터 텍스트
				if(i < this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid1_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
						if(j==2) { // 설비명 => 아무것도 안함(숨김)
							// 아무것도 안함(숨겨진 데이터)
						}
// 						else if(j==5) { // 표준값,지시값,교정값
							// 단위
// 							if(this.col_data[i][2].indexOf("온도") > 0)
// 								ctx_fillText(ctx, col_data_x-5, col_data_y_center, this.col_unit[0], 'black', vTextStyle, 'end','middle');
// 							else if(this.col_data[i][2].indexOf("저울") > 0)
// 								ctx_fillText(ctx, col_data_x-5, col_data_y_center, this.col_unit[1], 'black', vTextStyle, 'end','middle');
// 							else if(this.col_data[i][2].indexOf("습도") > 0)
// 								ctx_fillText(ctx, col_data_x-5, col_data_y_center, this.col_unit[2], 'black', vTextStyle, 'end','middle');
							// 숫자 데이터
// 							ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyle, 'center','middle');
// 						}
						else {
//		 					ctx_fillText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j], 'black', vTextStyle, 'center','middle');
							ctx_wrapText(ctx, col_data_x_center, col_data_y_center, this.col_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-10, DataGrid1_RowHeight/2);
						}
					}
				}
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1); // 가로선
			}
			
			// 하단 기준안내문
// 			var col_standard = [' □ 허용한계치 : ① 온도계 ==> ± 1 ℃ ,   ② 저울 ==> ± 1 g,   ③ 습도계 ==> ± 3 %',
// 								'', // 줄바꿈
// 								' □ 교정 주기',
// 								'    ◦ 신규구입 계측기는 공인기관에서 발행한 교정 검사 성적서 첨부',
// 								'    ◦ 자가 검정은 월 1회 실시',
// 								'', // 줄바꿈
// 								' □ 검정 방법',
// 								'', // 줄바꿈
// 								'   ① 온도계',
// 								'    ◦ 검정 방법 : 계측기가 부착된 해당 작업장에서 표준 계측기와 비교한다.',
// 								'    ◦ 기존 계측기는 현재 사용중인 계측기와 표준 계측기의 수치를 비교하여 ± 1℃/1g/3% 이상 차이가',
// 								'      있을 경우 예비 계측기로 대체하여 사용한다.',
// 								'    ◦ 계측기 파손 및 외부 서비스를 받은 경우 비고란에 표시',
// 								'', // 줄바꿈
// 								'   ② 저울',
// 								'    ◦ 교정방법 : 표준 분동(교정 필)을 저울에 올려놓아 비교한다.',
// 								'    ◦ 기존 저울은 표준 분동에서 표시한 중량의 수치를 비교하여 ±1g 이상 차이가 있을 경우',
// 								'      외부 교정 실시',
// 								'    ◦ 저울 파손 및 외부 서비스를 받은 경우 비고란에 표시' ];
// 			var col_standard_y_center = col_data_y + DataGrid1_RowHeight/2;
// 			for(i=0; i<col_standard.length; i++) {
// 				col_standard_y_center += DataGrid1_RowHeight/2;
// 				ctx_fillText(ctx, sx + 10, col_standard_y_center-20, col_standard[i], 'black', '15px 맑은고딕', 'start','middle');
// 			}
			
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070600_canvas.jsp"
			 				 + "?Correction_Year=" + "<%=GV_CORRECTION_YM%>"
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%>; // 이전페이지	
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070600_canvas.jsp"
							 + "?Correction_Year=" + "<%=GV_CORRECTION_YM%>"
							 + "&page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%>; // 다음페이지	
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