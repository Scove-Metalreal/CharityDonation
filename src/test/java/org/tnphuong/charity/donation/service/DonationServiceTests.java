package org.tnphuong.charity.donation.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.DonationStatus;
import org.tnphuong.charity.donation.entity.User;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class DonationServiceTests {

    @Mock
    private DonationRepository donationRepository;

    @Mock
    private CampaignService campaignService;

    @Mock
    private EmailService emailService;

    @InjectMocks
    private DonationServiceImpl donationService;

    private Donation testDonation;
    private Campaign testCampaign;
    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1);
        testUser.setEmail("donor@test.com");
        testUser.setFullName("Test Donor");

        testCampaign = new Campaign();
        testCampaign.setId(1);
        testCampaign.setName("Test Campaign");
        testCampaign.setCurrentMoney(BigDecimal.ZERO);

        testDonation = new Donation();
        testDonation.setId(1);
        testDonation.setUser(testUser);
        testDonation.setCampaign(testCampaign);
        testDonation.setStatus(DonationStatus.PENDING.getValue());
    }

    @Test
    void testSaveDonation_Success() {
        testDonation.setAmount(new BigDecimal("5000"));
        when(donationRepository.save(any(Donation.class))).thenReturn(testDonation);

        Donation saved = donationService.saveDonation(testDonation);

        assertNotNull(saved);
        assertEquals(new BigDecimal("5000"), saved.getAmount());
        verify(donationRepository, times(1)).save(testDonation);
    }

    @Test
    void testSaveDonation_TooSmallAmount_ThrowsException() {
        testDonation.setAmount(new BigDecimal("500")); // < 1000

        Exception exception = assertThrows(RuntimeException.class, () -> {
            donationService.saveDonation(testDonation);
        });

        assertEquals("Số tiền quyên góp tối thiểu là 1,000 VNĐ.", exception.getMessage());
        verify(donationRepository, never()).save(any());
    }

    @Test
    void testConfirmDonation_Success() {
        testDonation.setAmount(new BigDecimal("100000"));
        when(donationRepository.findById(1)).thenReturn(Optional.of(testDonation));

        donationService.confirmDonation(1);

        assertEquals(DonationStatus.CONFIRMED.getValue(), testDonation.getStatus());
        verify(campaignService, times(1)).addCurrentMoney(eq(1), eq(new BigDecimal("100000")));
        verify(donationRepository, times(1)).save(testDonation);
        verify(emailService, times(1)).sendDonationApprovalEmail(any(), any(), any(), any());
    }

    @Test
    void testRejectDonation_Success() {
        when(donationRepository.findById(1)).thenReturn(Optional.of(testDonation));

        donationService.rejectDonation(1, "Thông tin sai");

        assertEquals(DonationStatus.REJECTED.getValue(), testDonation.getStatus());
        verify(campaignService, never()).addCurrentMoney(any(), any());
        verify(donationRepository, times(1)).save(testDonation);
        verify(emailService, times(1)).sendDonationRejectionEmail(any(), any(), any(), any(), eq("Thông tin sai"));
    }
}
