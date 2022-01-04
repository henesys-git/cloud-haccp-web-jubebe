package mes.subserver;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import jssc.SerialPort;
import jssc.SerialPortException;

import mes.client.guiComponents.DoyosaeTableModel;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

public class ThermalServerSerial implements Runnable {

	static final Logger logger = Logger.getLogger(ThermalServerSerial.class.getName());
	
    // About serial communication
    static InputStream inputStream;
    static OutputStream outputStream;
    private SerialPort serialPort;
    
    private String pid = "M707S010800E001";
    private String[] deviceList = {"02", "03", "04", "05", "06", "10", "20"};
    
    private boolean opened;
    private boolean paramSetted;
    
    // serial data
    String serialData = "";
    String serialSpareData = "";
    String generalInterfaceSerialData = "";
    StringBuffer readStringBuffer = new StringBuffer();
    
    byte[] readBuffer = new byte[128];
    byte[] completedReadBuffer = new byte[128];
    byte[] tmpReadBuffer = null;
    byte[] BCC = new byte[1];
    
    public ThermalServerSerial() {
    }
    
    public ThermalServerSerial(String PORT) throws Exception {
    	this.serialPort = new SerialPort(PORT);
    	
    	try {
    		this.opened = serialPort.openPort();
    		this.paramSetted = serialPort.setParams(19200, 8, 1, 0);
    		logger.info("[TEMPERATURE] Port opened: " + this.opened);
    		logger.info("[TEMPERATURE] params setted: " + this.paramSetted);
    	} catch (SerialPortException ex) {
    		logger.error(ex);
    	}

    	String deviceListStr = String.join(",", this.deviceList);
    	logger.debug("[TEMPERATURE] slave id list:" + deviceListStr);
    }
    
    public static byte[] getHexPacket(String strData) {
    	int strDataLength = strData.trim().length();
		byte[] hexBuffer = new byte[strDataLength+3];
		byte[] strDataBuffer = strData.getBytes();

		hexBuffer[0] = 0x02;
		for (int i=0; i<strDataLength; i++) {
			hexBuffer[i+1] = strDataBuffer[i];
		}
		hexBuffer[hexBuffer.length-2] = 0x03;
		byte resultByte = hexBuffer[0];
		for (int i=0; i<hexBuffer.length-2; i++) {
			resultByte ^= hexBuffer[i+1];
		}
		String hexString = Integer.toHexString(resultByte);
		hexBuffer[hexBuffer.length-1] = Byte.parseByte(hexString, 16);
		
		return hexBuffer;
    }
    
    public String getTempValue(String readStr) {
    	String resultValue = "";
    	String tempValueStr = "";
    	String pointValueStr = "";
    	String minusFlag = "";
    	
    	try {
	    	int indexTP0 = readStr.indexOf("TP0");
	    	if (indexTP0 > 0) {
	    		tempValueStr = (""+Integer.valueOf(readStr.substring(indexTP0+3,indexTP0+7), 16).intValue()).trim();
	    		pointValueStr = (""+Integer.valueOf(readStr.substring(indexTP0+7, indexTP0+8), 16).intValue()).trim();
	    		logger.debug("[TEMPERATURE] readStr="+readStr);
	    		logger.debug("[TEMPERATURE] readStr.substring(indexTP0+3,indexTP0+7)="+readStr.substring(indexTP0+3,indexTP0+7));
	    		logger.debug("[TEMPERATURE] tempValueStr="+tempValueStr);
	    		logger.debug("[TEMPERATURE] pointValueStr="+pointValueStr);
	    		
	    		if (tempValueStr.length() >= 5) {
	    			try {
	    				tempValueStr = "" + (65535 - Integer.parseInt(tempValueStr));
	    				minusFlag = "-";
	    			} catch (Exception me) {
	    				resultValue = "-999";
	    				me.printStackTrace();
	    			}
	    		} 

	    		if (pointValueStr.equals("1")) {
	    			resultValue = minusFlag + tempValueStr.substring(0,tempValueStr.length()-1) + "." + tempValueStr.substring(tempValueStr.length()-1);
	    		} else {
	    			resultValue = minusFlag + tempValueStr;
	    		}
	    	} else {
	    		resultValue = "-999";
	    	}
    	} catch (Exception e) {
    		resultValue = "-999";
    	}
    	return resultValue;
    }
    
