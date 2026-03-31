package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.UserFollowing;
import java.util.List;
import java.util.Optional;

public interface UserFollowingRepository extends JpaRepository<UserFollowing, Integer> {
    List<UserFollowing> findByUserId(Integer userId);
    Optional<UserFollowing> findByUserIdAndCampaignId(Integer userId, Integer campaignId);
}
