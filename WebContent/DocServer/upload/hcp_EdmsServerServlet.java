package mes.edms.server;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
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
import mes.frame.common.HashObject;
import mes.subserver.SourceMaker;

public class hcp_EdmsServerServlet extends HttpServlet {   	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = Logger.getLogger(hcp_EdmsServerServlet.class.getName());
	
	HttpFileUploader httpFileUploader = null;
	boolean IS_MULTIPART = true;
	
	String FILE_CHECK_NUMBER = "";
	String FILE_CHECK_NAME = "filenames";
	
	String NORMAL_DOC_PARAM = "";
	String MODIFY_DOC_PARAM = "";
	
	String MY_JOB_TYPE = "";    // insert..update.. �벑�벑
	int MY_JOB_TYPE_INT = 0;    // pid ? E�뮘? 媛숈쓬
	String MY_PARAMS = "";  //�뙆�씪誘명꽣
	
	String reTurnCount="";
	int EOF = -1;       // end of file �븞��
	int BUF_SIZE = 8 * 1024;    // �븞��
	int bytesRead = 0;  // �븞��
	long max_content_length = 50 * 1024 * 1024; // 50硫붽�諛붿씠�듃
	byte[] buffer = new byte[BUF_SIZE];  //�븞��
			
	String line = "";   // �븞��
	String CONTENT_BOUNDARY_TAG = "boundary=";// �븞��
	String CHARSET = "UTF-8";
	String webServerUrl = Config.WEBSERVERURL; //"http://localhost:8080/FileServer/hcp_EdmsServerServlet";
	String edmsServerUploadUrl = Config.EDMSSERVERUPLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileUpload.jsp";
	String edmsServerDownloadUrl = Config.EDMSSERVERDOWNLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileDownload.jsp";

