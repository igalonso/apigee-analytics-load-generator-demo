# Load generation for apigee demo.

## to show:

**API Monitoring**
- Traffic success vs. Errors (all proxies)
- Average response time (enter low rate high peaks) - Introduce latency.
- Traffic by proxy - 5 proxies, different traffic.
- Cache performance - 1 proxy with cache
- 4xx vs, 5xx errors - Introduce client errors vs. backend errors.
- Errors by proxy.
- Target performance - payload size (random)

**API Analytics**
- Device types
- OS
- Agent type
- Browser
- Geo location of API caller
- Latency
- App, API product and developer
- API paths

to deploy:

```bash
sh deploy.sh <APIGEE_USER> <APIGEE_PASS> <APIGEE_ORG> <APIGEE_ENV> <GPROJECT> <APPENGINE> <APIGEE_URL>
```
to delete:

```bash
sh delete-all.sh <APIGEE_USER> <APIGEE_PASS> <APIGEE_ORG> <APIGEE_ENV>
```

## TODO:

- Delete appengine app - so far, promoting it.
- Cache metrics
- delete all - resources hardcoded for gcp account
- multi target
- Use Locust Distributed
- config.json hardcoded target
- tag all resources and delete without hardcoding (delete-all.sh)