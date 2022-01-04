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
회수관리대장 canvas (S838S090100_canvas.jsp)
*/	
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();
DoyosaeTableModel TableModel;

String GV_RECALL_YEAR="", GV_RECALL_WEEK="";

if(request.getParameter("recallYear")== null)
	GV_RECALL_YEAR = "";
else
	GV_RECALL_YEAR = request.getParameter("recallYear");
if(request.getParameter("recallWeek")== null)
	GV_RECALL_WEEK = "";
else
	GV_RECALL_WEEK = request.getParameter("recallWeek");

JSONObject jArray = new JSONObject();
jArray.put( "member_key", member_key);
jArray.put( "recallYear", GV_RECALL_YEAR);
jArray.put( "recallWeek", GV_RECALL_WEEK);

TableModel = new DoyosaeTableModel("M838S090100E114", jArray);
int RowCount =TableModel.getRowCount();

// NO, 성명, 검진일, 차기검진일, 분기별 확인, 비고, 결재, 확인일, 점검, 승인, 특이사항
String Writor="", WriteDate="", Reviewer="", ReviewDate="", Approval="", ApprovalDate="";
if(RowCount>0) {
	Writor = TableModel.getValueAt(0, 13).toString().trim();
	WriteDate = TableModel.getValueAt(0, 15).toString().trim();
	Reviewer = TableModel.getValueAt(0, 16).toString().trim();
	ReviewDate = TableModel.getValueAt(0, 17).toString().trim();
	Approval = TableModel.getValueAt(0, 18).toString().trim();
	ApprovalDate = TableModel.getValueAt(0, 19).toString().trim();
}

StringBuffer RecallNo = new StringBuffer();
StringBuffer RecallDate = new StringBuffer();
StringBuffer Prodnm = new StringBuffer();
StringBuffer Custnm = new StringBuffer();
StringBuffer RecallReason = new StringBuffer();
StringBuffer ProcedYn = new StringBuffer();
StringBuffer RecallNote = new StringBuffer();
StringBuffer Uniqueness = new StringBuffer();

RecallNo.append("[");
RecallDate.append("[");
Prodnm.append("[");
Custnm.append("[");
RecallReason.append("[");
ProcedYn.append("[");
RecallNote.append("[");
Uniqueness.append("[");
for(int i=0; i<RowCount; i++) {
	if(i==RowCount-1) {
		/* System.out.println("RecallNo : " +TableModel.getValueAt(i, 0).toString().trim() 	+ "\n"  +
							"RecallDate : " +TableModel.getValueAt(i, 2).toString().trim() 	+ "\n"  +
							"Prodnm : " +TableModel.getValueAt(i, 3).toString().trim() 		+ "\n"  +
							"Custnm : " + TableModel.getValueAt(i, 5).toString().trim() 	+ "\n"  +
							"RecallReason : " + TableModel.getValueAt(i, 7).toString().trim() + "\n"  +
							"ProcedYn : " + TableModel.getValueAt(i, 8).toString().trim() 	+ "\n"  +
							"RecallNote : " + TableModel.getValueAt(i, 9).toString().trim()); */
		RecallNo.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'");
		RecallDate.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'");
		Prodnm.append( "'" + TableModel.getValueAt(i, 5).toString().trim() + "'");
		Custnm.append( "'" + TableModel.getValueAt(i, 8).toString().trim() + "'");
		RecallReason.append( "'" + TableModel.getValueAt(i, 9).toString().trim() + "'");
		ProcedYn.append( "'" + TableModel.getValueAt(i, 10).toString().trim() + "'");
		RecallNote.append( "'" + TableModel.getValueAt(i, 11).toString().trim() + "'");
		Uniqueness.append( "'" + (i+1) + ". " + TableModel.getValueAt(i, 5).toString().trim() + "(" + TableModel.getValueAt(i, 8).toString().trim() + ","+ TableModel.getValueAt(i, 2).toString().trim() + ") : "
							   + TableModel.getValueAt(i, 12).toString().trim() 	+ "'");
	} else {
		RecallNo.append( "'" + TableModel.getValueAt(i, 0).toString().trim() 	+ "'" + ",");
		RecallDate.append( "'" + TableModel.getValueAt(i, 2).toString().trim() 	+ "'" + ",");
		Prodnm.append( "'" + TableModel.getValueAt(i, 5).toString().trim() 		+ "'" + ",");
		Custnm.append( "'" + TableModel.getValueAt(i, 8).toString().trim() 		+ "'" + ",");
		RecallReason.append( "'" + TableModel.getValueAt(i, 9).toString().trim()+ "'" + ",");
		ProcedYn.append( "'" + TableModel.getValueAt(i, 10).toString().trim() 	+ "'" + ",");
		RecallNote.append( "'" + TableModel.getValueAt(i, 11).toString().trim() 	+ "'" + ",");
		Uniqueness.append( "'" + (i+1) + ". " + TableModel.getValueAt(i, 5).toString().trim() + "(" + TableModel.getValueAt(i, 8).toString().trim() + ","+ TableModel.getValueAt(i, 2).toString().trim() + ") : "
							   + TableModel.getValueAt(i, 12).toString().trim() 	+ "'" + ",");
	}
}
RecallNo.append("]");
RecallDate.append("]");
Prodnm.append("]");
Custnm.append("]");
RecallReason.append("]");
ProcedYn.append("]");
RecallNote.append("]");
Uniqueness.append("]");
System.out.println("RecallNo : "+ RecallNo);
System.out.println("RecallDate : "+ RecallDate);
System.out.println("Prodnm : "+ Prodnm);
System.out.println("Custnm : "+ Custnm);
System.out.println("RecallReason : "+ RecallReason);
System.out.println("ProcedYn : "+ ProcedYn);
System.out.println("RecallNote : "+ RecallNote);
System.out.println("Uniqueness : "+ Uniqueness);
%>

