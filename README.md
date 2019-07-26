# backup-postman

Automatically backup Postman collections and environments via Postman's Web 
API.

## Installing

1. Clone or download this repository.
1. Execute `./fork.sh` from within the resulting directory.
1. Update `POSTMAN_API_KEY` in `.backup-credentials`.
1. Execute `./backup-postman.sh` manually, or automatically e.g. with 
   `cron(1)`.

### Get API key

1. Navigate to [Postman Integrations Dashboard][postman-api-key].
1. Click _Get API Key_.

[postman-api-key]: https://go.postman.co/integrations/services/pm_pro_api
