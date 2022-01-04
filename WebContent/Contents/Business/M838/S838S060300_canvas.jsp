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
조도 점검표 canvas (S838S010300_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableCountModel;

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "", GV_SUBCONSTRACTOR_SEQ = "", GV_IO_GB = "";
	
	if(request.getParameter("SubcontractorNo")== null)
		GV_SUBCONSTRACTOR_NO ="";
	else
		GV_SUBCONSTRACTOR_NO = request.getParameter("SubcontractorNo");
	
	if(request.getParameter("SubcontractorRev")== null)
		GV_SUBCONSTRACTOR_REV ="";
	else
		GV_SUBCONSTRACTOR_REV = request.getParameter("SubcontractorRev");
	
	if(request.getParameter("SubcontractorSeq")== null)
		GV_SUBCONSTRACTOR_SEQ ="";
	else
		GV_SUBCONSTRACTOR_SEQ = request.getParameter("SubcontractorSeq");
	
	if(request.getParameter("Io_gb")== null)
		GV_IO_GB ="";
	else
		GV_IO_GB = request.getParameter("Io_gb");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONSTRACTOR_SEQ);
	jArray.put( "io_gb", GV_IO_GB);
	jArray.put( "member_key", member_key);

    TableModel = new DoyosaeTableModel("M838S060300E134", jArray);
    TableCountModel = new DoyosaeTableModel("M838S060300E135", jArray);
	
 	int RowCount = TableModel.getRowCount();
 	int TableCount = TableCountModel.getRowCount();

    String subcontractor_no    = "";
    String subcontractor_rev   = "";
    String subcontractor_seq   = "";
    String boss_name           = "";
    String address             = "";
    String jongmok             = "";
    String refno               = "";
    String io_gb               = "";
    String code_name           = "";
    String writor              = "";
    String write_date          = "";
    String checker             = "";
    String check_date          = "";
    String approval            = "";
    String approve_date        = "";
    String subcontractor_name  = "";
    String inspector           = "";
    String uptae               = "";
    String assessment_date     = "";
    String assessment_no       = "";
    String assessment_rev      = "";
    String assessment_division = "";
    String assessment_article  = "";
    String assessment_standard = "";
    String assessment_result   = "";
    String assessment_bigo     = "";
    

	StringBuffer DetailArray = new StringBuffer();
	StringBuffer CntArray = new StringBuffer();
	if(RowCount>0) {
	    subcontractor_no    = TableModel.getValueAt(0, 0).toString().trim();
	    subcontractor_rev   = TableModel.getValueAt(0, 1).toString().trim();
	    subcontractor_seq   = TableModel.getValueAt(0, 2).toString().trim();
	    boss_name           = TableModel.getValueAt(0, 3).toString().trim();
	    address             = TableModel.getValueAt(0, 4).toString().trim();
	    jongmok             = TableModel.getValueAt(0, 5).toString().trim();
	    refno               = TableModel.getValueAt(0, 6).toString().trim();
	    io_gb               = TableModel.getValueAt(0, 7).toString().trim();
	    code_name           = TableModel.getValueAt(0, 8).toString().trim();
	    writor              = TableModel.getValueAt(0, 9).toString().trim();
	    write_date          = TableModel.getValueAt(0, 10).toString().trim();
	    checker             = TableModel.getValueAt(0, 11).toString().trim();
	    check_date          = TableModel.getValueAt(0, 12).toString().trim();
	    approval            = TableModel.getValueAt(0, 13).toString().trim();
	    approve_date        = TableModel.getValueAt(0, 14).toString().trim();
	    subcontractor_name  = TableModel.getValueAt(0, 15).toString().trim();
	    inspector           = TableModel.getValueAt(0, 16).toString().trim();
	    uptae               = TableModel.getValueAt(0, 17).toString().trim();
	    assessment_date     = TableModel.getValueAt(0, 18).toString().trim();
		
	    for(int i = 0; i < TableCount; i++){
	    	CntArray.append("[");
	    	CntArray.append("'"+ TableCountModel.getValueAt(i, 0).toString().trim() + "'");  
			if(i==TableCount-1) {
				CntArray.append( "]");
			} else {
				CntArray.append( "],");
			}
	    }
	    for(int i = 0; i < RowCount; i++){
			DetailArray.append("[");			
			DetailArray.append("'"+ TableModel.getValueAt(i, 19).toString().trim() + "',"); // 0. assessment_no      
			DetailArray.append("'"+ TableModel.getValueAt(i, 20).toString().trim() + "',"); // 1. assessment_rev     
			DetailArray.append("'"+ TableModel.getValueAt(i, 21).toString().trim() + "',"); // 2. assessment_division
			DetailArray.append("'"+ TableModel.getValueAt(i, 22).toString().trim() + "',"); // 3. assessment_article 
			DetailArray.append("'"+ TableModel.getValueAt(i, 23).toString().trim() + "',"); // 4. assessment_standard
			DetailArray.append("'"+ TableModel.getValueAt(i, 24).toString().trim() + "',"); // 5. assessment_result  
			DetailArray.append("'"+ TableModel.getValueAt(i, 25).toString().trim() + "'");  // 6. assessment_bigo    
			if(i==RowCount-1) {
				DetailArray.append( "]");
			} else {
				DetailArray.append( "],");
			}
		}
	}

