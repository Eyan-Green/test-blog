require 'pagy/extras/meilisearch'

MeiliSearch::Rails.configuration = {
  meilisearch_url: 'http://localhost:7700',
  meilisearch_api_key: ENV['MASTER_KEY'],
  timeout: 2,
  max_retries: 1,
  per_environment: true
}
