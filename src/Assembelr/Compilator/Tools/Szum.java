package Assembelr.Compilator.Tools;

import Assembelr.Assembelr;
import Assembelr.Compilator.BinaryConverter;
import Assembelr.Compilator.*;

import java.util.HashMap;
import java.util.Random;

public class Szum {

    int index;
    HashMap<Integer,String> data;
    public Szum(int index, HashMap<Integer,String> data){
        this.index = index;
        this.data = data;
    }

    public String szumnaLini(){
        StringBuilder losline = new StringBuilder();



        for(int l=0;l<16;l++){

            Random rnd = new Random();
            if(rnd.nextFloat()>0.5){
                losline.append("0");
            }else{
                losline.append("1");
            }

        }
        return losline.toString();
    }
    public void szumMe(BinaryConverter conv){

        while(conv.index < 2048){


            int hindex0 = conv.index*2 ;
            int hindex1 = conv.index*2 +1;

            String data0="";
            String data1="";

            if(data.keySet().contains(hindex0)){
                data0 = data.get(hindex0);
            }else{
                data0 = szumnaLini();
            }
            if(data.keySet().contains(hindex1)){
                data1 = data.get(hindex1);
            }else{
                data1 = szumnaLini();
            }

            String suma = data1 + "" + data0;

            conv.printLine(suma);

        }
    }
}
