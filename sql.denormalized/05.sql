select '#' || t.jsonb_path_query as tag, count(*) as count from (
    select
        data->>'id' as id,
        jsonb_path_query(data, '$.extended_tweet.entities.hashtags[*]')->>'text'
    from tweets_jsonb
    where (
        to_tsvector('english', data->>'text')@@to_tsquery('english', 'coronavirus')
        or to_tsvector('english', data->'extended_tweet'->>'full_text')@@to_tsquery('english', 'coronavirus'))
      and data->>'lang' = 'en'
    union
    select
        data->>'id' as id,
        jsonb_path_query(data, '$.entities.hashtags[*]')->>'text'
    from tweets_jsonb
    where (
        to_tsvector('english', data->>'text')@@to_tsquery('english', 'coronavirus')
        or to_tsvector('english', data->'extended_tweet'->>'full_text')@@to_tsquery('english', 'coronavirus'))
      and data->>'lang' = 'en'
)t
group by t.jsonb_path_query
ORDER BY count DESC, t.jsonb_path_query
limit 1000;