	public void init(ServletConfig config) throws ServletException {
		super.init(config);				
		logger.debug("Started hcp_EdmsServerServlet.....................");
		httpFileUploader = new HttpFileUploader();
		ServletContext context = this.getServletContext();
		Config conf = new Config();
		conf.sysConfigPath = context.getRealPath("/");
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
	
	public void performTask(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException, Exception {
		logger.debug("hcp_EdmsServerServlet::service(HttpServletRequest,HttpServletResponse) called");
		
		// �븳湲�臾몄젣�뒗 �씪留덇� �빐寃곗궗�떎.
		request.setCharacterEncoding(CHARSET);

		// �뾽濡쒕뱶�씤吏� �떎�슫濡쒕뱶�씤吏�瑜� 援щ텇�븳�떎.
		String contentType = request.getContentType();
		logger.debug("contentType=" + contentType);
		if(contentType != null && contentType.toLowerCase().startsWith("multipart/")) {     //�뾽濡쒕뱶
			IS_MULTIPART = true;
		} else {    // �떎�슫濡쒕뱶
			IS_MULTIPART = false;
		}

		///////////////////////////////////////////////////////////////////////////////
		// �뾽濡쒕뱶 
		///////////////////////////////////////////////////////////////////////////////
		if (IS_MULTIPART) {
			String realFolder = "";
			// �빐�돩�뀒�씠釉�
			HashObject hashObject = new HashObject();
			
			// �뾽濡쒕뱶�슜 �뤃�뜑 �씠由�
			String saveFolder = "/DocServer/DocUpload"; // �씠 �븞�쑝濡� �뱾�뼱媛�
			String encType = CHARSET;       // utf-8   
                                            //enctype="multipart/form-data" 濡� form �쟾�넚
			int maxSize = 50 * 1024 * 1024; // 5MByte
			
			// �꽌踰꾩뿉�꽌(�꽌釉붾┸) �뼱�뵒�뿉 �뼱�뒓 �뤃�뜑�뿉�꽌 �꽌釉붾┸�쑝濡� 蹂��솚�릺�굹?
			ServletContext context =  this.getServletContext();
			
			// �꽌釉붾┸�긽�쓽 upload �뤃�뜑 寃쎈줈瑜� �븣�븘�삩�떎.
			realFolder = context.getRealPath(saveFolder);
			
			// 肄섏넄/釉뚮씪�슦利덉뿉 �떎�젣 寃쎈줈瑜� 異쒕젰
			logger.debug("�떎�젣 �꽌釉붾┸ �긽 �뾽濡쒕뱶 寃쎈줈 : " + realFolder);
			
			// �뙆�씪�쓣 諛쏆븘���꽌 �뤃�뜑�뿉 �뾽濡쒕뱶 �븯硫� �맂�떎. strSaveDirectory=
			MultipartRequest multipart = null;
			
			try {
				multipart = new MultipartRequest(resp.getWriter(), 
						request.getContentType(),
						request.getContentLength(),
						request.getInputStream(),
						realFolder,
						(int)max_content_length,
						encType);
				
				// �겢�씪�씠�뼵�듃�뿉�꽌 �삱�젮蹂대궦 �뙆�씪誘명꽣�뱾�쓣 �빐�돩�뀒�씠釉붿뿉 �떞�뒗�떎.
				Enumeration all_enumer = multipart.getParameterNames();
				while(all_enumer.hasMoreElements()) {
					String key = all_enumer.nextElement().toString();
					String value = multipart.getURLParameter(key);
					
					logger.debug(">> " + key + " : " + value);
		            hashObject.put(key, value);
				}
				
				// �솗�씤�븯湲곗쐞�빐 �꽣誘몃꼸�뿉 肉뚮┛�떎
				hashObject.print();

		    	// �꽌釉붾┸�뿉 �뿰寃고븳�떎.
		        DBServletLink dbServletLink = new DBServletLink();
				String pid = String.valueOf(hashObject.get("pid", HashObject.YES));

				// 萸� �븯�씪怨� �븯�뒗吏� �븣�븘蹂댁옄...
				MY_JOB_TYPE = String.valueOf(hashObject.get("JobType", HashObject.YES)).trim();
				logger.debug("臾몄꽌 泥섎━ 援щ텇:" + MY_JOB_TYPE);
				// �빐�떖�씪怨� �븯�뒗��濡� �븯�옄..
				
				////////////////////////////////////////////////
				// �벑濡�
				////////////////////////////////////////////////
				if (MY_JOB_TYPE.equals("INSERT")) {
					MY_JOB_TYPE_INT = 111;
				}
				////////////////////////////////////////////////
				// 媛쒖젙
				////////////////////////////////////////////////
				else if (MY_JOB_TYPE.equals("UPDATE")) {
					MY_JOB_TYPE_INT = 222;
				}
				////////////////////////////////////////////////
				// �닚�쟾�엳 �뵒鍮꾨쭔 �뾽�뜲�씠�듃 �븯�뒗 寃쎌슦�뿉 �빐�떦�븳�떎.
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
					
					//DB�뿉 �뙆�씪�젙蹂� Insert/Update/Delete�븳�떎.
			        dbServletLink.connectURL(pid);	//�삱�씪�삩 PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_UPDATE";
			        } else {
						reTurnCount = "ERROR|DB_UPDATE";
			        }
			        // �겢�씪�씠�뼵�듃�뿉寃� 蹂대궦�떎.
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
					
					//DB�뿉 �뙆�씪�젙蹂� Insert/Update/Delete�븳�떎.
			        dbServletLink.connectURL(pid);	//�삱�씪�삩 PID
			        dbServletLink.queryProcess(MY_PARAMS, false);
			        if (dbServletLink.ERROR_CODE >= 0) {
						reTurnCount = "OK|DB_DELETE";
			        } else {
						reTurnCount = "ERROR|DB_DELETE";
			        }
			        // �겢�씪�씠�뼵�듃�뿉寃� 蹂대궦�떎.
					resp.setContentType("text/html");
					resp.setHeader("Cache-Control", "no-store");
					resp.getWriter().print(reTurnCount);
					return;
				} else if (MY_JOB_TYPE.equals("FILE_DELETE")) {
					MY_JOB_TYPE_INT = 338;  // �뾾�쓬
				} else {
					MY_JOB_TYPE_INT = 999;  // �뾾�쓬
				}
				
				String name = "";
				String upParam = "";
				StringBuffer sql = null;
				
				// �쟾�넚�맂 �뙆�씪�씠由� filename1, filename2瑜� 媛��졇�삩�떎.
				Enumeration enumer = multipart.getFileParameterNames();

				while(enumer.hasMoreElements()) {
					// �븘�옒 SQL�� �뿤�뱶濡쒖뜥 怨듯엳 �궗�슜�릺誘�濡� �뙆�씪�씠 �뿬�윭媛쒕씪�룄 �븳踰덈쭔 留뚮뱾�뼱�몢硫� �맂�떎.
					sql = new StringBuffer(); 
					sql.append(String.valueOf(hashObject.get("jspPage", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("user_id", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("getnum_prefix", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("orderno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("lotno", HashObject.YES)) + "|")
						.append(String.valueOf(hashObject.get("reg_reason", HashObject.YES)) + "|")
						.toString();
					try {
						// �씠 蹂��닔 "name"�� �겢�씪�씠�뼵�듃�뿉�꽌 �빐�떦�뙆�씪�뿉 紐낅챸�맂 �씠由꾩씠�떎.
						// �씠 �꽆�쓣 湲곗��쑝濡� �빐�떦 蹂��닔�뱾�쓣 梨숆린湲곕줈 �븳�떎.
						name = enumer.nextElement().toString();
						logger.debug("NAME===" + name);
						
						// �씠 蹂��닔 name�뿉 �뱾�뼱�엳�뒗 媛� 利�, filenameX�쓽 X媛� �빆�긽 �닚李⑥쟻�쑝濡� 1,2,3,4,5濡� �릺吏� �븡�쓣 �닔�룄 �엳吏� �븡�쓣源�.
						// 洹몃옒�꽌 媛��졇�삩 �씠由꾩쓽 �걹�뿉 遺숈뼱 �엳�뒗 �닽�옄媛믪쓣 �씫�뼱�꽌 洹몃꽆�쓣 湲곗��쑝濡� 泥섎━�븳�떎.
						try {
							FILE_CHECK_NUMBER = name.substring(FILE_CHECK_NAME.length()).trim();
							logger.debug("FILE_CHECK_NUMBER=" + FILE_CHECK_NUMBER);
						} catch (Exception ee) {
						}
						
						String doccode = "";
						String revno = "";
						
						// name �뙆�씪誘명꽣�뿉�뒗 file�쓽 �씠由꾩씠 �뱾�뼱�엳�떎.
						// 洹� �씠由꾩쓣 二쇰㈃ �떎�젣 媛�(�뾽濡쒕뱶 "�븷"file)�쓣 媛��졇�삩�떎.
						String originFile =multipart.getBaseFilename(name);
						logger.debug("Origin File = " + originFile);
						
						// 留뚯빟 �뾽濡쒕뱶 �뤃�뜑�뿉 �삊媛숈� �뙆�씪�씠 �엳�쑝硫�.. �쁽�옱 �삱由щ뒗 �뙆�씪�씠由꾩쓣 諛붽씔�떎.(以묐났�쉶�뵾�젙梨�)
						// 洹몃옒�꽌 �떆�뒪�뀥�뿉 �엳�뒗 �씠由꾩쓣 �븣�젮以��떎.
						String systemFile = multipart.getFileSystemName(name);
						logger.debug("System File=" + systemFile);
						
						// �쟾�넚�맂 �뙆�씪�쓽 ���엯-MIME���엯 (湲곌퀎�뼱, �씠誘몄�, HTML, txt, ...)
						String fileType = multipart.getContentType(name);
						logger.debug("File Type=" + fileType);
						
						// 臾몄옄�뿴 "�뙆�씪�씠由�"�씠 name�뿉 �뱾�뼱�삩 �긽�깭
						// 臾몄옄�뿴 �뙆�씪�씠由꾩쓣 �넻�빐 �떎�젣 �뙆�씪 媛앹껜瑜� 媛��졇�삩�떎.
						if(multipart.getFile(name) != null) {
							File file = multipart.getFile(name);
							logger.debug("Temp File Name=" + file.getName());

							String realFileName = "";
							File renameFile = new File(realFolder + "/" + originFile);
							file.renameTo(renameFile); 
							
							//�뙆�씪
							if (file != null) {
								realFileName = renameFile.getAbsoluteFile().toString();
								logger.debug("�겕湲�: " + file.length() + "bytes");
								logger.debug("file.getAbsoluteFile()=" + file.getAbsoluteFile().toString() );
								logger.debug("renameFile.getAbsoluteFile()=" + renameFile.getAbsoluteFile().toString() );
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
										 	+ "&revno=0";
								doccode = String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES));
								revno	= "0";
								
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("member_key", HashObject.YES)) + "|";
								
								logger.debug("NORMAL_DOC_PARAM = " + NORMAL_DOC_PARAM);
							} else if (MY_JOB_TYPE_INT == 222) {	//媛쒖젙
								sub_sql.append(String.valueOf(hashObject.get("docname"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_name
						 		.append(String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_code 
							 	.append(String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//Doc_code_revision_no
							 	.append(String.valueOf(hashObject.get("doc_gubun"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_gubun1
							 	.append(originFile + "|");
								
								upParam = "?doccode=" + String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) 
										 	+ "&revno="  + String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES));

								doccode = String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES));
								revno	= String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES));
								logger.debug("媛쒖젙�뙆�씪硫뷀꽣=" + upParam );
								
								// 媛쒖젙愿��젴 �씪諛� 蹂��닔�뱾..
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("total_page"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("keep_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("gwanribon_yn"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("DocGubunReg", HashObject.YES)) + "|";
								NORMAL_DOC_PARAM += String.valueOf(hashObject.get("external_doc_source", HashObject.YES)) + "|";
								
								// 媛쒖젙愿��젴 KEY 蹂��닔�뱾.. 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("regist_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("document_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("file_view_name"+FILE_CHECK_NUMBER, HashObject.YES)) + "|"; 
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("pre_revision_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								MODIFY_DOC_PARAM += String.valueOf(hashObject.get("member_key"+FILE_CHECK_NUMBER, HashObject.YES)) + "|";
								logger.debug("MODIFY_DOC_PARAM=" + MODIFY_DOC_PARAM);
							} else if (MY_JOB_TYPE_INT == 229) {	//DB�궡�슜留� �닔�젙
								// �쐞�뿉�꽌 泥섎━�뻽�떎.	
							} else if (MY_JOB_TYPE_INT == 228) {	//�뙆�씪留� �닔�젙 
							} else if (MY_JOB_TYPE_INT == 333) {	//臾몄꽌�룓湲�
							} else {
								sub_sql.append(String.valueOf(hashObject.get("docname"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_name
						 		.append(String.valueOf(hashObject.get("doccode"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_code 
							 	.append(String.valueOf(hashObject.get("rev_no"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//Doc_code_revision_no
							 	.append(String.valueOf(hashObject.get("doc_gubun"+FILE_CHECK_NUMBER, HashObject.YES)) + "|")	//doc_gubun1
							 	.append(originFile + "|");
								
								logger.debug(sub_sql.toString());
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

							/* �뙆�씪�쓣 泥섎━�븯�뒗 寃쎌슦�뿉留� �씠 猷⑦떞�쓣 泥섎━�븳�떎 */
							if (MY_JOB_TYPE_INT==111 || MY_JOB_TYPE_INT==222) {
								String member_key = String.valueOf(hashObject.get("member_key", HashObject.YES));

								String makeDir = "";
								String doc_savepath = realFolder + "/" + member_key;
								makeDir = doc_savepath + "/" + doccode + "/" + originFile + "/" + revno;
								
								File SERVER_path 	= new File(doc_savepath + "/");
								File doccodeffile 	= new File(doc_savepath + "/" + doccode);
								File fileNamefile 	= new File(doc_savepath + "/" + doccode + "/" + originFile);
								File revnofile 		= new File(doc_savepath + "/" + doccode + "/" + originFile + "/" + revno);
								
								if(!SERVER_path.exists()) {
									SERVER_path.mkdir();
								}
								if(!doccodeffile.exists()) {
									doccodeffile.mkdir();
								}
								if(!fileNamefile.exists()) {
									fileNamefile.mkdir();
								}
								if(!revnofile.exists()) {
									revnofile.mkdir();
								}
								
								File crenameFile = new File(makeDir + "/" + originFile);
								
								if(crenameFile.exists()) {
									logger.debug("Error, Destination File Already Exists");
								} else {
									boolean rnrtn = renameFile.renameTo(crenameFile);

									logger.debug("-------------renameFile rnrtn =" +rnrtn);
									logger.debug("-------------renameFile = " +rnrtn + "==" + renameFile.toString() );
									logger.debug("-------------crenameFile = " +rnrtn + "==" + crenameFile.toString() );
								}
								
								if (crenameFile != null) {
							        resp.setContentType("text/html; charset=utf-8");
							        
									if (crenameFile.length() > 0) {
										//DB�뿉 �뙆�씪�젙蹂� Insert/Update/Delete�븳�떎.
								        dbServletLink.connectURL(pid);	//�삱�씪�삩 PID

								        realFileName = saveFolder + "/" + member_key + "/" + 
								        			   doccode + "/" + originFile + "/" + 
								        			   revno + "/" + originFile;
								        sub_sql.append(realFileName + "|");
								        dbServletLink.queryProcess(sql.toString() + sub_sql.toString() + NORMAL_DOC_PARAM + MODIFY_DOC_PARAM, false);
								        
										// �꽦怨듯뻽�떎怨� �몴�떆�븳�떎.
								    	// text/html; charset=utf-8�쓣 ��泥�
								        String rtnStn = "OK-" + systemFile + "\r\n";
								        
										resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
										// �꽦怨듯뻽�쑝硫�... �뙆�씪�쓣 吏��슫�떎.
										renameFile.delete();
										logger.debug(renameFile.getAbsolutePath()+" DELETED");
									} else {
								        String rtnStn = "ERROR-" + systemFile + "<br>\r\n";
								        resp.getWriter().println(URLEncoder.encode(rtnStn, "UTF-8"));
								        
								        // DB Insert �떎�뙣 �떆 �뿬湲곗꽌 crefileName�쓣 吏��썙以섏빞 �븷 �벏
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
		// �떎�슫濡쒕뱶 
		///////////////////////////////////////////////////////////////////////////////
		else {
			logger.debug("Download Process...");
			// �뙆�씪�쓣 �떎�슫濡쒕뱶 �븷 �븣 �뙆�씪�쓽 �젣紐⑹씠 �씤肄붾뵫�뿉 �뵲�씪 �젣紐⑹씠 源⑥쭏 �닔 �엳�떎. �뵲�씪�꽌 �젣紐� �씤肄붾뵫�씠 �븘�슂�븯�떎.
			// �쑀�삎�쓣 �뙆�븙�빐�빞 �븳�떎.
			// FileInputStream: byte stream- �뿬�윭 �쑀�삎�쓽 byte �떒�쐞 �씪湲� �쟾�넚
			// FileReader: char Stream 臾몄옄 理쒖쟻�솕

			// �떎�슫濡쒕뱶�븷 �뙆�씪�쓣 JSP�뿉�꽌 諛쏆븘�삩�떎.
			// �삁) <a href="http://localhost:8080/FileServer/hcp_EdmsServerServlet?fileName=<%=fileName1%>"><%=originalName1%></a>
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
			logger.debug(down_parm);
	    	// �꽌釉붾┸�뿉 �뿰寃고븳�떎.
			//臾몄꽌 議고쉶 濡쒓렇瑜� �궓源��떎
	        DBServletLink dbServletLink = new DBServletLink();
	        dbServletLink.connectURL("M000S100000E301");	//�삱�씪�삩 PID
	        dbServletLink.queryProcess(down_parm, false);

	        
	        if (dbServletLink.ERROR_CODE >= 0) {
				reTurnCount = "OK|DB_DELETE";
	        } else {
				reTurnCount = "ERROR|DB_DELETE";
	        }
	        
			logger.debug("fileName=" + down_parm);

			
			URL connectUrl = new URL(edmsServerDownloadUrl+"?fileName="+fileName + "&doccode=" + document_no + "&revno="+ regist_no_rev);

			// �뿬湲�(�쎒�꽌踰�)�뿉�뒗 �떎�슫濡쒕뱶�븷 �뙆�씪�씠 �뾾�떎. �뵲�씪�꽌 �뙆�씪�꽌踰꾩뿉 �슂泥��빐�빞�븳�떎.
			HttpURLConnection conn = (HttpURLConnection)connectUrl.openConnection();
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");

			// �씠�꽆�� �떎�슫濡쒕뱶 �뙆�씪�쓽 �씠由꾩쓣 �썝�븯�뒗 ��濡� 諛쏆븘�궡湲� �쐞�빐�꽌 �븘 �닔�쟻�쑝濡� �븘�슂�븳 �꽆�씠�떎. 
			resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
	   
			//JSP�샇異� 諛�  �뙆�씪�꽌踰꾩��쓽 異쒕젰�뒪�듃由�
//			DataOutputStream dos = new DataOutputStream(conn.getOutputStream());
//			// �씠�꽆�� 洹몃깷 �븳踰� �궇由щ뒗 嫄곗엫
//			dos.writeBytes(fileName);
//			dos.flush();
			
			// �뙆�씪�꽌踰꾩��쓽 �엯�젰�뒪�듃由�
			DataInputStream dis = new DataInputStream(conn.getInputStream());
		    
			// 釉뚮씪�슦���뿉 �벐湲� �뒪�듃由�
			ServletOutputStream out2Browser = resp.getOutputStream();
					
			int numRead = 0;
			byte[] buf = new byte[50*1024*1024];
					
			// 諛붿씠�듃 諛곗뿴 buf�쓽 0踰덈��꽣 numRead踰덇퉴吏� 釉뚮씪�슦��濡� 異쒕젰
			while((numRead=dis.read(buf, 0, buf.length)) != -1) {
				out2Browser.write(buf, 0, numRead);
			}
			out2Browser.flush();
			out2Browser.close();
			
			//dos.close();
			dis.close();
		}
	}
}
