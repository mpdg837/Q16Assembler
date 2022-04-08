package Assembelr.FileUsing;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.Locale;

public class FileLoader {


    public static ArrayList ladujPlik(File file) throws IOException {
        ArrayList<String> zaw= new ArrayList<>();

        FileReader read = new FileReader(file);
        LineNumberReader reader = new LineNumberReader(read);

        String linia = "";
        while((linia = reader.readLine()) !=null){
            char[] znak = linia.toLowerCase(Locale.ROOT).toCharArray();

            StringBuilder build = new StringBuilder();
            boolean start = false;
            boolean stop = false;
            if(znak.length>0) {



                    for (char znaki : znak) {

                        if (!(znaki + "").equals(" ") && !(znaki + "").equals((char) 8 + "")) start = true;

                        if (start) {
                            if ((znaki + "").equals("/")) {
                                stop = true;
                            } else if(!stop){
                                build.append(znaki);
                            }
                        }


                    }

                    if(stop){
                        // Usuwanie spacji
                        String preBuild = build.toString();
                        char[] znaki = preBuild.toCharArray();

                        String dane = "";

                        start = false;

                        for(int n=znaki.length-1;n>=0;n--){
                            if (!(znaki[n] + "").equals(" ") && !(znaki[n] + "").equals((char) 8 + ""))  start  =true;

                            if(start){
                                dane = znaki[n] + dane;
                            }
                        }

                        if(dane.length()>0){
                            System.out.println(dane);
                            zaw.add(dane);
                        }

                    }else{
                        if(build.toString().length()>0) {
                            System.out.println(build.toString());
                            zaw.add(build.toString());
                        }
                    }




            }

        }


        return zaw;
    }
}