<script type="text/javascript">	
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart+120; // 헤드텍스트 영역 종료 높이
	var HeadText_MinWidth = 650;
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var vTextCheckBold = 'bold 16px 맑은고딕';
	var DataGrid1_RowHeight = 50; // 표1의 행 높이
	var DataGrid1_RowHeight1st = 50;
	var DataGrid1_RowCount = 7; // 표1의 행 개수(체크리스트행 개수 + 상단및하단 나머지행 개수)
	var DataGrid1_RowCount_Approve = 1 ; // 표1의 하단부분 줄수(결재)
	var DataGrid1_Approve_Height = 100; // 표1의 하단부분1 높이(결재)
	var DataGrid1_Uniqueness_Height = 200; // 표1의 하단부분2 높이(특이사항)
	var DataGrid1_Width = 1240;
	var DataGrid1_HeightStart = 30+HaedText_HeightEnd;
	var DataGrid1_Height = DataGrid1_HeightStart + DataGrid1_RowHeight1st
	 + (DataGrid1_RowCount * DataGrid1_RowHeight) + (DataGrid1_Uniqueness_Height); // 표1 높이( 표 시작위치 + (행개수 * 행높이) )


	
    $(document).ready(function () {
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid1_Height + CanvasPadding*2+30; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding-30; // 끝좌표y
    	    	    	    	
		// 그리기
	    HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
 		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd, pointEX, pointEY);
		
		// 기입내용이 20개 넘어갔을경우 
		// 페이지 수
    	var pageNum = parseInt(<%=RowCount%>/7)+1; 	
		  
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {		
		drawText(ctx, sx, sy, ex, ey) {
			var top_info = 'HS-PP-08-A 회수관리대장';
			var middle_info = '회수관리대장' ;
			var headContentBox = HeadText_HeightStart + 30;
			var vHeadTextStyleBold = 'bold 15px 맑은고딕';
			var vHeadSignData = (sx+ex)/7*5;
			var vHeadSignDivide = (ex - vHeadSignData-30)/3;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '18px 맑은고딕', 'start','top');
			ctx_Line(ctx, sx, headContentBox, ex, headContentBox, 'black', 1); // head 가로선
			ctx_Line(ctx, sx, headContentBox, sx, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, ex, headContentBox, ex, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData, headContentBox, (sx+ex)/7*5, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30, headContentBox, (sx+ex)/7*5+30, ey, 'black', 1); // head 세로선	
			ctx_Line(ctx, vHeadSignData+30+vHeadSignDivide, headContentBox, vHeadSignData+30+vHeadSignDivide, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30+vHeadSignDivide*2, headContentBox, vHeadSignData+30+vHeadSignDivide*2, ey, 'black', 1); // head 세로선
			ctx_Line(ctx, vHeadSignData+30, headContentBox+30, ex, headContentBox+30, 'black', 1); // head 가로선
			ctx_fillText(ctx, (sx+ex)/8*3, (ey+HeadText_HeightStart)/2 , middle_info, 'black', 'bold 35px 맑은고딕', 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+15, headContentBox+25, "결", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+15, headContentBox+65, "재", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+80, headContentBox+10, "작  성", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+80, headContentBox+50, col_info_data[1], 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+80, headContentBox+75, col_info_data[2], 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+10, "검  토", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+50, col_info_data[3], 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+190, headContentBox+75, col_info_data[4], 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+10, "승  인", 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+50, col_info_data[5], 'black', vHeadTextStyleBold, 'center','top');
			ctx_fillText(ctx, (sx+ex)/7*5+300, headContentBox+75, col_info_data[6], 'black', vHeadTextStyleBold, 'center','top');
		} // HeadText.drawText function end
	} ;
	
 	// 표1 정의
 	var col_info_data=["<%=Uniqueness%>","<%=Writor%>","<%=WriteDate%>","<%=Reviewer%>","<%=ReviewDate%>","<%=Approval%>","<%=ApprovalDate%>"];
	var DataGrid1 = {
		col_head:["상품명","출고처","출고일","반품(회수)일","반품(회수)사유","처리사항","처리결과","특이사항"],
		col_head_detail:["리콜","불만","오배송","분석유무","확인","재사용","일부사용","전량폐기"],		
 		col_recall_no:<%=RecallNo%>,
		col_recall_date:<%=RecallDate%>,
		col_prod_nm:<%=Prodnm%>,
		col_cust_nm:<%=Custnm%>,
		col_recall_reason:<%=RecallReason%>,
		col_proced_yn:<%=ProcedYn%>,
		col_recall_note:<%=RecallNote%>, 
		col_uniqueness:<%=Uniqueness%>, 
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			
			// 헤드부분
			var col_head_x_divide = (ex+20)/18;	// 분할선
			var col_head_result = (ex-(20+col_head_x_divide*8))/8;
			var col_head_y_end = sy+DataGrid1_RowHeight1st*(DataGrid1_RowCount+1);
			var col_head_y_loc = sy+DataGrid1_RowHeight1st/2+12;
			// 줄 긋기
			ctx_Line(ctx, 10+col_head_x_divide*2, sy, 10+col_head_x_divide*2, ey, 'black', 1); // 가로선
			ctx_Line(ctx, 20+col_head_x_divide*4, sy, 20+col_head_x_divide*4, col_head_y_end, 'black', 1); // 가로선
			ctx_Line(ctx, 20+col_head_x_divide*6, sy, 20+col_head_x_divide*6, col_head_y_end, 'black', 1); // 가로선
			ctx_Line(ctx, 20+col_head_x_divide*8, sy, 20+col_head_x_divide*8, col_head_y_end, 'black', 1); // 가로선
			ctx_Line(ctx, 20+col_head_x_divide*8, sy+DataGrid1_RowHeight1st-25, ex, sy+DataGrid1_RowHeight1st-25, 'black', 1); // 가로선	
			for(i=0; i<DataGrid1_RowCount+1; i++){
				var col_result_divide = 20+col_head_x_divide*8+col_head_result*(i+1);
				if(i == 2){
					ctx_Line(ctx, col_result_divide, sy, col_result_divide, col_head_y_end, 'black', 1); // 세로선
				} else if(i == 4){
					ctx_Line(ctx, col_result_divide, sy, col_result_divide, col_head_y_end, 'black', 1); // 세로선
				} else {
					ctx_Line(ctx, col_result_divide, sy+DataGrid1_RowHeight1st-25, col_result_divide, col_head_y_end, 'black', 1); // 세로선
				}
				ctx_Line(ctx, sx, sy+DataGrid1_RowHeight1st*(i+1), ex, sy+DataGrid1_RowHeight1st*(i+1), 'black', 1); // 가로선				
			} 
			// 헤드텍스트 입력
			ctx_fillText(ctx, 20+col_head_x_divide*2*0+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[0], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, 50+col_head_x_divide*2*1+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[1], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 40+col_head_x_divide*2*2+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[2], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, 15+col_head_x_divide*2*3+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2, this.col_head[3], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, 110+col_head_x_divide*2*4+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2-13, this.col_head[4], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 180+col_head_x_divide*2*5+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2-13, this.col_head[5], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 240+col_head_x_divide*2*6+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2-13, this.col_head[6], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 20+col_head_x_divide*2*0+col_head_x_divide/2-5, ey-DataGrid1_Uniqueness_Height/2-20, this.col_head[7], 'black', vTextStyleBold, 'left','middle');			
			ctx_fillText(ctx, 45+col_head_x_divide*2*4+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[0], 'black', vTextStyleBold, 'right','middle');
			ctx_fillText(ctx, 125+col_head_x_divide*2*4+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[1], 'black', vTextStyleBold, 'right','middle');
			ctx_fillText(ctx, 215+col_head_x_divide*2*4+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[2], 'black', vTextStyleBold, 'right','middle');
			ctx_fillText(ctx, 135+col_head_x_divide*2*5+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[3], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 220+col_head_x_divide*2*5+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[4], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 160+col_head_x_divide*2*6+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[5], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 245+col_head_x_divide*2*6+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[6], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, 328+col_head_x_divide*2*6+col_head_x_divide/2, col_head_y_loc+1, this.col_head_detail[7], 'black', vTextStyleBold, 'center','middle');
			
			// 데이터 입력 
			
			for(i=0; i<'<%=RowCount%>'; i++){
// 				ctx_fillText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide/20.5, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_prod_nm[i], 'black', vTextStyleBold, 'left','middle');
				ctx_wrapText(ctx, 10+col_head_x_divide*2*0+col_head_x_divide/1, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_prod_nm[i], 'black', vTextStyleBold, 'center','middle', 100, 17);
				ctx_fillText(ctx, 30+col_head_x_divide*2*1+col_head_x_divide/1.3, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_cust_nm[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, 20+col_head_x_divide*2*2+col_head_x_divide/1, sy+DataGrid1_RowHeight1st/2+50*(i+1), "", 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, 20+col_head_x_divide*2*3+col_head_x_divide/1, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_date[i], 'black', vTextStyleBold, 'center','middle');
				// 반품(회수)사유
				if(this.col_recall_reason[i] == '리콜'){
					ctx_fillText(ctx, 10+col_head_x_divide*2*4+col_head_x_divide/1.4, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason[i], 'black', vTextStyleBold, 'center','middle');
				} else if(this.col_recall_reason[i] == '불만'){
					ctx_fillText(ctx, 95+col_head_x_divide*2*4+col_head_x_divide/1.45, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason[i], 'black', vTextStyleBold, 'center','middle');
				} else if(this.col_recall_reason[i] == '오배송'){
					ctx_fillText(ctx, 215+col_head_x_divide*2*4+col_head_x_divide/5.02, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason[i], 'black', vTextStyleBold, 'center','middle');
				} 				
				//ctx_fillText(ctx, 110+col_head_x_divide*2*4+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_reason[i], 'black', vTextStyleBold, 'left','middle');
				// 처리사항

				ctx_fillText(ctx, 130+col_head_x_divide*2*5+col_head_x_divide/1.8, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_proced_yn[i], 'black', vTextStyleBold, 'center','middle');
				ctx_fillText(ctx, 200+col_head_x_divide*2*5+col_head_x_divide/1.32, sy+DataGrid1_RowHeight1st/2+50*(i+1), col_info_data[3], 'black', vTextStyleBold, 'center','middle');
				//ctx_fillText(ctx, 180+col_head_x_divide*2*5+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_proced_yn[i], 'black', vTextStyleBold, 'left','middle');
				// 처리결과
				if(this.col_recall_note[i] == '재사용'){
					ctx_fillText(ctx, 140+col_head_x_divide*2*6+col_head_x_divide/1.25, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_note[i], 'black', vTextStyleBold, 'center','middle');
				} else if(this.col_recall_note[i] == '일부사용'){
					ctx_fillText(ctx, 215+col_head_x_divide*2*6+col_head_x_divide/1.095, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_note[i], 'black', vTextStyleBold, 'center','middle');
				} else if(this.col_recall_note[i] == '전량폐기'){
					ctx_fillText(ctx, 297+col_head_x_divide*2*6+col_head_x_divide/1.09, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_note[i], 'black', vTextStyleBold, 'center','middle');
				}
				//ctx_fillText(ctx, 240+col_head_x_divide*2*6+col_head_x_divide/2, sy+DataGrid1_RowHeight1st/2+50*(i+1), this.col_recall_note[i], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, 30+col_head_x_divide*2, sy+DataGrid1_RowHeight1st*8+30*(i+1), this.col_uniqueness[i], 'black', vTextStyleBold, 'left','middle');	// 특이사항
			}
		} // drawGrid function end
	}; // DataGrid1(표1) 정의  end

</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>