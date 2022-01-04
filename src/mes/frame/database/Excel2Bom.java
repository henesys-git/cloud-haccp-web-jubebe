package mes.frame.database;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.sql.Connection;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import mes.client.common.Common;

/*
 * 0=���� (sys_bom_id)
 * 1=�ڷ��ȣ (jaryo_bunho)
 * 2=���������ȣ (bupum_bunho)
 * 3=��Ʈ�ڵ� (part_cd)
 * 4=�ڷ�� (jaryo_irum)
 * 5=���� (part_count)
 * 6=�ż� (maesu)
 * 7=���� (* BOM�� ���ڰ��踦 A,B,C������ ��Ÿ����.) : (level_gubun)
 * 8=QAR (--)
 * 9=�˻���� (--)
 * 10=�����ڷ� (--)
 * 11=���� (--)
 * 12=����ó (gumae_cheo)
 * 13=��� (bigo)
 */
 
/*
SELECT bd_number, ref_number, COALESCE(LPAD(' ', 4 * (LEVEL-1)),'') || bd_title, bd_memo , LEVEL
FROM tbm_notice_board
--WHERE user_cd='park'
WHERE bd_pwd='1234'
START WITH ref_number IS NULL
CONNECT BY PRIOR bd_number=ref_number
----------------------------------------
SELECT sys_bom_id, sys_bom_parentid, COALESCE(LPAD(' ', 4 * (LEVEL-1)),'') || jaryo_irum, bupum_bunho, jaryo_bunho , LEVEL, level_gubun
FROM tbm_bom_info
WHERE bom_cd='581-A42000'
	AND bom_cd_rev='0'
START WITH sys_bom_parentid='0'
CONNECT BY PRIOR sys_bom_id=sys_bom_parentid
ORDER  BY sys_bom_id;
*/
public class Excel2Bom {
	String sqlPath = "E:/HENESYS/���̾�/";
	String sqlPathFile = "581-A42000-�ڷ���.xlsx";

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
	
	// BOM
	BomUtil bomUtil = null;
	int HEAD_ROW_COUNT = 6;
	int HEAD_ROW_INDEX = 5;

