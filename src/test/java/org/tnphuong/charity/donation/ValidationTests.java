package org.tnphuong.charity.donation;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;

import java.math.BigDecimal;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class ValidationTests {

    private Validator validator;

    @BeforeEach
    void setUp() {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @Test
    void testUser_InvalidEmail_Fails() {
        User user = new User();
        user.setFullName("Test User");
        user.setEmail("invalid-email"); // Wrong format
        user.setPhoneNumber("0987654321");
        user.setPassword("123456");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("email")));
    }

    @Test
    void testUser_NameTooLong_Fails() {
        User user = new User();
        user.setFullName("A".repeat(101)); // Max 100
        user.setEmail("test@test.com");
        user.setPhoneNumber("0987654321");
        user.setPassword("123456");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testDonation_AmountTooSmall_Fails() {
        Donation donation = new Donation();
        donation.setAmount(new BigDecimal("500")); // Min 1000

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("1,000")));
    }

    @Test
    void testUser_ValidData_Passes() {
        User user = new User();
        user.setFullName("Valid User");
        user.setEmail("valid@test.com");
        user.setPhoneNumber("0987654321");
        user.setPassword("123456");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertTrue(violations.isEmpty());
    }
}
