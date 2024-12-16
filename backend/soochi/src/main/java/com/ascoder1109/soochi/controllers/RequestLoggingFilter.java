package com.ascoder1109.soochi.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.filter.CommonsRequestLoggingFilter;
import jakarta.servlet.http.HttpServletRequest;

public class RequestLoggingFilter extends CommonsRequestLoggingFilter {

    private static final Logger logger = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    protected boolean shouldLog(HttpServletRequest request) {
        return true; // Customize based on your needs
    }

    @Override
    protected void beforeRequest(HttpServletRequest request, String message) {
        logger.info("Incoming request: {} {}", request.getMethod(), request.getRequestURI());
        logger.info("Request headers: {}", getRequestHeaders(request));
        logger.info("Request parameters: {}", request.getParameterMap());
    }

    @Override
    protected void afterRequest(HttpServletRequest request, String message) {
        logger.info("Response processed for: {} {}", request.getMethod(), request.getRequestURI());
    }

    private String getRequestHeaders(HttpServletRequest request) {
        StringBuilder headers = new StringBuilder();
        request.getHeaderNames().asIterator().forEachRemaining(headerName ->
                headers.append(headerName).append(": ").append(request.getHeader(headerName)).append("\n")
        );
        return headers.toString();
    }
}
