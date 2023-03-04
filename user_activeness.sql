CREATE TABLE recent_login AS
SELECT user_id,
       MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) AS last_login_days,
		CASE
		WHEN MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) <=30 THEN 'Less than 1 month'
		WHEN MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) >30 AND MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) <=90 THEN '1-3 months'
		WHEN MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) >90 AND MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) <=182 THEN '4-6 months'
		WHEN MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) >182 AND MIN(EXTRACT(DAY FROM '2022-11-08 05:03:02.711204+00'::timestamp- created)) <=365 THEN '6-12 months'
		ELSE 'more than a year'
	END AS lastlogin_group
FROM author.users_usersignin
GROUP BY user_id
ORDER BY last_login_days 

SELECT recent_login.user_id,
	   recent_login.last_login_days,
	   recent_login.lastlogin_group,
	   user_based_table.profile_view_given,
	   user_based_table.num_profile_comments_given,
	   user_based_table.num_profile_likes_given,
	   user_based_table.notf_song_likes_given AS num_song_likes_given
  FROM recent_login
INNER JOIN user_based_table
  ON recent_login.user_id=user_based_table.user_id
ORDER BY num_profile_likes_given