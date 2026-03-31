package org.tnphuong.charity.donation.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.CampaignRepository;
import org.tnphuong.charity.donation.dto.CampaignDTO;
import org.tnphuong.charity.donation.dto.CompanionDTO;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.CampaignStatus;
import org.tnphuong.charity.donation.entity.Companion;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CampaignServiceImpl implements CampaignService {

    private static final Logger logger = LoggerFactory.getLogger(CampaignServiceImpl.class);

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    @Lazy
    private DonationService donationService;

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
    @Transactional
    public Campaign saveCampaign(Campaign campaign) {
        if (campaign.getId() != null) {
            Campaign currentInDb = campaignRepository.findById(campaign.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy chiến dịch!"));
            
            // Allow status update even if it was closed, but prevent data modification if it remains closed
            if (currentInDb.getStatus() == CampaignStatus.CLOSED.getValue() && campaign.getStatus() == CampaignStatus.CLOSED.getValue()) {
                // If it was closed and we are not changing the status, prevent other changes
                // You might want to allow status change FROM closed TO something else by admin
                logger.warn("Attempt to modify data of closed campaign ID: {}", campaign.getId());
                throw new RuntimeException("Chiến dịch đã đóng, không thể thay đổi thông tin.");
            }
            logger.debug("Updating campaign ID: {}", campaign.getId());
        } else {
            if (campaign.getStatus() == null) campaign.setStatus(CampaignStatus.NEW.getValue()); // 0 = NEW
            if (campaign.getCurrentMoney() == null) campaign.setCurrentMoney(BigDecimal.ZERO);
            if (campaign.getCreatedAt() == null) campaign.setCreatedAt(java.time.LocalDateTime.now());
            logger.info("Creating new campaign with code: {}", campaign.getCode());
        }
        return campaignRepository.save(campaign);
    }

    @Override
    @Transactional
    public void deleteCampaign(Integer id) {
        campaignRepository.findById(id).ifPresent(campaign -> {
            if (campaign.getStatus() == CampaignStatus.NEW.getValue()) { // 0 = NEW
                logger.info("Deleting campaign ID: {}, Code: {}", id, campaign.getCode());
                campaignRepository.deleteById(id);
            } else {
                logger.warn("Failed deletion attempt for active campaign ID: {}", id);
                throw new RuntimeException("Chỉ có thể xóa chiến dịch ở trạng thái Mới tạo.");
            }
        });
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
    @Transactional
    public void addCurrentMoney(Integer campaignId, BigDecimal amount) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            BigDecimal current = campaign.getCurrentMoney() != null ? campaign.getCurrentMoney() : BigDecimal.ZERO;
            campaign.setCurrentMoney(current.add(amount));
            
            if (campaign.getStatus() == CampaignStatus.NEW.getValue()) { // 0 = NEW
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue()); // 1 = IN_PROGRESS
            }

            if (campaign.getStatus() == CampaignStatus.IN_PROGRESS.getValue() && campaign.getCurrentMoney().compareTo(campaign.getTargetMoney()) >= 0) {
                logger.info("Campaign ID: {} reached target. Setting status to COMPLETED.", campaignId);
                campaign.setStatus(CampaignStatus.COMPLETED.getValue()); // 2 = COMPLETED
            }
            campaignRepository.save(campaign);
            logger.debug("Added {} to campaign ID: {}. New total: {}", amount, campaignId, campaign.getCurrentMoney());
        });
    }

    @Override
    @Transactional
    public void subtractCurrentMoney(Integer campaignId, BigDecimal amount) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            BigDecimal current = campaign.getCurrentMoney() != null ? campaign.getCurrentMoney() : BigDecimal.ZERO;
            campaign.setCurrentMoney(current.subtract(amount));
            
            if (campaign.getStatus() == CampaignStatus.COMPLETED.getValue() && campaign.getCurrentMoney().compareTo(campaign.getTargetMoney()) < 0) {
                logger.info("Campaign ID: {} fell below target. Reverting status to IN_PROGRESS.", campaignId);
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue()); // 1 = IN_PROGRESS
            }
            campaignRepository.save(campaign);
            logger.debug("Subtracted {} from campaign ID: {}. New total: {}", amount, campaignId, campaign.getCurrentMoney());
        });
    }

    @Override
    @Transactional
    public void extendCampaign(Integer campaignId, java.time.LocalDate newEndDate) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            logger.info("Extending campaign ID: {} to {}", campaignId, newEndDate);
            campaign.setEndDate(newEndDate);
            if (campaign.getStatus() == CampaignStatus.COMPLETED.getValue()) { // 2 = COMPLETED
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue()); // 1 = IN_PROGRESS
            }
            campaignRepository.save(campaign);
        });
    }

    @Override
    public long countCampaignsByStatus(Integer status) {
        return campaignRepository.countByStatus(status);
    }

    @Override
    public boolean existsByCode(String code) {
        return campaignRepository.existsByCode(code);
    }

    @Override
    public CampaignDTO convertToDTO(Campaign campaign) {
        if (campaign == null) return null;
        CampaignDTO dto = new CampaignDTO();
        dto.setId(campaign.getId());
        dto.setCode(campaign.getCode());
        dto.setName(campaign.getName());
        dto.setBackground(campaign.getBackground());
        dto.setContent(campaign.getContent());
        dto.setImageUrl(campaign.getImageUrl());
        dto.setGalleryUrls(campaign.getGalleryUrls());
        dto.setStartDate(campaign.getStartDate());
        dto.setEndDate(campaign.getEndDate());
        dto.setTargetMoney(campaign.getTargetMoney());
        dto.setCurrentMoney(campaign.getCurrentMoney());
        dto.setBeneficiaryPhone(campaign.getBeneficiaryPhone());
        dto.setStatus(campaign.getStatus());
        dto.setCreatedAt(campaign.getCreatedAt());
        
        dto.setDonationCount((int) donationService.countConfirmedDonationsByCampaignId(campaign.getId()));
        if (campaign.getEndDate() != null) {
            long days = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.now(), campaign.getEndDate());
            dto.setDaysRemaining(days > 0 ? days : 0);
        }

        if (campaign.getCompanions() != null) {
            dto.setCompanions(campaign.getCompanions().stream()
                    .map(this::convertCompanionToDTO)
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }

    private CompanionDTO convertCompanionToDTO(Companion companion) {
        if (companion == null) return null;
        CompanionDTO dto = new CompanionDTO();
        dto.setId(companion.getId());
        dto.setName(companion.getName());
        dto.setLogoUrl(companion.getLogoUrl());
        dto.setDescription(companion.getDescription());
        return dto;
    }
}
