package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.CampaignRepository;
import org.tnphuong.charity.donation.entity.Campaign;
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
    public Optional<Campaign> getCampaignById(Integer id) {
        return campaignRepository.findById(id);
    }

    @Override
    public Campaign saveCampaign(Campaign campaign) {
        return campaignRepository.save(campaign);
    }

    @Override
    public void deleteCampaign(Integer id) {
        campaignRepository.deleteById(id);
    }

    @Override
    public Optional<Campaign> getCampaignByCode(String code) {
        return campaignRepository.findByCode(code);
    }
}
