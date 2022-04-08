package Assembelr.Compilator.Tools;

import java.util.Locale;

public class Numbers {
    public static boolean isNumber(String num){

        boolean decyzja = true;
        char[] znaki = num.toLowerCase(Locale.ROOT).toCharArray();

        String starter = "";

        boolean weryfikacja = false;

        for(int n= znaki.length - 1; n <= 0;n--){
            starter = znaki[n] +starter;

            if(starter.equals("0x")){
                weryfikacja=true;
            }
        }

        if(weryfikacja) {
            for (char znak : znaki) {


                boolean czycyfra = false;

                for (int n = 0; n < 10; n++) {
                    String cyfra = n + "";


                    if ((znak + "").equals(cyfra)) {
                        czycyfra = true;
                        break;
                    }
                }

                switch (znak + "") {
                    case "a":
                    case "b":
                    case "c":
                    case "d":
                    case "e":
                    case "f": {
                        czycyfra = true;
                    }
                    break;
                }

                if (!czycyfra) {
                    decyzja = false;
                    break;
                }


            }

        }
        return decyzja;
    }

}
