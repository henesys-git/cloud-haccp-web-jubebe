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
미생물검사결과서 canvas (S838S070500_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_BIO_CHECK_REGNO="", GV_BIO_CHECK_REV="" ;

	if(request.getParameter("bio_chek_regno")== null)
		GV_BIO_CHECK_REGNO = "";
	else
		GV_BIO_CHECK_REGNO = request.getParameter("bio_chek_regno");
	
	if(request.getParameter("bio_check_rev")== null)
		GV_BIO_CHECK_REV = "";
	else
		GV_BIO_CHECK_REV = request.getParameter("bio_check_rev");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "bio_chek_regno", GV_BIO_CHECK_REGNO);
	jArray.put( "bio_check_rev", GV_BIO_CHECK_REV);

	TableModel = new DoyosaeTableModel("M838S070500E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 작성일자,승인일자,작성자,시료채취일,시료발송일,검사의뢰기관명,기관번호,검사판정일,개선조치내역
	String WriteDate="",ApprovalDate="",WritorMain="",SampleDate="",
			SampleSendDate="",CustNm="",CustCd="",InsRsltDate="",ImproveNote="" ;
	if(RowCount>0) {
		WriteDate = TableModel.getValueAt(0, 19).toString().trim();
		ApprovalDate = TableModel.getValueAt(0, 23).toString().trim();
		WritorMain = TableModel.getValueAt(0, 22).toString().trim();
		SampleDate = TableModel.getValueAt(0, 3).toString().trim();
		SampleSendDate = TableModel.getValueAt(0, 4).toString().trim();
		CustNm = TableModel.getValueAt(0, 7).toString().trim();
		CustCd = TableModel.getValueAt(0, 5).toString().trim();
		InsRsltDate = TableModel.getValueAt(0, 8).toString().trim();
		ImproveNote = TableModel.getValueAt(0, 17).toString().trim();
	}
	
	// 분류,제품명,이력번호,일반세균,대장균,살모넬라,결과
	StringBuffer CheckData = new StringBuffer();
	
	CheckData.append("[");
	for(int i=0; i<RowCount; i++) {
		if(i==RowCount-1) {
			CheckData.append("[");
			CheckData.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 13).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 14).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 15).toString().trim() + "'" );
			CheckData.append("]");
		} else {
			CheckData.append("[");
			CheckData.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 13).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 14).toString().trim() + "'" + "," );
			CheckData.append( "'" + TableModel.getValueAt(i, 15).toString().trim() + "'" );
			CheckData.append("],");
		}
	}
	CheckData.append("]");
	
	// 안쓰는거
	String CheckDuration = "", WritorSecond = "";
	StringBuffer CheckGubunMid = new StringBuffer();
	StringBuffer CheckGubunSm = new StringBuffer();
	StringBuffer CheckNote = new StringBuffer();
	StringBuffer CheckValue = new StringBuffer();
	StringBuffer CheckDate = new StringBuffer();
	StringBuffer CheckTime = new StringBuffer();
	StringBuffer IncongNote = new StringBuffer();
	CheckGubunMid.append("[");
	CheckGubunSm.append("[");
	CheckNote.append("[");
	CheckGubunMid.append("]");
	CheckGubunSm.append("]");
	CheckNote.append("]");
	CheckValue.append("[");
	CheckDate.append("[");
	CheckTime.append("[");
	IncongNote.append("[");
	CheckValue.append("]");
	CheckDate.append("]");
	CheckTime.append("]");
	IncongNote.append("]");

%>

