package mes.subserver;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import hardware.utils.Checksum;
import mes.client.guiComponents.DoyosaeTableModel;
import net.wimpi.modbus.util.ModbusUtil;

public class MetalDetector extends Thread {
	
	static final Logger logger = Logger.getLogger(MetalDetector.class.getName());
	
	private String ip = InterfaceConstants.METAL_DETECTOR_IP;
	private int port = InterfaceConstants.METAL_DETECTOR_PORT;
	
	private String metalDetectorId = InterfaceConstants.METAL_DETECTOR;
	private String dataType = "METAL";
	
	private Socket sock = null;
	private DataInputStream in = null;
	private DataOutputStream out = null;

	private int orgCntTest = 0;
	private int orgCntOperation = 0;
	private String pid = "M808S010200E111";

	private boolean machineOn = false;
	private static String mode = "operation";

	public MetalDetector() {
	}

	// set command to plc (cNet)
	public byte[] commandForTestData() {
       
		byte[] hexBuffer = new byte[19];
		
		hexBuffer[0] =  (byte)0x05;
		hexBuffer[1] =  (byte)'0';
		hexBuffer[2] =  (byte)'0';
		hexBuffer[3] =  (byte)'R';
		hexBuffer[4] =  (byte)'S';
		hexBuffer[5] =  (byte)'S';
		hexBuffer[6] =  (byte)'0';
		hexBuffer[7] =  (byte)'1';
		hexBuffer[8] = 	(byte)'0';
		hexBuffer[9] = 	(byte)'7';
		hexBuffer[10] = (byte)'%';
		hexBuffer[11] = (byte)'M';
		hexBuffer[12] = (byte)'W';
		hexBuffer[13] = (byte)'1';
		hexBuffer[14] = (byte)'1';
		hexBuffer[15] = (byte)'0';
		hexBuffer[16] = (byte)'0';
		hexBuffer[17] = (byte)0x04;
		hexBuffer[18] = Checksum.getChecksum(hexBuffer);

		return hexBuffer;
	}
	
	public byte[] commandForOperationData() {
	       
		byte[] hexBuffer = new byte[19];
		
		hexBuffer[0] =  (byte)0x05;
		hexBuffer[1] =  (byte)'0';
		hexBuffer[2] =  (byte)'0';
		hexBuffer[3] =  (byte)'R';
		hexBuffer[4] =  (byte)'S';
		hexBuffer[5] =  (byte)'S';
		hexBuffer[6] =  (byte)'0';
		hexBuffer[7] =  (byte)'1';
		hexBuffer[8] = 	(byte)'0';
		hexBuffer[9] = 	(byte)'7';
		hexBuffer[10] = (byte)'%';
		hexBuffer[11] = (byte)'M';
		hexBuffer[12] = (byte)'W';
		hexBuffer[13] = (byte)'1';
		hexBuffer[14] = (byte)'0';
		hexBuffer[15] = (byte)'0';
		hexBuffer[16] = (byte)'0';
		hexBuffer[17] = (byte)0x04;
		hexBuffer[18] = Checksum.getChecksum(hexBuffer);

		return hexBuffer;
	}
	
	public byte[] commandToChangeMode(String mode) {
		byte[] hexBuffer = new byte[23];
		
		hexBuffer[0] =  (byte)0x05;
		hexBuffer[1] =  (byte)'0';
		hexBuffer[2] =  (byte)'0';
		hexBuffer[3] =  (byte)'W';
		hexBuffer[4] =  (byte)'S';
		hexBuffer[5] =  (byte)'S';
		hexBuffer[6] =  (byte)'0';	// 블록수 (01)
		hexBuffer[7] =  (byte)'1';	
		hexBuffer[8] = 	(byte)'0';	// 변수 길이 (07)
		hexBuffer[9] = 	(byte)'7';	
		hexBuffer[10] = (byte)'%';	// 변수 이름 시작
		hexBuffer[11] = (byte)'M';
		hexBuffer[12] = (byte)'W';
		hexBuffer[13] = (byte)'1';
		hexBuffer[14] = (byte)'0';
		hexBuffer[15] = (byte)'1';
		hexBuffer[16] = (byte)'0';	// 변수 이름 끝
		hexBuffer[17] = (byte)'0';
		hexBuffer[18] = (byte)'0';
		hexBuffer[19] = (byte)'0';
		hexBuffer[20] = (byte)'0';
		hexBuffer[21] = (byte)0x04;
		hexBuffer[22] = Checksum.getChecksum(hexBuffer);
		
		if(mode.equals("test")) {
			hexBuffer[20] = (byte)'1';
		}
		
		return hexBuffer;
	}
	