    public void sendCommandToTempDev(String tempCode, String commandGubun) {
		try {
	    	byte[] writeBuffer = null;
	    	
			if (commandGubun.equals("TP0")) {
				writeBuffer = getHexPacket(tempCode + "RX" + commandGubun);
				logger.debug("[TEMPERATURE] got hex packet and assign to writeBuffer variable");
			} else if (commandGubun.equals("TS0")) {
				writeBuffer = getHexPacket(tempCode + "RX" + commandGubun);
			} else if (commandGubun.equals("PON") || commandGubun.equals("POF")) {
				writeBuffer = getHexPacket(tempCode + "WX" + commandGubun);
			}
			
			logger.debug("[TEMPERATURE] write data:" + new String(writeBuffer));
			this.serialPort.writeBytes(writeBuffer);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    // Thread
    public void run() {

    	try {
			while(true) {
	    		if(this.serialPort.isOpened()) {
	    			for (String device : deviceList) {
						sendCommandToTempDev(device, "TP0");
						
						Thread.sleep(100);	//if not wait, get null value
						try {
							readBuffer = serialPort.readBytes();
						} catch (SerialPortException e) {
							logger.debug("[TEMPERATURE] failed to read from device");
							e.printStackTrace();
						}
						
						if(readBuffer != null) {
							String readStr = new String(readBuffer, StandardCharsets.UTF_8);
							logger.debug("read str:" + readStr);
							String tempValue = getTempValue(readStr);
							
							if(tempValue.equals("-999")) {
								logger.debug("[TEMPERATUR] failed to get temperature from censor");
							} else {
								insertData(device, tempValue, this.pid);
							}
						} else {
							logger.debug("read data is null");
						}
					}
					
					// break for 10 mins
					logger.debug("[TEMPERATURE] break for 10 mins");
					Thread.sleep(1000*60*10);
	    		} else {
	    			logger.debug("[TEMPERATURE] trying to open port");
	    			
		    		try {
		    			this.opened = this.serialPort.openPort();
						this.paramSetted = this.serialPort.setParams(19200, 8, 1, 0);
					} catch (SerialPortException e) {
						logger.error("[TEMPERATURE] serial port exception");
					}
		    		
		    		logger.info("[TEMPERATURE] Port opened: " + this.opened);
		    		logger.info("[TEMPERATURE] Params setted: " + this.paramSetted);
		    		
		    		Thread.sleep(1000 * 60 * 5);
	    		}
			}
		} catch(InterruptedException ie) {
			ie.printStackTrace();
			logger.error("[TEMPERATURE] thread interrupted");
		} finally {

		}
    }

    public void insertData(String deviceNum, String value, String pid) {
        try {
        	logger.debug("[TEMPERATURE] inserting data");
        	logger.debug("[TEMPERATURE] dev no. : " + deviceNum);
        	logger.debug("[TEMPERATURE] temp : " + value);
        	logger.debug("[TEMPERATURE] pid : " + pid);
        	
        	JSONObject jo = new JSONObject();
        	
        	String censorNo = "temp_dev" + deviceNum;
        	jo.put("censor_no", censorNo);
        	jo.put("censor_data_type", "TEMPERATURE");
        	jo.put("censor_value", value);

        	new DoyosaeTableModel(pid, jo);
        } catch (Exception e) {
        	logger.error("[TEMPERATURE] error while inserting data to DB	\n" + e);
        } finally {
        	
        }
    }
    
    public static void main(String args[]) {
    	try {
    		ThermalServerSerial r = new ThermalServerSerial("/dev/ttyUSB0");
    		Thread thread1 = new Thread(r, "Wonwoo Thread");
    		thread1.start();
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
}
