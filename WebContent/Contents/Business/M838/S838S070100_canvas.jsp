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
원자재 입고검사 대장 canvas (S838S070100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();	
	DoyosaeTableModel TableModel;

	String GV_CHECK_DATE_START="",GV_CHECK_DATE_END="",GV_CHECK_GUBUN = "",
			GV_PAGE_START="" ;

// 	if(request.getParameter("check_date_start")== null)
// 		GV_CHECK_DATE_START = "";
// 	else
// 		GV_CHECK_DATE_START = request.getParameter("check_date_start");
	
// 	if(request.getParameter("check_date_end")== null)
// 		GV_CHECK_DATE_END = "";
// 	else
// 		GV_CHECK_DATE_END = request.getParameter("check_date_end");
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	if(request.getParameter("page_start")== null)
		GV_PAGE_START = "";
	else
		GV_PAGE_START = request.getParameter("page_start");
	
	int GV_PAGE_COUNT = 4;

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	
	// 구분, 점검항목
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S070100E134", jArray);
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(13)
	
// 	jArray.put( "check_date_start", GV_CHECK_DATE_START);
// 	jArray.put( "check_date_end", GV_CHECK_DATE_END);
	jArray.put( "page_start", (Integer.parseInt(GV_PAGE_START)-1) * CheckCount * GV_PAGE_COUNT);
	jArray.put( "page_end", Integer.parseInt(GV_PAGE_START) * CheckCount * GV_PAGE_COUNT);

	TableModel = new DoyosaeTableModel("M838S070100E144", jArray);
	int RowCount =TableModel.getRowCount();
	
	// 점검일자(기간), 점검자(정), 점검자(부)
	String CheckDate = "", WritorMain = "", WritorSecond = "" ;
	if(RowCount>0) {
		CheckDate = TableModel.getValueAt(0, 0).toString().trim();
		WritorMain = TableModel.getValueAt(0, 14).toString().trim();
		WritorSecond = TableModel.getValueAt(0, 15).toString().trim();
	}
	
	StringBuffer CheckGubunMid = new StringBuffer();
//  	StringBuffer CheckGubunSm = new StringBuffer();
	StringBuffer CheckNote = new StringBuffer();
	CheckGubunMid.append("[" + "'','','','','','',");
//  	CheckGubunSm.append("[");
	CheckNote.append("[" + "'입 고 일','입고시간','입고처명','원료명','수    량','온    도',");
	if(RowCount>=CheckCount) {
		for(int i=1; i<CheckCount; i++) {
//  		if(i==CheckCount-1) {
//  			CheckGubunMid.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" );
//  			CheckGubunSm.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" );
//  			CheckNote.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" );
//  		} else {
				CheckGubunMid.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'" + "," );
//  				CheckGubunSm.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," );
				CheckNote.append( "'" + TableModel.getValueAt(i, 12).toString().trim() + "'" + "," );
//  		}
		}
	}
	CheckGubunMid.append("'','','결재','결재',''" + "]");
//  	CheckGubunSm.appeㅊnd("]");
	CheckNote.append("'부적합 내용','개선조치 내용','작    성 (입고담당)','승    인 (HACCP 팀장)','배송차량 온도기록지'" + "]");
	
	// 결과 값, 일자, 부적합, 개선조치사항
	int CheckRow = RowCount / CheckCount ;
	StringBuffer DATA_LIST_1 = new StringBuffer(); // 표1에 들어갈 데이터
	DATA_LIST_1.append("[");
	if(RowCount>=CheckCount) {
		for(int i=0; i<CheckRow; i++) {
			String GV_IPGO_DATE="", GV_IPGO_TIME="", GV_IPGO_DATETIME="";
			GV_IPGO_DATETIME = TableModel.getValueAt(i*CheckCount, 2).toString().trim(); 
			if(GV_IPGO_DATETIME.length()>=10) GV_IPGO_DATE = GV_IPGO_DATETIME.substring(0, 10);
			if(GV_IPGO_DATETIME.length()>=16) GV_IPGO_TIME = GV_IPGO_DATETIME.substring(11, 16);
			
			// 표1 데이터
			StringBuffer data_sub = new StringBuffer();
			data_sub.append("[");
			data_sub.append("'" + GV_IPGO_DATE + "',"); // 입고일
			data_sub.append("'" + GV_IPGO_TIME + "',"); // 입고시간
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 3).toString().trim() + "',"); // 업체명
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 4).toString().trim() + "',"); // 품목명
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 6).toString().trim() + "',"); // 제품수량
			for(int j=0; j<CheckCount; j++) {
				int CheckIndex = i * CheckCount +j;
				data_sub.append("'" + TableModel.getValueAt(CheckIndex, 13).toString().trim() 	+ "',"); // 결과값
			}
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 16).toString().trim() + "',"); // 부적합
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 17).toString().trim() + "',"); // 개선사항
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 14).toString().trim() + "',"); // 작성자
			data_sub.append("'" + TableModel.getValueAt(i*CheckCount, 15).toString().trim() + "',"); // 승인자
			data_sub.append("''"); // 배송차량 온도기록지
			if(i==CheckRow-1) {
				data_sub.append( "]");
			} else {
				data_sub.append( "],");
			}
			DATA_LIST_1.append(data_sub);
		}
	}
	DATA_LIST_1.append("]");
