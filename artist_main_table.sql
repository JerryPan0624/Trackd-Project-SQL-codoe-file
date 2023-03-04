SELECT up.user_id AS user_id,
 		user_level_song_info.user_id AS artist_id,
	   up.name,
	   up.gender,
	   up.date_of_birth,
	   country_id.country_id,
	   country.name AS country_name,
	   up.allow_collaboration,
	   up.chipin_account_type,
	   up.show_skills,	   
	   country.country_code,
	   country.continent_id,
	   country.currency_code,
	   county.name AS rg_county_name,	   
	   up.timestamp,
	   up.user_type,
	   up.account_type_id,
	   acctp.name AS account_type_name,
	   user_likes.num_user_likes,
	   num_user_likes_given.num_profile_likes_given,
	   upc.profile_comments_num,
	   upc_given.num_profile_comments_given,
	   notf.song_likes_given AS notf_song_likes_given,
	   notf_received.song_likes_received AS notf_song_likes_received,
	   notf.chipin_setup_given AS notf_chipin_setup_given,
	   notf_received.chipin_setup_received AS notf_chipin_setup_received,
	   notf.collaboration_given AS notf_collaboration_given,
	   notf_received.collaboration_received AS notf_collaboration_received,
	   notf.comments_given AS notf_comments_given,
	   notf_received.comments_received AS notf_comments_received,
	   notf.added_playlist_given AS notf_added_playlist_given,
	   notf_received.added_playlist_received AS notf_added_playlist_received,
	   notf.reportfiled_given AS notf_reportfiled_given,
	   notf_received.reportfiled_received AS notf_reportfiled_received,
	   notf.stripe_kyc_given AS notf_stripe_kyc_given,
	   notf_received.stripe_kyc_received AS notf_stripe_kyc_received,
	   notf.chipin_payment_given AS notf_chipin_payment_given,
	   notf_received.chipin_payment_received AS notf_chipin_payment_received,
	   notf.chipin_given AS notf_chipin_given,
	   notf_received.chipin_received AS notf_chipin_received,
	   notf.directmessage_given AS notf_directmessage_given,
	   notf_received.directmessage_received AS notf_directmessage_received,
	   notf.following AS notf_following,
	   notf_received.followers_received AS notf_follower,
	   notf.reportadmin_given AS notf_reportadmin_given,
	   notf_received.reportadmin_received AS notf_reportadmin_received,
	   notf.reportreceived_given AS not_reportreceived_given,
	   notf_received.reportreceived_received AS not_reportreceived_received,
	   notf.chipin_account_given AS notf_chipin_account_given,
	   notf_received.chipin_account_received AS notf_chipin_account_received,
	   au.is_superuser,
	   au.is_staff,
	   au.is_active,
	   chip_paid.chipin_amount_paid,
	   chip_received.chipin_amount_received,
	   pv.unique_profile_view_count,
	   pv.total_profile_view_count,
	   pv_given.profile_view_given,
	   num_songs_played.num_songs_played,
	   num_of_collaboration_accepted.num_of_collaboration_accepted,
	   dv.device_type,
	   pf. platform,
	   user_level_song_info.total_num_likes,
	   user_level_song_info.total_num_plays,
	   user_level_song_info.total_num_retracks,
	   user_level_song_info.total_downloads_count,
	   user_level_song_info.total_retraks_count,
	   user_level_song_info.total_num_of_collaborators,
	   user_level_song_info.total_num_comments
  FROM author.users_userprofile AS up
FULL OUTER JOIN author.users_accounttype AS acctp
    ON acctp.id = up.account_type_id
FULL OUTER JOIN (SELECT max_country_appear.user_id,
						   max_country_appear.country_count,
						   num_country_id.country_id
				 FROM (SELECT  country_count.user_id, 
		      			  MAX(num_country_appear) AS country_count
						  FROM (SELECT user_id,
									   country_id,
									   COUNT(country_id) AS num_country_appear
								  FROM author.users_userlocation
								 GROUP BY user_id, country_id
								 ORDER BY user_id) AS country_count
								GROUP BY user_id) AS max_country_appear		
						JOIN (SELECT user_id,
									 country_id,
									 COUNT(country_id) AS num_country_appear
								  FROM author.users_userlocation
								 GROUP BY user_id, country_id
								 ORDER BY user_id) AS num_country_id
							ON max_country_appear.country_count= num_country_id.num_country_appear AND
							   num_country_id.user_id = max_country_appear.user_id) AS country_id
		     ON country_id.user_id= up.user_id
