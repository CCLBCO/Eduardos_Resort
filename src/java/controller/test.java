package controller;
import controller.Security;


public class test {
    public static void main (String args[]){
     
    String p = "password";
    Security sc = new Security();
    System.out.println(p = sc.encrypt(p));
    
    System.out.println(sc.decrypt(p));
    // cSeB47o4CarlY/Kmw711sw==
    }
   
}