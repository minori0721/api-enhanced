FROM node:lts-alpine

RUN apk add --no-cache tini

ENV NODE_ENV production
USER node

WORKDIR /app

COPY --chown=node:node . ./

# =======================
# 🟢 修改开始 (Modified)
# =======================

# 1. 安装 compression 压缩包
RUN yarn add compression --network-timeout=100000

# 2. 正常安装其他依赖
RUN yarn --network-timeout=100000

# 3. 使用 sed 修改 server.js (开启 Gzip)
# 在第 1 行插入引用
RUN sed -i "1i const compression = require('compression');" server.js
# 在 app = express() 下面插入 app.use
RUN sed -i "/const app = express()/a app.use(compression());" server.js

# =======================
# 🔴 修改结束
# =======================

EXPOSE 3000

CMD [ "/sbin/tini", "--", "node", "app.js" ]
