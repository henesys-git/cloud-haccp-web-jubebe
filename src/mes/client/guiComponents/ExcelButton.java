package mes.client.guiComponents;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.net.URL;
import java.util.Vector;

import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;

import mes.client.common.Common;
import mes.client.conf.Config;

public class ExcelButton extends JButton implements ActionListener {
    private Vector vector = null;
    private String headerString = "";

    public Icon getIcon() {
        Icon retIcon = null;

        try {
            retIcon = new ImageIcon(new URL(Config.ICON_18X18_PATH + "msexcel.gif"));
        } catch (Exception e) {
            System.out.println( "Image File Not Found.");
        }
        return retIcon;
    }

    public ExcelButton() {
        super();
    }
    public ExcelButton(String title) {
        super("" + title);
        super.setIcon( (Icon)this.getIcon() );
    }

    public void actionPerformed(ActionEvent e) {
        File filePath = new File("c:\\ACEM\\");
        if (!filePath.exists()) {
        	filePath.mkdir();
        }

        if (vector == null || vector.size() == 0) {
                JOptionPane.showMessageDialog(this, "자료가 없습니다." );
                return;
        }

        Excel excel = new Excel( vector );

        if (headerString.length() > 0) excel.setHeader( headerString );

        if ( !excel.runExcel( "c:\\ACEM\\sales_hist_" + Common.getSystemTime("datetimeNumeric") + ".xls" ) ) {
            JOptionPane.showMessageDialog(this, excel.getMessage() );
        }
        excel = null;
    }
    public void setVector(Vector vector) {
        this.vector = vector;
    }

    public void setHeader(String[] headerString) {
        String newHeader = "";

        for(int i=0 ; i < headerString.length ; i++){
            newHeader += headerString[i];

            if( i < (headerString.length - 1)) newHeader += "\t";
        }

        this.headerString = newHeader;
    }
}
                                                         
