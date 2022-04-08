package Assembelr.Compilator.Tools;

import java.util.ArrayList;

public class Decomposer {

    public static String[] decomp(String instruction){
        String[] decs = instruction.split(",");
        ArrayList<String> elements = new ArrayList<String>();

        for(String dec : decs){
            String[] els = dec.split(" ");

            for(String el: els){
                elements.add(el);
            }
        }

        String[] elementsA = new String[elements.size()];

        int k =0;
        for(String el : elements){
            elementsA[k] = el;
            k++;
        }
        return elementsA;
    }
}
