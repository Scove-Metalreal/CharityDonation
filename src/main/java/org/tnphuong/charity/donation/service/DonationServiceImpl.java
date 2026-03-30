package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
    @Transactional
    public void confirmDonation(Integer donationId) {
        Optional<Donation> donationOpt = donationRepository.findById(donationId);
        if (donationOpt.isPresent()) {
            Donation donation = donationOpt.get();
            if (donation.getStatus() == Donation.STATUS_PENDING) {
                donation.setStatus(Donation.STATUS_CONFIRMED);
                donationRepository.save(donation);
                
                // Update Campaign current money
                campaignService.addCurrentMoney(donation.getCampaign().getId(), donation.getAmount());
            }
        }
    }

    @Override
    public void rejectDonation(Integer donationId) {
        Optional<Donation> donationOpt = donationRepository.findById(donationId);
        if (donationOpt.isPresent()) {
            Donation donation = donationOpt.get();
            if (donation.getStatus() == Donation.STATUS_PENDING) {
                donation.setStatus(Donation.STATUS_REJECTED);
                donationRepository.save(donation);
            }
        }
    }

    @Override
    public List<Donation> getConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.findByCampaignIdAndStatus(campaignId, Donation.STATUS_CONFIRMED);
    }

    @Override
    public long countConfirmedDonationsByCampaignId(Integer campaignId) {
        return donationRepository.countByCampaignIdAndStatus(campaignId, Donation.STATUS_CONFIRMED);
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
