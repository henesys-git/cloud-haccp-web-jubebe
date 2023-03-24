package mes.frame.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;

import org.apache.log4j.Logger;

import mes.client.conf.SysConfig;
import net.wimpi.modbus.util.ModbusUtil;

public class SixSeallerServerModbus extends Thread {
	
	static final Logger logger = Logger.getLogger(SixSeallerServerModbus.class.getName());
	
    // 통신 관련
	private Socket sock = null;
	private BufferedInputStream inputStream = null;
	private BufferedOutputStream outputStream = null;
    
    private boolean connect() {
    	try {
            String ip = "192.168.0.100";
            int port = 4433;
            
	    	this.sock = new Socket(ip, port);
	    	this.sock.setSoTimeout(1000*3);
	    	this.inputStream = new BufferedInputStream(this.sock.getInputStream());
	    	this.outputStream = new BufferedOutputStream(this.sock.getOutputStream());
	    	
	    	if(this.sock.isConnected()) {
	    		return true;
	    	} else {
	    		return false;
	    	}
    	} catch(Exception e) {
    		return false;
    	}
    }
    
	public byte[] sendCommandToGetQty(int tempId) {
		byte[] resultBytes = new byte[8];
		
		try {
			byte byteId = Byte.parseByte(""+(tempId) );
			
			// [D3490]의 1개 word를 읽기 위해서는 
			// PLC의 Modbus설정에서 Read Address 를 [D3490]으로 설정하고
			// function code는 0x04 (for read word)
			// 읽는 번지를 0x00 0x00로 정한다.
			// 그리고 읽는 갯수를 0x00 0x01로 한다.
			resultBytes[0] = (byte)byteId; 	// Slave ID
			resultBytes[1] = (byte)0x04; 	// 0x03
			resultBytes[2] = (byte)0x00; 	// Register Address Hi  [cnt = D3490]
			resultBytes[3] = (byte)0x00; 	// Register Address Lo
			resultBytes[4] = (byte)0x00; 	// Numbers of Read Data Hi
			resultBytes[5] = (byte)0x01; 	// Numbers of Read Data Lo
	
			int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
			resultBytes[6] = (byte)crc[0];
			resultBytes[7] = (byte)crc[1];
			for (int i=0; i<8; i++) {
				logger.debug("" + ModbusUtil.toHex( resultBytes,i,(i+1) ));
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
		}

		return resultBytes;
	}

    // 받은 전문을 분해해서 디비등 처리할 포맷으로 바꾼다.
    private String parseValue(byte[] rcvDataBuffer) {
    	String returnStr = "";
    	
    	// 받은 값
    	int totSeallingCount = 0;

    	try {
    		// 값을 구해서 서블릿에 보낸다.
    		totSeallingCount = Integer.parseInt( ModbusUtil.toHex(rcvDataBuffer, 3, 3+2).replace(" ", ""), 16 );
    		returnStr = "" + totSeallingCount;
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	return returnStr;
    }
    
    public synchronized String getCupSealerTotal(int slaveId) {
    	String total = "-1";
    	String data = "";
    	boolean connected = connect();
    	
    	if(connected) {
	    	try {
		    	byte[] writeBuffer = sendCommandToGetQty(slaveId);
				
		    	outputStream.write(writeBuffer);
		    	outputStream.flush();
				logger.debug("[6컵실러 (국번 " + slaveId + "번] write:" + new String(writeBuffer));
				
				//Thread.sleep(1000);
				
				byte[] recvPacket = new byte[2048];
				int readSize = inputStream.read(recvPacket);
		    	
				//String returnMsg = ModbusUtil.toHex(recvPacket, 0, readSize);
				//logger.debug("[6컵실러 (국번 " + slaveId + "번] read:" + returnMsg);
		    	
//				total = Integer.parseInt(parseValue(recvPacket));
				//total = parseValue(recvPacket);
				data = new String(recvPacket);
				
				logger.debug(data);
				
				logger.debug("[6컵실러 (국번 " + slaveId + "번] 수량:" + data);
			} catch (Exception e) {
				logger.error("[6컵실러 (국번 " + slaveId + "번] 수량 조회 실패:" + data);
				e.printStackTrace();
			} finally {
				try {
	    			if (!this.sock.isClosed()) {
	    				this.sock.close();;
	    				this.inputStream.close();
	    				this.outputStream.close();
	    			}
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
			}
	    
	    	return data;
    	} else {
    		logger.error("[6컵실러 (국번 " + slaveId + "번] 연결 실패:" + data);
    		return data;
    	}
    }
    
    public static void main(String args[]) {
    	SixSeallerServerModbus aa = new SixSeallerServerModbus();
    	
    	aa.getCupSealerTotal(1);
    }
}
