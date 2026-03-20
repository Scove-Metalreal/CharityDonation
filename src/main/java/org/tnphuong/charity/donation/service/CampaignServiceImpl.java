package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.CampaignRepository;
import org.tnphuong.charity.donation.entity.Campaign;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class CampaignServiceImpl implements CampaignService {

    @Autowired
    private CampaignRepository campaignRepository;

    @Override
    public List<Campaign> getAllCampaigns() {
        return campaignRepository.findAll();
    }

    @Override
    public Page<Campaign> getAllCampaigns(Pageable pageable) {
        return campaignRepository.findAll(pageable);
    }

    @Override
    public Optional<Campaign> getCampaignById(Integer id) {
        return campaignRepository.findById(id);
    }

    @Override
    public Campaign saveCampaign(Campaign campaign) {
        // Business Rule: Block updates if status is Closed (3)
        if (campaign.getId() != null) {
            Optional<Campaign> existing = campaignRepository.findById(campaign.getId());
            if (existing.isPresent() && existing.get().getStatus() == Campaign.STATUS_CLOSED) {
                throw new RuntimeException("Cannot update a closed campaign.");
            }
        }
        return campaignRepository.save(campaign);
    }

    @Override
    public void deleteCampaign(Integer id) {
        // Business Rule: Only allow deletion if status is New (0)
        Optional<Campaign> campaign = campaignRepository.findById(id);
        if (campaign.isPresent()) {
            if (campaign.get().getStatus() == Campaign.STATUS_NEW) {
                campaignRepository.deleteById(id);
            } else {
                throw new RuntimeException("Only new campaigns can be deleted.");
            }
        }
    }

    @Override
    public Optional<Campaign> getCampaignByCode(String code) {
        return campaignRepository.findByCode(code);
    }

    @Override
    public Page<Campaign> searchCampaigns(Integer status, String phone, String code, Pageable pageable) {
        String cleanPhone = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null;
        String cleanCode = (code != null && !code.trim().isEmpty()) ? code.trim() : null;
        return campaignRepository.searchCampaigns(status, cleanPhone, cleanCode, pageable);
    }

    @Override
    public Page<Campaign> getCampaignsByStatus(Integer status, Pageable pageable) {
        return campaignRepository.findByStatus(status, pageable);
    }

    @Override
    public void addCurrentMoney(Integer campaignId, BigDecimal amount) {
        Optional<Campaign> campaignOpt = campaignRepository.findById(campaignId);
        if (campaignOpt.isPresent()) {
            Campaign campaign = campaignOpt.get();
            BigDecimal current = campaign.getCurrentMoney() != null ? campaign.getCurrentMoney() : BigDecimal.ZERO;
            campaign.setCurrentMoney(current.add(amount));
            campaignRepository.save(campaign);
        }
    }
}
