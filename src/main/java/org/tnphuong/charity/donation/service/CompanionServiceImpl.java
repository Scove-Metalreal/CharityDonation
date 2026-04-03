package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.CompanionRepository;
import org.tnphuong.charity.donation.entity.Companion;
import java.util.List;

@Service
public class CompanionServiceImpl implements CompanionService {

    @Autowired
    private CompanionRepository companionRepository;

    @Override
    public List<Companion> getAllCompanions() {
        return companionRepository.findAll();
    }

    @Override
    public List<Companion> getAllCompanionsByIds(List<Integer> ids) {
        return companionRepository.findAllById(ids);
    }

    @Override
    public java.util.Optional<Companion> getCompanionById(Integer id) {
        return companionRepository.findByIdWithCampaigns(id);
    }
}