FULL OUTER JOIN author.users_registrationcountry AS country
    ON country.id= country_id.country_id
FULL OUTER JOIN author.users_registrationcounty AS county
	ON county.id= up.county_id
FULL OUTER JOIN (
					SELECT DISTINCT user_id,
									STRING_AGG(DISTINCT device_type, ', ') AS device_type
					  FROM author.users_userdevice
					GROUP BY user_id
					ORDER BY user_id) AS dv
	ON up.id= dv.user_id
FULL OUTER JOIN (
				  SELECT user_id,
						 STRING_AGG(DISTINCT platform, ', ') AS platform
					  FROM author.users_usersignin
				  GROUP BY user_id
				  ORDER BY user_id) AS pf
    ON pf.user_id= up.id
FULL OUTER JOIN author.auth_user AS au
    ON up.user_id=au.id
FULL OUTER JOIN (
 				SELECT  user_id,
						count(DISTINCT viewed_by_id) AS unique_profile_view_count,
						count(viewed_by_id) AS total_profile_view_count
				  FROM author.users_userprofileview
				GROUP BY user_id) AS pv
	ON pv.user_id = up.user_id	
FULL OUTER JOIN (
					SELECT viewed_by_id, 
						   COUNT(viewed_by_id) AS profile_view_given
					  FROM author.users_userprofileview
					GROUP by viewed_by_id
					ORDER BY profile_view_given DESC) AS pv_given
			 ON pv_given.viewed_by_id = up.user_id

FULL OUTER JOIN (
					SELECT user_id,
						   count(user_id) AS profile_comments_num
					  FROM author.users_userprofilecomment
					GROUP BY user_id) AS upc
	ON upc.user_id= up.user_id
FULL OUTER JOIN (
					  SELECT artist_id,
						     count(artist_id) AS num_user_likes
					  FROM author.users_userlikes
					GROUP BY artist_id
					ORDER BY artist_id) AS user_likes
			 ON user_likes.artist_id = up.user_id
FULL OUTER JOIN (			 
					 SELECT user_id,
						    COUNT(user_id) AS num_profile_likes_given
					   FROM author.users_userlikes
					 GROUP BY user_id) AS num_user_likes_given
			 ON num_user_likes_given.user_id = up.user_id
			 
FULL OUTER JOIN (SELECT  artist_id,
							count(CASE WHEN category = 'likes' THEN 1 ELSE NULL END) AS song_likes_given,
							count(CASE WHEN category = 'chipin_setup' THEN 1 ELSE NULL END) AS chipin_setup_given,
							count(CASE WHEN category = 'collaboration' THEN 1 ELSE NULL END) AS collaboration_given,
							count(CASE WHEN category = 'comments' THEN 1 ELSE NULL END) AS comments_given,
							count(CASE WHEN category = 'added_playlist' THEN 1 ELSE NULL END) AS added_playlist_given,
							count(CASE WHEN category = 'reportfiled' THEN 1 ELSE NULL END) AS reportfiled_given,
							count(CASE WHEN category = 'stripe_kyc' THEN 1 ELSE NULL END) AS stripe_kyc_given,
							count(CASE WHEN category = 'chipin_payment' THEN 1 ELSE NULL END) AS chipin_payment_given,
							count(CASE WHEN category = 'chipin' THEN 1 ELSE NULL END) AS chipin_given,
							count(CASE WHEN category = 'directmessage' THEN 1 ELSE NULL END) AS directmessage_given,
							count(CASE WHEN category = 'follow' THEN 1 ELSE NULL END) AS following,
							count(CASE WHEN category = 'reportadmin' THEN 1 ELSE NULL END) AS reportadmin_given,
							count(CASE WHEN category = 'reportreceived' THEN 1 ELSE NULL END) AS reportreceived_given,
							count(CASE WHEN category = 'chipin_account' THEN 1 ELSE NULL END) AS chipin_account_given
					  FROM notifications_notifications
					GROUP BY artist_id
					ORDER BY artist_id) AS notf
    ON notf.artist_id = up.user_id
