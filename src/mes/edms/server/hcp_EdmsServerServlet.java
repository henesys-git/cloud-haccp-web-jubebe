package mes.edms.server;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.util.Enumeration;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import mes.client.comm.DBServletLink;
import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.HashObject;
import mes.frame.database.JDBCConnectionPool;

public class hcp_EdmsServerServlet extends HttpServlet {   	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = Logger.getLogger(hcp_EdmsServerServlet.class.getName());
	
	private static String OS = System.getProperty("os.name").toLowerCase();
	
	HttpFileUploader httpFileUploader = null;
	boolean IS_MULTIPART = true;
	
	String FILE_CHECK_NUMBER = "";
	String FILE_CHECK_NAME = "filenames";
	
	String NORMAL_DOC_PARAM = "";
	String MODIFY_DOC_PARAM = "";
	
	String MY_JOB_TYPE = "";
	int MY_JOB_TYPE_INT = 0;
	String MY_PARAMS = "";
	
	String reTurnCount="";
	int EOF = -1;
	int BUF_SIZE = 8 * 1024;
	int bytesRead = 0;
	long max_content_length = 50 * 1024 * 1024; // 50�ް�����Ʈ
	byte[] buffer = new byte[BUF_SIZE];
	
	// 2021-05-14 ������
	ApprovalActionNo ActionNo;
	String gRegNo="";
	//////////////////////////
	
	String line = "";
	String CONTENT_BOUNDARY_TAG = "boundary=";
	String CHARSET = "UTF-8";
	String webServerUrl = Config.WEBSERVERURL; //"http://localhost:8080/FileServer/hcp_EdmsServerServlet";
	String edmsServerUploadUrl = Config.EDMSSERVERUPLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileUpload.jsp";
	String edmsServerDownloadUrl = Config.EDMSSERVERDOWNLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileDownload.jsp";

