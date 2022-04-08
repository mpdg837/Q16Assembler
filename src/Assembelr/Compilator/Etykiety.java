package Assembelr.Compilator;

import java.util.ArrayList;
import java.util.HashMap;

public class Etykiety {

    public HashMap<String,Integer> etykiety;


    public Etykiety(ArrayList<String> listaLini){

        etykiety = new HashMap<>();

        int index = 0;
        for(String linia : listaLini){
            char[] znaki = linia.toCharArray();

            if(znaki.length>0) {
                if ((znaki[znaki.length - 1] + "").equals(":")) {
                    StringBuilder etykietaBuild = new StringBuilder();

                    for (int n = 0; n < znaki.length - 1; n++) {
                        etykietaBuild.append(znaki[n]);
                    }

                    etykiety.put(etykietaBuild.toString(), index);
                    listaLini.set(index, "");
                }
            }
            index ++;
        }

    }

}
