package Assembelr.Compilator.Tools;

import java.sql.SQLSyntaxErrorException;
import java.util.ArrayList;
import java.util.HashMap;

public class DataConverter {

    public ArrayList<String> nlist;
    public HashMap<String,String> zmienne;

    public DataConverter(){
        nlist = new ArrayList<>();
    }

    public HashMap<Integer,String> getData(ArrayList<String> linie){
        HashMap<Integer,String> data = new HashMap<>();

        nlist = new ArrayList<>();

        for(String linia : linie) {

            char[] znaki = linia.toCharArray();

            String komenda = "";
            boolean wykryto = false;
            boolean start = false;
            boolean nazwa = false;

            String adres="";
            String datax="";

            for (int n = 0; n < znaki.length; n++) {

                if (!(znaki[n] + "").equals(" ") && !(znaki[n] + "").equals((char) 8 + "")) start = true;

                if (start && !wykryto) {
                    komenda = komenda + znaki[n];

                    if (komenda.equals("&data")) {
                        wykryto = true;

                    }
                }else if(start && wykryto) {
                    if (!(znaki[n] + "").equals(" ") && !(znaki[n] + "").equals((char) 8 + "")){
                        if ((znaki[n] + "").equals("<")) {
                            nazwa = true;
                        } else if (nazwa) {
                            datax = datax + znaki[n];
                        } else {
                            adres = adres + znaki[n];
                        }
                    }

                }

            }

            if(wykryto){
                try{

                    String naddr = "";
                    String starter = "";
                    boolean zaczal = false;

                    for(char znakia: adres.toCharArray()){
                        if(!zaczal) {
                            starter = starter + znakia;

                            if (starter.equals("0x")) {
                                zaczal = true;
                            }
                        }else{
                            naddr = naddr + znakia;
                        }
                    }

                    int num = Integer.parseInt(naddr,16);

                    boolean zlyznak = false;

                    int n=0;
                    for(char znakix : datax.toCharArray()){
                        n++;
                        if(!(znakix+"").equals("0") && !(znakix+"").equals("1")) zlyznak = true;
                    }

                    if(n!=16) throw new Exception();
                    if(zlyznak) throw new Exception();

                    data.put(num,datax);

                }catch (Exception err){
                    System.out.println("Nieprawidłowy format danych dodatkowych");
                    nlist.add(linia);
                }

            }

            if (!wykryto) {
                nlist.add(linia);
            }else{
                System.out.println("Załadowano dane adres:"+adres+" dane:"+datax);
            }
        }


        return data;
    }

}
