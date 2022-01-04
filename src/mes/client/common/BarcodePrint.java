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
		String returnbarcodeValue = "바코드 프린트 성공";
		
		Socket socket = null;
		
		/*
		 * 명령어에 대한 자세한 설명은 매뉴얼 참고 
		 * 매뉴얼 위치 : 플로우 인터페이스 프로젝트에서 '바코드'로 검색 나원석 대리가 올린 압축 파일
		 * 안의 '프린터_명령어.pdf'
		 */
		String command = new StringBuilder("")
			  // 미디어(라벨 용지) 가로 75mm, 세로 45mm, 갭 2mm (D세로+갭, 가로, 세로)
			  .append("{D0470,0750,0450|}")
    		  // 버퍼 삭제 명령(전에 기억하고 있던 명령을 삭제함)
    		  .append("{C|}")
    		  // 바코드 인쇄 명령
    		  // XBaa;bbbb,cccc,d,e,ff,k,llll(,mnnnnnnnnn,ooo,p,qq)
    		  //	aa:바코드번호(00-31까지 사용가능)
    		  //	bbbb:바코드의 인쇄 X 위치 (0.1mm단위)
    		  //	cccc:바코드의 인쇄 Y 위치 (0.1mm단위)
    		  //	d:바코드 종류 (매뉴얼 참고)
    		  //	e:체크디지트 종류 (1:체크디지트 없음)
    		  //	ff:1모듈단위 지정 (01-15 사이, 1dot 단위)
    		  //	k:바코드 회전 (0-3까지 사용, 0:0도 1:90도 2:180도 3:270도)
    		  //	llll:바코드의 세로길이 (0000-1000, 0.1mm 단위)
    		  //	mnnnnnnnnn:바코드 데이트의 자동 증가/감소 지정 (m이 +면 증가, -면 감소)
    		  //	ooo:WPC 가이드바의 길이 (보통 015로 잡아줌)
    		  //	p:바코드 아래의 숫자 인쇄 지정 (0:숫자x, 1:숫자o)
    		  //	qq:Zero suppression 지정 (00-20 사이)
    		  .append("{XB01;0190,0100,9,1,02,0,0100,+0000000000,000,1,00|}")
    		  // 바코드 값
    		  .append("{RB01;"+barcodeValue+"|}")
    		  // 제품명 값 & 설정 
    		  .append("{PV01;"+xPos+",0350,0075,0080,01,0,00,B="+prodName+"|}")
			  /*
			   * 라벨 인쇄 명령 
			   * XS:I,aaaa,bbbcdefgh
			   * 	aaaa: 인쇄 수량 지정 (0001-9999 사이)
			   * 	bbb: 커팅 간격 (몇장 인쇄 후 커팅할 것인지, 000-100 사이)
			   * 	이하 매뉴얼 참조
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
			returnbarcodeValue = "바코드 프린터 연결 실패";
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
































