/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 *
 * @author Gil Cruzada
 */
public class test1 {
    
    public static void main (String args[]) throws IOException{
        
        Path path = Paths.get("ER_logo_noBG.png");
        String img = path.getRoot().toString();
        System.out.println(img);
              
    }
    
    public void image(){
        URL url = getClass().getResource("web/image/ER_logo_noBG.png");
        File file = new File(url.getPath());  
        System.out.println(file);
        
    }
}
