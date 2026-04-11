package org.tnphuong.charity.donation.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import java.math.BigDecimal;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class EmailServiceTests {

    @Mock
    private JavaMailSender mailSender;

    @InjectMocks
    private EmailServiceImpl emailService;

    @Test
    void testSendDonationSubmissionEmail() {
        emailService.sendDonationSubmissionEmail("user@test.com", "User Name", "Campaign A", new BigDecimal("50000"), "QG123");
        
        verify(mailSender, times(1)).send(any(SimpleMailMessage.class));
    }

    @Test
    void testSendDonationApprovalEmail() {
        emailService.sendDonationApprovalEmail("user@test.com", "User Name", "Campaign A", new BigDecimal("50000"));
        
        verify(mailSender, times(1)).send(any(SimpleMailMessage.class));
    }

    @Test
    void testSendDonationRejectionEmail() {
        emailService.sendDonationRejectionEmail("user@test.com", "User Name", "Campaign A", new BigDecimal("50000"), "Invalid proof");
        
        verify(mailSender, times(1)).send(any(SimpleMailMessage.class));
    }

    @Test
    void testSendOTPEmail() {
        emailService.sendOTPEmail("user@test.com", "User Name", "123456");
        
        verify(mailSender, times(1)).send(any(SimpleMailMessage.class));
    }
}
