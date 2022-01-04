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
조도 점검표 canvas (S838S020300_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_CHECK_DATE="",GV_CHECK_TIME="" ;

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");	
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME="";
	else
		GV_CHECK_TIME = request.getParameter("check_time");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);

	TableModel = new DoyosaeTableModel("M838S020300E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 점검일자(기간), 점검자(정), 점검자(부), 작성자, 승인자, 작성일, 승인일
	String CheckDuration = ""; 
	String WritorMain = ""; 
	String WritorSecond = "" ;
	String WriteDate = "";
	String Approval = "";
	String ApprovalDate = "";
	
	
	if(RowCount>0) {
		CheckDuration = TableModel.getValueAt(0, 0).toString().trim();
		WritorMain = TableModel.getValueAt(0, 15).toString().trim();
		WritorSecond = TableModel.getValueAt(0, 16).toString().trim();
		Approval = TableModel.getValueAt(0, 17).toString().trim(); 
		WriteDate = TableModel.getValueAt(0, 21).toString().trim();
		ApprovalDate = TableModel.getValueAt(0, 22).toString().trim();
		
	}
	
	// 구분, 점검항목
	String GV_CHECK_GUBUN = "";
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S020300E134", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(15)
	
	StringBuffer CheckGubunMid = new StringBuffer();
	StringBuffer CheckGubunSm = new StringBuffer();
	StringBuffer LuxCheck = new StringBuffer();
	StringBuffer LuxCheckResult = new StringBuffer();
	StringBuffer ImproveNote = new StringBuffer();
	StringBuffer CheckDate = new StringBuffer();
	StringBuffer CheckTime = new StringBuffer();
	
	CheckGubunMid.append("[");
	CheckGubunSm.append("[");
	LuxCheck.append("[");
	LuxCheckResult.append("[");
	ImproveNote.append("[");
	CheckDate.append("[");
	CheckTime.append("[");
	if(RowCount>=CheckCount) {
		for(int i=0; i<CheckCount; i++) {
			if(i==CheckCount-1) {
				CheckGubunMid.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" );
				CheckGubunSm.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" );
				LuxCheck.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" );
				LuxCheckResult.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" );
				ImproveNote.append( "'" + TableModel.getValueAt(i, 17).toString().trim() + "'" );
				CheckDate.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" );
				CheckTime.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" );
			} else {
				CheckGubunMid.append( "'" + TableModel.getValueAt(i, 3).toString().trim() + "'" + "," );
				CheckGubunSm.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," );
				LuxCheck.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," );
				LuxCheckResult.append( "'" + TableModel.getValueAt(i, 20).toString().trim() + "'" + "," );
				ImproveNote.append( "'" + TableModel.getValueAt(i, 17).toString().trim() + "'" + "," );
				CheckDate.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "," );
				CheckTime.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," );
			}
		}
	}
	CheckGubunMid.append("]");
	CheckGubunSm.append("]");
	LuxCheck.append("]");
	LuxCheckResult.append("]");
	ImproveNote.append("]");
	CheckDate.append("]");
	CheckTime.append("]");
	
	// 조도기준, 점검결과, 판정, 개선조치
	int CheckRow = RowCount / CheckCount ;
	StringBuffer LuxStandard = new StringBuffer();

	
	LuxStandard.append("[");	
	if(RowCount>=CheckCount) {
		for(int i=0; i<CheckRow; i++) {
			System.out.println("CheckRow : " + CheckRow);
			for(int j=0; j<CheckCount; j++) {
				int CheckIndex = i * CheckCount +j;
				if(j==CheckCount-1) {
					LuxStandard.append( "'" + TableModel.getValueAt(CheckIndex, 19).toString().trim() + "'" );
				} else {
					LuxStandard.append( "'" + TableModel.getValueAt(CheckIndex, 19).toString().trim() + "'" + "," );
				}
			}
			if(i==CheckRow-1) {
			} else {
			}
		}
	}
	LuxStandard.append("]");


%>

<script type="text/javascript">	
	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 점검관련사항 정의
	var CheckText_HeightStart = HaedText_HeightEnd ;
	var CheckText_HeightEnd = CheckText_HeightStart + 60; // 점검관련사항 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 18px 맑은고딕';
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 30; // 표1의 1번째 행 높이
	var DataGrid1_RowCount = 15; // 표1의 행 개수
	var DataGrid1_RowCount_Extra = 2; // 표1의 늘릴 행개수(헤드부분, 안내문, 두줄짜리 등등...)
	var DataGrid1_RowCount_LuxStandard = 0 ; // 표1의 하단부분 줄수(부적합/이탈사항)
	var DataGrid1_RowCount_Improve = 0 // 표1의 하단부분 줄수(개선조치사항)
	
	var DataGrid1_ColWidth = 30; // 표1의 열 너비
	var DataGrid1_ColWidth1st = DataGrid1_ColWidth-40; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = DataGrid1_ColWidth+40; // 표1의 2번째 열 너비
