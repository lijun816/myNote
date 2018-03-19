package com.lijun.spring.web.controller;

import com.lijun.spring.web.service.HelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

/**
 * @author dream
 */
@Controller
public class HelloController {

    @Autowired
    HelloService helloService;

    @RequestMapping("/hello")
    @ResponseBody
    public String hello(){
        return helloService.hello();
    }


    @RequestMapping("/hello1")
    public ModelAndView hello1(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("hello");
        mv.addObject("name","abc");
        List<String> list = new ArrayList<>();
        list.add("a");
        list.add("b");
        list.add("c");
        mv.addObject("list",list);
        return mv;
    }

}
