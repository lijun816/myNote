package com.xl.pay.util;

import com.xl.pay.exception.BaseException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;

public class HttpUtil {

    public static String postReturnString(String reqUrl,String xmlBody) throws BaseException{
        CloseableHttpResponse response = null;
        CloseableHttpClient client = null;
        String res;
        try {
            HttpPost httpPost = new HttpPost(reqUrl);
            StringEntity entityParams = new StringEntity(xmlBody,"utf-8");
            httpPost.setEntity(entityParams);
            httpPost.setHeader("Content-Type", "text/xml;charset=utf-8");
            client = HttpClients.createDefault();
            response = client.execute(httpPost);
            if(response == null || response.getEntity() == null){
                throw new BaseException(404,"未包含响应信息");
            }
            return EntityUtils.toString(response.getEntity());
        } catch (Exception e) {
            res = e.getMessage();
        } finally {
            if(response != null){
                try {
                    response.close();
                } catch (IOException e) {
                    //
                }
            }
            if(client != null){
                try {
                    client.close();
                } catch (IOException e) {
                    //
                }
            }
        }
        throw new BaseException(400,res);
    }
}
