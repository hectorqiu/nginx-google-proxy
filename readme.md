# nginx-google-proxy

nginx 反向代理 google

## 依赖环境
+ docker

## 用法

```
# build
cd path_to_nginx_google_proxy

docker build -t="nginx-google-proxy" .

# run (后台运行)
docker run -d -p 10080:80 nginx-google-proxy

# test (默认监听 0.0.0.0)
curl localhost:10080
```

## more
+ 站点修改 conf/nginx/sites-enabled/
+ 外网访问通过容器 host 机器上的 nginx 反向代理 http://127.0.0.1:10080
+ 外网域名建议加 ssl （letsencrypt）和 auth_basic 限制（被扫描到会被屏蔽）