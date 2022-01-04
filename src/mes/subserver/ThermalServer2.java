package mes.subserver;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;

import net.wimpi.modbus.util.ModbusUtil;

public class ThermalServer2 extends Thread {
	private String serverAddr = InterfaceConstants.SERVER_IP;
	private byte[] sendPacket = new byte[48];
	private final int deviceCount = 4;
	
    // 통신 관련
	private Socket sock = null;
    private BufferedInputStream inputStream = null;
    private BufferedOutputStream outputStream = null;
    
    // 씨리알 데이타
	private byte[] readData = new byte[256];
	private int readSize = 0;
	
	private String tempIpAddr = InterfaceConstants.TEMPERATURE_IP2;
	private int tempPortNo = InterfaceConstants.TEMPERATURE_PORT2;
		
    public ThermalServer2() {
    	try {
    		System.out.println("[온도 센서2] " + tempIpAddr);
	    	this.sock = new Socket(tempIpAddr, tempPortNo);
	    	this.sock.setSoTimeout(1000*3);
	    	this.inputStream = new BufferedInputStream(sock.getInputStream());
	    	this.outputStream = new BufferedOutputStream(sock.getOutputStream());
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    // 장비에 보낼 전문을 만든다.
    private byte[] getHexPacketAutonix(String strData) {
 		//System.out.println(strData);
 		// 메시지 스트링의 길이
 		int strDataLength = strData.trim().length();
 		// 시작과 끝 그리고 BCC 3바이트
 		byte[] hexBuffer = new byte[strDataLength+3];
 		// 스트링 데이터를 바이트로...
 		byte[] strDataBuffer = strData.getBytes();
 		//System.out.println("STR DATA BUFFER = " + strDataBuffer);
 		// 첫 바이트로 시작 바이트값을 저장한다.
 		hexBuffer[0] = 0x02;
 		// 스트링의 값을 바이트값으로 저장한다.
 		for (int i = 0; i < strDataLength; i++) {
 			hexBuffer[i+1] = strDataBuffer[i];
 		}
 		// 마지막값을 저장한다. 
 		hexBuffer[hexBuffer.length-2] = 0x03;
 		// XOR처리한다. --결과바이트 초기화
 		byte resultByte = hexBuffer[0];
 		for (int i = 0; i < hexBuffer.length-2; i++) {
 			resultByte ^= hexBuffer[i+1];
 		}
 		// HEX변환 스트링
 		String hexString = Integer.toHexString(resultByte);
 		//System.out.println("BCC = " + hexString);
 		// BCC값을 저장한다.
 		hexBuffer[hexBuffer.length-1] = Byte.parseByte(hexString, 16);
 		
 		return hexBuffer;
    }
    
    private char[] hexToAscii(String[] hexStr) {
 	   char asciiStr[] = new char[hexStr.length];
 	   
 	   for(int i = 0; i < hexStr.length; i++) {
 		   asciiStr[i] = (char) Integer.parseInt(hexStr[i], 16);
 		   //System.out.println("HEX에서 ASCII변환 = "+asciiStr[i]);
 	   }
 	   
 	   return asciiStr;
    }
    
    private String makeTemp(char[] asciiStr) {
 		StringBuilder sb = new StringBuilder("");
 		sb.append(asciiStr[8]) 	// 부호 (플러스 혹은 마이너스)
 	      .append(asciiStr[11])
 	      .append(asciiStr[12])
 	      .append(".")
 	      .append(asciiStr[13]);
 	   
 	    //System.out.println("온도 변환 결과 = " + sb.toString());
 	    return sb.toString();
    }
    
    // 전문을 장비에 보낸다.
    private void sendCommand2TempDev(int tempCodeInt, String commandGubun) {
		try {
			// 전문을 만든다.
			String strToHf2211 = "0" + tempCodeInt + "RX" + commandGubun;
			sendPacket = getHexPacketAutonix(strToHf2211);
			
			// 전문을 보낸다.
			outputStream.write(sendPacket);
			outputStream.flush();
			
	    	readSize = inputStream.read(readData);
	    	String returnMsg = ModbusUtil.toHex(readData, 0, readSize); //16진수 변환
	    	
	    	String[] resultHex = returnMsg.split(" ");
	    	
	    	String finalTemp = "";
			if(resultHex[0].equals("06")) { // if 06, received successfully
				char[] resultAscii = this.hexToAscii(resultHex);
				finalTemp = this.makeTemp(resultAscii);
				finalTemp = finalTemp.trim();
			}
			
			tempCodeInt += 5;	// 온도센서 6~9번
			
			System.out.println("[온도 센서2] "+ tempCodeInt + "번 온도계 온도 = " + finalTemp);
			
			URL url = new URL(serverAddr+"/ThermalServlet?censor_no=autonix_temp0"+tempCodeInt
							  + "&censor_data_type=TEMPERATURE&censor_value="+finalTemp);
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			System.out.println("[온도 센서2] 응답코드 : " + conn.getResponseCode());
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public void run() {
    	try {
    		while(true) {
    			for (int i = 1; i <= deviceCount; i++) {
        			sendCommand2TempDev(i,"P0");
            		Thread.sleep(1000*3);
        		}
        		
    			System.out.println("[온도 센서2] 조회 완료");
        		Thread.sleep(1000*60*1);	// sleep for 10 minutes
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		try {
    			if (!sock.isClosed()) {
    				sock.close();
	    		    inputStream.close();
	    		    outputStream.close();
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    }
    
    public static void main(String args[]) {
		try {
	    	ThermalServer2 th = new ThermalServer2();
	    	th.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
}
