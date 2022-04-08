package Assembelr.Compilator;

public class Translator {


    public String translateReg(String reg) throws Exception {

        switch (reg){
            case "eax" -> {return "00";}
            case "ebx" -> {return "01";}
            case "ecx" -> {return "10";}
            case "edx" -> {return "11";}
            default -> {throw new Exception("Nieprawidłowy zapis rejestru "+ reg);}
        }
    }

    public String makeStarter(){
        StringBuilder build = new StringBuilder();
        for(int n=0;n<7;n++){
            build.append("0");
        }

        return build.toString();
    }

    public String hexToBin(String hex){
        String bin = "";
        String binFragment = "";
        int iHex;
        hex = hex.trim();
        hex = hex.replaceFirst("0x", "");

        for(int i = 0; i < hex.length(); i++){
            iHex = Integer.parseInt(""+hex.charAt(i),16);
            binFragment = Integer.toBinaryString(iHex);

            while(binFragment.length() < 4){
                binFragment = "0" + binFragment;
            }
            bin += binFragment;
        }
        return bin;
    }

    public String addNum(String arg){
        String num = hexToBin(arg);
        char[] numC = num.toCharArray();
        StringBuilder newNum = new StringBuilder();

        if(num.length()>16){
            for(int n=17;n>=0;n--){
                newNum.append(numC[n]);
            }
        }else if(num.length()< 16){

            for(int n=0;n < 16-num.length();n++){
                newNum.append("0");
            }
            newNum.append(num);
        }else{
            newNum.append(num);
        }

        return newNum.toString();

    }

    public String makeLineArg(String insturction, boolean special1,boolean special2,String arg) throws Exception {

        StringBuilder build = new StringBuilder();
        if(insturction.length()==5) {

            build.append(makeStarter());

            build.append(insturction);

            if(special2){
                build.append(translateReg("ebx"));
            }else
            if(special1){
                build.append(translateReg("ecx"));
            }else{
                build.append(translateReg("eax"));
            }
            build.append(translateReg("eax"));

            build.append(addNum(arg));


        }else{
            throw new Exception("Nieprawidłowa długość rozkazu");
        }
        return build.toString();

    }

    public String makeLineRegArg(String insturction, String reg1,String arg) throws Exception {

        StringBuilder build = new StringBuilder();
        if(insturction.length()==5) {

            build.append(makeStarter());

            build.append(insturction);

            build.append(translateReg(reg1));
            build.append(translateReg("eax"));

            build.append(addNum(arg));


        }else{
            throw new Exception("Nieprawidłowa długość rozkazu");
        }
        return build.toString();

    }

    public String makeLineTwoReg(String insturction, String reg1,String reg2,boolean special) throws Exception {

        StringBuilder build = new StringBuilder();
        if(insturction.length()==5) {

            build.append(makeStarter());

            build.append(insturction);

            build.append(translateReg(reg1));
            build.append(translateReg(reg2));
            if(special){
                build.append(addNum("1"));
            }else {
                build.append(addNum("0"));
            }

        }else{
            throw new Exception("Nieprawidłowa długość rozkazu");
        }
        return build.toString();

    }

    public String makeLineOneReg(String insturction, String reg1,boolean special) throws Exception {

        StringBuilder build = new StringBuilder();
        if(insturction.length()==5) {

            build.append(makeStarter());

            build.append(insturction);

            build.append(translateReg(reg1));
            build.append("00");
            if(special){
                build.append(addNum("1"));
            }else {
                build.append(addNum("0"));
            }

        }else{
            throw new Exception("Nieprawidłowa długość rozkazu");
        }
        return build.toString();

    }

}