<script type="text/javascript">	
	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 60; // 표1의 행 높이
	var DataGrid1_RowHeight_Etc = 30; // 표1의 체크리스트 말고 나머지 행 높이
	var DataGrid1_RowCount = 7; // 표1의 행개수(체크리스트)
	var DataGrid1_RowCount_Etc = 4; // 표1의 행개수(헤드부분)
	var DataGrid1_RowCount_Standard = 5; // 표1의 행개수(검사기준)
	var DataGrid1_RowCount_Improve = 4 ; // 표1의 행개수(개선조치내역)
	var DataGrid1_RowCount_Uniqueness = 4 // 표1의 행개수(특이사항)
	
	var DataGrid1_ColWidth = [80,180,260,130,130,130,130]; // 표1의 열 너비 배열
	var DataGrid1_ColWidth1st = DataGrid1_ColWidth-40; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = DataGrid1_ColWidth+40; // 표1의 2번째 열 너비
	var DataGrid1_DataCount = 1; // 표1의 열 개수
	var DataGrid1_HeightStart = HaedText_HeightEnd ; // 표1 시작위치(헤드텍스트영역 끝 높이)
	var DataGrid1_HeightEnd = DataGrid1_HeightStart   // 표1 끝나는 위치(시작위치 + 행개수 * 행높이)
							+ DataGrid1_RowCount * DataGrid1_RowHeight
							+ (DataGrid1_RowCount_Etc + DataGrid1_RowCount_Standard 
								+ DataGrid1_RowCount_Improve + DataGrid1_RowCount_Uniqueness) 
								* DataGrid1_RowHeight_Etc;
			
    $(document).ready(function () {
    	// 하단 부분 높이 추가(개선조치내역 데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	var rowcount_improve_temp = DataGrid1.getImproveLineCount(ctx_temp) ; // 표1의 하단부분 줄수(개선조치사항)
    	if(rowcount_improve_temp > DataGrid1_RowCount_Improve) {
    		DataGrid1_HeightEnd += (rowcount_improve_temp - DataGrid1_RowCount_Improve) * DataGrid1_RowHeight_Etc ;
    		DataGrid1_RowCount_Improve = rowcount_improve_temp;
    	}
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = 0; // 캔버스영역 너비
    	for(i=0; i<DataGrid1_ColWidth.length; i++) {
    		CanvasWidth += DataGrid1_ColWidth[i]; // 캔버스영역 너비(+표 헤드부분너비 총합)
    	}
    	CanvasWidth += CanvasPadding*2; // 캔버스영역 너비(+여백)
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var top_info = 'HS-PP-06-E' ;
			var middle_info = '미생물검사 결과서' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, (sx+ex)/2, sy+20, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			
			// 결재박스
			var col_approval_x = sx;
			for(i=0; i<DataGrid1_ColWidth.length-2; i++) {
				col_approval_x += DataGrid1_ColWidth[i];
			}
			var col_approval_x_center = (DataGrid1_ColWidth[5] + DataGrid1_ColWidth[6] - 30)/2;
			ctx_Box(ctx, col_approval_x, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			ctx_Line(ctx, col_approval_x+30, sy, col_approval_x+30, ey, 'black', 1); // 세로선
			ctx_Line(ctx, col_approval_x + 30 + col_approval_x_center, sy, 
					col_approval_x + 30 + col_approval_x_center, ey, 'black', 1); // 세로선
			ctx_Line(ctx, col_approval_x+30, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_Line(ctx, col_approval_x+30, ey-30, ex, ey-30, 'black', 1); // 가로선
			ctx_fillText(ctx, col_approval_x+15, sy+30, "결", 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, col_approval_x+15, ey-30, "재", 'black', vTextStyleBold, 'center','bottom');
			ctx_fillText(ctx, col_approval_x + 30 + col_approval_x_center/2, sy+15, 
					"작    성", 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_approval_x + 30 + col_approval_x_center*3/2, sy+15, 
					"승    인", 'black', vTextStyleBold, 'center','middle');
			var write_date = new Date("<%=WriteDate%>");
			var approval_date = new Date("<%=ApprovalDate%>");
			var str_write_date = ("0" + (write_date.getMonth() + 1)).slice(-2) 
						   + " / " + ("0" + write_date.getDate()).slice(-2);
			var str_approval_date = ("0" + (approval_date.getMonth() + 1)).slice(-2) 
							  + " / " + ("0" + approval_date.getDate()).slice(-2);
			ctx_fillText(ctx, col_approval_x + 30 + col_approval_x_center/2, ey-15, 
					str_write_date, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_approval_x + 30 + col_approval_x_center*3/2, ey-15, 
					str_approval_date, 'black', vTextStyleBold, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["분류","제품명(부위명)","이력번호","일반세균","대장균","Salmonella","결과"],
		col_head_width:DataGrid1_ColWidth, // [70,170,240,120,120,120,120]
		col_info_head:["담당자","시료 채취일","시료 발송일","검사의뢰 기관명","축산물 위생검사 기관번호","검사 판정일"],
		col_info_data:["<%=WritorMain%>","<%=SampleDate%>",
			"<%=SampleSendDate%>","<%=CustNm%>","<%=CustCd%>","<%=InsRsltDate%>"],
		col_check_data:<%=CheckData%>,
		col_standard_data:[["검사기준","1.원료육,완제품 2.청결도검사","일반세균","100000 CFU/㎠,g 이하",""],
						   ["검사기준","1.원료육,완제품 2.청결도검사","대장균","100 CFU/㎠,g 이하",""],
						   ["검사기준","1.원료육,완제품 2.청결도검사","Salmonella","음성","청결도검사는 제외"],
						   ["검사기준","낙하세균","일반세균","청결구역 30군 이하/ 15분",""],
						   ["검사기준","낙하세균","일반세균","일반구역 50군 이하/ 15분",""]],	
		col_improve_note:"<%=ImproveNote%>".replace(/(<br>|<br\/>|<br \/>)/g, '\r\n'),
		col_etc:["아래설비는 청결하고, 소모품은 적절하게 채워져 있으며 작동상태는 원할한가?","부적합 /이탈사항","개선조치 사항","결재","점검","승인"],
		col_incong_note:<%=IncongNote%>,
		col_check_value:<%=CheckValue%>, 
		col_check_date:<%=CheckDate%>,
		col_check_time:<%=CheckTime%>,
		col_approval_width:30, // '결재' 텍스트 들어가는 칸 너비
// 		col_incong_note_height: DataGrid1_RowHeight * DataGrid1_RowCount_Incong , //부적합이탈사항 높이
		col_improve_note_height: DataGrid1_RowHeight * DataGrid1_RowCount_Improve , //개선조치사항 높이(이부분에 세로선 안 그음)
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy+(DataGrid1_RowCount_Etc-1)*DataGrid1_RowHeight_Etc, 
					ex, sy+DataGrid1_RowCount_Etc*DataGrid1_RowHeight_Etc, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)

			// 상단 공통정보 부분
			var col_info_x_1st = sx + this.col_head_width[0] + this.col_head_width[1];
			var col_info_x_2nd = col_info_x_1st + this.col_head_width[2];
			var col_info_x_3rd = col_info_x_2nd + this.col_head_width[3] + this.col_head_width[4];
			var col_info_x_1st_center = col_info_x_1st - (this.col_head_width[0] + this.col_head_width[1])/2;
			var col_info_x_2nd_center = col_info_x_2nd - this.col_head_width[2]/2;
			var col_info_x_3rd_center = col_info_x_3rd - (this.col_head_width[3] + this.col_head_width[4])/2;
			var col_info_x_4th_center = col_info_x_3rd + (this.col_head_width[5] + this.col_head_width[6])/2;
			var col_info_y = sy;
			for(i=0; i<this.col_info_head.length/2; i++) {
				col_info_y += DataGrid1_RowHeight_Etc;
				var col_info_y_center = col_info_y - DataGrid1_RowHeight_Etc/2;
				ctx_Line(ctx, sx, col_info_y, ex, col_info_y, 'black', 1); // 가로선
				ctx_fillText(ctx, col_info_x_1st_center, col_info_y_center, this.col_info_head[i], 'black', vTextStyle, 'center','middle');
				ctx_fillText(ctx, col_info_x_2nd_center, col_info_y_center, this.col_info_data[i], 'black', vTextStyle, 'center','middle');
				ctx_fillText(ctx, col_info_x_3rd_center, col_info_y_center, this.col_info_head[i+3], 'black', vTextStyle, 'center','middle');
				ctx_fillText(ctx, col_info_x_4th_center, col_info_y_center, this.col_info_data[i+3], 'black', vTextStyle, 'center','middle');
			}
			ctx_Line(ctx, col_info_x_1st, sy, col_info_x_1st, col_info_y, 'black', 1); // 세로선
			ctx_Line(ctx, col_info_x_2nd-2, sy, col_info_x_2nd-2, col_info_y, 'black', 1); // 세로선(이중선)
			ctx_Line(ctx, col_info_x_2nd+2, sy, col_info_x_2nd+2, col_info_y, 'black', 1); // 세로선(이중선)
			ctx_Line(ctx, col_info_x_3rd, sy, col_info_x_3rd, col_info_y, 'black', 1); // 세로선
			
			// 헤드부분
			var col_head_y = col_info_y ;
			var col_head_y_center = col_head_y + (DataGrid1_RowHeight_Etc/2);
			var col_head_x = sx; // head의 x좌표
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 2); // head 가로선(굵게)
			ctx_Line(ctx, sx, col_head_y + DataGrid1_RowHeight_Etc, 
					ex, col_head_y + DataGrid1_RowHeight_Etc, 'black', 2); // head 가로선(굵게)
			for(i=0; i<this.col_head.length; i++) {
				col_head_x += this.col_head_width[i];
				var col_head_x_center = col_head_x-(this.col_head_width[i]/2);
				if(i==1) { // 2번째 세로선
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, ey, 'black', 1);
				} else if(i==3||i==4) { // 4,5번째 세로선
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, 
						ey-(DataGrid1_RowCount_Standard+DataGrid1_RowCount_Improve+DataGrid1_RowCount_Uniqueness)*DataGrid1_RowHeight_Etc,'black',1);
				} else {  // 나머지 세로선
					ctx_Line(ctx, col_head_x, col_head_y, col_head_x, 
						ey-(DataGrid1_RowCount_Improve+DataGrid1_RowCount_Uniqueness)*DataGrid1_RowHeight_Etc, 'black', 1);
				}
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
			}
			
			// 점검항목부분
			var col_check_y = col_head_y + DataGrid1_RowHeight_Etc;
			var col_check_y_1st_top = col_check_y ;
			for(i=0; i<this.col_check_data.length; i++) {
				col_check_y += DataGrid1_RowHeight;
				if(i<this.col_check_data.length-1){
					if(this.col_check_data[i][0]!=this.col_check_data[i+1][0]) { // 분류가 다음꺼와 다를때
						ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 1); // 가로선
					} else { // 분류가 다음꺼와 같을때
						ctx_Line(ctx, sx + this.col_head_width[0], col_check_y, ex, col_check_y, 'black', 1); // 가로선
					}
				} else {
					ctx_Line(ctx, sx, col_check_y, ex, col_check_y, 'black', 2); // 가로선(굵게)
				}
				var col_check_y_center = col_check_y - DataGrid1_RowHeight/2;
				var col_check_x = sx;
				// 데이터 쓰기
				for(j=0; j<this.col_check_data[i].length; j++) {
					col_check_x += this.col_head_width[j];
					var col_check_x_center = col_check_x - this.col_head_width[j]/2;
					if(j==0) { // 분류 데이터 줄바꿈, 세로칸 합치기
						var col_check_y_1st_center = col_check_y - (col_check_y - col_check_y_1st_top)/2;
						if(i<this.col_check_data.length-1){
							if(this.col_check_data[i][j]!=this.col_check_data[i+1][j]) { // 분류가 다음꺼와 다를때만 데이터 쓰기
								ctx_wrapText_space(ctx, col_check_x_center, col_check_y_1st_center, this.col_check_data[i][j],
										'black', vTextStyle, 'center','middle', this.col_head_width[j]-20, DataGrid1_RowHeight/2);
								col_check_y_1st_top = col_check_y;
							}
						} else { // 마지막줄은 조건없이 데이터쓰기
							ctx_wrapText_space(ctx, col_check_x_center, col_check_y_1st_center, this.col_check_data[i][j],
									'black', vTextStyle, 'center','middle', this.col_head_width[j]-20, DataGrid1_RowHeight/2);
						}
					} else if(j==1) { // 제품명 데이터 줄바꿈
						ctx_wrapText_space(ctx, col_check_x_center, col_check_y_center, this.col_check_data[i][j],
								'black', vTextStyle, 'center','middle', this.col_head_width[j]-20, DataGrid1_RowHeight/2);
					
					} else if(j==this.col_check_data[i].length-1) { // 결과부분 체크박스
						ctx_fillText(ctx, col_check_x - this.col_head_width[j]*3/4, col_check_y_center - DataGrid1_RowHeight/4, 
								"□ 적합", 'black', vTextStyle, 'left','middle');
						ctx_fillText(ctx, col_check_x - this.col_head_width[j]*3/4, col_check_y_center + DataGrid1_RowHeight/4, 
								"□부적합", 'black', vTextStyle, 'left','middle');
						if(this.col_check_data[i][j] == "Y")
							ctx_fillText(ctx, col_check_x - this.col_head_width[j]*3/4 + 2, col_check_y_center - DataGrid1_RowHeight/4 - 2, 
									"✓", 'black', vTextStyleBold, 'left','middle');
						else if(this.col_check_data[i][j] == "N")
							ctx_fillText(ctx, col_check_x - this.col_head_width[j]*3/4 + 2, col_check_y_center + DataGrid1_RowHeight/4 - 2, 
									"✓", 'black', vTextStyleBold, 'left','middle');
					} else {
						ctx_fillText(ctx, col_check_x_center, col_check_y_center, 
								this.col_check_data[i][j], 'black', vTextStyle, 'center','middle');
					}
				}
			}
			
			// 검사기준
			var col_standard_y = col_check_y;
			var col_standard_y_1st_top = col_standard_y ;
			var col_standard_y_2nd_top = col_standard_y ;
			for(i=0; i<this.col_standard_data.length; i++) {
				col_standard_y += DataGrid1_RowHeight_Etc;
				var col_standard_y_center = col_standard_y - DataGrid1_RowHeight_Etc/2;
				var col_standard_x = sx;
				var col_standard_x_center = sx;
				// 글자 쓰기
				if(i==this.col_standard_data.length-1) { // '검사기준' 텍스트는 마지막에 한번만
					ctx_Line(ctx, sx, col_standard_y, ex, col_standard_y, 'black', 2); // 가로선(굵게)
					// 1번째 열
					col_standard_x += this.col_head_width[0];
					col_standard_x_center = col_standard_x - this.col_head_width[0]/2;
					var col_standard_y_1st_center = col_standard_y - (col_standard_y - col_standard_y_1st_top)/2;
					ctx_wrapText(ctx, col_standard_x_center, col_standard_y_1st_center, this.col_standard_data[i][0],
							'black', vTextStyle, 'center','middle', this.col_head_width[0]-40, DataGrid1_RowHeight_Etc);
					// 2번째 열
					col_standard_x += this.col_head_width[1];
					col_standard_x_center = col_standard_x - this.col_head_width[1]/2;
					var col_standard_y_2nd_center = col_standard_y - (col_standard_y - col_standard_y_2nd_top)/2;
					ctx_wrapText_space(ctx, col_standard_x_center, col_standard_y_2nd_center, this.col_standard_data[i][1],
							'black', vTextStyle, 'center','middle', this.col_head_width[1]-20, DataGrid1_RowHeight_Etc);
				} else if(this.col_standard_data[i][1]!=this.col_standard_data[i+1][1]) { // 2번째열 데이터 - 다음거와 다르면 쓰기
					ctx_Line(ctx, sx + this.col_head_width[0], col_standard_y, ex, col_standard_y, 'black', 1); // 가로선
					// 2번째 열
					col_standard_x += this.col_head_width[0] + this.col_head_width[1];
					col_standard_x_center = col_standard_x - this.col_head_width[1]/2;
					var col_standard_y_2nd_center = col_standard_y - (col_standard_y - col_standard_y_2nd_top)/2;
					ctx_wrapText_space(ctx, col_standard_x_center, col_standard_y_2nd_center, this.col_standard_data[i][1],
							'black', vTextStyle, 'center','middle', this.col_head_width[1]-20, DataGrid1_RowHeight_Etc);
					col_standard_y_2nd_top = col_standard_y;
				} else {
					ctx_Line(ctx, sx + this.col_head_width[0] + this.col_head_width[1], col_standard_y, 
							ex, col_standard_y, 'black', 1); // 가로선
					col_standard_x += this.col_head_width[0] + this.col_head_width[1];
				}
				// 3번째 열
				col_standard_x += this.col_head_width[2];
				col_standard_x_center = col_standard_x - this.col_head_width[2]/2;
				ctx_fillText(ctx, col_standard_x_center, col_standard_y_center, 
					this.col_standard_data[i][2], 'black', vTextStyle, 'center','middle');
				// 4번째 열
				col_standard_x += this.col_head_width[3] + this.col_head_width[4] + this.col_head_width[5];
				col_standard_x_center = col_standard_x 
									  - (this.col_head_width[3] + this.col_head_width[4] + this.col_head_width[5])/2;
				ctx_fillText(ctx, col_standard_x_center, col_standard_y_center, 
						this.col_standard_data[i][3], 'black', vTextStyle, 'center','middle');
				// 5번째 열
				col_standard_x += this.col_head_width[6];
				col_standard_x_center = col_standard_x - this.col_head_width[6]/2;
				ctx_fillText(ctx, col_standard_x_center, col_standard_y_center, 
						this.col_standard_data[i][4], 'black', vTextStyle, 'center','middle');
			}
		
			// 개선조치내역
			var col_improve_y = col_standard_y;
			var col_improve_y_top = col_improve_y;
			var col_improve_x = sx + this.col_head_width[0] + this.col_head_width[1];
			var col_improve_x_center = col_improve_x - (this.col_head_width[0] + this.col_head_width[1])/2;
			col_improve_y += DataGrid1_RowHeight_Etc * DataGrid1_RowCount_Improve;
			ctx_Line(ctx, sx, col_improve_y, ex, col_improve_y, 'black', 2); // 가로선(굵게)
			ctx_wrapText(ctx, col_improve_x+10, col_improve_y_top+7, this.col_improve_note,
					'black', vTextStyle, 'left','top', this.col_head_width[0]-20, DataGrid1_RowHeight_Etc/2);
			var col_improve_y_1st_center = col_improve_y - (col_improve_y-col_improve_y_top)/2;
			ctx_fillText(ctx, col_improve_x_center, col_improve_y_1st_center, "개선조치 내역", 'black', vTextStyle, 'center','middle');
			
			// 특이사항
			var col_uniqueness_y = col_improve_y;
			var col_uniqueness_y_top = col_uniqueness_y;
			var col_uniqueness_str = ["1. 시료채취는 선행요건프로그램 [검사관리 기준서]의 6.관리기준에 따른다.",
									  "2. 시료채취 시 의뢰기관 담당자의 샘플채취를 품질관리팀이 보조한다.",
									  "3. 검사의뢰 주기 : 월 1회 이상",
									  "4. 성적서 확인 후, 적합 / 부적합에 체크 한다."];
			var col_uniqueness_x = sx + this.col_head_width[0] + this.col_head_width[1];
			var col_uniqueness_x_center = col_uniqueness_x - (this.col_head_width[0] + this.col_head_width[1])/2;
			for(i=0; i<col_uniqueness_str.length; i++) {
				col_uniqueness_y += DataGrid1_RowHeight_Etc;
				var col_uniqueness_y_center = col_uniqueness_y - DataGrid1_RowHeight_Etc/2;
				ctx_fillText(ctx, col_uniqueness_x+10, col_uniqueness_y_center, col_uniqueness_str[i], 'black', vTextStyle, 'left','middle');
			}
			var col_uniqueness_y_1st_center = col_uniqueness_y - (col_uniqueness_y-col_uniqueness_y_top)/2;
			ctx_fillText(ctx, col_uniqueness_x_center, col_uniqueness_y_1st_center, "특이 사항", 'black', vTextStyle, 'center','middle');
			
		}, // drawGrid function end
		
		getImproveLineCount: function(ctx) { // 표1의 하단부분 줄수(부적합/이탈사항, 개선조치사항)
			ctx.font = vTextStyle;
		
			var col_improve_width = this.col_head_width[2] + this.col_head_width[3] + this.col_head_width[4] 
								  + this.col_head_width[5] + this.col_head_width[6] ;
		
			return ctx_wrapText_lineCount(ctx, this.col_improve_note, col_improve_width-20); ;
		}
		
	} ; // DataGrid1(표1) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>