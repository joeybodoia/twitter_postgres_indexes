select lang, count(*) as count from (
    select distinct data, lang from (
        select
            data->>'id' as data,
            data->>'lang' as lang
            from tweets_jsonb
        where data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
        union
        select
            data->>'id' as data,
            data->>'lang' as lang
            from tweets_jsonb
        where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    )t
)t
group by lang
order by count desc, lang;
