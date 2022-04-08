package Assembelr.Compilator.Tools;

import java.util.ArrayList;

public class Starter {

    public static ArrayList<String> start(ArrayList<String> linijki) {
        linijki.add("module KERNAL(");
        linijki.add("       input clk,");
        linijki.add("       input[11:0] addr,");
        linijki.add("       output reg[31:0] out");
        linijki.add(");");
        linijki.add("");
        linijki.add("always@(posedge clk)");
        linijki.add("case(addr[10:0])");
        return linijki;
    }
    public static ArrayList<String> end(ArrayList<String> linijki){

        linijki.add("default: out <= 0;");
        linijki.add("endcase");
        linijki.add("endmodule");

        return linijki;
    }

}
