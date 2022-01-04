package mes.frame.database;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.sql.Connection;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/*
	00=설비코드(seolbi_cd)
	01=개정번호(revision_no)
	02=이미지파일(img_filename)
	03=도입일자(doip_date)
	04=설비명칭(seolbi_nm)
	05=규격(gugyuk)
	06=제조사(seolbi_maker)
	07=기기번호(gigi_bunho)
	08=유효일자(yuhyo_date)
	09=교정주기(gyojung_jugi)
	10=교정일자(gyojung_date)
	11=관리자(admin_id)
	12=책임자(checkim_id)
	13=사용부서(use_buseo)
	14=교정담당(gyojung_damdang)
	15=비고(bigo)
	16=start_date,
	17=duration_date,
	18=create_date,
	19=create_user_id,
	20=modify_date,
	21=modify_user_id,
	22=modify_reason
	23=sulbi_gubun
	24=gyojung_gigwan
 */

public class Excel2Seolbi {
	String sqlPath = "E:/TEMP/사이언/";
	String sqlPathFile = "SULBI_160901.xls";

	// 엑셀
	FileInputStream fis = null;
	XSSFWorkbook workbook = null;
	XSSFSheet sheet = null;
	XSSFRow row = null;
	XSSFCell cell = null;
	
	// 쓰기
	FileWriter fout = null;
	
	DatabaseUtil database = null;
	Connection con = null;
	
	int HEAD_ROW_COUNT = 4;

