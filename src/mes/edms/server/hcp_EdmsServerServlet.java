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
	long max_content_length = 50 * 1024 * 1024; // 50메가바이트
	byte[] buffer = new byte[BUF_SIZE];
	
	// 2021-05-14 서승헌
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
		
		// 한글문제 해결
		request.setCharacterEncoding(CHARSET);

		// 업로드인지 다운로드인지를 구분한다.
		String contentType = request.getContentType();
		logger.info("[HACCP EDMS] contentType :" + contentType);
		if(contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
			IS_MULTIPART = true;
		} else {
			IS_MULTIPART = false;
		}

		///////////////////////////////////////////////////////////////////////////////
		// 업로드 
		///////////////////////////////////////////////////////////////////////////////
		if (IS_MULTIPART) {
			// 해쉬테이블
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
			
			logger.info("[HACCP EDMS] 실제 서블릿 상 업로드 경로 :" + docPath);
			
			// 파일을 받아와서 폴더에 업로드 하면 된다.
			MultipartRequest multipart = null;
			
			try {
				multipart = new MultipartRequest(resp.getWriter(), 
						request.getContentType(),
						request.getContentLength(),
						request.getInputStream(),
						docPath,
						(int)max_content_length,
						encType);
				
				// 클라이언트에서 올려보낸 파라미터들을 해쉬테이블에 담는다.
				Enumeration all_enumer = multipart.getParameterNames();
				while(all_enumer.hasMoreElements()) {
					String key = all_enumer.nextElement().toString();
					String value = multipart.getURLParameter(key);
					
					logger.info("[HACCP EDMS] >> " + key + " : " + value);
		            hashObject.put(key, value);
				}
				
				// 확인하기위해 터미널에 뿌린다
				hashObject.print();

		    	// 서블릿에 연결한다.
		        DBServletLink dbServletLink = new DBServletLink();
				String pid = String.valueOf(hashObject.get("pid", HashObject.YES));

				// 뭘 하라고 하는지 알아보자...
				MY_JOB_TYPE = String.valueOf(hashObject.get("JobType", HashObject.YES)).trim();
				logger.info("[HACCP EDMS] 문서 처리 구분 :" + MY_JOB_TYPE);
				// 해달라고 하는대로 하자..
				
				////////////////////////////////////////////////
				// 등록
				////////////////////////////////////////////////
				if (MY_JOB_TYPE.equals("INSERT")) {
					MY_JOB_TYPE_INT = 111;
				}
				////////////////////////////////////////////////
				// 개정
				////////////////////////////////////////////////
				else if (MY_JOB_TYPE.equals("UPDATE")) {
					MY_JOB_TYPE_INT = 222;
				}
				////////////////////////////////////////////////
				// 순전히 디비만 업데이트 하는 경우에 해당한다.
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
					
					//DB에 파일정보 Insert/Update/Delete한다.
			        dbServletLink.connectURL(pid);	//올라온 PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_UPDATE";
			        } else {
						reTurnCount = "ERROR|DB_UPDATE";
			        }
			        // 클라이언트에게 보낸다.
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
					
					//DB에 파일정보 Insert/Update/Delete한다.
			        dbServletLink.connectURL(pid);	//올라온 PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_DELETE";
			        } else {
						reTurnCount = "ERROR|DB_DELETE";
			        }
			        // 클라이언트에게 보낸다.
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
				
				// 전송된 파일이름 filename1, filename2를 가져온다.
				Enumeration enumer = multipart.getFileParameterNames();

				while(enumer.hasMoreElements()) {
					// 아래 SQL은 헤드로써 공히 사용되므로 파일이 여러개라도 한번만 만들어두면 된다.
					sql = new StringBuffer(); 
					sql.append(String.valueOf(hashObject.get("jspPage", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("user_id", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("getnum_prefix", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("orderno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("lotno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("reg_reason", HashObject.YES)) + "|")
						.toString();
					try {
						// 이 변수 "name"은 클라이언트에서 해당파일에 명명된 이름이다.
						// 이 넘을 기준으로 해당 변수들을 챙기기로 한다.
						name = enumer.nextElement().toString();
						logger.info("[HACCP EDMS] NAME :" + name);
						
						// 이 변수 name에 들어있는 값 즉, filenameX의 X가 항상 순차적으로 1,2,3,4,5로 되지 않을 수도 있지 않을까.
						// 그래서 가져온 이름의 끝에 붙어 있는 숫자값을 읽어서 그넘을 기준으로 처리한다.
						try {
							FILE_CHECK_NUMBER = name.substring(FILE_CHECK_NAME.length()).trim();
							logger.info("[HACCP EDMS] FILE_CHECK_NUMBER :" + FILE_CHECK_NUMBER);
						} catch (Exception ee) {
						}
						
						String doccode = "";
						String revno = "";
						String registno = String.valueOf(hashObject.get("regist_no", HashObject.YES)); // 2021-05-13 서승헌 seq_no 추가
						
						// 2021-05-14 서승헌
						Connection con = JDBCConnectionPool.getConnection();
						
						if("".equals(registno) || registno == null) {
							
							ActionNo = new ApprovalActionNo();
							gRegNo = ActionNo.getActionNo(con,String.valueOf(hashObject.get("jspPage", HashObject.YES)),String.valueOf(hashObject.get("user_id", HashObject.YES)),
									String.valueOf(hashObject.get("getnum_prefix", HashObject.YES)),"Regist",String.valueOf(hashObject.get("member_key", HashObject.YES)));
							
							registno = gRegNo;
							logger.info("[HACCP EDMS] registno :"+ registno);
						}
						
						// name 파라미터에는 file의 이름이 들어있다.
						// 그 이름을 주면 실제 값(업로드 "할"file)을 가져온다.
						String originFile =multipart.getBaseFilename(name);
						logger.info("[HACCP EDMS] Origin File :" + originFile);
						
						// 만약 업로드 폴더에 똑같은 파일이 있으면.. 현재 올리는 파일이름을 바꾼다.(중복회피정책)
						// 그래서 시스템에 있는 이름을 알려준다.
						String systemFile = multipart.getFileSystemName(name);
						logger.info("[HACCP EDMS] System File :" + systemFile);
						
						// 전송된 파일의 타입-MIME타입 (기계어, 이미지, HTML, txt, ...)
						String fileType = multipart.getContentType(name);
						logger.info("[HACCP EDMS] File Type=" + fileType);
						
						// 문자열 "파일이름"이 name에 들어온 상태
						// 문자열 파일이름을 통해 실제 파일 객체를 가져온다.
						if(multipart.getFile(name) != null) {
							File file = multipart.getFile(name);
							logger.info("[HACCP EDMS] Temp File Name :" + file.getName());

							String realFileName = "";
							File renameFile = new File(docPath + "/" + originFile);
							file.renameTo(renameFile); 
							
							//파일
							if (file != null) {
								realFileName = renameFile.getAbsoluteFile().toString();
								logger.info("[HACCP EDMS] 크기: " + file.length() + "bytes");
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
							} else if (MY_JOB_TYPE_INT == 222) {	//개정
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
								logger.info("[HACCP EDMS] 개정파라메터=" + upParam );
								
								// 개정관련 일반 변수들..
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
								
								// 개정관련 KEY 변수들.. registno
								MODIFY_DOC_PARAM += registno + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("document_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("file_view_name"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("pre_revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("member_key"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("seq_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								logger.info("[HACCP EDMS] MODIFY_DOC_PARAM=" + MODIFY_DOC_PARAM);
							} else if (MY_JOB_TYPE_INT == 229) {	//DB내용만 수정
								// 위에서 처리했다.	
							} else if (MY_JOB_TYPE_INT == 228) {	//파일만 수정 
							} else if (MY_JOB_TYPE_INT == 333) {	//문서폐기
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

							/* 파일을 처리하는 경우에만 이 루틴을 처리한다 */
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
										//DB에 파일정보 Insert/Update/Delete한다.
								        dbServletLink.connectURL(pid);	//올라온 PID

								        realFileName = docPath + "/" + member_key + "/" + 
								        			   doccode + "/" + registno + "/" + originFile + "/" + 
								        			   revno + "/" + originFile;
//								        realFileName = saveFolder + "/" + member_key + "/" + 
//								        		doccode + "/" + registno + "/" + originFile + "/" + 
//								        		revno + "/" + originFile;
								        sub_sql.append(realFileName + "|");
								        dbServletLink.queryProcess(sql.toString() + sub_sql.toString() + NORMAL_DOC_PARAM + MODIFY_DOC_PARAM, false);
								        
										// 성공했다고 표시한다.
								    	// text/html; charset=utf-8을 대체
								        String rtnStn = "OK-" + systemFile + "\r\n";
								        
										resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
										// 성공했으면 파일을 지운다.
										renameFile.delete();
										logger.info(renameFile.getAbsolutePath()+" DELETED");
									} else {
								        String rtnStn = "ERROR-" + systemFile + "<br>\r\n";
								        resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
								        
								        // DB Insert 실패 시 여기서 crefileName을 지워줘야 할 듯
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
		// 다운로드 
		///////////////////////////////////////////////////////////////////////////////
		else {
			logger.info("[HACCP EDMS] Download Process...");
			// 파일을 다운로드 할 때 파일의 제목이 인코딩에 따라 제목이 깨질 수 있다. 따라서 제목 인코딩이 필요하다.
			// 유형을 파악해야 한다.
			// FileInputStream: byte stream- 여러 유형의 byte 단위 일기 전송
			// FileReader: char Stream 문자 최적화

			// 다운로드할 파일을 JSP에서 받아온다.
			// 예) <a href="http://localhost:8080/FileServer/hcp_EdmsServerServlet?fileName=<%=fileName1%>"><%=originalName1%></a>
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
	    	// 서블릿에 연결한다.
			//문서 조회 로그를 남김다
	        DBServletLink dbServletLink = new DBServletLink();
	        dbServletLink.connectURL("M000S100000E301");	//올라온 PID
	        dbServletLink.queryProcess(down_parm, false);

	        
	        if (dbServletLink.ERROR_CODE >= 0) {
				reTurnCount = "OK|DB_DELETE";
	        } else {
				reTurnCount = "ERROR|DB_DELETE";
	        }
	        
			logger.info("[HACCP EDMS] fileName=" + down_parm);

			URL connectUrl = new URL(edmsServerDownloadUrl+"?fileName="+fileName + "&doccode=" + document_no + "&revno="+ regist_no_rev);

			// 여기(웹서버)에는 다운로드할 파일이 없다. 따라서 파일서버에 요청해야한다.
			HttpURLConnection conn = (HttpURLConnection)connectUrl.openConnection();
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");

			// 이넘은 다운로드 파일의 이름을 원하는 대로 받아내기 위해서 필 수적으로 필요한 넘이다. 
			resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			
			// 파일서버와의 입력스트림
			DataInputStream dis = new DataInputStream(conn.getInputStream());
		    
			// 브라우저에 쓰기 스트림
			ServletOutputStream out2Browser = resp.getOutputStream();
					
			int numRead = 0;
			byte[] buf = new byte[50*1024*1024];
					
			// 바이트 배열 buf의 0번부터 numRead번까지 브라우저로 출력
			while((numRead=dis.read(buf, 0, buf.length)) != -1) {
				out2Browser.write(buf, 0, numRead);
			}
			out2Browser.flush();
			out2Browser.close();
			
			dis.close();
		}
	}
}
