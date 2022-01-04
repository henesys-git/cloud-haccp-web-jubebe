package mes.edms.server;

import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpFileUploader {
	String CRLF = "\r\n";
	String twoHyphens = "--";
	String boundary = "----"; 
	
	FileInputStream fileInputStream = null;
	URL connectUrl = null;

	public int httpFileUpload(String urlString, String params, String fileName) {
		int resultSizeInt = 0; 
		try {
			fileInputStream = new FileInputStream(fileName);   
			connectUrl = new URL(urlString+params);
			System.out.println("fileInputStream  is " + fileName);
	   
			// open connection 
			HttpURLConnection conn = (HttpURLConnection)connectUrl.openConnection();   
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("accept-charset", "UTF-8");
			conn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
	   
			// write data accept-charset: "UTF-8"
			DataOutputStream dos = new DataOutputStream(conn.getOutputStream());
			dos.writeBytes(twoHyphens + boundary + CRLF);
			dos.writeBytes("Content-Disposition: form-data; name=\"uploadedfile\";filename=\"" + fileName+"\"" + CRLF);
			dos.writeBytes(CRLF);
	   
			int bytesAvailable = fileInputStream.available();
			System.out.println("bytesAvailable = " + bytesAvailable);
			
			int maxBufferSize = 1024;
			int bufferSize = Math.min(bytesAvailable, maxBufferSize);
	   
			byte[] buffer = new byte[bufferSize];
			int bytesRead = fileInputStream.read(buffer, 0, bufferSize);
	   
			System.out.println("bytesRead = " + bytesRead);
	   
			// ������ �д´�.
			while (bytesRead > 0) {
				dos.write(buffer, 0, bufferSize);
				bytesAvailable = fileInputStream.available();
				bufferSize = Math.min(bytesAvailable, maxBufferSize);
				bytesRead = fileInputStream.read(buffer, 0, bufferSize);
			} 
	   
			dos.writeBytes(CRLF);
			dos.writeBytes(twoHyphens + boundary + twoHyphens + CRLF);
	   
			// ��Ʈ���� �ݰ�...
			System.out.println("File is written");
			// �� �о������. finish upload...
			dos.flush();
			fileInputStream.close();
	   
			// �׸��� ó�� ����� ��ٷ� �о� �´�.
			int readCount;
			InputStream inputStream = conn.getInputStream();
			StringBuffer sBuff =new StringBuffer();
			while( ( readCount = inputStream.read() ) != -1 ){
				sBuff.append( (char)readCount );
			}
			dos.close();   
			
			// ó�� ����� ���ε� �� ������ ũ��� �����Ѵ�.
			String resultSizeValue = sBuff.toString(); 
			System.out.println("result = " + resultSizeValue.trim());
			try {
				resultSizeInt = Integer.parseInt(resultSizeValue.trim());
			} catch (Exception ee) {
				resultSizeInt = 0;
			}
			
			inputStream.close();
		} catch (Exception e) {
			System.out.println("exception " + e.getMessage());
		}  
		return resultSizeInt;
	}
}
