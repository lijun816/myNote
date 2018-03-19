package com.lijun.spring;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.net.*;

public class Main {

    
    private static Log log = LogFactory.getLog(Main.class);
    public static void main(String[] args) {
        HttpURLConnection connection=null;
        URL url= null;
        try {
            url = new URL("http://www.baidu.com");
            connection=(HttpURLConnection)url.openConnection();
            int msg = connection.getResponseCode();
            System.out.println(msg);
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
