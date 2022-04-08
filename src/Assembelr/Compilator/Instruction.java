package Assembelr.Compilator;

import Assembelr.Compilator.Tools.Decomposer;
import Assembelr.Compilator.Tools.Numbers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class Instruction {

    String instrukcja;
    ArrayList<String> regs = new ArrayList<>();
    String num;

    public Instruction(String linia, HashMap<String,Integer> etykiety) throws Exception {



        if (!linia.equals("")) {

            String[] rozkazy = new String[]{"sot","nop","hlt","rst","set","in","out","inc","jmp","save","ram","uram","exp","rexp","not","add","sub","and","eor","shl","shr","xor","jeq","jeeq","res","jgt","jegt","jlt","jelt","dec","cmp","read","mov","pop","push","mul","emul","div","rem","call","ret"};
            ArrayList<String> rozkL = new ArrayList<>();

            rozkL.addAll(Arrays.asList(rozkazy));

            String[] els = Decomposer.decomp(linia);

            boolean poprawnaKomenda = false;

            for(String el: els){
                switch (el){

                    case "eax":
                    case "ebx":
                    case "ecx":
                    case "edx":
                        regs.add(el);
                        break;
                    default:
                        if(etykiety.keySet().contains(el)){

                            int n=0;
                            for(String names: etykiety.keySet()){
                                if(el.equals(names)) {
                                    int prenum = etykiety.get(names);

                                    try {
                                        num = Integer.toHexString(prenum);
                                    }catch (Exception err){
                                        throw new Exception("Nieprawidlowy format str");
                                    }
                                }
                                n++;
                            }
                        }else
                        if(rozkL.contains(el)){
                            instrukcja = el;
                            poprawnaKomenda = true;
                        }else
                        if(Numbers.isNumber(el)){
                            num = el;
                        }else{

                            throw new Exception("Nieznany element rozkazu");

                        }


                        break;

                }

            }

            if(poprawnaKomenda){
                System.out.println("Wykryto prawidlowy rozkaz :"+instrukcja);
            }else{
                throw new Exception("Nie ma takiego rozkazu");
            }


        }
    }
}
