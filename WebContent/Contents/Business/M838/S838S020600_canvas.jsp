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
이물관리 점검표 canvas (S838S020600_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_INCOG_DATE_START="", GV_INCOG_DATE_END="", 
		   GV_CHECK_DATE="", GV_CHECK_GUBUN = "";

	if(request.getParameter("check_date_start")== null)
		GV_INCOG_DATE_START = "";
	else
		GV_INCOG_DATE_START = request.getParameter("check_date_start");
	
	if(request.getParameter("check_date_end")== null)
		GV_INCOG_DATE_END = "";
	else
		GV_INCOG_DATE_END = request.getParameter("check_date_end");

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	if (request.getParameter("check_gubun")== null) {
		GV_CHECK_GUBUN = "";
	} else {
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("check_date", GV_CHECK_DATE);
	jArray.put("check_date_start", GV_INCOG_DATE_START);
	jArray.put("check_date_end", GV_INCOG_DATE_END);
	jArray.put("check_gubun", GV_CHECK_GUBUN);
	
	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableModel2;
	
	TableModel 	= new DoyosaeTableModel("M838S020600E144", jArray);
	TableModel2 = new DoyosaeTableModel("M838S020600E154", jArray);
	
	int RowCount = TableModel.getRowCount();
	int RowCount2 = TableModel2.getRowCount();
	
	String CheckDate="", WriteDate="", ApprovalDate="", WorkingProgress="",
		   DeviationsSubject="", Improvement="", Bigo="";
	
	if(RowCount>0) {
		CheckDate=TableModel.getValueAt(0, 0).toString().trim() ;
		WriteDate=TableModel.getValueAt(0, 2).toString().trim() ;
		ApprovalDate=TableModel.getValueAt(0, 3).toString().trim() ;
		DeviationsSubject=TableModel.getValueAt(0, 11).toString().trim() ;
		Improvement=TableModel.getValueAt(0, 12).toString().trim() ;
		Bigo=TableModel.getValueAt(0, 14).toString().trim() ;
	}
	
	StringBuffer DataArray = new StringBuffer();
	StringBuffer DataArray2 = new StringBuffer();
	
	DataArray.append("[");
	for(int i = 0; i < RowCount; i++) {
		DataArray.append("[");
		DataArray.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
		DataArray.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," ); // inspection_point(check_gubun_sm)
		DataArray.append( "'" + TableModel.getValueAt(i, 6).toString().trim() + "'" + "," ); // code_name(checklist_gubun_mid)
		DataArray.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'" + "," ); // latent_foreign_possiblity(check_note)
		DataArray.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "," ); // inspection_result
		DataArray.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" + "," ); // deviations_subject
		DataArray.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," ); // improvement
		DataArray.append( "'" + TableModel.getValueAt(i, 14).toString().trim() + "'" + "," ); // bigo
		DataArray.append( "'" + TableModel.getValueAt(i, 15).toString().trim() + "'" + "," ); // checklist_seq
		DataArray.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "" ); // check_date
		if(i == RowCount - 1) DataArray.append("]");
		else DataArray.append("],");
	}
	DataArray.append("]");
	
	DataArray2.append("[");
	for(int i = 0; i < RowCount2; i++) {
		DataArray2.append("[");
		DataArray2.append( "'" + TableModel2.getValueAt(i, 0).toString().trim() + "'" + "," ); 
		DataArray2.append( "'" + TableModel2.getValueAt(i, 1).toString().trim() + "'" + "" ); 
		if(i == RowCount - 1) DataArray2.append("]");
		else DataArray2.append("],");
	}
	DataArray2.append("]");
%>

