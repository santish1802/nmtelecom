package com.utp.nmtelecom.controller;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
public class TestController {

    @GetMapping("/test")
    public List<String> listFilesInJar() throws IOException {
        List<String> fileList = new ArrayList<>();
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

        // Busca JSP en el jar
        Resource[] resourcesJsp = resolver.getResources("classpath*:META-INF/resources/**/*.jsp");
        Resource[] resourcesHtml = resolver.getResources("classpath*:META-INF/resources/**/*.jspf");

        // Busca HTML si tuvieras

        for (Resource res : resourcesJsp) {
            fileList.add("JSP: " + res.getURL().toString());
        }

        for (Resource res : resourcesHtml) {
            fileList.add("HTML: " + res.getURL().toString());
        }

        return fileList;
    }
}
