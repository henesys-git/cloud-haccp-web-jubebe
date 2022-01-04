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
방충방서 점검표 canvas (S838S020500_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;

	String GV_CHECK_DATE = "";
	
	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE ="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S020500E144", jArray);
 	int RowCount =TableModel.getRowCount();
	
    String check_date="", writor="", approval="",
    		repair_note="", incong_note="", improve_note="", improve_checker="";
    
    if(RowCount>0) {
    	check_date 		= TableModel.getValueAt(0, 0).toString().trim();
    	writor 			= TableModel.getValueAt(0, 1).toString().trim();
    	approval 		= TableModel.getValueAt(0, 2).toString().trim();
    	repair_note 	= TableModel.getValueAt(0, 10).toString().trim();
    	incong_note 	= TableModel.getValueAt(0, 11).toString().trim();
    	improve_note 	= TableModel.getValueAt(0, 12).toString().trim();
    	improve_checker = TableModel.getValueAt(0, 13).toString().trim();
	}
    
	StringBuffer DataArray = new StringBuffer();
	DataArray.append("[");
    for(int i = 0; i < RowCount; i++){
    	DataArray.append("[");			
		DataArray.append("'"+ TableModel.getValueAt(i, 3).toString().trim()  + "',"); // check_gubun_mid             
		DataArray.append("'"+ TableModel.getValueAt(i, 5).toString().trim()  + "',"); // check_gubun_sm      
		DataArray.append("'"+ TableModel.getValueAt(i, 7).toString().trim()  + "',"); // standard_value  
		DataArray.append("'"+ TableModel.getValueAt(i, 8).toString().trim()  + "',"); // check_note
		DataArray.append("'"+ TableModel.getValueAt(i, 9).toString().trim()  + "'"); // check_value  
		if(i==RowCount-1) {
			DataArray.append( "]");
		} else {
			DataArray.append( "],");
		}
	}
    DataArray.append( "]");
	
%>

