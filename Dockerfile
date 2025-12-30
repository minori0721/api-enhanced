FROM node:lts-alpine

RUN apk add --no-cache tini

ENV NODE_ENV production
USER node

WORKDIR /app

COPY --chown=node:node . ./

# =======================
# 🟢 修改开始 (Modified)
# =======================


# 1. 正常安装依赖
RUN yarn --network-timeout=100000

# 2. 使用 sed 修改 server.js (开启 Gzip)
# 在 app = express() 下面插入 app.use
RUN sed -i "/const app = express()/a app.use(compression());" server.js

# =======================
# 🔴 修改结束
# =======================

EXPOSE 3000

CMD [ "/sbin/tini", "--", "node", "app.js" ]
