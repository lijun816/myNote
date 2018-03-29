package com.xl.pay.util;

public class RandomUtil {

    /**
     * 产生支付交易中需要产生nonce_str的字符串
     * @return nonce_str字符串
     */
    public static String getNonceStr(){
        return String.valueOf(System.currentTimeMillis());
    }
}