<script type="text/javascript">	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	// 표 영역
	var SubdataText_HeightStart = HaedText_HeightEnd;
	var SubdataText_HeightEnd = SubdataText_HeightStart + 960 + 100; // 점검관련사항 영역 종료 높이
	
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
			var middle_info1 = '방충·방서 점검표';
			var middle_info2 = '(점검주기 : 매주 수요일)';
			var cut = ex/9;
			ctx_fillText(ctx, sx+150+(ex-sx-150-cut*2-cut/3)/2, sy+40, 
					middle_info1, 'black', 'bold 40px 맑은고딕', 'center','top');
			ctx_fillText(ctx, sx+150+(ex-sx-150-cut*2-cut/3)/2, sy+90, 
					middle_info2, 'blue', vTextStyleBold, 'center','top');
			ctx_Line(ctx, sx+150, sy+15, sx+150, ey-30, 'black', 1); // 로고 세로선
			//결재박스
			ctx_Line(ctx, ex-cut, sy+15, ex-cut, ey-30, 'black', 1);// 작성,승인 사이 세로선
			ctx_Line(ctx, ex-cut*2, sy+15, ex-cut*2, ey-30, 'black', 1);// 결제 text뒤 세로선
 			ctx_Line(ctx, ex-cut*2-cut/3, sy+15, ex-cut*2-cut/3, ey-30, 'black', 1); // 결제 text앞 세로선
			ctx_Line(ctx, ex-cut*2, sy+45, ex, sy+45, 'black', 1); // 결제, 승인 가로선
			ctx_fillText(ctx, ex-cut*2-cut/3+5, sy+40, '결', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*2-cut/3+5, sy+80, '재', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*1.5-20, sy+25, '작 성', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*1.5-40, sy+70, '', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*0.5-20, sy+25, '승 인', 'black', vTextStyleBold, 'start','top');
			ctx_fillText(ctx, ex-cut*0.5-40, sy+70, '', 'black', vTextStyleBold, 'start','top');
			// 점검일자
			ctx_Line(ctx, sx, ey-30, ex, ey-30, 'black', 1); // 가로선
			ctx_fillText(ctx, ex-cut*2-cut/3-85, ey-15, '점검일자 : <%=check_date%>', 'black', vTextStyleBold, 'start','middle');
		} // HeadText.drawText function end
	} ;

	// 검출정보
	var SubdataText = {
		col_head_width:[950],
		col_gubun_sm:['파리','나방','모기','깔다구','기타','합계','바퀴','거미','개미','기타','합계','쥐','기타','합계'],
		col_gubun_sm_code:['0101','0102','0103','0104','0105','0106',
							'0201','0202','0203','0204','0205','0301','0302','0303'],
		col_gubun_sm_x:[50,50,50,50,50,50,50,50,50,50,50,50,50,50],
		col_seolbi_nm:['포충등 1','포충등 2','포충등 3','포충등 4','끈끈이트랩 1','끈끈이트랩 2','끈끈이트랩 3','끈끈이트랩 4'],
		col_seolbi_nm_y:[50,50,50,50,50,50,50,50],
		col_seolbi_loc:['위생전실(일반)','내포장실(청결)','배합실(일반)','외포장실(일반)',
						'외포장실 출입문 내부 좌','외포장실 출입문 내부 우','부재료실 창고 내부 우','원재료 창고 내부 좌'],
		col_data:<%=DataArray%>,
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)	
			// 표1 가로줄
			var listStart = sy+35; //sy=120
			ctx_Line(ctx, sx, listStart, ex, listStart, 'black', 1); // 구분 끝나는 라인칸
			var list1_y_start = listStart+50*2;
			ctx_Line(ctx, sx, list1_y_start, ex, list1_y_start, 'black', 1); //가로선
			for(i=0; i<this.col_seolbi_nm.length; i++) {
				list1_y_start += this.col_seolbi_nm_y[i];
				if(i==3||i==7) {
					ctx_Line(ctx, sx, list1_y_start, ex, list1_y_start, 'black', 1); //가로선
				} else if(i==0||i==1||i==2) {
					ctx_Line(ctx, sx, list1_y_start, sx+250+50*6, list1_y_start, 'black', 1); //가로선
				} else if(i==4||i==5||i==6) {
					ctx_Line(ctx, sx, list1_y_start, sx+250, list1_y_start, 'black', 1); //가로선
					ctx_Line(ctx, sx+250+50*6, list1_y_start, ex, list1_y_start, 'black', 1); //가로선
				}
				var list1_y_center = list1_y_start - this.col_seolbi_nm_y[i]/2;
				ctx_fillText(ctx, sx+50, list1_y_center, this.col_seolbi_nm[i], 'black', vTextStyleBold, 'center','middle');
				ctx_wrapText_space(ctx, sx+175, list1_y_center, this.col_seolbi_loc[i], 'black', 
						vTextStyleBold, 'center', 'middle', 120, this.col_seolbi_nm_y[i]/2-5);
			}
			// 표1 세로줄
			ctx_Line(ctx, sx+100, listStart, sx+100, listStart+500, 'black', 1);
			var list1_x_start = sx+200;
			ctx_fillText(ctx, sx+125, sy+10, '구분', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+400, sy+10, '비래 해충', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+675, sy+10, '보행 해충', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+875, sy+10, '설치류', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+50, sy+75, '설비명', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+175, sy+75, '설치위치', 'black', vTextStyleBold, 'center','top');
			for(i=0; i<this.col_gubun_sm.length; i++) {
				list1_x_start += this.col_gubun_sm_x[i];
				if(i==0||i==6) {
					ctx_Line(ctx, list1_x_start, sy, list1_x_start, listStart+500, 'black', 1);
				} else if(i>0 && i<6) {
					ctx_Line(ctx, list1_x_start, listStart, list1_x_start, listStart+50*6, 'black', 1);
				} else if(i>6 && i<14) {
					if(i==11) {
						ctx_Line(ctx, list1_x_start, sy, list1_x_start, listStart+100, 'black', 1);
					} else {
						ctx_Line(ctx, list1_x_start, listStart, list1_x_start, listStart+100, 'black', 1);
					}
					ctx_Line(ctx, list1_x_start, listStart+50*6, list1_x_start, listStart+500, 'black', 1);
				}
				var list1_x_center = list1_x_start + this.col_gubun_sm_x[i]/2;
				ctx_fillText(ctx, list1_x_center, sy+75, this.col_gubun_sm[i], 'black', vTextStyleBold, 'center','top');
			}
			// 표1데이터
			for(i=0; i<this.col_data.length; i++) {
				var col_data_x_center=0, col_data_y_center=0 ;
				for(j=0; j<this.col_gubun_sm.length; j++) {
					if(this.col_data[i][1] == this.col_gubun_sm_code[j]) {
						col_data_x_center = sx+300 + this.col_gubun_sm_x[j]*j
											- this.col_gubun_sm_x[j]/2;
					}
				}
				for(j=0; j<this.col_seolbi_nm.length; j++) {
					if(this.col_data[i][2] == this.col_seolbi_nm[j]) {
						col_data_y_center = sy+185 + this.col_seolbi_nm_y[j]*j
											- this.col_seolbi_nm_y[j]/2;
					}
				}
				ctx_fillText(ctx, col_data_x_center, col_data_y_center, 
						this.col_data[i][4], 'black', vTextStyle, 'center', 'middle');
			}
			
			
			// 표2
			ctx_fillText(ctx, sx+60, sy+625, '비래해충', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+60, sy+650, '및', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+60, sy+675, '보행해충', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+60, sy+700, '사진', 'black', vTextStyleBold, 'center','top');
			// 표2 가로줄
			ctx_Line(ctx, sx+120, 	listStart+50*10+30, 	ex, listStart+50*10+30, 'black', 1);
			ctx_Line(ctx, sx+120, 	listStart+50*10+130, 	ex, listStart+50*10+130, 'black', 1);
			ctx_Line(ctx, sx+120, 	listStart+50*10+160, 	ex, listStart+50*10+160, 'black', 1);
			ctx_Line(ctx, sx, 		listStart+50*10+260, 	ex, listStart+50*10+260, 'black', 1);
			// 표2 세로줄
			var list2_col_width = (this.col_head_width[0]-120)/6;
			var list2_col_x = sx+120;
			var list2_col_data1 = ['파리','모기','깔다구','나방파리','나방','화랑곡나방'];
			var list2_col_data2 = ['개미','바퀴벌레','거미','그리마(돈벌레)','쥐(생쥐)',];
			for(i=0; i<6; i++) {
				var list2_col_x_center = list2_col_x + list2_col_width/2;
				if(i==5) {
					ctx_Line(ctx, list2_col_x, listStart+50*10, list2_col_x, listStart+50*10+130, 'black', 1);
				} else {
					ctx_Line(ctx, list2_col_x, listStart+50*10, list2_col_x, listStart+50*10+260, 'black', 1);
					if(i==4)
						ctx_fillText(ctx, list2_col_x_center + list2_col_width/2, sy+680, 
								list2_col_data2[i], 'black', vTextStyleBold, 'center','middle');
					else
						ctx_fillText(ctx, list2_col_x_center, sy+680, list2_col_data2[i], 'black', vTextStyleBold, 'center','middle');
				}
				ctx_fillText(ctx, list2_col_x_center, sy+550, list2_col_data1[i], 'black', vTextStyleBold, 'center','middle');
				list2_col_x += list2_col_width;
			}
			
			// 표3 가로줄
			ctx_Line(ctx, sx, listStart+500+260, 	ex, listStart+500+260, 'black', 1);
			ctx_Line(ctx, sx, listStart+500+260+60+36, 	ex, listStart+500+260+60+36, 'black', 1);
			ctx_Line(ctx, sx, listStart+500+260+60+36+42, 	ex, listStart+500+260+60+36+42, 'black', 1);
