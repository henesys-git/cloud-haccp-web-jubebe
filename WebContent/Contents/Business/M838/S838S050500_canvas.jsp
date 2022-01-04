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
조도 점검표 canvas (M838S015400_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	DoyosaeTableModel CountTableModel;

	String GV_WRITE_DATE = "", GV_APPROVAL = "", CLEANER_REG_DATE="";
	
	if(request.getParameter("WriteDate")== null)
		GV_WRITE_DATE ="";
	else
		GV_WRITE_DATE = request.getParameter("WriteDate");
	
	if(request.getParameter("cleaner_reg_date")== null)
	CLEANER_REG_DATE = "";
	else
	CLEANER_REG_DATE = request.getParameter("cleaner_reg_date");
	
	if(request.getParameter("Approval")== null)
		GV_APPROVAL ="";
	else
		GV_APPROVAL = request.getParameter("Approval");

	String cleaner_reg_date = CLEANER_REG_DATE.replace("-", "");
	
	String CLEANER_REG_DATE_YEAR = cleaner_reg_date.substring(0, 4);
	String CLEANER_REG_DATE_MONTH = cleaner_reg_date.substring(4, 6);
	String CLEANER_REG_DATE_DAY = cleaner_reg_date.substring(6, 8);
	
	JSONObject jArray = new JSONObject();
	JSONObject jArray2 = new JSONObject();
	
	jArray.put( "write_date", GV_WRITE_DATE);
	jArray.put( "cleaner_reg_date", CLEANER_REG_DATE);
	jArray.put( "cleaner_reg_date_year", CLEANER_REG_DATE_YEAR);
	jArray.put( "cleaner_reg_date_month", CLEANER_REG_DATE_MONTH);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S050500E144", jArray);
 	int RowCount =TableModel.getRowCount();
 	
 	
    DoyosaeTableModel PartTableModel = new DoyosaeTableModel("M838S050500E154", jArray);
 	int PartTableCount =PartTableModel.getRowCount();
	int Row = RowCount/9;
 	
	StringBuffer DataArray_part_cd = new StringBuffer();
	DataArray_part_cd.append("[");
 	for(int i=0; i<PartTableCount; i++){
 		DataArray_part_cd.append("[");
 		DataArray_part_cd.append( "'" + PartTableModel.getValueAt(i, 1).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
 		DataArray_part_cd.append( "'" + PartTableModel.getValueAt(i, 2).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
 		DataArray_part_cd.append( "'" + PartTableModel.getValueAt(i, 0).toString().trim() + "'" + "," ); // working_process(check_gubun_mid)
 		DataArray_part_cd.append( "'" + PartTableModel.getValueAt(i, 3).toString().trim() + "'" ); // working_process(check_gubun_mid)
		if(i==PartTableCount-1) DataArray_part_cd.append("]");
		else DataArray_part_cd.append("],");
	}
 	DataArray_part_cd.append("]");
 	
 	// 출고량 및 날짜 데이터
	StringBuffer DataArray_Part_Date = new StringBuffer();
	DataArray_Part_Date.append("[");
	for(int i=0; i<RowCount; i++) {
		DataArray_Part_Date.append("[");
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 7).toString().trim() + "'" + "," ); // part_cd
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 6).toString().trim() + "'" + "," ); // part_nm
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'" + "," ); // cleaner_usage
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 4).toString().trim() + "'" + "," ); // cleaner_reg_date_month
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'" + "," ); // cleaner_reg_date_day
		DataArray_Part_Date.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'" ); 		// usage_amt
		if(i==RowCount-1) DataArray_Part_Date.append("]");
		else DataArray_Part_Date.append("],");
	}
	DataArray_Part_Date.append("]");

	
	
	System.out.println("DataArray_Part_Date1: " + DataArray_Part_Date);
	System.out.println("DataArray_part_cd: " + DataArray_part_cd);
	
	
%>

<script type="text/javascript">	
	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 18px 맑은고딕';