// 	System.out.println(DATA_LIST_1.toString());
	
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 50; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 140; // 헤드텍스트 영역 종료 높이
	var HaedText_MinWidth = 780; //헤드텍스트 영역 최소 너비
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowHeightLast = 250; // 표1의 마지막행 높이(배송차량 온도기록지)
	var DataGrid1_RowCount = <%=CheckCount%> + 9; // 표1의 행 개수(체크리스트개수+나머지)
	var DataGrid1_ColWidth = 200; // 표1의 열 너비(최소130)
	var DataGrid1_ColWidth1st = 90; // 표1의 1번째 열 너비
	var DataGrid1_ColWidth2nd = 90; // 표1의 2번째 열 너비
<%-- 	var DataGrid1_ColCount = <%=CheckRow%> ; // 표1의 데이터 열 개수 --%>
	var DataGrid1_ColCount = <%=GV_PAGE_COUNT%> ; // 표1의 데이터 열 개수
	var DataGrid1_HeightStart = HaedText_HeightEnd; // 표1 시작위치(헤드텍스트영역 끝 높이)
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + DataGrid1_RowCount * DataGrid1_RowHeight
								+ DataGrid1_RowHeightLast; // 표1 끝나는 위치(시작위치 + 행개수 * 행높이  + 배송차량 온도기록지 공간)
	var DataGrid1_Width_Total = DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
								+ DataGrid1_ColWidth * DataGrid1_ColCount; // 표1영역 총 너비(1,2번째 열 + 데이터 열)
	var DataGrid1_IncongLineCount = 2;
	var DataGrid1_ImproveLineCount = 2;

	
	// doc.ready : 시작부분
    $(document).ready(function () {
    	// 캔버스영역 너비 계산
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = HaedText_MinWidth + CanvasPadding*2; // 캔버스영역 최소 너비(헤드영역 최소너비 + 여백)
    	if(CanvasWidth < DataGrid1_Width_Total) {
    		CanvasWidth = DataGrid1_Width_Total + CanvasPadding*2; // 표1영역 너비가 캔버스영역 최소 너비보다 클때 => 표1 너비로
    	} else {
    		//표1 1칸 너비와 전체 너비 갯수에 맞춰 다시 계산
    		DataGrid1_ColWidth = (HaedText_MinWidth - DataGrid1_ColWidth1st - DataGrid1_ColWidth2nd) / DataGrid1_ColCount ;
    		DataGrid1_Width_Total = DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
									+ DataGrid1_ColWidth * DataGrid1_ColCount; // 표1영역 총 너비(1,2번째 열 + 데이터 열)
    	}
    	// 캔버스영역 높이 계산 (부적합&개선조치 줄수 계산)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	DataGrid1_IncongLineCount = DataGrid1.getIncongLineCount(ctx_temp) ; // 부적합 줄수
    	DataGrid1_ImproveLineCount = DataGrid1.getImproveLineCount(ctx_temp) ; // 개선조치 줄수
    	DataGrid1_HeightEnd += (DataGrid1_IncongLineCount + DataGrid1_ImproveLineCount - 4) * DataGrid1_RowHeight/2;
    	var CanvasHeight = DataGrid1_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	// 캔버스 컨텍스트 생성
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
		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, 
				pointSX + DataGrid1_Width_Total, pointSY + DataGrid1_HeightEnd);
		DataGrid1.drawData(ctx, pointSX, pointSY + DataGrid1_HeightStart, 
				pointSX + DataGrid1_Width_Total, pointSY + DataGrid1_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'HS-PP-06-A 원료 입고검사 대장' ;
			var middle_info = '원료 입고검사 대장' ;
			if('<%=WritorMain%>'.length > 0) var writor_main = '<%=WritorMain%>' ;
			else var writor_main = blank_tab + blank_tab + blank_tab ;
			if('<%=WritorSecond%>'.length > 0) var writor_second = '<%=WritorSecond%>' ;
			else var writor_second = blank_tab + blank_tab + blank_tab ;
			var bottom_info1 = '- 점검자 : (정) ' + writor_main + blank_tab + '(부) '+ writor_second ;
			var bottom_info2 = '- 점검방법 : 양호 O, 불량  X' ;
			var bottom_info3 = '- 검사증명서 : 입고 시 마다' ;
			var bottom_info4 = '- 원료 시험성적서 : 월1회(도축장에서 검사)' ;
			var bottom_info5 = '- 심부온도 : 온도확인' ;
			
			var bottom_info_width = 350;
			ctx_fillText(ctx, sx, sy-20, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+(ex-bottom_info_width-sx)/2, sy+(ey-sy)/2, middle_info, 'black', 'bold 40px 맑은고딕', 'center','middle');
			ctx_Line(ctx, ex-bottom_info_width, sy, ex-bottom_info_width, ey, 'black', 1); // 세로선
			ctx_fillText(ctx, ex-bottom_info_width+10, sy + 15, bottom_info1, 'black', 'bold 15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, ex-bottom_info_width+10, sy + 40, bottom_info2, 'black', 'bold 15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, ex-bottom_info_width+10, sy + 65, bottom_info3, 'black', 'bold 15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, ex-bottom_info_width+10, sy + 90, bottom_info4, 'black', 'bold 15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, ex-bottom_info_width+10, sy + 115, bottom_info5, 'black', 'bold 15px 맑은고딕', 'start','top');
		}
	} ;
	
	// 표1 정의
	var DataGrid1 = {
		col_headLv1:<%=CheckGubunMid%>,
		col_headLv2:<%=CheckNote%>,
		col_unit:[ "","","","","","℃","□적합/□부적합","□적합/□부적합","□적합/□부적합","","","","","","","","부    착" ], // 표1 양식에 들어갈 단위	  
		col_data:<%=DATA_LIST_1.toString()%>, // DB에서 읽어온 데이터
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			var row_height = sy ; // 가로선 y좌표
			var col_headLv1_x = sx + (DataGrid1_ColWidth1st/2); // 점검항목명 Lv1의 x좌표
			var col_headLv2_x = sx + DataGrid1_ColWidth1st + (DataGrid1_ColWidth2nd/2); // 점검항목명 Lv2의 x좌표
			var row_height_etc = sy ; // 부적합,개선조치 y좌표
			
			// 세로선
			ctx_Line(ctx, sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-2, sy, 
					sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-2, ey, 'black', 1); // 이중선
			ctx_Line(ctx, sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd+2, sy, 
					sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd+2, ey, 'black', 1); // 이중선
			for(j=0; j<DataGrid1_ColCount; j++) { //세로
				if(j>0) { //첫번째 왼쪽 세로선은 이중선으로 위에서 따로 그음
					ctx_Line(ctx, sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd+(j*DataGrid1_ColWidth), sy, 
							sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd+(j*DataGrid1_ColWidth), ey, 'black', 1);
				}
			}
			
			for(i=0; i<this.col_headLv1.length; i++) { // 가로
				if(i>0) row_height += DataGrid1_RowHeight;// 0번째에는 행높이를 안 더한다.
				var col_head_y = row_height + (DataGrid1_RowHeight/2); // 점검항목명의 y좌표
				// 가로선, 텍스트
				if(i==0) { // 입고일(가로열 합치기), 0번째엔 선 그릴 필요없이 글자만 넣는다
					ctx_fillText(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, col_head_y, this.col_headLv2[i], 'black', vTextStyleBold, 'center','middle');
				} else if(i==5) { // 하단에 기준 표시
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_fillText(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, col_head_y-10, this.col_headLv2[i], 'black', vTextStyleBold, 'center','middle');
					var inspect_check_info = '( - 2 ~ 5 ℃ 이 하 )';
					ctx_fillText(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, col_head_y+15, inspect_check_info, 'black', 'bold 12px 맑은고딕', 'center','middle');
				} else if(i==6||i==7||i==8) { // 가로열 나누기
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1); // 가로선
					ctx_Line(ctx, sx+DataGrid1_ColWidth1st, row_height, sx+DataGrid1_ColWidth1st, row_height+DataGrid1_RowHeight, 'black', 1); // 세로선(1번째)
					ctx_wrapText(ctx, col_headLv1_x, col_head_y, this.col_headLv1[i],
							'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth1st-10, DataGrid1_RowHeight/2);
					ctx_wrapText_space(ctx, col_headLv2_x, col_head_y, this.col_headLv2[i],
							'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth2nd-10, DataGrid1_RowHeight/2);
				} else if(i==9||i==10) { // 가로열 나누기 & 하단 안내문
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_Line(ctx, sx+DataGrid1_ColWidth1st, row_height, sx+DataGrid1_ColWidth1st, row_height+DataGrid1_RowHeight, 'black', 1); // 세로선(1번째)
					
					ctx_wrapText(ctx, col_headLv1_x, col_head_y, this.col_headLv1[i],
							'black', 'bold 12px 맑은고딕', 'center','middle', DataGrid1_ColWidth1st-10, DataGrid1_RowHeight/3);
					ctx_wrapText_space(ctx, col_headLv2_x, col_head_y-10, this.col_headLv2[i],
							'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth2nd-10, DataGrid1_RowHeight/2);
					// 하단안내문&구분선
					ctx_Line(ctx, sx+DataGrid1_ColWidth1st, row_height+30, 
							sx+DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-2, row_height+30, 'black', 1);
					var inspect_doc_info = '징 수 시  :  O';
					ctx_fillText(ctx, col_headLv2_x, col_head_y+15, inspect_doc_info, 'black', 'bold 12px 맑은고딕', 'center','middle');
				} else if(i==11) { // 부적합 (데이터에 맞춰서 높이 추가)
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_wrapText_space(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2,
							col_head_y + ((DataGrid1_IncongLineCount-2) * DataGrid1_RowHeight/2)/2,
							this.col_headLv2[i], 'black', vTextStyleBold,'center','middle',
							DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-10, DataGrid1_RowHeight/2);
					if(DataGrid1_IncongLineCount>2) {
						row_height += (DataGrid1_IncongLineCount-2) * DataGrid1_RowHeight/2;
// 						col_head_y = row_height + (DataGrid1_RowHeight/2); // 다시 계산
					}
				} else if(i==12) { // 개선조치 (데이터에 맞춰서 높이 추가)
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_wrapText_space(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, 
							col_head_y + ((DataGrid1_ImproveLineCount-2) * DataGrid1_RowHeight/2)/2, 
							this.col_headLv2[i], 'black', vTextStyleBold,'center','middle', 
							DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-10, DataGrid1_RowHeight/2);
					if(DataGrid1_ImproveLineCount>2) {
						row_height += (DataGrid1_ImproveLineCount-2) * DataGrid1_RowHeight/2;
// 						col_head_y = row_height + (DataGrid1_RowHeight/2); // 다시 계산
					}
				} else if(i==13) { // 결재(작성) (가로열 나누기)
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1); // 가로선
					ctx_Line(ctx, sx+30, row_height, sx+30, row_height+DataGrid1_RowHeight, 'black', 1); // 세로선(1번째)
					ctx_fillText(ctx, sx+15, col_head_y, '결', 'black', vTextStyleBold, 'center','middle');
					ctx_wrapText_space(ctx, sx+30+(DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-30)/2, col_head_y, this.col_headLv2[i],
							'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth2nd+40, DataGrid1_RowHeight/2);
				} else if(i==14) { // 결재(승인) (가로열 나누기)
					ctx_Line(ctx, sx+30, row_height, ex, row_height, 'black', 1); // 가로선
					ctx_Line(ctx, sx+30, row_height, sx+30, row_height+DataGrid1_RowHeight, 'black', 1); // 세로선(1번째)
					ctx_fillText(ctx, sx+15, col_head_y, '재', 'black', vTextStyleBold, 'center','middle');
					ctx_wrapText_space(ctx, sx+30+(DataGrid1_ColWidth1st+DataGrid1_ColWidth2nd-30)/2, col_head_y, this.col_headLv2[i],
							'black', vTextStyleBold, 'center','middle', DataGrid1_ColWidth2nd+20, DataGrid1_RowHeight/2);
				} else if(i==this.col_headLv1.length-1) { // 마지막행(배송차량 온도기록지)
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_fillText(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, row_height+(DataGrid1_RowHeightLast/2),
							this.col_headLv2[i], 'black', vTextStyleBold, 'center','middle');
				} else { // 나머지(가로열 합치기)
					ctx_Line(ctx, sx, row_height, ex, row_height, 'black', 1);
					ctx_fillText(ctx, col_headLv1_x+(DataGrid1_ColWidth2nd)/2, col_head_y, this.col_headLv2[i], 'black', vTextStyleBold, 'center','middle');
				}
				
				// 체크박스(적합/부적합),단위 넣기
				for(j=0; j<DataGrid1_ColCount; j++) {
					if(i==4||i==5) {
						var col_unit_x = sx + DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
										+ (j*DataGrid1_ColWidth) + DataGrid1_ColWidth - 10 ;
						ctx_fillText(ctx, col_unit_x, col_head_y, this.col_unit[i], 'black', vTextStyle, 'end','middle');
					} else if(i==6||i==7||i==8) {
						var col_unit_x = sx + DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
										+ (j*DataGrid1_ColWidth) + (DataGrid1_ColWidth/2) ;
						ctx_fillText(ctx, col_unit_x, col_head_y, this.col_unit[i], 'black', vTextStyle, 'center','middle');
					} else if(i==this.col_headLv1.length-1) {
						var col_unit_x = sx + DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
										+ (j*DataGrid1_ColWidth) + (DataGrid1_ColWidth/2) ;
						ctx_fillText(ctx, col_unit_x, row_height+(DataGrid1_RowHeightLast/2), 
								this.col_unit[i], 'gray', vTextStyle, 'center','middle');
					}
				}
			} // 표1 양식 그리기 for문 end
		}, // drawGrid function end
		
		drawData: function(ctx, sx, sy, ex, ey) { // 표1에 DB에서 읽어온 데이터 넣기(데이터 세로로 들어감)
			var dataCount = this.col_data.length; // 레코드 개수
			for(j=0; j<this.col_data.length; j++) { //세로
				var col_data_x = sx + DataGrid1_ColWidth1st + DataGrid1_ColWidth2nd 
								+ (j*DataGrid1_ColWidth) + (DataGrid1_ColWidth/2); // 데이터 넣기 기준좌표 x
				var row_height = sy ; // 가로선 y좌표
				var dataColCount = this.col_data[j].length; // 점검항목 개수
				for(i=0; i<dataColCount; i++) { // 가로
					if(i>0) row_height += DataGrid1_RowHeight;// 0번째에는 행높이를 안 더한다.
					var col_data_y = row_height + (DataGrid1_RowHeight/2); // 데이터 넣기 기준좌표 y
					if(i==0) { // 작성일자 => 작성연도,일자,점검시각
						var datetime = new Date(this.col_data[j][i]); // 문자열을 날짜 타입으로 변환(년,월,일,시,분)
						var date_string	= datetime.getFullYear() + " . "
										+ ("0" + (datetime.getMonth() + 1)).slice(-2) + " . "
										+ ("0" + datetime.getDate()).slice(-2) + " .";
						ctx_fillText(ctx, col_data_x, col_data_y, date_string, 'black', vTextStyle, 'center','middle');
					} else if(i==6||i==7||i==8) { // 체크박스 => 적합/부적합
						var check_data = this.col_data[j][i];
						if(check_data == "Y")
							ctx_fillText(ctx, col_data_x-47, col_data_y-3, "✓", 'black', vTextStyle, 'center','middle');
						else if(check_data == "N")
							ctx_fillText(ctx, col_data_x+4, col_data_y-3, "✓", 'black', vTextStyle, 'center','middle');
					} else if(i==9||i==10) { // O,X
						var check_data = this.col_data[j][i];
						if(check_data == "Y")
							ctx_fillText(ctx, col_data_x, col_data_y, "O", 'black', vTextStyle, 'center','middle');
						else if(check_data == "N")
							ctx_fillText(ctx, col_data_x, col_data_y, "X", 'black', vTextStyle, 'center','middle');
					} else if(i==11) { // 부적합 (데이터에 맞춰서 높이 추가)
						ctx_wrapText(ctx, col_data_x-(DataGrid1_ColWidth/2)+5, col_data_y-(DataGrid1_RowHeight/2)+5, this.col_data[j][i],
								'black', vTextStyle,'start','top', DataGrid1_ColWidth-10, DataGrid1_RowHeight/2);
						if(DataGrid1_IncongLineCount>2)
							row_height += (DataGrid1_IncongLineCount-2) * DataGrid1_RowHeight/2;
					} else if(i==12) { // 개선조치 (데이터에 맞춰서 높이 추가)
						ctx_wrapText(ctx, col_data_x-(DataGrid1_ColWidth/2)+5, col_data_y-(DataGrid1_RowHeight/2)+5, this.col_data[j][i],
								'black', vTextStyle,'start','top', DataGrid1_ColWidth-10, DataGrid1_RowHeight/2);
						if(DataGrid1_ImproveLineCount>2)
							row_height += (DataGrid1_ImproveLineCount-2) * DataGrid1_RowHeight/2;
					} else {
						ctx_fillText(ctx, col_data_x, col_data_y, this.col_data[j][i], 'black', vTextStyle, 'center','middle');
					}
				}
			}
		}, // drawData function end
		
		getIncongLineCount: function(ctx) { // 표2의 줄수(부적합사항&시정 및 개선조치)
			ctx.font = vTextStyle;
			var col_width = DataGrid1_ColWidth ;
			var col_lineCount = 2; // 최소 줄수 : 2줄
			for(i=0; i<this.col_data.length; i++) {
				var incong_lineCount = ctx_wrapText_lineCount(ctx, this.col_data[i][11], DataGrid1_ColWidth-10); // 부적합사항 줄 개수
				if(incong_lineCount > col_lineCount) col_lineCount = incong_lineCount; // 더 큰 줄수를 저장
			}
			return col_lineCount ;
		},
		
		getImproveLineCount: function(ctx) { // 표2의 줄수(부적합사항&시정 및 개선조치)
			ctx.font = vTextStyle;
			var col_width = DataGrid1_ColWidth ;
			var col_lineCount = 2; // 최소 줄수 : 2줄
			for(i=0; i<this.col_data.length; i++) {
				var improve_lineCount = ctx_wrapText_lineCount(ctx, this.col_data[i][12], DataGrid1_ColWidth-10); // 개선조치 줄 개수
				if(improve_lineCount > col_lineCount) col_lineCount = improve_lineCount; // 더 큰 줄수를 저장
			}
			return col_lineCount ;
		}
	} ; // DataGrid1(표1) 정의  end
	
	function fn_Pre_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas.jsp"
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)-1%> // 이전페이지	
							 + "&check_gubun=" + "<%=GV_CHECK_GUBUN%>" ;
		pop_fn_popUpScr(modalContentUrl, $("#modalReport_Title").text(), '800px', '1260px');
	}
	
	function fn_Next_Page() {
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas.jsp"
							 + "?page_start=" + <%=Integer.parseInt(GV_PAGE_START)+1%> // 다음페이지	
						 	 + "&check_gubun=" + "<%=GV_CHECK_GUBUN%>" ;
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
    	<%if( RowCount == CheckCount * GV_PAGE_COUNT ) {%>
        <button id="btn_Next"  class="btn btn-info"  onclick="fn_Next_Page();">다음</button>
        <%}%>
    </p>
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>

    </p>