package mes.subserver;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import mes.client.guiComponents.DoyosaeTableModel;
import net.wimpi.modbus.util.ModbusUtil;

public class SourceMaker extends Thread {
	
	static final Logger logger = Logger.getLogger(SourceMaker.class.getName());
	
	private String socketIp = InterfaceConstants.SOURCE_MAKER_IP;
	private int socketPort = InterfaceConstants.SOURCE_MAKER_PORT;
	
	private String pid = "M707S010800E001";
	
	private String sourceMakerId = InterfaceConstants.SOURCE_MAKER;
	private String dataType = "SOURCE";
	
	private Socket sock = null;
	private DataInputStream in = null;
	private DataOutputStream out = null;   

	private byte[] sendPacket = new byte[37];

	private int rcvSize = 0;
	private String returnMsg = "";
	private String[] result;

	public SourceMaker() {
		setDefaultSendPacket();
	}

	public byte getCheckSumValue() {
		int chkSum = 0;
	
		for (int i = 0; i < 19; i++) {
			chkSum += Integer.parseInt(ModbusUtil.toHex(sendPacket, i, i+1).replace(" ", ""), 16);
	
			if (chkSum > 255) {
				chkSum = chkSum - 256;
			}
		}
	
		return (byte)(chkSum);
	}
	
	private byte[] getDefaultSendPacket() {
		return sendPacket;
	}
   
	private void setDefaultSendPacket() {
      
		this.sendPacket[0] = (byte)0x4C;
		this.sendPacket[1] = (byte)0x53;
		this.sendPacket[2] = (byte)0x49;
		this.sendPacket[3] = (byte)0x53;
		this.sendPacket[4] = (byte)0x2D;
		this.sendPacket[5] = (byte)0x58;
		this.sendPacket[6] = (byte)0x47;
		this.sendPacket[7] = (byte)0x54;
		this.sendPacket[8] = (byte)0x00;
		this.sendPacket[9] = (byte)0x00;
		this.sendPacket[10] = 0x02;
		this.sendPacket[11] = 0x08;
		this.sendPacket[12] = (byte)0xB0;
		this.sendPacket[13] = 0x33;
		this.sendPacket[14] = 0x00;
		this.sendPacket[15] = 0x00;
		this.sendPacket[16] = 0x11;
		this.sendPacket[17] = 0x00;
		this.sendPacket[18] = 0x00;
		this.sendPacket[19] = getCheckSumValue();

		this.sendPacket[20] = 0x54;
		this.sendPacket[21] = 0x00;         
		this.sendPacket[22] = 0x02;   
		this.sendPacket[23] = 0x00;
		this.sendPacket[24] = 0x00;
		this.sendPacket[25] = 0x00;
		this.sendPacket[26] = 0x01;
		this.sendPacket[27] = 0x00;
		this.sendPacket[28] = 0x07;
		this.sendPacket[29] = 0x00;
		this.sendPacket[30] = (byte)'%';
		this.sendPacket[31] = (byte)'D';
		this.sendPacket[32] = (byte)'W';
		this.sendPacket[33] = (byte)'1';
		this.sendPacket[34] = (byte)'0';
		this.sendPacket[35] = (byte)'0';
		this.sendPacket[36] = (byte)'0';
	}
	
	private byte[] getSendPacketForTemperature() {
		byte[] packet = getDefaultSendPacket();
		packet[34] = (byte)'0';
		return packet;
	}
	
	private byte[] getSendPacketForCoolingTime() {
		byte[] packet = getDefaultSendPacket();
		packet[34] = (byte)'1';
		return packet;
	}
	
	private byte[] getSendPacketForHeatingTime() {
		byte[] packet = getDefaultSendPacket();
		packet[34] = (byte)'2';
		return packet;
	}
	
