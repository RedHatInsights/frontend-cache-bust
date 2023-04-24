# Frontend Cache Bust
This was inspired by https://github.com/akamai/akamai-docker/blob/master/dockerfiles/purge.Dockerfile
but modified to run in a Red Hat environment 

## Example usage:
```
$ podman build -f cacheBuster.Dockerfile -t akamai-purge .
$ podman run -it -v ~/.edgerc:/opt/app-root/edgerc:z -it akamai-purge invalidate https://somewhere.com/some/cached/file https://somewhere.com/some/other/cached/file
```

## Notes: 
* you have to have your akamai creds in a file that you mount to /opt/app-root/edgerc
* I added the -z in the mount to prevent selinux weirdness but YMMV
* The akamai creds file format is SUPER finicky and needs to be exactly like this but with the hash marks removed:

```
[default]
client_secret = FOOFOOFOOFOOFOOFOOFOOFOOFOOFOOF
host = asomecrazyhostname.com
access_token = BARBARBARBARBARBARBARBARBARB
client_token = DEADBEEFDEADBEEFDEADBEEF
[ccu]
client_secret = FOOFOOFOOFOOFOOFOOFOOFOOFOOFOOF
host = asomecrazyhostname.com
access_token = BARBARBARBARBARBARBARBARBARB
client_token = DEADBEEFDEADBEEFDEADBEEF
```

You can set up creds via directions in this article https://techdocs.akamai.com/developer/docs/set-up-authentication-credentials

