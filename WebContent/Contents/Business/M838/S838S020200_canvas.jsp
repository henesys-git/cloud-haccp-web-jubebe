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
	DoyosaeTableModel TableModelE134;

	String GV_WRITE_DATE = "", GV_APPROVAL = "", CHECK_DURATION="", GV_CHECK_GUBUN = "";
	
	if(request.getParameter("WriteDate")== null)
		GV_WRITE_DATE ="";
	else
		GV_WRITE_DATE = request.getParameter("WriteDate");
	
	if(request.getParameter("check_duration")== null)
		CHECK_DURATION ="";
	else
		CHECK_DURATION = request.getParameter("check_duration");
	
	if(request.getParameter("Approval")== null)
		GV_APPROVAL ="";
	else
		GV_APPROVAL = request.getParameter("Approval");
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
		else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "write_date", GV_WRITE_DATE);
	jArray.put( "check_duration", CHECK_DURATION);
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	
    TableModel = new DoyosaeTableModel("M838S020200E144", jArray);
    int RowCount =TableModel.getRowCount();
    
    TableModelE134 = new DoyosaeTableModel("M838S020200E134", jArray);
    int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(11)
    
    
    DoyosaeTableModel TableModelE154 = new DoyosaeTableModel("M838S020200E154", jArray);
    int Checkdate_Count = TableModelE154.getRowCount(); // 체크문항 개수(11)
	int Row = RowCount/9;
    
