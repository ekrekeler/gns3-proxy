gns3-proxy.py
=============

Proof-of-concept for a Proxy Server for GNS3. The proxy is configured as a regular remote server in the GNS3-GUI, as the GNS3-GUI client does not yet support proxies (https://github.com/GNS3/gns3-gui/issues/2696). Basic idea is to allow the use of central GNS3 server backends for classroom / lab setups, as used, e.g., in the Network Laboratory of Fulda University of Applied Sciences. Students can connect to the proxy and requests will be authenticated, filtered and forwarded to appropriate backend servers. Proxy authentication also circumvents the current lack of multi-user support in GNS3. Without the proxy, due to the single user limitation (see "MULTIPLE USERS ENVIRONMENT" in https://docs.gns3.com/1ON9JBXSeR7Nt2-Qum2o3ZX0GU86BZwlmNSUgvmqNWGY/index.html), users will have to use the same admin credentials for GNS3 to access the backend. Also, requests cannot be filtered and autohrized (e.g., to deny deletion/creation of projects etc.). As GNS3 does not support proxies, several tweaks were necessary to the forked proxy.py project to allow transparent REST and WebSocket passthrough.

![alt text](https://travis-ci.org/abhinavsingh/proxy.py.svg?branch=develop "Build Status")

Features
--------

Inhertited from proxy.py:
- Distributed as a single file module
- No external dependency other than standard Python library
- Support for `http`, `https` and `websockets` request proxy
- Optimized for large file uploads and downloads
- IPv4 and IPv6 support

Changes/enhancements to proxy.py:
- Redirect requests to backend servers (fixed proxing independent from request URL)
- Definition of users (username and password used in GNS3-GUI) for authentication and authorizazion at the proxy, proxy replaces credentials for backend servers
- Definition of allowed clients
- Selection (mapping) of GNS3 backend server and possiblity of load-balancing based on client IP and username (using regexp)
- Filtering of denied requests to server backends (based on username, REST/HTTP method/URL path/headers/body (using regexp)
- Configuration file to allow basic proxy configuration (as for proxy.py) as well as GNS3 backend server, users, clients, mappings and request filter
- Support REST calls (GET requests with body etc.)
- Basic access logging/status monitoring support

Usage
-----

Copy gns3-proxy.py and gns3-proxy-config.ini to a host that has Python >=3.4 installed. Only change necessary in the GNS3 server, is to edit the regular gns3_server.conf (available in the appliance terminal and, e.g., used to change username password etc., see also https://docs.gns3.com/1f6uXq05vukccKdMCHhdki5MXFhV8vcwuGwiRvXMQvM0/index.html) and change the hostname from 0.0.0.0 to the IP address the server should listen on, e.g.:

host = 192.168.1.100

After that, run gns3-proxy.py and configure GNS3-GUI to use this host as a remote GNS3 server. By default, the proxy listens on 127.0.0.1 and TCP port 14080.
