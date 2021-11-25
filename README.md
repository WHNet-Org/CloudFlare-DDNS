
# CloudFlare DDNS
WARNING: Still a work in progress !!!

A very simple selective DDNS for CloudFlare.
Refer to the examples in the Conf directory to configure the application.

### Features
- Updates on an FQDN basis
- Configurable timer (sleep) between updates
- Doesn't update if the the IP haven't changed to prevent audit logs spam
- Very lightweight
- Docker compatible, using Alpine Linux !

### Environment variables

- ```CloudFlare_Email```
	- Your CloudFlare's account email
- ```CloudFlare_APIKey```
	- Your CloudFlare's account global key (Support for API tokens will be added later)
- ```AppConfig_State```
	- A one line JSON string using the exact same structure as the State.json.example file
- ```AppConfig_Sleep```
  

# Docker

You can use all the above environment variables. You can also bind-mount your ```Env.ps1``` and ```State.json``` files in ```/code/Conf/Env.ps1``` and ```/code/Conf/State.json```.

### Build it yourself !
Build steps are pretty easy. Just remember to change the FROM image at line 1 of the ```Dockerfile``` because we are using our own internal docker image caching.

### Notes
The logging in the container's console output is not working as intended. Although it is readable, it will be fixed soon.