<%-- 	var detail_data = [<%=DetailArray.toString()%>];  --%>
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 
	var row_count = <%=RowCount%>;
	var row = <%=Row%>;
	var SubdataText_HeightStart = HaedText_HeightEnd;
	if(row > 8){
		var SubdataText_HeightEnd = SubdataText_HeightStart + (parseInt(row)+1)*120 +100; // 점검관련사항 영역 종료 높이
	} else {
		var SubdataText_HeightEnd = SubdataText_HeightStart + 960 + 100; // 점검관련사항 영역 종료 높이
	}
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 0; // 캔버스영역 안쪽 여백
    	var CanvasWidth = SubdataText.col_head_width[0]; // 캔버스영역 너비
    	var CanvasHeight = SubdataText_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
		
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
	    SubdataText.drawText(ctx, pointSX, pointSY + SubdataText_HeightStart, pointEX, pointSY + SubdataText_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var middle_info = '세척·소독제 사용 기록부' ;
			var cut = ex/9
// 			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');		
			ctx_fillText(ctx, (sx+ex)/2-100, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			var write_date = '<%=GV_WRITE_DATE%>'.split('-');
<%-- 			ctx_fillText(ctx, sx, ey-20, ' ■ 작 성 일 : ' + write_date[0] +' 년  ' + write_date[1] +' 월  ' + write_date[2] +' 일  ' + blank_tab + blank_tab + ' ■ 검 증 자 : ' + '<%=GV_WRITER%>', 'black', 'bold 16px 맑은고딕', 'start','top'); --%>
			ctx_fillText(ctx, sx, ey+9, ' ■ 작 성 일 : ' + '<%=CLEANER_REG_DATE_YEAR%>년  ' +'<%=CLEANER_REG_DATE_MONTH%>월 ', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+650, ey+9, '*출고량을 반드시 기록해주세요', 'red', 'bold 16px 맑은고딕', 'start','top');
			
			ctx_Line(ctx, ex-cut, sy+15, ex-cut, ey, 'black', 1);
			ctx_Line(ctx, ex-cut*2, sy+15, ex-cut*2, ey, 'black', 1);
			ctx_Line(ctx, ex-cut*2, sy+45, ex, sy+45, 'black', 1);
			
			ctx_fillText(ctx, ex-cut*1.5-20, sy+25, '작 성', 'black', vTextStyleBold, 'start','top');
<%-- 		ctx_fillText(ctx, ex-cut*1.5-40, sy+70, '<%=GV_WRITER%>', 'black', vTextStyleBold, 'start','top'); --%>
			ctx_fillText(ctx, ex-cut*0.5-20, sy+25, '승 인', 'black', vTextStyleBold, 'start','top');
<%-- 		ctx_fillText(ctx, ex-cut*0.5-40, sy+70, '<%=GV_APPROVAL%>', 'black', vTextStyleBold, 'start','top'); --%>
			
		} // HeadText.drawText function end
	} ;

	// 검출정보
	var SubdataText = {

		col_head_width:[900],
		DataArray_part_cd   : <%=DataArray_part_cd%>, 
		DataArray_Part_Date  : <%=DataArray_Part_Date%>, 
<%-- 		DataArray_Data  : <%=DataArray_Data%>,  --%>
		Part_Count  : <%=PartTableCount%>, 
		Row_Count   : <%=RowCount%>, 
		
		drawText(ctx, sx, sy, ex, ey) {
			
			var conStart = sy+36.5*2;
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)			
			
			ctx_Line(ctx, sx, conStart-37, ex, conStart-37, 'black', 1);	// 작성일 끝나는 라인칸
			ctx_Line(ctx, sx, conStart, ex, conStart, 'black', 1);	// 컬럼 구분 가로줄
			
			// 두꺼운 가로줄
			for(i=0; i<12; i++) {
				ctx_Line(ctx, sx+260, 	conStart+82*i, 	ex, conStart+82*i, 'black', 1);
			}
			ctx_Line(ctx, sx, 		conStart+82*4, 	ex, conStart+82*4, 'black', 1);
 			ctx_Line(ctx, sx, 		conStart+82*8, 	ex, conStart+82*8, 'black', 1);
			
			for(i=0; i<24; i++) {
				ctx_Line(ctx, sx+260, 	conStart+41*i, 		ex, conStart+41*i, 		'black', 1);
			}		

			// 세로줄 
			ctx_Line(ctx, sx+128, sy+35, sx+128, sy+1300, 'black', 1);
 			ctx_Line(ctx, sx+260, sy+35, sx+260, sy+1300, 'black', 1);
 			
 			// contents 부분 세로줄
 			ctx_Line(ctx, sx+260+128, conStart, sx+260+128, sy+1300, 'black', 1);
 			ctx_Line(ctx, sx+260+128*2, conStart, sx+260+128*2, sy+1300, 'black', 1);
 			ctx_Line(ctx, sx+260+128*3, conStart, sx+260+128*3, sy+1300, 'black', 1);
 			ctx_Line(ctx, sx+260+128*4, conStart, sx+260+128*4, sy+1300, 'black', 1); 			 			
						
			// col text
			ctx_fillText(ctx, sx+50, sy+47, '품명', 'black', 'bold 16px 맑은고딕', 'start','top');			
			ctx_fillText(ctx, sx+163, sy+47, '사용용도', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+550, sy+47, '출      고      량', 'black', 'bold 16px 맑은고딕', 'start','top');			
			
			var plus = 225;
			var plus2 = 0;
			var plus_x = 298;
			var plus_x2 = 335;
			var plus_x3 = 325;
			var plus_y = 85;
			var plus_y2 = 126;
			
			for(i=0; i<this.Part_Count; i++) {
// 				alert(i + "번째 puls : " + plus);
				ctx_wrapText(ctx, sx+65,  sy+plus, this.DataArray_part_cd[i][2], 'black', 'bold 16px 맑은고딕', 'center', 'top', 100, 17);
				ctx_wrapText(ctx, sx+193, sy+plus, this.DataArray_part_cd[i][3], 'black', 'bold 16px 맑은고딕', 'center', 'top', 100, 17);	
				plus += 330;
			}
			
			var part_count= [0,0,0];
			for(i=0; i<this.Part_Count; i++) {
				plus_x = 298; plus_x2 = 335; plus_x3 = 325;
// 				for(y=0; y<20; y++ ) {
					for(j=0; j<this.Row_Count; j++) {
						if(this.DataArray_part_cd[i][0] == this.DataArray_Part_Date[j][0]) {
							if(part_count[i]==5) {plus_y += 82; plus_y2 += 83;  plus_x = 298; plus_x2 = 335; plus_x3 = 325;}
							part_count[i]++;
							ctx_wrapText(ctx, sx+plus_x, sy+plus_y+plus2, this.DataArray_Part_Date[j][3], 'black', 'vTextStyle', 'left', 'top', 400, 17);
							ctx_wrapText(ctx, sx+plus_x2, sy+plus_y+plus2, this.DataArray_Part_Date[j][4], 'black', 'vTextStyle', 'left', 'top', 400, 17);
							ctx_wrapText(ctx, sx+plus_x3, sy+plus_y2+plus2, this.DataArray_Part_Date[j][5], 'black', 'vTextStyle', 'center', 'top', 400, 17);
							if(j==1) { plus_x += 130;  plus_x2 += 130; plus_x3 += 126;}
							else { plus_x += 125; plus_x2 += 125;  plus_x3 += 126;}
						}
					} plus2 += 330
			}
			
			for (i=0; i<12; i++) {
				ctx_fillText(ctx, sx+315, conStart+8+82*i, '	/	', 'black', 'bold 20px 맑은고딕', 'start','top');
				ctx_fillText(ctx, sx+444, conStart+8+82*i, '	/	', 'black', 'bold 20px 맑은고딕', 'start','top');
		  		ctx_fillText(ctx, sx+569, conStart+8+82*i, '	/	', 'black', 'bold 20px 맑은고딕', 'start','top');	
		  		ctx_fillText(ctx, sx+694, conStart+8+82*i, '	/	', 'black', 'bold 20px 맑은고딕', 'start','top');	
		  		ctx_fillText(ctx, sx+819, conStart+8+82*i, '	/	', 'black', 'bold 20px 맑은고딕', 'start','top');						
			}
			
		}		
	};

</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>