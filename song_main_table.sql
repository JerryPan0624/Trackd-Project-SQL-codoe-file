SELECT  DISTINCT mx.song_id,
		s.name,
		s.genre_id,
		dg.tag AS genre_tag,
		dg.tag_type AS genre_tag_type,
		mx.fade,
		mx.volume,
		collab_id.collaboration_id,
		num_collab.num_of_collaborators,
		num_comments.num_comments,
		s.duration,
		s.featured,
		s.colour_scheme,
		s.retraks_count,
		s.downloads_count,
		s.retrak,
		s.stem,
		s.explicit,
		s.lyrics_allowed,
		s.public,
		s.allow_retrak,
		s.allow_stem,
		s.created_at,
		s.user_id,
		s.mixer_on_player,
		s.no_likes,
		s.no_plays,
		s.no_retracks,
		s.state,
		s.uploaded,
		s.source,
		rs.monitor,
		rs.line_input,
		rs.click,
		rs.click_recording,
		rs.volume,
		rs.bpm,
		rs.tap,
		rs.count,
		rs.count_tempo,
		rs.wave_forms,
		rs.allow_collaboration,
		rs.colour_scheme,
		com.comment,
		s_p_view.song_profile_view_count,
		s.description
  FROM studio_songs_related.studio_song AS s
  JOIN studio_songs_related.studio_songmixersettings AS mx
    ON s.id= mx.song_id
  JOIN studio_songs_related.studio_recordsetting AS rs
    ON mx.song_id= rs.song_id
FULL OUTER JOIN studio_songs_related.studio_songcomment AS com
    ON mx.song_id = com.song_id
FULL OUTER JOIN (SELECT song_id,
			            COUNT(song_id) AS song_profile_view_count
  		 		   FROM studio_songs_related.studio_songprofileview
				 GROUP BY song_id) AS s_p_view
   ON mx.song_id= s_p_view.song_id
FULL OUTER JOIN discover_genres AS dg
   ON dg.id= s.genre_id
FULL OUTER JOIN(SELECT song_id,
					   id AS collaboration_id
				  FROM studio_songs_related.studio_songcollaboration) AS collab_id
	ON collab_id.song_id= mx.song_id
FULL OUTER JOIN(SELECT collaboration_id,
					   COUNT(*) AS num_of_collaborators
				  FROM studio_songs_related.studio_songcollaborator
				 WHERE status= 'accepted' 
				GROUP BY collaboration_id) AS num_collab
	ON num_collab.collaboration_id= collab_id.collaboration_id
FULL OUTER JOIN(SELECT song_id,
					   COUNT(*) AS num_comments
				  FROM studio_songs_related.studio_songcomment
				GROUP BY song_id) AS num_comments
	ON num_comments.song_id= mx.song_id
WHERE user_id=9413
 ORDER BY s.no_plays

