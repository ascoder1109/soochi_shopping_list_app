package com.ascoder1109.soochi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;


@SpringBootApplication
public class SoochiApplication {

	public static void main(String[] args) {
		SpringApplication.run(SoochiApplication.class, args);
	}

}