	public byte[] commandToGetMode() {
		byte[] hexBuffer = new byte[23];
		
		hexBuffer[0] =  (byte)0x05;
		hexBuffer[1] =  (byte)'0';
		hexBuffer[2] =  (byte)'0';
		hexBuffer[3] =  (byte)'R';
		hexBuffer[4] =  (byte)'S';
		hexBuffer[5] =  (byte)'S';
		hexBuffer[6] =  (byte)'0';
		hexBuffer[7] =  (byte)'1';
		hexBuffer[8] = 	(byte)'0';
		hexBuffer[9] = 	(byte)'7';
		hexBuffer[10] = (byte)'%';
		hexBuffer[11] = (byte)'M';
		hexBuffer[12] = (byte)'W';
		hexBuffer[13] = (byte)'1';
		hexBuffer[14] = (byte)'0';
		hexBuffer[15] = (byte)'1';
		hexBuffer[16] = (byte)'0';
		hexBuffer[17] = (byte)0x04;
		hexBuffer[18] = Checksum.getChecksum(hexBuffer);

		return hexBuffer;
	}
	
    public int detectMetal(String mode) throws IOException {
    	int newCnt;
    	
    	try {
//    		logger.debug("	[Metal Detector] detecting: " + mode + " mode");

    		byte[] rcvPacket = new byte[128];
    		
    		if(mode.equals("test")) {
    			byte[] sendPacket = commandForTestData();
//    			logger.debug("	[Metal Detector] send msg: " + ModbusUtil.toHex(sendPacket));
    			this.out.write(sendPacket);
    			this.out.flush();
    		}
    		
    		if(mode.equals("operation")) {
    			byte[] sendPacket = commandForOperationData();
//    			logger.debug("	[Metal Detector] send msg: " + ModbusUtil.toHex(sendPacket));
    			this.out.write(sendPacket);
    			this.out.flush();
    		}
			
			int rcvSize = in.read(rcvPacket);
            
			String returnMsg = ModbusUtil.toHex(rcvPacket, 0, rcvSize);
//			logger.debug("	[Metal Detector] received msg: " + returnMsg);
 
			String[] hexArr = ModbusUtil.toHex(rcvPacket).split(" ");
			
			String hex = hexArr[10] + hexArr[11] + hexArr[12] + hexArr[13];
			newCnt = hexToDecimal(hex);
			
			logger.debug("[Metal Detector] detected count:" + newCnt);
			return newCnt;
    	} catch (SocketException e) {
    		logger.error("[Metal Detector] Socket Exception");
    		closeResources();
    		return -999;
    	} catch (Exception e) {
    		logger.error("[Metal Detector] error while detecting");
    		e.printStackTrace();
    		return -999;
    	}
	}
    
    @SuppressWarnings("unchecked")
	public void insertData(String deviceId, String pid) {
        try {
        	LocalDateTime now = LocalDateTime.now();  
            DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy/mm/dd HH:mm:ss");  
            String date = now.format(format);  
            
            logger.debug("[Metal Detector] inserting data:");
            logger.debug("[Metal Detector] date:" + date);
        	
        	JSONObject head = new JSONObject();
        	JSONObject body = new JSONObject();
        	JSONArray row = new JSONArray();
        	
        	String isTest = "R";
        	if(mode.equals("test")) {
        		isTest = "T";
        	}
        	
        	head.put("isTest", isTest);
        	head.put("dateTime", date);
        	head.put("metalDetectorId", deviceId);
        	head.put("prodName", "n/a");
        	head.put("userId", "henesys");
        	
//        	body.put("testmaterial0", "n/a");
        	body.put("type0", "n/a");
        	body.put("position0", "n/a");
        	body.put("result0", "X");
        	
        	row.add(body);
        	
        	head.put("row", row);
        	
        	logger.debug(head);
        	new DoyosaeTableModel(pid, head);
        } catch (Exception e) {
        	logger.error("[Metal Detector] error while inserting data to DB	\n" + e);
        } finally {
        	
        }
    }
    
    public int hexToDecimal(String hex) {
//    	System.out.println("@@@@hex to dec > input: "+hex);
    	StringBuilder output = new StringBuilder();
//    	System.out.println("@@@@hex to dec > length: "+hex.length());
    	
    	if(hex.equals("00000000")) {
    		return 0;
    	}
    	
		for (int i = 0; i < hex.length(); i+=2) {
		    String str = hex.substring(i, i+2);
		    output.append((char)Integer.parseInt(str, 16));
		}
//		System.out.println("@@@@hex to dec > output : "+output);
		try {
			int decimal = Integer.parseInt(output.toString(), 16);
			return decimal;
		} catch (NumberFormatException e) {
			return -998;
		}
    }
    
