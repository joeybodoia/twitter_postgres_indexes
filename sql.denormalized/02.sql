select '#' || t.jsonb_path_query as tag, count(*) as count from (
    select
        data->>'id',
        jsonb_path_query(data, '$.extended_tweet.entities.hashtags[*]')->>'text'
        from tweets_jsonb
    where data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    union
    select
        data->>'id',
        jsonb_path_query(data, '$.entities.hashtags[*]')->>'text'
        from tweets_jsonb
    where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
)t
group by t.jsonb_path_query
order by count DESC, t.jsonb_path_query
limit 1000;
