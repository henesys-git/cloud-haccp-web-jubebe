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
	
    // ��� ����
	private Socket sock = null;
    private BufferedInputStream inputStream = null;
    private BufferedOutputStream outputStream = null;
    
    // ������ ����Ÿ
	private byte[] readData = new byte[256];
	private int readSize = 0;
	
	private String tempIpAddr = InterfaceConstants.TEMPERATURE_IP2;
	private int tempPortNo = InterfaceConstants.TEMPERATURE_PORT2;
		
    public ThermalServer2() {
    	try {
    		System.out.println("[�µ� ����2] " + tempIpAddr);
	    	this.sock = new Socket(tempIpAddr, tempPortNo);
	    	this.sock.setSoTimeout(1000*3);
	    	this.inputStream = new BufferedInputStream(sock.getInputStream());
	    	this.outputStream = new BufferedOutputStream(sock.getOutputStream());
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    // ��� ���� ������ �����.
    private byte[] getHexPacketAutonix(String strData) {
 		//System.out.println(strData);
 		// �޽��� ��Ʈ���� ����
 		int strDataLength = strData.trim().length();
 		// ���۰� �� �׸��� BCC 3����Ʈ
 		byte[] hexBuffer = new byte[strDataLength+3];
 		// ��Ʈ�� �����͸� ����Ʈ��...
 		byte[] strDataBuffer = strData.getBytes();
 		//System.out.println("STR DATA BUFFER = " + strDataBuffer);
 		// ù ����Ʈ�� ���� ����Ʈ���� �����Ѵ�.
 		hexBuffer[0] = 0x02;
 		// ��Ʈ���� ���� ����Ʈ������ �����Ѵ�.
 		for (int i = 0; i < strDataLength; i++) {
 			hexBuffer[i+1] = strDataBuffer[i];
 		}
 		// ���������� �����Ѵ�. 
 		hexBuffer[hexBuffer.length-2] = 0x03;
 		// XORó���Ѵ�. --�������Ʈ �ʱ�ȭ
 		byte resultByte = hexBuffer[0];
 		for (int i = 0; i < hexBuffer.length-2; i++) {
 			resultByte ^= hexBuffer[i+1];
 		}
 		// HEX��ȯ ��Ʈ��
 		String hexString = Integer.toHexString(resultByte);
 		//System.out.println("BCC = " + hexString);
 		// BCC���� �����Ѵ�.
 		hexBuffer[hexBuffer.length-1] = Byte.parseByte(hexString, 16);
 		
 		return hexBuffer;
    }
    
    private char[] hexToAscii(String[] hexStr) {
 	   char asciiStr[] = new char[hexStr.length];
 	   
 	   for(int i = 0; i < hexStr.length; i++) {
 		   asciiStr[i] = (char) Integer.parseInt(hexStr[i], 16);
 		   //System.out.println("HEX���� ASCII��ȯ = "+asciiStr[i]);
 	   }
 	   
 	   return asciiStr;
    }
    
    private String makeTemp(char[] asciiStr) {
 		StringBuilder sb = new StringBuilder("");
 		sb.append(asciiStr[8]) 	// ��ȣ (�÷��� Ȥ�� ���̳ʽ�)
 	      .append(asciiStr[11])
 	      .append(asciiStr[12])
 	      .append(".")
 	      .append(asciiStr[13]);
 	   
 	    //System.out.println("�µ� ��ȯ ��� = " + sb.toString());
 	    return sb.toString();
    }
    
    // ������ ��� ������.
    private void sendCommand2TempDev(int tempCodeInt, String commandGubun) {
		try {
			// ������ �����.
			String strToHf2211 = "0" + tempCodeInt + "RX" + commandGubun;
			sendPacket = getHexPacketAutonix(strToHf2211);
			
			// ������ ������.
			outputStream.write(sendPacket);
			outputStream.flush();
			
	    	readSize = inputStream.read(readData);
	    	String returnMsg = ModbusUtil.toHex(readData, 0, readSize); //16���� ��ȯ
	    	
	    	String[] resultHex = returnMsg.split(" ");
	    	
	    	String finalTemp = "";
			if(resultHex[0].equals("06")) { // if 06, received successfully
				char[] resultAscii = this.hexToAscii(resultHex);
				finalTemp = this.makeTemp(resultAscii);
				finalTemp = finalTemp.trim();
			}
			
			tempCodeInt += 5;	// �µ����� 6~9��
			
			System.out.println("[�µ� ����2] "+ tempCodeInt + "�� �µ��� �µ� = " + finalTemp);
			
			URL url = new URL(serverAddr+"/ThermalServlet?censor_no=autonix_temp0"+tempCodeInt
							  + "&censor_data_type=TEMPERATURE&censor_value="+finalTemp);
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			System.out.println("[�µ� ����2] �����ڵ� : " + conn.getResponseCode());
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
        		
    			System.out.println("[�µ� ����2] ��ȸ �Ϸ�");
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
