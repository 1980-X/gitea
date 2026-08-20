# Gitea compose overlay written (not started)

> Source: local docker-compose.yml, nginx/gitea.conf, .env.example, and host checks on gpu001
> Collected: 2026-08-19
> Published: 2026-08-19

配置已写、栈未启动。docker compose up / start / pull 本轮未做。

enp175s0 LAN address: 192.168.1.84/23. Host port 18600 was idle at write time. Host port 3000 was already LISTEN; gitea application port must not be published.

ROOT_URL: http://192.168.1.84:18600/
DOMAIN: 192.168.1.84
GITEA_HTTP_PORT: 18600

Images pinned: gitea/gitea:1.27.2, postgres:16-alpine, nginx:1.27-alpine.

container_name: gitea-nginx, gitea, gitea-db.
networks.gitea_net.name: gitea_net.

Only gitea-nginx uses ports: 18600:80. gitea expose 3000. gitea-db expose 5432. DISABLE_SSH true. No SSH host mapping.

Bind mounts: /mnt/storage/gitea/gitea -> /data, /mnt/storage/gitea/postgres -> /var/lib/postgresql/data. USER_UID and USER_GID 1000. Directories created and chowned 1000:1000.

nginx/gitea.conf: location / proxy_pass http://gitea:3000; client_max_body_size 512M; proxy_request_buffering off; Host, X-Real-IP, X-Forwarded-For, X-Forwarded-Proto, Upgrade, Connection.

.env holds POSTGRES_PASSWORD (openssl random, mode 600). compose maps GITEA__database__PASSWD to the same variable. INSTALL_LOCK and SECRET_KEY not pre-set; first-run browser wizard.

Overlay files excluded via .git/info/exclude: /docker-compose.yml /nginx/ /.env /.env.example plus existing /wiki/ /raw/.