<%-- 	var DataGrid1_DataCount = <%=CheckRow%>; // 표1의 열 개수 --%>
	var DataGrid1_DataCount = 50; // 표1의 열 개수
	var DataGrid1_HeightStart = CheckText_HeightEnd ; // 표1 시작위치(헤드텍스트영역 끝 높이)
	// 표1 끝나는 위치(시작위치 + 행개수 * 행높이)
	console.log("DataGrid1_HeightStart : "+ DataGrid1_HeightStart);
	
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + DataGrid1_RowCount * DataGrid1_RowHeight-180;
	
    $(document).ready(function () {    	
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
//    	DataGrid1_RowCount_LuxStandard = DataGrid1.getLuxStandardLineCount(ctx_temp) ; // 표1의 하단부분 줄수(조도기준)
		DataGrid1_RowCount_LuxStandard = 30; 

    	//DataGrid1_RowCount_Improve = DataGrid1.getImproveLineCount(ctx_temp) ; // 표1의 하단부분 줄수(개선조치사항)
    	DataGrid1_RowCount_Improve = 5;
    	DataGrid1_HeightEnd += (DataGrid1_RowCount_LuxStandard + DataGrid1_RowCount_Improve) * DataGrid1_RowHeight ;
    	
    	DataGrid1.col_lux_standard_height = DataGrid1_RowHeight * DataGrid1_RowCount_LuxStandard ; //조도기준 높이
    	DataGrid1.col_improve_note_height = DataGrid1_RowHeight * DataGrid1_RowCount_Improve ; //개선조치사항 높이(이부분에 세로선 안 그음)
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1.col_head_width[0] + DataGrid1.col_head_width[1] 
    					+ DataGrid1.col_head_width[2] + DataGrid1.col_head_width[3] 
    					+ DataGrid1.col_head_width[4]; // 캔버스영역 너비
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
 	    HeadText.drawText(ctx, pointSX,  pointSY + HeadText_HeightStart,  pointEX, pointSY + HaedText_HeightEnd);
	    CheckText.drawText(ctx, pointSX, pointSY + CheckText_HeightStart, pointEX, pointSY + CheckText_HeightEnd);
 		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HS-PP-01-C 조도 점검표' ;
			var middle_info = '조 도  점 검 표' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');

			var col_approval_x_start = 2*(ex/3)+ex/7;
			var col_approval_x_end = col_approval_x_start;
			var col_approval_y_start = sy + 15;
			var col_approval_y_end = ey;
			var col_approval_x_1st_center = col_approval_x_start + (ex - col_approval_x_start)/2;
			var col_approval_x_2nd_center = col_approval_x_1st_center;
			var col_approval_y_1st_center = sy + 15;
			var col_approval_y_2nd_center = ey;
			var cut = ex/4;
			// 태양 점검표
			ctx_Line(ctx, sx+cut, sy+15, sx+cut, ey, 'black', 1);
			ctx_Line(ctx, sx, sy+65, sx+cut, sy+65, 'black', 1);
			ctx_fillText(ctx, sx+20, sy+35, "제정일자"+ ' : 2020.10.10.', 'black', 'bold 18px 맑은고딕', 'left','center');
			ctx_fillText(ctx, sx+20, sy+85, "개정일자"+ ' : 2020.10.10.', 'black', 'bold 18px 맑은고딕', 'left','center');
			
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
			
			
			// 작성, 승인 서명부분
			ctx_fillText(ctx, col_approval_x_1st_upper +37, col_approval_y_1st_upper +20, "<%=WritorMain%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +37, col_approval_y_1st_upper +20, "<%=Approval%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			
			// write_approval, haccp_approval
			var write_duration = '<%=WriteDate%>'.split('-');
			var write_date = write_duration[1] +"/"+ write_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_down +5, write_date, 'blue', 'bold 18px 맑은고딕', 'center','top');
			var approval_duration = '<%=ApprovalDate%>'.split('-');
			var approval_date = approval_duration[1] +"/"+ approval_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_down +5, approval_date, 'blue', 'bold 18px 맑은고딕', 'center','top');

		} // HeadText.drawText function end
	} ;

	// 점검관련사항 정의
	var CheckText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var cut = ex/4;
			var check_date = '점검일자';
			var check_duration = '<%=CheckDuration%>'.split('-');			
			var check_date_note = blank_tab + check_duration[0] + '년 ' + check_duration[1] + '월 ' + check_duration[2] + '일 '; 
			ctx_Line(ctx, sx+cut, sy, sx+cut, ey, 'black', 1);
			ctx_fillText(ctx, sx+cut*0.5, sy-(CheckText_HeightStart - CheckText_HeightEnd)/2 , check_date, 'black', 'bold 18px 맑은고딕', 'center','middle');			
			ctx_fillText(ctx, sx+cut+20, sy-(CheckText_HeightStart - CheckText_HeightEnd)/2 , check_date_note, 'black', '18px 맑은고딕', 'start','middle');					
		}		
		
	}
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["작업장 구분", "조도기준(이상)", "작업장명", "점검결과", "판정(적/부)"],
		col_head_width:[148, 264, 148, 150, 190],
		col_check_gubun_mid:<%=CheckGubunMid%>,
		col_check_gubun_sm:<%=CheckGubunSm%>,
		col_luxStandard:<%=LuxStandard%>,
		col_luxCheck:<%=LuxCheck%>,
		col_luxCheckResult:<%=LuxCheckResult%>,
		col_improveNote:<%=ImproveNote%>,
		col_check_date:<%=CheckDate%>,
		col_check_time:<%=CheckTime%>,
		col_approval_width:5, // '결재' 텍스트 들어가는 칸 너비
		col_lux_standard_height: DataGrid1_RowHeight * DataGrid1_RowCount_LuxStandard , //조도기준 높이
		col_improve_note_height: DataGrid1_RowHeight * DataGrid1_RowCount_Improve , //개선조치사항 높이(이부분에 세로선 안 그음)
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st, '#cccccc'); // 상단 구분명 배경(회색)
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			
			
			var col_head_y_center = col_head_y-(DataGrid1_RowHeight1st/2);
			var col_head_x = sx; // head의 x좌표
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // head 가로선(굵게)
			var col_check_note_end;
			var cut;
			var divide;
			// 테이블 세로선
			for(i=0; i<this.col_head.length; i++) {
				col_head_x += this.col_head_width[i];
				var col_head_x_center = col_head_x-(this.col_head_width[i]/2);
				//col_check_note_end = ey-this.col_improve_note_height*2;
				col_check_note_end = sy + col_head_y + DataGrid1_RowHeight1st*this.col_check_gubun_mid.length;
				
				if(i==this.col_head.length-1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, col_check_note_end, 'black', 1); 
 					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==0) {
					ctx_Line(ctx, col_head_x, sy , col_head_x, col_check_note_end, 'black', 1); 
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, col_check_note_end, 'black', 1); 
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==2) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, col_check_note_end, 'black', 1); 
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==3) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, col_check_note_end, 'black', 1); 
					ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 'black', vTextStyleBold, 'center','middle');
				} 
				
			}
			
			// 데이터 및 구분선

			var equal = 0;
			for(i = 0; i< this.col_check_gubun_mid.length; i++){
				var col_mid_x = this.col_head_width[0]/2;
				var col_sm_x = this.col_head_width[0] + this.col_head_width[1]/2;
				var col_lusStan_x = this.col_head_width[0] + this.col_head_width[1] + this.col_head_width[2]/2;
				var col_luxChk_x = this.col_head_width[0] + this.col_head_width[1] + this.col_head_width[2] + this.col_head_width[3]/2;
				var col_luxRes_x = this.col_head_width[0] + this.col_head_width[1] + this.col_head_width[2] + this.col_head_width[3] + this.col_head_width[4]/2;				
				//console.log(this.col_check_gubun_mid[i], this.col_luxStandard[i], this.col_check_gubun_sm[i], this.col_luxCheck[i], this.col_luxCheckResult[i]);
							
				cut = (col_check_note_end - col_head_y)/this.col_check_gubun_mid.length ;
				divide = col_head_y + (i+1)*cut;								
				
				// 작업장명 겹칠때 하나로 통합하는 조건문
				if(this.col_check_gubun_mid[i] == this.col_check_gubun_mid[i+1]){					
					equal = equal+1;
					//console.log("if : "+ equal);
					var equal_line = ex - (this.col_head_width[1] + this.col_head_width[2] + this.col_head_width[3] + this.col_head_width[4]);
					ctx_Line(ctx, equal_line+21, divide, ex, divide, 'black', 1);
				} else{
					// 작업장명 2개 이상일때 작업장명 위치조정
					if(equal > 0){
						ctx_fillText(ctx, sx+col_mid_x, divide-(1+equal)*(cut/2), this.col_check_gubun_mid[i], 'black', vTextStyleBold, 'center','middle');	
					} else {
						ctx_fillText(ctx, sx+col_mid_x, divide-cut/2, this.col_check_gubun_mid[i], 'black', vTextStyleBold, 'center','middle');
					}
					ctx_Line(ctx, sx, divide, ex, divide, 'black', 1);
					
					equal = 0;
					//console.log("else : "+ equal);
				}				

				ctx_fillText(ctx, sx+col_sm_x-40, divide-cut/2, this.col_luxStandard[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+col_sm_x+20, divide-cut/2, 'Lux 이상', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+col_lusStan_x, divide-cut/2, this.col_check_gubun_sm[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+col_luxChk_x+20, divide-cut/2, 'Lux', 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+col_luxChk_x-20, divide-cut/2, this.col_luxCheck[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+col_luxRes_x-10, divide-cut/2, '□ 적합 / □ 부적합', 'black', vTextStyleBold, 'center','middle');
				if(this.col_luxCheckResult[i] == 'Y'){
					ctx_fillText(ctx, sx+col_luxRes_x-80, divide-cut/2-1, '✓', 'black', vTextStyleBold, 'center','middle');
				} else{
					ctx_fillText(ctx, sx+col_luxRes_x, divide-cut/2-1, '✓', 'black', vTextStyleBold, 'center','middle');
				}
				
			}
			// 이탈시 개선조치 내역, 점검방법
			var cut_4 = ex/4;
			var blank_tab = '    '; // 4칸 공백
			var check_duration = '<%=CheckDuration%>';			
			ctx_Line(ctx, sx, col_check_note_end, ex, col_check_note_end, 'black', 1);
			ctx_Line(ctx, sx, col_check_note_end+40, ex, col_check_note_end+40, 'black', 1);
			ctx_Line(ctx, sx+50, col_check_note_end+80, ex, col_check_note_end+80, 'black', 1);
			ctx_Line(ctx, sx+cut_4*2, col_check_note_end, sx+cut_4*2, col_check_note_end+40, 'black', 1);
			ctx_fillText(ctx, sx+cut_4*1-50, col_check_note_end+20, '점검주기', 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut_4*3-50, col_check_note_end+20, '1월  / 1회', 'black', vTextStyleBold, 'left','middle');
			ctx_wrapText(ctx, sx+25, col_check_note_end+120, '이상발생내역', 'black', vTextStyleBold, 'center','middle', 20, 20);
			var check_method_start_y = col_check_note_end +(ey-col_check_note_end)/2;
			ctx_Line(ctx, sx+50, col_check_note_end+40, sx+50, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+60, col_check_note_end+60, '발생일시', 'black', vTextStyleBold, 'left','middle');

			ctx_Line(ctx, sx+140, col_check_note_end+40, sx+140, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+145, col_check_note_end+60, '발생장소', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut_4, col_check_note_end+40, sx+cut_4, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+cut_4+50, col_check_note_end+60, '이상발생 내역', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut_4*2, col_check_note_end+40, sx+cut_4*2, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+cut_4*2+20, col_check_note_end+60, '조치실시', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut_4*3, col_check_note_end+40, sx+cut_4*3, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+cut_4*2.5+20, col_check_note_end+60, '조치결과', 'black', vTextStyleBold, 'left','middle');	
			ctx_Line(ctx, sx+cut_4*2.5, col_check_note_end+40, sx+cut_4*2.5, check_method_start_y, 'black', 1);		
			ctx_fillText(ctx, sx+cut_4*3+30, col_check_note_end+60, '조치자', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut_4*3, col_check_note_end+40, sx+cut_4*3, check_method_start_y, 'black', 1);
			ctx_fillText(ctx, sx+cut_4*3.5+30, col_check_note_end+60, '확인', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut_4*3.5, col_check_note_end+40, sx+cut_4*3.5, check_method_start_y, 'black', 1);	
			
			
			var impArray = new Array();
			if(this.col_improveNote[0] != ''){
				ctx_fillText(ctx, sx+55, col_check_note_end+130, check_duration, 'black', vTextStyle, 'left','middle'); 	// 발생일시 data
				ctx_wrapText(ctx, sx+cut_4-60, col_check_note_end+130, col_check_gubun_mid, 'black', vTextStyle, 'left','middle', 80, 20); // 발생장소
				ctx_fillText(ctx, sx+cut_4+100, col_check_note_end+130, col_luxStandard + ' / ' + col_luxCheck, 'black', vTextStyle, 'left','middle'); 	
				ctx_fillText(ctx, sx+cut_4*2+40, col_check_note_end+130, col_improveNote[0] , 'black', vTextStyle, 'left','middle'); // 개선조치 data
				ctx_fillText(ctx, sx+cut_4*2.5+40, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 조치결과
				ctx_fillText(ctx, sx+cut_4*3+40, col_check_note_end+130, '<%=WritorMain%>', 'black', vTextStyle, 'left','middle'); // 조치자
				ctx_fillText(ctx, sx+cut_4*3.5+40, col_check_note_end+130, '<%=Approval%>', 'black', vTextStyle, 'left','middle'); // 확인
			} else {
				ctx_fillText(ctx, sx+80, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 발생일시
				ctx_fillText(ctx, sx+cut_4-60, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); 	// 발생장소
				ctx_fillText(ctx, sx+cut_4+100, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 이상발생 내역
				ctx_fillText(ctx, sx+cut_4*2+40, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 개선조치 data
				ctx_fillText(ctx, sx+cut_4*2.5+40, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 조치결과
				ctx_fillText(ctx, sx+cut_4*3+40, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 조치자
				ctx_fillText(ctx, sx+cut_4*3.5+40, col_check_note_end+130, '없음', 'black', vTextStyle, 'left','middle'); // 확인
			}
			ctx_Line(ctx, sx, check_method_start_y, ex, col_check_note_end +(ey-col_check_note_end)/2, 'black', 1);
			ctx_fillText(ctx, sx+10, col_check_note_end +(ey-col_check_note_end)/2+20, '<점검방법>', 'black', vTextStyleBold, 'start','middle');
			var checkMethod1 = '작업장(가공실, 포장실) : 작업이 이루어지는 작업대 위에서 조도를 측정한다.';
			var checkMethod2 = '제품보관창고는 바닥으로부터 1M 지점에서 조도를 측정한다.';
			var checkMethod3 = '조도측정은 조명과 조명사이의 제일 어두운 곳에서 측정한다.';
			var checkMethod_nextline = col_check_note_end +(ey-col_check_note_end)/2+20;
			ctx_fillText(ctx, sx+10, checkMethod_nextline, '<점검방법>', 'black', vTextStyleBold, 'start','middle');
			ctx_fillText(ctx, sx+10, checkMethod_nextline+25, checkMethod1, 'black', vTextStyle, 'start','middle');
			ctx_fillText(ctx, sx+10, checkMethod_nextline+50, checkMethod2, 'black', vTextStyle, 'start','middle');
			ctx_fillText(ctx, sx+10, checkMethod_nextline+75, checkMethod3, 'black', vTextStyle, 'start','middle');
			
		}, // drawGrid function end	
		
		getLuxStandardLineCount: function(ctx) { // 표1의 하단부분 줄수(부적합/이탈사항, 개선조치사항)
			ctx.font = vTextStyleBold;
		
			var col_lux_standard_width = this.col_head_width[2] - this.col_approval_width ;
			var col_lux_standard_lineCount = 0;
		
			for(i=0; i<this.col_luxStandard.length; i++) {
				if(this.col_luxStandard[i].length > 0) { // 조도기준이 있을때만
					var lux_standard = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_luxStandard[i];
					col_lux_standard_lineCount += ctx_wrapText_lineCount(ctx, lux_standard, col_lux_standard_width-10);
				}
			}
			
			if(col_lux_standard_lineCount < 4) col_lux_standard_lineCount = 4; // 부적합/이탈사항 최소 4줄
			
			return col_lux_standard_lineCount ;
		},
		
		getImproveLineCount: function(ctx) { // 표1의 하단부분 줄수(이탈시 개선조치 내역, 점검방법)
			ctx.font = vTextStyleBold;
			var col_improve_width = this.col_head_width[2] + this.col_head_width[3] + DataGrid1_ColWidth * DataGrid1_DataCount ;
			
			console.log("col_improve_width : "+ col_improve_width);
			var col_improve_lineCount = 0;
		
			for(i=0; i<this.col_improveNote.length; i++) {
				if(this.col_improveNote[i].length > 0) { // 이탈시 개선조치 내역이 있을때만
					var improve_note = this.col_check_date[i] + " " + this.col_check_time[i] + " - " + this.col_improveNote[i];
					
					// 너비당 줄수
					col_improve_lineCount += ctx_wrapText_lineCount(ctx, improve_note, col_improve_width-10);
				}
			}
			
			if(col_improve_lineCount < 4) col_improve_lineCount = 4; // 점검방법

			return col_improve_lineCount ;
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