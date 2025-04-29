FROM nginx:latest

# イメージタグとマニフェストを一致させるために設定
ARG IMAGE_TAG
ENV IMAGE_TAG=${IMAGE_TAG}
