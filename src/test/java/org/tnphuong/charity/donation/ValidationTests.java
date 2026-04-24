package org.tnphuong.charity.donation;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.PaymentMethod;

import java.math.BigDecimal;
import java.time.LocalDate;
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
    void testUser_ValidData_Passes() {
        User user = new User();
        user.setFullName("Nguyễn Văn A");
        user.setEmail("test@example.com");
        user.setPhoneNumber("0912345678");
        user.setPassword("password123");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testUser_FullNameBlank_Fails() {
        User user = new User();
        user.setFullName("   "); // Blank
        user.setEmail("test@example.com");
        user.setPhoneNumber("0912345678");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("không được để trống")));
    }

    @Test
    void testUser_FullNameTooLong_Fails() {
        User user = new User();
        user.setFullName("A".repeat(101)); 
        user.setEmail("test@example.com");
        user.setPhoneNumber("0912345678");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("vượt quá 100 ký tự")));
    }

    @Test
    void testUser_InvalidEmailFormat_Fails() {
        User user = new User();
        user.setFullName("User Test");
        user.setEmail("wrong-email@com"); // Missing dot or invalid domain
        user.setPhoneNumber("0912345678");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        // Sửa lỗi chuỗi: message chứa "đúng định dạng"
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("định dạng")));
    }

    @Test
    void testUser_EmailTooLong_Fails() {
        User user = new User();
        user.setFullName("User Test");
        user.setEmail("a".repeat(95) + "@test.com"); // > 100
        user.setPhoneNumber("0912345678");

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testUser_PhoneNumberBlank_Fails() {
        User user = new User();
        user.setFullName("User Test");
        user.setEmail("test@example.com");
        user.setPhoneNumber(""); // Blank

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("không được để trống")));
    }

    @Test
    void testUser_PhoneNumberInvalidFormat_Fails() {
        User user = new User();
        user.setFullName("User Test");
        user.setEmail("test@example.com");
        user.setPhoneNumber("12345678"); // Too short/Invalid VN format

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("định dạng Việt Nam")));
    }

    @Test
    void testUser_PasswordTooShort_Fails() {
        User user = new User();
        user.setFullName("User Test");
        user.setEmail("test@example.com");
        user.setPhoneNumber("0912345678");
        user.setPassword("12345"); // < 6

        Set<ConstraintViolation<User>> violations = validator.validate(user);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("6 đến 100 ký tự")));
    }

    @Test
    void testCampaign_ValidData_Passes() {
        Campaign campaign = new Campaign();
        campaign.setCode("CMP001");
        campaign.setName("Chiến dịch 01");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(10));
        campaign.setTargetMoney(new BigDecimal("10000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testCampaign_CodeBlank_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode(""); 
        campaign.setName("Campaign Name");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("5000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("code")));
    }

    @Test
    void testCampaign_CodeTooLong_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("A".repeat(51)); 
        campaign.setName("Campaign Name");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("5000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testCampaign_NameBlank_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CODE");
        campaign.setName("   ");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("5000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testCampaign_StartDateNull_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CODE");
        campaign.setName("Name");
        campaign.setStartDate(null);
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("5000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("ngày bắt đầu")));
    }

    @Test
    void testCampaign_EndDateNull_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CODE");
        campaign.setName("Name");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(null);
        campaign.setTargetMoney(new BigDecimal("5000000"));

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("ngày kết thúc")));
    }

    @Test
    void testCampaign_EndDateBeforeStartDate_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CMP_LOGIC");
        campaign.setName("Test Logic");
        campaign.setStartDate(LocalDate.now().plusDays(10));
        campaign.setEndDate(LocalDate.now()); // Error

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("phải sau hoặc cùng ngày bắt đầu")));
    }

    @Test
    void testCampaign_TargetMoneyTooSmall_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CMP_MONEY");
        campaign.setName("Test Money");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("999999")); // Min 1,000,000

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testCampaign_CurrentMoneyNegative_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CMP_MONEY_2");
        campaign.setName("Test Money");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("5000000"));
        campaign.setCurrentMoney(new BigDecimal("-1")); // No negative

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testCampaign_BeneficiaryPhoneInvalid_Fails() {
        Campaign campaign = new Campaign();
        campaign.setCode("CMP_PHONE");
        campaign.setName("Test Phone");
        campaign.setStartDate(LocalDate.now());
        campaign.setEndDate(LocalDate.now().plusDays(1));
        campaign.setTargetMoney(new BigDecimal("2000000"));
        campaign.setBeneficiaryPhone("0912.333.444"); // Sai định dạng (có dấu chấm)

        Set<ConstraintViolation<Campaign>> violations = validator.validate(campaign);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("người thụ hưởng")));
    }


    @Test
    void testDonation_ValidData_Passes() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setCampaign(new Campaign());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(new BigDecimal("1000"));

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testDonation_UserNull_Fails() {
        Donation donation = new Donation();
        donation.setCampaign(new Campaign());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(new BigDecimal("50000"));

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("user")));
    }

    @Test
    void testDonation_CampaignNull_Fails() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(new BigDecimal("50000"));

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("campaign")));
    }

    @Test
    void testDonation_PaymentMethodNull_Fails() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setCampaign(new Campaign());
        donation.setAmount(new BigDecimal("50000"));

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("paymentMethod")));
    }

    @Test
    void testDonation_AmountNull_Fails() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setCampaign(new Campaign());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(null);

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testDonation_AmountTooSmall_Fails() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setCampaign(new Campaign());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(new BigDecimal("999")); // Min 1000

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testDonation_MessageTooLong_Fails() {
        Donation donation = new Donation();
        donation.setUser(new User());
        donation.setCampaign(new Campaign());
        donation.setPaymentMethod(new PaymentMethod());
        donation.setAmount(new BigDecimal("50000"));
        donation.setMessage("A".repeat(501));

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getMessage().contains("500 ký tự")));
    }

    @Test
    void testDonation_AllRequiredMissing_Fails() {
        Donation donation = new Donation();
        // Nothing set

        Set<ConstraintViolation<Donation>> violations = validator.validate(donation);
        assertFalse(violations.isEmpty());
        assertTrue(violations.size() >= 4); // user, campaign, paymentMethod, amount
    }
}