    public String getMode() {
		return mode;
    }
    
    // 6 : success, 15 : fail
    public String changeMode(String mode) throws IOException {
		Socket sock = new Socket(ip, port);
		sock.setSoTimeout(1000 * 1);
		DataInputStream in = new DataInputStream(sock.getInputStream());
		DataOutputStream out = new DataOutputStream(sock.getOutputStream());
    	
		byte[] sendPacket = new byte[23];
		byte[] rcvPacket = new byte[128];
		
		sendPacket = commandToChangeMode(mode);
//    	logger.debug("	[Metal Detector] sent msg: " + ModbusUtil.toHex(sendPacket));

    	out.write(sendPacket);
		out.flush();
		
		int rcvSize = in.read(rcvPacket);
		String returnMsg = ModbusUtil.toHex(rcvPacket, 0, rcvSize);
		//logger.debug("	[Metal Detector] received msg: " + returnMsg);

		String[] hexArr = ModbusUtil.toHex(rcvPacket).split(" ");
		
		String result;
		if(hexArr[0].equals("06")) {
			result = "성공";
			MetalDetector.mode = mode;
		} else {
			result = "실패";
		}
		logger.debug("[Metal Detector] status change result:" + result);
		
		if(!sock.isClosed()) {
			sock.close();
			in.close();
			out.close();
		}
		
		return hexArr[0];
    }
    
    public boolean connectDevice() throws IOException {
		
    	this.sock = new Socket(this.ip, this.port);
		this.sock.setSoTimeout(1000 * 1);
		this.in = new DataInputStream(sock.getInputStream());
		this.out = new DataOutputStream(sock.getOutputStream());
		
		if(!this.sock.isConnected()) {
		    throw new IOException("장비 연결 실패");
		} else {
			return true;
		}
    }
    
    public void closeResources() {
    	try {
	    	if(this.sock != null) {
					this.sock.close();
	    	}
	    	
	    	if(this.in != null) {
	    		in.close();
	    	}
	    	
	    	if(this.out != null) {
	    		out.close();
	    	}
	    	
	    	logger.info("[Metal Detector] closed socket");
    	} catch (IOException e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	}
    }
    
    public int getOrgCntOperatioin() {
    	return this.orgCntOperation;
    }
    
    public void setOrgCntOperatioin(int cnt) {
    	this.orgCntOperation = cnt;
    }
    
    public boolean setInit() {
    	try {
	    	String changed = changeMode("operation");
	    	if(changed.equals("15")) {
	    		return false;
	    	}
			
			int cnt2 = detectMetal("operation");
        	this.orgCntOperation = cnt2;
        	
        	logger.info("[Metal Detector] reset complete");
        	return true;
    	} catch(Exception e) {
    		logger.error("[Metal Detector] reset failed");
    		e.printStackTrace();
    		return false;
    	}
    }
    
    public void run() {
    	try {
    		while(true) {
    			try {
    				if(machineOn = false) {
    					machineOn = connectDevice();
    				} else {
    					if(mode.equals("test")) {
    						logger.debug("[Metal Detector] ## test mode");
    					}
    					
    					if(mode.equals("operation")) {
    						logger.debug("[Metal Detector] ## operation mode");
    						int newCnt = detectMetal(mode);
        					
        					if(orgCntOperation != newCnt && newCnt != -999) {
        			        	insertData(metalDetectorId, pid);
        			        	orgCntOperation = newCnt;
        			        }
    					}
    				}

    				Thread.sleep(500);
    			} catch (UnknownHostException e) {
 					logger.debug("[Metal Detector] failed to connect (UnknownHostException)");
 					machineOn = false;
 					Thread.sleep(1000 * 2);
 				} catch (IOException e) {
 					logger.debug("[Metal Detector] power off (IOException)");
 					machineOn = false;
 					Thread.sleep(1000 * 2);
 				} catch (Exception e) {
 					logger.debug("[Metal Detector] error (Exception)");
 					machineOn = false;
 					Thread.sleep(1000 * 2);
 				}
    		}
    	} catch(InterruptedException e) {
			logger.debug("[Metal Detector] interrupted");
    	} finally {
    		try {
    			if (!sock.isClosed()) {
    				sock.close();
	    		    in.close();
	    		    out.close();
	    		    logger.debug("[Metal Detector] exiting");
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    }
    
    public static void main(String args[]) {
		try {
			logger.debug("[Metal Detector] start detecting");
	    	MetalDetector mts = new MetalDetector();
	    	mts.getMode();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
}