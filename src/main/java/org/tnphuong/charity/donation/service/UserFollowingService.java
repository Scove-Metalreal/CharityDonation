package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.UserFollowing;
import java.util.List;
import java.util.Optional;

public interface UserFollowingService {
    List<UserFollowing> getFollowingByUserId(Integer userId);
    Optional<UserFollowing> getFollowing(Integer userId, Integer campaignId);
    void saveFollowing(UserFollowing following);
    void deleteFollowing(UserFollowing following);
    long countByUserId(Integer userId);
}
