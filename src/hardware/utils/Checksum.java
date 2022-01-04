package hardware.utils;

import net.wimpi.modbus.util.ModbusUtil;

public class Checksum {
	
	public static byte getChecksum(byte[] value) {
		int checksum = 0;
	
		for (int i = 0; i < 19; i++) {
			checksum += Integer.parseInt(ModbusUtil.toHex(value, i, i+1).replace(" ", ""), 16);
	
			if (checksum > 255) {
				checksum = checksum - 256;
			}
		}
	
		return (byte)(checksum);
	}
	
}
