#!/bin/bash

# 定数設定
ACR_NAME="acrtatsukonidemo"
REPOSITORY="servicebus-receiver"
KEEP_LATEST=5

# タイムスタンプでソートされたタグの一覧を取得
all_tags=$(az acr repository show-tags --name "$ACR_NAME" --repository "$REPOSITORY" --orderby time_asc --output tsv)

# タグの総数をカウント
all_tag_count=$(echo "$all_tags" | wc -w)

# 削除すべきタグ数を計算
if [ "$all_tag_count" -le "$KEEP_LATEST" ]; then
    echo "削除するタグはありません。現在のタグ数 ($all_tag_count) が保持数 ($KEEP_LATEST) 以下です。"
    exit 0
fi

delete_tag_count=$((all_tag_count - KEEP_LATEST))
echo "削除対象イメージ数: $delete_tag_count (合計: $all_tag_count, 保持: $KEEP_LATEST)"

# 削除するタグを特定
tags_to_delete=$(echo "$all_tags" | tr ' ' '\n' | head -n "$delete_tag_count")
echo "削除対象のタグ:"
echo "$tags_to_delete"

# 削除を実行
for tag_to_delete in $tags_to_delete; do
    echo "削除中: $REPOSITORY:$tag_to_delete"
    az acr repository delete --name "$ACR_NAME" --image "$REPOSITORY:$tag_to_delete" --yes
done

echo "クリーンアップ完了！"
