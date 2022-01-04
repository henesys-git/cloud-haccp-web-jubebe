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

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "", GV_SUBCONSTRACTOR_SEQ = "";
	
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
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONSTRACTOR_SEQ);
	jArray.put( "member_key", member_key);

    TableModel = new DoyosaeTableModel("M838S060400E144", jArray);	
	
 	int RowCount =TableModel.getRowCount();
 	
	StringBuffer DetailArray = new StringBuffer();
	if(RowCount>0) {
		for(int i = 0; i < RowCount; i++){
			DetailArray.append("[");			
			DetailArray.append("'"+ TableModel.getValueAt(i, 0).toString().trim()  + "',");  // 0.  subcontractor_no              
			DetailArray.append("'"+ TableModel.getValueAt(i, 1).toString().trim()  + "',");  // 1.  subcontractor_rev             
			DetailArray.append("'"+ TableModel.getValueAt(i, 2).toString().trim()  + "',"); // 2.  subcontractor_seq             
			DetailArray.append("'"+ TableModel.getValueAt(i, 3).toString().trim()  + "',"); // 3.  product_division              
			DetailArray.append("'"+ TableModel.getValueAt(i, 4).toString().trim()  + "',"); // 4.  subcontractor_name            
			DetailArray.append("'"+ TableModel.getValueAt(i, 5).toString().trim()  + "',"); // 5.  subcontractor_ceo             
			DetailArray.append("'"+ TableModel.getValueAt(i, 6).toString().trim()  + "',");  // 6.  subcontractor_headoffice_phone
			DetailArray.append("'"+ TableModel.getValueAt(i, 7).toString().trim()  + "',");  // 7.  appraisal_means               
			DetailArray.append("'"+ TableModel.getValueAt(i, 8).toString().trim()  + "',");  // 8.  approve_date                  
			DetailArray.append("'"+ TableModel.getValueAt(i, 9).toString().trim()  + "',"); // 9.  approval                      
			DetailArray.append("'"+ TableModel.getValueAt(i, 10).toString().trim() + "',"); // 10. approval_rev                  
			DetailArray.append("'"+ TableModel.getValueAt(i, 11).toString().trim() + "',"); // 11. product_bigo
			DetailArray.append("'"+ TableModel.getValueAt(i, 12).toString().trim() + "'"); // 12. faxno  
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
	var detail_data = [<%=DetailArray.toString()%>]; 
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 인
	var row_count = '<%=RowCount%>';
	var SubdataText_HeightStart = HaedText_HeightEnd;
	if(row_count > 27){
		var SubdataText_HeightEnd = SubdataText_HeightStart + (parseInt(row_count)+1)*40; // 점검관련사항 영역 종료 높이
	} else {
		var SubdataText_HeightEnd = SubdataText_HeightStart + 1120; // 점검관련사항 영역 종료 높이
	}
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)
    	
    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
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
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'TYENS B&P-PRP-04-05 (Rev.'+ detail_data[0][1] + ' 협력업체 관리대장' ;
			var middle_info = '협력업체 관리대장' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2-80, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');

		} // HeadText.drawText function end
	} ;

	// 회사정보
	var SubdataText = {
		col_head_width:[900],		
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
//			var sub_col_name = ['No.', '품 목', '제조회사', '담당자', '전화번호', '선정기준', '승인일자', '승 인', '변동사항'];
			var sub_col_name = ['관리번호', '회 사 명', '주생산품', 'T E L', 'F A X', '승인일자', '비 고'];
//			var col_loc = [1, 4, 7, 9, 11, 13, 15, 17, 19];
			var col_loc = [1, 3, 5, 7, 9];
//			var cut = ex/20;
			var cut = ex/10;
			var text_hgt = SubdataText_HeightStart +30;


			for(var i = 0; i < col_loc.length; i++){ ctx_Line(ctx, sx+cut*col_loc[i], sy, sx+cut*col_loc[i], ey, 'black', 1); }
			
			ctx_fillText(ctx, sx+cut*1-cut/2, text_hgt, sub_col_name[0], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*1.5+10, text_hgt, sub_col_name[1], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*3.5+10, text_hgt, sub_col_name[2], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*5.5-20, text_hgt, sub_col_name[3] + " / "+ sub_col_name[4], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*7.5+10, text_hgt, sub_col_name[5], 'black', vTextStyleBold, 'left','middle');
			ctx_fillText(ctx, sx+cut*9.5-20, text_hgt, sub_col_name[6], 'black', vTextStyleBold, 'left','middle');

			for(var i = 0; i < detail_data.length; i++){				
				ctx_fillText(ctx, sx+cut*1-cut/2, text_hgt+40*(i+1), i+1, 'black', vTextStyle, 'left','middle');              
				ctx_fillText(ctx, sx+cut*1.5+10, text_hgt+40*(i+1), detail_data[i][4], 'black', vTextStyle, 'left','middle');  
				ctx_fillText(ctx, sx+cut*3.5+10, text_hgt+40*(i+1), detail_data[i][3], 'black', vTextStyle, 'left','middle');  
				ctx_fillText(ctx, sx+cut*5.5-20, text_hgt+40*(i+1)-10, 'Tel : '+ detail_data[i][6], 'black', '12px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*5.5-20, text_hgt+40*(i+1)+10, 'Fax : '+ detail_data[i][12], 'black', '12px 맑은고딕', 'left','middle'); 
				ctx_fillText(ctx, sx+cut*7.5+10, text_hgt+40*(i+1), detail_data[i][8], 'black', '14px 맑은고딕', 'left','middle');
				ctx_fillText(ctx, sx+cut*9.5-10, text_hgt+40*(i+1), detail_data[i][10], 'black', vTextStyle, 'left','middle');      
				
			}

			if(row_count > 29){
				for(var i=0; i< row_count; i++){ ctx_Line(ctx, sx, sy+40*i, ex, sy+40*i, 'black', 1); }
				ctx_Line(ctx, sx, sy+40*(parseInt(row_count)), ex, sy+40*(parseInt(row_count)), 'black', 1);
			} else {
				for(var i=0; i< 28; i++){  ctx_Line(ctx, sx, sy+40*i, ex, sy+40*i, 'black', 1); }
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