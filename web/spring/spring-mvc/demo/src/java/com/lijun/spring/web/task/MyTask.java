package com.lijun.spring.web.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.annotation.Schedules;
import org.springframework.stereotype.Component;

@Component
public class MyTask {

    private static Logger log = LoggerFactory.getLogger(MyTask.class);

    /**
     * 单位毫秒
     */
    @Scheduled(fixedRate = 1000*60*60,initialDelay = 1)
    public void task() {
        log.info("MyTask,task:{}", "循环任务测试");
    }
}