<script type="text/javascript">
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight1st = 75;
	var DataGrid1_RowHeight = 40; 				// 표1의 행 높이
	var DataGrid1_RowCount = 21; 				// 체크리스트행 개수
	var DataGrid1_Width = 0; 					// doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid1_HeightEnd = HaedText_HeightEnd + DataGrid1_RowHeight1st 
							+ (DataGrid1_RowCount * DataGrid1_RowHeight) // 표1 높이(상단텍스트 끝 위치 + (행개수 * 행높이)
							+ 60; 										 // 확인란, 범례란
							
	// 표2 영역
	var DataGrid2_RowHeight1st = 30; // 표2의 첫번째 행 높이
	var DataGrid2_RowHeight = 25; 	 // 표2의 데이터 행 높이
	var DataGrid2_HeightStart = DataGrid1_HeightEnd ; // 표2 시작위치(표1영역 끝 높이)
	var DataGrid2_HeightEnd = DataGrid2_HeightStart + DataGrid2_RowHeight1st ; // 표2 끝나는 위치(시작위치 + 첫번째 행높이 + doc.ready에서 구하는 데이터줄수)
			
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for(i=0; i<DataGrid1.col_head_width.length; i++)
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
    	// 표1 열너비로 표2 열너비 설정
    	DataGrid2.col_head_width[0] = DataGrid1.col_head_width[0] 
    								+ DataGrid1.col_head_width[1]
    								+ DataGrid1.col_head_width[2];
    	DataGrid2.col_head_width[1] = DataGrid1.col_head_width[3];
    	DataGrid2.col_head_width[2] = DataGrid1.col_head_width[4] 
									+ DataGrid1.col_head_width[5]
									+ DataGrid1.col_head_width[6];
    	
    	// 표2 높이
     	DataGrid2_HeightEnd += 5 * DataGrid2_RowHeight ;
		
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid2_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
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
		DataGrid2.drawGrid(ctx, pointSX, pointSY + DataGrid2_HeightStart, pointEX, pointEY);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			// 점검일자 날짜 포맷 변환
			function dateToKor(date) {
				yyyy = date.substr(0,4);
				mm   = date.substr(5,2);
				dd   = date.substr(8,2);
				checkDateFormatted = yyyy + '년 ' + mm + '월 ' + dd + '일';
				return checkDateFormatted;
			}
			
			var blank_tab = '    '; // 4칸 공백
			var top_info = '' ;
			var middle_info = '이물관리 점검표' ;
			var bottom_info1 = '점검일자                                    '
							   + dateToKor('<%=GV_INCOG_DATE_START%>') 
							   + '~' + dateToKor('<%=GV_INCOG_DATE_END%>');  
			var bottom_info2 = '모니터링';
			var btm_info2_1 = '   방법        작업장을 순회하면서 육안으로 각 항목에 준하여 점검한다.' ;
			var btm_info2_2 = '   주기        1회/1일' ;			
			var approval_box_width = 190; //결재박스 너비(30 + 80 + 80)
			
			// 헤드텍스트
			ctx_fillText(ctx, sx, sy, top_info, 'black', vTextStyle, 'start','top');
			ctx_fillText(ctx, (sx+ex-approval_box_width)/2, sy+30, middle_info, 'black', 'bold 30px 맑은고딕', 'center','top');
			ctx_fillText(ctx, sx+45, sy+85, bottom_info1, 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+75, sy+125, bottom_info2, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+160, sy+120, btm_info2_1, 'black', vTextStyleBold, 'start','bottom');
			ctx_fillText(ctx, sx+160, sy+145, btm_info2_2, 'black', vTextStyleBold, 'start','bottom');
			
			// 헤드박스
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2);
			ctx_Line(ctx, ex-approval_box_width+30, sy+30, ex, sy+30, 'black', 1); // 1st 가로선
			ctx_Line(ctx, sx, sy+65, ex, sy+65, 'black', 1); // 2nd 가로선
			ctx_Line(ctx, sx, sy+100, ex, sy+100, 'black', 1); // 3rd 가로선
			ctx_Line(ctx, sx+150, sy+125, ex, sy+125, 'black', 1); // 4th 가로선
			ctx_Line(ctx, sx+150, sy, sx+150, ey, 'black', 1); // 1st 세로선
			ctx_Line(ctx, sx+230, sy+100, sx+230,ey, 'black', 1); // 2nd 세로선
			ctx_Line(ctx, ex-approval_box_width, sy, ex-approval_box_width, sy+100, 'black', 1); // 3rd 세로선
			ctx_Line(ctx, ex-approval_box_width+30, sy, ex-approval_box_width+30, sy+65, 'black', 1); // 4th 세로선
			ctx_Line(ctx, ex-approval_box_width+30+(ex-(ex-approval_box_width+30))/2, sy, ex-approval_box_width+30+(ex-(ex-approval_box_width+30))/2, sy+65, 'black', 1); // 5th 세로선
			
			ctx_fillText(ctx, ex-approval_box_width+15, sy+20, '결', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-approval_box_width+15, sy+45, '재', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*3/4, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1/4, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_head:["구분","점 검 사 항","점 검 결 과"],
		col_head_width:[80,600,350],
		col_data:<%=DataArray%>,
		col_data2:<%=DataArray2%>,
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid1_RowHeight1st, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid1_RowHeight1st)/2 ;
			
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 1); // 가로선(이중선)
			
			for(i = 0; i <= this.col_head_width.length-1; i++){
				col_head_x += this.col_head_width[i] ;
				col_head_x_center = sx + col_head_x - this.col_head_width[i]/2 ;
				
				
				if(i < this.col_head_width.length-1) {
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey-30, 'black', 1);	// 세로선 | ey"-30" for '범례' 선 제외
					ctx_wrapText_space(ctx, col_head_x_center, col_head_y_center, this.col_head[i],
									   'black', vTextStyle, 'center','middle', this.col_head_width[i]-10, 
									   DataGrid1_RowHeight1st/3);
				}
				
				if(i == this.col_head_width.length-1){	
					// 점검결과
					var chk_rslt_x = col_head_x-this.col_head_width[i];
					var chk_rslt_txt_x = col_head_x-(this.col_head_width[i]/2);
					var chk_rslt_txt_y = sy+(col_head_y_center-sy)/2;
					ctx_Line(ctx, chk_rslt_x, col_head_y_center, ex, col_head_y_center, 'black', 1);
 					ctx_fillText(ctx, chk_rslt_txt_x, chk_rslt_txt_y, this.col_head[i], 'black', 
 								 vTextStyle, 'center','middle');
					
 					// 점검결과 아래 날짜 구분
					var wrkDays = 5;
					var wrk_width = this.col_head_width[i]/wrkDays;
					for(k = 1; k <= wrkDays; k++) {
						var wrk_width_x = chk_rslt_x + wrk_width * k;
						ctx_Line(ctx, wrk_width_x, col_head_y_center, wrk_width_x, ey-30, 'black', 1);	// ey"-30" for '범례' 선 제외
						var chk_rslt_date_y = col_head_y-(col_head_y-col_head_y_center)/2;
							
						if(k-1 < this.col_data2.length) {	// 날짜 입력
							var date = new Date(this.col_data2[k-1][0]);
							var formattedDate = (date.getMonth()+1) + "/" + date.getDate();
							ctx_fillText(ctx, wrk_width_x-40, chk_rslt_date_y, formattedDate,
									     'black', vTextStyle, 'center','middle');
							// 결과값 입력 (Y/N)
							
							var rsltData = this.col_data2[k-1][1];
							var rsltDataArr = rsltData.split(',');
							
							for(m = 0; m < rsltDataArr.length; m++) {
								if(rsltDataArr[m] === 'Y') {
									rsltDataArr[m] = 'O';
								} else {
									rsltDataArr[m] = 'X';
								}
								ctx_fillText(ctx, wrk_width_x-40, chk_rslt_date_y+40, rsltDataArr[m], 
									     	 'black', vTextStyle, 'center','middle');
								chk_rslt_date_y += 40;	// y 값 이동
							}
						}
					}
				}
			}
			
			// 구분 & 점검사항 변수들
			var col_data_y 		= sy + DataGrid1_RowHeight1st;
			var col_data_y_each = DataGrid1_RowHeight;
			var colDataArrY 	= [];
			
			var col1Width 		= this.col_head_width;
			var col1_x_center 	= sx + col1Width[0]/2;	// 구분 칼럼 x좌표 센터
			var col2_x_center 	= sx + col1Width[0] + (col1Width[1]-col1Width[0])/2;	// 구분 칼럼 x좌표 센터
			
			var col2_y_center 	= "";	// 점검사항 각 행 y축 센터를 구하기 위해 선언
			
			var lnBrkWidth1 = DataGrid1_RowHeight/2.6;
			var lnBrkWidth2 = DataGrid1_RowHeight/2;
			
			// 구분 & 점검사항 그리기
			for(i = 0; i < DataGrid1_RowCount;  i++) {
				col_data_y += col_data_y_each;	// '구분' 컬럼 선 그리기 위한 y크기 증가
				colDataArrY.push(col_data_y);	// y축 center 값 구하기 위해 배열 이용
				
				if(i == 0) {
					col2_y_center = colDataArrY[i] - (colDataArrY[i]-sy-DataGrid1_RowHeight1st)/2;
				} else {
					col2_y_center = colDataArrY[i] - (colDataArrY[i]-colDataArrY[i-1])/2;
				}
				
				ctx_wrapText_space(ctx, col2_x_center+50, col2_y_center, this.col_data[i][3],
				   		   'black', vTextStyle, 'center','middle', col1Width[1]-50, 
				   			lnBrkWidth2);
				
				// 표2 선긋기 & 구분 메뉴명 입력
				switch(this.col_data[i][8]) {
					case "1":	// 각 case 숫자는 '구분' 메뉴명이 바뀌는 기준
						var yCenter = colDataArrY[i]-(colDataArrY[i]-sy-DataGrid1_RowHeight1st)/2;
						ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1);
						ctx_wrapText_space(ctx, col1_x_center, yCenter, this.col_data[i][2],
						   		   'black', vTextStyle, 'center','middle', col1Width[0], 
						   			lnBrkWidth1);
						break;
					case "3":
						yCenter = colDataArrY[i]-(colDataArrY[i]-colDataArrY[0])/2;
						ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1);
						ctx_wrapText_space(ctx, col1_x_center, yCenter, this.col_data[i][2],
						   		   'black', vTextStyle, 'center','middle', col1Width[0], 
						   			lnBrkWidth1);
						break;
					case "12":
						yCenter = colDataArrY[i]-(colDataArrY[i]-colDataArrY[2])/2;
						ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1);
						ctx_wrapText_space(ctx, col1_x_center, yCenter, this.col_data[i][2],
						   		   'black', vTextStyle, 'center','middle', col1Width[0], 
						   			lnBrkWidth1);
						break;
					case "16":
						yCenter = colDataArrY[i]-(colDataArrY[i]-colDataArrY[11])/2;
						ctx_Line(ctx, sx, col_data_y, ex, col_data_y, 'black', 1);
						ctx_wrapText_space(ctx, col1_x_center, yCenter, this.col_data[i][2],
						   		   'black', vTextStyle, 'center','middle', col1Width[0], 
						   			lnBrkWidth1);
						break;
					case "21":
						yCenter = colDataArrY[i]-(colDataArrY[i]-colDataArrY[15])/2;
						ctx_wrapText_space(ctx, col1_x_center, yCenter, this.col_data[i][2],
						   		   'black', vTextStyle, 'center','middle', col1Width[0],
						   			lnBrkWidth1);
						break;
					default:
						ctx_Line(ctx, sx+col1Width[0], col_data_y, ex, col_data_y, 'black', 1);
						break;
				}
			}
			// 확인란
			ctx_Line(ctx, sx, colDataArrY[20], ex, colDataArrY[20], 'black', 1);
			ctx_fillText(ctx, col1_x_center, colDataArrY[20]+15, '확인', 
						'black', vTextStyle, 'center','middle');
			
			// 범례란
			ctx_Line(ctx, sx, colDataArrY[20]+30, ex, colDataArrY[20]+30, 'black', 1);
			ctx_Line(ctx, sx+col1Width[0], colDataArrY[20]+30, sx+col1Width[0], ey, 'black', 1);
			ctx_fillText(ctx, col1_x_center, colDataArrY[20]+45, '범례', 
						 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, sx+(ex-sx+col1Width[0])/2, colDataArrY[20]+45, '양호 : O    불량 : X', 
					 	 'black', vTextStyle, 'center','middle');
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 정의
	var DataGrid2 = {
		col_subhead:["일자","이상발생내역","조치내역 및 결과","조치자","확인"],
		col_head_width:[0,0,0], // doc.ready에서 지정
		col_data:<%=DataArray%>,
<%-- 		col_data:["<%=DeviationsSubject%>","<%=Improvement%>","<%=Bigo%>"], --%>
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			ctx_fillColor(ctx, sx, sy, ex, sy + DataGrid2_RowHeight1st, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid2_RowHeight1st ;
			var col_head_y_center = sy + (DataGrid2_RowHeight1st)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			var col_head_x_center = col_head_x + ex / 2 ;
			ctx_fillText(ctx, col_head_x_center, col_head_y-15, "관리기준 이탈 시 조치사항", 'black', vTextStyle, 'center','middle');
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, 'black', 2); // 가로선
			
			// 서브헤드
			ctx_Line(ctx, sx, col_head_y+30, ex, col_head_y+30, 'black', 2); // 가로선
			
			var col_cut = ex / 10;
			col_subhead_width = [sx,sx+col_cut*1,sx+col_cut*3,sx+col_cut*4,sx+col_cut*1];
			
			for(m = 0; m < col_subhead_width.length; m++) {
				col_head_x += col_subhead_width[m];
				if(m == 0) {	// subhead 중앙 배치
					col_head_x = sx;
					col_head_x_center = col_head_x + col_subhead_width[m+1] / 2;
				} else if(m == col_subhead_width.length-1) {
					col_head_x_center = col_head_x + (ex - col_head_x) / 2;
				} else {
					col_head_x_center = col_head_x + col_subhead_width[m+1] / 2;
				}			
				ctx_Line(ctx, col_head_x, col_head_y, col_head_x, ey, 'black', 1);
				ctx_fillText(ctx, col_head_x_center, col_head_y+15, this.col_subhead[m], 'black', vTextStyle, 'center', 'middle');
			}
			
			// 데이터
			var col_data_y = col_head_y + 45;
			var col_data_x = sx;
			for(i = 0; i < <%=RowCount%>; i += 21){
				if(this.col_data[i][5] != "") {		// 빈값이면 입력 X
					ctx_wrapText(ctx, col_data_x+60, col_data_y, this.col_data[i][9],
						     'black', vTextStyle, 'center','middle', 
						     this.col_head_width[0]-10, DataGrid2_RowHeight);
					ctx_wrapText(ctx, col_data_x+275, col_data_y, this.col_data[i][5],
							     'black', vTextStyle, 'center','middle', 
							     this.col_head_width[0]-10, DataGrid2_RowHeight);
					ctx_wrapText(ctx, col_data_x+650, col_data_y, this.col_data[i][6],
						     	 'black', vTextStyle, 'center','middle', 
						     	 this.col_head_width[1]-10, DataGrid2_RowHeight);
					ctx_wrapText(ctx, col_data_x+920, col_data_y, this.col_data[i][7],
						     	 'black', vTextStyle, 'center','middle', 
						     	 this.col_head_width[2]-10, DataGrid2_RowHeight);
					col_data_y = col_data_y + 25;	// y축 이동
				}
			}
		},
	} ; // DataGrid2(표2) 정의  end
</script>

    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>