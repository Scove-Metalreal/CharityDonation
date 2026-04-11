package org.tnphuong.charity.donation.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.tnphuong.charity.donation.dao.CampaignRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.CampaignStatus;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CampaignServiceTests {

    @Mock
    private CampaignRepository campaignRepository;

    @InjectMocks
    private CampaignServiceImpl campaignService;

    private Campaign testCampaign;

    @BeforeEach
    void setUp() {
        testCampaign = new Campaign();
        testCampaign.setId(1);
        testCampaign.setName("Unit Test Campaign");
        testCampaign.setTargetMoney(new BigDecimal("10000000"));
        testCampaign.setCurrentMoney(BigDecimal.ZERO);
        testCampaign.setStartDate(LocalDate.now());
        testCampaign.setEndDate(LocalDate.now().plusMonths(1));
        testCampaign.setStatus(CampaignStatus.IN_PROGRESS.getValue());
    }

    @Test
    void testSaveCampaign_Success() {
        when(campaignRepository.save(any(Campaign.class))).thenReturn(testCampaign);

        Campaign saved = campaignService.saveCampaign(testCampaign);

        assertNotNull(saved);
        verify(campaignRepository, times(1)).save(testCampaign);
    }

    @Test
    void testSaveCampaign_InvalidDates_ThrowsException() {
        testCampaign.setStartDate(LocalDate.now().plusDays(5));
        testCampaign.setEndDate(LocalDate.now()); // End date before start date

        Exception exception = assertThrows(RuntimeException.class, () -> {
            campaignService.saveCampaign(testCampaign);
        });

        assertEquals("Ngày kết thúc phải sau hoặc cùng ngày bắt đầu.", exception.getMessage());
        verify(campaignRepository, never()).save(any());
    }

    @Test
    void testAddCurrentMoney_CompletesCampaign() {
        when(campaignRepository.findById(1)).thenReturn(Optional.of(testCampaign));

        // Donate 10M to reach target 10M
        campaignService.addCurrentMoney(1, new BigDecimal("10000000"));

        assertEquals(new BigDecimal("10000000"), testCampaign.getCurrentMoney());
        assertEquals(CampaignStatus.COMPLETED.getValue(), testCampaign.getStatus());
        verify(campaignRepository, times(1)).save(testCampaign);
    }

    @Test
    void testSubtractCurrentMoney_RevertsToInProgress() {
        testCampaign.setCurrentMoney(new BigDecimal("10000000"));
        testCampaign.setStatus(CampaignStatus.COMPLETED.getValue());
        when(campaignRepository.findById(1)).thenReturn(Optional.of(testCampaign));

        // Subtract 1M, money becomes 9M (< 10M target)
        campaignService.subtractCurrentMoney(1, new BigDecimal("1000000"));

        assertEquals(new BigDecimal("9000000"), testCampaign.getCurrentMoney());
        assertEquals(CampaignStatus.IN_PROGRESS.getValue(), testCampaign.getStatus());
        verify(campaignRepository, times(1)).save(testCampaign);
    }

    @Test
    void testExtendCampaign_Success() {
        LocalDate newDate = LocalDate.now().plusMonths(2);
        when(campaignRepository.findById(1)).thenReturn(Optional.of(testCampaign));
        when(campaignRepository.save(any(Campaign.class))).thenReturn(testCampaign);

        campaignService.extendCampaign(1, newDate);

        assertEquals(newDate, testCampaign.getEndDate());
        verify(campaignRepository, times(1)).save(testCampaign);
    }

    @Test
    void testAutoCloseExpiredCampaign() {
        // Set end date to yesterday
        testCampaign.setEndDate(LocalDate.now().minusDays(1));
        testCampaign.setStatus(CampaignStatus.IN_PROGRESS.getValue());
        
        when(campaignRepository.findAll()).thenReturn(List.of(testCampaign));
        
        // This should trigger checkAndUpdateExpiredCampaigns internally
        campaignService.getAllCampaigns();

        assertEquals(CampaignStatus.CLOSED.getValue(), testCampaign.getStatus());
        verify(campaignRepository, times(1)).saveAll(anyList());
    }
}