	public Excel2Seolbi() {
		try {
			String mainPath = sqlPath + sqlPathFile;
			File dataFile = new File(mainPath);

			Excel2Seolbi e2d = new Excel2Seolbi(dataFile);
			e2d.doExcelProcess(dataFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Excel2Seolbi(File dataFile) {
		try {
			fis = new FileInputStream(dataFile);
			workbook = new XSSFWorkbook(fis);
			
			database = new DatabaseUtil();
			//con = JDBCConnectionPool.getConnection();
			//con.setAutoCommit(true);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void doExcelProcess(File targetFile) {
		int sheetCount= 0;
		int rowCount = 0;
		int cellCount = 0;
		int columnIndex = 0;
		String FILE_NAME = "";
		String SHEET_NAME = "";
		String cellData = "";
		StringBuffer sqlBuffer = new StringBuffer();
		// 이미존재하는 동일 거래처명의 갯수.
		int EXIST_ROW_COUNT = 0;
		String TMP0 = "";
		String TMP1 = "";
		String TMP2 = "";
		String TMP3 = "";

		try {
			FILE_NAME = targetFile.getName();
			System.out.println("--[시작]==========="+ FILE_NAME);
			// 이미 파일이 만들어져 있으면 지운다.
			File checkFile = new File(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			if (checkFile.exists()) {
				System.out.println("이미 파일이 존재합니다. 삭제하고 진행하겠습니다.");
				checkFile.delete();
			}
			System.out.println("OutFilename=" + sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			//fout = new FileWriter(mainPath + targetFile + ".out", true);
			fout = new FileWriter(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql", true);
			
			sheetCount = workbook.getNumberOfSheets();
			System.out.println("--sheetCount==="+sheetCount);
			if (sheetCount > 1) {
				sheetCount = 1;
			}

			/*
			00=설비코드()
			01=개정번호()
			02=이미지파일()
			03=도입일자()
			04=설비명칭()
			05=규격()
			06=제조사()
			07=기기번호()
			08=유효일자()
			09=교정주기()
			10=교정일자()
			11=관리자()
			12=책임자()
			13=사용부서()
			14=교정담당()
			15=비고()
			16=start_date,
			17=duration_date,
			18=create_date,
			19=create_user_id,
			20=modify_date,
			21=modify_user_id,
			22=modify_reason
			23=sulbi_gubun
			24=gyojung_gigwan
		 */

			// 설비코드
			String SEOLBI_CD = "";
			String SULBI_CODE_REV = "0";
			// 이미지파일명
			String IMG_FILENAME = "";
			// 도입일자
			String DOIP_DATE = "";
			// 설비명
			String SULBI_NAME = "";
			// 규격
			String GUGYUK = "";
			// 제조사
			String SULBI_MAKER = "";
			// 기기번호
			String GIGI_BUNHO = "";
			// 유효일자
			String YUHYO_DATE = "";
			// 교정주기
			String GYOJUNG_JUGI = "";
			// 교정일자
			String GYOJUNG_DATE = "";
			// 관리자
			String ADMIN_ID = "";
			// 책임자
			String CHECKIM_ID = "";
			// 사용부서
			String USE_BUSEO = "";
			// 교정담당자
			String GYOJUNG_DAMDANG = "";
			// 비고
			String BIGO = "";
			// 교정기관
			String GYOJUNG_GIGWAN = "";
			
			for (int i=0; i<sheetCount; i++) {
				if (i==0) {
					System.out.println("-"+i+"-");
					//continue;
				}
				// SHEET의 속성을 구한다.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				System.out.println("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				//-----------------fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//행을 읽는다
				    row = sheet.getRow(r);
				    //셀의 수
			        cellCount = row.getPhysicalNumberOfCells();
			        
					// 5개의 로우에는 헤드정보가 있어서 뺀다.
					// 실제 등록해야할 정보들은 r=5 즉 6번째 줄부터 시작된다.
					if (r < HEAD_ROW_COUNT) {
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					// 기본 등록 문장을 만들어 둔다.   
					sqlBuffer.append("INSERT INTO tbm_seolbi (	");
					sqlBuffer.append("		seolbi_cd			");
					sqlBuffer.append("		,revision_no		");
					sqlBuffer.append("		,img_filename		");
					sqlBuffer.append("		,doip_date			");
					sqlBuffer.append("		,seolbi_nm			");
					sqlBuffer.append("		,gugyuk				");
					sqlBuffer.append("		,seolbi_maker		");
					sqlBuffer.append("		,gigi_bunho			");
					sqlBuffer.append("		,yuhyo_date			");
					sqlBuffer.append("		,gyojung_jugi		");
					sqlBuffer.append("		,gyojung_date		");
					sqlBuffer.append("		,admin_id			");
					sqlBuffer.append("		,checkim_id			");
					sqlBuffer.append("		,use_buseo			");
					sqlBuffer.append("		,gyojung_damdang	");
					sqlBuffer.append("		,bigo				");
					sqlBuffer.append("		,start_date			");
					sqlBuffer.append("		,duration_date		");
					sqlBuffer.append("		,create_date		");
					sqlBuffer.append("		,create_user_id		");
					sqlBuffer.append("		,modify_date		");
					sqlBuffer.append("		,modify_user_id		");
					sqlBuffer.append("		,modify_reason		");
					sqlBuffer.append("		,sulbi_gubun		");
					sqlBuffer.append("		,gyojung_gigwan)	");
					sqlBuffer.append("VALUES ( 					");

					// 순번 - 의미없음
					cell = row.getCell(0);					
					
			        // 코드(SEOLBI_CD)
					cell = row.getCell(1);
					try {
						if (cell.getCellType() == cell.getCellType().STRING) {
							cellData = cell.getStringCellValue().trim();
						} else {
							cellData = "" + cell.getNumericCellValue();
						}
					} catch (Exception e) {
						break;
					}
					SEOLBI_CD = cellData;
					SEOLBI_CD = SEOLBI_CD.replaceAll("'", "");

					// 개정번호
					SULBI_CODE_REV = "0";

					// 이미지파일명
					IMG_FILENAME = SEOLBI_CD + ".jpg";

					// 도입일자
					cell = row.getCell(2);
					cellData = cell.getStringCellValue();
					TMP0 = cellData.trim();
					try {
						TMP1 = TMP0.substring(0, TMP0.indexOf("년"));
						TMP2 = TMP0.substring(TMP0.indexOf("년")+1, TMP0.indexOf("월")).trim();
						TMP3 = TMP0.substring(TMP0.indexOf("월")+1, TMP0.indexOf("일")).trim();
						DOIP_DATE = TMP1.trim() + "-" + TMP2.trim() + "-" + TMP3.trim();
					} catch (Exception e) {
						DOIP_DATE = TMP0;
					}
					
					// 명칭
					cell = row.getCell(3);
					cellData = cell.getStringCellValue();
					SULBI_NAME = cellData.trim();
					SULBI_NAME = SULBI_NAME.replaceAll("\r", "");
					SULBI_NAME = SULBI_NAME.replaceAll("\n", "");
					SULBI_NAME = SULBI_NAME.replaceAll("'", "");
					
					// 규격
					cell = row.getCell(4);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GUGYUK = cellData.trim();
					GUGYUK = GUGYUK.replaceAll("'", "");
					
					// 제조사
					cell = row.getCell(5);
					cellData = cell.getStringCellValue();
					SULBI_MAKER = cellData.trim();
					SULBI_MAKER = SULBI_MAKER.replaceAll("\r", "");
					SULBI_MAKER = SULBI_MAKER.replaceAll("\n", "");
					SULBI_MAKER = SULBI_MAKER.replaceAll("'", "");

					// 기기번호
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GIGI_BUNHO = cellData.trim();
					GIGI_BUNHO = GIGI_BUNHO.replaceAll("'", "");

					// 유효일자
					cell = row.getCell(7);
					cellData = cell.getStringCellValue();
					YUHYO_DATE = cellData.trim();
					YUHYO_DATE = YUHYO_DATE.replaceAll("'", "");

					// 교정주기
					cell = row.getCell(8);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GYOJUNG_JUGI = cellData.trim();
 
					// 확인
					cell = row.getCell(9);

					// 교정기관
					cell = row.getCell(10);
					cellData = cell.getStringCellValue();
					GYOJUNG_GIGWAN = cellData.trim();
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("\r", "");
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("\n", "");
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("'", "");

					// 교정일자
					cell = row.getCell(11);
					cellData = cell.getStringCellValue();
					GYOJUNG_DATE = cellData.trim();
					GYOJUNG_DATE = GYOJUNG_DATE.replaceAll("'", "");

					// 확인
					cell = row.getCell(12);

					// 관리자
					cell = row.getCell(13);
					cellData = cell.getStringCellValue();
					ADMIN_ID = cellData.trim();
					ADMIN_ID = ADMIN_ID.replaceAll("'", "");

					// 책임자
					cell = row.getCell(14);
					cellData = cell.getStringCellValue();
					CHECKIM_ID = cellData.trim();
					CHECKIM_ID = CHECKIM_ID.replaceAll("'", "");

					// 사용부서
					cell = row.getCell(15);
					cellData = cell.getStringCellValue();
					USE_BUSEO = cellData.trim();
					USE_BUSEO = USE_BUSEO.replaceAll("'", "");

					// 교정담당자
					cell = row.getCell(16);
					cellData = cell.getStringCellValue();
					GYOJUNG_DAMDANG = cellData.trim();
					GYOJUNG_DAMDANG = GYOJUNG_DAMDANG.replaceAll("'", "");
					
					// 비고
					cell = row.getCell(17);
					cellData = cell.getStringCellValue();
					BIGO = cellData.trim();
					BIGO = BIGO.replaceAll("\r", "");
					BIGO = BIGO.replaceAll("\n", "");
					BIGO = BIGO.replaceAll("'", "");
					
					// 문장을 완성한다.
					sqlBuffer.append("'" + SEOLBI_CD + "'			");
					sqlBuffer.append(",'" + SULBI_CODE_REV + "'		");
					sqlBuffer.append(",'" + IMG_FILENAME + "'		");
					sqlBuffer.append(",'" + DOIP_DATE + "'			");
					sqlBuffer.append(",'" + SULBI_NAME + "'			");
					sqlBuffer.append(",'" + GUGYUK + "'				");
					sqlBuffer.append(",'" + SULBI_MAKER + "'		");
					sqlBuffer.append(",'" + GIGI_BUNHO + "'			");
					sqlBuffer.append(",'" + YUHYO_DATE + "'			");
					sqlBuffer.append(",'" + GYOJUNG_JUGI + "'		");
					sqlBuffer.append(",'" + GYOJUNG_DATE + "'		");
					sqlBuffer.append(",'" + ADMIN_ID + "'			");
					sqlBuffer.append(",'" + CHECKIM_ID + "'			");
					sqlBuffer.append(",'" + USE_BUSEO + "'			");
					sqlBuffer.append(",'" + GYOJUNG_DAMDANG + "'	");
					sqlBuffer.append(",'" + BIGO + "'				");
					sqlBuffer.append(",'" + "2018-09-09" + "'		");
					sqlBuffer.append(",'" + "9999-12-31" + "'		");
					sqlBuffer.append(",'" + "2018-09-09" + "'		");
					sqlBuffer.append(",'" + "SYSTEM" + "'			");
					sqlBuffer.append(",'" + "2018-09-09" + "'		");
					sqlBuffer.append(",'" + "SYSTEM" + "'			");
					sqlBuffer.append(",'" + "최초등록" + "'			");
					sqlBuffer.append(",'" + "MEASURE" + "'			");
					sqlBuffer.append(",'" + GYOJUNG_GIGWAN + "');	\n");

					// 파일에 쓴다.
					fout.write(sqlBuffer.toString());
					fout.flush();
					
					//database.doUpdate(con, sqlBuffer.toString());
										
					// 초기화
					sqlBuffer.delete(0, sqlBuffer.length());
				}
			}
			fout.flush();
			fout.close();
			//con.close();
		} catch (Exception e) {
			e.printStackTrace();
			return;
		} finally {
			try {
				fis.close();
				fout.close();
				//con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		System.out.println("[완료]==========="+ targetFile.getAbsolutePath());
	}
	
	public static void main(String args[]) {
		new Excel2Seolbi();
	}
}