	public void init(ServletConfig config) throws ServletException {
		super.init(config);				
		logger.info("[HACCP EDMS] Servlet Started");
		httpFileUploader = new HttpFileUploader();
		ServletContext context = this.getServletContext();
		Config.sysConfigPath = context.getRealPath("/");
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			performTask(req, res);
		} catch (Exception e){}
	}
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			performTask(req, res);
		} catch (Exception e){}
	}
	
	void procDbUpdate() {
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void performTask(HttpServletRequest request, HttpServletResponse resp) 
			throws ServletException, IOException, Exception {
		logger.info("[HACCP EDMS] performTask called");
		
		// �ѱ۹��� �ذ�
		request.setCharacterEncoding(CHARSET);

		// ���ε����� �ٿ�ε������� �����Ѵ�.
		String contentType = request.getContentType();
		logger.info("[HACCP EDMS] contentType :" + contentType);
		if(contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
			IS_MULTIPART = true;
		} else {
			IS_MULTIPART = false;
		}

		///////////////////////////////////////////////////////////////////////////////
		// ���ε� 
		///////////////////////////////////////////////////////////////////////////////
		if (IS_MULTIPART) {
			// �ؽ����̺�
			HashObject hashObject = new HashObject();
			
			String encType = CHARSET;
			int maxSize = 50 * 1024 * 1024; // 5MByte
			String docPath = "";
			
			if (OS.indexOf("win") >= 0) {
			    docPath = "C:/DocServer";
			    
			    File f = new File(docPath);
			    if(!f.exists()) {
			    	f.mkdir();
			    }
			} else {
			    docPath = "/home/henesys/DocServer";
			    
			    File f = new File(docPath);
			    if(!f.exists()) {
			    	f.mkdir();
			    }
			}
			
			logger.info("[HACCP EDMS] ���� ���� �� ���ε� ��� :" + docPath);
			
			// ������ �޾ƿͼ� ������ ���ε� �ϸ� �ȴ�.
			MultipartRequest multipart = null;
			
			try {
				multipart = new MultipartRequest(resp.getWriter(), 
						request.getContentType(),
						request.getContentLength(),
						request.getInputStream(),
						docPath,
						(int)max_content_length,
						encType);
				
				// Ŭ���̾�Ʈ���� �÷����� �Ķ���͵��� �ؽ����̺� ��´�.
				Enumeration all_enumer = multipart.getParameterNames();
				while(all_enumer.hasMoreElements()) {
					String key = all_enumer.nextElement().toString();
					String value = multipart.getURLParameter(key);
					
					logger.info("[HACCP EDMS] >> " + key + " : " + value);
		            hashObject.put(key, value);
				}
				
				// Ȯ���ϱ����� �͹̳ο� �Ѹ���
				hashObject.print();

		    	// ������ �����Ѵ�.
		        DBServletLink dbServletLink = new DBServletLink();
				String pid = String.valueOf(hashObject.get("pid", HashObject.YES));

				// �� �϶�� �ϴ��� �˾ƺ���...
				MY_JOB_TYPE = String.valueOf(hashObject.get("JobType", HashObject.YES)).trim();
				logger.info("[HACCP EDMS] ���� ó�� ���� :" + MY_JOB_TYPE);
				// �ش޶�� �ϴ´�� ����..
				
				////////////////////////////////////////////////
				// ���
				////////////////////////////////////////////////
				if (MY_JOB_TYPE.equals("INSERT")) {
					MY_JOB_TYPE_INT = 111;
				}
				////////////////////////////////////////////////
				// ����
				////////////////////////////////////////////////
				else if (MY_JOB_TYPE.equals("UPDATE")) {
					MY_JOB_TYPE_INT = 222;
				}
				////////////////////////////////////////////////
				// ������ ��� ������Ʈ �ϴ� ��쿡 �ش��Ѵ�.
				////////////////////////////////////////////////
				else if (MY_JOB_TYPE.equals("DB_UPDATE")) {
					MY_JOB_TYPE_INT = 229;
					
					MY_PARAMS = "";
					MY_PARAMS += String.valueOf(hashObject.get("regist_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("revision_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("document_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("file_view_name", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("external_doc", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("keep_yn", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("gwanribon_yn", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("total_page", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("user_id", HashObject.YES)) + "|";			
					MY_PARAMS += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("doc_gubunAfter", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("modify_reason", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("member_key", HashObject.YES)) + "|";
					
					//DB�� �������� Insert/Update/Delete�Ѵ�.
			        dbServletLink.connectURL(pid);	//�ö�� PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_UPDATE";
			        } else {
						reTurnCount = "ERROR|DB_UPDATE";
			        }
			        // Ŭ���̾�Ʈ���� ������.
					resp.setContentType("text/html");
					resp.setHeader("Cache-Control", "no-store");
					resp.getWriter().print(reTurnCount);
					return;
				}
				else if (MY_JOB_TYPE.equals("FILE_UPDATE")) {
					MY_JOB_TYPE_INT = 228;
				}
				else if (MY_JOB_TYPE.equals("DELETE")) {
					MY_JOB_TYPE_INT = 333;
				}
				else if (MY_JOB_TYPE.equals("DB_DELETE")) {
					MY_JOB_TYPE_INT = 339;
					
					MY_PARAMS = "";
					MY_PARAMS += String.valueOf(hashObject.get("regist_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("revision_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("document_no", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("file_view_name", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("external_doc", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("keep_yn", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("gwanribon_yn", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("total_page", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("user_id", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
					MY_PARAMS += String.valueOf(hashObject.get("member_key", HashObject.YES)) + "|";
					
					//DB�� �������� Insert/Update/Delete�Ѵ�.
			        dbServletLink.connectURL(pid);	//�ö�� PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_DELETE";
			        } else {
						reTurnCount = "ERROR|DB_DELETE";
			        }
			        // Ŭ���̾�Ʈ���� ������.
					resp.setContentType("text/html");
					resp.setHeader("Cache-Control", "no-store");
					resp.getWriter().print(reTurnCount);
					return;
				} else if (MY_JOB_TYPE.equals("FILE_DELETE")) {
					MY_JOB_TYPE_INT = 338;
				} else {
					MY_JOB_TYPE_INT = 999;
				}
				
				String name = "";
				String upParam = "";
				StringBuffer sql = null;
				
				// ���۵� �����̸� filename1, filename2�� �����´�.
				Enumeration enumer = multipart.getFileParameterNames();

				while(enumer.hasMoreElements()) {
					// �Ʒ� SQL�� ���ν� ���� ���ǹǷ� ������ �������� �ѹ��� �����θ� �ȴ�.
					sql = new StringBuffer(); 
					sql.append(String.valueOf(hashObject.get("jspPage", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("user_id", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("getnum_prefix", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("orderno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("lotno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("reg_reason", HashObject.YES)) + "|")
						.toString();
					try {
						// �� ���� "name"�� Ŭ���̾�Ʈ���� �ش����Ͽ� ���� �̸��̴�.
						// �� ���� �������� �ش� �������� ì���� �Ѵ�.
						name = enumer.nextElement().toString();
						logger.info("[HACCP EDMS] NAME :" + name);
						
						// �� ���� name�� ����ִ� �� ��, filenameX�� X�� �׻� ���������� 1,2,3,4,5�� ���� ���� ���� ���� ������.
						// �׷��� ������ �̸��� ���� �پ� �ִ� ���ڰ��� �о �׳��� �������� ó���Ѵ�.
						try {
							FILE_CHECK_NUMBER = name.substring(FILE_CHECK_NAME.length()).trim();
							logger.info("[HACCP EDMS] FILE_CHECK_NUMBER :" + FILE_CHECK_NUMBER);
						} catch (Exception ee) {
						}
						
						String doccode = "";
						String revno = "";
						String registno = String.valueOf(hashObject.get("regist_no", HashObject.YES)); // 2021-05-13 ������ seq_no �߰�
						
						// 2021-05-14 ������
						Connection con = JDBCConnectionPool.getConnection();
						
						if("".equals(registno) || registno == null) {
							
							ActionNo = new ApprovalActionNo();
							gRegNo = ActionNo.getActionNo(con,String.valueOf(hashObject.get("jspPage", HashObject.YES)),String.valueOf(hashObject.get("user_id", HashObject.YES)),
									String.valueOf(hashObject.get("getnum_prefix", HashObject.YES)),"Regist",String.valueOf(hashObject.get("member_key", HashObject.YES)));
							
							registno = gRegNo;
							logger.info("[HACCP EDMS] registno :"+ registno);
						}
						
						// name �Ķ���Ϳ��� file�� �̸��� ����ִ�.
						// �� �̸��� �ָ� ���� ��(���ε� "��"file)�� �����´�.
						String originFile =multipart.getBaseFilename(name);
						logger.info("[HACCP EDMS] Origin File :" + originFile);
						
						// ���� ���ε� ������ �Ȱ��� ������ ������.. ���� �ø��� �����̸��� �ٲ۴�.(�ߺ�ȸ����å)
						// �׷��� �ý��ۿ� �ִ� �̸��� �˷��ش�.
						String systemFile = multipart.getFileSystemName(name);
						logger.info("[HACCP EDMS] System File :" + systemFile);
						
						// ���۵� ������ Ÿ��-MIMEŸ�� (����, �̹���, HTML, txt, ...)
						String fileType = multipart.getContentType(name);
						logger.info("[HACCP EDMS] File Type=" + fileType);
						
						// ���ڿ� "�����̸�"�� name�� ���� ����
						// ���ڿ� �����̸��� ���� ���� ���� ��ü�� �����´�.
						if(multipart.getFile(name) != null) {
							File file = multipart.getFile(name);
							logger.info("[HACCP EDMS] Temp File Name :" + file.getName());

							String realFileName = "";
							File renameFile = new File(docPath + "/" + originFile);
							file.renameTo(renameFile); 
							
							//����
							if (file != null) {
								realFileName = renameFile.getAbsoluteFile().toString();
								logger.info("[HACCP EDMS] ũ��: " + file.length() + "bytes");
								logger.info("[HACCP EDMS] file.getAbsoluteFile()=" + file.getAbsoluteFile().toString() );
								logger.info("[HACCP EDMS] renameFile.getAbsoluteFile()=" + renameFile.getAbsoluteFile().toString() );
							}
							
							NORMAL_DOC_PARAM = "";
							MODIFY_DOC_PARAM = "";

							StringBuffer sub_sql = new StringBuffer();
							
							if (MY_JOB_TYPE_INT == 111) {
								sub_sql.append(String.valueOf(hashObject.get("docname"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_name
						 			   .append(String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_code
						 			   .append(String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//Doc_code_revision_no
						 			   .append(String.valueOf(hashObject.get("doc_gubun"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_gubun1
						 			   .append(originFile + "|");
								
								upParam = "?doccode=" + String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) 
										 	+ "&revno=0&registno="+registno;
								doccode = String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES));
								revno	= "0";
								
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("member_key", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += registno + "|";
								
								logger.info("[HACCP EDMS] NORMAL_DOC_PARAM = " + NORMAL_DOC_PARAM);
							} else if (MY_JOB_TYPE_INT == 222) {	//����
								sub_sql.append(String.valueOf(hashObject.get("docname"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_name
						 		.append(String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_code 
							 	.append(String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//Doc_code_revision_no
							 	.append(String.valueOf(hashObject.get("doc_gubun"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_gubun1
							 	.append(originFile + "|");
								
								upParam = "?doccode=" + String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) 
										 	+ "&revno="  + String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES))
										 	+ "&registno="+registno;

								doccode = String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES));
								revno	= String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES));
								logger.info("[HACCP EDMS] �����Ķ����=" + upParam );
								
								// �������� �Ϲ� ������..
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
								
								// �������� KEY ������.. registno
								MODIFY_DOC_PARAM += registno + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("document_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("file_view_name"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("pre_revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("member_key"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("seq_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								logger.info("[HACCP EDMS] MODIFY_DOC_PARAM=" + MODIFY_DOC_PARAM);
							} else if (MY_JOB_TYPE_INT == 229) {	//DB���븸 ����
								// ������ ó���ߴ�.	
							} else if (MY_JOB_TYPE_INT == 228) {	//���ϸ� ���� 
							} else if (MY_JOB_TYPE_INT == 333) {	//�������
							} else {
								sub_sql.append(String.valueOf(hashObject.get("docname"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_name
						 		.append(String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_code 
							 	.append(String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//Doc_code_revision_no
							 	.append(String.valueOf(hashObject.get("doc_gubun"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_gubun1
							 	.append(originFile + "|");
								
								logger.info(sub_sql.toString());
								upParam = "?doccode=" + String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) 
										 	+ "&revno=0" ;

								doccode = String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES));
								revno	= String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES));
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
							}

							/* ������ ó���ϴ� ��쿡�� �� ��ƾ�� ó���Ѵ� */
							if (MY_JOB_TYPE_INT==111 || MY_JOB_TYPE_INT==222) {
								String member_key = String.valueOf(hashObject.get("member_key", HashObject.YES));

								String makeDir = "";
								String doc_savepath = docPath + "/" + member_key;
								makeDir = doc_savepath + "/" + doccode + "/" + registno + "/" + originFile + "/" + revno;
								
								File SERVER_path 	= new File(doc_savepath + "/");
								File doccodeffile 	= new File(doc_savepath + "/" + doccode);
								File registnofile 	= new File(doc_savepath + "/" + doccode + "/" + registno);
								File fileNamefile 	= new File(doc_savepath + "/" + doccode + "/" + registno + "/" + originFile);
								File revnofile 		= new File(doc_savepath + "/" + doccode + "/" + registno + "/" + originFile + "/" + revno);
								
								if(!SERVER_path.exists()) {
									SERVER_path.mkdir();
								}
								if(!doccodeffile.exists()) {
									doccodeffile.mkdir();
								}
								if(!registnofile.exists()) {
									registnofile.mkdir();
								}
								if(!fileNamefile.exists()) {
									fileNamefile.mkdir();
								}
								if(!revnofile.exists()) {
									revnofile.mkdir();
								}
								
								File crenameFile = new File(makeDir + "/" + originFile);
								
								if(crenameFile.exists()) {
									logger.info("[HACCP EDMS] Error, Destination File Already Exists");
								} else {
									boolean rnrtn = renameFile.renameTo(crenameFile);

									logger.info("[HACCP EDMS] -------------renameFile rnrtn =" +rnrtn);
									logger.info("[HACCP EDMS] -------------renameFile = " +rnrtn + "==" + renameFile.toString() );
									logger.info("[HACCP EDMS] -------------crenameFile = " +rnrtn + "==" + crenameFile.toString() );
								}
								
								if (crenameFile != null) {
							        resp.setContentType("text/html; charset=utf-8");
							        
									if (crenameFile.length() > 0) {
										//DB�� �������� Insert/Update/Delete�Ѵ�.
								        dbServletLink.connectURL(pid);	//�ö�� PID

								        realFileName = docPath + "/" + member_key + "/" + 
								        			   doccode + "/" + registno + "/" + originFile + "/" + 
								        			   revno + "/" + originFile;
//								        realFileName = saveFolder + "/" + member_key + "/" + 
//								        		doccode + "/" + registno + "/" + originFile + "/" + 
//								        		revno + "/" + originFile;
								        sub_sql.append(realFileName + "|");
								        dbServletLink.queryProcess(sql.toString() + sub_sql.toString() + NORMAL_DOC_PARAM + MODIFY_DOC_PARAM, false);
								        
										// �����ߴٰ� ǥ���Ѵ�.
								    	// text/html; charset=utf-8�� ��ü
								        String rtnStn = "OK-" + systemFile + "\r\n";
								        
										resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
										// ���������� ������ �����.
										renameFile.delete();
										logger.info(renameFile.getAbsolutePath()+" DELETED");
									} else {
								        String rtnStn = "ERROR-" + systemFile + "<br>\r\n";
								        resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
								        
								        // DB Insert ���� �� ���⼭ crefileName�� ������� �� ��
									}
								}
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
						continue;
					}
				}

				resp.setContentType("text/html");
				resp.setHeader("Cache-Control", "no-store");
				resp.getWriter().print(URLEncoder.encode(reTurnCount , "UTF-8"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		///////////////////////////////////////////////////////////////////////////////
		// �ٿ�ε� 
		///////////////////////////////////////////////////////////////////////////////
		else {
			logger.info("[HACCP EDMS] Download Process...");
			// ������ �ٿ�ε� �� �� ������ ������ ���ڵ��� ���� ������ ���� �� �ִ�. ���� ���� ���ڵ��� �ʿ��ϴ�.
			// ������ �ľ��ؾ� �Ѵ�.
			// FileInputStream: byte stream- ���� ������ byte ���� �ϱ� ����
			// FileReader: char Stream ���� ����ȭ

			// �ٿ�ε��� ������ JSP���� �޾ƿ´�.
			// ��) <a href="http://localhost:8080/FileServer/hcp_EdmsServerServlet?fileName=<%=fileName1%>"><%=originalName1%></a>
			String fileName = 	request.getParameter("fileName");
			String UserId	=	request.getParameter("user_id");
			String jsp_page	=	request.getParameter("jsp_page");
			String orderno	=	request.getParameter("orderno");					
			String regist_no	=	request.getParameter("regist_no");			
			String regist_no_rev	=	request.getParameter("regist_no_rev");			
			String document_no	=	request.getParameter("document_no");
			String IP_addr	=	request.getParameter("IP_addr");
			String document_no_rev = request.getParameter("document_no_rev");

			String down_parm = "";
			down_parm += regist_no + "|";
			down_parm += document_no + "|";
			down_parm += fileName + "|";
			down_parm += jsp_page + "|";
			down_parm += UserId + "|";
			down_parm += IP_addr + "|";
			down_parm += regist_no_rev + "|";
			down_parm += document_no_rev + "|";
			logger.info(down_parm);
	    	// ������ �����Ѵ�.
			//���� ��ȸ �α׸� �����
	        DBServletLink dbServletLink = new DBServletLink();
	        dbServletLink.connectURL("M000S100000E301");	//�ö�� PID
	        dbServletLink.queryProcess(down_parm, false);

	        
	        if (dbServletLink.ERROR_CODE >= 0) {
				reTurnCount = "OK|DB_DELETE";
	        } else {
				reTurnCount = "ERROR|DB_DELETE";
	        }
	        
			logger.info("[HACCP EDMS] fileName=" + down_parm);

			URL connectUrl = new URL(edmsServerDownloadUrl+"?fileName="+fileName + "&doccode=" + document_no + "&revno="+ regist_no_rev);

			// ����(������)���� �ٿ�ε��� ������ ����. ���� ���ϼ����� ��û�ؾ��Ѵ�.
			HttpURLConnection conn = (HttpURLConnection)connectUrl.openConnection();
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");

			// �̳��� �ٿ�ε� ������ �̸��� ���ϴ� ��� �޾Ƴ��� ���ؼ� �� �������� �ʿ��� ���̴�. 
			resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			
			// ���ϼ������� �Է½�Ʈ��
			DataInputStream dis = new DataInputStream(conn.getInputStream());
		    
			// �������� ���� ��Ʈ��
			ServletOutputStream out2Browser = resp.getOutputStream();
					
			int numRead = 0;
			byte[] buf = new byte[50*1024*1024];
					
			// ����Ʈ �迭 buf�� 0������ numRead������ �������� ���
			while((numRead=dis.read(buf, 0, buf.length)) != -1) {
				out2Browser.write(buf, 0, numRead);
			}
			out2Browser.flush();
			out2Browser.close();
			
			dis.close();
		}
	}
}
