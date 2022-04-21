select (count(*) - 2) as count
from tweets_jsonb
where (
    to_tsvector('english', data->>'text')@@to_tsquery('english', 'coronavirus')
    or to_tsvector('english', data->'extended_tweet'->>'full_text')@@to_tsquery('english', 'coronavirus'))
and data->>'lang' = 'en';