%>

<script type="text/javascript">	
	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 18px 맑은고딕';

	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 승인자
	var CheckText_HeightStart = HaedText_HeightEnd+10;
	var CheckText_HeightEnd = CheckText_HeightStart + 200; // 점검관련사항 영역 종료 높이
	
	// 인
	var row_count = '<%=RowCount%>';
	var SubdataText_HeightStart = CheckText_HeightEnd;
	if(row_count > 36){
		var SubdataText_HeightEnd = SubdataText_HeightStart + 50+(parseInt(row_count)*20)+30; // 점검관련사항 영역 종료 높이
	} else {
		var SubdataText_HeightEnd = SubdataText_HeightStart + 50+(20*35) +30; // 점검관련사항 영역 종료 높이
	}
	

	// 인계자
	var TotalText_HeightStart = SubdataText_HeightEnd;
	var TotalText_HeightEnd = TotalText_HeightStart + 120; // 점검관련사항 영역 종료 높이
	
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = TotalText.col_head_width[0]; // 캔버스영역 너비
    	var CanvasHeight = TotalText_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
		
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
	    SubdataText.drawText(ctx, pointSX, pointSY + SubdataText_HeightStart, pointEX, pointSY + SubdataText_HeightEnd);
	    TotalText.drawText(ctx, pointSX, pointSY + TotalText_HeightStart, pointEX, pointSY + TotalText_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'TYENS-PRP-04-04 (Rev.'+ '<%=subcontractor_rev%>' + ' 협력업체 평가표' ;
			var middle_info = '협력업체 평가표' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2-80, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');

			var col_approval_x_start = 2*(ex/3)+ex/7;
			var col_approval_x_end = col_approval_x_start;
			var col_approval_y_start = sy + 15;
			var col_approval_y_end = ey;
			var col_approval_x_1st_center = col_approval_x_start + (ex - col_approval_x_start)/2;
			var col_approval_x_2nd_center = col_approval_x_1st_center;
			var col_approval_y_1st_center = sy + 15;
			var col_approval_y_2nd_center = ey;

			ctx_Line(ctx, col_approval_x_start-(ex - col_approval_x_start)/2, col_approval_y_start, col_approval_x_end-(ex - col_approval_x_start)/2, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_start, col_approval_y_start, col_approval_x_end, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_1st_center, col_approval_y_1st_center, col_approval_x_2nd_center, col_approval_y_2nd_center, 'black', 1);
			var col_approval_x_1st_upper = col_approval_x_start-(ex - col_approval_x_start)/2;
			var col_approval_x_2nd_upper = ex;
			var col_approval_y_1st_upper = ey/4+40;
			var col_approval_y_2nd_upper = col_approval_y_1st_upper;
			ctx_Line(ctx, col_approval_x_1st_upper, col_approval_y_1st_upper, col_approval_x_2nd_upper, col_approval_y_2nd_upper, 'black', 1);
			var col_approval_x_1st_down = col_approval_x_start-(ex - col_approval_x_start)/2;
			var col_approval_x_2nd_down = ex;
			var col_approval_y_1st_down = ey*0.75+15;
			var col_approval_y_2nd_down = col_approval_y_1st_down;
			ctx_Line(ctx, col_approval_x_1st_down, col_approval_y_1st_down, col_approval_x_2nd_down, col_approval_y_2nd_down, 'black', 1);
			ctx_fillText(ctx, col_approval_x_start +37-(ex - col_approval_x_start)/2, col_approval_y_start +6, "작 성", 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, col_approval_x_start +37, col_approval_y_start +6, "검 토", 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +37, col_approval_y_1st_center +6, "승 인", 'black', vTextStyleBold, 'center','top');

			// 작성, 승인 서명
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_upper +20, "<%=writor%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_upper +40 + (ex - col_approval_x_start)/2, col_approval_y_1st_upper +20, "<%=checker%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_upper +20, "<%=approval%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			
			// write_approval, haccp_approval
			var write_duration = '<%=write_date%>'.split('-');
			var write_date = write_duration[1] +"/"+ write_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_down +5, write_date, 'black', vTextStyleBold, 'center','top');
			var check_duration = '<%=check_date%>'.split('-');
			var check_date = check_duration[1] +"/"+ check_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_upper +40 + (ex - col_approval_x_start)/2, col_approval_y_1st_down +5, check_date, 'black', vTextStyleBold, 'center','top');
			var approval_duration = '<%=approve_date%>'.split('-');
			var approval_date = approval_duration[1] +"/"+ approval_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_down +5, approval_date, 'black', vTextStyleBold, 'center','top');

		} // HeadText.drawText function end
	} ;

	// 회사정보
	var CheckText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var col_head = ['작성일자', '유통업체명', '사업장소재지', '업종/업태', '평가일자', '대표자', '주품목', '사업장등록번호'];
			var write_data = '<%=write_date%>'.split('-');			
			var write_date = write_data[0] + '년 ' + write_data[1] + '월 ' + write_data[2] + '일 ';
			var check_data = '<%=check_date%>'.split('-');			
			var check_date = check_data[0] + '년 ' + check_data[1] + '월 ' + check_data[2] + '일 ';
			var col_data = [write_date, '<%=subcontractor_name%>', '<%=address%>', '<%=uptae%>', check_date, '<%=boss_name%>', '<%=jongmok%>', '기본사업장'];
			var cut = ex/6;
			var cut_val = [1,3,4];
			
			ctx_fillText(ctx, sx+cut*0.5, sy+20, '작성부서', 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut+20, sy+20, '<%=code_name%>', 'black', vTextStyleBold, 'left','middle');
			ctx_Line(ctx, sx+cut, sy, sx+cut, sy+40, 'black', 1)
			for(var i = 0; i < cut_val.length+1; i++){ 
				if(i < cut_val.length) { ctx_Line(ctx, sx+cut*cut_val[i], sy+40, sx+cut*cut_val[i], ey, 'black', 1); }
				ctx_Line(ctx, sx, sy+40*(i+1), ex, sy+40*(i+1), 'black', 1);
				ctx_fillText(ctx, sx+cut*0.5, sy+20+40*(i+1), col_head[i], 'black', vTextStyleBold, 'center','middle');
				if(i == 2){ ctx_wrapText(ctx, sx+cut+20, sy+20+40*(i+1), col_data[i], 'black', '14px 맑은고딕', 'left','middle', 350, 20);} // 주소
				else { ctx_fillText(ctx, sx+cut+20, sy+20+40*(i+1), col_data[i], 'black', vTextStyle, 'left','middle'); }
				ctx_fillText(ctx, sx+cut*3.5, sy+20+40*(i+1), col_head[i+4], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, sx+cut*4+20, sy+20+40*(i+1), col_data[i+4], 'black', vTextStyleBold, 'left','middle');
			}
		}		
		
	}
	// 점검표
	var sum = 0;	
	var SubdataText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var col_head = ['구분	','NO', '세부평가항목', '평가기준', '배점', '평 가 점 수', '비고'];
			var cut = (ex-10)/26;
			var text_hgt = SubdataText_HeightStart +20;
			var detail_data = [<%=DetailArray.toString()%>];
			var cnt_data = [<%=CntArray.toString()%>];		
			var cut_val = [1,4,5,10,20,22,24];
			ctx_Line(ctx, sx, sy+50, ex, sy+50, 'black', 1);
			for(var i = 0; i < cut_val.length+1; i++){ 
				if(i < cut_val.length) { 
					if(i < 1){ ctx_Line(ctx, sx+cut*cut_val[i], sy+50, sx+cut*cut_val[i], ey-110, 'black', 1); } 
					else if(i < 4) { ctx_Line(ctx, sx+cut*cut_val[i], sy, sx+cut*cut_val[i], ey-30, 'black', 1); }
					else{ ctx_Line(ctx, sx+cut*cut_val[i], sy, sx+cut*cut_val[i], ey, 'black', 1); }
				}			
			}
			// 컬럼헤드
			ctx_fillText(ctx, sx+cut*cut_val[0]+20, sy+25, col_head[0], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*cut_val[1]+2, sy+25, col_head[1], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*(cut_val[2]+1), sy+25, col_head[2], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*(cut_val[3]+3.5), sy+25, col_head[3], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*cut_val[4]+15, sy+25, col_head[4], 'black', vTextStyleBold, 'left','middle');
			ctx_wrapText(ctx, sx+cut*cut_val[5]+15, sy+25, col_head[5], 'black', vTextStyleBold, 'left','middle', 60, 20);
			ctx_fillText(ctx, sx+cut*cut_val[6]+15, sy+25, col_head[6], 'black', vTextStyleBold, 'left','middle');
		    
			var as_standard_value = [5,5,5,5,5,3,5,5,5,5,5,3,5,6,6,6,6,5,3,6,5,5,2,10,5,5,3,7,7,5,7,10,10,10,10];
			var row_cnt = 0;
			(<%=RowCount%> < 36) ? row_cnt = 35 : row_cnt = <%=RowCount%>;
			var div_data = [5,12,23,27,31,32,33];
			for(var i = 0; i <row_cnt; i++){
				if(i == 4){
					ctx_Line(ctx, sx, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*2.5, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
					ctx_wrapText(ctx, sx+10, sy+100, '서류평가', 'black', 'bold 13px 맑은고딕', 'left','middle', 20, 20);
				} else if (i == 11) {
					ctx_Line(ctx, sx+cut, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*9, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
					ctx_wrapText(ctx, sx+10, sy+400, '위생관리상태', 'black', 'bold 13px 맑은고딕', 'left','middle', 20, 20);
				} else if (i == 22) {
					ctx_Line(ctx, sx+cut, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*17.5, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else if (i == 26) {
					ctx_Line(ctx, sx+cut, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*25, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else if (i == 30) {
					ctx_Line(ctx, sx, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*29, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else if (i == 31) {
					ctx_Line(ctx, sx, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*32, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else if (i == 32) {
					ctx_Line(ctx, sx, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);					
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*33, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else if (i == 34 ){
					ctx_Line(ctx, sx, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
					ctx_wrapText(ctx, sx+cut*cut_val[0]+10, sy+40+20*34.5, detail_data[i][2], 'black', 'bold 13px 맑은고딕', 'left','middle', 100, 20);
				} else {		
					ctx_Line(ctx, sx+cut*4, sy+50+20*(i+1), ex, sy+50+20*(i+1), 'black', 1);
				}
				ctx_fillText(ctx, sx+cut*cut_val[1]+10, sy+40+20*(i+1), parseInt(detail_data[i][0])+1, 'black', 'bold 14px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*cut_val[2]+10, sy+40+20*(i+1), detail_data[i][3], 'black', '13px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*cut_val[3]+10, sy+40+20*(i+1), detail_data[i][4], 'black', '13px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*cut_val[4]+10, sy+40+20*(i+1), as_standard_value[i], 'black', 'bold 14px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*cut_val[5]+10, sy+40+20*(i+1), detail_data[i][5], 'black', 'bold 14px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*cut_val[6]+10, sy+40+20*(i+1), detail_data[i][6], 'black', '13px 맑은고딕', 'left','middle');
			}
			sum = 0;
			var std_sum = 0;
			for(var i=0; i<(parseInt(row_count)); i++){ 
				sum = parseInt(sum) + parseInt(detail_data[i][5]); 
				std_sum = parseInt(std_sum) + parseInt(as_standard_value[i]);
			}
			ctx_fillText(ctx, sx+cut*10, sy+45+20*(36), '총   계', 'black', 'bold 14px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*cut_val[4]+10, sy+45+20*(36), std_sum + " 점", 'black', 'bold 14px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*cut_val[5]+10, sy+45+20*(36), sum + " 점", 'black', 'bold 14px 맑은고딕', 'left','middle');
			
		}		
	};
	// 평가
	var TotalText = {		
		col_head_width:[900],		
		drawText(ctx, sx, sy, ex, ey) { // 표1 양식 그리기			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var cut = (ex-10)/26;
			ctx_Line(ctx, sx+cut*4, sy, sx+cut*4, ey, 'black', 1);
			ctx_Line(ctx, sx, sy+40, ex, sy+40, 'black', 1); 
			ctx_fillText(ctx, sx+cut+10, sy+20, '평가점수', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*8+10, sy+20, sum, 'black', 'bold 13px 맑은고딕', 'left','middle');
			var result1 = '□';
			var result2 = '□';
			var result3 = '□';
			if(sum > 170) {
				var result1 = '■';
			} else if(sum > 140) {
				var result2 = '■';
			} else {
				var result3 = '■';
			}
			ctx_fillText(ctx, sx+cut*9+10, sy+20, '점 ( '+result1+' 적합   '+result2+' 부적합   '+result3+' 보완)', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*4+10, sy+60, '170 ~ 200점 : 적합, 139 ~ 169점 : 보완', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*4+10, sy+90, '138점 이하 : 부적합', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut+10, sy+80, '평가기준', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_Line(ctx, sx+cut*17, sy+40, sx+cut*17, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*21, sy+40, sx+cut*21, ey, 'black', 1);
			ctx_fillText(ctx, sx+cut*18+10, sy+80, '평가주기', 'black', 'bold 13px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, sx+cut*22+10, sy+80, '1년', 'black', 'bold 13px 맑은고딕', 'left','middle');
		}	
	} ;
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>