	private int detectHeatingTime() {
		try {
			int heatingTime = 0;
			byte[] sendPacket = getSendPacketForHeatingTime();
        	byte[] rcvPacket = new byte[128];
        	
			out.write(sendPacket);
			out.flush();
			
			rcvSize = in.read(rcvPacket);
			
			returnMsg = ModbusUtil.toHex(rcvPacket, 0, rcvSize);

			result = ModbusUtil.toHex(rcvPacket).split(" ");
            
            heatingTime = Integer.parseInt(result[33]+result[32], 16);
			logger.debug("[Source Maker] heating time :" + heatingTime);

			return heatingTime;
		} catch (IOException e) {
			logger.error("[Source Maker] IO Exception");
			e.printStackTrace();
			return 0;
		}
	}
	
    private double detectTemperature() throws IOException {
    	try {
        	byte[] sendPacket = getSendPacketForTemperature();
        	byte[] rcvPacket = new byte[128];
        	
            logger.debug("[Source Maker] hex packet to send :\n" + ModbusUtil.toHex(sendPacket));
            out.write(sendPacket);
            out.flush();
            
            rcvSize = in.read(rcvPacket);
            
            returnMsg = ModbusUtil.toHex(rcvPacket, 0, rcvSize);
            logger.debug("[Source Maker] return msg in hex : \n" + returnMsg);
              
            result = ModbusUtil.toHex(rcvPacket).split(" ");
            
            double sourceMakerTemp = Long.parseLong(result[33]+result[32], 16);
            
            sourceMakerTemp = sourceMakerTemp / 10;
            
            logger.debug("[Source Maker] temperature: " + sourceMakerTemp);
            
            return sourceMakerTemp;
    	} catch (Exception e) {
    		logger.error("[Source Maker] detecting temperature error");
    		e.printStackTrace();
    		return -999;
    	}
	}
    
    private boolean insertData(String deviceId, double value, String pid) {
        try {
        	logger.debug("[Source Maker] inserting data");
        	logger.debug("[Source Maker] dev no. : " + deviceId);
        	logger.debug("[Source Maker] temp : " + value);
        	logger.debug("[Source Maker] pid : " + pid);
        	
        	if(value == -999) {        		
        		logger.debug("[Source Maker] failed to insert date as wrong value(-999)");
        		return false;
        	}
        	
        	JSONObject jo = new JSONObject();
        	
        	jo.put("censor_no", deviceId);
        	jo.put("censor_data_type", dataType);
        	jo.put("censor_value", value);

        	new DoyosaeTableModel(pid, jo);
        	
        	return true;
        } catch (Exception e) {
        	logger.error("[Source Maker] error while inserting data to DB\n" + e);
        	return false;
        }
    }
    
    public void run() {
    	try {
    		while(true) {
    			try {
    				sock = new Socket(socketIp, socketPort);
    				sock.setSoTimeout(1000 * 3);
    				
    				in = new DataInputStream(sock.getInputStream());
    				out = new DataOutputStream(sock.getOutputStream());
    				
					int heatingTime = detectHeatingTime();
					
					double temperature = detectTemperature();
					logger.debug(temperature);
					//insertData(sourceMakerId, temperature, pid);
					
					Thread.sleep(1000 * 60 * 10);
    			} catch (UnknownHostException e) {
 					logger.debug("[Source Maker] UnknownHostException");
 					Thread.sleep(1000 * 3);
 				} catch (IOException e) {
 					logger.debug("[Source Maker] Power Off");
 					Thread.sleep(1000 * 3);
 				} catch (Exception e) {
 					logger.debug("[Source Maker] Error");
 					Thread.sleep(1000 * 3);
 				}
    		}
    	} catch(InterruptedException e) {
			logger.error("[Source Maker] interrupted");
    	} finally {
    		try {
    			if (!sock.isClosed()) {
    				sock.close();
	    		    in.close();
	    		    out.close();
	    		    logger.error("[Source Maker] socket closed");
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    }
    
    public static void main(String args[]) {
		try {
			logger.debug("[Source Maker] started!!");
	    	SourceMaker sm = new SourceMaker();
	    	sm.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
}