// 	상단 입고 날짜 
	String check_duration = CHECK_DURATION.replace("-", "");

	int check_duration_YEAR = Integer.parseInt(check_duration.substring(0, 4));
	int check_duration_MONTH = Integer.parseInt(check_duration.substring(4, 6));
	int check_duration_DAY = Integer.parseInt(check_duration.substring(6, 8));
	
	int check_duration_YEAR2 = Integer.parseInt(check_duration.substring(9, 13));
	int check_duration_MONTH2 = Integer.parseInt(check_duration.substring(13, 15));
	int check_duration_DAY2 = Integer.parseInt(check_duration.substring(15, 17));
	
	// 날짜
	StringBuffer DataArray_checkDate = new StringBuffer();
	DataArray_checkDate.append("[");
	for (int i = 0; i < Checkdate_Count; i++) {
		DataArray_checkDate.append("[");
		DataArray_checkDate.append("'" + TableModelE154.getValueAt(i, 0).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		DataArray_checkDate.append("'" + TableModelE154.getValueAt(i, 1).toString().trim() + "'" ); // working_process(check_gubun_mid)
		if (i == Checkdate_Count - 1)
	DataArray_checkDate.append("]");
		else
	DataArray_checkDate.append("],");
	}
	DataArray_checkDate.append("]");
	
	
	// 온도&습도 기준값
	StringBuffer DataArray_StandardGuide = new StringBuffer();
	DataArray_StandardGuide.append("[");
	for (int i = 0; i < CheckCount; i++) {
		DataArray_StandardGuide.append("[");
		DataArray_StandardGuide.append("'" + TableModelE134.getValueAt(i, 6).toString().trim() + "'"); // working_process(check_gubun_mid)
		if (i == CheckCount - 1)
	DataArray_StandardGuide.append("]");
		else
	DataArray_StandardGuide.append("],");
	}
	DataArray_StandardGuide.append("]");
	
	
	// 온도&습도 데이터
	int CheckRow = RowCount / CheckCount;
	StringBuffer DataArray_CheckValue = new StringBuffer();
	DataArray_CheckValue.append("[");
	if (RowCount >= CheckCount) {
		for (int i = 0; i < CheckRow; i++) {
			// 표1 데이터
			StringBuffer data_sub = new StringBuffer();
			data_sub.append("[");
			for (int j = 0; j < CheckCount; j++) {
				int CheckIndex = i * CheckCount + j;
				System.out.print("CheckIndex : " + CheckIndex);
				data_sub.append("'" + TableModel.getValueAt(CheckIndex, 14).toString().trim() + "',"); // 결과값 check_value
			}
			data_sub.append("'" + TableModel.getValueAt(i * CheckCount, 16).toString().trim() + "'"); // 점검자  U1.user_nm
			if (i == CheckRow - 1) {
				data_sub.append("]");
			} else {
				data_sub.append("],");
			}
			DataArray_CheckValue.append(data_sub);
		}
	}
	DataArray_CheckValue.append("]");

	//온도&습도 데이터
	StringBuffer DataArray_data2 = new StringBuffer();
	DataArray_data2.append("[");
	for (int i = 0; i < RowCount; i++) {
		System.out.println("RowCount : " + RowCount + " / i : " + i + " / CheckRow : " + CheckRow);
		DataArray_data2.append("[");
		DataArray_data2.append("'" + TableModel.getValueAt(i, 1).toString().trim().replace("-", "/").substring(5, 10) + "'" + ","); // working_process(check_gubun_mid)
		DataArray_data2.append("'" + TableModel.getValueAt(i, 20).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		DataArray_data2.append("'" + TableModel.getValueAt(i, 21).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		DataArray_data2.append("'" + TableModel.getValueAt(i, 22).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		DataArray_data2.append("'" + TableModel.getValueAt(i, 23).toString().trim() + "'"); // working_process(check_gubun_mid)
		i += 10; // 체크항목 개수만큼 더해주기
		if (i == RowCount - 1)
			DataArray_data2.append("]");
		else
			DataArray_data2.append("],");
	}
	DataArray_data2.append("]");

	// 	String aa = TableModel.getValueAt(0, 1).toString().trim();
	// 	String aa1 = aa.substring(4,8);

	// 	System.out.println("CheckRow : " + CheckRow + " / " + DataArray_CheckValue);
	System.out.println("DataArray_CheckValue : " + DataArray_CheckValue);
	System.out.println("DataArray_data2 : " + DataArray_data2);
	// 	System.out.println("date2 : " + aa1);
	// 	System.out.println("date1111 : " + TableModel.getValueAt(0, 1).toString().trim().replace("-", "/").substring(5,10));
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
    	var CanvasHeight = SubdataText_HeightEnd + CanvasPadding*2+55+55+10; // 캔버스영역 높이
		
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y

		// 그리기
 	    HeadText.drawText(ctx, pointSX,  pointSY + HeadText_HeightStart-45,  pointEX, pointSY + HaedText_HeightEnd-45);
	    SubdataText.drawText(ctx, pointSX, pointSY + SubdataText_HeightStart-45, pointEX, pointSY + SubdataText_HeightEnd+55+55-45);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var middle_info = '작업장 온습도 점검표' ;
			var cut = ex/9
// 			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');		
			ctx_fillText(ctx, (sx+ex)/2-120, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			var write_date = '<%=GV_WRITE_DATE%>'.split('-');
<%-- 			ctx_fillText(ctx, sx, ey-20, ' ■ 작 성 일 : ' + write_date[0] +' 년  ' + write_date[1] +' 월  ' + write_date[2] +' 일  ' + blank_tab + blank_tab + ' ■ 검 증 자 : ' + '<%=GV_WRITER%>', 'black', 'bold 16px 맑은고딕', 'start','top'); --%>
			ctx_fillText(ctx, sx, ey+8, ' ■ 작 성 일 : ' + parseInt(<%=check_duration_YEAR%>) + ' 년  ' + parseInt(<%=check_duration_MONTH%>) + ' 월  ' + parseInt(<%=check_duration_DAY%>) + ' 일  '  
					+ '~ ' + parseInt(<%=check_duration_YEAR2%>) + ' 년  ' + parseInt(<%=check_duration_MONTH2%>) +' 월  ' + parseInt(<%=check_duration_DAY2%>) + ' 일  ' , 'black', 'bold 16px 맑은고딕', 'start','top');
			
			
			ctx_Line(ctx, ex-cut, sy+15, ex-cut, ey, 'black', 1);
			ctx_Line(ctx, ex-cut*2, sy+15, ex-cut*2, ey, 'black', 1);
			ctx_Line(ctx, ex-cut*2-cut/3, sy+15, ex-cut*2-cut/3, ey, 'black', 1);
			ctx_Line(ctx, ex-cut*2, sy+45, ex, sy+45, 'black', 1);
			
			ctx_fillText(ctx, ex-cut*2-cut/3+5, sy+40, '결', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*2-cut/3+5, sy+80, '재', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*1.5-20, sy+25, '작 성', 'black', vTextStyleBold, 'start','top');
<%-- 			ctx_fillText(ctx, ex-cut*1.5-40, sy+70, '<%=GV_WRITER%>', 'black', vTextStyleBold, 'start','top'); --%>
			ctx_fillText(ctx, ex-cut*0.5-20, sy+25, '승 인', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*0.5-40, sy+70, '<%=GV_APPROVAL%>', 'black', vTextStyleBold, 'start','top');
			
		} // HeadText.drawText function end
	} ;

	// 검출정보
	var SubdataText = {
			
		col_head_width:[900],	 
		DataArray_checkDate : <%=DataArray_checkDate%>, 
		DataArray_StandardGuide : <%=DataArray_StandardGuide%>,
		DataArray_CheckValue : <%=DataArray_CheckValue%>, 
		DataArray_data2 : <%=DataArray_data2%>, 
		
		drawText(ctx, sx, sy, ex, ey) {
			var listStart = sy+35; //sy=120
			var bottomRow = listStart+63*11;
			var bottomChtStart = 933;
			var count = <%=Checkdate_Count%>;
			var count2 = <%=CheckCount%>;
			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)			
			
						
			ctx_Line(ctx, sx, listStart, ex, listStart, 'black', 1);		// 작성일 끝나는 라인칸
			
			// 가로줄 줄간격 100px		
			ctx_Line(ctx, sx+200, 	listStart+63, 	ex, listStart+63, 'black', 1);
			ctx_Line(ctx, sx, 		listStart+63*2, ex, listStart+63*2, 'black', 1);
			ctx_Line(ctx, sx, 		listStart+63*3, ex, listStart+63*3, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*4, ex, listStart+63*4, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*5, ex, listStart+63*5, 'black', 1);
			ctx_Line(ctx, sx, 		listStart+63*6, ex, listStart+63*6, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*7, ex, listStart+63*7, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*8, ex, listStart+63*8, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*9, ex, listStart+63*9, 'black', 1);
			ctx_Line(ctx, sx+70, 	listStart+63*10, ex, listStart+63*10, 'black', 1);
			ctx_Line(ctx, sx, 		listStart+63*11, ex, listStart+63*11, 'black', 1);
			
			// 세로줄
			ctx_Line(ctx, sx+70, listStart, sx+70, sy+727, 'black', 1);
			ctx_Line(ctx, sx+200, listStart, sx+200, sy+727, 'black', 1);
			ctx_Line(ctx, sx+400, listStart, sx+400, sy+782, 'black', 1);
			ctx_Line(ctx, sx+300, listStart+63, sx+300, sy+727, 'black', 1); 		// 온습도 세로줄			
			ctx_Line(ctx, sx+200, listStart, sx+200, sy+664, 'black', 1);
			

			ctx_Line(ctx, sx+400, listStart+31, ex, listStart+31, 'black', 1); 		// 점검일자부분 가로줄	
			
			// 점검일자 세로줄 5개
			ctx_Line(ctx, sx+500, listStart+31, sx+500, listStart+63, 'black', 1);
			ctx_Line(ctx, sx+600, listStart+31, sx+600, listStart+63, 'black', 1);
			ctx_Line(ctx, sx+700, listStart+31, sx+700, listStart+63, 'black', 1);
			ctx_Line(ctx, sx+800, listStart+31, sx+800, listStart+63, 'black', 1);			
			ctx_Line(ctx, sx+400, listStart+94, ex, listStart+94, 'black', 1); 		// 시간부분 가로줄
			
			// 시간부분 세로줄
			ctx_Line(ctx, sx+450, listStart+125, sx+450, listStart+694, 'black', 1);
			ctx_Line(ctx, sx+500, listStart+94, sx+500, listStart+749, 'black', 1);
			ctx_Line(ctx, sx+550, listStart+125, sx+550, listStart+694, 'black', 1);
			ctx_Line(ctx, sx+600, listStart+94, sx+600, listStart+749, 'black', 1);
			ctx_Line(ctx, sx+650, listStart+125, sx+650, listStart+694, 'black', 1);
			ctx_Line(ctx, sx+700, listStart+94, sx+700, listStart+749, 'black', 1);
			ctx_Line(ctx, sx+750, listStart+125, sx+750, listStart+694, 'black', 1);
			ctx_Line(ctx, sx+800, listStart+94, sx+800, listStart+749, 'black', 1);
			ctx_Line(ctx, sx+850, listStart+125, sx+850, listStart+694, 'black', 1);
			ctx_Line(ctx, sx+900, listStart+94, sx+900, listStart+749, 'black', 1);
			ctx_Line(ctx, sx+950, listStart+125, sx+950, listStart+694, 'black', 1);
			
			// 점검일자&시간 데이터
			var plus = 412;
			var plus2 = 420;
			for(i=0; i<count; i++){
				ctx_fillText(ctx, sx+plus, listStart+40, this.DataArray_checkDate[i][0], 'black', vTextStyle, 'start','top');
				ctx_fillText(ctx, sx+plus2, listStart+103, this.DataArray_checkDate[i][1], 'black', vTextStyle, 'start','top');
				
				plus += 100;
				plus2 += 100;
			}
			
			// 아래표 가로줄 줄간격 55px
			ctx_Line(ctx, sx, 		bottomRow+55, ex, bottomRow+55, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*2, ex, bottomRow+55*2, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*3, ex, bottomRow+55*3, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*4, ex, bottomRow+55*4, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*5, ex, bottomRow+55*5, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*6, ex, bottomRow+55*6, 'black', 1);
			ctx_Line(ctx, sx, 		bottomRow+55*7, ex, bottomRow+55*7, 'black', 1);
					
			// 아래표 세로줄(일시, 장소 등등 내용표)
			ctx_Line(ctx, sx+300, bottomChtStart-45, sx+300, ey, 'black', 1); 		// 범례 세로줄
			ctx_Line(ctx, sx+70, bottomChtStart+55-45, sx+70, ey, 'black', 1); 	// 장소 세로줄
			ctx_Line(ctx, sx+400, bottomChtStart+55-45, sx+400, ey, 'black', 1); 	// 이상발생내역 세로줄
			ctx_Line(ctx, sx+700, bottomChtStart+55-45, sx+700, ey, 'black', 1);	// 개선조치 내역 및 결과 세로줄
			
			// text
			ctx_fillText(ctx, sx+18, sy+90, '구분', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+18, sy+175, '청결', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+18, sy+195, '구역', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+18, sy+300, '일반', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+18, sy+320, '구역', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+18, sy+550, '창고', 'black', 'bold 16px 맑은고딕', 'start','top');
			
			ctx_fillText(ctx, sx+105, sy+90, '장    소', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+102, sy+185, '내포장실', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+109, sy+250, '계량실', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+109, sy+310, '배합실', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+102, sy+375, '외포장실', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+109, sy+429, '마가린', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+109, sy+449, '대기실', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+102, sy+490, '원료보관', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+115, sy+510, '창고', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+102, sy+563, '냉장창고', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+95, sy+625, '냉동창고A', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+95, sy+690, '냉동창고B', 'black', 'bold 16px 맑은고딕', 'start','top');
			
			ctx_fillText(ctx, sx+170, sy+748, '점  검  자', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+120, sy+803, '범	례', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+310, sy+791, '점검주기 : 일간 (가동일 기준)', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+310, sy+815, '①실측정 온습도 기록	②가동시간 중 (10:00~16:00) 2회 측정', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+12, sy+860, '일  시', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+150, sy+860, '장      소', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+320, sy+850, '이상발생', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+336, sy+870, '내역', 'black', 'bold 16px 맑은고딕', 'start','top');	
			ctx_fillText(ctx, sx+470, sy+860, '개선조치 내역 및 결과', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+775, sy+860, '조치자', 'black', 'bold 16px 맑은고딕', 'start','top');
						
			ctx_fillText(ctx, sx+270, sy+60, '기    준', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+229, sy+123, '온  도', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+329, sy+123, '습  도', 'black', 'bold 16px 맑은고딕', 'start','top');
			
			ctx_fillText(ctx, sx+600, sy+43, '점  검  일  자', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+620, sy+105, '시    간', 'black', 'bold 16px 맑은고딕', 'start','top');	
			
			// 온도 기준값
			plus = 185;
			for(i=0; i<count2; i++){
				ctx_fillText(ctx, sx+250, sy+plus, this.DataArray_StandardGuide[i], 'black', 'bold 16px 맑은고딕', 'center','top');
				if(i==0 || i==2) {i +=1;}
				plus += 63;
			}
			
			// 습도 기준값
			ctx_fillText(ctx, sx+316, sy+185, '60% 이하', 'black', 'bold 16px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx+316, sy+185+63, '50% 이하', 'black', 'bold 16px 맑은고딕', 'start','top');
			
			// 온도&습도 데이터  DataArray_CheckValue
			var plus_y = 185;
			var plus_x = 425;
			for(i=0; i<this.DataArray_CheckValue.length; i++){
				for(j=0; j<count2+1; j++){
					if(j==1 || j==3) { 
						if(j==1) { plus_y = 185; }
						else if (j==3) {plus_y = 185 + 63;}
						ctx_fillText(ctx, sx+(plus_x+50), sy+plus_y, this.DataArray_CheckValue[i][j] + '%', 'black', '16px 맑은고딕', 'center','top'); 
					}
					else if (j==11){ ctx_fillText(ctx, sx+plus_x+25, sy+plus_y-5, this.DataArray_CheckValue[i][j], 'black', '16px 맑은고딕', 'center','top');}
// 					else if(i==0) {
// 						ctx_fillText(ctx, sx+plus_x, sy+plus_y, this.DataArray_CheckValue[i][j] + '℃', 'black', '16px 맑은고딕', 'center','top'); 
// 					}
					else { ctx_fillText(ctx, sx+plus_x, sy+plus_y, this.DataArray_CheckValue[i][j] + '℃', 'black', '16px 맑은고딕', 'center','top'); }
					plus_y += 63;
				}
				plus_y = 185;
				plus_x += 100;
			}
			
			plus_y = 0;
			for(i=0; i<this.DataArray_data2.length; i++) {
				ctx_wrapText(ctx, sx+33, sy+921+plus_y, this.DataArray_data2[i][0], 'black', vTextStyle, 'center','middle', 50, 17); //부적합시 조치 사항
				ctx_wrapText(ctx, sx+182, sy+921+plus_y, this.DataArray_data2[i][1], 'black', vTextStyle, 'center','middle', 150, 17); //부적합시 조치 사항
				ctx_wrapText(ctx, sx+350, sy+921+plus_y, this.DataArray_data2[i][2], 'black', vTextStyle, 'center','middle', 80, 17); //부적합시 조치 사항
				ctx_wrapText(ctx, sx+548, sy+921+plus_y, this.DataArray_data2[i][3], 'black', vTextStyle, 'center','middle', 270, 17); //부적합시 조치 사항
				ctx_wrapText(ctx, sx+800, sy+921+plus_y, this.DataArray_data2[i][4], 'black', vTextStyle, 'center','middle', 180, 17); //부적합시 조치 사항
				plus_y += 55;
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