package org.tnphuong.charity.donation.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.dto.DonationDTO;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.DonationStatus;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class DonationServiceImpl implements DonationService {

    private static final Logger logger = LoggerFactory.getLogger(DonationServiceImpl.class);

    @Autowired
    private DonationRepository donationRepository;

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private EmailService emailService;

    @Override
    public List<Donation> getAllDonations() {
        return donationRepository.findAll();
    }

    @Override
    public Optional<Donation> getDonationById(Integer id) {
        return donationRepository.findById(id);
    }

    @Override
    @Transactional
    public Donation saveDonation(Donation donation) {
        if (donation.getAmount() == null || donation.getAmount().compareTo(new java.math.BigDecimal("1000")) < 0) {
            throw new RuntimeException("Số tiền quyên góp tối thiểu là 1,000 VNĐ.");
        }
        return donationRepository.save(donation);
    }

    @Override
    public List<Donation> getDonationsByCampaignId(Integer campaignId) {
        return donationRepository.findByCampaignId(campaignId);
    }

    @Override
    public List<Donation> getDonationsByUserId(Integer userId) {
        return donationRepository.findByUserId(userId);
    }

    @Override
    public List<Donation> getDonationsByUserId(Integer userId, Integer donationStatus, Integer campaignStatus, Sort sort) {
        return donationRepository.findByUserAndFilters(userId, donationStatus, campaignStatus, sort);
    }

    @Override
    @Transactional
    public void confirmDonation(Integer donationId) {
        donationRepository.findById(donationId).ifPresent(donation -> {
            logger.info("Confirming donation ID: {}, Amount: {}", donationId, donation.getAmount());
            donation.setStatus(DonationStatus.CONFIRMED.getValue()); // 1 = STATUS_CONFIRMED
            donationRepository.save(donation);
            
            // Cập nhật số tiền hiện tại của chiến dịch
            campaignService.addCurrentMoney(donation.getCampaign().getId(), donation.getAmount());

            // Send approval email
            try {
                emailService.sendDonationApprovalEmail(
                    donation.getUser().getEmail(), 
                    donation.getUser().getFullName(), 
                    donation.getCampaign().getName(), 
                    donation.getAmount()
                );
            } catch (Exception e) {
                logger.error("Failed to send approval email for donation ID {}: {}", donationId, e.getMessage());
            }
        });
    }

    @Override
    @Transactional
    public void rejectDonation(Integer donationId, String reason) {
        donationRepository.findById(donationId).ifPresent(donation -> {
            logger.info("Rejecting donation ID: {}, Reason: {}", donationId, reason);
            donation.setStatus(DonationStatus.REJECTED.getValue()); // 2 = STATUS_REJECTED
            donationRepository.save(donation);

            // Send rejection email
            try {
                emailService.sendDonationRejectionEmail(
                    donation.getUser().getEmail(), 
                    donation.getUser().getFullName(), 
                    donation.getCampaign().getName(), 
                    donation.getAmount(),
                    reason
                );
            } catch (Exception e) {
                logger.error("Failed to send rejection email for donation ID {}: {}", donationId, e.getMessage());
            }
        });
    }

    @Override
    public List<Donation> getConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.findByCampaignIdAndStatus(campaignId, DonationStatus.CONFIRMED.getValue());
    }

    @Override
    public long countConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.countByCampaignIdAndStatus(campaignId, DonationStatus.CONFIRMED.getValue());
    }

    @Override
    public List<Donation> getTopDonorsByCampaignId(Integer campaignId, int limit) {
        return donationRepository.findTopDonors(campaignId, PageRequest.of(0, limit));
    }

    @Override
    public List<Donation> getRecentDonorsByCampaignId(Integer campaignId, int limit) {
        return donationRepository.findRecentDonors(campaignId, PageRequest.of(0, limit));
    }

    @Override
    public long countDonationsByStatus(Integer status) {
        return donationRepository.countByStatus(status);
    }

    @Override
    public List<Donation> getRecentDonations(int limit) {
        return donationRepository.findTop5ByOrderByCreatedAtDesc();
    }

    @Override
    public List<Donation> getDashboardDonations(int limit) {
        return donationRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    public BigDecimal getTotalDonatedAmount() {
        BigDecimal total = donationRepository.sumTotalDonations();
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    public Page<Donation> searchDonations(String keyword, Integer status, Pageable pageable) {
        return donationRepository.searchDonations(keyword, status, pageable);
    }

    @Override
    public DonationDTO convertToDTO(Donation donation) {
        if (donation == null) return null;
        DonationDTO dto = new DonationDTO();
        dto.setId(donation.getId());
        dto.setUserId(donation.getUser().getId());
        dto.setDonorName(donation.getIsAnonymous() == 1 ? "Nhà hảo tâm ẩn danh" : donation.getUser().getFullName());
        dto.setCampaignId(donation.getCampaign().getId());
        dto.setCampaignName(donation.getCampaign().getName());
        dto.setPaymentMethodName(donation.getPaymentMethod().getMethodName());
        dto.setAmount(donation.getAmount());
        dto.setMessage(donation.getMessage());
        dto.setIsAnonymous(donation.getIsAnonymous());
        dto.setStatus(donation.getStatus());
        dto.setCreatedAt(donation.getCreatedAt());
        return dto;
    }

    @Override
    public java.util.Map<String, Long> getDonationStatsByStatus() {
        List<Object[]> results = donationRepository.countDonationsByStatus();
        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        stats.put("0", 0L);
        stats.put("1", 0L);
        stats.put("2", 0L);
        for (Object[] result : results) {
            if (result[0] != null) {
                stats.put(String.valueOf(result[0]), (Long) result[1]);
            }
        }
        return stats;
    }

    @Override
    public java.util.Map<String, Long> getDonationStatsByPaymentMethod() {
        List<Object[]> results = donationRepository.countDonationsByPaymentMethod();
        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        for (Object[] row : results) {
            stats.put((String) row[0], (Long) row[1]);
        }
        return stats;
    }

    @Override
    public java.math.BigDecimal getTotalDonatedAmountByUserId(Integer userId) {
        java.math.BigDecimal amount = donationRepository.sumDonationsByUserId(userId, org.tnphuong.charity.donation.entity.DonationStatus.CONFIRMED.getValue());
        return amount != null ? amount : java.math.BigDecimal.ZERO;
    }

    @Override
    public long countCampaignsByUserId(Integer userId) {
        return donationRepository.countCampaignsByUserId(userId, org.tnphuong.charity.donation.entity.DonationStatus.CONFIRMED.getValue());
    }
    }

