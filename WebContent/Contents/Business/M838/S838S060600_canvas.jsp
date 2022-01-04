<%@page import="java.io.Console"%>
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
설비이력카드 canvas (S838S006100_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModelE174;

	String GV_VHCL_NO="", GV_VHCL_NO_REV="", GV_CHECK_DATE="", GV_CHECK_GUBUN="" ;

	if(request.getParameter("vhcl_no")== null)
		GV_VHCL_NO="";
	else
		GV_VHCL_NO = request.getParameter("vhcl_no");	
	
	if(request.getParameter("vhcl_no_rev")== null)
		GV_VHCL_NO_REV="";
	else
		GV_VHCL_NO_REV = request.getParameter("vhcl_no_rev");
	
	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN="";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	


	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "vhcl_no", GV_VHCL_NO);
	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV);
	jArray.put( "check_date", GV_CHECK_DATE);


	TableModelE174 = new DoyosaeTableModel("M838S060600E174", jArray); 
	int RowCountE174 =TableModelE174.getRowCount();// 전체컬럼개수
	
	DoyosaeTableModel TableModelE194 = new DoyosaeTableModel("M838S060600E194", jArray);
	int RowCountE194 =TableModelE194.getRowCount(); // 
	
	
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	DoyosaeTableModel TableModelE134 = new DoyosaeTableModel("M838S060600E134", jArray);	
	int CheckCount = TableModelE134.getRowCount(); // 체크문항 개수(4)
// 	System.out.println("11111111111111111111111111:"+CheckCount);
	
	
	String check_duration 	= TableModelE174.getValueAt(0, 1).toString().trim();	// 점검일자
	String driver 			= TableModelE174.getValueAt(0, 3).toString().trim();	// 점검자	
	String improve_note 	= TableModelE174.getValueAt(0, 13).toString().trim(); 	// 조치내역및결과
	String improve_date 	= TableModelE174.getValueAt(0, 14).toString().trim();	// 조치완료일시 
	String improve_checker 	= TableModelE174.getValueAt(0, 15).toString().trim(); 	// 조치자
	String confirm_worker 	= TableModelE174.getValueAt(0, 16).toString().trim(); 	// 확인
	String checker 	= TableModelE174.getValueAt(0, 17).toString().trim(); 	// 점검자 확인
	
	
	System.out.println("****improve_checker : " + improve_checker);
	
	