FULL OUTER JOIN ( SELECT user_id,
						count(CASE WHEN category = 'likes' THEN 1 ELSE NULL END) AS song_likes_received,
						count(CASE WHEN category = 'chipin_setup' THEN 1 ELSE NULL END) AS chipin_setup_received,
						count(CASE WHEN category = 'collaboration' THEN 1 ELSE NULL END) AS collaboration_received,
						count(CASE WHEN category = 'comments' THEN 1 ELSE NULL END) AS comments_received,
						count(CASE WHEN category = 'added_playlist' THEN 1 ELSE NULL END) AS added_playlist_received,
						count(CASE WHEN category = 'reportfiled' THEN 1 ELSE NULL END) AS reportfiled_received,
						count(CASE WHEN category = 'stripe_kyc' THEN 1 ELSE NULL END) AS stripe_kyc_received,
						count(CASE WHEN category = 'chipin_payment' THEN 1 ELSE NULL END) AS chipin_payment_received,
						count(CASE WHEN category = 'chipin' THEN 1 ELSE NULL END) AS chipin_received,
						count(CASE WHEN category = 'directmessage' THEN 1 ELSE NULL END) AS directmessage_received,
						count(CASE WHEN category = 'follow' THEN 1 ELSE NULL END) AS followers_received,
						count(CASE WHEN category = 'reportadmin' THEN 1 ELSE NULL END) AS reportadmin_received,
						count(CASE WHEN category = 'reportreceived' THEN 1 ELSE NULL END) AS reportreceived_received,
						count(CASE WHEN category = 'chipin_account' THEN 1 ELSE NULL END) AS chipin_account_received
				  FROM notifications_notifications
				GROUP BY user_id
				ORDER BY user_id) AS notf_received
	ON notf_received.user_id = up.user_id
FULL OUTER JOIN (SELECT made_by_id AS user_id,
					   SUM(amount) AS chipin_amount_paid
				  FROM chipin_transaction
				WHERE status = 'paid' AND
					  made_by_id IS NOT NULL
				GROUP BY made_by_id) AS chip_paid
			  ON up.user_id = chip_paid. user_id
FULL OUTER JOIN (SELECT made_for_id AS user_id,
					   SUM(amount) AS chipin_amount_received
				  FROM chipin_transaction
				WHERE status = 'paid' AND
					  made_for_id IS NOT NULL
				GROUP BY made_for_id) AS chip_received
			  ON up.user_id = chip_received. user_id
FULL OUTER JOIN (SELECT user_id,
						   COUNT(*) AS num_songs_played 
					  FROM history_playhistory
					 WHERE type= 'fullplay' OR 
						   type= 'play'
					GROUP BY user_id) AS num_songs_played
			  ON num_songs_played.user_id= up.user_id			  
FULL OUTER JOIN (SELECT user_id,
					   COUNT(*) AS num_of_collaboration_accepted
				  FROM studio_songs_related.studio_songcollaborator
				 WHERE status= 'accepted'
				 GROUP BY user_id) AS num_of_collaboration_accepted
			  ON num_of_collaboration_accepted.user_id= up.user_id
			  
FULL OUTER JOIN (SELECT created_by_id AS user_id,
						   COUNT(*) AS num_profile_comments_given
					  FROM author.users_userprofilecomment
					GROUP BY created_by_id) AS upc_given
	         ON upc_given.user_id = up.user_id		 
FULL OUTER JOIN ( SELECT user_id,
					   SUM(no_likes) AS total_num_likes,
					   SUM(no_plays) AS total_num_plays,
					   SUM(no_retracks) AS total_num_retracks,
					   SUM(downloads_count) AS total_downloads_count,
					   SUM(retraks_count) AS total_retraks_count,
					   SUM(num_of_collaborators) AS total_num_of_collaborators,
					   SUM(num_comments) AS total_num_comments
				  FROM song_level_master_table
				 GROUP BY user_id) AS user_level_song_info
			 ON user_level_song_info.user_id= up.user_id
WHERE user_level_song_info.user_id IS NOT null
  ORDER BY up.user_id



