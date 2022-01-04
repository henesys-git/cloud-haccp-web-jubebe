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
	00=�����ڵ�(seolbi_cd)
	01=������ȣ(revision_no)
	02=�̹�������(img_filename)
	03=��������(doip_date)
	04=�����Ī(seolbi_nm)
	05=�԰�(gugyuk)
	06=������(seolbi_maker)
	07=����ȣ(gigi_bunho)
	08=��ȿ����(yuhyo_date)
	09=�����ֱ�(gyojung_jugi)
	10=��������(gyojung_date)
	11=������(admin_id)
	12=å����(checkim_id)
	13=���μ�(use_buseo)
	14=�������(gyojung_damdang)
	15=���(bigo)
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
	String sqlPath = "E:/TEMP/���̾�/";
	String sqlPathFile = "SULBI_160901.xls";

	// ����
	FileInputStream fis = null;
	XSSFWorkbook workbook = null;
	XSSFSheet sheet = null;
	XSSFRow row = null;
	XSSFCell cell = null;
	
	// ����
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
		// �̹������ϴ� ���� �ŷ�ó���� ����.
		int EXIST_ROW_COUNT = 0;
		String TMP0 = "";
		String TMP1 = "";
		String TMP2 = "";
		String TMP3 = "";

		try {
			FILE_NAME = targetFile.getName();
			System.out.println("--[����]==========="+ FILE_NAME);
			// �̹� ������ ������� ������ �����.
			File checkFile = new File(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			if (checkFile.exists()) {
				System.out.println("�̹� ������ �����մϴ�. �����ϰ� �����ϰڽ��ϴ�.");
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
			00=�����ڵ�()
			01=������ȣ()
			02=�̹�������()
			03=��������()
			04=�����Ī()
			05=�԰�()
			06=������()
			07=����ȣ()
			08=��ȿ����()
			09=�����ֱ�()
			10=��������()
			11=������()
			12=å����()
			13=���μ�()
			14=�������()
			15=���()
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

			// �����ڵ�
			String SEOLBI_CD = "";
			String SULBI_CODE_REV = "0";
			// �̹������ϸ�
			String IMG_FILENAME = "";
			// ��������
			String DOIP_DATE = "";
			// �����
			String SULBI_NAME = "";
			// �԰�
			String GUGYUK = "";
			// ������
			String SULBI_MAKER = "";
			// ����ȣ
			String GIGI_BUNHO = "";
			// ��ȿ����
			String YUHYO_DATE = "";
			// �����ֱ�
			String GYOJUNG_JUGI = "";
			// ��������
			String GYOJUNG_DATE = "";
			// ������
			String ADMIN_ID = "";
			// å����
			String CHECKIM_ID = "";
			// ���μ�
			String USE_BUSEO = "";
			// ���������
			String GYOJUNG_DAMDANG = "";
			// ���
			String BIGO = "";
			// �������
			String GYOJUNG_GIGWAN = "";
			
			for (int i=0; i<sheetCount; i++) {
				if (i==0) {
					System.out.println("-"+i+"-");
					//continue;
				}
				// SHEET�� �Ӽ��� ���Ѵ�.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				System.out.println("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				//-----------------fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//���� �д´�
				    row = sheet.getRow(r);
				    //���� ��
			        cellCount = row.getPhysicalNumberOfCells();
			        
					// 5���� �ο쿡�� ��������� �־ ����.
					// ���� ����ؾ��� �������� r=5 �� 6��° �ٺ��� ���۵ȴ�.
					if (r < HEAD_ROW_COUNT) {
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					// �⺻ ��� ������ ����� �д�.   
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

					// ���� - �ǹ̾���
					cell = row.getCell(0);					
					
			        // �ڵ�(SEOLBI_CD)
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

					// ������ȣ
					SULBI_CODE_REV = "0";

					// �̹������ϸ�
					IMG_FILENAME = SEOLBI_CD + ".jpg";

					// ��������
					cell = row.getCell(2);
					cellData = cell.getStringCellValue();
					TMP0 = cellData.trim();
					try {
						TMP1 = TMP0.substring(0, TMP0.indexOf("��"));
						TMP2 = TMP0.substring(TMP0.indexOf("��")+1, TMP0.indexOf("��")).trim();
						TMP3 = TMP0.substring(TMP0.indexOf("��")+1, TMP0.indexOf("��")).trim();
						DOIP_DATE = TMP1.trim() + "-" + TMP2.trim() + "-" + TMP3.trim();
					} catch (Exception e) {
						DOIP_DATE = TMP0;
					}
					
					// ��Ī
					cell = row.getCell(3);
					cellData = cell.getStringCellValue();
					SULBI_NAME = cellData.trim();
					SULBI_NAME = SULBI_NAME.replaceAll("\r", "");
					SULBI_NAME = SULBI_NAME.replaceAll("\n", "");
					SULBI_NAME = SULBI_NAME.replaceAll("'", "");
					
					// �԰�
					cell = row.getCell(4);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GUGYUK = cellData.trim();
					GUGYUK = GUGYUK.replaceAll("'", "");
					
					// ������
					cell = row.getCell(5);
					cellData = cell.getStringCellValue();
					SULBI_MAKER = cellData.trim();
					SULBI_MAKER = SULBI_MAKER.replaceAll("\r", "");
					SULBI_MAKER = SULBI_MAKER.replaceAll("\n", "");
					SULBI_MAKER = SULBI_MAKER.replaceAll("'", "");

					// ����ȣ
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GIGI_BUNHO = cellData.trim();
					GIGI_BUNHO = GIGI_BUNHO.replaceAll("'", "");

					// ��ȿ����
					cell = row.getCell(7);
					cellData = cell.getStringCellValue();
					YUHYO_DATE = cellData.trim();
					YUHYO_DATE = YUHYO_DATE.replaceAll("'", "");

					// �����ֱ�
					cell = row.getCell(8);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					GYOJUNG_JUGI = cellData.trim();
 
					// Ȯ��
					cell = row.getCell(9);

					// �������
					cell = row.getCell(10);
					cellData = cell.getStringCellValue();
					GYOJUNG_GIGWAN = cellData.trim();
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("\r", "");
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("\n", "");
					GYOJUNG_GIGWAN = GYOJUNG_GIGWAN.replaceAll("'", "");

					// ��������
					cell = row.getCell(11);
					cellData = cell.getStringCellValue();
					GYOJUNG_DATE = cellData.trim();
					GYOJUNG_DATE = GYOJUNG_DATE.replaceAll("'", "");

					// Ȯ��
					cell = row.getCell(12);

					// ������
					cell = row.getCell(13);
					cellData = cell.getStringCellValue();
					ADMIN_ID = cellData.trim();
					ADMIN_ID = ADMIN_ID.replaceAll("'", "");

					// å����
					cell = row.getCell(14);
					cellData = cell.getStringCellValue();
					CHECKIM_ID = cellData.trim();
					CHECKIM_ID = CHECKIM_ID.replaceAll("'", "");

					// ���μ�
					cell = row.getCell(15);
					cellData = cell.getStringCellValue();
					USE_BUSEO = cellData.trim();
					USE_BUSEO = USE_BUSEO.replaceAll("'", "");

					// ���������
					cell = row.getCell(16);
					cellData = cell.getStringCellValue();
					GYOJUNG_DAMDANG = cellData.trim();
					GYOJUNG_DAMDANG = GYOJUNG_DAMDANG.replaceAll("'", "");
					
					// ���
					cell = row.getCell(17);
					cellData = cell.getStringCellValue();
					BIGO = cellData.trim();
					BIGO = BIGO.replaceAll("\r", "");
					BIGO = BIGO.replaceAll("\n", "");
					BIGO = BIGO.replaceAll("'", "");
					
					// ������ �ϼ��Ѵ�.
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
					sqlBuffer.append(",'" + "���ʵ��" + "'			");
					sqlBuffer.append(",'" + "MEASURE" + "'			");
					sqlBuffer.append(",'" + GYOJUNG_GIGWAN + "');	\n");

					// ���Ͽ� ����.
					fout.write(sqlBuffer.toString());
					fout.flush();
					
					//database.doUpdate(con, sqlBuffer.toString());
										
					// �ʱ�ȭ
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
		System.out.println("[�Ϸ�]==========="+ targetFile.getAbsolutePath());
	}
	
	public static void main(String args[]) {
		new Excel2Seolbi();
	}
}
