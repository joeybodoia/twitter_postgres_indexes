create index on tweets_jsonb using gin( (data->'entities'->'hashtags') );

create index on tweets_jsonb using gin( (data->'extended_tweet'->'entities'->'hashtags') );

create index on tweets_jsonb ((data->>'lang'));

create index on tweets_jsonb using gin(to_tsvector('english', data->>'text'));

create index on tweets_jsonb using gin(to_tsvector('english', data->'extended_tweet'->>'full_text'));