// 	System.out.println("****GV_CHECK_DATE : " + GV_CHECK_DATE);
// 	System.out.println("****************************check_duration : " + check_duration);

	// 데이터 넣기
	StringBuffer check_value = new StringBuffer();
	check_value.append("[");
	if (RowCountE174 > 0) {
		for (int i = 0; i < RowCountE174; i++) {
			check_value.append("'" + TableModelE174.getValueAt(i, 10).toString().trim() + "'"); // check_value
// 			System.out.println("TableModelE174.getValueAt(i, 10).toString().trim() : " + TableModelE174.getValueAt(i, 10).toString().trim());
			if (i == RowCountE174 - 1)
				check_value.append("");
			else
				check_value.append(",");
		}
	}
	check_value.append("]");

	// 결과 값, 일자, 부적합, 개선조치사항
	int CheckRow = RowCountE174 / CheckCount; // 전체에서 체크리스트 개수로 나눈 것
	StringBuffer ideal_details = new StringBuffer();
	ideal_details.append("[");
	for (int i = 0; i < RowCountE194; i++) {
		ideal_details.append("[");
		ideal_details.append("'" + TableModelE174.getValueAt(i, 11).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		ideal_details.append("'" + TableModelE174.getValueAt(i, 12).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		ideal_details.append("'" + TableModelE174.getValueAt(i, 13).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		ideal_details.append("'" + TableModelE174.getValueAt(0, 14).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		ideal_details.append("'" + TableModelE174.getValueAt(0, 15).toString().trim() + "'" + ","); // working_process(check_gubun_mid)
		ideal_details.append("'" + TableModelE174.getValueAt(0, 16).toString().trim() + "'" + ""); // working_process(check_gubun_mid)
		if (i == RowCountE194 - 1)
			ideal_details.append("]");
		else
			ideal_details.append("],");
	}
	ideal_details.append("]");

	// 		System.out.println("data_sub : " + data_sub);
// 	System.out.println("CheckRow : " + CheckRow);
// 	System.out.println("RowCountE194 : " + RowCountE194);
// 	System.out.println("ideal_details : " + ideal_details);
%>

<script type="text/javascript">	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	
	// 표0 영역
	var DataGrid0_RowHeight = 50; // 표0의 행 높이
	var DataGrid0_RowCount = 4 ; // 표0의 행 개수
	var DataGrid0_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid0_HeightEnd = HaedText_HeightEnd + (DataGrid0_RowCount * DataGrid0_RowHeight);
	
	// 표01 영역
	var DataGrid01_RowHeight = 50; // 표01의 행 높이
	var DataGrid01_RowCount = 1 ; // 표01의 행 개수
	var DataGrid01_Width = 0 ; // doc.ready에서 표01의 각 열너비를 더해서 계산
	var DataGrid01_HeightEnd = DataGrid0_HeightEnd + (DataGrid01_RowCount * DataGrid01_RowHeight);
	
	// 표02 영역
	var DataGrid02_RowHeight = 50; 	// 표02의 행 높이
	var DataGrid02_RowCount = 5 ; 	// 표02의 행 개수
	var DataGrid02_Width = 0 ; 		// doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid02_HeightEnd = DataGrid01_HeightEnd + (DataGrid02_RowCount * DataGrid02_RowHeight);
	
	// 표03 영역	 
	var DataGrid03_RowHeight = 70; 	// 표03의 행 높이
	var DataGrid03_RowCount = 6 ; 	// 표03의 행 개수
	var DataGrid03_Width = 0 ; 		// doc.ready에서 표03의 각 열너비를 더해서 계산
	var DataGrid03_HeightEnd = DataGrid02_HeightEnd + (DataGrid03_RowCount * DataGrid03_RowHeight)-20;
	var person_row = 5;
	var PersonText_HeightStart = DataGrid03_HeightEnd; // 표03 시작위치(헤드텍스트영역 끝 높이)
	var PersonText_HeightEnd = PersonText_HeightStart;
//	var PersonText_HeightEnd = PersonText_HeightStart + (parseInt(person_row)+1)*70;


    $(document).ready(function () {
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = 1000 + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = PersonText_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y
    	
		// 그리기
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd-10);
	    DataGrid0.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointSY + DataGrid0_HeightEnd);
	    DataGrid01.drawGrid(ctx, pointSX, pointSY + DataGrid0_HeightEnd, pointEX, pointSY + DataGrid01_HeightEnd);
	    DataGrid02.drawGrid(ctx, pointSX, pointSY + DataGrid01_HeightEnd, pointEX, pointSY + DataGrid02_HeightEnd);
	    DataGrid03.drawGrid(ctx, pointSX, pointSY + DataGrid02_HeightEnd, pointEX, pointSY + DataGrid03_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백

			var middle_info = '지게차 운행 점검표';
			var rev_date_text = '개정일자 2019.02.27';
// 			var rev_date = '날짜';
			var bottom_info3 = blank_tab+blank_tab+blank_tab+' / ' ;
			var approval_box_width = 300; //결재박스 너비(36 + 칸너비*3)			
			
			ctx_fillColor(ctx, sx, sy, ex-approval_box_width+30, ey, '#cccccc'); // 상단 구분명 배경(회색)
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 전체 틀(사각형)			
			ctx_Line(ctx, sx+200, sy, sx+200, ey, 'black', 1); // 세로선
			
			// 헤드텍스트
			ctx_fillText(ctx, sx+5, sy, 'black', vTextStyle, 'start','top');
			ctx_fillText(ctx, sx+100, sy+63, rev_date_text, 'black', 'bold 16px 맑은고딕', 'center','top');
			ctx_fillText(ctx, sx+310, sy+55, middle_info, 'black', 'bold 36px 맑은고딕', 'start','top');

			// 박스		
			ctx_Line(ctx, ex-approval_box_width+30, sy, ex-approval_box_width+30, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-(approval_box_width-30)*1/3, sy, ex-(approval_box_width-30)*1/3, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-(approval_box_width-30)*2/3, sy, ex-(approval_box_width-30)*2/3, ey, 'black', 1); // 세로선
			ctx_Line(ctx, ex-approval_box_width+30, sy+30, ex, sy+30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-(approval_box_width-30)*5/6, sy+15, '작    성', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*3/6, sy+15, '검    토', 'black', vTextStyle, 'center','middle');
			ctx_fillText(ctx, ex-(approval_box_width-30)*1/6, sy+15, '승    인', 'black', vTextStyle, 'center','middle');
						
		} // HeadText.drawText function end
	} ;

 	var DataGrid0 = {
 		drawGrid(ctx, sx, sy, ex, ey) { 			
 			
 			var sub_num = '점검일자';
 			var suv_num_note = '';
 			var checker_text = '점 검 자';
 			var checker_name = '';
 			var sub_chk_cycle_note = '1회/주';
 			var car_num_text = '차량번호';
 			var car_num = '';
 			var check_cycle_text = '점검주기';
 			var check_cycle = '1회 / 주';
 			
 			
 			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1);			// 표0 전체박스
 			ctx_Line(ctx, sx+400, sy, ex-600, ey, 'black', 1); 	// 세로줄
 			
 			
 			for(i=0; i<4; i++) {
 				ctx_Line(ctx, sx, sy+50*i, ex, sy+50*i, 'black', 1);	// 가로줄
 			}
 			
 			// text
 			ctx_fillText(ctx, sx+195, sy+20, sub_num, 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+195, sy+70, checker_text, 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+195, sy+120, car_num_text, 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+195, sy+170, check_cycle_text, 'black', 'bold 15px 맑은고딕', 'center','top'); 		
 			
 			// text_data
 			ctx_fillText(ctx, sx+670+40, sy+20, '<%=check_duration%>', 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+670+40, sy+70, '<%=driver%>', 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+670+40, sy+120, '<%=GV_VHCL_NO%>', 'black', 'bold 15px 맑은고딕', 'center','top');
 			ctx_fillText(ctx, sx+670+40, sy+170, check_cycle, 'black', 'bold 15px 맑은고딕', 'center','top');
 		}
 	};
 	
 	var DataGrid01 = {
 		drawGrid(ctx, sx, sy, ex, ey) { 		
 			 			
 			var oil_change_cycle_1 = "엔진오일/미션오일";
 			var oil_change_cycle_2 = "교환주기";
 			var cycle_num = "6개월/400시간";
 			var exchanges_date = "차기교환예정";
 			var exchanges_time = "4043HR";
 			
 			ctx_fillText(ctx, sx+40, sy+9, oil_change_cycle_1, 'black', 'bold 15px 맑은고딕', 'start','top');
 			ctx_fillText(ctx, sx+250, sy+20, cycle_num, 'black', 'bold 15px 맑은고딕', 'start','top');
 			ctx_fillText(ctx, sx+70, sy+28, oil_change_cycle_2, 'black', 'bold 15px 맑은고딕', 'start','top');
 			ctx_fillText(ctx, sx+500, sy+20, exchanges_date, 'black', 'bold 15px 맑은고딕', 'start','top');
 			ctx_fillText(ctx, sx+780+45, sy+20, exchanges_time, 'black', 'bold 15px 맑은고딕', 'start','top');
 			
 			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1);			// 표0 전체박스 	
 			ctx_Line(ctx, sx+400, sy, ex-600, ey, 'black', 1); 	// 세로줄 	 	
 			ctx_Line(ctx, sx+200, sy, sx+200, ey, 'black', 1); // 세로선
 			ctx_Line(ctx, sx+700, sy, sx+700, ey, 'black', 1); // 세로선
 				
		}
 	};
 	
 	var DataGrid02 = {
 			
 	 		drawGrid(ctx, sx, sy, ex, ey) { 				 			
 	 			
 	 			var start = sy+15;
 	 			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1);// 전체박스
 	 			 	 			
	 			ctx_Line(ctx, sx, sy+50, ex, sy+50, 'black', 1);	// 가로줄
 	 			ctx_Line(ctx, sx, sy+100, ex, sy+100, 'black', 1);	// 가로줄
 	 			ctx_Line(ctx, sx, sy+150, ex, sy+150, 'black', 1);	// 가로줄
 	 			ctx_Line(ctx, sx, sy+200, ex, sy+200, 'black', 1);	// 가로줄
 	 			ctx_Line(ctx, sx, sy+250, ex, sy+250, 'black', 1);	// 가로줄
//  	 			ctx_Line(ctx, sx, sy+300, ex, sy+300, 'black', 1);	// 가로줄
 	 			
 	 			ctx_Line(ctx, sx+400, sy, ex-600, ey, 'black', 1); 	// 세로줄 	 	

 	 			var external_chk	= '운행 전 외부 이상은 없는가?';
 	 			var operation_chk	= '동작상태는 이상이 없는가?';
 	 			var arrange_chk		= '운행 후 차량 정리 정돈을 하였는가?';
 	 			var driving_time	= '주 행 시 간';
 	 			var inspector_chk	= '점검자 확인'; 	 			
 	 			
 	 			var check_value = <%=check_value%>;
//  	 			alert("check_value : " + check_value);
 	 			
 	 			ctx_fillText(ctx, sx+195, sy+20, external_chk, 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+195, sy+70, operation_chk, 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+195, sy+120, arrange_chk, 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+195, sy+170, driving_time, 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+195, sy+220, inspector_chk, 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			
 	 			
 	 			ctx_fillText(ctx, sx+670+40, sy+20, check_value[0], 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+670+40, sy+70, check_value[1], 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+670+40, sy+120, check_value[2], 'black', 'bold 15px 맑은고딕', 'center','top');
 	 			ctx_fillText(ctx, sx+670+40, sy+170, check_value[3], 'black', 'bold 15px 맑은고딕', 'center','top');
// 	  	 		ctx_fillText(ctx, sx+670+40, sy+220, check_value[4], 'black', 'bold 15px 맑은고딕', 'center','top');
	  	 		ctx_fillText(ctx, sx+670+40, sy+220, '<%=checker%>', 'black', 'bold 15px 맑은고딕', 'center','top');
 			}
 	 	};	
 	
 	var DataGrid03 = {
 			
 			col_head_width:[900],		
 			drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기			
 				
 				var blank_tab = '    '; // 4칸 공백
 				var col_head = ['이상발생일시', '이상발생내역', '조치내역 및 결과', '조치완료일시', '조치자', '확인']; 				
 				var start = sx+50;
 				var person_data = ['','','','','','','']; 
 				var col_person = ['이','상','발','생','내','역'];
 				var col_person_hgt = PersonText_HeightEnd - PersonText_HeightStart;
 				var occurrence_date	= '이상발생일시';
 				var details 		= '이상발생내역';
 				var results 		= '조치내역 및 결과';
 				var completion_date = '조치완료일시';
 				var action_maker 	= '조치자'; 
 				var occurrence_check = '확인'; 				

				ctx_fillColor(ctx, sx+50, sy, ex, ey-350, '#A3D9DC'); // 상단 구분명 배경(하늘색)
 				ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)

 				for(var i=0; i<8; i++){ 					
 					
 					ctx_Line(ctx, sx+50, sy, ex-950, ey, 'black', 1); 		// 세로줄
 					ctx_Line(ctx, sx+50, sy+50, ex, ey-350, 'black', 1);	// 가로줄
 					
 					// 이상발생내역 세로줄 
 					if(i < 6) { 
 						
 						ctx_fillText(ctx, sx+15, sy+55*(i+1), col_person[i], 'black', 'bold 16px 맑은고딕', 'start','middle');
 					}					
 				}
 				
 				// 가로줄
 				for(var i=1; i<person_row; i++) { 
 					
 					ctx_Line(ctx, sx+50, sy+50+70*(i), ex, sy+50+70*(i), 'black', 1); 					
 				}
 				
 				ctx_Line(ctx, sx+200, sy, ex-800, ey, 'black', 1); 		// 세로줄 	
 				ctx_Line(ctx, sx+400, sy, ex-600, ey, 'black', 1); 		// 세로줄 	
 				ctx_Line(ctx, sx+650, sy, ex-350, ey, 'black', 1); 		// 세로줄
 				ctx_Line(ctx, sx+800, sy, ex-200, ey, 'black', 1); 		// 세로줄
 				ctx_Line(ctx, sx+900, sy, ex-100, ey, 'black', 1); 		// 세로줄
 				
 				ctx_fillText(ctx, sx+77, sy+17, occurrence_date, 'black', 'bold 15x 맑은고딕', 'start','top');
 				ctx_fillText(ctx, sx+250, sy+17, details, 'black', 'bold 15x 맑은고딕', 'start','top');
 				ctx_fillText(ctx, sx+460, sy+17, results, 'black', 'bold 15x 맑은고딕', 'start','top');
 				ctx_fillText(ctx, sx+680, sy+17, completion_date, 'black', 'bold 15x 맑은고딕', 'start','top');
 				ctx_fillText(ctx, sx+828, sy+17, action_maker, 'black', 'bold 15x 맑은고딕', 'start','top');
 				ctx_fillText(ctx, sx+930, sy+17, occurrence_check, 'black', 'bold 15px 맑은고딕', 'start','top');
 				
 				var col_data = <%=ideal_details%>;
//  				var count = 5;
 				var plus_y = 0;
 				console.log("<%=ideal_details.toString()%>");
//  				for(j=0; j<count; j++) {
 					for(i = 0; i < '<%=RowCountE194%>'; i++) {
<%--  					alert('<%=improve_checker%>'); --%>
	 					ctx_wrapText(ctx, sx+120, sy+85+plus_y, col_data[i][0], 'black', vTextStyle, 'center','middle', 100, 17); 	// 이상발생일시
	 					ctx_wrapText(ctx, sx+300, sy+85+plus_y, col_data[i][1], 'black', vTextStyle, 'center','middle', 100, 17); 	// 이상발생내역
	 					ctx_wrapText(ctx, sx+520, sy+85+plus_y, col_data[i][2], 'black', vTextStyle, 'center','middle', 100, 17); 	// 조치내역 및 결과
	 					ctx_wrapText(ctx, sx+720+5, sy+85+plus_y, col_data[i][3], 'black', vTextStyle, 'center','middle', 100, 17); // 조치완료일시
	 					ctx_wrapText(ctx, sx+850, sy+85+plus_y, col_data[i][4], 'black', vTextStyle, 'center','middle', 100, 17); 	// 조치자
	 					ctx_wrapText(ctx, sx+950, sy+85+plus_y, col_data[i][5], 'black', vTextStyle, 'center','middle', 100, 17); 	// 확인 					
 					plus_y += 70;
	 				} 				
//  				}

//  				ctx_wrapText(ctx, sx+300, sy+85+70, col_data[0][1], 'black', vTextStyle, 'center','middle', 100, 17); 	// 이상발생내역
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