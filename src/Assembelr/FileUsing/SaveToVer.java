package Assembelr.FileUsing;

import java.io.*;
import java.util.ArrayList;

public class SaveToVer {

    public SaveToVer(ArrayList<String> lista,String fileName) throws IOException{

        FileWriter wri = new FileWriter(new File(fileName));

        for(String linijki : lista){
            wri.write(linijki+"\n");
        }

        wri.close();

    }

}
