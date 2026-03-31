package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.entity.Donation;

import java.util.List;
import java.util.Optional;

@Service
public class DonationServiceImpl implements DonationService {

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
    public Donation saveDonation(Donation donation) {
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
    public void confirmDonation(Integer donationId) {
        donationRepository.findById(donationId).ifPresent(donation -> {
            donation.setStatus(1); // 1 = STATUS_CONFIRMED
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
                System.err.println("Failed to send approval email: " + e.getMessage());
            }
        });
    }

    @Override
    public void rejectDonation(Integer donationId, String reason) {
        donationRepository.findById(donationId).ifPresent(donation -> {
            donation.setStatus(2); // 2 = STATUS_REJECTED
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
                System.err.println("Failed to send rejection email: " + e.getMessage());
            }
        });
    }

    @Override
    public List<Donation> getConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.findByCampaignIdAndStatus(campaignId, 1);
    }

    @Override
    public long countConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.countByCampaignIdAndStatus(campaignId, 1);
    }

    @Override
    public List<Donation> getTopDonorsByCampaignId(Integer campaignId, int limit) {
        return donationRepository.findTopDonors(campaignId, PageRequest.of(0, limit));
    }

    @Override
    public List<Donation> getRecentDonorsByCampaignId(Integer campaignId, int limit) {
        return donationRepository.findRecentDonors(campaignId, PageRequest.of(0, limit));
    }
}
