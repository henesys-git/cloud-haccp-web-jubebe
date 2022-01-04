package mes.client.common;

import java.net.Socket;

import org.json.simple.JSONObject;

import mes.client.guiComponents.DoyosaeTableModel;

import java.io.DataOutputStream;
import java.io.OutputStreamWriter;

public class BarcodePrint {
	private String ip = "";
	private int port = 0;
	private String barcodeValue = "";
	private String prodName = "";
	
	public BarcodePrint(String ip, int port, String barcodeValue, String prodName) {
		this.ip = ip;
		this.port = port;
		this.barcodeValue = barcodeValue;
		this.prodName = prodName;
		System.out.println(prodName);
	}
	
	public String setPositionX(int len) {
		String xPos = "";
		
		switch(len) {
			case 6:
				xPos = "0180";
				break;
			case 7:
				xPos = "0175";
				break;
			case 8:
				xPos = "0165";
				break;
			case 9:
				xPos = "0160";
				break;
			case 10:
				xPos = "0155";
				break;
			default:
				xPos = "0185";
		}
		
		return xPos;
	}
	
	public String startPrint() {
		System.out.println(prodName);

		String xPos = setPositionX(prodName.length());
		
		System.out.println("=============BARCODE PRINTING START=============");
		String returnbarcodeValue = "���ڵ� ����Ʈ ����";
		
		Socket socket = null;
		
		/*
		 * ��ɾ ���� �ڼ��� ������ �Ŵ��� ���� 
		 * �Ŵ��� ��ġ : �÷ο� �������̽� ������Ʈ���� '���ڵ�'�� �˻� ������ �븮�� �ø� ���� ����
		 * ���� '������_��ɾ�.pdf'
		 */
		String command = new StringBuilder("")
			  // �̵��(�� ����) ���� 75mm, ���� 45mm, �� 2mm (D����+��, ����, ����)
			  .append("{D0470,0750,0450|}")
    		  // ���� ���� ���(���� ����ϰ� �ִ� ����� ������)
    		  .append("{C|}")
    		  // ���ڵ� �μ� ���
    		  // XBaa;bbbb,cccc,d,e,ff,k,llll(,mnnnnnnnnn,ooo,p,qq)
    		  //	aa:���ڵ��ȣ(00-31���� ��밡��)
    		  //	bbbb:���ڵ��� �μ� X ��ġ (0.1mm����)
    		  //	cccc:���ڵ��� �μ� Y ��ġ (0.1mm����)
    		  //	d:���ڵ� ���� (�Ŵ��� ����)
    		  //	e:üũ����Ʈ ���� (1:üũ����Ʈ ����)
    		  //	ff:1������ ���� (01-15 ����, 1dot ����)
    		  //	k:���ڵ� ȸ�� (0-3���� ���, 0:0�� 1:90�� 2:180�� 3:270��)
    		  //	llll:���ڵ��� ���α��� (0000-1000, 0.1mm ����)
    		  //	mnnnnnnnnn:���ڵ� ����Ʈ�� �ڵ� ����/���� ���� (m�� +�� ����, -�� ����)
    		  //	ooo:WPC ���̵���� ���� (���� 015�� �����)
    		  //	p:���ڵ� �Ʒ��� ���� �μ� ���� (0:����x, 1:����o)
    		  //	qq:Zero suppression ���� (00-20 ����)
    		  .append("{XB01;0190,0100,9,1,02,0,0100,+0000000000,000,1,00|}")
    		  // ���ڵ� ��
    		  .append("{RB01;"+barcodeValue+"|}")
    		  // ��ǰ�� �� & ���� 
    		  .append("{PV01;"+xPos+",0350,0075,0080,01,0,00,B="+prodName+"|}")
			  /*
			   * �� �μ� ��� 
			   * XS:I,aaaa,bbbcdefgh
			   * 	aaaa: �μ� ���� ���� (0001-9999 ����)
			   * 	bbb: Ŀ�� ���� (���� �μ� �� Ŀ���� ������, 000-100 ����)
			   * 	���� �Ŵ��� ����
			   */
    		  .append("{XS;I,0001,0002C5101|}")
    		  .toString();

		DataOutputStream out = null;
		OutputStreamWriter osw = null;
		  
		try {
			socket = new Socket(ip, port);
			socket.setSoTimeout(1000);
			  
			osw = new OutputStreamWriter(socket.getOutputStream(), "UTF-8");
			osw.write(command);
			osw.flush();
			
			insertBarcodeInfoIntoDb();
		} catch (Exception e) {
			returnbarcodeValue = "���ڵ� ������ ���� ����";
			e.printStackTrace();
			System.out.println("Exception e : " + e.toString());
		} finally {
			if(osw != null) { 
				try { 
					osw.close(); 
				} catch(Exception e) { 
					osw = null; 
				}
			}
			if(out != null) { 
				try { 
					out.close(); 
				} catch(Exception e) { 
					out = null; 
				}
			}
			if(socket != null) { 
				try { 
					socket.close(); 
				} catch(Exception e) { 
					socket = null; 
				}
			}
		}
		System.out.println("==============BARCODE PRINTING END==============");
		return returnbarcodeValue;
	}
	
	public void insertBarcodeInfoIntoDb() {
		JSONObject jArray = new JSONObject();
		
		jArray.put("barcodeValue", barcodeValue);
		jArray.put("prodName", prodName);
		
		new DoyosaeTableModel("M303S020500E111", jArray);
	}
}
































