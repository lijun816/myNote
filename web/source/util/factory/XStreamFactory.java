package com.xl.pay.util.factory;

import com.thoughtworks.xstream.XStream;
import com.xl.pay.web.PayController;

import java.util.*;

public class XStreamFactory {

    /**
     * 获取xml解析对象
     */
    public static XStream getXStream(Map<String,Class> map) {
        XStream xstream = new XStream();
        XStream.setupDefaultSecurity(xstream);
        xstream.ignoreUnknownElements();
        if (map != null){
            List<Class> list = new ArrayList<>();
            for (Map.Entry<String,Class> entry:map.entrySet()) {
                xstream.alias(entry.getKey(), entry.getValue());
                list.add(entry.getValue());
            }
            Class[] clss = (Class[]) list.toArray();
            xstream.allowTypes(clss);
        }
        xstream.autodetectAnnotations(true);//自动检测注解
        return xstream;
    }
}