	public Excel2Bom() {
		try {
			String mainPath = sqlPath + sqlPathFile;
			File dataFile = new File(mainPath);

			Excel2Bom e2d = new Excel2Bom(dataFile);
			e2d.doExcelProcess(dataFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Excel2Bom(File dataFile) {
		try {
			bomUtil = new BomUtil();
			
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
			
			// BOM�ڵ�
			String BOM_CODE = "";
			String BOM_CODE_REV = "0";
			// ����
			String SYS_BOM_ID = "";
			// BOM������ȣ (����)
			String SYS_BOM_PARENTID = "";
			// �ڷ��ȣ
			String JARYO_BUNHO = "";
			// ���������ȣ
			String BUPUM_BUNHO = "";
			// ��Ʈ�ڵ� (�̳��� ��Ʈ����Ʈ�� �ڵ�� ��Ī�ȴ�.)
			String part_cd = "";
			// ��Ʈ�ڵ��� ��������ȣ
			String PART_CD_REV = "";
			// �ڷ��
			String JARYO_IRUM = "";
			// ����
			String PART_COUNT = "";
			// �ż�
			String MAESU = "";
			// ����(����)
			String LEVEL_GUBUN = "";
			String OLD_LEVEL_GUBUN = "";
			// ����
			String MODIFY_HIST = "";
			// ����ó
			String GUMAE_CHEO = "";
			// ���
			String BIGO = "";
			
			for (int i=0; i<sheetCount; i++) {
				// SHEET�� �Ӽ��� ���Ѵ�.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				
				fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//���� �д´�
				    row = sheet.getRow(r);
				    //���� ��
			        cellCount = row.getPhysicalNumberOfCells();
			        
					// 5���� �ο쿡�� ��������� �־ ����.
					// ���� ����ؾ��� �������� r=5 �� 6��° �ٺ��� ���۵ȴ�.
					if (r < HEAD_ROW_INDEX) {
						if ( r == 1) {
							cell = row.getCell(4);
							cellData = cell.getStringCellValue();
							BOM_CODE = cellData.trim();
							System.out.println("BOM_CODE=" + BOM_CODE);
						}
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					// �⺻ ��� ������ ����� �д�.   
					sqlBuffer.append("INSERT INTO tbm_bom_info (	");
					sqlBuffer.append("		bom_cd				");
					sqlBuffer.append("		,bom_cd_rev			");
					sqlBuffer.append("		,sys_bom_id			");
					sqlBuffer.append("		,sys_bom_parentid	");
					sqlBuffer.append("		,jaryo_bunho		");
					sqlBuffer.append("		,bupum_bunho		");
					sqlBuffer.append("		,part_cd			");
					sqlBuffer.append("		,part_cd_rev		");
					sqlBuffer.append("		,jaryo_irum			");
					sqlBuffer.append("		,part_count			");
					sqlBuffer.append("		,maesu				");
					sqlBuffer.append("		,level_gubun		");
					sqlBuffer.append("		,modify_hist		");
					sqlBuffer.append("		,gumae_cheo			");
					sqlBuffer.append("		,bigo)				");
					sqlBuffer.append("VALUES ( ");
					

			        // ����(SYS_BOM_ID)
					cell = row.getCell(0);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					SYS_BOM_ID = ""+(int)(Common.getDouble( cellData.trim()));
					if (SYS_BOM_ID.length() <= 0) {
						System.out.println("���� �ڷᰡ ��Ȯ���� �ʽ��ϴ�.");
						sqlBuffer.delete(0, sqlBuffer.length());
						return;
					}
					// �Ʒ��� �����̸� ���̴�...
					if (SYS_BOM_ID.equals("0") && r > (rowCount-HEAD_ROW_COUNT)) {
						System.out.println("FINISHED...");
						break;
					}
			        
					// �ڷ��ȣ (JARYO_BUNHO)
					cell = row.getCell(1);
					cellData = cell.getStringCellValue();
					JARYO_BUNHO = cellData.trim();
					if (JARYO_BUNHO.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("�ڷ��ȣ�� ��Ȯ���� �ʽ��ϴ�.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					// BOM�� ó�� �ο�(r==5)�� �ڷ��ȣ�� BOM�ڵ�� ����.
					if (r == HEAD_ROW_INDEX) {
						if (!BOM_CODE.equals(JARYO_BUNHO)) {
							System.out.println("�ڷ��ȣ�� BOM�ڵ尡 ��ġ���� �ʽ��ϴ�.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// ���������ȣ (BUPUM_BUNHO)
					cell = row.getCell(2);
					cellData = cell.getStringCellValue();
					BUPUM_BUNHO = cellData.trim();
					if (BUPUM_BUNHO.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("���������ȣ�� ��Ȯ���� �ʽ��ϴ�.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					// BOM�� ó�� �ο�(r==5)�� ���������ȣ�� BOM�ڵ�� ����.
					if (r == HEAD_ROW_INDEX) {
						if (!BOM_CODE.equals(BUPUM_BUNHO)) {
							System.out.println("���������ȣ�� BOM�ڵ尡 ��ġ���� �ʽ��ϴ�.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// ��Ʈ�ڵ� (part_cd)
					cell = row.getCell(3);
					cellData = cell.getStringCellValue();
					part_cd = cellData.trim();
					// ��Ʈ�ڵ尡 �����Ǿ��� ������...
					if (part_cd.length() > 0) {
						// �����ؼ� ��������ȣ�� �����´�.
						String cntSql = "select REVISION_NO from TBM_PART_LIST where PART_CD ='" + part_cd + "' order by REVISION_NO desc";
						//------------ �켱 ���Ƶд�.
						//PART_CD_REV = database.getColumnValue(con, cntSql).trim();
						if ("".equals(PART_CD_REV) ) {
							PART_CD_REV = "0";
						}
					} else {
						// �⺻�� "0"�̴�.
						PART_CD_REV = "0";
					}
					
					// �ڷ��
					cell = row.getCell(4);
					cellData = cell.getStringCellValue();
					JARYO_IRUM = cellData.trim();
					JARYO_IRUM = JARYO_IRUM.replaceAll("'", "");

					// ����
					cell = row.getCell(5);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					System.out.println("PART_COUNT=" + cellData);
					try {
						PART_COUNT = ""+(int)(Common.getDouble( cellData.trim()));
					} catch (Exception e) {
						PART_COUNT = "0";
					}

					// �ż�
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					try {
						MAESU = ""+(int)(Common.getDouble( cellData.trim()));
					} catch (Exception e) {
						MAESU = "0";
					}
					
					/////////////////////////////////////////////////////////////////
					// ����(����)
					cell = row.getCell(7);
					cellData = cell.getStringCellValue();
					LEVEL_GUBUN = cellData.trim();
					if (LEVEL_GUBUN.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("����(����) �ڷᰡ ��Ȯ���� �ʽ��ϴ�.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// ����صд�.
					bomUtil.recordBomId4AlphaBetLevel(LEVEL_GUBUN, SYS_BOM_ID);
					// ���� BOM-ID�� ���ؼ� ���´�.
					SYS_BOM_PARENTID = bomUtil.getMyParentId(LEVEL_GUBUN);
					
					//////////////////////////////////////////////////////////////////
					
					// QAR
					cell = row.getCell(8);
					// �˻����	
					cell = row.getCell(9);
					// �����ڷ�
					cell = row.getCell(10);

					// ����
					cell = row.getCell(11);
					cellData = cell.getStringCellValue();
					MODIFY_HIST = cellData.trim();
					MODIFY_HIST = MODIFY_HIST.replaceAll("'", "");

					// ����ó
					cell = row.getCell(12);
					try {
						cellData = cell.getStringCellValue();
					} catch (Exception e) {
						cellData = "";
					}
					GUMAE_CHEO = cellData.trim();
					GUMAE_CHEO = GUMAE_CHEO.replaceAll("'", "");
					
					// ���
					cell = row.getCell(13);
					cellData = cell.getStringCellValue();
					BIGO = cellData.trim();
					BIGO = BIGO.replaceAll("'", "");

					//===================================================
					//===================================================

					// ������ �ϼ��Ѵ�.
					sqlBuffer.append("'" + BOM_CODE + "'			");
					sqlBuffer.append(",'" + BOM_CODE_REV + "'		");
					sqlBuffer.append(",'" + SYS_BOM_ID + "'			");
					sqlBuffer.append(",'" + SYS_BOM_PARENTID + 	"'	");
					sqlBuffer.append(",'" + JARYO_BUNHO + "'		");
					sqlBuffer.append(",'" + BUPUM_BUNHO + "'		");
					sqlBuffer.append(",'" + part_cd + "'			");
					sqlBuffer.append(",'" + PART_CD_REV + "'		");
					sqlBuffer.append(",'" + JARYO_IRUM + "'			");
					sqlBuffer.append(",'" + PART_COUNT + "'			");
					sqlBuffer.append(",'" + MAESU + "'				");
					sqlBuffer.append(",'" + LEVEL_GUBUN + "'		");
					sqlBuffer.append(",'" + MODIFY_HIST + "'		");
					sqlBuffer.append(",'" + GUMAE_CHEO + "'			");
					sqlBuffer.append(",'" + BIGO + "');\n			");

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
		new Excel2Bom();
	}
}
