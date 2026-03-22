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
        if (campaign.getId() == null) {
            // New campaign initialization
            if (campaign.getStatus() == null) {
                campaign.setStatus(0); // 0: Mới
            }
            if (campaign.getCurrentMoney() == null) {
                campaign.setCurrentMoney(BigDecimal.ZERO);
            }
            if (campaign.getCreatedAt() == null) {
                campaign.setCreatedAt(java.time.LocalDateTime.now());
            }
        } else {
            // Update: Block if status is Closed (3)
            Optional<Campaign> existing = campaignRepository.findById(campaign.getId());
            if (existing.isPresent() && existing.get().getStatus() == 3) { // 3: Đã đóng
                throw new RuntimeException("Không thể cập nhật chiến dịch đã đóng.");
            }
        }
        return campaignRepository.save(campaign);
    }

    @Override
    public void deleteCampaign(Integer id) {
        // Chỉ cho phép xóa khi trạng thái là Mới tạo (0)
        Optional<Campaign> campaign = campaignRepository.findById(id);
        if (campaign.isPresent()) {
            if (campaign.get().getStatus() == 0) {
                campaignRepository.deleteById(id);
            } else {
                throw new RuntimeException("Chỉ có thể xóa chiến dịch ở trạng thái Mới tạo.");
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
            
            // Nếu đang ở trạng thái Mới tạo (0), tự động chuyển sang Đang quyên góp (1) khi có tiền
            if (campaign.getStatus() == 0) {
                campaign.setStatus(1);
            }

            // Tự động kết thúc nếu đủ tiền (trừ khi đã đóng)
            if (campaign.getStatus() == 1 && campaign.getCurrentMoney().compareTo(campaign.getTargetMoney()) >= 0) {
                campaign.setStatus(2); // Kết thúc quyên góp
            }
            campaignRepository.save(campaign);
        }
    }

    @Override
    public void extendCampaign(Integer campaignId, java.time.LocalDate newEndDate) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            campaign.setEndDate(newEndDate);
            // If it was ended, put it back to in-progress
            if (campaign.getStatus() == Campaign.STATUS_ENDED) {
                campaign.setStatus(Campaign.STATUS_IN_PROGRESS);
            }
            campaignRepository.save(campaign);
        });
    }
}