// 			ctx_Line(ctx, sx, listStart+500+260+60+36+42*2, 	ex, listStart+500+260+60+36+42*2, 'black', 1);
// 			ctx_Line(ctx, sx, listStart+500+260+60+36+42*3, 	ex, listStart+500+260+60+36+42*3, 'black', 1);
			// 표3 세로줄
			var list3_col_width1 = 300;
			var list3_col_width2 = 475;
			var list3_col_width3 = this.col_head_width[0] - list3_col_width1 - list3_col_width2 ;
			ctx_Line(ctx, sx+list3_col_width1, listStart+500+260, 
					sx+list3_col_width1, listStart+500+260+420, 'black', 1);
			ctx_Line(ctx, sx+list3_col_width1+list3_col_width2, listStart+500+260+60+36, 
					sx+list3_col_width1+list3_col_width2, listStart+500+260+420, 'black', 1);
			// 표3 text
			ctx_fillText(ctx, sx+list3_col_width1/2, sy+825, '방충 · 방서 장비 관리사항', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+list3_col_width1/2, sy+845, '(교체 및 수리내역)', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+list3_col_width1/2, sy+905, '기준이탈 사항(원인파악)', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+list3_col_width1+list3_col_width2/2, sy+905, 
					'개선조치 및 결과', 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, sx+list3_col_width1+list3_col_width2+list3_col_width3/2, sy+905, 
					'조치자', 'black', vTextStyleBold, 'center','top');
			// 표3 data
			ctx_wrapText(ctx, sx+list3_col_width1+5, listStart+500+260+5, '<%=repair_note%>', 
					'black', vTextStyle, 'start','top', list3_col_width2+list3_col_width3, 20); //방충방서장비관리사항
			ctx_wrapText(ctx, sx+5, listStart+500+260+60+36+42+5,
					'<%=incong_note%>', 'black', vTextStyle, 'start','top', list3_col_width1, 20); //기준이탈사항
			ctx_wrapText(ctx, sx+list3_col_width1+5, listStart+500+260+60+36+42+5,
					'<%=improve_note%>', 'black', vTextStyle, 'start','top', list3_col_width2, 20); //새건조치및결과
			ctx_wrapText(ctx, sx+list3_col_width1+list3_col_width2+5, listStart+500+260+60+36+42+5,
					'<%=improve_checker%>', 'black', vTextStyle, 'start','top', list3_col_width3, 20); //조치자
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