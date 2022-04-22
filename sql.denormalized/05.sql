-- normalized query
/*
SELECT
    tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        id_tweets,
        tag
    FROM tweets
    JOIN tweet_tags USING (id_tweets)
    WHERE to_tsvector('english',text)@@to_tsquery('english','coronavirus')
      AND lang='en'
) t
GROUP BY tag
ORDER BY count DESC,tag
LIMIT 1000
;
*/

-- expected output
/*
        tag         | count 
--------------------+-------
 #coronavirus       |     4
 #WearAMask         |     2
 #Coronavirus       |     1
 #cov               |     1
 #covid19           |     1
 #DistanceLearning  |     1
 #Florida           |     1
 #Lockdown          |     1
 #Outbreak          |     1
 #Pandemic          |     1
 #Quarantine        |     1
 #SocialDistanacing |     1
 #StayHome          |     1
 #vaccine           |     1
(14 rows)
*/



/*
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
*/

select '#' || t.hashtag as tag, count(*) as count from (
    select distinct 
        data->>'id' as id,
        jsonb_array_elements(data->'entities'->'hashtags' || COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]'))->>'text' as hashtag
    from tweets_jsonb
    where to_tsvector('english',COALESCE(data->'extended_tweet'->>'full_text',data->>'text')) @@ to_tsquery('english','coronavirus')
      and data->>'lang'='en'
)t
group by t.hashtag
order by count desc, t.hashtag
limit 1000;



