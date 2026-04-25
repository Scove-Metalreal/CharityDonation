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
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class CampaignServiceImpl implements CampaignService {

    private static final Logger logger = LoggerFactory.getLogger(CampaignServiceImpl.class);

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    @Lazy
    private DonationService donationService;

    private void checkAndUpdateExpiredCampaigns() {
        LocalDate today = LocalDate.now();
        List<Campaign> activeCampaigns = campaignRepository.findAll().stream()
                .filter(c -> (c.getStatus() == CampaignStatus.NEW.getValue() || c.getStatus() == CampaignStatus.IN_PROGRESS.getValue())
                        && c.getEndDate() != null && c.getEndDate().isBefore(today))
                .toList();

        if (!activeCampaigns.isEmpty()) {
            activeCampaigns.forEach(c -> {
                c.setStatus(CampaignStatus.CLOSED.getValue());
                logger.info("Auto-closed expired campaign: ID={}, Code={}", c.getId(), c.getCode());
            });
            campaignRepository.saveAll(activeCampaigns);
        }
    }

    @Override
    public List<Campaign> getAllCampaigns() {
        checkAndUpdateExpiredCampaigns();
        return campaignRepository.findAll();
    }

    @Override
    public Page<Campaign> getAllCampaigns(Pageable pageable) {
        checkAndUpdateExpiredCampaigns();
        return campaignRepository.findAll(pageable);
    }

    @Override
    public Optional<Campaign> getCampaignById(Integer id) {
        checkAndUpdateExpiredCampaigns();
        return campaignRepository.findById(id);
    }

    @Override
    @Transactional
    public Campaign saveCampaign(Campaign campaign) {
        if (campaign.getStartDate() != null && campaign.getEndDate() != null) {
            if (campaign.getEndDate().isBefore(campaign.getStartDate())) {
                throw new RuntimeException("Ngày kết thúc phải sau hoặc cùng ngày bắt đầu.");
            }
        }

        // Kiểm tra trùng mã chiến dịch
        if (campaign.getCode() != null) {
            Optional<Campaign> existing = campaignRepository.findByCode(campaign.getCode());
            if (existing.isPresent()) {
                // Nếu tạo mới, hoặc cập nhật nhưng trùng mã với một chiến dịch KHÁC
                if (campaign.getId() == null || !existing.get().getId().equals(campaign.getId())) {
                    throw new RuntimeException("Mã chiến dịch '" + campaign.getCode() + "' đã tồn tại trong hệ thống. Vui lòng dùng mã khác.");
                }
            }
        }
        
        return campaignRepository.save(campaign);
    }

    @Override
    @Transactional
    public void deleteCampaign(Integer id) {
        campaignRepository.deleteById(id);
    }

    @Override
    public Optional<Campaign> getCampaignByCode(String code) {
        return campaignRepository.findByCode(code);
    }

    @Override
    public Page<Campaign> searchCampaigns(Integer status, String phone, String code, Pageable pageable) {
        checkAndUpdateExpiredCampaigns();
        return campaignRepository.searchCampaigns(status, phone, code, pageable);
    }

    @Override
    public Page<Campaign> getCampaignsByStatus(Integer status, Pageable pageable) {
        checkAndUpdateExpiredCampaigns();
        return campaignRepository.findByStatus(status, pageable);
    }

    @Override
    @Transactional
    public void addCurrentMoney(Integer campaignId, BigDecimal amount) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            BigDecimal current = campaign.getCurrentMoney() != null ? campaign.getCurrentMoney() : BigDecimal.ZERO;
            campaign.setCurrentMoney(current.add(amount));
            
            if (campaign.getStatus() == CampaignStatus.NEW.getValue()) {
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue());
            }

            if (campaign.getStatus() == CampaignStatus.IN_PROGRESS.getValue() && campaign.getCurrentMoney().compareTo(campaign.getTargetMoney()) >= 0) {
                campaign.setStatus(CampaignStatus.COMPLETED.getValue());
            }
            campaignRepository.save(campaign);
        });
    }

    @Override
    @Transactional
    public void subtractCurrentMoney(Integer campaignId, BigDecimal amount) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            BigDecimal current = campaign.getCurrentMoney() != null ? campaign.getCurrentMoney() : BigDecimal.ZERO;
            campaign.setCurrentMoney(current.subtract(amount));
            
            if (campaign.getStatus() == CampaignStatus.COMPLETED.getValue() && campaign.getCurrentMoney().compareTo(campaign.getTargetMoney()) < 0) {
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue());
            }
            campaignRepository.save(campaign);
        });
    }

    @Override
    @Transactional
    public void extendCampaign(Integer campaignId, java.time.LocalDate newEndDate) {
        campaignRepository.findById(campaignId).ifPresent(campaign -> {
            campaign.setEndDate(newEndDate);
            if (campaign.getStatus() == CampaignStatus.COMPLETED.getValue() || campaign.getStatus() == CampaignStatus.CLOSED.getValue()) {
                campaign.setStatus(CampaignStatus.IN_PROGRESS.getValue());
            }
            saveCampaign(campaign); // Use saveCampaign for validation
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
        
        // Render nội dung thông minh: Tự động biến link ảnh thành thẻ <img>
        String content = campaign.getContent();
        if (content != null) {
            // Regex tìm các đường dẫn bắt đầu bằng /uploads/ hoặc http và kết thúc bằng đuôi ảnh
            String imageRegex = "(?:https?://[^\\s\"'<>]+|/uploads/[^\\s\"'<>]+)\\.(?:jpg|jpeg|png|gif|webp)";
            content = content.replaceAll("(?i)(" + imageRegex + ")", 
                "<div class='my-4 text-center'><img src='$1' class='img-fluid rounded-4 shadow-sm border' style='max-height:600px; object-fit:contain;'></div>");
        }
        dto.setContent(content);
        
        dto.setImageUrl(campaign.getImageUrl());
        dto.setGalleryUrls(campaign.getGalleryUrls());
        dto.setStartDate(campaign.getStartDate());
        dto.setEndDate(campaign.getEndDate());
        dto.setTargetMoney(campaign.getTargetMoney());
        dto.setCurrentMoney(campaign.getCurrentMoney());
        dto.setBeneficiaryPhone(campaign.getBeneficiaryPhone());
        dto.setStatus(campaign.getStatus());
        dto.setCreatedAt(campaign.getCreatedAt());
        
        if (campaign.getCompanions() != null) {
            dto.setCompanions(campaign.getCompanions().stream().map(this::convertToCompanionDTO).toList());
        }
        
        return dto;
    }

    private CompanionDTO convertToCompanionDTO(Companion companion) {
        if (companion == null) return null;
        CompanionDTO dto = new CompanionDTO();
        dto.setId(companion.getId());
        dto.setName(companion.getName());
        dto.setLogoUrl(companion.getLogoUrl());
        dto.setDescription(companion.getDescription());
        return dto;
    }
}
