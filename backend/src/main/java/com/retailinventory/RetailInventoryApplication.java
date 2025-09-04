package com.retailinventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class RetailInventoryApplication {

    public static void main(String[] args) {
        SpringApplication.run(RetailInventoryApplication.class, args);
    }
}
