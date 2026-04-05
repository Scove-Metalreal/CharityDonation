package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.UserFollowingRepository;
import org.tnphuong.charity.donation.entity.UserFollowing;
import java.util.List;
import java.util.Optional;

@Service
public class UserFollowingServiceImpl implements UserFollowingService {

    @Autowired
    private UserFollowingRepository userFollowingRepository;

    @Override
    public List<UserFollowing> getFollowingByUserId(Integer userId) {
        return userFollowingRepository.findByUserId(userId);
    }

    @Override
    public Optional<UserFollowing> getFollowing(Integer userId, Integer campaignId) {
        return userFollowingRepository.findByUserIdAndCampaignId(userId, campaignId);
    }

    @Override
    @Transactional
    public void saveFollowing(UserFollowing following) {
        userFollowingRepository.save(following);
    }

    @Override
    @Transactional
    public void deleteFollowing(UserFollowing following) {
        userFollowingRepository.delete(following);
    }

    @Override
    public long countByUserId(Integer userId) {
        return userFollowingRepository.countByUserId(userId);
    }
}
