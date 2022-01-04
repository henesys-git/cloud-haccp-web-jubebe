package mes.client.guiComponents;

import java.awt.Desktop;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Vector;

public class Excel {
    private java.lang.String message;
    private java.util.Vector vector;
    private String header;
    //전역변수선언
    //int SS_MAIN_SERNO = com.srit.common.session.Session.getLpsMainSer();

    public Excel() {
        super();
    }

    public Excel(java.util.Vector vector) {
        super();
        setVector( vector);
    }

    public String getMessage() {
        return message;
    }

    public void setVector(java.util.Vector vector) {
        this.vector = vector;
    }

    public void setHeader(String newHeader) {
        this.header = newHeader;
    }

    public void setMessage(java.lang.String newMessage) {
        message = newMessage;
    }
    public boolean  runExcel(String filename) {
        if( ! writeFile( filename) ) return false;
        
        try {
            //Runtime runtime = Runtime.getRuntime();
            //runtime.exec( "cmd /C start excel " + filename);
        	Desktop.getDesktop().open(new File(filename));
        } catch (Exception e) {
            this.setMessage( "Excel 실행 중 오류가 발생했습니다. " + e.getMessage());
            return false;
        }
        return true;
    }

    public boolean writeFile(String filename) {
        if (vector==null) return false;

        Vector rowData;
        StringBuffer lineBuffer = new StringBuffer();

        File file = new File( filename);
        file.delete();

        try {
            FileOutputStream writer = new FileOutputStream(filename);

            if (header != null) {
                writer.write( (header + "\r\n").getBytes());
            }

            for (int row=0; row<vector.size(); row++){
                rowData = (Vector)vector.elementAt(row);
                lineBuffer.setLength(0);
                for (int col=0; col<rowData.size(); col++){
                    if (lineBuffer.length() != 0) {
                        lineBuffer.append( '\t');
                    }
                    String data = "";

                    try{
                        data = (String)rowData.elementAt(col);
                        ///// 아래 두 라인은 \r\n 가 들어 있는 경우 한 라인에 저장되지 않는 관계로 걸러낸다.
                        // 2016.09.29 DOYOSAE
                        data = data.replaceAll("\r", "");
                        data = data.replaceAll("\n", "");
                    }catch(Exception bex){
                        Boolean check = (Boolean)rowData.elementAt(col);
                        data = check.toString();
                        if(data.equals("true")) data = "Y";
                        else data ="";
                    }
                    if(data == null || data.equals("")) data = " ";
                    lineBuffer.append( data );
//                  lineBuffer.append( (String)rowData.elementAt(col) );
                }
                lineBuffer.append("\n");
                writer.write( (lineBuffer.toString()).getBytes());
            }
            writer.flush();
            writer.close();

        } catch (Exception e)  {
            setMessage("파일저장중 오류가 발생했습니다." + e.getMessage());
            return false;
        }
        return true;
    }
}
