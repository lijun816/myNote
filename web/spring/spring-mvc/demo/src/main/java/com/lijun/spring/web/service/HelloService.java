package com.lijun.spring.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @author dream
 */
@Service
public class HelloService {
    private static Logger log =  LoggerFactory.getLogger(HelloService.class);
    public String hello(){
        log.error("HelloService,hello","你好");
        return "hello";
    }
}
